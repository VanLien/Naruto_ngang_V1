package main

import (
	"bytes"
	"crypto/md5"
	"encoding/base64"
	"encoding/json"
	goerr "errors"
	"fmt"
	"net/http"
	"os"
	"strings"
	"sync"
	"time"
	"tjgame/server_framework/tj/log"

	"github.com/tencentcloud/tencentcloud-sdk-go/tencentcloud/common/errors"

	"github.com/tencentcloud/tencentcloud-sdk-go/tencentcloud/common/profile"

	"github.com/tencentcloud/tencentcloud-sdk-go/tencentcloud/common"
	tms "github.com/tencentcloud/tencentcloud-sdk-go/tencentcloud/tms/v20201229"
)

const customScoreThreshold = 70

var QQCh chan *task

var gmBanUrl string
var timeLimit = 5 * time.Second
var vipLimit = []int{
	3,                         // 0
	5, 9999, 9999, 9999, 9999, // 1-5
}
var accountLimitMap = &sync.Map{}

type respTuple struct {
	resp *tms.TextModerationResponse
	err  error
}

func qq() {
	reqChan := make(chan respTuple)
	reqTimer := time.NewTimer(timeLimit)

	credential := common.NewCredential(
		"AKIDKN99AvqT2cygLjmgIwJOCt3ycAxUF6QY",
		"1mHdMrFNTJs9HnSpwsZz852rPhiTxDTG",
	)
	cpf := profile.NewClientProfile()
	cpf.HttpProfile.Endpoint = "tms.tencentcloudapi.com"
	client, _ := tms.NewClient(credential, "ap-shanghai", cpf)
	//client.WithDebug(true)

NEXT_TASK:
	for t := range QQCh {
		if len(t.words) < 3 || t.vip >= 6 {
			t.qqResult(true, "", "")
			continue NEXT_TASK
		}

		encoded := base64.StdEncoding.EncodeToString([]byte(t.msg))

		request := tms.NewTextModerationRequest()
		request.Content = common.StringPtr(encoded)
		request.DataId = common.StringPtr(fmt.Sprintf("%d", t.id))
		request.User = &tms.User{
			UserId: common.StringPtr(t.account),
		}
		request.BizType = common.StringPtr("kd1")

		startTime := time.Now()
		go func() {
			curID := t.id
			response, err := client.TextModeration(request)
			if t.id != curID {
				log.Warningf("qq return too later %d %d", curID, t.id)
				return
			}
			reqChan <- respTuple{response, err}
		}()

		var response *tms.TextModerationResponse
		var err error
		if !reqTimer.Stop() {
			select {
			case <-reqTimer.C:
			default:
			}
		}

		reqTimer.Reset(timeLimit)
		select {
		case tuple := <-reqChan:
			// resp ok
			response = tuple.resp
			err = tuple.err
		case <-reqTimer.C:
			// timeout
			response = nil
			err = goerr.New("timeout")
			log.Debug(time.Now().Sub(startTime).String())
		}

		if _, ok := err.(*errors.TencentCloudSDKError); ok {
			log.Warningf("qq API error has returned: %s", err)
			t.qqResult(true, "", "")
			continue NEXT_TASK
		}
		if err != nil || response == nil {
			log.Warningf("qq error has returned: %s", err)
			t.qqResult(true, "", "")
			continue NEXT_TASK
		}

		log.Debugf("qq ret %s", response.ToJsonString())

		if *response.Response.Suggestion != "Pass" {
			word := ""
			if len(response.Response.Keywords) > 0 {
				arr := make([]string, 0, len(response.Response.Keywords))
				for _, s := range response.Response.Keywords {
					arr = append(arr, *s)
				}
				word = strings.Join(arr, ", ")
			}

			t.qqResult(false, *response.Response.Label, word)
			banAccount(t)
		} else {
			// 通过qq后台添加词库解决，暂时不自定义阈值

			//for _, detail := range response.Response.DetailResults {
			//	if *detail.Score >= customScoreThreshold {
			//		t.qqResult(false, *detail.Label, "")
			//		banAccount(t)
			//		continue NEXT_TASK
			//	}
			//}

			t.qqResult(true, "", "")
		}
	}
}

func banAccount(t *task) {
	// 只有广告的封号
	if t.err != "Ad" {
		return
	}
	// 高VIP不封
	if t.vip >= len(vipLimit) {
		return
	}
	limit := vipLimit[t.vip]
	if limit > 0 {
		cnt := 0
		if iv, ok := accountLimitMap.Load(t.account); ok {
			cnt = iv.(int)
		}
		// 放过limit次
		if cnt+1 <= limit {
			log.Debugf("account %s role %s server %s level %d vip %d pass %d limit", t.account, t.role, t.servName, t.level, t.vip, cnt+1)
			accountLimitMap.Store(t.account, cnt+1)
			return
		}
		// 封号后计数清空
		accountLimitMap.Delete(t.account)
	}
	t.ban = true

	url := fmt.Sprintf("%s?account=%s", gmBanUrl, t.account)
	auth := fmt.Sprintf("%x", md5.Sum([]byte("crash-gm-admin-asdzxc")))
	data := map[string]string{"account_id": t.account, "auth": auth, "server": t.servName, "role": t.role}
	jsonStr, _ := json.Marshal(data)
	log.Infof("account %s role %s server %s level %d vip %d banned", t.account, t.role, t.servName, t.level, t.vip)

	// async ban with http
	go http.Post(url, "", bytes.NewBuffer(jsonStr))
}

func initQQ() {
	QQCh = make(chan *task, TaskParallel)
	gmBanUrl = fmt.Sprintf("http://%s/gm_cmd/_ban_account", os.Args[1])
	for i := 0; i < TaskParallel; i++ {
		go qq()
	}
}

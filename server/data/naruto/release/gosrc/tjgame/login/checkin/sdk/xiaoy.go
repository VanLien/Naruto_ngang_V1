package sdk

import (
	"crypto/md5"
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"strconv"
	"strings"
	"time"
	"tjgame/server_framework/tj/log"
)

// 小y渠道

type xyResp struct {
	Ret int    `json:"ret"`
	Msg string `json:"message"`
}

type xy struct{}

func (s *xy) Channel() string {
	return "xy51"
}

func (s *xy) FetchUID(sdk SDKVerifier, params map[string]interface{}) (*SDKAccount, error) {
	cfg := gConfigs[sdk.Channel()]
	appid := cfg.AppID
	appkey := cfg.AppKey
	channel := params["channel"].(string) // 小y渠道信息
	token := params["token"].(string)
	openid := params["openid"].(string) // 小y平台用户ID

	now := time.Now()
	t := now.Unix()
	sign := fmt.Sprintf("%s%s%s%s%d", appkey, token, channel, openid, t)
	sign = fmt.Sprintf("%x", md5.Sum([]byte(sign)))
	sign = strings.ToLower(sign)

	resp, err := http.PostForm(cfg.VerifyURL, url.Values{
		"timestamp":    {strconv.Itoa(int(t))},
		"appid":        {appid},
		"channel":      {channel},
		"access_token": {token},
		"openid":       {openid},
		"appKey":       {appkey},
		"sig":          {sign},
	})
	if err != nil {
		log.Error(err)
		return nil, err
	}
	body, err := ioutil.ReadAll(resp.Body)
	resp.Body.Close()
	if err != nil {
		log.Error(err)
		return nil, err
	}
	log.Debugf("%s", body)
	ret := xyResp{}
	err = json.Unmarshal(body, &ret)
	log.Debug(ret)
	if err != nil {
		log.Error(err)
		return nil, err
	}

	if ret.Ret != 0 {
		log.Errorf("%s", body)
		return nil, errors.New(ret.Msg)
	}
	return &SDKAccount{
		Channel:       sdk.Channel(),
		ChannelPrefix: sdk.Channel(),
		Name:          openid,
	}, nil
}

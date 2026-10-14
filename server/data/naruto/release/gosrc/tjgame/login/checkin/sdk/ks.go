package sdk

import (
	"crypto/md5"
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"net/http"
	"strings"
	"time"
	"tjgame/server_framework/tj/log"
)

// 凯撒 tw iOS
type ksConfig struct {
	PID    int    `json:"pid"`     // 渠道sdk编号
	GID    int    `json:"gid"`     // 游戏ID
	KSKey1 string `json:"ks_key1"` // 基础通讯密钥
	KSKey2 string `json:"ks_key2"` // 发货密钥
}

type ksResp struct {
	State int    `json:"state"` // 1-成功，0-失败
	Msg   string `json:"msg"`
	Data  struct {
		UID   string `json:"uid"`
		UName string `json:"uname"`
	} `json:"data"`
}

type ks struct{}

func (s *ks) Channel() string {
	return "ks_i"
}

func (s *ks) FetchUID(sdk SDKVerifier, params map[string]interface{}) (*SDKAccount, error) {
	cfg := gConfigs[sdk.Channel()]
	token := params["token"].(string)

	now := time.Now()
	sign := fmt.Sprintf("%d%d%d%s", cfg.PID, cfg.GID, now.Unix(), cfg.KSKey1)
	sign = fmt.Sprintf("%x", md5.Sum([]byte(sign)))
	sign = strings.ToLower(sign)

	urlq := "pid=%d&gid=%d&time=%d&sign=%s&token=%s"
	urlq = fmt.Sprintf(urlq, cfg.PID, cfg.GID, now.Unix(), sign, token)
	resp, err := http.Get(cfg.VerifyURL + "?" + urlq)
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
	ret := ksResp{}
	err = json.Unmarshal(body, &ret)
	log.Debug(ret)
	if err != nil {
		log.Error(err)
		return nil, err
	}

	if ret.State != 1 {
		log.Errorf("%s", body)
		return nil, errors.New(ret.Msg)
	}
	prefix := sdk.Channel()
	v := strings.Split(sdk.Channel(), "_")
	if len(v) > 0 {
		prefix = v[0]
	}
	return &SDKAccount{
		Channel:       sdk.Channel(),
		ChannelPrefix: prefix,
		Name:          ret.Data.UID,
	}, nil
}

// 凯撒 tw Android
type ksAndroid struct {
	ks
}

func (s *ksAndroid) Channel() string {
	return "ks_a"
}

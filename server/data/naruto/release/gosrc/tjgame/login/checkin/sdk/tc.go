package sdk

import (
	"crypto/sha1"
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"tjgame/server_framework/tj/log"
)

type tc struct {
}

type tcResp struct {
	Ret int    `json:"ret"`
	Msg string `json:"msg"`
}

func (s *tc) Channel() string {
	return "tc"
}

func (s *tc) FetchUID(sdk SDKVerifier, params map[string]interface{}) (*SDKAccount, error) {
	cfg := gConfigs[sdk.Channel()]

	channelID := params["channelId"].(string)
	// 360 关闭注册
	disable := channelID == "13"

	//sdkReq := map[string]interface{}{
	//	"app_id":      cfg.AppID,
	//	"channel_id":  params["channelID"],
	//	"user_id":     params["userId"],
	//	"login_token": params["token"],
	//}

	//"app_id=100&channel_id=1&user_id=77&login_token=1231jsjfjlsf&secret_key=12312313131"
	// need params had order
	urlq := "app_id=%s&channel_id=%s&user_id=%s&login_token=%s"
	urlq = fmt.Sprintf(urlq, cfg.AppID, url.QueryEscape(channelID), url.QueryEscape(params["userId"].(string)), url.QueryEscape(params["token"].(string)))
	sign := "%s&secret_key=%s"
	sign = fmt.Sprintf(sign, urlq, cfg.AppSecret)
	//fmt.Println("sign:", sign)

	sign = fmt.Sprintf("%x", sha1.Sum([]byte(sign)))
	//fmt.Println("sign sha1:", sign)

	urlq = urlq + fmt.Sprintf("&sign=%s", sign)
	//fmt.Println("query url:", cfg.VerifyURL+"?"+urlq)

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

	ret := tcResp{}
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
		Channel:           sdk.Channel(),
		ChannelPrefix:     sdk.Channel(),
		Name:              params["userId"].(string),
		IsDisableRegister: disable,
	}, nil
}

package sdk

import (
	"crypto/sha256"
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"net/http"
	"tjgame/server_framework/tj/log"
)

// 卓动 en

type zdConfig struct {
	CpID      string `json:"cpid"`
	GameID    string `json:"gameid"`
	ChannelID string `json:"channelid"`
	PN        string `json:"pn"`
}

type zd struct {
}

type zdRespState struct {
	Code int    `json:"code"`
	Msg  string `json:"msg"`
}

type zdResp struct {
	State zdRespState `json:"state"`
}

func (s *zd) Channel() string {
	return "zd"
}

func (s *zd) FetchUID(sdk SDKVerifier, params map[string]interface{}) (*SDKAccount, error) {
	cfg := gConfigs[sdk.Channel()]

	token := params["token"].(string)
	uid := params["uid"].(string)

	// {secretkey}{cpid}{gameid}{channelid}{pn}{sessiontoken}{gameuid}
	sign := "%s%s%s%s%s%s%s"
	sign = fmt.Sprintf(sign, cfg.AppSecret, cfg.CpID, cfg.GameID, cfg.ChannelID, cfg.PN, token, uid)
	fmt.Println("sign:", sign)

	sign = fmt.Sprintf("%x", sha256.Sum256([]byte(sign)))
	fmt.Println("sign sha256:", sign)

	// cpid={cpid}&gameid={gameid}&channelid={channelid}&pn={pn}&sessiontoken={sessiontoken}&gameuid={gameuid}&psw={psw}
	urlq := fmt.Sprintf("cpid=%s&gameid=%s&channelid=%s&pn=%s&sessiontoken=%s&gameuid=%s&psw=%s", cfg.CpID, cfg.GameID, cfg.ChannelID, cfg.PN, token, uid, sign)
	fmt.Println("query url:", cfg.VerifyURL+"?"+urlq)

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

	ret := zdResp{}
	err = json.Unmarshal(body, &ret)
	log.Debug(ret)
	if err != nil {
		log.Error(err)
		return nil, err
	}

	if ret.State.Code != 0 {
		log.Errorf("%s", body)
		return nil, errors.New(ret.State.Msg)
	}

	return &SDKAccount{
		Channel:       sdk.Channel(),
		ChannelPrefix: sdk.Channel(),
		Name:          uid,
	}, nil
}

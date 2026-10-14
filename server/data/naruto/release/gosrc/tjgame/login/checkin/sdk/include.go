package sdk

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"tjgame/server_framework/tj/log"
)

const sdkConfPath = "conf/sdk.json"

// 不能出现json的key重复
type SDKConfig struct {
	AppID     string `json:"appid"`
	AppKey    string `json:"appkey"`
	AppSecret string `json:"appsecret"`
	VerifyURL string `json:"verifyURL"`

	zdConfig
	lpConfig
	ksConfig
}

type SDKVerifier interface {
	Channel() string
	FetchUID(SDKVerifier, map[string]interface{}) (*SDKAccount, error)
}

type SDKAccount struct {
	Channel           string // usage for channel sdk implement
	ChannelPrefix     string // usage for construct name
	Name              string
	IsDisableRegister bool
}

func (s *SDKAccount) GetName() string {
	if len(s.ChannelPrefix) == 0 {
		return s.Name
	}
	return fmt.Sprintf("%s_%s", s.ChannelPrefix, s.Name)
}

type SDKVerifierMap map[string]SDKVerifier

func (m SDKVerifierMap) Register(sdk SDKVerifier) {
	m[sdk.Channel()] = sdk
}

var (
	Factory SDKVerifierMap

	gReqCounter uint
	gConfigs    map[string]SDKConfig
)

func initConfig() {
	dir, _ := os.Getwd()
	path := filepath.Join(dir, sdkConfPath)
	content, err := ioutil.ReadFile(path)
	if err != nil {
		log.Panic(err)
	}

	gConfigs = make(map[string]SDKConfig)
	err = json.Unmarshal(content, &gConfigs)
	if err != nil {
		log.Panic(err)
	}

	//log.Debug(m)
}

func init() {
	Factory = make(SDKVerifierMap)

	gReqCounter = 0

	initConfig()
	Factory.Register(&tc{})
	Factory.Register(&tc_beta{})
	Factory.Register(&tc_qd{})
	Factory.Register(&tc_ly1{})
	Factory.Register(&zd{})
	Factory.Register(&lp{})
	Factory.Register(&lp_vn{})
	Factory.Register(&lp_kr{})
	Factory.Register(&lp_en{})
	Factory.Register(&ks{})
	Factory.Register(&ksAndroid{})
	Factory.Register(&xy{})
}

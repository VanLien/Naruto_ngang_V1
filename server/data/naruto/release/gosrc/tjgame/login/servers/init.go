package servers

import (
	"encoding/json"
	"io/ioutil"
	"net"
	"net/http"
	"net/url"
	"strconv"
	"strings"
	"time"
	"tjgame/server_framework/tj/log"

	"login/util"
)

var (
	langKey                   string
	allServersJson            string
	channelServersJson        map[string]string
	channelForwardServersJson map[string]string
	allServersCache           []byte
	allForwardServersJson     string
	allForwardServersCache    []byte

	blackListConfig blackListGlobalConfig
	config          globalConfig
	channelConfig   ChannelConfig
	allGameKeys     []string
	development     bool
	guarderMD5      string
)

type MaintainConfig struct {
	Maintain          bool     `json:"maintain"` // if true, all game is in maintain
	MaintainServers   []string `json:"maintain_servers"`
	MaintainBillboard string   `json:"maintain_billboard"`
}

type globalConfig struct {
	GameKeyPrefix   []string `json:"game_key_prefix"`
	Newest          int      `json:"newest"`
	RegisterDisable []string `json:"register_disable"` // 关闭注册的区服
	RmbReturn       bool     `json:"rmb_return"`       // 钻石返还的开关

	WhiteListEnable    bool                `json:"white_list_enable"` // 是否开启白名单功能
	WhiteListBillboard string              `json:"white_list_billboard"`
	WhiteListAll       []string            `json:"white_list_all"`
	WhiteList          map[string][]string `json:"white_list"`

	CheckIsp    bool   `json:"check_isp"`
	CheckIspUrl string `json:"check_isp_url"`
	ShenheLogin string `json:"shenhe_login"`

	MaintainConfig `json:"-"`
	forwardConfig  `json:"-"`

	maintainServs        map[string]bool
	registerDisableServs map[string]bool
}

type forwardConfig struct {
	ForwardIP    string            `json:"forward_ip"`
	ForwardLANIP string            `json:"forward_lan_ip"`
	LANIPMap     map[string]string `json:"lan_ip_map"`
}

type blackListGlobalConfig struct {
	BlackList    []string `json:"black_list"`
	blackIPAddrs map[string]bool
}

type ChannelConfig struct {
	Channels   map[string][]string `json:"channels"`
	Servers    map[string][]string `json:"servers"`
	GuarderMD5 string              `json:"guarder"`
}

func (conf *ChannelConfig) channels() []string {
	channels := make([]string, 0, len(conf.Channels))
	for channel := range conf.Channels {
		channels = append(channels, channel)
	}
	return channels
}

func (conf *ChannelConfig) filter(channel string, servers []ServerInfo) []ServerInfo {
	tags := make([]string, 0, len(conf.Channels[channel]))
	for _, prefix := range conf.Channels[channel] {
		v := strings.Split(prefix, ".")
		tags = append(tags, v[1])
	}
	infos := make([]ServerInfo, 0, len(servers))
	for _, info := range servers {
		flag := false
		if channels, ok := conf.Servers[info.Key]; ok {
			for _, v := range channels {
				if v == channel {
					flag = true
					break
				}
			}
		} else {
			domain := strings.Split(info.Key, ".")
			for _, tag := range tags {
				if domain[1] == tag {
					flag = true
					break
				}
			}
		}

		if flag {
			infos = append(infos, info)
		}
	}
	return infos
}

func serversHandler(w http.ResponseWriter, req *http.Request) {
	defer util.LogHTTPReq(req, time.Now())

	// forward by iptables
	remoteIP, _, err := net.SplitHostPort(req.RemoteAddr)
	if err == nil && config.ForwardLANIP != "" && config.ForwardLANIP == remoteIP {
		w.Header().Set("Content-Type", "application/json; charset=utf-8")
		w.Header().Set("Content-Encoding", "gzip")
		w.Header().Set("Content-Length", strconv.Itoa(len(allForwardServersCache)))
		w.Write(allForwardServersCache)
		return
	}

	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.Header().Set("Content-Encoding", "gzip")
	w.Header().Set("Content-Length", strconv.Itoa(len(allServersCache)))
	w.Write(allServersCache)
}

func Init(key, lang string, mux *http.ServeMux) {
	langKey = lang
	if strings.Contains(key, "dev") {
		development = true
	}

	OnConfigChanged()

	mux.HandleFunc("/servers", serversHandler)
}

func OnConfigChanged() {
	initGlobalConfig()

	// it will write serv.json
	initServerOpen()

	initChannelConfig()

	// it will read serv.json
	makeServersCache(nil)
}

func GetChannelServersJson(channel string, addr string) string {
	if config.ForwardIP != "" {
		remoteIP, _, err := net.SplitHostPort(addr)
		if err == nil && config.ForwardLANIP == remoteIP {
			return channelForwardServersJson[channel]
		}
	}
	return channelServersJson[channel]
}

func GetAllGameKeys() []string {
	return allGameKeys
}

func IsMaintain() bool {
	return config.Maintain
}

func IsGameMantain(key string) bool {
	return config.maintainServs[key]
}

func MaintainBillboard() string {
	return config.MaintainBillboard
}

func IsGameRegisterDisable(key string) bool {
	return config.registerDisableServs[key]
}

func IsRmbReturn() bool {
	return config.RmbReturn
}

func WhiteListEnable() bool {
	return config.WhiteListEnable
}

func IsInWhiteList(tag string, addr net.Addr) bool {
	if len(config.WhiteListAll) > 0 {
		// ALL 优先级更高
		ip := strings.Split(addr.String(), ":")[0]
		for _, s := range config.WhiteListAll {
			if s == ip {
				return true
			}
		}
	} else {
		if _, ok := config.WhiteList[tag]; !ok {
			return true
		}
		ip := strings.Split(addr.String(), ":")[0]
		for _, s := range config.WhiteList[tag] {
			if s == ip {
				return true
			}
		}
	}
	return false
}

func WhiteListBillboard() string {
	if config.WhiteListBillboard == "" {
		return config.MaintainBillboard
	}
	return config.WhiteListBillboard
}

func ShenheLogin() string {
	return config.ShenheLogin
}

func CheckIsp(ipAddr string, os string) bool {
	if !config.CheckIsp || len(config.CheckIspUrl) <= 0 {
		return false
	}
	ip := strings.Split(ipAddr, ":")[0]
	params := url.Values{}
	params.Set("ipAddress", ip)
	params.Set("os", os)
	params.Set("gameCode", "FKDJXEN")

	Url, _ := url.Parse(config.CheckIspUrl)
	Url.RawQuery = params.Encode()
	urlPath := Url.String()

	resp, err := http.Get(urlPath)
	if err != nil {
		log.Error(err)
		return false
	}
	s, err := ioutil.ReadAll(resp.Body)
	resp.Body.Close()
	ret := struct {
		Code string `json:"code"`
		Tag  int    `json:"tag"`
	}{}
	err = json.Unmarshal(s, &ret)
	if err != nil {
		log.Error(err)
		return false
	}
	if ret.Tag == 1 {
		return true
	}
	return false
}

func OnBlackListConfigChanged() {
	initBlacklistGlobalConfig()
}

func IsInBlackList(addr net.Addr) bool {
	if len(blackListConfig.blackIPAddrs) <= 0 {
		return false
	}
	ip := strings.Split(addr.String(), ":")[0]
	if _, ok := blackListConfig.blackIPAddrs[ip]; ok {
		return true
	}
	return false
}

func GetGuarderMD5() string {
	return guarderMD5
}

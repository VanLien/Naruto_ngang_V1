package servers

import (
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"net"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"time"

	"tjgame/server_framework/tj/log"
	tjutil "tjgame/server_framework/tj/util"
)

const (
	blackGlobalJsonPath    = "blacklist/global.json"
	globalJsonPath         = "conf/global.json"
	gameJsonPath           = "conf/game.json"
	namesJsonPathFormat    = "conf/%s/names.json"
	maintainJsonPathFormat = "conf/%s/maintain.json"
	forwardJsonPathFormat  = "conf/%s/forward.json"

	devServJsonPath    = "conf/serv.json"
	servJsonPathFormat = "conf/%s/serv.json"
)

type ServerInfo struct {
	ID     uint   `json:"id"`
	Name   string `json:"name"`
	Key    string `json:"key"`
	Status int    `json:"status"` // 1-火爆, 2-流畅, 3-维护
	Addr   string `json:"addr"`
}

func getServJsonPath() string {
	if development {
		return devServJsonPath
	}
	return fmt.Sprintf(servJsonPathFormat, langKey)
}

func initChannelConfig() {
	content, err := ioutil.ReadFile("conf/channel.json")
	if err != nil {
		log.Panic("no channel.json", err)
	}
	err = json.Unmarshal(content, &channelConfig)
	if err != nil {
		log.Panic("error", err)
	}

	guarderMD5 = channelConfig.GuarderMD5
}

// addr: 外网IP:外网port
// forwardIP: forward外网IP
func getForwardAddr(addr, forwardIP string, lanMap map[string]string) string {
	host, port, _ := net.SplitHostPort(addr)
	lanIP, ok := lanMap[host]
	if !ok {
		lanIP = host
	}
	nums := strings.Split(lanIP, ".")
	port = nums[3] + port[:len(port)-3]
	return net.JoinHostPort(forwardIP, port)
}

func getForwardServerInfo(servers []ServerInfo) []ServerInfo {
	forwardServers := make([]ServerInfo, 0, len(servers))
	for _, server := range servers {
		addr := server.Addr
		server.Addr = getForwardAddr(server.Addr, config.ForwardIP, config.LANIPMap)
		forwardServers = append(forwardServers, server)
		log.Infof("forward %d %s -> %s", server.ID, addr, server.Addr)
	}
	return forwardServers
}

func makeServersCache(reader io.Reader) {
	if reader == nil {
		path := getServJsonPath()
		dir, _ := os.Getwd()
		path = filepath.Join(dir, path)
		f, err := os.Open(path)
		if err != nil {
			log.Panicf("no serv.json")
		}
		defer f.Close()
		reader = f
	}

	content, err := ioutil.ReadAll(reader)
	if err != nil {
		log.Panic("no servers file", err)
	}

	// verify servers json
	var servers []ServerInfo
	err = json.Unmarshal(content, &servers)
	if err != nil {
		fmt.Println("error:", err)
	}

	content, err = json.Marshal(servers)
	if err != nil {
		log.Panic("servers marshal", err)
	}
	allServersJson = string(content)
	allServersCache, _ = tjutil.GZipCompress(content)

	// gen servers for forward
	if config.ForwardIP != "" {
		forwardServers := getForwardServerInfo(servers)
		content, err := json.Marshal(forwardServers)
		if err != nil {
			log.Panic("forward servers marshal", err)
		}

		allForwardServersJson = string(content)
		allForwardServersCache, _ = tjutil.GZipCompress(content)
	}

	// filter channel servers
	newServers := make(map[string]string)
	newForwardServers := make(map[string]string)
	channels := channelConfig.channels()
	for _, channel := range channels {
		channelServers := channelConfig.filter(channel, servers)
		content, err := json.Marshal(channelServers)
		if err != nil {
			log.Panic("servers marshal", err)
		}
		newServers[channel] = string(content)

		// gen servers for forward
		if config.ForwardIP != "" {
			forwardServers := getForwardServerInfo(channelServers)
			content, err := json.Marshal(forwardServers)
			if err != nil {
				log.Panic("forward servers marshal", err)
			}
			newForwardServers[channel] = string(content)
		}
	}
	channelServersJson = newServers
	channelForwardServersJson = newForwardServers
}

func initGlobalConfig() {
	content, err := ioutil.ReadFile(globalJsonPath)
	if err != nil {
		log.Panic("global.json error:", err)
	}
	data := make(map[string]globalConfig)
	if err = json.Unmarshal(content, &data); err != nil {
		log.Panic(err)
	}
	config = data[langKey]
	registerDisableServs := make(map[string]bool)
	for _, key := range config.RegisterDisable {
		registerDisableServs[key] = true
	}
	config.registerDisableServs = registerDisableServs

	config.MaintainConfig = loadMaintainConfig()
	maintainServs := make(map[string]bool)
	for _, key := range config.MaintainServers {
		maintainServs[key] = true
	}
	config.maintainServs = maintainServs

	config.forwardConfig = loadForwardConfig()
}

func loadMaintainConfig() MaintainConfig {
	content, err := ioutil.ReadFile(fmt.Sprintf(maintainJsonPathFormat, langKey))
	if err != nil {
		log.Panic("maintain.json error", err)
	}
	config := MaintainConfig{}
	if err = json.Unmarshal(content, &config); err != nil {
		log.Panic(err)
	}
	return config
}

func loadForwardConfig() forwardConfig {
	content, err := ioutil.ReadFile(fmt.Sprintf(forwardJsonPathFormat, langKey))
	// forward.json只是额外配置
	if err != nil {
		log.Info("forward.json error", err)
		return forwardConfig{}
	}
	config := forwardConfig{}
	if err = json.Unmarshal(content, &config); err != nil {
		log.Panic(err)
	}
	return config
}

func initBlacklistGlobalConfig() {
	content, err := ioutil.ReadFile(blackGlobalJsonPath)
	if err != nil {
		log.Panic("global.json error:", err)
	}
	blackListConfig := blackListGlobalConfig{}
	if err = json.Unmarshal(content, &blackListConfig); err != nil {
		log.Panic(err)
	}
	blackIPAddrs := make(map[string]bool)
	for _, ip := range blackListConfig.BlackList {
		blackIPAddrs[ip] = true
	}
	blackListConfig.blackIPAddrs = blackIPAddrs
}

type gameinfo struct {
	Addr     string `json:"addr"`
	Key      string `json:"key"`
	OpenDate string `json:"open_date"`

	id       uint
	name     string
	opentime time.Time
}

type gameinfos []gameinfo

func (s gameinfos) Len() int {
	return len(s)
}
func (s gameinfos) Less(i, j int) bool {
	return s[i].opentime.Unix() < s[j].opentime.Unix()
}
func (s gameinfos) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}

func initServerOpen() {
	// load game json
	content, err := ioutil.ReadFile(gameJsonPath)
	if err != nil {
		log.Panic("no game.json", err)
	}
	var data gameinfos
	err = json.Unmarshal(content, &data)
	if err != nil {
		fmt.Println("error:", err)
	}
	games := make(map[string]gameinfo)
	for _, v := range data {
		games[v.Key] = v
	}

	// filter
	names := loadNames()
	infos := make(gameinfos, 0, 64)
	keys := make([]string, 0, 64)
	for _, prefix := range config.GameKeyPrefix {
		for i := 1; i <= 9999; i++ {
			key := fmt.Sprintf("%s.%d", prefix, i)
			if _, ok := games[key]; !ok {
				break
			}
			if _, ok := names[key]; !ok {
				continue
			}
			info := games[key]
			info.id = uint(i)
			info.name = names[key]
			info.opentime, err = tjutil.TimeParse("2006-01-02 15:04:05", info.OpenDate)
			if err != nil {
				panic(err)
			}
			infos = append(infos, info)
			keys = append(keys, key)
		}
	}
	allGameKeys = keys

	if len(infos) == 0 {
		return
	}
	sort.Sort(infos)

	// game.json + cn/names.json --gen--> serv.json
	openNewServer(infos)
	now := tjutil.Now()
	for _, d := range infos {
		if d.opentime.Unix() < now.Unix() {
			continue
		}
		duration := d.opentime.Sub(now)
		time.AfterFunc(duration, func() {
			openNewServer(infos)
		})
		log.Debugf("%s open at %v, delta %v", d.Key, now.Add(duration), duration)
	}
}

func loadNames() map[string]string {
	// read names
	content, err := ioutil.ReadFile(fmt.Sprintf(namesJsonPathFormat, langKey))
	if err != nil {
		log.Panic("names.json error:", err)
	}

	var data []struct {
		ID   int    `json:"id"`
		Key  string `json:"key"`
		Name string `json:"name"`
	}
	err = json.Unmarshal(content, &data)
	if err != nil {
		log.Panic("names content error:", err)
	}

	names := make(map[string]string)
	for _, v := range data {
		names[v.Key] = v.Name
	}
	return names
}

func openNewServer(infos gameinfos) {
	if development {
		log.Info("no open check in development")
		return
	}

	now := tjutil.Now().Unix()
	opened := make(gameinfos, 0, len(infos))
	unopened := make(gameinfos, 0, len(infos))
	for _, d := range infos {
		if d.opentime.Unix() <= now {
			opened = append(opened, d)
		} else {
			unopened = append(unopened, d)
		}
	}
	data := make([]*ServerInfo, 0, len(opened))
	for _, d := range opened {
		info := &ServerInfo{
			ID:     d.id,
			Name:   d.name,
			Key:    d.Key,
			Status: 1, // 1-火爆
			Addr:   d.Addr,
		}
		if IsGameMantain(d.Key) {
			info.Status = 3 // 3-维护
		}
		data = append(data, info)
	}
	for _, prefix := range config.GameKeyPrefix {
		tag := strings.Split(prefix, ".")[1]
		last := make([]*ServerInfo, 0, len(data))
		for _, d := range data {
			domain := strings.Split(d.Key, ".")
			if domain[1] == tag {
				last = append(last, d)
			}
		}
		newest := 1
		if config.Newest > 0 {
			newest = config.Newest
		}
		least := len(last) - newest
		if least < 0 {
			least = 0
		}
		for _, d := range last[least:] {
			if d.Status == 1 {
				d.Status = 2 // 2-流畅
			}
			log.Infof("open new server %s - %s", d.Key, d.Name)
		}
	}

	content, err := json.Marshal(data)
	if err != nil {
		log.Panicf("servers marshal", err)
	}

	path := getServJsonPath()
	if string(content) == allServersJson {
		// avoid write & watch in dead loop
		log.Infof("no new data be write to %s", path)
		return
	}

	if err := ioutil.WriteFile(path, content, 0777); err != nil {
		log.Panicf("write %s faild, error %v", path, err)
	}

	least := 2
	if least > len(unopened) {
		least = len(unopened)
	}
	for _, d := range unopened[:least] {
		log.Infof("next %s open server %s - %s", d.OpenDate, d.Key, d.name)
	}
}

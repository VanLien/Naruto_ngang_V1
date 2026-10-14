package diff

import (
	"encoding/json"
	"io/ioutil"
	"regexp"
	"strings"

	"tjgame/server_framework/tj/log"
)

const testPath = "conf/test.json"

var (
	ips       map[string]struct{}
	ipRegexps []string // only support the regexp which contain *
)

func initTestIPMap() {
	ips = map[string]struct{}{}
	ipRegexps = []string{}

	testConfig := map[string][]string{}
	data, _ := ioutil.ReadFile(testPath)
	err := json.Unmarshal(data, &testConfig)
	if err != nil {
		log.Panic(err)
	}
	iplist, ok := testConfig["iplist"]
	if !ok {
		log.Panic("no iplist")
	}
	for _, ip := range iplist {
		if strings.Contains(ip, "*") {
			ipRegexps = append(ipRegexps, ip)
		} else {
			ips[ip] = struct{}{}
		}
	}
	log.Infof("%s test init ok", testPath)
	log.Debug("ips=", ips)
	log.Debug("ipRegexps=", ipRegexps)
}

func isIPEnableTest(addr string) bool {
	ret := strings.Split(addr, ":")
	ip := ret[0]
	//port, _ := strconv.Atoi(ret[1])
	if _, ok := ips[ip]; ok {
		log.Infof("test %s", ip)
		return true
	}
	for _, reg := range ipRegexps {
		if matched, _ := regexp.MatchString(reg, ip); matched {
			log.Infof("test %s by '%s'", ip, reg)
			return true
		}
	}
	return false
}

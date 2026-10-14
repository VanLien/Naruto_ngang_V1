package diff

import (
	"encoding/json"
	"io/ioutil"
	"regexp"
	"strings"

	"tjgame/server_framework/tj/log"
)

const filterPath = "conf/filter.json"

var (
	filters       map[string]struct{}
	filterRegexps []string // only support the regexp which contain *
)

func initFilterMap() {
	filters = map[string]struct{}{}
	filterRegexps = []string{}

	filterConfig := map[string][]string{}
	data, _ := ioutil.ReadFile(filterPath)
	err := json.Unmarshal(data, &filterConfig)
	if err != nil {
		log.Panic(err)
	}
	for k, arr := range filterConfig {
		enable := false
		for _, lang := range arr {
			if lang == langKey {
				enable = true
				break
			}
		}
		if !enable {
			if strings.Contains(k, "*") {
				filterRegexps = append(filterRegexps, k)
			} else {
				filters[k] = struct{}{}
			}
		}
	}
	log.Infof("%s filter init ok", filterPath)
	log.Debug("filters=", filters)
	log.Debug("filterRegexps=", filterRegexps)
}

func isDisable(filename string) bool {
	if _, ok := filters[filename]; ok {
		log.Infof("filter %s", filename)
		return true
	}
	for _, reg := range filterRegexps {
		if matched, _ := regexp.MatchString(reg, filename); matched {
			log.Infof("filter %s by '%s'", filename, reg)
			return true
		}
	}
	return false
}

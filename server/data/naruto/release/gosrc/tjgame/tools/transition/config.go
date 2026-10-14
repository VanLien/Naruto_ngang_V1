package transition

import (
	"encoding/json"
	"io/ioutil"
	"strings"
)

var mongodbMap = make(map[string]string)

func LoadStorageDefines(filename string) {
	type config struct {
		Services []struct {
			Mongodb string `json:"mongodb"`
			Dbname  string `json:"dbname"`
		} `json:"services"`
	}

	data, err := ioutil.ReadFile(filename)
	if err == nil {
		cfgs := make(map[string]*config)
		err = json.Unmarshal(data, &cfgs)
		if err == nil {
			for key, cfg := range cfgs {
				mongodbMap[key] = cfg.Services[0].Mongodb
			}
		}
	}
}

//"game.cn_qd.30": "gamemerge.cn_qd.1",
//"game.cn_qd.31": "gamemerge.cn_qd.1",
var merged = map[string]string{}

func SlimMerged() {
	vv := make(map[string][]string)
	data, err := ioutil.ReadFile("merged.json")
	if err == nil {
		err = json.Unmarshal(data, &vv)
	}
	if err != nil {
		panic(err)
	}
	merged = make(map[string]string)
	for k, v := range vv {
		for _, val := range v {
			merged[val] = k
		}
	}

	for key, value := range merged {
		key = strings.Replace(key, "game", "storage", 1)
		value = strings.Replace(value, "game", "storage", 1)
		mongodbMap[key] = mongodbMap[value]
	}
}

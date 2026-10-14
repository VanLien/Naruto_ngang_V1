package union

import (
	"fmt"
	"sync/atomic"
	"tjgame/csv"

	tjcsv "tjgame/server_framework/tj/csv"
)

type Config struct {
	LevelMax          int
	LevelSumExp       map[int]int
	FeatureLevel      map[string]int         // {feature: level}
	CSVRoleRedPackets map[int][3]int         // {csvID: (type, val, count)}
	CSVSysRedPackets  map[int]map[int][2]int // {level: {type: (val, count)}}
	LastFubenCsvID    int
}

var config atomic.Value

func GetConfig() *Config {
	return config.Load().(*Config)
}

func LoadConfig() {
	unpack := func(p tjcsv.Map) (int, int) {
		for k, v := range p {
			key := csv.Interface2string(k)
			val := csv.Interface2int(v)
			t := RedPacketGold
			switch key {
			case "gold":
				t = RedPacketGold
			case "rmb":
				t = RedPacketRMB
			case "coin3":
				t = RedPacketCoin3
			default:
				panic(fmt.Sprintf("unknown %v", key))
			}
			return t, val
		}
		return 0, 0
	}

	conf := csv.GetConfig()

	v := &Config{}
	v.LevelMax = 0
	v.LevelSumExp = make(map[int]int)
	v.FeatureLevel = make(map[string]int)
	v.CSVSysRedPackets = make(map[int]map[int][2]int)

	levels := conf.Union.Union_level
	v.LevelMax = len(levels)
	sumexp := 0
	for level := 1; level <= v.LevelMax; level++ {
		cfg := levels[level]
		sumexp += cfg.LevelUpContrib
		v.LevelSumExp[level] = sumexp
		for _, vv := range cfg.OpenFeature {
			feature := vv.(string)
			v.FeatureLevel[feature] = level
		}

		v.CSVSysRedPackets[level] = make(map[int][2]int)
		t, val := unpack(cfg.DailyPacket1)
		v.CSVSysRedPackets[level][t] = [2]int{val, cfg.TotalCount1}
		t, val = unpack(cfg.DailyPacket2)
		v.CSVSysRedPackets[level][t] = [2]int{val, cfg.TotalCount2}
		t, val = unpack(cfg.DailyPacket3)
		v.CSVSysRedPackets[level][t] = [2]int{val, cfg.TotalCount3}
	}

	v.CSVRoleRedPackets = make(map[int][3]int)
	for csvid, cfg := range conf.Union.Red_packet {
		t, val := unpack(cfg.TotalVal)
		v.CSVRoleRedPackets[csvid] = [3]int{t, val, cfg.TotalCount}
	}

	v.LastFubenCsvID = 0
	for id := range conf.Union.Union_fuben {
		if v.LastFubenCsvID < id {
			v.LastFubenCsvID = id
		}
	}

	config.Store(v)
}

func isFeatureOpen(feature string, level int) bool {
	lev := GetConfig().FeatureLevel[feature]
	if lev == 0 { // 未配置的默认就当未开放
		lev = 999999
	}
	return level >= lev
}

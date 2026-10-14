package match

import (
	"sort"
	"sync/atomic"
	"tjgame/csv"
	"tjgame/server_framework/tj/service"
)

var config atomic.Value

func GetConfig() *Config {
	return config.Load().(*Config)
}

func LoadConfig() error {
	cfg := csv.GetConfig()

	crossFishingCfg := cfg.Cross.Fishing.Base[1]

	size := 0
	limit := 0
	crossRedPacketGroupSize := 0
	skyscraperGroupSize := 0
	crossBraveChallengeGroupSize := 0
	crossHorseRaceGroupSize := 0
	crossVolleyballGroupSize := 0
	for _, cfg := range cfg.Common_config {
		if cfg.Name == "huodongBossCrossServerSize" {
			size = int(cfg.Value)
		} else if cfg.Name == "huodongBossCrossServerLimit" {
			limit = int(cfg.Value)
		} else if cfg.Name == "redPacketCrossGroupSize" {
			crossRedPacketGroupSize = int(cfg.Value)
		} else if cfg.Name == "skyscraperCrossGroupSize" {
			skyscraperGroupSize = int(cfg.Value)
		} else if cfg.Name == "braveChallengeGroupSize" {
			crossBraveChallengeGroupSize = int(cfg.Value)
		} else if cfg.Name == "horseRaceGroupSize" {
			crossHorseRaceGroupSize = int(cfg.Value)
		} else if cfg.Name == "volleyballGroupSize" {
			crossVolleyballGroupSize = int(cfg.Value)
		}
		if size != 0 && limit != 0 && crossRedPacketGroupSize != 0 && skyscraperGroupSize != 0 && crossBraveChallengeGroupSize != 0 && crossHorseRaceGroupSize != 0 && crossVolleyballGroupSize != 0 {
			break
		}
	}
	if size == 0 {
		size = 5
	}
	if limit == 0 {
		limit = 8
	}
	if crossRedPacketGroupSize == 0 {
		crossRedPacketGroupSize = 20
	}
	if skyscraperGroupSize == 0 {
		skyscraperGroupSize = 20
	}
	if crossBraveChallengeGroupSize == 0 {
		crossBraveChallengeGroupSize = 50
	}
	if crossHorseRaceGroupSize == 0 {
		crossHorseRaceGroupSize = 20
	}
	if crossVolleyballGroupSize == 0 {
		crossVolleyballGroupSize = 20
	}

	v := &Config{
		CrossFishingConfig: CrossFishingConfig{
			servOpenDays: crossFishingCfg.ServOpenDays,
			GroupSize:    crossFishingCfg.GroupSize,
		},
		HuodongBossGroupSize: size,
		HuodongBossReserve:   limit,

		CrossUnionQAGroupSize:        cfg.Cross.Union_qa.Base[1].GroupSize,
		CrossUnionQAServOpenDays:     cfg.Cross.Union_qa.Base[1].ServOpenDays,
		CrossRedPacketGroupSize:      crossRedPacketGroupSize,
		SkyscraperGroupSize:          skyscraperGroupSize,
		CrossBraveChallengeGroupSize: crossBraveChallengeGroupSize,
		CrossHorseRaceGroupSize:      crossHorseRaceGroupSize,
		CrossVolleyballGroupSize:     crossVolleyballGroupSize,
		CrossShavediceGroupSize:      20, // TODO: 后续修改，没有奖励的排行榜，数量都统一一个字段
	}

	config.Store(v)
	return nil
}

func getServiceMapKeys(data map[string]service.IService, bySOrt bool) []string {
	ret := make([]string, 0, len(data))
	for k := range data {
		ret = append(ret, k)
	}

	if bySOrt {
		ret = sortServices(ret)
	}
	return ret
}

type servList struct {
	servs []string
}

func (sl *servList) Len() int {
	return len(sl.servs)
}

func (sl *servList) Less(i, j int) bool {
	cfg := csv.GetMergeConfig()
	name1, _, num1 := service.SplitServiceName(cfg.GetSrcServKeys(sl.servs[i])[0])
	name2, _, num2 := service.SplitServiceName(cfg.GetSrcServKeys(sl.servs[j])[0])
	if num1 != num2 {
		return num1 < num2
	} else {
		return len(name1) < len(name2)
	}
}

func (sl *servList) Swap(i, j int) {
	sl.servs[i], sl.servs[j] = sl.servs[j], sl.servs[i]
}

func sortServices(services []string) []string {
	sl := &servList{servs: services}
	sort.Sort(sl)
	return sl.servs
}

package yyhuodong

import (
	"sync/atomic"
	"tjgame/csv"
	"tjgame/server_framework/tj/util"
)

var config atomic.Value

func GetConfig() *Config {
	return config.Load().(*Config)
}

func LoadConfig() error {
	return nil
}

// 精灵赛跑
var horseRaceConfig atomic.Value

func GetHorseRaceConfig() *HorseRaceConfig {
	return horseRaceConfig.Load().(*HorseRaceConfig)
}

type HorseRaceConfig struct {
	HorseRaceCardRandom map[int][]util.WeightElement // {group: [Weight]}
	HorseRaceCardGroup  []int                        //  [group]
}

func LoadHorseRaceConifg() error {
	random := make(map[int][]util.WeightElement)
	groupsS := util.NewSet()
	for i, cfg := range csv.GetConfig().Cross.Horse_race.Horse_race_card {
		group := cfg.Group
		groupsS.Add(group)
		if _, ok := random[group]; !ok {
			random[group] = make([]util.WeightElement, 0, 4)
		}
		random[group] = append(random[group], util.WeightInts{i, cfg.Weight})
	}
	groups := make([]int, 0, groupsS.Size())
	groupsS.Range(func(i interface{}) bool {
		groups = append(groups, i.(int))
		return true
	})
	v := &HorseRaceConfig{
		HorseRaceCardRandom: random,
		HorseRaceCardGroup:  groups,
	}

	horseRaceConfig.Store(v)
	return nil
}

func Max(v1, v2 float64) float64 {
	if v1 >= v2 {
		return v1
	}
	return v2
}

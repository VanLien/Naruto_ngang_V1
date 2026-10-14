package hunting

import (
	"sort"
	"sync/atomic"
	"tjgame/csv"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
)

var config atomic.Value

func GetConfig() *Config {
	return config.Load().(*Config)
}

func LoadConfig() error {
	routeMin := map[int]map[int]int{}
	routeMax := map[int]map[int]int{}
	for i, cfg := range csv.GetConfig().Cross.Hunting.Route {
		if versionMin, ok := routeMin[cfg.Version]; ok {
			if min, ok := versionMin[cfg.RouteTag]; ok {
				if i < min {
					versionMin[cfg.RouteTag] = i
				}
			} else {
				versionMin[cfg.RouteTag] = i
			}
			routeMin[cfg.Version] = versionMin
		} else {
			routeMin[cfg.Version] = map[int]int{cfg.RouteTag: i}
		}
		if versionMax, ok := routeMax[cfg.Version]; ok {
			if max, ok := versionMax[cfg.RouteTag]; ok {
				if i > max {
					versionMax[cfg.RouteTag] = i
				}
			} else {
				versionMax[cfg.RouteTag] = i
			}
			routeMax[cfg.Version] = versionMax
		} else {
			routeMax[cfg.Version] = map[int]int{cfg.RouteTag: i}
		}
	}
	random := make(map[int][]util.WeightElement)
	for j, cfgBuff := range csv.GetConfig().Cross.Hunting.Buffs {
		group := cfgBuff.Type
		if _, ok := random[group]; !ok {
			random[group] = []util.WeightElement{}
		}
		random[group] = append(random[group], util.WeightInts{j, cfgBuff.Weight})
	}
	v := &Config{
		HuntingRouteMin:   routeMin,
		HuntingRouteMax:   routeMax,
		HuntingBuffRandom: random,
	}
	config.Store(v)
	return nil
}

// 根据key排序
func SortMap(mp map[int]interface{}) []interface{} {
	var keys = make([]int, 0, len(mp))
	var newList = make([]interface{}, 0, len(mp))
	for k, _ := range mp {
		keys = append(keys, k)
	}
	sort.Ints(keys)
	for key := range keys {
		newList = append(newList, mp[key])
	}
	return newList
}

func Max(v1, v2 float64) float64 {
	if v1 >= v2 {
		return v1
	}
	return v2
}

func Min(v1, v2 float64) float64 {
	if v1 < v2 {
		return v1
	}
	return v2
}

func Game2ArenaService(name string) string {
	return service.Gamemerge2PVPService(name, "arena")
}

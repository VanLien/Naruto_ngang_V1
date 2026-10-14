package csv

import (
	"strconv"
	"strings"
	"sync/atomic"
	"tjgame/server_framework/tj/util"
)

var mergeConfig atomic.Value

type MergeConfig struct {
	DestServMerge map[string][]string
	DestServAreas map[string][]int
	SrcServMerge  map[string]string
	ServCfg       map[string]*Server_merge
}

func GetMergeConfig() *MergeConfig {
	return mergeConfig.Load().(*MergeConfig)
}

func LoadMergeConfig() error {
	cfg := GetConfig()

	v := &MergeConfig{
		DestServMerge: make(map[string][]string),
		DestServAreas: make(map[string][]int),
		SrcServMerge:  make(map[string]string),
		ServCfg:       make(map[string]*Server_merge),
	}

	mergemap := make(map[string][]string)
	var mergesDestL []string
	for _, item := range cfg.Server.Merge {
		if item.RealityMerge != 1 {
			continue
		}

		var srcServers []string
		for _, server := range item.Servers {
			srcServers = append(srcServers, server.(string))
		}
		v.ServCfg[item.DestServer] = item
		mergemap[item.DestServer] = srcServers
		mergesDestL = append(mergesDestL, item.DestServer)
	}

	for _, destServer := range mergesDestL {
		srcs := destServ2SrcServ(mergemap, destServer)
		v.DestServMerge[destServer] = srcs
		var servCounts []int
		for _, src := range srcs {
			v.SrcServMerge[src] = destServer
			ss := strings.Split(src, ".")
			count, _ := strconv.Atoi(ss[len(ss)-1])
			servCounts = append(servCounts, count)
		}
		v.DestServAreas[destServer] = servCounts
	}

	mergeConfig.Store(v)
	return nil
}

func destServ2SrcServ(mergemap map[string][]string, destServer string) (servs []string) {
	srcServ := mergemap[destServer]
	for _, serv := range srcServ {
		if _, ok := mergemap[serv]; ok {
			if serv != destServer {
				servs = append(servs, destServ2SrcServ(mergemap, serv)...)
			} else {
				servs = append(servs, serv)
			}
		} else {
			servs = append(servs, serv)
		}
	}
	return
}

// 原始服名 -> 合服名,没有则返回自身
func (m *MergeConfig) GetMergeServKey(srcKey string) string {
	if mergeKey, ok := m.SrcServMerge[srcKey]; ok {
		return mergeKey
	} else {
		return srcKey
	}
}

// 是否已经被合服
func (m *MergeConfig) IsMerged(srcKey string) bool {
	_, ok := m.SrcServMerge[srcKey]
	return ok
}

// 合服名 -> 原始服名列表
func (m *MergeConfig) GetSrcServKeys(mergeKey string) []string {
	if srcKeyList, ok := m.DestServMerge[mergeKey]; ok {
		return srcKeyList
	} else {
		return []string{mergeKey}
	}
}

// 合服名 -> 原始服名序号列表
func (m *MergeConfig) GetSrcServAreas(mergeKey string) []int {
	if srcvKeyList, ok := m.DestServAreas[mergeKey]; ok {
		return srcvKeyList
	} else {
		ss := strings.Split(mergeKey, ".")
		count, _ := strconv.Atoi(ss[len(ss)-1])
		return []int{count}
	}
}

// 合服名 -> cfg
func (m *MergeConfig) GetServCfg(servKey string) *Server_merge {
	if cfg, ok := m.ServCfg[servKey]; ok {
		return cfg
	} else {
		return nil
	}
}

// 是否是 该合服名 下的 原始服
func (m *MergeConfig) InSubServer(destKey, srcKey string) bool {
	if srcKeyList, ok := m.DestServMerge[destKey]; ok {
		for _, key := range srcKeyList {
			if key == srcKey {
				return true
			}
		}
	}
	return false
}

// 是否是合服名
func (m *MergeConfig) IsServMerged(servKey string) bool {
	if srcvKeyList, ok := m.DestServMerge[servKey]; ok {
		if len(srcvKeyList) > 1 || srcvKeyList[0] != servKey {
			return true
		}
	}
	return false
}

// 过滤同一个合服区的原始服，只保留一个原始服
func (m *MergeConfig) FilterMergeServer(servers []string) []string {
	var filteredServer []string
	mergedKeyMap := make(map[string]bool)
	for _, key := range servers {
		if m.IsMerged(key) {
			mergedKey := m.GetMergeServKey(key)
			if _, ok := mergedKeyMap[mergedKey]; !ok {
				mergedKeyMap[mergedKey] = true
			} else {
				continue
			}
		}
		filteredServer = append(filteredServer, key)
	}
	return filteredServer
}

// 判断给定的服务器key对应的原始服key列表，是否在列表中
func (m *MergeConfig) IsMergeKeyInServers(key string, servers []string) bool {
	srcKeys := m.GetSrcServKeys(key)
	srcKeySet := util.NewSetByStringSlice(srcKeys)
	ServerSet := util.NewSetByStringSlice(servers)
	if srcKeySet.Intersect(ServerSet).Size() > 0 {
		return true
	}
	return false
}

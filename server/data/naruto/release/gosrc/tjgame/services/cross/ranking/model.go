package ranking

import (
	"sort"
	"sync"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/service"
)

type Ranker interface {
	sync.Locker
	// 自动生成
	Group() int
	Status() string
	Servers() []string
	SetServers(v []string)
	GamePlay() string

	// 手动实现
	init(container service.IContainer, manager *Manager)
	onInit(id int, games []string)
	isOver() bool
	resetToday() bool
	onClosed()
	sendRankInfo(crossRankRoleInfo *scheme.RoleRankInfo) error
	getRankInfo(gamePlay string, roleID document.ID, size int) ([]*scheme.RoleRankInfo, int)
	clearRankInfo() []scheme.RoleRankInfo
}

type RankingReturn struct {
	Rank    int                    `codec:"rank"`
	Ranking []*scheme.RoleRankInfo `codec:"ranking"`
}

type rankCacheInfo struct {
	rid       document.ID
	rankData  []int
	timestamp int64
}

type Sortable interface {
	sort.Interface
	AddItem(info rankCacheInfo)
	GetItems() []rankCacheInfo
}

type rankList struct {
	items []rankCacheInfo
}

func (b *rankList) AddItem(info rankCacheInfo) {
	b.items = append(b.items, info)
}

func (b *rankList) GetItems() []rankCacheInfo {
	return b.items
}

func (b *rankList) Len() int {
	return len(b.items)
}

func (b *rankList) Swap(i, j int) {
	b.items[i], b.items[j] = b.items[j], b.items[i]
}

func (b *rankList) specLess(i, j int) bool {
	// 若关键字全部相等，时间戳小靠前， role_id小靠前
	if b.items[i].timestamp != b.items[j].timestamp {
		return b.items[i].timestamp < b.items[j].timestamp
	}
	return b.items[i].rid < b.items[j].rid
}

func (b *rankList) Less(i, j int) bool {
	// 关键字序列都从大到小, 按列表顺序存在优先级
	for idx := range b.items[i].rankData {
		if b.items[i].rankData[idx] != b.items[j].rankData[idx] {
			return b.items[i].rankData[idx] > b.items[j].rankData[idx]
		}
	}
	return b.specLess(i, j)
}

// 降序
type DescendingRankList struct {
	rankList
}

// 升序
type AscendingRankList struct {
	rankList
}

func (b *AscendingRankList) Less(i, j int) bool {
	// 关键字序列都从小到大, 按列表顺序存在优先级
	for idx := range b.items[i].rankData {
		if b.items[i].rankData[idx] != b.items[j].rankData[idx] {
			return b.items[i].rankData[idx] < b.items[j].rankData[idx]
		}
	}
	return b.rankList.specLess(i, j)
}

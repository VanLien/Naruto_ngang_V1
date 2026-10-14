package fishing

import (
	"fmt"
	"tjgame/document"
	"tjgame/document/scheme"
)

type eventToGame struct {
	Model    *DBForGame                    `codec:"model,omitempty"`
	Servers  []string                      `codec:"servers"`
	AllRanks []scheme.CrossFishingRoleItem `codec:"allRanks,omitempty"`
}

type syncModel struct {
	Round string `codec:"round"`
}

type ReqCrossFishingRole struct {
	scheme.CrossFishingRoleInfo
	Point          int `codec:"point"`
	SpecialFishNum int `codec:"special_fish_num"`
}

type RespCrossFishingRankInfo struct {
	Ranks          []scheme.CrossFishingRoleItem `codec:"ranks"`
	Rank           int                           `codec:"rank"`
	Point          int                           `codec:"point"`
	SpecialFishNum int                           `codec:"special_fish_num"`
}

type DBForGame struct {
	Servers []string `codec:"servers"`
	Date    int      `codec:"date"`
	Round   string   `codec:"round"`
	Group   int      `codec:"group"`
}

type rankItem struct {
	id    document.ID
	items map[string]int
}

type ranks struct {
	items []rankItem
	keys  [][]string
}

func (r *ranks) Len() int {
	return len(r.items)
}

func (r *ranks) Less(i, j int) bool {
	for _, keyItem := range r.keys {
		key := keyItem[0]
		if r.items[i].items[key] == r.items[j].items[key] {
			continue
		}
		keyType := keyItem[1]
		switch keyType {
		case "desc":
			return r.items[i].items[key] > r.items[j].items[key]
		case "asc":
			return r.items[i].items[key] < r.items[j].items[key]
		default:
			panic(fmt.Sprintf("keyType %s error", keyType))
		}
	}
	return true
}

func (r *ranks) Swap(i, j int) {
	r.items[i], r.items[j] = r.items[j], r.items[i]
}

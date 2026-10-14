package unionqa

import (
	"fmt"
	"tjgame/document"
	"tjgame/document/scheme"
)

type eventToGame struct {
	Model      *DBForGame                         `codec:"model,omitempty"`
	RoleRanks  []scheme.CrossUnionQARoleRankItem  `codec:"role_ranks,omitempty"`
	UnionRanks []scheme.CrossUnionQAUnionRankItem `codec:"union_ranks,omitempty"`
}

type syncModel struct {
	Round string `codec:"round"`
}

type ReqCrossUnionQA struct {
	Role    scheme.CrossUnionQARoleInfo  `codec:"role"`
	Union   scheme.CrossUnionQAUnionInfo `codec:"union"`
	Score   int                          `codec:"score"`
	WeekDay int                          `codec:"weekday"`
}

type RespCrossUnionQARankInfo struct {
	RoleRanks   []scheme.CrossUnionQARoleRankItem  `codec:"role_ranks"`
	UnionRanks  []scheme.CrossUnionQAUnionRankItem `codec:"union_ranks"`
	MyUnionRank scheme.CrossUnionQAMyRankItem      `codec:"my_union_rank"`
	MyRank      scheme.CrossUnionQAMyRankItem      `codec:"my_rank"`
}

type RespCrossUnionQAMain struct {
	RespCrossUnionQARankInfo
	Servers []string `codec:"servers"`
	Round   string   `codec:"round"`
}

type DBForGame struct {
	Servers []string `codec:"servers"`
	Date    int      `codec:"date"`
	Round   string   `codec:"round"`
	Group   int      `codec:"group"`
	Key     string   `codec:"key"`
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

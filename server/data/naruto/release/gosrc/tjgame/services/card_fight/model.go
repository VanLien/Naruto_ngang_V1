package card_fight

import (
	"fmt"
	"tjgame/document"
	"tjgame/document/scheme"
)

type RespCardFightRank struct {
	Ranks []scheme.CardFightRankItem `codec:"ranks"`
	Rank  int                        `codec:"rank"`
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

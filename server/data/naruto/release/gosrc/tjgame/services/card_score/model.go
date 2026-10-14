package card_score

import (
	"fmt"
	"tjgame/document"
)

type Config struct {
	MarkIDToRarity map[int]int
}

type RespCardScore struct {
	Score     float64 `codec:"score"`
	LastScore float64 `codec:"last_score"`
	MyScore   int     `codec:"my_score"`
}

type rankItem struct {
	id    document.Integer
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

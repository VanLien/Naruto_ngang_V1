package card_comment

import (
	"fmt"
	"tjgame/document"
)

type Config struct {
	CardCommentHotNum int
}

type ReqRole struct {
	RoleID  document.ID `codec:"role_db_id"`
	GameKey string      `codec:"game_key"`
	Name    string      `codec:"name"`
	Logo    int         `codec:"logo"`
	Frame   int         `codec:"frame"`
	Level   int         `codec:"level"`
	Vip     int         `codec:"vip"`
}

type ReqList struct {
	Role   ReqRole `codec:"role"`
	MarkID int     `codec:"markID"`
	Offset int     `codec:"offset"`
	Size   int     `codec:"size"`
}

type RespList struct {
	Hot     []*CardComment          `codec:"hot"`
	My      []*CardComment          `codec:"my"`
	New     []*CardComment          `codec:"new"`
	Roles   map[document.ID]ReqRole `codec:"roles"`
	Like    map[document.ID]bool    `codec:"like"`
	Dislike map[document.ID]bool    `codec:"dislike"`
}

type RespGMList struct {
	Hot       []*CardComment          `codec:"hot"`
	New       []*CardComment          `codec:"new"`
	Roles     map[document.ID]ReqRole `codec:"roles"`
	TotalPage int                     `codec:"totalPage"`
}

type RespEvaluateHistory struct {
	CommentLike    map[document.ID]float64 `codec:"comment_like,omitempty"`
	CommentDislike map[document.ID]float64 `codec:"comment_dislike,omitempty"`
}

type rankItem struct {
	id    int
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

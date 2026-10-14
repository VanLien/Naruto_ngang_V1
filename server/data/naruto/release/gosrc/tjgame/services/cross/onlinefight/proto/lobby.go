package proto

import (
	"tjgame/document"
)

type Player struct {
	ID document.ID `codec:"id"`
	Competitor

	Winstreak     bool   `codec:"winstreak"`  // 连胜
	Failstreak    bool   `codec:"failstreak"` // 连负
	FightingPoint int    `codec:"fighting_point"`
	Time          int64  `codec:"time"`
	Timeout       int    `codec:"timeout"` // second
	CrossKey      string `codec:"cross_key"`
	Cards         []int  `codec:"cards"`
}

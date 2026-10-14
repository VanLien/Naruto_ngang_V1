package ta

import (
	"tjgame/csv"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
)

var cards *util.Set

// 初始化关键卡牌id
func InitCoreCards() {
	cards = util.NewSet()
	for id, cfg := range csv.GetConfig().Cards {
		unit := csv.GetConfig().Unit[cfg.UnitID]
		if unit.Rarity >= 3 { // 大于等于S资质
			cards.Add(id)
		}
	}
	log.Debugf("Core Cards Count %d", cards.Size())
}

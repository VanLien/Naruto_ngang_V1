package craft

import (
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
	gamecards "tjgame/services/game/cards"
)

type fixattr map[string]map[int]float64 // {attr: {40: float64}}

func (f fixattr) amend(percents map[string]float64, attrs map[string]float64) map[string]float64 {
	if percents == nil {
		return attrs
	}

	ret := make(map[string]float64)
	for attr, value := range attrs {
		percent := percents[attr]
		if percent > 0 {
			rate := f[attr][int(percent*100)]
			if rate > 0 {
				ret[attr] = value * rate
			} else {
				ret[attr] = value
			}
		} else {
			ret[attr] = value
		}
	}
	return ret
}

var lastdate int // 配表内最后一个日期
var dayFixAttr map[int]fixattr

func initFix() {
	gamecards.InitBattleCardHaloConfig()

	dayFixAttr = make(map[int]fixattr)
	for _, cfg := range csv.GetConfig().Cross.Craft.Halo_fix {
		fix := make(fixattr)

		fix["hp"] = make(map[int]float64)
		fix["hp"][40] = (cfg.Hp1 + 1) / 1.4
		fix["hp"][35] = (cfg.Hp2 + 1) / 1.35
		fix["hp"][30] = (cfg.Hp3 + 1) / 1.3
		fix["hp"][25] = (cfg.Hp4 + 1) / 1.25
		fix["hp"][20] = (cfg.Hp5 + 1) / 1.2
		fix["hp"][15] = (cfg.Hp6 + 1) / 1.15
		fix["hp"][10] = (cfg.Hp7 + 1) / 1.1

		fix["damage"] = make(map[int]float64)
		fix["damage"][40] = (cfg.Damage1 + 1) / 1.4
		fix["damage"][35] = (cfg.Damage2 + 1) / 1.35
		fix["damage"][30] = (cfg.Damage3 + 1) / 1.3
		fix["damage"][25] = (cfg.Damage4 + 1) / 1.25
		fix["damage"][20] = (cfg.Damage5 + 1) / 1.2
		fix["damage"][15] = (cfg.Damage6 + 1) / 1.15
		fix["damage"][10] = (cfg.Damage7 + 1) / 1.1

		fix["specialDamage"] = fix["damage"]

		dayFixAttr[cfg.Date] = fix
		if cfg.Date > lastdate {
			lastdate = cfg.Date
		}
	}
	log.Infof("fix attr last date %d", lastdate)
}

func getFixAndHaloPercents(ids []document.ID, cardAttrs map[document.ID]*scheme.CardBattleModel) (fixattr, map[string]float64) {
	now := util.Todaydate2int()
	fix := dayFixAttr[now]
	if fix == nil && now > lastdate {
		fix = dayFixAttr[lastdate]
	}
	if fix == nil {
		return nil, nil
	}

	cards := make([]int, 0, len(ids))
	for _, id := range ids {
		if id != "" {
			cards = append(cards, cardAttrs[id].CardId)
		}
	}

	_, percents := gamecards.MakeBattleCardHalo(cards, 0)
	return fix, percents
}

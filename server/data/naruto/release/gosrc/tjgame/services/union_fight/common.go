package union_fight

import (
	"io/ioutil"
	"sync/atomic"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
	"tjgame/services/game"
)

var config atomic.Value

func GetConfig() *Config {
	return config.Load().(*Config)
}

func LoadConfig() error {
	cfg := csv.GetConfig()

	v := &Config{
		BetRateFix:      float64(cfg.Union_fight.Base[1].BetRateFix),
		MinBetRate:      float64(cfg.Union_fight.Base[1].MinBetRate),
		MaxBetWin:       cfg.Union_fight.Base[1].MaxBetWin,
		BattleWinPoint:  cfg.Union_fight.Base[1].WinPoint,
		BattleFailPoint: cfg.Union_fight.Base[1].FailPoint,
	}

	for _, item := range cfg.Common_config {
		if item.Name == "unionFightLastWinRolePoint" {
			v.LastWinRolePoint = int(item.Value)
		}
	}

	// 战斗修正
	v.BattleFixMap = make(map[int]map[string]float64)
	for idx := range cfg.Union_fight.Battle_fix {
		if _, ok := v.BattleFixMap[idx]; !ok {
			v.BattleFixMap[idx] = make(map[string]float64)
		}
		csv.FieldRangeValues(cfg.Union_fight.Battle_fix[idx], []string{"AttrType%d", "AttrFix%d"}, func(values []interface{}) bool {
			attrType := values[0].(int)
			if attrType == -1 {
				return false
			}
			v.BattleFixMap[idx][game.CardAttrDefs[attrType]] = values[1].(float64)
			return true
		})
	}

	v.PointFix = make(map[int]int)
	for idx := range cfg.Union_fight.Point_fix {
		v.PointFix[idx] = cfg.Union_fight.Point_fix[idx].PointFix
	}

	config.Store(v)
	return nil
}

func CreateBattlePlayRecord(model interface{}) {
	data, err := util.MsgPack(model)
	if err != nil {
		log.Info(err)
	}
	s := struct {
		_struct struct{} `codec:",toarray"`
		Name    string
		Model   []byte
	}{
		Name:  "union_fight",
		Model: data,
	}

	f, err := util.MsgPack(s)
	if err != nil {
		log.Info(err)
	}
	err = ioutil.WriteFile("union_fight.play", f, 0644)
	if err != nil {
		log.Info(err)
	}

}

func sortUnionRoleIDs(m map[document.ID][]document.ID) []document.ID {
	var ret []document.ID
	for key, _ := range m {
		ret = append(ret, key)
	}
	for i := 0; i < len(ret); i++ {
		for j := i + 1; j < len(ret); j++ {
			if len(m[ret[i]]) < len(m[ret[j]]) {
				ret[i], ret[j] = ret[j], ret[i]
			}
		}
	}
	return ret
}

func calcHpPercent(data map[document.ID][2]float64) (float64, float64) {
	num := 0
	sum := 0.0
	for _, item := range data {
		num++
		sum += item[0]
	}

	return sum, sum / float64(num)
}

type rankitem struct {
	id    document.ID
	items map[string]int
}

type ranks struct {
	items []rankitem
	keys  []string
}

func (r *ranks) Len() int {
	return len(r.items)
}

func (r *ranks) Less(i, j int) bool {
	for _, key := range r.keys {
		if r.items[i].items[key] == r.items[j].items[key] {
			continue
		}
		return r.items[i].items[key] > r.items[j].items[key]
	}
	return true
}

func (r *ranks) Swap(i, j int) {
	r.items[i], r.items[j] = r.items[j], r.items[i]
}

func refreshTop8(top8IDs []document.ID, old []scheme.UnionFightUnionRankItem) []scheme.UnionFightUnionRankItem {
	ret := []scheme.UnionFightUnionRankItem{}
	tmp := make(map[document.ID]scheme.UnionFightUnionRankItem)
	top8Check := make(map[document.ID]bool)
	cfg := GetConfig()

	for _, v := range top8IDs {
		top8Check[v] = true
	}

	for _, v := range old {
		if _, ok := top8Check[v.UnionID]; ok {
			tmp[v.UnionID] = v
			continue
		}
		ret = append(ret, v)
	}

	top8Ret := []scheme.UnionFightUnionRankItem{}
	for _, v := range top8IDs {
		top8Ret = append(top8Ret, tmp[v])
	}

	ret = append(top8Ret, ret...)

	for idx := range ret {
		ret[idx].Rank = idx + 1
		// top8 积分修正
		if _, ok := top8Check[ret[idx].UnionID]; !ok {
			continue
		}
		if pointFix, ok := cfg.PointFix[ret[idx].Rank]; ok {
			ret[idx].Point += pointFix
		}
	}

	return ret

}

func newUnionFightTop8VSUnionInfo(union *scheme.UnionFightUnionInfo) *scheme.UnionFightTop8VSUnionInfo {
	return &scheme.UnionFightTop8VSUnionInfo{
		UnionID:    union.UnionID,
		UnionName:  union.Name,
		UnionLogo:  union.Logo,
		UnionLevel: union.Level,
		UnionSigns: union.SignNum,
		UnionLives: union.SignNum - union.DeadNum,
	}
}

func float64IsEqual(a, b float64) bool {
	return (a-b) < EPSILON && (b-a) < EPSILON
}

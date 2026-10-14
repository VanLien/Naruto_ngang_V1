/*
 * @Time     : 2019/10/18 10:49
 * @Author   : cancan
 * @File     : common.go
 * @Function :
 */

package clone

import (
	"crypto/md5"
	"fmt"
	"sync/atomic"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/document/schemeutil"
	"tjgame/server_framework/tj/util"
	"tjgame/services/game"
)

var config atomic.Value

func GetConfig() *Config {
	return config.Load().(*Config)
}

func LoadConfig() error {
	csvConfig := csv.GetConfig()
	v := &Config{}

	// 奖励权重
	awardWeights := make([]util.WeightElement, 0, len(csvConfig.Clone.Award))
	for idx, v := range csvConfig.Clone.Award {
		awardWeights = append(awardWeights, util.WeightInts{idx, v.RandWeight})
	}
	v.AwardRandom = util.NewWeightRandom(awardWeights)

	// 稀有度随机
	rarityWeights := make([]util.WeightElement, 0, len(csvConfig.Clone.Rarity))
	for idx, v := range csvConfig.Clone.Rarity {
		rarityWeights = append(rarityWeights, util.WeightInts{idx, v.Weight})
	}
	v.RarityRandom = util.NewWeightRandom(rarityWeights)

	// 战斗修正
	idxs := [3]int{1, 2, 3}
	v.BattleFixSlice = make([]BattleFix, 0, 3)
	for _, idx := range idxs {
		cfg := csvConfig.Clone.Battle[idx]
		bf := BattleFix{
			AttrFix:       make(map[string]float64),
			SkillLevelFix: cfg.SkillLevelFix,
		}
		csv.FieldRangeValues(cfg, []string{"AttrType%d", "AttrFix%d"}, func(values []interface{}) bool {
			attrType := values[0].(int)
			if attrType == -1 {
				return false
			}
			bf.AttrFix[game.CardAttrDefs[attrType]] = values[1].(float64)
			return true
		})
		v.BattleFixSlice = append(v.BattleFixSlice, bf)
	}

	// 机器人修正
	v.NatureRobotMap = make(map[int]NatureRobot)
	for idx, cfg := range csvConfig.Clone.Nature {
		cardIDs := []int{}
		csv.FieldRangeValues(cfg, []string{"Robot%d"}, func(values []interface{}) bool {
			cardID := values[0].(int)
			if cardID > 0 {
				cardIDs = append(cardIDs, cardID)
			}
			return true
		})
		if cfg.Fix > 0 {
			attrFix := make(map[string]float64)
			for _, v := range RobotFixAttr {
				attrFix[v] = cfg.Fix
			}
			v.NatureRobotMap[idx] = NatureRobot{
				LevelFix: cfg.Fix,
				AttrFix:  attrFix,
				CardIDs:  cardIDs,
			}
		}
	}

	// 机器人相关时间点控制
	for _, cfg := range csvConfig.Common_config {
		switch cfg.Name {
		case "cloneRobotTime":
			v.CloneRobotTime = int(cfg.Value)
		case "cloneRobotRefreshTime":
			v.CloneRobotRefreshTime = int(cfg.Value)
		case "cloneCanKickTime":
			v.CLoneCanKickTime = int(cfg.Value)
		case "cloneCanKickFinishNum":
			v.CloneCanKickFinishNum = int(cfg.Value)

		}
	}

	v.CardMarkDevelopMap = make(map[[3]int]int)
	for _, cfg := range csvConfig.Cards {
		v.CardMarkDevelopMap[[3]int{cfg.CardMarkID, cfg.Branch, cfg.Develop}] = cfg.ID
	}

	config.Store(v)

	return nil
}

func CreateBattleID(roleID document.ID) string {
	data := []byte(fmt.Sprintf("%v%v", roleID.String(), util.NowTime()))
	has := md5.Sum(data)
	return fmt.Sprintf("%x", has)
}

func InCDTime(old int, cd int) bool {
	year := int(old / 10000)
	month := int(old % 10000 / 100)
	day := int(old % 100)
	oldTime := util.Date(year, month, day, 0, 0, 0, 0)

	now := util.Perioddate2int(CloneRefreshTime, util.Now())

	year = int(now / 10000)
	month = int(now % 10000 / 100)
	day = int(now % 100)
	nowTime := util.Date(year, month, day, 0, 0, 0, 0)

	if nowTime.Sub(oldTime).Minutes()/(60*24) < float64(cd) {
		return true
	} else {
		return false
	}
}

// 抽宝箱 csvID clone.monster.ID
func BoxDraw(csvID int) *BattleAward {
	config := csv.GetConfig()
	cardID := config.Clone.Monster[csvID].CardID
	rndIdx := GetConfig().AwardRandom.GetRandom().(util.WeightInts)[0]
	awardCfg := config.Clone.Award[rndIdx]
	return &BattleAward{
		FragID:  config.Cards[cardID].FragID,
		FragNum: awardCfg.DropNum,
		DropLib: awardCfg.DropLib.ToIntSlice(),
	}
}

func GetCloneNextRefreshTime() int {
	now := util.Perioddate2int(CloneRefreshTime, util.Now())
	year := int(now / 10000)
	month := int(now % 10000 / 100)
	day := int(now % 100)
	t := util.Date(year, month, day, CloneRefreshTime, 0, 0, 0)
	t = t.Add(util.OneDay)
	return int(t.Unix())
}

// Deprecated: object new lock method
func duplicate(room *scheme.CloneRoom) *scheme.CloneRoom {
	ret := *room

	ret.Places = make(map[document.Integer]*scheme.CloneRoomPlace)
	for k, v := range room.Places {
		place := *v
		place.BattleDeploy = schemeutil.CopyCards(v.BattleDeploy)

		card := *v.Card
		card.Skills = schemeutil.CopySkills(v.Card.Skills)
		card.PassiveSkills = schemeutil.CopySkills(v.Card.PassiveSkills)
		card.Attrs = schemeutil.CopyAttrs(v.Card.Attrs)
		card.Attrs2 = schemeutil.CopyAttrs(v.Card.Attrs2)
		place.Card = &card

		ret.Places[k] = &place
	}

	return &ret
}

func card2twinCardID(markID, branch, develop int) int {
	switch branch {
	case 1:
		branch = 2
	case 2:
		branch = 1
	default:
		panic(fmt.Sprintf("cardID %d brach %d develop %d error", markID, branch, develop))
	}

	return GetConfig().CardMarkDevelopMap[[3]int{markID, branch, develop}]
}

func makeTwinCardBattleModel(markID, branch, develop, skillLevel int, base *scheme.CardBattleModel) *scheme.CardBattleModel {
	nextCardID := card2twinCardID(markID, branch, develop)
	ret := &scheme.CardBattleModel{
		ID:            base.ID,
		CardId:        nextCardID,
		SkinId:        0,
		Level:         base.Level,
		FightingPoint: 0,
		Star:          base.Star,
		Advance:       base.Advance,
		Attrs:         base.Attrs,
		Attrs2:        base.Attrs2,
	}
	ret.Skills = make(map[document.Integer]int)
	for _, v := range csv.GetConfig().Cards[nextCardID].SkillList {
		ret.Skills[document.Integer(v.(int64))] = skillLevel
	}
	ret.PassiveSkills = make(map[document.Integer]int)

	return ret
}

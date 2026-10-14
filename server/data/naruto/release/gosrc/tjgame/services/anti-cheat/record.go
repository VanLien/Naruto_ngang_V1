package anti_cheat

import (
	"fmt"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
)

type BattleType int

const (
	Arena           BattleType = 1
	Craft           BattleType = 2
	UnionFight      BattleType = 3
	CrossCraft      BattleType = 4
	Endless         BattleType = 5
	CrossMineBoss   BattleType = 6
	BraveChallenge  BattleType = 7
	Hunting         BattleType = 8
	SummerChallenge BattleType = 9
	CrossMine       BattleType = 10
	CrossArena      BattleType = 11
	CrossUnionFight BattleType = 12
	Gate            BattleType = 999
)

var types = map[BattleType]string{
	Arena:           "arena",
	Craft:           "craft",
	CrossCraft:      "crosscraft",
	UnionFight:      "unionfight",
	Endless:         "endless",
	CrossMineBoss:   "crossmineboss",
	BraveChallenge:  "bravechallenge",
	Hunting:         "hunting",
	SummerChallenge: "summerchallenge",
	CrossMine:       "crossmine",
	CrossArena:      "crossarena",
	CrossUnionFight: "crossunionfight",
	Gate:            "gate",
}

type Record struct {
	Type       BattleType
	PlayRecord []byte

	Result  string
	Point1  int
	Point2  int
	States  map[document.ID][2]float64
	Damages map[document.Integer]int

	id   int64
	done chan struct{}

	servKey string
	playID  document.ID
}

func (r *Record) Wait() {
	if r.done == nil {
		return
	}
	<-r.done
	r.done = nil
}

func (r *Record) Done() {
	close(r.done)
}

func (r *Record) String() string {
	return fmt.Sprintf("Record %s:%v Result %s", r.servKey, r.playID, r.Result)
}

func (r *Record) forceResult() (err error) {
	var forceResultHandler ErrorForceResultHandler
	switch r.Type {
	case Craft:
		var play scheme.CraftPlayRecord
		if err = util.MsgUnpack(r.PlayRecord, &play); err == nil {
			forceResultHandler = &simpleForceResultHandler{
				Cards:            play.Cards,
				CardAttrs:        play.CardAttrs,
				DefenceCards:     play.DefenceCards,
				DefenceCardAttrs: play.DefenceCardAttrs,
			}
		}
	case CrossCraft:
		var play scheme.CrossCraftPlayRecord
		if err = util.MsgUnpack(r.PlayRecord, &play); err == nil {
			forceResultHandler = &simpleForceResultHandler{
				Cards:            play.Cards,
				CardAttrs:        play.CardAttrs,
				DefenceCards:     play.DefenceCards,
				DefenceCardAttrs: play.DefenceCardAttrs,
			}
		}
	case UnionFight:
		var play scheme.UnionFightPlayRecord
		if err = util.MsgUnpack(r.PlayRecord, &play); err == nil {
			forceResultHandler = &simpleUnionFightForceResultHandler{
				simpleForceResultHandler: simpleForceResultHandler{
					Cards:            play.Cards,
					CardAttrs:        play.CardAttrs,
					DefenceCards:     play.DefenceCards,
					DefenceCardAttrs: play.DefenceCardAttrs,
				},
				CardStates:        play.CardStates,
				DefenceCardStates: play.DefenceCardStates,
			}
		}
	case CrossUnionFight:
		var play scheme.CrossUnionFightPlayRecord
		if err = util.MsgUnpack(r.PlayRecord, &play); err == nil {
			forceResultHandler = &simpleUnionFightForceResultHandler{
				simpleForceResultHandler: simpleForceResultHandler{
					Cards:            play.Cards,
					CardAttrs:        play.CardAttrs,
					DefenceCards:     play.DefenceCards,
					DefenceCardAttrs: play.DefenceCardAttrs,
				},
				CardStates:        play.CardStates,
				DefenceCardStates: play.DefenceCardStates,
			}
		}
	default:
		err = fmt.Errorf("force result unsupport %d type", r.Type)
	}
	if forceResultHandler != nil {
		forceResultHandler.ForceResult(r)
		log.Warningf("Record %s:%v Force Result %s", r.servKey, r.playID, r.Result)
	}
	return
}

func NewRecord(id int64, battleType BattleType, servKey string, playID document.ID, playRecord []byte) *Record {
	return &Record{
		Type:       battleType,
		PlayRecord: playRecord,
		id:         id,
		servKey:    servKey,
		playID:     playID,
		done:       make(chan struct{}),
	}
}

func totalFightingPoint(cards []document.ID, attrs map[document.ID]*scheme.CardBattleModel) int {
	total := 0
	for _, id := range cards {
		if id != "" {
			if attr, ok := attrs[id]; ok {
				total += attr.FightingPoint
			}
		}
	}
	return total
}

func calcCraftScore(cards []document.ID, attrs map[document.ID]*scheme.CardBattleModel, damageScoreRatio float64) int {
	point := 0
	for _, id := range cards {
		if id != "" {
			if attrs, ok := attrs[id]; ok {
				point = int(attrs.Attrs["hp"] / damageScoreRatio)
				break
			}
		}
	}
	return point
}

type ErrorForceResultHandler interface {
	ForceResult(record *Record)
}

type simpleForceResultHandler struct {
	Cards            []document.ID
	CardAttrs        map[document.ID]*scheme.CardBattleModel
	DefenceCards     []document.ID
	DefenceCardAttrs map[document.ID]*scheme.CardBattleModel
}

func (h *simpleForceResultHandler) ForceResult(record *Record) {
	fightingPoint := totalFightingPoint(h.Cards, h.CardAttrs)
	defenceFightingPoint := totalFightingPoint(h.DefenceCards, h.DefenceCardAttrs)
	result := "win"
	if fightingPoint < defenceFightingPoint {
		result = "fail"
	}
	point1 := calcCraftScore(h.Cards, h.CardAttrs, 500)
	point2 := calcCraftScore(h.DefenceCards, h.DefenceCardAttrs, 500)

	record.Result = result
	record.Point1 = point1
	record.Point2 = point2
	record.States = nil
}

const (
	FightingPointWeight = 80
	CardAvgHPWeight     = 20
)

func calcCardsHPAvg(cards []document.ID, attrs map[document.ID]*scheme.CardBattleModel, states map[document.ID][2]float64) float64 {
	totalHp := 0.0
	count := 0
	for _, id := range cards {
		if id == "" {
			continue
		}
		if attr, ok := attrs[id]; ok {
			if state, ok := states[id]; ok {
				// 卡牌状态 {cardID:{hp, mp)}
				totalHp += attr.Attrs["hp"] * state[0]
				count += 1
			}
		}
	}
	return totalHp / float64(count)
}

func calcUnionFightForceWeight(fightingPoint int, avgHP float64) float64 {
	return float64(fightingPoint*FightingPointWeight) + avgHP*CardAvgHPWeight
}

type simpleUnionFightForceResultHandler struct {
	simpleForceResultHandler

	CardStates        map[document.ID][2]float64
	DefenceCardStates map[document.ID][2]float64
}

func (h *simpleUnionFightForceResultHandler) ForceResult(record *Record) {
	fightingPoint := totalFightingPoint(h.Cards, h.CardAttrs)
	defenceFightingPoint := totalFightingPoint(h.DefenceCards, h.DefenceCardAttrs)
	avgHP := calcCardsHPAvg(h.Cards, h.CardAttrs, h.CardStates)
	defenceAvgHP := calcCardsHPAvg(h.DefenceCards, h.DefenceCardAttrs, h.DefenceCardStates)
	result := "win"
	if calcUnionFightForceWeight(fightingPoint, avgHP) < calcUnionFightForceWeight(defenceFightingPoint, defenceAvgHP) {
		result = "fail"
	}

	states := make(map[document.ID][2]float64)
	// 简单认为全死
	for _, id := range h.Cards {
		if id != "" {
			states[id] = [2]float64{0, 0}
		}
	}
	for _, id := range h.DefenceCards {
		if id != "" {
			states[id] = [2]float64{0, 0}
		}
	}

	record.Result = result
	record.States = states
}

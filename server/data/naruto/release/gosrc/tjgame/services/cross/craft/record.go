package craft

import (
	"math/rand"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
)

func CrossCraftRecordTopDisplay(record *scheme.CrossCraftRecord) map[string]int {
	card := 0
	point := 0
	total := 0
	skin := 0
	for _, id := range record.Cards {
		if m, ok := record.CardAttrs[id]; ok {
			total += m.FightingPoint
			if m.FightingPoint > point {
				point = m.FightingPoint
				card = m.CardId
				skin = m.SkinId
			}
		}
	}
	return map[string]int{
		"top_card":       card,
		"fighting_point": total,
		"skin_id":        skin,
	}
}

func RoundBattleCard(record *scheme.CrossCraftRecord, round string) ([]scheme.CardTuple, int) {
	roundIdx := RoundNextMap[round].idx - 1
	cardIdx := (roundIdx * 3) % 12

	cards := make([]scheme.CardTuple, 3)
	fightingpoint := 0
	for i := 0; i < 3; i++ {
		idx := cardIdx + i
		id := record.Cards[idx]
		attr := record.CardAttrs[id]
		fightingpoint += attr.FightingPoint
		cards[i] = scheme.CardTuple{
			ID:     id,
			CardID: attr.CardId,
			SkinID: attr.SkinId,
		}
	}
	return cards, fightingpoint
}

// CrossCraftPlayRecord
type PlayRecord struct {
	*scheme.CrossCraftPlayRecordObject
}

func NewPlayRecord(record *scheme.CrossCraftPlayRecord) *PlayRecord {
	r := &PlayRecord{
		CrossCraftPlayRecordObject: scheme.NewCrossCraftPlayRecordObject(record),
	}
	return r
}

func (r *PlayRecord) resetRandSeed() int32 {
	seed := rand.Int31n(99999999) + 1
	id := r.GetID()
	old := r.RandSeed()
	r.SetRandSeed(seed)
	log.Infof("CrossCraftPlayRecord ResetRandSeed %v, %d -> %d", id, old, seed)
	return seed
}

func calcPlayCards(round string, record *scheme.CrossCraftRecord) ([]document.ID, map[document.ID]*scheme.CardBattleModel, map[document.ID]*scheme.CardBattleModel) {
	roundIdx := RoundNextMap[round].idx - 1
	cardIdx := (roundIdx * 3) % 12

	fix, percents := getFixAndHaloPercents(record.Cards, record.CardAttrs)
	if fix != nil {
		log.Debugf("fix card attrs, %s percents %v", record.RoleDbId, percents)
	}
	cards := make([]document.ID, 12)
	cardD := make(map[document.ID]*scheme.CardBattleModel)
	cardD2 := make(map[document.ID]*scheme.CardBattleModel)
	for i := 0; i < 3; i++ {
		idx := cardIdx + i
		cardID := record.Cards[idx]
		cards[idx] = cardID
		cardD[cardID] = record.CardAttrs[cardID]
		if fix != nil {
			cardD[cardID].Attrs = fix.amend(percents, cardD[cardID].Attrs)
		}
		if attr, ok := record.CardAttrs2[cardID]; ok {
			cardD2[cardID] = attr
			if fix != nil {
				cardD2[cardID].Attrs = fix.amend(percents, cardD2[cardID].Attrs)
			}
		}
	}
	return cards, cardD, cardD2
}

func NewPlayModel(round string, roleKey1 scheme.RoleKey, record1 *scheme.CrossCraftRecord, roleKey2 scheme.RoleKey, record2 *scheme.CrossCraftRecord, buffs []int) *scheme.CrossCraftPlayRecord {
	cards1, cardD1, cardD12 := calcPlayCards(round, record1)
	cards2, cardD2, cardD22 := calcPlayCards(round, record2)

	playModel := document.New("CrossCraftPlayRecord", true).(*scheme.CrossCraftPlayRecord)
	playModel.RandSeed = rand.Int31n(99999999) + 1
	playModel.Round = round
	playModel.Buffs = buffs

	playModel.RoleKey = roleKey1
	playModel.RecordDbId = record1.ID
	playModel.Name = record1.RoleName
	playModel.Logo = record1.RoleLogo
	playModel.Level = record1.RoleLevel
	playModel.Figure = record1.RoleFigure
	playModel.Cards = cards1
	playModel.CardAttrs = cardD1
	playModel.CardAttrs2 = cardD12

	playModel.DefenceRoleKey = roleKey2
	playModel.DefenceRecordId = record2.ID
	playModel.DefenceName = record2.RoleName
	playModel.DefenceLogo = record2.RoleLogo
	playModel.DefenceLevel = record2.RoleLevel
	playModel.DefenceFigure = record2.RoleFigure
	playModel.DefenceCards = cards2
	playModel.DefenceCardAttrs = cardD2
	playModel.DefenceCardAttrs2 = cardD22

	return playModel
}

func NewByePlayModel(round string, roleKey scheme.RoleKey, record *scheme.CrossCraftRecord) *scheme.CrossCraftPlayRecord {
	cards1, cardD1, cardD12 := calcPlayCards(round, record)
	playModel := document.New("CrossCraftPlayRecord", true).(*scheme.CrossCraftPlayRecord)
	playModel.Round = round

	point := 0 // 轮空积分按本卡hp来计算
	cfg := GetConfig()
	for _, card := range cardD1 {
		point = int(card.Attrs["hp"] / cfg.DamageScoreRatio)
		break
	}

	playModel.Result = "win"
	playModel.Point = point
	playModel.DefencePoint = 0

	playModel.RoleKey = roleKey
	playModel.RecordDbId = record.ID
	playModel.Name = record.RoleName
	playModel.Logo = record.RoleLogo
	playModel.Level = record.RoleLevel
	playModel.Figure = record.RoleFigure
	playModel.Cards = cards1
	playModel.CardAttrs = cardD1
	playModel.CardAttrs2 = cardD12
	return playModel
}

func CalcRobotPlayResult(model *scheme.CrossCraftPlayRecord) (string, [2]int) {
	fightingpoint1, fightingpoint2 := 0, 0
	for _, card := range model.CardAttrs {
		fightingpoint1 += card.FightingPoint
	}
	for _, card := range model.DefenceCardAttrs {
		fightingpoint2 += card.FightingPoint
	}
	result := "fail"
	if fightingpoint1 > fightingpoint2 {
		result = "win"
	}
	point1 := int(float32(model.Level)*rand.Float32() + 0.5)
	point2 := int(float32(model.DefenceLevel)*rand.Float32() + 0.5)
	return result, [2]int{point1, point2}
}

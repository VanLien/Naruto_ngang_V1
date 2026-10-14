package craft

import (
	"errors"
	"math/rand"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/document/schemeutil"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
)

type competitor struct {
	ID     document.ID `codec:"id"`
	Name   string      `codec:"name"`
	Level  int         `codec:"level"`
	Logo   int         `codec:"logo"`
	Frame  int         `codec:"frame"`
	Figure int         `codec:"figure"`
}

type deployment struct {
	Cards         []document.ID                           `codec:"cards"`
	CardAttrs     map[document.ID]*scheme.CardBattleModel `codec:"card_attrs"`
	CardAttrs2    map[document.ID]*scheme.CardBattleModel `codec:"card_attrs2"`
	PassiveSkills map[document.Integer]int                `codec:"passive_skills"`
}

// CraftRecord
type Record struct {
	*scheme.CraftRecordObject
}

func (r *Record) updateRole(role competitor) {
	db, unlock := r.LockAndGetDB()
	defer unlock()

	db.RoleName = role.Name
	db.RoleLogo = role.Logo
	db.RoleFrame = role.Frame
	db.RoleLevel = role.Level
	db.RoleFigure = role.Figure
	r.SetDirty("role_name", "role_logo", "role_frame", "role_level", "role_figure")
}

func (r *Record) deployCards(deploy deployment, lockcardnum int, lockcardattrs bool) (err error) {
	db, unlock := r.LockAndGetDB()
	defer unlock()

	if len(deploy.Cards) > 0 {
		if lockcardattrs { // lock card attrs means round not in signup or closed
			// 更换阵容
			if !schemeutil.CompareCardsSetEqual(db.Cards, deploy.Cards) {
				err = errors.New("craft cards not matched")
				return
			}
			for i, card := range deploy.Cards {
				// 开始pre或final战斗，只能更换之后的
				if i < lockcardnum && db.Cards[i] != card {
					err = errors.New("craftLockDeploy")
					return
				}
			}
			r.SetCards(deploy.Cards)
		} else {
			r.SetHoldCards(deploy.Cards)
		}
	}

	// 属性变动
	if len(deploy.CardAttrs) > 0 {
		db.HoldCardAttrs = schemeutil.UpdateCardAttrs(db.HoldCardAttrs, deploy.CardAttrs, db.Cards, db.HoldCards)
		r.SetHoldCardAttrs(db.HoldCardAttrs)
	}
	if len(deploy.CardAttrs2) > 0 {
		db.HoldCardAttrs2 = schemeutil.UpdateCardAttrs(db.HoldCardAttrs2, deploy.CardAttrs2, db.Cards, db.HoldCards)
		r.SetHoldCardAttrs2(db.HoldCardAttrs2)
	}
	r.SetHoldPassiveSkills(deploy.PassiveSkills)
	return
}

func (r *Record) deployHoldCard(deploy deployment) {
	db, unlock := r.LockAndGetDB()
	defer unlock()

	if len(deploy.Cards) > 0 {
		r.SetHoldCards(deploy.Cards)
	}
	if len(deploy.CardAttrs) > 0 {
		db.HoldCardAttrs = schemeutil.UpdateCardAttrs(db.HoldCardAttrs, deploy.CardAttrs, db.Cards, db.HoldCards)
		r.SetHoldCardAttrs(db.HoldCardAttrs)
	}
	if len(deploy.CardAttrs2) > 0 {
		db.HoldCardAttrs2 = schemeutil.UpdateCardAttrs(db.HoldCardAttrs2, deploy.CardAttrs2, db.Cards, db.HoldCards)
		r.SetHoldCardAttrs2(db.HoldCardAttrs2)
	}
	r.SetHoldPassiveSkills(deploy.PassiveSkills)
}

func (r *Record) checkBroken() bool {
	r.Lock()
	defer r.Unlock()
	broken := false
	cardattrs := r.CardAttrs()
	cards := r.Cards()
	if len(cards) < 10 {
		log.Warningf("role %v %s record %v not enough cards, expect %d got %d", r.RoleDbId(), r.RoleName(), r.GetID(), 10, len(cards))
		return true
	}
	for _, id := range cards {
		if id == "" {
			broken = true
			log.Warningf("role %v %s record %v not enough cards", r.RoleDbId(), r.RoleName(), r.GetID())
			break
		} else {
			if _, ok := cardattrs[id]; !ok {
				broken = true
				log.Warningf("role %v %s record %v card not find card attr", r.RoleDbId(), r.RoleName(), r.GetID())
				break
			}
		}
	}
	return broken
}

func (r *Record) prepare(manual bool) {
	db, unlock := r.LockAndGetDB()
	defer unlock()

	r.SetHistory([]scheme.CraftBattleHistory{}) // 清空历史
	if r.Robot() {
		return
	}
	// 更新战斗数据
	if len(db.HoldCards) > 0 { // 旧数据 HoldCards 可能没有
		r.SetCards(db.HoldCards)
	}
	r.SetCardAttrs(schemeutil.CopyCardAttrs(db.HoldCardAttrs))
	r.SetCardAttrs2(schemeutil.CopyCardAttrs(db.HoldCardAttrs2))
	r.SetPassiveSkills(schemeutil.CopySkills(db.HoldPassiveSkills))
}

func (r *Record) addByeHistory(model *scheme.CraftPlayRecord) {
	cards, fightingpoint := filterEmptyCards(model.Cards, model.CardAttrs)
	h := scheme.CraftBattleHistory{
		Time:          util.NowTime(),
		Round:         model.Round,
		Result:        "win",
		Point:         model.Point,
		FightingPoint: fightingpoint,
		Cards:         cards,
	}
	r.Lock()
	history := r.History()
	history = append(history, h)
	r.SetHistory(history)
	r.Unlock()
}

func (r *Record) addHistoryFromPlay(model *scheme.CraftPlayRecord) {
	cards, fightingpoint := filterEmptyCards(model.Cards, model.CardAttrs)
	cards2, fightingpoint2 := filterEmptyCards(model.DefenceCards, model.DefenceCardAttrs)
	h := scheme.CraftBattleHistory{
		Time:         util.NowTime(),
		Round:        model.Round,
		PlayRecordID: &model.ID,
	}
	r.Lock()
	if r.RoleDbId() == model.RoleDbId {
		h.Result = model.Result
		h.Point = model.Point
		h.FightingPoint = fightingpoint
		h.Cards = cards
		h.Enemy = &scheme.CraftBattleRole{
			CraftRole: scheme.CraftRole{
				RoleID:   model.DefenceRoleDbId,
				RecordID: model.DefenceRecordId,
				Name:     model.DefenceName,
				Logo:     model.DefenceLogo,
				Frame:    model.DefenceFrame,
				Level:    model.DefenceLevel,
				Figure:   model.DefenceFigure,
			},
			FightingPoint: fightingpoint2,
			Cards:         cards2,
		}
	} else {
		result := "win"
		if model.Result == "win" {
			result = "fail"
		}
		h.Result = result
		h.Point = model.DefencePoint
		h.FightingPoint = fightingpoint2
		h.Cards = cards2
		h.Enemy = &scheme.CraftBattleRole{
			CraftRole: scheme.CraftRole{
				RoleID:   model.RoleDbId,
				RecordID: model.RecordDbId,
				Name:     model.Name,
				Logo:     model.Logo,
				Frame:    model.Frame,
				Level:    model.Level,
				Figure:   model.Figure,
			},
			FightingPoint: fightingpoint,
			Cards:         cards,
		}
	}
	history := r.History()
	history = append(history, h)
	r.SetHistory(history)
	r.Unlock()
}

func (r *Record) TopDisplay() map[string]int {
	card := 0
	point := 0
	total := 0
	skin := 0
	r.Lock()
	defer r.Unlock()
	for _, id := range r.Cards() {
		if m, ok := r.CardAttrs()[id]; ok {
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

func (r *Record) TotalFightingPoint() int {
	total := 0
	r.Lock()
	defer r.Unlock()
	for _, id := range r.Cards() {
		if m, ok := r.CardAttrs()[id]; ok {
			total += m.FightingPoint
		}
	}
	return total
}

func (r *Record) RoundBattleCards(round string) ([]scheme.CardTuple, int) {
	r.Lock()
	defer r.Unlock()
	idx := RoundNextMap[round].idx - 1
	if isInFinal(round) {
		idx -= 10
		cards := make([]scheme.CardTuple, 3)
		fightingpoint := 0
		for i := 0; i < 3; i++ {
			iidex := idx*3 + i
			id := r.Cards()[iidex]
			attr := r.CardAttrs()[id]
			fightingpoint += attr.FightingPoint
			cards[i] = scheme.CardTuple{
				ID:     id,
				CardID: attr.CardId,
				SkinID: attr.SkinId,
			}
		}
		return cards, fightingpoint
	}
	id := r.Cards()[idx]
	attr := r.CardAttrs()[id]
	return []scheme.CardTuple{{
		ID:     id,
		CardID: attr.CardId,
		SkinID: attr.SkinId,
	}}, attr.FightingPoint
}

// CraftPlayRecord
type PlayRecord struct {
	*scheme.CraftPlayRecordObject
}

func (r *PlayRecord) resetRandSeed() int32 {
	seed := rand.Int31n(99999999) + 1
	id := r.GetID()
	old := r.RandSeed()
	r.SetRandSeed(seed)
	log.Infof("CraftPlayRecord ResetRandSeed %v, %d -> %d", id, old, seed)
	return seed
}

func filterEmptyCards(cards []document.ID, cardAttrs map[document.ID]*scheme.CardBattleModel) ([]scheme.CardTuple, int) {
	v := make([]scheme.CardTuple, 0, len(cards))
	fightingPoint := 0
	for _, cardID := range cards {
		if cardID != "" {
			attrs := cardAttrs[cardID]
			if attrs == nil {
				continue
			}
			v = append(v, scheme.CardTuple{
				ID:     cardID,
				CardID: attrs.CardId,
				SkinID: attrs.SkinId,
			})
			fightingPoint += attrs.FightingPoint
		}
	}
	return v, fightingPoint
}

func calcPlayCards(round string, record *Record) ([]document.ID, map[document.ID]*scheme.CardBattleModel, map[document.ID]*scheme.CardBattleModel) {
	idx := RoundNextMap[round].idx - 1
	cards := make([]document.ID, 10)
	cardD := make(map[document.ID]*scheme.CardBattleModel)
	cardD2 := make(map[document.ID]*scheme.CardBattleModel)
	if isInFinal(round) {
		idx -= 10
		for i := 0; i < 3; i++ {
			iidex := idx*3 + i
			cardID := record.Cards()[iidex]
			cards[iidex] = cardID
			cardD[cardID] = record.CardAttrs()[cardID]
			if attr, ok := record.CardAttrs2()[cardID]; ok {
				cardD2[cardID] = attr
			}
		}
	} else {
		cardID := record.Cards()[idx]
		cards[idx] = cardID
		cardD[cardID] = record.CardAttrs()[cardID]
		if attr, ok := record.CardAttrs2()[cardID]; ok {
			cardD2[cardID] = attr
		}
	}
	return cards, cardD, cardD2
}

func NewPlayModel(round string, record *Record, enemyRecord *Record, buffs []int) *scheme.CraftPlayRecord {
	recordDB, recordUnlock := record.LockAndGetDB()
	enemyRecordDB, enemyRecordUnlock := enemyRecord.LockAndGetDB()

	cards1, cardD1, cardD12 := calcPlayCards(round, record)
	cards2, cardD2, cardD22 := calcPlayCards(round, enemyRecord)

	playModel := document.New("CraftPlayRecord", true).(*scheme.CraftPlayRecord)
	playModel.RandSeed = rand.Int31n(99999999) + 1
	playModel.Round = round
	playModel.Buffs = buffs

	playModel.RoleDbId = recordDB.RoleDbId
	playModel.RecordDbId = recordDB.ID
	playModel.Name = recordDB.RoleName
	playModel.Logo = recordDB.RoleLogo
	playModel.Level = recordDB.RoleLevel
	playModel.Figure = recordDB.RoleFigure
	playModel.Cards = cards1
	playModel.CardAttrs = cardD1
	playModel.CardAttrs2 = cardD12
	recordUnlock()

	playModel.DefenceRoleDbId = enemyRecordDB.RoleDbId
	playModel.DefenceRecordId = enemyRecordDB.ID
	playModel.DefenceName = enemyRecordDB.RoleName
	playModel.DefenceLogo = enemyRecordDB.RoleLogo
	playModel.DefenceLevel = enemyRecordDB.RoleLevel
	playModel.DefenceFigure = enemyRecordDB.RoleFigure
	playModel.DefenceCards = cards2
	playModel.DefenceCardAttrs = cardD2
	playModel.DefenceCardAttrs2 = cardD22
	enemyRecordUnlock()

	return playModel
}

func NewByePlayModel(round string, record *Record) *scheme.CraftPlayRecord {
	recordDB, unlock := record.LockAndGetDB()
	defer unlock()

	cards1, cardD1, cardD12 := calcPlayCards(round, record)
	playModel := document.New("CraftPlayRecord", true).(*scheme.CraftPlayRecord)
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

	playModel.RoleDbId = recordDB.RoleDbId
	playModel.RecordDbId = recordDB.ID
	playModel.Name = recordDB.RoleName
	playModel.Logo = recordDB.RoleLogo
	playModel.Level = recordDB.RoleLevel
	playModel.Figure = recordDB.RoleFigure
	playModel.Cards = cards1
	playModel.CardAttrs = cardD1
	playModel.CardAttrs2 = cardD12
	return playModel
}

func CalcRobotPlayResult(model *scheme.CraftPlayRecord) (string, [2]int) {
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

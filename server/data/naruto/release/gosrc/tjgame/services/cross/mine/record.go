package mine

import (
	"math/rand"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
)

// CrossMinePlayRecord
type PlayRecord struct {
	*scheme.CrossMinePlayRecordObject
}

func NewPlayModel(roleKey, enemyRoleKey scheme.RoleKey, record, enemyRecord *scheme.CrossMineRecord) *scheme.CrossMinePlayRecord {
	playModel := document.New("CrossMinePlayRecord", true).(*scheme.CrossMinePlayRecord)
	playModel.RandSeed = rand.Int31n(99999999) + 1

	playModel.RoleKey = roleKey
	playModel.RecordDbId = record.ID
	playModel.Name = record.RoleName
	playModel.Logo = record.RoleLogo
	playModel.Frame = record.RoleFrame
	playModel.Level = record.RoleLevel
	playModel.Vip = record.RoleVip
	playModel.Figure = record.RoleFigure
	playModel.Cards = record.Cards
	playModel.CardAttrs = record.CardAttrs
	playModel.CardAttrs2 = record.CardAttrs2
	playModel.PassiveSkills = record.PassiveSkills

	playModel.DefenceRoleKey = enemyRoleKey
	playModel.DefenceRecordId = enemyRecord.ID
	playModel.DefenceName = enemyRecord.RoleName
	playModel.DefenceLogo = enemyRecord.RoleLogo
	playModel.DefenceFrame = enemyRecord.RoleFrame
	playModel.DefenceLevel = enemyRecord.RoleLevel
	playModel.DefenceVip = enemyRecord.RoleVip
	playModel.DefenceFigure = enemyRecord.RoleFigure
	playModel.DefenceCards = enemyRecord.DefenceCards
	playModel.DefenceCardAttrs = enemyRecord.DefenceCardAttrs
	playModel.DefenceCardAttrs2 = enemyRecord.DefenceCardAttrs2
	playModel.DefencePassiveSkills = enemyRecord.DefencePassiveSkills

	return playModel
}

func (r *PlayRecord) cardAttrFix(serverBuffLevel, roleBuffLevel int, bossBuffAdd float64) {
	db, unlock := r.LockAndGetDB()
	defer unlock()
	r.SetCardAttrs(calcCardAttr(db.CardAttrs, serverBuffLevel, roleBuffLevel, bossBuffAdd))
	if db.CardAttrs2 != nil {
		r.SetCardAttrs2(calcCardAttr(db.CardAttrs2, serverBuffLevel, roleBuffLevel, bossBuffAdd))
	}
}

func (r *PlayRecord) defenceCardAttrFix(serverBuffLevel, roleBuffLevel int, bossBuffAdd float64) {
	db, unlock := r.LockAndGetDB()
	defer unlock()
	r.SetDefenceCardAttrs(calcCardAttr(db.DefenceCardAttrs, serverBuffLevel, roleBuffLevel, bossBuffAdd))
	if db.DefenceCardAttrs2 != nil {
		r.SetDefenceCardAttrs2(calcCardAttr(db.DefenceCardAttrs2, serverBuffLevel, roleBuffLevel, bossBuffAdd))
	}
}

func (r *PlayRecord) getFightingPoint() int {
	fp := 0
	for _, attr := range r.CardAttrs() {
		fp += attr.FightingPoint
	}
	return fp
}

func (r *PlayRecord) getEnemyFightingPoint() int {
	fp := 0
	for _, attr := range r.DefenceCardAttrs() {
		fp += attr.FightingPoint
	}
	return fp
}

func (r *PlayRecord) resetRandSeed() int32 {
	seed := rand.Int31n(99999999) + 1
	id := r.GetID()
	old := r.RandSeed()
	r.SetRandSeed(seed)
	log.Infof("CrossMinePlayRecord ResetRandSeed %v, %d -> %d", id, old, seed)
	return seed
}

package arena

import (
	"math/rand"
	"tjgame/document"
	"tjgame/document/scheme"
)

// CrossArenaPlayRecord
type PlayRecord struct {
	*scheme.CrossArenaPlayRecordObject
}

func NewPlayRecord(record *scheme.CrossArenaPlayRecord) *PlayRecord {
	r := &PlayRecord{
		CrossArenaPlayRecordObject: scheme.NewCrossArenaPlayRecordObject(record),
	}
	return r
}

func NewPlayModel(roleKey, enemyRoleKey scheme.RoleKey, record, enemyRecord *scheme.CrossArenaRecord) *scheme.CrossArenaPlayRecord {

	playModel := document.New("CrossArenaPlayRecord", true).(*scheme.CrossArenaPlayRecord)
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

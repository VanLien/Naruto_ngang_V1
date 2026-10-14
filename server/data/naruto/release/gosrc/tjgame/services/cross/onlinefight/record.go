package onlinefight

import (
	"math/rand"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/services/cross/onlinefight/proto"
)

// CrossOnlineFightPlayRecord
type PlayRecord struct {
	*scheme.CrossOnlineFightPlayRecordObject
}

func NewUnlimitedPlayModel(roleKey1 scheme.RoleKey, record1 *scheme.CrossOnlineFightRecord, roleKey2 scheme.RoleKey, record2 *scheme.CrossOnlineFightRecord) *scheme.CrossOnlineFightPlayRecord {
	model := document.New("CrossOnlineFightPlayRecord", true).(*scheme.CrossOnlineFightPlayRecord)

	model.RandSeed = rand.Int31n(99999999) + 1

	model.RoleKey = roleKey1
	model.RecordDbId = record1.ID
	model.Name = record1.RoleName
	model.Logo = record1.RoleLogo
	model.Frame = record1.RoleFrame
	model.Level = record1.RoleLevel
	model.Figure = record1.RoleFigure
	model.Cards = record1.Cards
	model.CardAttrs = record1.CardAttrs
	model.CardAttrs2 = record1.CardAttrs2
	model.PassiveSkills = record1.PassiveSkills

	model.DefenceRoleKey = roleKey2
	model.DefenceRecordId = record2.ID
	model.DefenceName = record2.RoleName
	model.DefenceLogo = record2.RoleLogo
	model.DefenceFrame = record2.RoleFrame
	model.DefenceLevel = record2.RoleLevel
	model.DefenceFigure = record2.RoleFigure
	model.DefenceCards = record2.Cards
	model.DefenceCardAttrs = record2.CardAttrs
	model.DefenceCardAttrs2 = record2.CardAttrs2
	model.DefencePassiveSkills = record2.PassiveSkills

	return model
}

func NewLimitedPlayModel(role1, role2 *scheme.CrossOnlineFightRole, deck *proto.CrossOnlineFightLimitedCardDeck) *scheme.CrossOnlineFightPlayRecord {
	model := document.New("CrossOnlineFightPlayRecord", true).(*scheme.CrossOnlineFightPlayRecord)

	model.RandSeed = rand.Int31n(99999999) + 1

	model.RoleKey = scheme.RoleKey{GameKey: role1.GameKey, ID: role1.RoleID}
	model.RecordDbId = role1.RecordID
	model.Name = role1.Name
	model.Logo = role1.Logo
	model.Frame = role1.Frame
	model.Level = role1.Level
	model.Figure = role1.Figure

	model.DefenceRoleKey = scheme.RoleKey{GameKey: role2.GameKey, ID: role2.RoleID}
	model.DefenceRecordId = role2.RecordID
	model.DefenceName = role2.Name
	model.DefenceLogo = role2.Logo
	model.DefenceFrame = role2.Frame
	model.DefenceLevel = role2.Level
	model.DefenceFigure = role2.Figure

	model.LimitedCardDeck = &scheme.CrossOnlineFightLimitedCardDeck{
		RoleCardDeck1: deck.RoleCardDeck1,
		RoleCardDeck2: deck.RoleCardDeck2,
		Cards:         make(map[document.ID]*scheme.CrossOnlineFightCard),
	}
	for id, card := range deck.Cards {
		model.LimitedCardDeck.Cards[id] = &card.CrossOnlineFightCard
	}

	return model
}

func combinePlayRecordResult(record *scheme.CrossOnlineFightPlayRecord, result *proto.BattleResult, scores [2]int) {
	if result.BanPickInputSteps != nil {
		record.Cards = result.Cards
		record.CardAttrs = result.CardAttrs
		record.DefenceCards = result.DefenceCards
		record.DefenceCardAttrs = result.DefenceCardAttrs
		record.BanPickInputSteps = result.BanPickInputSteps
	}
	record.AttackFrames = result.AttackFrames
	record.Result = result.Results
	record.Scores = scores
}

func playRecord2TopHistory(key string, record *scheme.CrossOnlineFightPlayRecord) scheme.CrossOnlineFightTopBattleHistory {
	return scheme.CrossOnlineFightTopBattleHistory{
		Time:            record.Time,
		Result:          record.Result[0],
		PlayRecordID:    record.ID,
		CrossKey:        key,
		RoleKey:         record.RoleKey,
		RecordID:        record.RecordDbId,
		Name:            record.Name,
		Logo:            record.Logo,
		Frame:           record.Frame,
		Level:           record.Level,
		DefenceRoleKey:  record.DefenceRoleKey,
		DefenceRecordID: record.DefenceRecordId,
		DefenceName:     record.DefenceName,
		DefenceLogo:     record.DefenceLogo,
		DefenceFrame:    record.DefenceFrame,
		DefenceLevel:    record.DefenceLevel,
	}
}

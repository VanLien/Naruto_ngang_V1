/*
 * @Date    : 2021/9/9 22:43
 * @File    : record.go
 * @Version : 1.0.0
 * @Author  : hss
 * @Note    :
 *
 */

package union_fight

import (
	"math/rand"
	"tjgame/document"
	"tjgame/document/scheme"
)

// CrossUnionFightPlayRecord
type CrossUnionFightPlayRecord struct {
	*scheme.CrossUnionFightPlayRecordObject
}

func NewPlayModel(roundInfo BattleRoundInfo, roleKey, enemyRoleKey scheme.RoleKey, record, enemyRecord *scheme.CrossUnionFightRoleRecord) *scheme.CrossUnionFightPlayRecord {
	group := roundInfo.Group
	battleType := roundInfo.BattleType
	round := roundInfo.Round

	playModel := document.New("CrossUnionFightPlayRecord", true).(*scheme.CrossUnionFightPlayRecord)
	playModel.RandSeed = rand.Int31n(99999999) + 1
	playModel.Group = group
	playModel.BattleType = battleType
	playModel.Round = round

	// 己方
	playModel.RoleKey = roleKey
	if record.ID != "" {
		playModel.RecordId = record.ID
	}
	playModel.Name = record.RoleName
	playModel.Logo = record.RoleLogo
	playModel.Frame = record.RoleFrame
	playModel.Level = record.RoleLevel
	playModel.Figure = record.RoleFigure
	if group != TopGroup {
		if roleKey.ID == "" {
			playModel.Cards = []document.ID{}
		} else {
			allCardIDs := record.Cards[PreStage][document.Integer(battleType)]
			playModel.Cards = makePlayRecordCards(allCardIDs, battleType, roundInfo.Troop, roundInfo.CardStates)
		}
		playModel.CardAttrs = record.CardAttrs
		playModel.CardAttrs2 = record.CardAttrs2
		playModel.PassiveSkills = record.PassiveSkills
	} else {
		if roleKey.ID == "" {
			playModel.Cards = []document.ID{}
		} else {
			allCardIDs := record.Cards[TopStage][document.Integer(battleType)]
			playModel.Cards = makePlayRecordCards(allCardIDs, battleType, roundInfo.Troop, roundInfo.CardStates)
		}
		playModel.CardAttrs = record.TopCardAttrs
		playModel.CardAttrs2 = record.TopCardAttrs2
		playModel.PassiveSkills = record.TopPassiveSkills
	}

	playModel.CardStates = roundInfo.CardStates
	playModel.BattleTimes = roundInfo.BattleTimes

	// 对方
	playModel.DefenceRoleKey = enemyRoleKey
	if enemyRecord.ID != "" {
		playModel.DefenceRecordId = enemyRecord.ID
	}
	playModel.DefenceName = enemyRecord.RoleName
	playModel.DefenceLogo = enemyRecord.RoleLogo
	playModel.DefenceFrame = enemyRecord.RoleFrame
	playModel.DefenceLevel = enemyRecord.RoleLevel
	playModel.DefenceFigure = enemyRecord.RoleFigure
	if group != TopGroup {
		if enemyRoleKey.ID == "" {
			playModel.DefenceCards = []document.ID{}
		} else {
			allCardIDs := enemyRecord.Cards[PreStage][document.Integer(battleType)]
			playModel.DefenceCards = makePlayRecordCards(allCardIDs, battleType, roundInfo.DefenceTroop, roundInfo.DefenceCardStates)
		}
		playModel.DefenceCardAttrs = enemyRecord.CardAttrs
		playModel.DefenceCardAttrs2 = enemyRecord.CardAttrs2
		playModel.DefencePassiveSkills = enemyRecord.PassiveSkills
	} else {
		if enemyRoleKey.ID == "" {
			playModel.DefenceCards = []document.ID{}
		} else {
			allCardIDs := enemyRecord.Cards[TopStage][document.Integer(battleType)]
			playModel.DefenceCards = makePlayRecordCards(allCardIDs, battleType, roundInfo.DefenceTroop, roundInfo.DefenceCardStates)
		}
		playModel.DefenceCardAttrs = enemyRecord.TopCardAttrs
		playModel.DefenceCardAttrs2 = enemyRecord.TopCardAttrs2
		playModel.DefencePassiveSkills = enemyRecord.TopPassiveSkills
	}
	playModel.DefenceCardStates = roundInfo.DefenceCardStates
	playModel.DefenceBattleTimes = roundInfo.DefenceBattleTimes

	return playModel
}

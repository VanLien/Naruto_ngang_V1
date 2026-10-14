package union_fight

import (
	"math/rand"
	"tjgame/document"
	"tjgame/document/scheme"
)

// UnionFightPlayRecord
type PlayRecord struct {
	*scheme.UnionFightPlayRecordObject
}

func NewPlayModel(round string, record *RoleRecord, enemyRecord *RoleRecord) *scheme.UnionFightPlayRecord {
	playModel := document.New("UnionFightPlayRecord", true).(*scheme.UnionFightPlayRecord)
	playModel.RandSeed = rand.Int31n(99999999) + 1
	playModel.Round = round

	if record != nil {
		recordDB, unlock := record.LockAndGetDB()
		playModel.RoleDbId = recordDB.RoleDbId
		playModel.RecordDbId = recordDB.ID
		playModel.Name = recordDB.RoleName
		playModel.Logo = recordDB.RoleLogo
		playModel.Level = recordDB.RoleLevel
		playModel.Figure = recordDB.RoleFigure
		unlock()
	}

	if enemyRecord != nil {
		enemyRecordDB, enemyUnlcok := enemyRecord.LockAndGetDB()
		playModel.DefenceRoleDbId = enemyRecordDB.RoleDbId
		playModel.DefenceRecordId = enemyRecordDB.ID
		playModel.DefenceName = enemyRecordDB.RoleName
		playModel.DefenceLogo = enemyRecordDB.RoleLogo
		playModel.DefenceLevel = enemyRecordDB.RoleLevel
		playModel.DefenceFigure = enemyRecordDB.RoleFigure
		enemyUnlcok()
	}

	return playModel
}

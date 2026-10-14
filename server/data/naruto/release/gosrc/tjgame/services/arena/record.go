package arena

import (
	"math/rand"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/document/schemeutil"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
)

type SlimModel struct {
	RoleDbId      document.ID `codec:"role_db_id"`
	RecordID      document.ID `codec:"record_id"`
	Name          string      `codec:"name"`
	Level         int         `codec:"level"`
	Logo          int         `codec:"logo"`
	Frame         int         `codec:"frame"`
	Rank          int         `codec:"rank"`
	FightingPoint int         `codec:"fighting_point"`
	Display       int         `codec:"display"`
}

// ArenaRecord
type Record struct {
	*scheme.ArenaRecordObject
}

func (r *Record) deploy(role competitor, deploy deployment) {
	db, unlock := r.LockAndGetDB()
	defer unlock()
	db.RoleName = role.Name
	db.RoleLogo = role.Logo
	db.RoleFrame = role.Frame
	db.RoleLevel = role.Level
	db.RoleVip = role.Vip
	db.RoleFigure = role.Figure
	keys := []string{"role_name", "role_logo", "role_frame", "role_level", "role_vip", "role_figure"}
	if len(deploy.Cards) > 0 {
		db.Cards = deploy.Cards
		keys = append(keys, "cards")
	}
	if len(deploy.DefenceCards) > 0 {
		db.DefenceCards = deploy.DefenceCards
		keys = append(keys, "defence_cards")
	}
	if len(deploy.CardAttrs) > 0 {
		db.CardAttrs = schemeutil.UpdateCardAttrs(db.CardAttrs, deploy.CardAttrs, db.Cards)
		keys = append(keys, "card_attrs")
	}
	if len(deploy.CardAttrs2) > 0 {
		db.CardAttrs2 = schemeutil.UpdateCardAttrs(db.CardAttrs2, deploy.CardAttrs2, db.Cards)
		keys = append(keys, "card_attrs2")
	}
	if len(deploy.DefenceCardAttrs) > 0 {
		db.DefenceCardAttrs = schemeutil.UpdateCardAttrs(db.DefenceCardAttrs, deploy.DefenceCardAttrs, db.DefenceCards)
		// 计算防御战力值
		db.FightingPoint = schemeutil.CalcCardFightingPoint(db.DefenceCards, db.DefenceCardAttrs)
		keys = append(keys, "defence_card_attrs", "fighting_point")
	}
	if len(deploy.DefenceCardAttrs2) > 0 {
		db.DefenceCardAttrs2 = schemeutil.UpdateCardAttrs(db.DefenceCardAttrs2, deploy.DefenceCardAttrs2, db.DefenceCards)
		keys = append(keys, "defence_card_attrs2")
	}
	r.SetDirty(keys...)
	r.SetPassiveSkills(deploy.PassiveSkills)
	r.SetDefencePassiveSkills(deploy.DefencePassiveSkills)
}

func (r *Record) addHistory(result string, move int, playRecordID document.ID, enemyName string, enemyRoleID document.ID, enemyRecordID document.ID, enemyLogo int, enemyFrame int, enemyLevel int, enemyFight int) {
	r.Lock()
	defer r.Unlock()
	h := scheme.BattleHistory{
		Time:          util.NowTime(),
		Result:        result,
		PlayRecordID:  playRecordID,
		EnemyName:     enemyName,
		EnemyRoleID:   enemyRoleID,
		EnemyRecordID: enemyRecordID,
		EnemyLogo:     enemyLogo,
		EnemyFrame:    enemyFrame,
		EnemyLevel:    enemyLevel,
		EnemyFight:    enemyFight,
		Move:          move,
	}
	historys := r.History()
	historys = append(historys, h)
	if len(historys) > 10 {
		historys = historys[len(historys)-10:]
	}
	r.SetHistory(historys)
}

func (r *Record) checkAndRefresh(arena *Arena, refresh bool) {
	// 更新最新的rank
	arena.setNewestRank(r)

	date := util.Perioddate2int(RefreshTimeHour, util.Now())
	db := r.GetLockedDB()
	ranges := GetConfig().PWRanges
	if refresh || date != db.RefreshLastDate || len(db.EnemyRanks) == 0 {
		if rr := ranges.GetRange(db.Rank); rr != nil {
			pwrange := rr.(*PWRange)
			r.SetEnemyRanks(pwrange.getEnemys(db.Rank, 4, int(arena.RankMax())))
		} else {
			log.Warningf("rank %d can not get range", db.Rank)
		}

		if date != db.RefreshLastDate {
			r.SetRefreshLastDate(date)
		}
	}
}

func (r *Record) SetRank(rank int) {
	r.ArenaRecordObject.SetRank(rank)
	if r.RankTop() == 0 || r.RankTop() > rank {
		r.SetRankTop(rank)
	}
}

func (r *Record) slimModelLocked() SlimModel {
	db, unlock := r.RLockAndGetDB()
	defer unlock()
	return SlimModel{
		db.RoleDbId,
		db.ID,
		db.RoleName,
		db.RoleLevel,
		db.RoleLogo,
		db.RoleFrame,
		db.Rank,
		db.FightingPoint,
		db.Display,
	}
}

func NewRecord(record *scheme.ArenaRecord) *Record {
	r := &Record{
		ArenaRecordObject: scheme.NewArenaRecordObject(record),
	}
	return r
}

// ArenaPlayRecord
type PlayRecord struct {
	*scheme.ArenaPlayRecordObject
}

func NewPlayModel(record *Record, enemyRecord *Record) *scheme.ArenaPlayRecord {
	recordDB, recordDBUnlock := record.RLockAndGetDB()
	enemyRecordDB, enemyRecordDBUnlock := enemyRecord.RLockAndGetDB()

	defer recordDBUnlock()
	defer enemyRecordDBUnlock()

	playModel := document.New("ArenaPlayRecord", true).(*scheme.ArenaPlayRecord)
	playModel.RandSeed = rand.Int31n(99999999) + 1

	playModel.RoleDbId = recordDB.RoleDbId
	playModel.RecordDbId = recordDB.ID
	playModel.Name = recordDB.RoleName
	playModel.Logo = recordDB.RoleLogo
	playModel.Level = recordDB.RoleLevel
	playModel.Figure = recordDB.RoleFigure
	playModel.Cards = recordDB.Cards
	playModel.CardAttrs = recordDB.CardAttrs
	playModel.CardAttrs2 = recordDB.CardAttrs2
	playModel.PassiveSkills = recordDB.PassiveSkills

	playModel.DefenceRoleDbId = enemyRecordDB.RoleDbId
	playModel.DefenceRecordId = enemyRecordDB.ID
	playModel.DefenceName = enemyRecordDB.RoleName
	playModel.DefenceLogo = enemyRecordDB.RoleLogo
	playModel.DefenceLevel = enemyRecordDB.RoleLevel
	playModel.DefenceFigure = enemyRecordDB.RoleFigure
	playModel.DefenceCards = enemyRecordDB.DefenceCards
	playModel.DefenceCardAttrs = enemyRecordDB.DefenceCardAttrs
	playModel.DefenceCardAttrs2 = enemyRecordDB.DefenceCardAttrs2
	playModel.DefencePassiveSkills = enemyRecordDB.DefencePassiveSkills
	return playModel
}

func NewFriendPlayModel(role competitor, deploy deployment, enemyRecord *Record) *scheme.ArenaPlayRecord {
	enemyRecordDB, enemyRecordDBUnlock := enemyRecord.RLockAndGetDB()

	defer enemyRecordDBUnlock()

	playModel := document.New("ArenaPlayRecord", true).(*scheme.ArenaPlayRecord)
	playModel.RandSeed = rand.Int31n(99999999) + 1

	playModel.RoleDbId = role.ID
	playModel.Name = role.Name
	playModel.Logo = role.Logo
	playModel.Level = role.Level
	playModel.Figure = role.Figure
	playModel.Cards = deploy.Cards
	playModel.CardAttrs = deploy.CardAttrs
	playModel.CardAttrs2 = deploy.CardAttrs2
	playModel.PassiveSkills = deploy.PassiveSkills

	playModel.DefenceRoleDbId = enemyRecordDB.RoleDbId
	playModel.DefenceRecordId = enemyRecordDB.ID
	playModel.DefenceName = enemyRecordDB.RoleName
	playModel.DefenceLogo = enemyRecordDB.RoleLogo
	playModel.DefenceLevel = enemyRecordDB.RoleLevel
	playModel.DefenceFigure = enemyRecordDB.RoleFigure
	playModel.DefenceCards = enemyRecordDB.DefenceCards
	playModel.DefenceCardAttrs = enemyRecordDB.DefenceCardAttrs
	playModel.DefenceCardAttrs2 = enemyRecordDB.DefenceCardAttrs2
	playModel.DefencePassiveSkills = enemyRecordDB.DefencePassiveSkills
	return playModel
}

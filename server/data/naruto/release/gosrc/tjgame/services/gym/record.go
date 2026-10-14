package gym

import (
	"math/rand"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/document/schemeutil"
	tjutil "tjgame/server_framework/tj/util"
)

// GymRecord
type GymRecord struct {
	*scheme.GymRecordObject
}

func NewRecord(record *scheme.GymRecord) *GymRecord {
	r := &GymRecord{
		GymRecordObject: scheme.NewGymRecordObject(record),
	}
	return r
}

// GymPlayRecord
type PlayRecord struct {
	*scheme.GymPlayRecordObject
}

func NewPlayModel(record, enemyRecord *GymRecord, deploy gymDeployment) *scheme.GymPlayRecord {

	playModel := document.New("GymPlayRecord", true).(*scheme.GymPlayRecord)

	playModel.Date = tjutil.Todaydate2int()
	playModel.Time = tjutil.NowTime()
	playModel.RandSeed = rand.Int31n(99999999) + 1

	playModel.RoleDbId = record.RoleId()
	playModel.RecordDbId = record.GetID()
	playModel.Name = record.RoleName()
	playModel.Logo = record.RoleLogo()
	playModel.Frame = record.RoleFrame()
	playModel.Level = record.RoleLevel()
	playModel.Vip = record.RoleVip()
	playModel.Figure = record.RoleFigure()
	playModel.Cards = deploy.Cards
	playModel.CardAttrs = deploy.CardAttrs
	playModel.CardAttrs2 = deploy.CardAttrs2
	playModel.PassiveSkills = deploy.PassiveSkills

	playModel.DefenceRoleDbId = enemyRecord.RoleId()
	playModel.DefenceRecordId = enemyRecord.GetID()
	playModel.DefenceName = enemyRecord.RoleName()
	playModel.DefenceLogo = enemyRecord.RoleLogo()
	playModel.DefenceFrame = enemyRecord.RoleFrame()
	playModel.DefenceLevel = enemyRecord.RoleLevel()
	playModel.DefenceVip = enemyRecord.RoleVip()
	playModel.DefenceFigure = enemyRecord.RoleFigure()
	playModel.DefenceCards = enemyRecord.Cards()
	playModel.DefenceCardAttrs = enemyRecord.CardAttrs()
	playModel.DefenceCardAttrs2 = enemyRecord.CardAttrs2()
	playModel.DefencePassiveSkills = enemyRecord.PassiveSkills()

	return playModel
}

// 布阵
func (r *GymRecord) deployCards(role gymCompetitor, deploy gymDeployment) {
	db, unlock := r.LockAndGetDB()
	defer unlock()

	db.RoleName = role.Name
	db.RoleLogo = role.Logo
	db.RoleFrame = role.Frame
	db.RoleLevel = role.Level
	db.RoleVip = role.Vip
	db.RoleFigure = role.Figure
	keys := []string{"role_name", "role_logo", "role_frame", "role_level", "role_vip", "role_figure"}

	// cards
	if len(deploy.Cards) > 0 {
		db.Cards = deploy.Cards
		keys = append(keys, "cards")
	}
	if len(deploy.CrossCards) > 0 {
		db.CrossCards = deploy.CrossCards
		keys = append(keys, "cross_cards")
	}

	// CardAttrs
	if len(deploy.CardAttrs) > 0 {
		db.CardAttrs = schemeutil.UpdateCardAttrs(db.CardAttrs, deploy.CardAttrs, db.Cards)
		keys = append(keys, "card_attrs")
	}
	if len(deploy.CardAttrs2) > 0 {
		db.CardAttrs2 = schemeutil.UpdateCardAttrs(db.CardAttrs2, deploy.CardAttrs2, db.Cards)
		keys = append(keys, "card_attrs2")
	}
	if len(deploy.CrossCardAttrs) > 0 {
		db.CrossCardAttrs = schemeutil.UpdateCardAttrs(db.CrossCardAttrs, deploy.CrossCardAttrs, db.CrossCards)
		keys = append(keys, "cross_card_attrs")
	}
	if len(deploy.CrossCardAttrs2) > 0 {
		db.CrossCardAttrs2 = schemeutil.UpdateCardAttrs(db.CrossCardAttrs2, deploy.CrossCardAttrs2, db.CrossCards)
		keys = append(keys, "cross_card_attrs2")
	}
	r.SetDirty(keys...)

	// PassiveSkills
	if len(deploy.PassiveSkills) > 0 {
		r.SetPassiveSkills(deploy.PassiveSkills)
	}
	if len(deploy.CrossPassiveSkills) > 0 {
		r.SetCrossPassiveSkills(deploy.CrossPassiveSkills)
	}
}

// 阵容重置
func (r *GymRecord) resetCards() {
	_, unlock := r.LockAndGetDB()
	defer unlock()

	// cards
	r.SetCards([]document.ID{})
	r.SetCrossCards([]document.ID{})

	// CardAttrs
	r.SetCardAttrs(map[document.ID]*scheme.CardBattleModel{})
	r.SetCrossCardAttrs(map[document.ID]*scheme.CardBattleModel{})

	// PassiveSkills
	r.SetPassiveSkills(map[document.Integer]int{})
	r.SetCrossPassiveSkills(map[document.Integer]int{})
}

// 添加日志
func (r *GymRecord) addLog(logInfo scheme.GymLogInfo) {
	db, unlock := r.LockAndGetDB()
	defer unlock()
	logs := db.Logs
	logs = append(logs, logInfo)
	// 日志数量限制
	logLimit := GetConfig().GymLogLimit
	if len(logs) > logLimit {
		logs = logs[:logLimit]
	}
	r.SetLogs(logs)
}

// 设置结束日志数据
func (r *GymRecord) setCloseLog(info scheme.GymCloseInfo) {
	db, unlock := r.LockAndGetDB()
	defer unlock()
	closeInfo := db.GymCloseInfo
	if info.PassNum != 0 {
		closeInfo.PassNum = info.PassNum
	}
	if info.CrossGymID != 0 {
		closeInfo.CrossGymID = info.CrossGymID
	}
	if info.LeaderGymID != 0 {
		closeInfo.LeaderGymID = info.LeaderGymID
	}
	if info.CrossLeaderGymID != 0 {
		closeInfo.CrossLeaderGymID = info.CrossLeaderGymID
	}
	r.SetGymCloseInfo(closeInfo)
}

// 构建对战详情
func (r *GymRecord) newHistory(model *scheme.GymPlayRecordObject, crossKey string) *scheme.GymBattleHistory {
	r.Lock()
	defer r.Unlock()

	h := scheme.GymBattleHistory{}

	cardAttrs := map[document.ID]*scheme.CardSlimModel{}
	for id, v := range model.CardAttrs() {
		cardAttrs[id] = &scheme.CardSlimModel{
			CardId:        v.CardId,
			FightingPoint: v.FightingPoint,
			NatureChoose:  v.NatureChoose,
			Level:         v.Level,
			Star:          v.Star,
			Advance:       v.Advance,
			SkinId:        v.SkinId,
		}
	}
	defenceCardAttrs := map[document.ID]*scheme.CardSlimModel{}
	for id, v := range model.DefenceCardAttrs() {
		defenceCardAttrs[id] = &scheme.CardSlimModel{
			CardId:        v.CardId,
			FightingPoint: v.FightingPoint,
			NatureChoose:  v.NatureChoose,
			Level:         v.Level,
			Star:          v.Star,
			Advance:       v.Advance,
			SkinId:        v.SkinId,
		}
	}
	// 进攻方 1
	if r.GetID() == model.RecordDbId() {
		h = scheme.GymBattleHistory{
			Result:       model.Result(),
			CrossKey:     crossKey,
			PlayRecordID: model.GetID(),

			RoleID:    model.RoleDbId(),
			RoleKey:   model.RoleKey(),
			RecordID:  model.RecordDbId(),
			Name:      model.Name(),
			Logo:      model.Logo(),
			Frame:     model.Frame(),
			Level:     model.Level(),
			Vip:       model.Vip(),
			Cards:     model.Cards(),
			CardAttrs: cardAttrs,

			DefenceRoleID:    model.DefenceRoleDbId(),
			DefenceRoleKey:   model.DefenceRoleKey(),
			DefenceRecordID:  model.DefenceRecordId(),
			DefenceName:      model.DefenceName(),
			DefenceLogo:      model.DefenceLogo(),
			DefenceFrame:     model.DefenceFrame(),
			DefenceLevel:     model.DefenceLevel(),
			DefenceVip:       model.DefenceVip(),
			DefenceCards:     model.DefenceCards(),
			DefenceCardAttrs: defenceCardAttrs,
		}
	} else if r.GetID() == model.DefenceRecordId() {
		result := "win"
		if model.Result() == "win" {
			result = "fail"
		}
		h = scheme.GymBattleHistory{
			Result:       result,
			CrossKey:     crossKey,
			PlayRecordID: model.GetID(),

			RoleID:    model.DefenceRoleDbId(),
			RoleKey:   model.DefenceRoleKey(),
			RecordID:  model.DefenceRecordId(),
			Name:      model.DefenceName(),
			Logo:      model.DefenceLogo(),
			Frame:     model.DefenceFrame(),
			Level:     model.DefenceLevel(),
			Vip:       model.DefenceVip(),
			Cards:     model.DefenceCards(),
			CardAttrs: defenceCardAttrs,

			DefenceRoleID:    model.RoleDbId(),
			DefenceRoleKey:   model.RoleKey(),
			DefenceRecordID:  model.RecordDbId(),
			DefenceName:      model.Name(),
			DefenceLogo:      model.Logo(),
			DefenceFrame:     model.Frame(),
			DefenceLevel:     model.Level(),
			DefenceVip:       model.Vip(),
			DefenceCards:     model.Cards(),
			DefenceCardAttrs: cardAttrs,
		}
	}
	return &h
}

// 清除本周日志
func (r *GymRecord) clearLogs() {
	db, unlock := r.LockAndGetDB()
	defer unlock()
	r.SetLastLogs(db.Logs)
	r.SetLogs([]scheme.GymLogInfo{})

	r.SetLastGymCloseInfo(db.GymCloseInfo)
	r.SetGymCloseInfo(scheme.GymCloseInfo{})
}

// 清除全部日志
func (r *GymRecord) clearAllLogs() {
	_, unlock := r.LockAndGetDB()
	defer unlock()
	r.SetLastLogs([]scheme.GymLogInfo{})
	r.SetLogs([]scheme.GymLogInfo{})

	r.SetLastGymCloseInfo(scheme.GymCloseInfo{})
	r.SetGymCloseInfo(scheme.GymCloseInfo{})
}

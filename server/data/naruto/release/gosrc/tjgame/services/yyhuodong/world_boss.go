package yyhuodong

import (
	"errors"
	"sort"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/util"
)

type WorldBossGlobal struct {
	*scheme.WorldBossGlobalObject

	worldBossRoleRank  []scheme.WorldBossRole
	worldBossUnionRank []worldBossUnionRankItem
	damageSum          int
}

func (w *WorldBossGlobal) init() {
	db, unlock := w.LockAndGetDB()
	defer unlock()
	// 第一次开活动等级为 100
	if db.LastLevel == 0 {
		db.LastLevel = WorldBossInitLevel
	}
	db.LastLevel = WorldBossLevelCheck(db.LastLevel)
	w.SetLastLevel(db.LastLevel)
	w.resortUnionRank()
	w.resortRoleRank()
}

func (w *WorldBossGlobal) main() RespWorldBossMain {
	db := w.GetLockedDB()
	return RespWorldBossMain{
		BossLevel: db.LastLevel,
		DamageSum: w.damageSum,
	}
}

func (w *WorldBossGlobal) updateUnionDamage(union *scheme.WorldBossUnionInfo, roleID document.ID, damage int) {
	db := w.GetLockedDB()
	if _, ok := db.Unions[union.ID]; !ok {
		db.Unions[union.ID] = &scheme.WorldBossUnion{
			DamageSum:   0,
			DamageRoles: make(map[document.ID]int),
		}
	}
	db.Unions[union.ID].WorldBossUnionInfo = *union
	db.Unions[union.ID].DamageRoles[roleID] = damage
	newDamageSum := 0
	for _, damage := range db.Unions[union.ID].DamageRoles {
		newDamageSum += damage
	}
	db.Unions[union.ID].DamageSum = newDamageSum
	w.SetUnions(db.Unions)
}

func (w *WorldBossGlobal) updateRoleDamage(role *scheme.WorldBossRole) int {
	db := w.GetLockedDB()
	db.Roles[role.Role.ID] = role
	w.SetRoles(db.Roles)
	w.resortRoleRank()
	return w.damageSum
}

func (w *WorldBossGlobal) resortUnionRank() {
	db := w.GetLockedDB()

	ranks := &ranks{
		items: make([]rankItem, 0, len(db.Unions)),
	}
	for unionID, union := range db.Unions {
		ranks.items = append(ranks.items, rankItem{
			id: unionID,
			items: map[string]int{
				"damage_sum": union.DamageSum,
				"level":      union.Level,
			},
		})
	}
	ranks.keys = []string{"damage_sum", "level"}
	sort.Sort(ranks)
	newRank := make([]worldBossUnionRankItem, 0, len(db.Unions))
	for idx, item := range ranks.items {
		rank := idx + 1
		db.Unions[item.id].Rank = rank
		newRank = append(newRank, worldBossUnionRankItem{
			WorldBossUnionInfo: db.Unions[item.id].WorldBossUnionInfo,
			Damage:             db.Unions[item.id].DamageSum,
		})
	}
	w.SetUnions(db.Unions)
	w.worldBossUnionRank = newRank
}

func (w *WorldBossGlobal) resortRoleRank() {
	db := w.GetLockedDB()

	ranks := &ranks{
		items: make([]rankItem, 0, len(db.Roles)),
	}
	for roleID, role := range db.Roles {
		ranks.items = append(ranks.items, rankItem{
			id: roleID,
			items: map[string]int{
				"boss_damage": role.BossDamage,
				"level":       role.Role.Level,
			},
		})
	}
	ranks.keys = []string{"boss_damage", "level"}
	sort.Sort(ranks)
	newRank := make([]scheme.WorldBossRole, 0, len(db.Roles))
	damageSum := 0
	for idx, item := range ranks.items {
		rank := idx + 1
		db.Roles[item.id].Rank = rank
		damageSum += db.Roles[item.id].BossDamage
		newRank = append(newRank, *db.Roles[item.id])
	}
	w.SetRoles(db.Roles)
	w.worldBossRoleRank = newRank
	w.damageSum = damageSum
}

func (w *WorldBossGlobal) getRankInfo(roleID, unionID document.ID) RespWorldBossRankInfo {
	db := w.GetLockedDB()

	roleRank := RespWorldBossRoleRank{
		Ranks: make([]scheme.WorldBossRole, 0, WorldBossRankSize),
	}
	roleRankLen := len(w.worldBossRoleRank)
	if roleRankLen <= WorldBossRankSize {
		roleRank.Ranks = w.worldBossRoleRank
	} else {
		roleRank.Ranks = w.worldBossRoleRank[:WorldBossRankSize]
	}
	if roleInfo, ok := db.Roles[roleID]; ok {
		roleRank.SelfRank = roleInfo.Rank
		roleRank.SelfDamage = roleInfo.BossDamage
	}

	unionRank := RespWorldBossUnionRank{
		Ranks: make([]worldBossUnionRankItem, 0, WorldBossRankSize),
	}
	unionRankLen := len(w.worldBossUnionRank)
	if unionRankLen <= WorldBossRankSize {
		unionRank.Ranks = w.worldBossUnionRank
	} else {
		unionRank.Ranks = w.worldBossUnionRank[:WorldBossRankSize]
	}
	if unionInfo, ok := db.Unions[unionID]; ok {
		unionRank.SelfRank = unionInfo.Rank
		unionRank.SelfDamage = unionInfo.DamageSum
	}

	return RespWorldBossRankInfo{
		RoleRank:  roleRank,
		UnionRank: unionRank,
	}
}

func (w *WorldBossGlobal) getWorldBossUnionRankAll() []document.ID {
	ret := []document.ID{}
	for _, item := range w.worldBossUnionRank {
		ret = append(ret, item.ID)
	}
	return ret
}

func (w *WorldBossGlobal) rankEnd(huodongID int) (RespWorldBossDayEnd, error) {
	ret := RespWorldBossDayEnd{
		RankRoles:  make([]document.ID, 0, len(w.worldBossRoleRank)),
		RankUnions: make([]document.ID, 0, len(w.worldBossUnionRank)),
	}
	cfg := GetConfig()

	var ok bool
	baseHP, ok := cfg.WorldBossHP[huodongID]
	if !ok {
		return ret, errors.New("huodongID error")
	}

	db := w.GetLockedDB()
	hpFix, ok := cfg.WorldBossHPFix[db.LastLevel]
	if !ok {
		return ret, errors.New("hpFix error")
	}

	targetDamage := int(float64(baseHP) * hpFix / 100)

	roleDamageSum := 0
	for _, item := range w.worldBossRoleRank {
		ret.RankRoles = append(ret.RankRoles, item.Role.ID)
		roleDamageSum += item.BossDamage
	}

	ret.FinishGoal = roleDamageSum >= targetDamage

	for _, item := range w.worldBossUnionRank {
		ret.RankUnions = append(ret.RankUnions, item.ID)
	}

	return ret, nil
}

func (w *WorldBossGlobal) clear() {
	db := w.GetLockedDB()
	db.LastUnions = db.Unions
	db.LastRoles = db.Roles
	db.Unions = make(map[document.ID]*scheme.WorldBossUnion)
	db.Roles = make(map[document.ID]*scheme.WorldBossRole)
	w.SetUnions(db.Unions)
	w.SetLastUnions(db.LastUnions)
	w.SetRoles(db.Roles)
	w.SetLastRoles(db.LastRoles)
	w.worldBossUnionRank = []worldBossUnionRankItem{}
	w.worldBossRoleRank = []scheme.WorldBossRole{}
	w.damageSum = 0
}

func (w *WorldBossGlobal) updateLevel(finishGoal bool) {
	db := w.GetLockedDB()
	var newLevel int
	if finishGoal {
		newLevel = db.LastLevel + 1
	} else {
		newLevel = db.LastLevel - 1
	}
	db.LastLevel = WorldBossLevelCheck(newLevel)
	w.SetLastLevel(db.LastLevel)
}

func (w *WorldBossGlobal) recordLastEnd(yyID int) {
	db := w.GetLockedDB()
	db.LastYYID = yyID
	db.LastDate = util.Todaydate2int()
	w.SetLastYYID(db.LastYYID)
	w.SetLastDate(db.LastDate)
}

func (w *WorldBossGlobal) unionDissolve(unionID document.ID) {
	db := w.GetLockedDB()
	delete(db.Unions, unionID)
	w.SetUnions(db.Unions)
}

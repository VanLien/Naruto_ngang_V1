package gym

import (
	"sync"
	"tjgame/document"
	"tjgame/document/scheme"
)

type gymCompetitor struct {
	ID     document.ID `codec:"id"`
	Name   string      `codec:"name"`
	Level  int         `codec:"level"`
	Logo   int         `codec:"logo"`
	Frame  int         `codec:"frame"`
	Figure int         `codec:"figure"`
	Vip    int         `codec:"vip"`
}

type gymDeployment struct {
	Cards         []document.ID                           `codec:"cards"`
	CardAttrs     map[document.ID]*scheme.CardBattleModel `codec:"card_attrs"`
	CardAttrs2    map[document.ID]*scheme.CardBattleModel `codec:"card_attrs2"`
	PassiveSkills map[document.Integer]int                `codec:"passive_skills"`

	CrossCards         []document.ID                           `codec:"cross_cards"`
	CrossCardAttrs     map[document.ID]*scheme.CardBattleModel `codec:"cross_card_attrs"`
	CrossCardAttrs2    map[document.ID]*scheme.CardBattleModel `codec:"cross_card_attrs2"`
	CrossPassiveSkills map[document.Integer]int                `codec:"cross_passive_skills"`
}

type viefor struct {
	role        document.ID
	record      document.ID
	enemy       document.ID
	enemyRecord document.ID
	time        int64
}

// 战斗信息
type battle struct {
	enemyRoleID   document.ID
	enemyRecordID document.ID
	gymID         int
	playRecordID  document.ID

	mu     sync.Mutex
	result result
}

// 战斗结果
type result struct {
	client    string
	anticheat string
}

// 战斗结束返回
type ResponseBattleEnd struct {
	Cards []document.ID `codec:"cards"`
}

// event同步
type EventToGame struct {
	// 副本关卡 {gymID: {degree: gateID}}
	GymGates map[int]map[int]int `codec:"gym_gates"`
	// 荣誉馆主奖励 {gymID: roleID}
	LeaderRoleIDs map[document.Integer]document.ID `codec:"leader_role_ids"`
	// 上期 馆主相关信息 {gymID: Object}
	LastLeaderRoles map[document.Integer]*scheme.GymRoleInfo `codec:"last_leader_roles"`
}

type SyncModel struct {
}

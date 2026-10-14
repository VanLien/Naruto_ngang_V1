package gym

import (
	"sync"
	"tjgame/document"
	"tjgame/document/scheme"
)

// init同步game数据
type DBForGame struct {
	Servers []string `codec:"servers"`
	CsvId   int      `codec:"csv_id"`
	Date    int      `codec:"date"`
	Round   string   `codec:"round"`
}

// event同步 cross => game（需求部分数据）
type EventToGame struct {
	// init同步数据
	Model *DBForGame `codec:"model,omitempty"`
	// 跨服馆主奖励 {gymID: roleID}
	CrossLeaderRoleIDs map[document.Integer]document.ID `codec:"cross_leader_role_ids"`
	// 跨服馆员奖励 {gymID: [roleID]}
	CrossGeneralRoleIDs map[document.Integer][]document.ID `codec:"cross_general_role_ids"`
	// 上期 跨服馆员相关信息 {gymID: {pos: Object}} 默认第一位是跨服馆主
	LastCrossGymRoles map[document.Integer]map[document.Integer]*scheme.CrossGymRoleInfo `codec:"last_cross_gym_roles"`
}

// event同步 cross => game（同步全部数据）
type SyncModel struct {
	Round string `codec:"round"`
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
	pos           int
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
	Cards        []document.ID `codec:"cards"`
	IsSwapDeploy bool          `codec:"is_swap_deploy"`
}

// 战斗结束返回
type ResponseBattleEndUpdate struct {
	Cards          []document.ID     `codec:"cards"`
	IsSwapDeploy   bool              `codec:"is_swap_deploy"`
	LogInfo        scheme.GymLogInfo `codec:"log_info"`
	DefenceLogInfo scheme.GymLogInfo `codec:"defence_log_info"`
}

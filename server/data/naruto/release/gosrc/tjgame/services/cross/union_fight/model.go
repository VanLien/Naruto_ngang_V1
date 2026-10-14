/*
 * @Date    : 2021/9/9 22:39
 * @File    : model.go
 * @Version : 1.0.0
 * @Author  : hss
 * @Note    :
 *
 */

package union_fight

import (
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/services/anti-cheat/manager"
)

type Config struct {
	WinPointMap   map[int]int
	FailPointMap  map[int]int
	ExtraPointMap map[int]int
}

// init同步game数据
type DBForGame struct {
	Servers    []string      `codec:"servers"`
	CsvId      int           `codec:"csv_id"`
	Date       int           `codec:"date"`
	Status     string        `codec:"status"`
	JoinUnions []document.ID `codec:"join_unions"`
	JoinRoles  []document.ID `codec:"join_roles"`
}

// event 事件
type EventToGame struct {
	// init同步数据
	Model *DBForGame `codec:"model,omitempty"`

	// 排行榜 {组别: [CrossUnionFightRankPoint]}
	LastRanks map[document.Integer][]*scheme.CrossUnionFightRankPoint `codec:"last_ranks,omitempty"`

	// 竞猜 {组别: {公会ID: [CrossUnionFightBet]}
	LastBets map[document.Integer]map[document.ID]*scheme.CrossUnionFightBet `codec:"last_bets,omitempty"`

	// 战报 {组别: {战场: [CrossUnionFightResultInfo]}}
	LastResults map[document.Integer]map[document.Integer][]*scheme.CrossUnionFightResultInfo `codec:"last_results,omitempty"`

	// 公会人员名单 用于发奖励
	UnionRoles map[document.ID][]document.ID `codec:"union_roles,omitempty"`

	// 参与公会
	UnionIDs []document.ID `codec:"union_ids,omitempty"`

	// 参与玩家
	RoleIDs []document.ID `codec:"role_ids,omitempty"`

	// 上期公会
	LastUnions map[document.ID]*scheme.CrossUnionFightGameUnion `bson:"last_unions" codec:"last_unions"`

	// 上期玩家
	LastRoles map[document.ID]*scheme.CrossUnionFightRole `bson:"last_roles" codec:"last_roles"`

	// 上期战斗组 {组别: [unionID]}
	LastBattleGroups map[document.Integer][]document.ID `bson:"last_battle_groups" codec:"last_battle_groups"`

	// 押注名单 (暂不用)
	BetRoles []document.ID `codec:"bet_roles,omitempty"`
}

// event sync 数据
type SyncModel struct {
	Status string `codec:"status"`
}

// main请求roleInfo
type ResRoleInfo struct {
	RoleDbId   document.ID `codec:"role_db_id"`
	RecordID   document.ID `codec:"record_id"`
	ServerKey  string      `codec:"server_key"`
	RoleName   string      `codec:"role_name"`
	RoleLogo   int         `codec:"role_logo"`
	RoleFrame  int         `codec:"role_frame"`
	RoleLevel  int         `codec:"role_level"`
	RoleFigure int         `codec:"role_figure"`

	UnionDbId      document.ID `codec:"union_db_id"`
	UnionName      string      `codec:"union_name,omitempty"`
	UnionLogo      int         `codec:"union_logo,omitempty"`
	ChairmanID     document.ID `codec:"chairman_id,omitempty"`
	ChairmanName   string      `codec:"chairman_name,omitempty"`
	ChairmanFigure int         `codec:"chairman_figure,omitempty"`
	ChairmanTitle  int         `codec:"chairman_title,omitempty"`
}

// 会长信息
type RespChairmanInfo struct {
	ChairmanName   string `codec:"chairman_name"`
	ChairmanFigure int    `codec:"chairman_figure"`
	ChairmanTitle  int    `codec:"chairman_title"`
}

// main响应model
type RespMainModel struct {
	// 初赛 战斗组 {组别: [CrossUnionFightUnion]}
	PreBattleGroups map[document.Integer][]*scheme.CrossUnionFightUnion `codec:"pre_battle_groups"`
	// 决赛 名单 [CrossUnionFightUnion]
	TopBattleGroups []*scheme.CrossUnionFightUnion `codec:"top_battle_groups"`

	// 参与公会 {unionID: CrossUnionFightUnionInfo}
	Unions map[document.ID]*scheme.CrossUnionFightUnionInfo `bson:"unions" codec:"unions"`
	// 参与玩家 {roleID: CrossUnionFightRoleInfo}
	Roles map[document.ID]*scheme.CrossUnionFightRoleInfo `bson:"roles" codec:"roles"`
}

type RoleInfo struct {
	RoleID    document.ID
	RecordID  document.ID
	ServerKey string
	UnionID   document.ID
}

type BattleRoundInfo struct {
	Group              int
	BattleType         int
	Round              int
	Troop              int
	DefenceTroop       int
	CardStates         map[document.ID][2]float64
	DefenceCardStates  map[document.ID][2]float64
	BattleTimes        int
	DefenceBattleTimes int
}

type ReqRoleInfo struct {
	RoleID    document.ID `codec:"role_id,omitempty"`
	UnionID   document.ID `codec:"union_id,omitempty"`
	ServerKey string      `codec:"server_key,omitempty"`
}

type antiResultChan struct {
	AntiResult map[document.ID]manager.Result
}

type PlayModel struct {
	// playID
	ID document.ID `bson:"id" codec:"id"`
	// 战斗分组
	Group int `bson:"group" codec:"group"`
	// 战斗类型
	BattleType int `bson:"battle_type" codec:"battle_type"`
	// 战斗场次
	Round int `bson:"round" codec:"round"`
}

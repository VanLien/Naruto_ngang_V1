package union_fight

import (
	"tjgame/document"
	"tjgame/document/scheme"
)

type Config struct {
	BetRateFix       float64
	MinBetRate       float64
	MaxBetWin        int
	LastWinRolePoint int
	BattleWinPoint   int
	BattleFailPoint  int
	BattleFixMap     map[int]map[string]float64
	PointFix         map[int]int
}

type roundItem struct {
	next string
}

type RoleUnionFightView struct {
	RoleInfo  RespRoleInfo  `codec:"role_info"`
	UnionInfo RespUnionInfo `codec:"union_info"`
	Model     RespModel     `codec:"model"`
}

type RespRoleInfo struct {
	Cards     DeployCards                             `codec:"cards"`
	CardAttrs map[document.ID]*scheme.CardBattleModel `codec:"card_attrs"`
	IsOut     bool                                    `codec:"isout,omitempty"`
}

type Top8EnemyUnion struct {
	UnionID      document.ID `codec:"union_id"`
	Name         string      `codec:"name"`
	Logo         int         `codec:"logo"`
	Top8RoundKey int         `codec:"top8_round_key"`
	Level        int         `codec:"level"`
}

type RespUnionInfo struct {
	IsOut          bool           `codec:"is_out"`           // 是否淘汰
	MemberNum      int            `codec:"member_num"`       // 成员数
	SignNum        int            `codec:"sign_num"`         // 报名人数
	LiveNum        int            `codec:"live_num"`         // 存活人数
	CurRank        int            `codec:"cur_rank"`         // 当前排名
	CurPoint       int            `codec:"cur_point"`        // 本轮积分
	LastRoleName   string         `codec:"last_role_name"`   // 最后一个存活的角色
	TopsDeploy     Top8DeployInfo `codec:"top8_deploy"`      // top8 布阵
	Top8EnemyUnion Top8EnemyUnion `codec:"top8_enemy_union"` // top8 对阵公会
	Top8RoundKey   int            `codec:"top8_round_key"`   // 晋级后的 top8 key
	RoundMax       int            `codec:"round_max"`        // 最大轮次
	BattleStarNum  int            `codec:"battle_star_num"`  // 战斗之星数量
}

type RespModel struct {
	PrepareEndTime       float64                                                `codec:"prepare_end_time"`
	NextRoundResultTime  float64                                                `codec:"next_round_result_time"`
	NextRoundBattleTime  float64                                                `codec:"next_round_battle_time"`  // top8 下一次战斗的时间点
	NextRoundPrepareTime float64                                                `codec:"next_round_prepare_time"` // top8 下一次预备的时间点
	RoundResults         map[interface{}][]scheme.UnionFightResultInfo          `codec:"round_results"`
	FinalResult          []scheme.UnionFightFinalResultItem                     `codec:"final_result"`
	LastRoleName         string                                                 `codec:"last_role_name"`
	LastUnionName        string                                                 `codec:"last_union_name"`
	Top8VSInfo           map[document.Integer]*scheme.UnionFightTop8VSUnionInfo `codec:"top8_vs_info"`
	BattleStars          map[document.Integer]map[document.Integer]int          `codec:"battle_stars"`
	UnionBattleStatus    map[document.ID]UnionBattleStatuItem                   `codec:"union_battle_status"`
}

type UnionBattleStatuItem struct {
	_struct struct{} `codec:",toarray"`

	LiveNum int
	SignNum int
	Name    string
}

type roleCompetitor struct {
	ID        document.ID `codec:"id"`
	Name      string      `codec:"name"`
	Level     int         `codec:"level"`
	Logo      int         `codec:"logo"`
	Frame     int         `codec:"frame"`
	Figure    int         `codec:"figure"`
	UnionDbId document.ID `codec:"union_db_id"`
}

type unionCompetitor struct {
	ID    document.ID `codec:"id"`
	Name  string      `codec:"name"`
	Level int         `codec:"level"`
	Logo  int         `codec:"logo"`
}

type deployment struct {
	Cards         scheme.UnioinFightCards                 `codec:"cards"`
	CardAttrs     map[document.ID]*scheme.CardBattleModel `codec:"card_attrs"`
	CardAttrs2    map[document.ID]*scheme.CardBattleModel `codec:"card_attrs2"`
	PassiveSkills map[document.Integer]int                `codec:"passive_skills"`
}

type UnionIDAndRoleNum struct {
	UnionID document.ID
}

type RoundResult struct {
	PlayID document.ID `codec:"play_id"`
}

type Top8DeployCardInfo struct {
	_struct struct{} `codec:",toarray"`

	CardID  int `codec:"card_id"`
	SkinID  int `codec:"skin_id"`
	Hp      int `codec:"hp"`
	Level   int `codec:"level"`
	Star    int `codec:"star"`
	Advance int `codec:"advance"`
}

type DeployCardInfo struct {
	_struct struct{} `codec:",toarray"`

	ID      document.ID `codec:"id,omitempty"`
	CardID  int         `codec:"card_id"`
	SkinID  int         `codec:"skin_id"`
	Fp      int         `codec:"fp"`
	Level   int         `codec:"level"`
	Star    int         `codec:"star"`
	Advance int         `codec:"advance"`
}

type DeployCards map[document.Integer]map[document.Integer][6]*DeployCardInfo

type Top8DeployRoleTroopsInfo struct {
	Cards    [6]*Top8DeployCardInfo `codec:"cards"`
	TroopsFp int                    `codec:"troops_fp"`
}

type Top8DeployRoleInfo struct {
	scheme.UnionFightRole `bson:",inline"`
	Troops                map[int]Top8DeployRoleTroopsInfo `codec:"troops"`
	TotalFP               int                              `codec:"total_fp"`
}

type Top8DeployInfo struct {
	Roles    []document.ID                      `codec:"roles"`
	RoleInfo map[document.ID]Top8DeployRoleInfo `codec:"role_info"`
}

type RespRankInfo struct {
	RoleRank    []scheme.UnionFightRoleRankItem  `codec:"role_rank"`
	UnionRank   []scheme.UnionFightUnionRankItem `codec:"union_rank"`
	MyUnionRank scheme.UnionFightRankOnceItem    `codec:"my_union_rank"`
	MyRank      scheme.UnionFightRankOnceItem    `codec:"my_rank"`
}

type EventToGame struct {
	// 下注结果数据
	UnionFightBets map[document.ID][3]interface{} `codec:"union_fight_bets,omitempty"`

	// 公会排名
	RankUnions []UnionRankAwardItem `codec:"rank_unions,omitempty"`

	// 角色排名
	RankRoles []RoleRankAwardItem `codec:"rank_roles,omitempty"`

	// 八强公会
	Top8VSUnion map[document.ID][]document.ID `codec:"top8_vs_union,omitempty"`
}

type SyncModel struct {
	Round string `codec:"round"`
}

type MatchItem struct {
	roleID    document.ID
	troopsNum int
}

type YesterdayInfo struct {
	UnionInfo    scheme.UnionFightUUnionYesterdayInfo  `codec:"union_info"`
	RoundResults map[int][]scheme.UnionFightResultInfo `codec:"round_results"`
}

type UnionRankAwardItem struct {
	_struct struct{} `codec:",toarray"`

	UnionID document.ID
	Rank    int
}

type RoleRankAwardItem struct {
	_struct struct{} `codec:",toarray"`

	RoleID  document.ID
	KillNum int
}

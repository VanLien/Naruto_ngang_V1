package scheme

import "tjgame/document"

// {初/决: {战场: [cardID]}} (初:1 决:2)
type CrossUnionFightCards map[document.Integer]map[document.Integer][]document.ID

/*
**
** 部屋大作战 全局
**
 */
type CrossUnionFightGlobal struct {
	document.DocumentID `bson:",inline"`

	// cross_key
	Key string `bson:"key" codec:"key" unique:"true"`
	// 参与的server [node key list]
	Servers []string `bson:"servers" codec:"servers"`
	// service.csv的CSV ID
	CsvId int `bson:"csv_id" codec:"csv_id"`
	// 开始日期
	Date int `bson:"date" codec:"date"`

	// 参与公会 {unionID: CrossUnionFightUnionInfo}
	Unions map[document.ID]*CrossUnionFightUnionInfo `bson:"unions" codec:"unions"`
	// 参与玩家 {roleID: CrossUnionFightRoleInfo}
	Roles map[document.ID]*CrossUnionFightRoleInfo `bson:"roles" codec:"roles"`

	// 初赛 战斗组 {组别: [CrossUnionFightUnion]}
	PreBattleGroups map[document.Integer][]*CrossUnionFightUnion `bson:"pre_battle_groups" codec:"pre_battle_groups"`
	// 决赛 名单 [CrossUnionFightUnion]
	TopBattleGroups []*CrossUnionFightUnion `bson:"top_battle_groups" codec:"top_battle_groups"`

	// 初赛 排行榜 {组别: [CrossUnionFightRankPoint]}
	PrePointRanks map[document.Integer][]*CrossUnionFightRankPoint `bson:"pre_point_ranks" codec:"pre_point_ranks"`
	// 决赛 排行榜 [CrossUnionFightRankPoint]
	TopPointRanks []*CrossUnionFightRankPoint `bson:"top_point_ranks" codec:"top_point_ranks"`

	// 初赛 战报  {组别: {战场: [CrossUnionFightResultInfo]}}
	PreRoundResults map[document.Integer]map[document.Integer][]*CrossUnionFightResultInfo `bson:"pre_round_results" codec:"pre_round_results"`
	// 决赛 战报  {战场: [CrossUnionFightResultInfo]}
	TopRoundResults map[document.Integer][]*CrossUnionFightResultInfo `bson:"top_round_results" codec:"top_round_results"`

	// 初/决赛 竞猜 {组别: {公会ID: CrossUnionFightBet} 决赛用5
	Bets map[document.Integer]map[document.ID]*CrossUnionFightBet `bson:"bets" codec:"bets"`

	// 状态
	Status string `bson:"status" codec:"status" default:"closed"`
	// 状态 修改时间
	Time int64 `bson:"time" codec:"time"`
}

// 公会玩法中信息
type CrossUnionFightUnionInfo struct {
	CrossUnionFightUnion `bson:",inline"`
	LiveCount            int                                `bson:"live_count" codec:"live_count"`
	IsOut                bool                               `bson:"is_out" codec:"is_out" default:"false"`
	Point                int                                `bson:"point" codec:"point"`
	WinNum               int                                `bson:"win_num" codec:"win_num"`
	RoleDbIds            []document.ID                      `bson:"role_db_ids" codec:"role_db_ids"`
	FpRank               int                                `bson:"fp_rank" codec:"fp_rank"`
	Group                int                                `bson:"group" codec:"group"`
	PreDeployRoles       map[document.Integer][]document.ID `bson:"pre_deploy_roles" codec:"pre_deploy_roles"`
	TopDeployRoles       map[document.Integer][]document.ID `bson:"top_deploy_roles" codec:"top_deploy_roles"`
}

// 角色玩法中信息
type CrossUnionFightRoleInfo struct {
	CrossUnionFightRole `bson:",inline"`
	Point               int                                             `bson:"point" codec:"point"`
	IsOut               bool                                            `bson:"is_out" codec:"is_out" default:"false"`
	CurTroop            int                                             `bson:"cur_troop" codec:"cur_troop"`       // 当前队伍
	CardState           map[document.Integer]map[document.ID][2]float64 `bson:"card_state" codec:"card_state"`     // 血量 {队伍: {卡牌: (hp, mp)}}
	Projects            map[document.Integer]int                        `bson:"projects" codec:"projects"`         // 战场 {初/决: 战场类型}(1=常规 2=车轮 3=单挑)
	BattleTimes         int                                             `bson:"battle_times" codec:"battle_times"` // 真实进入战斗的次数
}

// 公会积分排行
type CrossUnionFightRankPoint struct {
	CrossUnionFightUnion `bson:",inline"`
	Point                int `bson:"point" codec:"point"`             // 汇总积分
	AliveCount           int `bson:"alive_count" codec:"alive_count"` // 存活人数
	WinNum               int `bson:"win_num" codec:"win_num"`         // 总胜场
}

// 竞猜
type CrossUnionFightBet struct {
	RoleKeys []RoleKey `bson:"role_keys" codec:"role_keys"`
	Success  bool      `bson:"success" codec:"success"` // 是否预测成功
}

// 公会基本信息
type CrossUnionFightUnion struct {
	UnionDbId      document.ID `bson:"union_db_id" codec:"union_db_id"`
	UnionName      string      `bson:"union_name" codec:"union_name"`
	UnionLogo      int         `bson:"union_logo" codec:"union_logo"`
	ServerKey      string      `bson:"server_key" codec:"server_key"`           // 区服
	SignsCount     int         `bson:"signs_count" codec:"signs_count"`         // 参赛人数
	ChairmanDbID   document.ID `bson:"chairman_db_id" codec:"chairman_db_id"`   // 会长ID
	ChairmanName   string      `bson:"chairman_name" codec:"chairman_name"`     // 会长名字
	ChairmanFigure int         `bson:"chairman_figure" codec:"chairman_figure"` // 会长形象
	ChairmanTitle  int         `bson:"chairman_title" codec:"chairman_title"`   // 会长称号
	FightingPoint  int         `bson:"fighting_point" codec:"fighting_point"`   // 公会总战力
}

// 角色基本信息
type CrossUnionFightRole struct {
	RoleDbId      document.ID `bson:"role_db_id" codec:"role_db_id"`
	UnionDbId     document.ID `bson:"union_db_id" codec:"union_db_id"`
	RecordID      document.ID `bson:"record_id" codec:"record_id"`
	ServerKey     string      `bson:"server_key" codec:"server_key"`
	RoleName      string      `bson:"role_name" codec:"role_name"`
	RoleLogo      int         `bson:"role_logo" codec:"role_logo"`
	RoleFrame     int         `bson:"role_frame" codec:"role_frame"`
	RoleLevel     int         `bson:"role_level" codec:"role_level"`
	RoleFigure    int         `bson:"role_figure" codec:"role_figure"`
	FightingPoint int         `bson:"fighting_point" codec:"fighting_point"`
}

// 战报展示
type CrossUnionFightResultInfo struct {
	CrossKey string                    `bson:"cross_key" codec:"cross_key"`
	Round    int                       `bson:"round" codec:"round"`
	PlayID   document.ID               `bson:"play_id" codec:"play_id"`
	Result   string                    `bson:"result" codec:"result" default:"unknown"`
	Left     CrossUnionFightResultItem `bson:"left" codec:"left"`
	Right    CrossUnionFightResultItem `bson:"right" codec:"right"`
}

// 战报条目
type CrossUnionFightResultItem struct {
	RoleDbId       document.ID                `bson:"role_db_id" codec:"role_db_id"`
	RoleRecordId   document.ID                `bson:"role_record_id" codec:"role_record_id"`
	UnionDbId      document.ID                `bson:"union_db_id" codec:"union_db_id"`
	UnionName      string                     `bson:"union_name" codec:"union_name"`
	UnionPoint     int                        `bson:"union_point" codec:"union_point"`
	UnionAlive     int                        `bson:"union_alive" codec:"union_alive"`
	WinNum         int                        `bson:"win_num" codec:"win_num"`
	Troop          int                        `bson:"troop" codec:"troop"`                       // 队伍
	TroopCardState map[document.ID][2]float64 `bson:"troop_card_state" codec:"troop_card_state"` // 血量 {卡牌: (hp, mp)}
}

func (*CrossUnionFightGlobal) CollectionName() string {
	return "CrossUnionFightGlobal"
}

/*
**
** 部屋大作战 个人记录
**
 */
type CrossUnionFightRoleRecord struct {
	document.DocumentID `bson:",inline"`

	// Role.id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// Role.name
	RoleName string `bson:"role_name" codec:"role_name"`
	// Role.logo
	RoleLogo int `bson:"role_logo" codec:"role_logo"`
	// Role.frame
	RoleFrame int `bson:"role_frame" codec:"role_frame"`
	// Role.level
	RoleLevel int `bson:"role_level" codec:"role_level"`
	// Role.figure
	RoleFigure int `bson:"role_figure" codec:"role_figure"`
	// Role.title
	RoleTitle int `bson:"role_title" codec:"role_title"`

	// 部署卡牌列表
	Cards CrossUnionFightCards `bson:"cards" codec:"cards"`

	// 初赛卡牌离线属性
	CardAttrs map[document.ID]*CardBattleModel `bson:"card_attrs" codec:"card_attrs"`
	// 初赛卡牌离线属性
	CardAttrs2 map[document.ID]*CardBattleModel `bson:"card_attrs2" codec:"card_attrs2"`
	// 初赛全局被动技能
	PassiveSkills map[document.Integer]int `bson:"passive_skills" codec:"passive_skills"`
	// 初赛默认战场
	InitProject int `bson:"init_project" codec:"init_project"`

	// 决赛卡牌离线属性
	TopCardAttrs map[document.ID]*CardBattleModel `bson:"top_card_attrs" codec:"top_card_attrs"`
	// 决赛卡牌离线属性
	TopCardAttrs2 map[document.ID]*CardBattleModel `bson:"top_card_attrs2" codec:"top_card_attrs2"`
	// 决赛全局被动技能
	TopPassiveSkills map[document.Integer]int `bson:"top_passive_skills" codec:"top_passive_skills"`
	// 决赛默认战场
	TopInitProject int `bson:"top_init_project" codec:"top_init_project"`
}

func (*CrossUnionFightRoleRecord) CollectionName() string {
	return "CrossUnionFightRoleRecord"
}

/*
**
** 部屋大作战 战报记录
**
 */
type CrossUnionFightPlayRecord struct {
	document.DocumentID `bson:",inline"`

	// 战斗日期
	Date int `bson:"date" codec:"date" default:"todaydate2int" index:"true"`
	// 战斗时间
	Time float64 `bson:"time" codec:"time" default:"nowtime_t"`
	// 战斗随机种子
	RandSeed int32 `bson:"rand_seed" codec:"rand_seed"`
	// 战斗分组
	Group int `bson:"group" codec:"group"`
	// 战斗类型
	BattleType int `bson:"battle_type" codec:"battle_type"`
	// 战斗场次
	Round int `bson:"round" codec:"round"`

	// 主动进攻方 RoleKey
	RoleKey RoleKey `bson:"role_key" codec:"role_key" index:"role_key.id"`
	// 主动进攻方 ArenaRecord.id
	RecordId document.ID `bson:"record_id" codec:"record_id"`
	// 主动进攻方角色名字
	Name string `bson:"name" codec:"name"`
	// 主动进攻方角色头像ID
	Logo int `bson:"logo" codec:"logo"`
	// 主动进攻方角色头像框ID
	Frame int `bson:"frame" codec:"frame"`
	// 主动进攻方角色等级
	Level int `bson:"level" codec:"level"`
	// 主动进攻方角色形象
	Figure int `bson:"figure" codec:"figure"`
	// 主动进攻部署卡牌列表
	Cards []document.ID `bson:"cards" codec:"cards"`
	// 主动进攻卡牌离线属性
	CardAttrs map[document.ID]*CardBattleModel `bson:"card_attrs" codec:"card_attrs"`
	// 主动进攻卡牌离线属性
	CardAttrs2 map[document.ID]*CardBattleModel `bson:"card_attrs2,omitempty" codec:"card_attrs2,omitempty"`
	// 主动进攻全局被动技能
	PassiveSkills map[document.Integer]int `bson:"passive_skills" codec:"passive_skills"`
	// 主动进攻卡牌状态 {cardID:{hp, mp)}
	CardStates map[document.ID][2]float64 `bson:"card_states" codec:"card_states"`
	// 主动进攻方 真实战斗过次数
	BattleTimes int `bson:"battle_times" codec:"battle_times"`

	// 被动防御方 RoleKey
	DefenceRoleKey RoleKey `bson:"defence_role_key" codec:"defence_role_key" index:"defence_role_key.id"`
	// 被动防御方 ArenaRecord.id
	DefenceRecordId document.ID `bson:"defence_record_id" codec:"defence_record_id"`
	// 被动防御方角色名字
	DefenceName string `bson:"defence_name" codec:"defence_name"`
	// 被动防御方角色头像ID
	DefenceLogo int `bson:"defence_logo" codec:"defence_logo"`
	// 被动防御方角色头像框ID
	DefenceFrame int `bson:"defence_frame" codec:"defence_frame"`
	// 被动防御方角色等级
	DefenceLevel int `bson:"defence_level" codec:"defence_level"`
	// 主动进攻方角色形象
	DefenceFigure int `bson:"defence_figure" codec:"defence_figure"`
	// 被动防御部署卡牌列表
	DefenceCards []document.ID `bson:"defence_cards" codec:"defence_cards"`
	// 被动防御卡牌离线属性
	DefenceCardAttrs map[document.ID]*CardBattleModel `bson:"defence_card_attrs" codec:"defence_card_attrs"`
	// 被动防御卡牌离线属性
	DefenceCardAttrs2 map[document.ID]*CardBattleModel `bson:"defence_card_attrs2,omitempty" codec:"defence_card_attrs2,omitempty"`
	// 被动防御全局被动技能
	DefencePassiveSkills map[document.Integer]int `bson:"defence_passive_skills" codec:"defence_passive_skills"`
	// 被动防御卡牌状态 {cardID:{hp, mp)}
	DefenceCardStates map[document.ID][2]float64 `bson:"defence_card_states" codec:"defence_card_states"`
	// 被动防御方 真实战斗过次数
	DefenceBattleTimes int `bson:"defence_battle_times" codec:"defence_battle_times"`

	// 战斗结果
	Result string `bson:"result" codec:"result" default:"unknown"`
}

func (*CrossUnionFightPlayRecord) CollectionName() string {
	return "CrossUnionFightPlayRecord"
}

/*
**
** 部屋大作战 Game全局记录
**
 */
type CrossUnionFightGameGlobal struct {
	document.DocumentID `bson:",inline"`

	// serverKey
	Key string `bson:"key" codec:"key" unique:"true"`
	// 跨服server key
	CrossKey string `bson:"cross_key" codec:"cross_key"`
	// 开始日期
	Date int `bson:"date" codec:"date"`
	// 跨服csv_id
	CsvID int `bson:"csv_id" codec:"csv_id"`
	// 状态
	Status string `bson:"status" codec:"status" default:"closed"`

	// 上期 排行榜 {组别: [CrossUnionFightRankPoint]} 决赛用5
	LastPointRanks map[document.Integer][]*CrossUnionFightRankPoint `bson:"last_point_ranks" codec:"last_point_ranks"`

	// 上期 竞猜 {组别: {公会ID: [CrossUnionFightBet]} 决赛用5
	LastBets map[document.Integer]map[document.ID]*CrossUnionFightBet `bson:"last_bets" codec:"last_bets"`

	// 上期回顾 战报 {组别: {战场: [CrossUnionFightResultInfo]}} 决赛用5
	LastRoundResults map[document.Integer]map[document.Integer][]*CrossUnionFightResultInfo `bson:"last_round_results" codec:"last_round_results"`

	// 初赛全部竞猜正确名单 [roleID]
	PreBetSuccess []document.ID `bson:"pre_bet_success" codec:"pre_bet_success"`

	// 公会战积分排行
	UnionFightPointRank []*UnionFightPointRankInfo `bson:"union_fight_point_rank" codec:"union_fight_point_rank"`

	// 上期参与公会 {unionID: CrossUnionFightUnion}
	LastUnions map[document.ID]*CrossUnionFightGameUnion `bson:"last_unions" codec:"last_unions"`

	// 上期参与玩家 {roleID: CrossUnionFightRoleInfo}
	LastRoles map[document.ID]*CrossUnionFightRole `bson:"last_roles" codec:"last_roles"`

	// 上期战斗组 {组别: [unionID]}  决赛用5
	LastBattleGroups map[document.Integer][]document.ID `bson:"last_battle_groups" codec:"last_battle_groups"`
}

type UnionFightPointRankInfo struct {
	GameKey   string      `bson:"game_key" codec:"game_key"`
	UnionDbId document.ID `bson:"union_db_id" codec:"union_db_id"`
	UnionName string      `bson:"union_name" codec:"union_name"`
	UnionLogo int         `bson:"union_logo" codec:"union_logo"`
	Point     int         `bson:"point" codec:"point"`
}

type CrossUnionFightGameUnion struct {
	CrossUnionFightUnion `bson:",inline"`
	PreDeployRoles       map[document.Integer][]document.ID `bson:"pre_deploy_roles" codec:"pre_deploy_roles"`
	TopDeployRoles       map[document.Integer][]document.ID `bson:"top_deploy_roles" codec:"top_deploy_roles"`
}

func (*CrossUnionFightGameGlobal) CollectionName() string {
	return "CrossUnionFightGameGlobal"
}

package scheme

import "tjgame/document"

// 跨服竞技场记录
type CrossArenaRecord struct {
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
	// Role.vip_level
	RoleVip int `bson:"role_vip" codec:"role_vip"`

	// 主动进攻部署卡牌列表 {1: [cardID], 2: [cardID]}
	Cards map[document.Integer][]document.ID `bson:"cards" codec:"cards"`
	// 主动进攻卡牌离线属性 {cardID: CardBattleModel}
	CardAttrs map[document.ID]*CardBattleModel `bson:"card_attrs" codec:"card_attrs"`
	// 主动进攻卡牌离线属性 {cardID: CardBattleModel}
	CardAttrs2 map[document.ID]*CardBattleModel `bson:"card_attrs2" codec:"card_attrs2"`
	// 进攻全局被动技能
	PassiveSkills map[document.Integer]int `bson:"passive_skills" codec:"passive_skills"`

	// 被动防御部署卡牌列表 {1: [cardID], 2: [cardID]}
	DefenceCards map[document.Integer][]document.ID `bson:"defence_cards" codec:"defence_cards"`
	// 被动防御卡牌离线属性
	DefenceCardAttrs map[document.ID]*CardBattleModel `bson:"defence_card_attrs" codec:"defence_card_attrs"`
	// 被动防御卡牌离线属性
	DefenceCardAttrs2 map[document.ID]*CardBattleModel `bson:"defence_card_attrs2" codec:"defence_card_attrs2"`
	// 被动防御全局被动技能
	DefencePassiveSkills map[document.Integer]int `bson:"defence_passive_skills" codec:"defence_passive_skills"`

	// 战斗历史
	History []CrossArenaBattleHistory `bson:"history" codec:"history"`

	// 是否是机器人
	Robot bool `bson:"robot,omitempty" codec:"robot,omitempty"`
}

type CrossArenaBattleHistory struct {
	Time   float64 `bson:"time" codec:"time"`
	Result string  `bson:"result" codec:"result"`

	// CrossArenaRecord.id 录像回放
	PlayRecordID document.ID `bson:"play_record_id" codec:"play_record_id"`

	EnemyName     string      `bson:"enemy_name" codec:"enemy_name"`
	EnemyRoleID   document.ID `bson:"enemy_role_id" codec:"enemy_role_id"`
	EnemyRecordID document.ID `bson:"enemy_record_id" codec:"enemy_record_id"`
	EnemyLogo     int         `bson:"enemy_logo" codec:"enemy_logo"`
	EnemyFrame    int         `bson:"enemy_frame" codec:"enemy_frame"`
	EnemyLevel    int         `bson:"enemy_level" codec:"enemy_level"`
	EnemyVip      int         `bson:"enemy_vip" codec:"enemy_vip"`
	EnemyFight    int         `bson:"enemy_fight" codec:"enemy_fight"`
	EnemyRank     int         `bson:"enemy_rank" codec:"enemy_rank"`

	// gameKey 展示对手区服
	Key string `bson:"key" codec:"key"`
	// 进攻: 1  防守: 2
	BattleMode int `bson:"battle_mode" codec:"battle_mode"`
	// 自己排名
	Rank int `bson:"rank" codec:"rank"`
	// 排名变化
	Move     int    `bson:"move" codec:"move"`
	CrossKey string `bson:"cross_key" codec:"cross_key"`
}

func (*CrossArenaRecord) CollectionName() string {
	return "CrossArenaRecord"
}

// 跨服竞技场战斗记录
type CrossArenaPlayRecord struct {
	document.DocumentID `bson:",inline"`

	// 战斗日期
	Date int `bson:"date" codec:"date" default:"todaydate2int" index:"true"`
	// 战斗时间
	Time float64 `bson:"time" codec:"time" default:"nowtime_t"`
	// 战斗随机种子
	RandSeed int32 `bson:"rand_seed" codec:"rand_seed"`

	// 主动进攻方 Role.key
	RoleKey RoleKey `bson:"role_key" codec:"role_key" index:"role_key.id"`
	// 主动进攻方 CrossArenaRecord.id
	RecordDbId document.ID `bson:"record_db_id" codec:"record_db_id"`
	// 主动进攻方角色名字
	Name string `bson:"name" codec:"name"`
	// 主动进攻方角色头像ID
	Logo int `bson:"logo" codec:"logo"`
	// 主动进攻方角色头像框ID
	Frame int `bson:"frame" codec:"frame"`
	// 主动进攻方角色等级
	Level int `bson:"level" codec:"level"`
	// 主动进攻方VIP
	Vip int `bson:"vip" codec:"vip"`
	// 主动进攻方角色形象
	Figure int `bson:"figure" codec:"figure"`

	// 主动进攻部署卡牌列表 {1: [cardID], 2: [cardID]}
	Cards map[document.Integer][]document.ID `bson:"cards" codec:"cards"`
	// 主动进攻卡牌离线属性
	CardAttrs map[document.ID]*CardBattleModel `bson:"card_attrs" codec:"card_attrs"`
	// 主动进攻卡牌离线属性
	CardAttrs2 map[document.ID]*CardBattleModel `bson:"card_attrs2,omitempty" codec:"card_attrs2,omitempty"`
	// 主动进攻全局被动技能
	PassiveSkills map[document.Integer]int `bson:"passive_skills" codec:"passive_skills"`

	// 被动防御方 Role.key
	DefenceRoleKey RoleKey `bson:"defence_role_key" codec:"defence_role_key" index:"defence_role_key.id"`
	// 被动防御方 CrossArenaRecord.id
	DefenceRecordId document.ID `bson:"defence_record_id" codec:"defence_record_id"`
	// 被动防御方角色名字
	DefenceName string `bson:"defence_name" codec:"defence_name"`
	// 被动防御方角色头像ID
	DefenceLogo int `bson:"defence_logo" codec:"defence_logo"`
	// 被动防御方角色头像框ID
	DefenceFrame int `bson:"defence_frame" codec:"defence_frame"`
	// 被动防御方角色等级
	DefenceLevel int `bson:"defence_level" codec:"defence_level"`
	// 被动进攻方VIP
	DefenceVip int `bson:"defence_vip" codec:"defence_vip"`
	// 被动进攻方角色形象
	DefenceFigure int `bson:"defence_figure" codec:"defence_figure"`

	// 被动防御部署卡牌列表 {1: [cardID], 2: [cardID]}
	DefenceCards map[document.Integer][]document.ID `bson:"defence_cards" codec:"defence_cards"`
	// 被动防御卡牌离线属性
	DefenceCardAttrs map[document.ID]*CardBattleModel `bson:"defence_card_attrs" codec:"defence_card_attrs"`
	// 被动防御卡牌离线属性
	DefenceCardAttrs2 map[document.ID]*CardBattleModel `bson:"defence_card_attrs2,omitempty" codec:"defence_card_attrs2,omitempty"`
	// 被动防御全局被动技能
	DefencePassiveSkills map[document.Integer]int `bson:"defence_passive_skills" codec:"defence_passive_skills"`

	// 战斗结果
	Result string `bson:"result" codec:"result" default:"unknown"`
}

func (*CrossArenaPlayRecord) CollectionName() string {
	return "CrossArenaPlayRecord"
}

// 跨服竞技场全局记录
type CrossArenaGlobal struct {
	document.DocumentID `bson:",inline"`

	// cross_key
	Key string `bson:"key" codec:"key" unique:"true"`
	// 参与的server [server_key]
	Servers []string `bson:"servers" codec:"servers"`
	// service.csv的CSV ID
	CsvId int `bson:"csv_id" codec:"csv_id"`
	// 下次发放奖励阶段
	NextAwardDate int `bson:"next_award_date" codec:"next_award_date"`

	// 开始日期
	Date int `bson:"date" codec:"date"`
	// 赛季状态 （start, closed）
	Round string `bson:"round" codec:"round" default:"closed"`

	// 角色相关信息 {role.id: Object}  role缩略信息、排名、展示卡牌
	ArenaRoles map[document.ID]*CrossArenaRoleInfo `bson:"arena_roles" codec:"arena_roles"`

	// 匹配对手 {role.id: [ranks]}
	EnemyRanks map[document.ID][]int `bson:"enemy_ranks" codec:"enemy_ranks"`

	// 排位赛总排名 {rank:(Role.id, CrossArenaRecord.id)}
	Ranks map[document.Integer][2]document.ID `bson:"ranks" codec:"ranks"`
	// 排位最大下标
	RankMax int64 `bson:"rank_max" codec:"rank_max"`

	// 精彩战报
	TopBattleHistory []CrossArenaTopBattleHistory `bson:"top_battle_history" codec:"top_battle_history"`
	// 上阶段精彩战报
	LastTopBattleHistory []CrossArenaTopBattleHistory `bson:"last_top_battle_history" codec:"last_top_battle_history"`
	// 上次精彩战报 刷新时间节点
	LastRefreshTime int `bson:"last_refresh_time" codec:"last_refresh_time"`
}

type CrossArenaRoleInfo struct {
	RoleID document.ID `bson:"role_db_id" codec:"role_db_id"`
	Name   string      `bson:"name" codec:"name"`
	Logo   int         `bson:"logo" codec:"logo"`
	Frame  int         `bson:"frame" codec:"frame"`
	Level  int         `bson:"level" codec:"level"`
	Figure int         `bson:"figure" codec:"figure"`
	Vip    int         `bson:"vip" codec:"vip"`

	RecordID document.ID `bson:"record_db_id" codec:"record_db_id"`
	GameKey  string      `bson:"game_key" codec:"game_key"`

	// 排名
	Rank int `bson:"rank" codec:"rank"`
	// 形象展示
	Display int `bson:"display" codec:"display"`
	// 战力
	FightingPoint int `bson:"fighting_point" codec:"fighting_point"`
	// 历史最高排名
	TopRank int `bson:"top_rank" codec:"top_rank"`
}

type CrossArenaTopBattleHistory struct {
	Time     float64 `bson:"time" codec:"time"`
	Result   string  `bson:"result" codec:"result"`
	CrossKey string  `bson:"cross_key" codec:"cross_key"`

	// CrossArenaRecord.id
	PlayRecordID document.ID `bson:"play_record_id" codec:"play_record_id"`

	// 挑战方
	RoleKey  RoleKey     `bson:"role_key" codec:"role_key"`
	RecordID document.ID `bson:"record_id" codec:"record_id"`
	Name     string      `bson:"name" codec:"name"`
	Logo     int         `bson:"logo" codec:"logo"`
	Frame    int         `bson:"frame" codec:"frame"`
	Level    int         `bson:"level" codec:"level"`
	Vip      int         `bson:"vip" codec:"vip"`
	Rank     int         `bson:"rank" codec:"rank"`

	// 被挑战方
	DefenceRoleKey  RoleKey     `bson:"defence_role_key" codec:"defence_role_key"`
	DefenceRecordID document.ID `bson:"defence_record_id" codec:"defence_record_id"`
	DefenceName     string      `bson:"defence_name" codec:"defence_name"`
	DefenceLogo     int         `bson:"defence_logo" codec:"defence_logo"`
	DefenceFrame    int         `bson:"defence_frame" codec:"defence_frame"`
	DefenceLevel    int         `bson:"defence_level" codec:"defence_level"`
	DefenceVip      int         `bson:"defence_vip" codec:"defence_vip"`
	DefenceRank     int         `bson:"defence_rank" codec:"defence_rank"`
}

func (*CrossArenaGlobal) CollectionName() string {
	return "CrossArenaGlobal"
}

// 跨服竞技场Game全局记录
type CrossArenaGameGlobal struct {
	document.DocumentID `bson:",inline"`

	// server_key
	Key string `bson:"key" codec:"key" unique:"true"`
	// 跨服cross_key
	CrossKey string `bson:"cross_key" codec:"cross_key"`
	// 跨服csv_id
	CsvID int `bson:"csv_id" codec:"csv_id"`
	// 上期排行榜
	LastRanks []CrossArenaRoleInfo `bson:"last_ranks" codec:"last_ranks"`
	// 排行奖励已领取 段位 {roleID: {1: sevenStage, 2: finishStage} 缓存
	PeriodAwardStages map[document.ID]map[document.Integer]int `bson:"period_award_stages" codec:"period_award_stages"`
	// 结束后精彩战报
	TopBattleHistory []CrossArenaTopBattleHistory `bson:"top_battle_history" codec:"top_battle_history"`

	// 赛季状态 （start, closed）
	Round string `bson:"round" codec:"round" default:"closed"`
}

func (*CrossArenaGameGlobal) CollectionName() string {
	return "CrossArenaGameGlobal"
}

package scheme

import "tjgame/document"

// 跨服资源战全局记录
type CrossMineGlobal struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key" unique:"true"`
	// 参与的server [node key list]
	Servers []string `bson:"servers" codec:"servers"`
	// service.csv的CSV ID
	CsvId int `bson:"csv_id" codec:"csv_id"`
	// 开始日期
	Date int `bson:"date" codec:"date"`
	// MineGlobal.time
	Time int64 `bson:"time" codec:"time"`
	// round
	Round string `bson:"round" codec:"round" default:"closed"`
	// 下次发放奖励阶段
	NextAwardDate int `bson:"next_award_date" codec:"next_award_date"`
	// 取 servers 内最小的开服时间
	ServerOpenDays int `bson:"server_open_days" codec:"server_open_days"`
	// 参赛玩家
	Roles map[document.ID]*CrossMineRoleInfo `bson:"roles" codec:"roles"`

	// 总排名 {rank:(Role.id, CrossMineRecord.id)}
	Ranks map[document.Integer][2]document.ID `bson:"ranks" codec:"ranks"`
	// 排名最大下标
	RankMax int64 `bson:"rank_max" codec:"rank_max"`
	// 匹配对手 {role.id: [ranks]}
	EnemyRanks map[document.ID][]int `bson:"enemy_ranks" codec:"enemy_ranks"`
	// 区服 buff
	ServerBuffInfo map[string]*CrossMineServerBuffInfo `bson:"server_buff_info" codec:"server_buff_info"`
	// 个人 buff
	RoleBuffInfo map[document.ID]*CrossMineRoleBuffInfo `bson:"role_buff_info" codec:"role_buff_info"`
	// 上次生产资源时间
	LastProductTime float64 `bson:"last_product_time" codec:"last_product_time" default:"nowtime_t"`
	// 角色被抢夺的时间点和当日次数
	RoleBeRoded map[document.ID]*CrossMineRoleBeRodedInfo `bson:"role_be_roded" codec:"role_be_roded"`
	// 角色被复仇次数
	RoleBeRevenged map[document.ID]map[document.ID]*CrossMineRoleBeRevengedInfo `bson:"role_be_revenged" codec:"role_be_revenged"`
	// Boss
	Boss map[document.ID]*CrossMineBoss `bson:"boss" codec:"boss"`
	// 服务器击杀的 boss
	ServerKillBoss map[string]map[document.ID]*CrossMineServerKillBoss `bson:"server_kill_boss" codec:"server_kill_boss"`
	// NPC
	Npc map[document.ID]*CrossMineNpc `bson:"npc" codec:"npc"`
	// 事件生成记录
	EventRecrod map[document.Integer]bool `bson:"event_record" codec:"event_record"`

	// 精彩战报
	TopBattleHistory []CrossMineTopBattleHistory `bson:"top_battle_history" codec:"top_battle_history"`
	// 上阶段精彩战报
	LastTopBattleHistory []CrossMineTopBattleHistory `bson:"last_top_battle_history" codec:"last_top_battle_history"`
	// 上次精彩战报 刷新时间节点
	LastRefreshTime int `bson:"last_refresh_time" codec:"last_refresh_time"`
}

type CrossMineServerKillBoss struct {
	// 配表 CsvID
	CsvID int `bson:"csv_id" codec:"csv_id"`
	// 击杀时间
	Time float64 `bson:"time" codec:"time"`
}

type CrossMineBoss struct {
	// 唯一 ID
	ID document.ID `bson:"id" codec:"id"`
	// 配表 CsvID
	CsvID int `bson:"csv_id" codec:"csv_id"`
	// 开放时间
	OpenTime float64 `bson:"open_time" codec:"open_time"`
	// 血量 HP
	HP map[document.Integer]int `bson:"hp" codec:"hp"`
	// 参与玩家
	Roles map[document.ID]*CrossMineBossRole `bson:"roles" codec:"roles"`
	// 累计伤害
	Damage map[document.Integer]int `bson:"damage" codec:"damage"`
	// 发放奖励
	AwardDate int `bson:"award_date" codec:"award_date"`
	// 形象
	FigureID int `bson:"figure_id" codec:"figure_id"`
	// 击杀者
	KillRoleID document.ID `bson:"kill_role_id" codec:"kill_role_id"`
}

type CrossMineBossRole struct {
	Damage int `bson:"damage" codec:"damage"`
	Rank   int `bson:"rank" codec:"rank"`
}

type CrossMineNpc struct {
	// 唯一 ID
	ID document.ID `bson:"id" codec:"id"`
	// 配表 csvID
	CsvID int `bson:"csv_id" codec:"csv_id"`
	// 开放时间
	OpenTime float64 `bson:"open_time" codec:"open_time"`
}

type CrossMineServerBuffInfo struct {
	// 总经验
	SumExp int `bson:"sum_exp" codec:"sum_exp"`
	// 等级
	Level int `bson:"level" codec:"level"`
	// 当天累计经验
	DayExp int `bson:"day_exp" codec:"day_exp"`
	// 最后一次日期
	LastDate int `bson:"last_date" codec:"last_date"`
}

type CrossMineRoleBuffInfo struct {
	// 总经验
	SumExp int `bson:"sum_exp" codec:"sum_exp"`
	// 等级
	Level int `bson:"level" codec:"level"`
}

type CrossMineRoleBeRodedInfo struct {
	Time  []float64 `bson:"time" codec:"time"`
	Count int       `bson:"count" codec:"count"`
}

type CrossMineRoleBeRevengedInfo struct {
	Time  []float64 `bson:"time" codec:"time"`
	Count int       `bson:"count" codec:"count"`
}

type CrossMineTopBattleHistory struct {
	Time     float64 `bson:"time" codec:"time"`
	Result   string  `bson:"result" codec:"result"`
	CrossKey string  `bson:"cross_key" codec:"cross_key"`

	// CrossMineRecord.id
	PlayRecordID document.ID `bson:"play_record_id" codec:"play_record_id"`

	// 挑战方
	RoleKey       RoleKey     `bson:"role_key" codec:"role_key"`
	RecordID      document.ID `bson:"record_id" codec:"record_id"`
	Name          string      `bson:"name" codec:"name"`
	Logo          int         `bson:"logo" codec:"logo"`
	Frame         int         `bson:"frame" codec:"frame"`
	Level         int         `bson:"level" codec:"level"`
	Vip           int         `bson:"vip" codec:"vip"`
	Rank          int         `bson:"rank" codec:"rank"`
	FightingPoint int         `bson:"fighting_point" codec:"fighting_point"`

	// 被挑战方
	DefenceRoleKey       RoleKey     `bson:"defence_role_key" codec:"defence_role_key"`
	DefenceRecordID      document.ID `bson:"defence_record_id" codec:"defence_record_id"`
	DefenceName          string      `bson:"defence_name" codec:"defence_name"`
	DefenceLogo          int         `bson:"defence_logo" codec:"defence_logo"`
	DefenceFrame         int         `bson:"defence_frame" codec:"defence_frame"`
	DefenceLevel         int         `bson:"defence_level" codec:"defence_level"`
	DefenceVip           int         `bson:"defence_vip" codec:"defence_vip"`
	DefenceRank          int         `bson:"defence_rank" codec:"defence_rank"`
	DefenceFightingPoint int         `bson:"defence_fighting_point" codec:"defence_fighting_point"`
}

func (*CrossMineGlobal) CollectionName() string {
	return "CrossMineGlobal"
}

type CrossMineRole struct {
	RoleID   document.ID `bson:"role_db_id" codec:"role_db_id"`
	RecordID document.ID `bson:"record_db_id" codec:"record_db_id"`
	GameKey  string      `bson:"game_key" codec:"game_key"`
	Name     string      `bson:"name" codec:"name"`
	Logo     int         `bson:"logo" codec:"logo"`
	Frame    int         `bson:"frame" codec:"frame"`
	Level    int         `bson:"level" codec:"level"`
	Figure   int         `bson:"figure" codec:"figure"`
	Title    int         `bson:"title" codec:"title"`
	Vip      int         `bson:"vip" codec:"vip"`
}

type CrossMineRoleInfo struct {
	CrossMineRole `bson:",inline"`

	// 排名
	Rank int `bson:"rank" codec:"rank"`
	// Speed
	Speed float64 `bson:"speed" codec:"speed"`
	// 战力
	FightingPoint int `bson:"fighting_point" codec:"fighting_point"`
	// 历史最高排名
	TopRank int `bson:"top_rank" codec:"top_rank"`
	// 原始 coin13
	Coin13Origin int `bson:"coin13_origin" codec:"coin13_origin"`
	// coin13 差量
	Coin13Diff float64 `bson:"coin13_diff" codec:"coin13_diff"`
	// 全服 buff 培养之和
	ServerBuffFeed int `bson:"server_buff_feed" codec:"server_buff_feed"`
	// 全服 buff 培养排名
	ServerBuffFeedRank int `bson:"server_buff_feed_rank" codec:"server_buff_feed_rank"`
	// 战斗 boss 获得的积分
	BossScore int `bson:"boss_score" codec:"boss_score"`
}

// 跨服资源战记录
type CrossMineRecord struct {
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

	// 进攻阵容
	Cards map[document.Integer][]document.ID `bson:"cards" codec:"cards"`
	// 卡牌离线属性
	CardAttrs map[document.ID]*CardBattleModel `bson:"card_attrs" codec:"card_attrs"`
	// 卡牌离线属性
	CardAttrs2 map[document.ID]*CardBattleModel `bson:"card_attrs2" codec:"card_attrs2"`
	// 全局被动技能
	PassiveSkills map[document.Integer]int `bson:"passive_skills" codec:"passive_skills"`

	// 防守阵容
	DefenceCards map[document.Integer][]document.ID `bson:"defence_cards" codec:"defence_cards"`
	// 卡牌离线属性
	DefenceCardAttrs map[document.ID]*CardBattleModel `bson:"defence_card_attrs" codec:"defence_card_attrs"`
	// 卡牌离线属性
	DefenceCardAttrs2 map[document.ID]*CardBattleModel `bson:"defence_card_attrs2" codec:"defence_card_attrs2"`
	// 全局被动技能
	DefencePassiveSkills map[document.Integer]int `bson:"defence_passive_skills" codec:"defence_passive_skills"`

	// 战斗历史
	History []CrossMineBattleHistory `bson:"history" codec:"history"`
}

func (*CrossMineRecord) CollectionName() string {
	return "CrossMineRecord"
}

type CrossMineBattleHistory struct {
	Time   float64 `bson:"time" codec:"time"`
	Result string  `bson:"result" codec:"result"`

	// CrossMinePlayRecord.id 录像回放
	PlayRecordID document.ID `bson:"play_record_id" codec:"play_record_id"`

	EnemyRoleID        document.ID `bson:"enemy_role_id" codec:"enemy_role_id"`
	EnemyRecordID      document.ID `bson:"enemy_record_id" codec:"enemy_record_id"`
	EnemyGameKey       string      `bson:"enemy_game_key" codec:"enemy_game_key"`
	EnemyName          string      `bson:"enemy_name" codec:"enemy_name"`
	EnemyLogo          int         `bson:"enemy_logo" codec:"enemy_logo"`
	EnemyFrame         int         `bson:"enemy_frame" codec:"enemy_frame"`
	EnemyLevel         int         `bson:"enemy_level" codec:"enemy_level"`
	EnemyFight         int         `bson:"enemy_fight" codec:"enemy_fight"`
	EnemyVip           int         `bson:"enemy_vip" codec:"enemy_vip"`
	EnemyRank          int         `bson:"enemy_rank" codec:"enemy_rank"`
	EnemyFightingPoint int         `bson:"enemy_fighting_point" codec:"enemy_fighting_point"`

	// 进攻: 1  防守: 2
	BattleMode int `bson:"battle_mode" codec:"battle_mode"`
	// 自己排名
	Rank int `bson:"rank" codec:"rank"`
	// 排名变化
	Move int `bson:"move" codec:"move"`
	// 资源变化
	Coin13 int `bson:"coin13" codec:"coin13"`
	// 跨服 crossKey
	CrossKey string `bson:"cross_key" codec:"cross_key"`
	// 战斗类型 rob 抢夺，revenge 复仇
	Flag string `bson:"flag" codec:"flag"`
}

// 跨服资源战战斗记录
type CrossMinePlayRecord struct {
	document.DocumentID `bson:",inline"`

	// 战斗日期
	Date int `bson:"date" codec:"date" default:"todaydate2int" index:"true"`
	// 战斗时间
	Time float64 `bson:"time" codec:"time" default:"nowtime_t"`
	// 战斗随机种子
	RandSeed int32 `bson:"rand_seed" codec:"rand_seed"`

	// 主动进攻方 Role.key
	RoleKey RoleKey `bson:"role_key" codec:"role_key" index:"role_key.id"`
	// 主动进攻方 CrossMineRecord.id
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
	// 被动防御方 CrossMineRecord.id
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
	// 胜负统计 {1: "win", 2: "win"} 第一场 win，第二场 fail，第三场未进行
	Stats map[document.Integer]string `bson:"stats" codec:"stats"`
	// 抢夺的资源
	RobNum int `bson:"rob_num" codec:"rob_num"`
	// 战斗类型 rob 抢夺，revenge 复仇
	Flag string `bson:"flag" codec:"flag"`
	// 结束后进攻方排名
	Rank int `bson:"rank" codec:"rank"`
	// 结束后防守方排名
	DefenceRank int `bson:"defence_rank" codec:"defence_rank"`
}

func (*CrossMinePlayRecord) CollectionName() string {
	return "CrossMinePlayRecord"
}

// 跨服资源战Game全局记录
type CrossMineGameGlobal struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key" unique:"true"`
	// 跨服server key
	CrossKey string `bson:"cross_key" codec:"cross_key"`
	// 开始日期
	Date int `bson:"date" codec:"date"`
	// 跨服 csvID
	CsvID int `bson:"csv_id" codec:"csv_id"`
	// MineGlobal.time
	Time int64 `bson:"time" codec:"time"`
	// MineGlobal.round
	Round string `bson:"round" codec:"round" default:"closed"`

	// 角色缓存资源变化
	RoleCoin13Diff map[document.ID]int `bson:"role_coin13_diff" codec:"role_coin13_diff"`
	// 上期排行榜
	LastRanks []CrossMineRoleInfo `bson:"last_ranks" codec:"last_ranks"`
	// 上期服务器积分
	LastServerPoints map[string]int `bson:"last_server_points" codec:"last_server_points"`
	// 结束后精彩战报
	TopBattleHistory []CrossMineTopBattleHistory `bson:"top_battle_history" codec:"top_battle_history"`
}

func (*CrossMineGameGlobal) CollectionName() string {
	return "CrossMineGameGlobal"
}

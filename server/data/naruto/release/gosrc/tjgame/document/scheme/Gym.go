package scheme

import "tjgame/document"

// 道馆记录
type GymRecord struct {
	document.DocumentID `bson:",inline"`

	// Role.id
	RoleId document.ID `bson:"role_id" codec:"role_id" index:"true"`
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

	// 馆主 防守卡牌列表 [cardID]
	Cards []document.ID `bson:"cards" codec:"cards"`
	// 馆主 防守卡牌离线属性
	CardAttrs map[document.ID]*CardBattleModel `bson:"card_attrs" codec:"card_attrs"`
	// 馆主 防守卡牌离线属性
	CardAttrs2 map[document.ID]*CardBattleModel `bson:"card_attrs2" codec:"card_attrs2"`
	// 馆主 防守全局被动技能
	PassiveSkills map[document.Integer]int `bson:"passive_skills" codec:"passive_skills"`

	// 跨服馆主 防守卡牌列表 [cardID]
	CrossCards []document.ID `bson:"cross_cards" codec:"cross_cards"`
	// 跨服馆主 防守卡牌离线属性
	CrossCardAttrs map[document.ID]*CardBattleModel `bson:"cross_card_attrs" codec:"cross_card_attrs"`
	// 跨服馆主 防守卡牌离线属性
	CrossCardAttrs2 map[document.ID]*CardBattleModel `bson:"cross_card_attrs2" codec:"cross_card_attrs2"`
	// 跨服馆主 防守全局被动技能
	CrossPassiveSkills map[document.Integer]int `bson:"cross_passive_skills" codec:"cross_passive_skills"`

	// 上周日志
	LastLogs []GymLogInfo `bson:"last_logs" codec:"last_logs"`
	// 日志
	Logs []GymLogInfo `bson:"logs" codec:"logs"`

	// 上周结束详情
	LastGymCloseInfo GymCloseInfo `bson:"last_gym_close_info" codec:"last_gym_close_info"`
	// 本周结束详情
	GymCloseInfo GymCloseInfo `bson:"gym_close_info" codec:"gym_close_info"`
}

func (*GymRecord) CollectionName() string {
	return "GymRecord"
}

type GymLogInfo struct {
	// 记录时间 时间戳
	Time float64 `bson:"time" codec:"time"`
	// 日志类型 string
	Type int `bson:"type" codec:"type"`

	// 道馆id
	GymID int `bson:"gym_id,omitempty" codec:"gym_id,omitempty"`
	// 战斗类 对战详情
	GymBattleHistory *GymBattleHistory `bson:"gym_battle_history,omitempty" codec:"gym_battle_history,omitempty"`
}

type GymCloseInfo struct {
	// 通关数量
	PassNum int `bson:"pass_num,omitempty" codec:"pass_num,omitempty"`
	// 本服哪个馆 馆主
	LeaderGymID int `bson:"leader_gym_id,omitempty" codec:"leader_gym_id,omitempty"`
	// 跨服哪个馆 馆员
	CrossGymID int `bson:"cross_gym_id,omitempty" codec:"cross_gym_id,omitempty"`
	// 跨服哪个馆 馆主
	CrossLeaderGymID int `bson:"cross_leader_gym_id,omitempty" codec:"cross_leader_gym_id,omitempty"`
}

type CardSlimModel struct {
	CardId        int `bson:"card_id" codec:"card_id"`
	Level         int `bson:"level" codec:"level"`
	FightingPoint int `bson:"fighting_point" codec:"fighting_point"`
	Star          int `bson:"star" codec:"star"`
	Advance       int `bson:"advance" codec:"advance"`
	NatureChoose  int `bson:"nature_choose" codec:"nature_choose" default:"1"`
	SkinId        int `bson:"skin_id" codec:"skin_id"`
}

type GymBattleHistory struct {
	Result   string `bson:"result" codec:"result"`
	CrossKey string `bson:"cross_key" codec:"cross_key"`

	// GymPlayRecord.id
	PlayRecordID document.ID `bson:"play_record_id" codec:"play_record_id"`

	// 挑战方
	RoleID    document.ID                    `bson:"role_id" codec:"role_id"`
	RoleKey   string                         `bson:"role_key" codec:"role_key"`
	RecordID  document.ID                    `bson:"record_id" codec:"record_id"`
	Name      string                         `bson:"name" codec:"name"`
	Logo      int                            `bson:"logo" codec:"logo"`
	Frame     int                            `bson:"frame" codec:"frame"`
	Level     int                            `bson:"level" codec:"level"`
	Vip       int                            `bson:"vip" codec:"vip"`
	Cards     []document.ID                  `bson:"cards" codec:"cards"`
	CardAttrs map[document.ID]*CardSlimModel `bson:"card_attrs" codec:"card_attrs"`

	// 被挑战方
	DefenceRoleID    document.ID                    `bson:"defence_role_id" codec:"defence_role_id"`
	DefenceRoleKey   string                         `bson:"defence_role_key" codec:"defence_role_key"`
	DefenceRecordID  document.ID                    `bson:"defence_record_id" codec:"defence_record_id"`
	DefenceName      string                         `bson:"defence_name" codec:"defence_name"`
	DefenceLogo      int                            `bson:"defence_logo" codec:"defence_logo"`
	DefenceFrame     int                            `bson:"defence_frame" codec:"defence_frame"`
	DefenceLevel     int                            `bson:"defence_level" codec:"defence_level"`
	DefenceVip       int                            `bson:"defence_vip" codec:"defence_vip"`
	DefenceCards     []document.ID                  `bson:"defence_cards" codec:"defence_cards"`
	DefenceCardAttrs map[document.ID]*CardSlimModel `bson:"defence_card_attrs" codec:"defence_card_attrs"`
}

// 道馆战斗记录
type GymPlayRecord struct {
	document.DocumentID `bson:",inline"`

	// 战斗日期
	Date int `bson:"date" codec:"date" default:"todaydate2int"`
	// 战斗时间
	Time float64 `bson:"time" codec:"time" default:"nowtime_t"`
	// 战斗随机种子
	RandSeed int32 `bson:"rand_seed" codec:"rand_seed"`

	// 主动进攻方 Role.ID
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id"`
	// 主动进攻方 RoleKey
	RoleKey string `bson:"role_key" codec:"role_key"`
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

	// 主动进攻部署卡牌列表 [cardID]
	Cards []document.ID `bson:"cards" codec:"cards"`
	// 主动进攻卡牌离线属性
	CardAttrs map[document.ID]*CardBattleModel `bson:"card_attrs" codec:"card_attrs"`
	// 主动进攻卡牌离线属性
	CardAttrs2 map[document.ID]*CardBattleModel `bson:"card_attrs2" codec:"card_attrs2"`
	// 主动进攻全局被动技能
	PassiveSkills map[document.Integer]int `bson:"passive_skills" codec:"passive_skills"`

	// 被动防御方 Role.ID
	DefenceRoleDbId document.ID `bson:"defence_role_db_id" codec:"defence_role_db_id"`
	// 被动防御方 RoleKey
	DefenceRoleKey string `bson:"defence_role_key" codec:"defence_role_key"`
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

	// 被动防御部署卡牌列表 [cardID]
	DefenceCards []document.ID `bson:"defence_cards" codec:"defence_cards"`
	// 被动防御卡牌离线属性
	DefenceCardAttrs map[document.ID]*CardBattleModel `bson:"defence_card_attrs" codec:"defence_card_attrs"`
	// 被动防御卡牌离线属性
	DefenceCardAttrs2 map[document.ID]*CardBattleModel `bson:"defence_card_attrs2" codec:"defence_card_attrs2"`
	// 被动防御全局被动技能
	DefencePassiveSkills map[document.Integer]int `bson:"defence_passive_skills" codec:"defence_passive_skills"`

	// 战斗结果
	Result string `bson:"result" codec:"result" default:"unknown"`
}

func (*GymPlayRecord) CollectionName() string {
	return "GymPlayRecord"
}

// 跨服道馆全局记录
type CrossGymGlobal struct {
	document.DocumentID `bson:",inline"`

	// cross_key
	Key string `bson:"key" codec:"key" unique:"true"`
	// 参与的server [server_key]
	Servers []string `bson:"servers" codec:"servers"`
	// service.csv的CSV ID
	CsvId int `bson:"csv_id" codec:"csv_id"`
	// 开始日期
	Date int `bson:"date" codec:"date"`

	// 状态 （start, closed）
	Round string `bson:"round" codec:"round" default:"closed"`

	// 跨服馆员相关信息 {gymID: {pos: Object}} 默认第一位是跨服馆主
	CrossGymRoles map[document.Integer]map[document.Integer]*CrossGymRoleInfo `bson:"cross_gym_roles" codec:"cross_gym_roles"`
}

func (*CrossGymGlobal) CollectionName() string {
	return "CrossGymGlobal"
}

// 道馆全局记录
type GymGlobal struct {
	document.DocumentID `bson:",inline"`

	// server_key
	Key string `bson:"key" codec:"key" unique:"true"`

	// 状态 （start, closed）
	Round string `bson:"round" codec:"round" default:"closed"`

	// 馆主相关信息 {gymID: Object}
	LeaderRoles map[document.Integer]*GymRoleInfo `bson:"leader_roles" codec:"leader_roles"`

	// 通关数量 {recordID: num}
	PassNums map[document.ID]int `bson:"pass_nums" codec:"pass_nums"`
}

func (*GymGlobal) CollectionName() string {
	return "GymGlobal"
}

type GymRoleInfo struct {
	RoleID document.ID `bson:"role_id" codec:"role_id"`
	Name   string      `bson:"name" codec:"name"`
	Logo   int         `bson:"logo" codec:"logo"`
	Frame  int         `bson:"frame" codec:"frame"`
	Level  int         `bson:"level" codec:"level"`
	Figure int         `bson:"figure" codec:"figure"`
	Vip    int         `bson:"vip" codec:"vip"`

	RecordID document.ID `bson:"record_id" codec:"record_id"`

	// 战力
	FightingPoint int `bson:"fighting_point" codec:"fighting_point"`
}

type CrossGymRoleInfo struct {
	GymRoleInfo `bson:",inline"`
	// 区服
	GameKey string `bson:"game_key" codec:"game_key"`
}

// 道馆Game全局记录
type GymGameGlobal struct {
	document.DocumentID `bson:",inline"`

	// server_key
	Key string `bson:"key" codec:"key" unique:"true"`
	// 跨服cross_key
	CrossKey string `bson:"cross_key" codec:"cross_key"`
	// 跨服csv_id
	CsvID int `bson:"csv_id" codec:"csv_id"`

	// 状态 （start, closed）
	Round string `bson:"round" codec:"round" default:"closed"`

	// 副本关卡 {gymID: {degree: gateID}}
	GymGates map[document.Integer]map[document.Integer]int `bson:"gym_gates" codec:"gym_gates"`

	// 道馆离线称号 {roleID: [{titleID: openTime}]}
	GymTitles map[document.ID][]map[document.Integer]float64 `bson:"gym_titles" codec:"gym_titles"`

	// 上期 馆主相关信息 {gymID: Object}
	LastLeaderRoles map[document.Integer]*GymRoleInfo `bson:"last_leader_roles" codec:"last_leader_roles"`
	// 上期 跨服馆员相关信息 {gymID: {pos: Object}} 默认第一位是跨服馆主
	LastCrossGymRoles map[document.Integer]map[document.Integer]*CrossGymRoleInfo `bson:"last_cross_gym_roles" codec:"last_cross_gym_roles"`
}

func (*GymGameGlobal) CollectionName() string {
	return "GymGameGlobal"
}

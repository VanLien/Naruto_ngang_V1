package scheme

import "tjgame/document"

// 竞技场记录
type ArenaRecord struct {
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
	// 排位赛排名
	Rank int `bson:"rank" codec:"rank"`
	// 历史最高排名
	RankTop int `bson:"rank_top" codec:"rank_top"`
	// 战斗力
	FightingPoint int `bson:"fighting_point" codec:"fighting_point"`
	// 展示卡牌
	Display int `bson:"display" codec:"display"`
	// 上次刷新时间
	RefreshLastDate int `bson:"refresh_last_date" codec:"refresh_last_date"`
	// 对手排名
	EnemyRanks []int `bson:"enemy_ranks" codec:"enemy_ranks"`

	// 主动进攻部署卡牌列表
	Cards []document.ID `bson:"cards" codec:"cards"`
	// 主动进攻卡牌离线属性
	CardAttrs map[document.ID]*CardBattleModel `bson:"card_attrs" codec:"card_attrs"`
	// 主动进攻卡牌离线属性
	CardAttrs2 map[document.ID]*CardBattleModel `bson:"card_attrs2" codec:"card_attrs2"`
	// 进攻全局被动技能
	PassiveSkills map[document.Integer]int `bson:"passive_skills" codec:"passive_skills"`
	// 被动防御部署卡牌列表
	DefenceCards []document.ID `bson:"defence_cards" codec:"defence_cards"`
	// 被动防御卡牌离线属性
	DefenceCardAttrs map[document.ID]*CardBattleModel `bson:"defence_card_attrs" codec:"defence_card_attrs"`
	// 被动防御卡牌离线属性
	DefenceCardAttrs2 map[document.ID]*CardBattleModel `bson:"defence_card_attrs2" codec:"defence_card_attrs2"`
	// 被动防御全局被动技能
	DefencePassiveSkills map[document.Integer]int `bson:"defence_passive_skills" codec:"defence_passive_skills"`

	// 战斗历史
	History []BattleHistory `bson:"history" codec:"history"`

	// 是否是机器人
	Robot bool `bson:"robot,omitempty" codec:"robot,omitempty"`
}

type BattleHistory struct {
	Time          float64     `bson:"time" codec:"time"`
	Result        string      `bson:"result" codec:"result"`
	PlayRecordID  document.ID `bson:"playRecordID" codec:"playRecordID"`
	EnemyName     string      `bson:"enemyName" codec:"enemyName"`
	EnemyRoleID   document.ID `bson:"enemyRoleID" codec:"enemyRoleID"`
	EnemyRecordID document.ID `bson:"enemyRecordID" codec:"enemyRecordID"`
	EnemyLogo     int         `bson:"enemyLogo" codec:"enemyLogo"`
	EnemyFrame    int         `bson:"enemyFrame" codec:"enemyFrame"`
	EnemyLevel    int         `bson:"enemyLevel" codec:"enemyLevel"`
	EnemyFight    int         `bson:"enemyFight" codec:"enemyFight"`

	Move int `bson:"move" codec:"move"`
}

func (*ArenaRecord) CollectionName() string {
	return "ArenaRecord"
}

// 远征防守记录
type ArenaHuntingRecord struct {
	document.DocumentID `bson:",inline"`

	// 玩家id
	RoleDbID document.ID `bson:"role_db_id" codec:"role_db_id" unique:"true" index:"true"`

	// 作为关卡卡牌列表
	DefenceCards []document.ID `bson:"defence_cards" codec:"defence_cards"`
	// 作为关卡卡牌离线属性
	DefenceCardAttrs map[document.ID]*CardBattleModel `bson:"defence_card_attrs" codec:"defence_card_attrs"`
	// 作为关卡卡牌离线属性2
	DefenceCardAttrs2 map[document.ID]*CardBattleModel `bson:"defence_card_attrs2" codec:"defence_card_attrs2"`
	// 作为关卡全局被动技能
	DefencePassiveSkills map[document.Integer]int `bson:"defence_passive_skills" codec:"defence_passive_skills"`
}

func (*ArenaHuntingRecord) CollectionName() string {
	return "ArenaHuntingRecord"
}

// 竞技场战斗记录
type ArenaPlayRecord struct {
	document.DocumentID `bson:",inline"`

	// 战斗日期
	Date int `bson:"date" codec:"date" default:"todaydate2int" index:"true"`
	// 战斗时间
	Time float64 `bson:"time" codec:"time" default:"nowtime_t"`
	// 战斗随机种子
	RandSeed int32 `bson:"rand_seed" codec:"rand_seed"`

	// 主动进攻方 Role.id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// 主动进攻方 ArenaRecord.id
	RecordDbId document.ID `bson:"record_db_id" codec:"record_db_id"`
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

	// 被动防御方 Role.id
	DefenceRoleDbId document.ID `bson:"defence_role_db_id" codec:"defence_role_db_id" index:"true"`
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

	// 战斗结果
	Result string `bson:"result" codec:"result" default:"unknown"`
}

func (*ArenaPlayRecord) CollectionName() string {
	return "ArenaPlayRecord"
}

// 竞技场全局记录
type ArenaGlobal struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key" unique:"true"`
	// 排位赛总排名 {rank:(Role.id, ArenaRecord.id)}
	Ranks map[document.Integer][2]document.ID `bson:"ranks" codec:"ranks"`
	// 排位最大下标
	RankMax int64 `bson:"rank_max" codec:"rank_max"`

	// 刷新远征阵容名单最新日期
	LastDate int `bson:"last_date" codec:"last_date"`
}

func (*ArenaGlobal) CollectionName() string {
	return "ArenaGlobal"
}

// 竞技场全局记录历史
type ArenaGlobalHistory struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key"`

	// 结算日期时间 19021621
	AwardTime int `bson:"award_time" codec:"award_time"`
	// 离线玩家排名
	OfflineRoleRanks map[document.ID]int `bson:"offline_role_ranks" codec:"offline_role_ranks"`
	// 总排名
	AllRanks map[document.ID]int `bson:"all_ranks" codec:"all_ranks"`
}

func (*ArenaGlobalHistory) CollectionName() string {
	return "ArenaGlobalHistory"
}

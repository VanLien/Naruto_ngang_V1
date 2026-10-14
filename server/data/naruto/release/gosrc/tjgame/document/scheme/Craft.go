package scheme

import "tjgame/document"

// 王者记录
type CraftRecord struct {
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
	// 部署卡牌列表
	Cards []document.ID `bson:"cards" codec:"cards"`
	// 部署卡牌列表2 (暂存未战斗时的布阵数据)
	HoldCards []document.ID `bson:"hold_cards" codec:"hold_cards"`
	// 卡牌离线属性 (prepare阶段复制自HoldCardAttrs)
	CardAttrs map[document.ID]*CardBattleModel `bson:"card_attrs" codec:"card_attrs"`
	// 卡牌离线属性 (prepare阶段复制自HoldCardAttrs)
	CardAttrs2 map[document.ID]*CardBattleModel `bson:"card_attrs2" codec:"card_attrs2"`
	// 卡牌离线属性2 （暂存未战斗时的数据）
	HoldCardAttrs map[document.ID]*CardBattleModel `bson:"hold_card_attrs" codec:"hold_card_attrs"`
	// 卡牌离线属性2 （暂存未战斗时的数据）
	HoldCardAttrs2 map[document.ID]*CardBattleModel `bson:"hold_card_attrs2" codec:"hold_card_attrs2"`
	// 全局被动技能 (prepare阶段复制自HoldPassiveSkills)
	PassiveSkills map[document.Integer]int `bson:"passive_skills" codec:"passive_skills"`
	// 全局被动技能2（暂存未战斗时数据）
	HoldPassiveSkills map[document.Integer]int `bson:"hold_passive_skills" codec:"hold_passive_skills"`
	// 战斗历史
	History []CraftBattleHistory `bson:"history" codec:"history"`

	// 是否是机器人
	Robot bool `bson:"robot,omitempty" codec:"robot,omitempty"`
}

func (*CraftRecord) CollectionName() string {
	return "CraftRecord"
}

type CraftRole struct {
	RoleID   document.ID `bson:"role_db_id" codec:"role_db_id"`
	RecordID document.ID `bson:"record_db_id" codec:"record_db_id"`
	Name     string      `bson:"name" codec:"name"`
	Logo     int         `bson:"logo" codec:"logo"`
	Frame    int         `bson:"frame" codec:"frame"`
	Level    int         `bson:"level" codec:"level"`
	Figure   int         `bson:"figure" codec:"figure"`
	Title    int         `bson:"title" codec:"title"`
	Vip      int         `bson:"vip" codec:"vip"`
}

type CraftBattleRole struct {
	CraftRole     `bson:",inline"`
	FightingPoint int         `bson:"fighting_point" codec:"fighting_point"`
	Cards         []CardTuple `bson:"cards" codec:"cards"`
	// fighting_point, top_card
	Display map[string]int `bson:"display,omitempty" codec:"display,omitempty"`
}

type CraftBattleHistory struct {
	Time   float64 `bson:"time" codec:"time"`
	Round  string  `bson:"round" codec:"round"`
	Result string  `bson:"result" codec:"result"`
	Point  int     `bson:"point" codec:"point"`

	FightingPoint int         `bson:"fighting_point" codec:"fighting_point"`
	Cards         []CardTuple `bson:"cards" codec:"cards"`

	Enemy        *CraftBattleRole `bson:"enemy,omitempty" codec:"enemy,omitempty"`
	PlayRecordID *document.ID     `bson:"prid,omitempty" codec:"prid,omitempty"`
}

// 王者战斗记录
type CraftPlayRecord struct {
	document.DocumentID `bson:",inline"`

	// 战斗日期
	Date int `bson:"date" codec:"date" default:"todaydate2int" index:"true"`
	// 战斗时间
	Time float64 `bson:"time" codec:"time" default:"nowtime_t"`
	// 战斗随机种子
	RandSeed int32 `bson:"rand_seed" codec:"rand_seed"`
	// 战斗场次
	Round string `bson:"round" codec:"round"`
	// 每日特色buff [csv_id, ...]
	Buffs []int `bson:"buffs" codec:"buffs"`

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
	// 选手1的积分
	Point int `bson:"point" codec:"point"`
	// 选手2的积分
	DefencePoint int `bson:"defence_point" codec:"defence_point"`
}

func (*CraftPlayRecord) CollectionName() string {
	return "CraftPlayRecord"
}

// 王者全局记录
type CraftGlobal struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key" unique:"true"`
	// 日期
	Date int `bson:"date" codec:"date"`
	// CraftGlobal.time
	Time int64 `bson:"time" codec:"time"`
	// round
	Round string `bson:"round" codec:"round" default:"closed"`
	// 每日特色buff [csv_id, ...]
	Buffs []int `bson:"buffs" codec:"buffs"`
	// 总参赛人员
	CraftRoles map[document.ID]*CraftRoleInfo `bson:"craft_roles" codec:"craft_roles"`
	// 8强战斗记录
	Top8Plays map[string]*CraftTop8Play `bson:"top8_plays" codec:"top8_plays"`
	// 战局总记录 {pre1: {key: CraftResultInfo}}
	RoundResults map[string]map[string]*CraftResultInfo `bson:"round_results" codec:"round_results"`
	// 昨天前20下注
	Bet map[document.ID]*CraftBet `bson:"bet" codec:"bet"`
}

func (*CraftGlobal) CollectionName() string {
	return "CraftGlobal"
}

type CraftRoleInfo struct {
	CraftRole `bson:",inline"`

	Round int `bson:"round" codec:"round"`
	Win   int `bson:"win" codec:"win"`
	Point int `bson:"point" codec:"point"`
}

type CraftResultInfo struct {
	PlayID document.ID `bson:"play_id" codec:"play_id"`
	Result string      `bson:"result" codec:"result"`
	// (roleID1, roleID2)
	Roles []document.ID `bson:"roles" codec:"roles"`
	// (point1, point2)
	Points [2]int `bson:"points" codec:"points"`
}

type CraftTop8Play struct {
	PlayID document.ID     `bson:"play_id" codec:"play_id"`
	Role1  CraftBattleRole `bson:"role1" codec:"role1"`
	Role2  CraftBattleRole `bson:"role2" codec:"role2"`
	Result string          `bson:"result" codec:"result"`
	Points [2]int          `bson:"points" codec:"points"`
}

// 王者Game全局记录
type CraftGameGlobal struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key" unique:"true"`
	// 日期
	Date int `bson:"date" codec:"date"`
	// CraftGlobal.time
	Time int64 `bson:"time" codec:"time"`
	// CraftGlobal.round
	Round string `bson:"round" codec:"round" default:"closed"`
	// 每日特色buff [csv_id, ...]
	Buffs []int `bson:"buffs" codec:"buffs"`
	// 报名 {Role.id: RoleSignItem}
	Signup map[document.ID]CraftRoleSignItem `bson:"signup" codec:"signup"`
	// 昨天8强战斗记录 CraftGlobal.top8_plays
	YesterdayTop8Plays map[string]*CraftTop8Play `bson:"yesterday_top8_plays" codec:"yesterday_top8_plays"`
	// yesterday的刷新时间
	YesterdayRefreshTime int `bson:"yesterday_refresh_time" codec:"yesterday_refresh_time"`
}

func (*CraftGameGlobal) CollectionName() string {
	return "CraftGameGlobal"
}

type CraftRoleSignItem struct {
	ID       document.ID `bson:"id" codec:"id"`
	Name     string      `bson:"name" codec:"name"`
	Logo     int         `bson:"logo" codec:"logo"`
	Frame    int         `bson:"frame" codec:"frame"`
	Level    int         `bson:"level" codec:"level"`
	Figure   int         `bson:"figure" codec:"figure"`
	Title    int         `bson:"title_id" codec:"title_id"`
	Vip      int         `bson:"vip_level" codec:"vip_level"`
	RecordID document.ID `bson:"craft_record_db_id" codec:"craft_record_db_id"`
	Manual   bool        `bson:"manual" codec:"manual"` // 是否是手动报名
}

type CraftBet struct {
	Role CraftRole           `bson:"role" codec:"role"`
	Rank int                 `bson:"rank" codec:"rank"`
	Rate float64             `bson:"rate" codec:"rate"`
	Gold map[document.ID]int `bson:"gold" codec:"gold"`

	FightingPoint int `bson:"fighting_point" codec:"fighting_point"`
}

package scheme

import (
	"tjgame/document"
)

// 跨服王者记录
type CrossCraftRecord struct {
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
	History []CrossCraftBattleHistory `bson:"history" codec:"history"`

	// 是否是机器人
	Robot bool `bson:"robot,omitempty" codec:"robot,omitempty"`
}

func (*CrossCraftRecord) CollectionName() string {
	return "CrossCraftRecord"
}

// 跨服王者战斗记录
type CrossCraftPlayRecord struct {
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

	// 主动进攻方 RoleKey
	RoleKey RoleKey `bson:"role_key" codec:"role_key" index:"role_key.id"`
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

	// 战斗结果
	Result string `bson:"result" codec:"result" default:"unknown"`
	// 选手1的积分
	Point int `bson:"point" codec:"point"`
	// 选手2的积分
	DefencePoint int `bson:"defence_point" codec:"defence_point"`
}

func (*CrossCraftPlayRecord) CollectionName() string {
	return "CrossCraftPlayRecord"
}

type CrossCraftRole struct {
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

type CrossCraftBattleRole struct {
	CrossCraftRole `bson:",inline"`
	FightingPoint  int         `bson:"fighting_point" codec:"fighting_point"`
	Cards          []CardTuple `bson:"cards" codec:"cards"`
	// fighting_point, top_card
	Display map[string]int `bson:"display,omitempty" codec:"display,omitempty"`
}

type CrossCraftBattleHistory struct {
	Time   float64 `bson:"time" codec:"time"`
	Round  string  `bson:"round" codec:"round"`
	Result string  `bson:"result" codec:"result"`
	Point  int     `bson:"point" codec:"point"`

	FightingPoint int         `bson:"fighting_point" codec:"fighting_point"`
	Cards         []CardTuple `bson:"cards" codec:"cards"`

	Enemy        *CrossCraftBattleRole `bson:"enemy,omitempty" codec:"enemy,omitempty"`
	PlayRecordID *document.ID          `bson:"prid,omitempty" codec:"prid,omitempty"`
	CrossKey     string                `bson:"cross_key" codec:"cross_key"`
}

// 跨服王者全局记录
type CrossCraftGlobal struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key" unique:"true"`
	// 参与的server [node key list]
	Servers []string `bson:"servers" codec:"servers"`
	// service.csv的CSV ID
	CsvId int `bson:"csv_id" codec:"csv_id"`
	// 开始日期
	Date int `bson:"date" codec:"date"`
	// CraftGlobal.time
	Time int64 `bson:"time" codec:"time"`
	// round
	Round string `bson:"round" codec:"round" default:"closed"`
	// 每日特色buff [csv_id, ...]
	Buffs []int `bson:"buffs" codec:"buffs"`
	// 总参赛人员
	CraftRoles map[document.ID]*CrossCraftRoleInfo `bson:"craft_roles" codec:"craft_roles"`
	// 8强战斗记录
	Top8Plays map[string]map[string]*CrossCraftTop8Play `bson:"top8_plays" codec:"top8_plays"`
	// 战局总记录 {pre1: {key: CraftResultInfo}}
	RoundResults map[string]map[string]*CrossCraftResultInfo `bson:"round_results" codec:"round_results"`
	// 预选竞猜(第一天结束本服前3)
	PreBet map[document.ID][]*CrossCraftBet `bson:"pre_bet" codec:"pre_bet"`
	// 四强下注
	Top4Bet map[document.ID][]*CrossCraftBet `bson:"top4_bet" codec:"top4_bet"`
	// 冠军下注
	ChampionBet map[document.ID]*CrossCraftChampionBet `bson:"champion_bet" codec:"champion_bet"`
	// 下注玩家 server key
	RoleServKeys map[document.ID]string `bson:"role_servkeys" codec:"role_servkeys"`
	//预选赛单服积分排行榜
	PrePointRanks map[string][]PreRankRolePoint `bson:"pre_point_ranks" codec:"pre_point_ranks"`
}

func (*CrossCraftGlobal) CollectionName() string {
	return "CrossCraftGlobal"
}

type PreRankRolePoint struct {
	ID            document.ID `bson:"id" codec:"id"`
	Point         int         `bson:"point" codec:"point"`
	FightingPoint int         `bson:"fighting_point" codec:"fighting_point"`
}

type CrossCraftRoleInfo struct {
	CrossCraftRole `bson:",inline"`

	Round int `bson:"round" codec:"round"`
	Win   int `bson:"win" codec:"win"`
	Point int `bson:"point" codec:"point"`

	Rank int `bson:"rank" codec:"rank"`
}

type CrossCraftResultInfo CraftResultInfo

type CrossCraftTop8Play struct {
	CrossKey string               `bson:"cross_key" codec:"cross_key"`
	PlayID   document.ID          `bson:"play_id" codec:"play_id"`
	Role1    CrossCraftBattleRole `bson:"role1" codec:"role1"`
	Role2    CrossCraftBattleRole `bson:"role2" codec:"role2"`
	Result   string               `bson:"result" codec:"result"`
	Points   [2]int               `bson:"points" codec:"points"`
}

// 跨服王者Game全局记录
type CrossCraftGameGlobal struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key" unique:"true"`
	// 跨服server key
	CrossKey string `bson:"cross_key" codec:"cross_key"`
	// 开始日期
	Date int `bson:"date" codec:"date"`
	// CraftGlobal.time
	Time int64 `bson:"time" codec:"time"`
	// CraftGlobal.round
	Round string `bson:"round" codec:"round" default:"closed"`
	// 报名 {Role.id: RoleSignItem}
	Signup map[document.ID]CrossCraftRoleSignItem `bson:"signup" codec:"signup"`
	// 上期排行榜
	LastRanks []CrossCraftRoleInfo `bson:"last_ranks" codec:"last_ranks"`
	// 上期8强战斗记录 CraftGlobal.top8_plays
	LastTop8Plays map[string]map[string]*CrossCraftTop8Play `bson:"last_top8_plays" codec:"last_top8_plays"`
	// 上期刷新时间
	LastRefreshTime int `bson:"last_refresh_time" codec:"last_refresh_time"`
	// 上期竞猜数据
	LastBetInfo LastBetInfo `bson:"last_bet_info" codec:"last_bet_info"`
	// 上期预选赛积分排行
	LastPrePointRanks []PreRankRolePoint `bson:"last_pre_point_ranks" codec:"last_pre_point_ranks"`
}

func (*CrossCraftGameGlobal) CollectionName() string {
	return "CrossCraftGameGlobal"
}

type CrossCraftRoleSignItem struct {
	ID       document.ID `bson:"id" codec:"id"`
	Name     string      `bson:"name" codec:"name"`
	GameKey  string      `bson:"game_key" codec:"game_key"`
	Logo     int         `bson:"logo" codec:"logo"`
	Frame    int         `bson:"frame" codec:"frame"`
	Level    int         `bson:"level" codec:"level"`
	Figure   int         `bson:"figure" codec:"figure"`
	Title    int         `bson:"title_id" codec:"title_id"`
	Vip      int         `bson:"vip_level" codec:"vip_level"`
	RecordID document.ID `bson:"cross_craft_record_db_id" codec:"cross_craft_record_db_id"`
	Manual   bool        `bson:"manual" codec:"manual"` // 是否是手动报名
}

// 四强竞猜/预选竞猜
type CrossCraftBet struct {
	Role    CrossCraftRole `bson:"role" codec:"role"` // 被下注玩家的信息
	Coin    string         `bson:"coin" codec:"coin"` // gold/coin8
	Amount  int            `bson:"amount" codec:"amount"`
	Success bool           `bson:"success" codec:"success"` // 是否预测成功
}

// 冠军竞猜
type CrossCraftChampionBet struct {
	Role          CrossCraftRole      `bson:"role" codec:"role"`
	Rank          int                 `bson:"rank" codec:"rank"`
	GoldRate      float64             `bson:"gold_rate" codec:"gold_rate"`
	Gold          map[document.ID]int `bson:"gold" codec:"gold"`
	CoinRate      float64             `bson:"coin_rate" codec:"coin_rate"`
	Coin          map[document.ID]int `bson:"coin" codec:"coin"`
	FightingPoint int                 `bson:"fighting_point" codec:"fighting_point"`
}

type RoleBetChampion struct {
	_struct struct{} `codec:",toarray"`

	RoleID document.ID `bson:"role_id"`
	Coin   string      `bson:"coin"` // gold/coin
}

// 上期竞猜数据
type LastBetInfo struct {
	PreBet          map[document.ID][]CrossCraftBet       `bson:"pre_bet" codec:"pre_bet"`
	Top4Bet         map[document.ID][]CrossCraftBet       `bson:"top4_bet" codec:"top4_bet"`
	ChampionBet     map[document.ID]CrossCraftChampionBet `bson:"champion_bet" codec:"champion_bet"`
	RoleBetChampion map[document.ID]RoleBetChampion       `bson:"role_bet_champion" codec:"role_bet_champion"`
}

package scheme

import "tjgame/document"

// 实时对战记录
type CrossOnlineFightRecord struct {
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

	// 无限制模式部署卡牌列表
	Cards []document.ID `bson:"cards" codec:"cards"`
	// 无限制模式卡牌离线属性 {cardID: CardBattleModel}
	CardAttrs map[document.ID]*CardBattleModel `bson:"card_attrs" codec:"card_attrs"`
	// 无限制模式卡牌离线属性 {cardID: CardBattleModel}
	CardAttrs2 map[document.ID]*CardBattleModel `bson:"card_attrs2" codec:"card_attrs2"`
	// 无限制模式全局被动技能
	PassiveSkills map[document.Integer]int `bson:"passive_skills" codec:"passive_skills"`

	// 战斗历史
	UnlimitedHistory []CrossOnlineFightHistory `bson:"unlimited_history" codec:"unlimited_history"`
	LimitedHistory   []CrossOnlineFightHistory `bson:"limited_history" codec:"limited_history"`
}

func (*CrossOnlineFightRecord) CollectionName() string {
	return "CrossOnlineFightRecord"
}

type CrossOnlineFightHistory struct {
	Time   int64  `bson:"time" codec:"time"`
	Result string `bson:"result" codec:"result"`

	PlayRecordID document.ID `bson:"play_record_id" codec:"play_record_id"`
	CrossKey     string      `bson:"cross_key" codec:"cross_key"`

	Enemy CrossOnlineFightRole `bson:"enemy" codec:"enemy"`
	// 结束之后的积分
	Score int `bson:"score" codec:"score"`
	// 积分的变化值
	Delta int `bson:"delta" codec:"delta"`

	// 操作数量 [2]int{len(result.BanPickInputSteps), len(result.AttackFrames)},
	Frames [2]int `bson:"frames" codec:"frames"`
}

// 实时对战战斗记录
type CrossOnlineFightPlayRecord struct {
	document.DocumentID `bson:",inline"`

	// 战斗日期
	Date int `bson:"date" codec:"date" default:"todaydate2int" index:"true"`
	// 战斗时间
	Time float64 `bson:"time" codec:"time" default:"nowtime_t"`
	// 战斗随机种子
	RandSeed int32 `bson:"rand_seed" codec:"rand_seed"`

	// 主动进攻方 Role.key
	RoleKey RoleKey `bson:"role_key" codec:"role_key" index:"role_key.id"`
	// 主动进攻方 CrossOnlineFightRecord.id
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

	// 被动防御方 Role.key
	DefenceRoleKey RoleKey `bson:"defence_role_key" codec:"defence_role_key" index:"defence_role_key.id"`
	// 被动防御方 CrossOnlineFightRecord.id
	DefenceRecordId document.ID `bson:"defence_record_id" codec:"defence_record_id"`
	// 被动防御方角色名字
	DefenceName string `bson:"defence_name" codec:"defence_name"`
	// 被动防御方角色头像ID
	DefenceLogo int `bson:"defence_logo" codec:"defence_logo"`
	// 被动防御方角色头像框ID
	DefenceFrame int `bson:"defence_frame" codec:"defence_frame"`
	// 被动防御方角色等级
	DefenceLevel int `bson:"defence_level" codec:"defence_level"`
	// 被动进攻方角色形象
	DefenceFigure int `bson:"defence_figure" codec:"defence_figure"`

	// 被动防御部署卡牌列表
	DefenceCards []document.ID `bson:"defence_cards" codec:"defence_cards"`
	// 被动防御卡牌离线属性
	DefenceCardAttrs map[document.ID]*CardBattleModel `bson:"defence_card_attrs" codec:"defence_card_attrs"`
	// 被动防御卡牌离线属性
	DefenceCardAttrs2 map[document.ID]*CardBattleModel `bson:"defence_card_attrs2,omitempty" codec:"defence_card_attrs2,omitempty"`
	// 被动防御全局被动技能
	DefencePassiveSkills map[document.Integer]int `bson:"defence_passive_skills" codec:"defence_passive_skills"`

	// 公平赛卡组信息
	LimitedCardDeck *CrossOnlineFightLimitedCardDeck `bson:"limited_card_deck,omitempty" codec:"limited_card_deck,omitempty"`
	// 板卡，选卡，布阵操作序列
	BanPickInputSteps []BanPickInputStep `bson:"banpick_input_steps,omitempty" codec:"banpick_input_steps,omitempty"`

	// 攻击操作集
	AttackFrames []AttackFrame `bson:"attack_frames" codec:"attack_frames"`
	// 战斗结果
	Result [2]string `bson:"results" codec:"results"`
	// 积分变化
	Scores [2]int `bson:"scores" codec:"scores"`
}

type CrossOnlineFightCard struct {
	ID            document.ID `bson:"id" codec:"id"`
	CardId        int         `bson:"card_id" codec:"card_id"`
	SkinId        int         `bson:"skin_id" codec:"skin_id"`
	Level         int         `bson:"level" codec:"level"`
	FightingPoint int         `bson:"fighting_point" codec:"fighting_point"`
	Star          int         `bson:"star" codec:"star"`
	Advance       int         `bson:"advance" codec:"advance"`
}

// 公平赛卡组信息
type CrossOnlineFightLimitedCardDeck struct {
	// 公平赛使用卡牌列表
	RoleCardDeck1 []document.ID `bson:"card_deck1" codec:"card_deck1"`
	RoleCardDeck2 []document.ID `bson:"card_deck2" codec:"card_deck2"`
	// 公平赛使用的卡牌
	Cards map[document.ID]*CrossOnlineFightCard `bson:"cards" codec:"cards"`
}

type BanPickInputStep [2]*BanPickInput

// 板卡，选卡，布阵操作
type BanPickInput struct {
	Step   int           `bson:"step" codec:"step"`
	Action int           `bson:"action" codec:"action"` // 1-ban,2-pick,3-deploy
	Cards  []document.ID `bson:"cards" codec:"cards"`
}

type AttackFrame struct {
	// 回合数, 血量，怒气记录？
	Input AttackInput `bson:"input" codec:"input"`
}

// 攻击操作
type AttackInput struct {
	_struct struct{} `codec:",toarray"`

	FrameID int `bson:"frame_id"`
	Current int `bson:"current"`
	Target  int `bson:"target"`
	Skill   int `bson:"skill"`
}

func (*CrossOnlineFightPlayRecord) CollectionName() string {
	return "CrossOnlineFightPlayRecord"
}

type CrossOnlineFightRole struct {
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

type BattleRecord struct {
	_struct struct{} `codec:",toarray"`

	Win        int `bson:"win"`
	WinStreak  int `bson:"winstreak"`
	Fail       int `bson:"fail"`
	FailStreak int `bson:"failstreak"`
}

type CrossOnlineFightRoleInfo struct {
	CrossOnlineFightRole `bson:",inline"`

	// 无限制赛积分
	UnlimitedScore int `bson:"unlimited_score" codec:"unlimited_score"`
	// 无限制赛战斗记录
	UnlimitedRecord *BattleRecord `bson:"unlimited_record" codec:"unlimited_record"`
	// 无限制赛历史最高积分
	UnlimitedTopScore int `bson:"unlimited_top_score,omitempty" codec:"unlimited_top_score"`
	// 公平赛积分
	LimitedScore int `bson:"limited_score" codec:"limited_score"`
	// 公平赛战斗记录
	LimitedRecord *BattleRecord `bson:"limited_record" codec:"limited_record"`
	// 公平赛历史最高积分
	LimitedTopScore int `bson:"limited_top_score,omitempty" codec:"limited_top_score"`
	// 每周胜场次数
	WinTimes int `bson:"win_times" codec:"win_times"`
	// 每周参与次数
	BattleTimes int `bson:"battle_times" codec:"battle_times"`
}

type CrossOnlineFightRankRole struct {
	CrossOnlineFightRole `bson:",inline"`

	Score int `bson:"score" codec:"score"`
}

type CrossOnlineFightGlobal struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key" unique:"true"`
	// 参与的server [node key list]
	Servers []string `bson:"servers" codec:"servers"`
	// service.csv的CSV ID
	CsvId int `bson:"csv_id" codec:"csv_id"`
	// 开始日期
	StartDate int `bson:"start_date" codec:"start_date"`
	// 结束时间
	EndDate int `bson:"end_date" codec:"end_date"`
	// round
	Round string `bson:"round" codec:"round" default:"closed"`
	// 上次结算日期
	LastAwardDate int `bson:"last_award_date" codec:"last_award_date"`

	// 总参赛人员
	Roles map[document.ID]*CrossOnlineFightRoleInfo `bson:"roles" codec:"roles"`

	// 公平赛卡牌使用统计
	CardReport map[document.Integer]map[string]int `bson:"card_report" codec:"card_report"`

	// 精彩战报
	UnlimitedTopBattleHistory []CrossOnlineFightTopBattleHistory `bson:"unlimited_top_battle_history" codec:"unlimited_top_battle_history"`
	LimitedTopBattleHistory   []CrossOnlineFightTopBattleHistory `bson:"limited_top_battle_history" codec:"limited_top_battle_history"`
}

func (*CrossOnlineFightGlobal) CollectionName() string {
	return "CrossOnlineFightGlobal"
}

type CrossOnlineFightGameGlobal struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key" unique:"true"`
	// 跨服server key
	CrossKey string `bson:"cross_key" codec:"cross_key"`
	// 上期非限制赛排名
	LastUnLimitedRanks []CrossOnlineFightRankRole `bson:"last_unlimited_ranks" codec:"last_unlimited_ranks"`
	// 上期公平赛排名
	LastLimitedRanks []CrossOnlineFightRankRole `bson:"last_limited_ranks" codec:"last_limited_ranks"`
	// 精彩战报
	LastUnlimitedTopBattleHistory []CrossOnlineFightTopBattleHistory `bson:"last_unlimited_top_battle_history" codec:"last_unlimited_top_battle_history"`
	LastLimitedTopBattleHistory   []CrossOnlineFightTopBattleHistory `bson:"last_limited_top_battle_history" codec:"last_limited_top_battle_history"`
}

func (*CrossOnlineFightGameGlobal) CollectionName() string {
	return "CrossOnlineFightGameGlobal"
}

type CrossOnlineFightTopBattleHistory struct {
	Time   float64 `bson:"time" codec:"time"`
	Result string  `bson:"result" codec:"result"`

	PlayRecordID document.ID `bson:"play_record_id" codec:"play_record_id"`
	CrossKey     string      `bson:"cross_key" codec:"cross_key"`

	RoleKey  RoleKey     `bson:"role_key" codec:"role_key"`
	RecordID document.ID `bson:"record_id" codec:"record_id"`
	Name     string      `bson:"name" codec:"name"`
	Logo     int         `bson:"logo" codec:"logo"`
	Frame    int         `bson:"frame" codec:"frame"`
	Level    int         `bson:"level" codec:"level"`
	Rank     int         `bson:"rank" codec:"rank"`
	Score    int         `bson:"score" codec:"score"`

	DefenceRoleKey  RoleKey     `bson:"defence_role_key" codec:"defence_role_key"`
	DefenceRecordID document.ID `bson:"defence_record_id" codec:"defence_record_id"`
	DefenceName     string      `bson:"defence_name" codec:"defence_name"`
	DefenceLogo     int         `bson:"defence_logo" codec:"defence_logo"`
	DefenceFrame    int         `bson:"defence_frame" codec:"defence_frame"`
	DefenceLevel    int         `bson:"defence_level" codec:"defence_level"`
	DefenceRank     int         `bson:"defence_rank" codec:"defence_rank"`
	DefenceScore    int         `bson:"defence_score" codec:"defence_score"`
}

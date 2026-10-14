package scheme

import (
	"tjgame/document"
)

type UnioinFightCards map[document.Integer]map[document.Integer][]document.ID

// 王者全局记录
type UnionFightGlobal struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key"`
	// 日期
	Date int `bson:"date" codec:"date"`
	// CraftGlobal.time
	Time int64 `bson:"time" codec:"time"`
	// 上次结算日期
	LastAwardTime int `bson:"last_award_time" codec:"last_award_time"`
	// closed, signup, prepare, over, battle
	Round string `bson:"round" codec:"round" default:"'closed'"`
	// 8强战斗记录
	Top8Plays map[string]map[document.Integer][]UnionFightResultInfo `bson:"top8_plays" codec:"top8_plays"`
	// 战局总记录 {pre1: {key: CraftResultInfo}}
	// RoundResults map[document.ID]map[document.Integer][]UnionFightResultInfo `bson:"round_results" codec:"round_results"`
	// 最大战斗轮次
	RoundResultMax int `bson:"round_result_max" codec:"round_result_max"`
	// 最后获胜者ID
	LastRoleID document.ID `bson:"last_role_id" codec:"last_role_id"`
	// 最后获胜者公会ID
	LastUnionID document.ID `bson:"last_union_id" codec:"last_union_id"`
	// 参与公会
	Unions map[document.ID]*UnionFightUnionInfo `bson:"unions" codec:"unions"`
	// 参与角色
	Roles map[document.ID]*UnionFightRoleInfo `bson:"roles" codec:"roles"`
	// 角色榜
	RoleRanks map[document.Integer][]UnionFightRoleRankItem `bson:"role_ranks" codec:"role_ranks"`
	// 公会榜
	UnionRanks map[document.Integer][]UnionFightUnionRankItem `bson:"union_ranks" codec:"union_ranks"`
	// 战斗之星
	BattleStars map[document.Integer]map[document.Integer]int `bson:"battle_stars" codec:"battle_stars"`
	// 昨天前20下注
	Bet map[document.ID]*UnionFightBet `bson:"bet" codec:"bet"`
	// top8 对战信息
	Top8VSInfo map[document.Integer]*UnionFightTop8VSUnionInfo `bson:"top8_vs_info" codec:"top8_vs_info"`
	// 当日战斗结果数据
	FinalResult []UnionFightFinalResultItem `bson:"final_result" codec:"final_result"`
}

type UnionFightTop8VSUnionInfo struct {
	_struct struct{} `codec:",toarray"`

	UnionID    document.ID // 公会ID
	UnionName  string      // 公会名
	UnionLogo  int         // 公会 logo
	UnionLevel int         // 公会 level
	UnionSigns int         // 公会成员数
	UnionLives int         // 公会报名数
}

type UnionFightFinalResultItem struct {
	Rank       int    `bson:"rank" codec:"rank"`
	UnionName  string `bson:"union_name" codec:"union_name"`
	UnionLogo  int    `bson:"union_logo" codec:"union_logo"`
	UnionLevel int    `bson:"union_level" codec:"union_level"`
	SignNum    int    `bson:"sign_num" codec:"sign_num"`
	KillNum    int    `bson;:"kill_num" codec:"kill_num"`
	Point      int    `bson:"point" codec:"point"`
}

type UnionFightUnionStar struct {
	//UnionID      document.ID `bson:"union_id" codec:"union_id"`
	//StarNum      int         `bson:"star_num" codec:"star_num"`
	//EffectNature int         `bson:"effect_nature" codec:"effect_nature"`
	//EffectAttr   int         `bson:"effect_attr" codec:"effect_attr"`
	//EffectUpType int         `bson:"effect_up_type" codec:"effect_up_type"`
	Attr      int `bson:"attr" codec:"attr"`
	EffectNum int `bson:"effect_num" codec:"effect_num"`
}

type UnionFightRankOnceItem struct {
	_struct struct{} `codec:",toarray"`

	Rank  int `bson:"rank" codec:"rank"`
	Point int `bson:"point" codec:"point"`
}

type UnionFightUnionInfo struct {
	UnionID         document.ID                                 `bson:"union_id" codec:"union_id"`
	Name            string                                      `bson:"name" codec:"name"`
	Logo            int                                         `bson:"logo" codec:"logo"`
	Level           int                                         `bson:"level" codec:"level"`
	SignNum         int                                         `bson:"sign_num" codec:"sign_num"`
	DeadNum         int                                         `bson:"dead_num" codec:"dead_num"`
	KillNum         int                                         `bson:"kill_num" codec:"kill_num"`
	MemberNum       int                                         `bson:"member_num" codec:"member_num"`
	IsOut           bool                                        `bson:"is_out" codec:"is_out"`
	RoundMax        int                                         `bson:"round_max" codec:"round_max"`
	Point           int                                         `bson:"point" codec:"point"`
	PointSum        int                                         `bson:"point_sum" codec:"point_sum"`
	RankRecord      map[document.Integer]UnionFightRankOnceItem `bson:"rank_record" codec:"rank_record"`
	Roles           []document.ID                               `bson:"roles" codec:"roles"`
	Top8MaxRoundKey int                                         `bson:"top8_max_round_key" codec:"top8_max_round_key"`
	LastRoleName    string                                      `bson:"last_role_name" codec:"last_role_name"`
}

type UnionFightRoleInfo struct {
	RoleID            document.ID                                     `bson:"role_db_id,omitempty" codec:"role_db_id,omitempty"`
	RecordID          document.ID                                     `bson:"record_db_id,omitempty" codec:"record_db_id,omitempty"`
	Point             int                                             `bson:"point" codec:"point"`
	PointSum          int                                             `bson:"point_sum" codec:"point_sum"`
	RankRecord        map[document.Integer]UnionFightRankOnceItem     `bson:"rank_record" codec:"rank_record"`
	KillNum           int                                             `bson:"kill_num" codec:"kill_num"`
	CurTroop          int                                             `bson:"cur_troop" codec:"cur_troop"`
	CurTroopBattleNum int                                             `bson:"cur_troop_battle_num" codec:"cur_troop_battle_num"`
	DeedInfo          map[document.Integer]bool                       `bson:"dead_info" codec:"dead_info"`
	CardState         map[document.Integer]map[document.ID][2]float64 `bson:"card_state" codec:"card_state"`
}

type UnionFightResultInfo struct {
	PlayID       document.ID          `bson:"play_id" codec:"play_id"`
	Result       string               `bson:"result" codec:"result"`
	Left         UnionFightResultItem `bson:"left" codec:"left"`
	Right        UnionFightResultItem `bson:"right" codec:"right"`
	Top83V3Round int                  `bson:"top8_3v3_round" codec:"top8_3v3_round"`
}

type UnionFightResultItem struct {
	RoleID     document.ID `bson:"role_id" codec:"role_id"`
	RoleName   string      `bson:"role_name" codec:"role_name"`
	RoleLogo   int         `bson:"role_logo" codec:"role_logo"`
	RoleFrame  int         `bson:"role_frame" codec:"role_frame"`
	RoleLevel  int         `bson:"role_level" codec:"role_level"`
	RoleFigure int         `bson:"role_figure" codec:"role_figure"`
	RoleTitle  int         `bson:"role_title" codec:"role_title"`
	UnionID    document.ID `bson:"union_id" codec:"union_id"`
	UnionName  string      `bson:"union_name" codec:"union_name"`
	HP         int         `bson:"hp" codec:"hp"`
	Troops     int         `bson:"troops" codec:"troops"`
}

type UnionFightRoleRankItem struct {
	Rank   int    `bson:"rank" codec:"rank"`
	Name   string `bson:"name" codec:"name"`
	Logo   int    `bson:"logo" codec:"logo"`
	Frame  int    `bson:"frame" codec:"frame"`
	Level  int    `bson:"level" codec:"level"`
	Figure int    `bson:"figure" codec:"figure"`
	Point  int    `bson:"point" codec:"point"`
}

type UnionFightUnionRankItem struct {
	UnionID document.ID `bson:"union_id" codec:"union_id"`
	Rank    int         `bson:"rank" codec:"rank"`
	Name    string      `bson:"name" codec:"name"`
	Logo    int         `bson:"logo" codec:"logo"`
	Point   int         `bson:"point" codec:"point"`
	Level   int         `bson:"level" codec:"level"`
}

func (*UnionFightGlobal) CollectionName() string {
	return "UnionFightGlobal"
}

type UnionFightRole struct {
	RoleID   document.ID `bson:"role_db_id,omitempty" codec:"role_db_id,omitempty"`
	RecordID document.ID `bson:"record_db_id,omitempty" codec:"record_db_id,omitempty"`
	Name     string      `bson:"name" codec:"name"`
	Logo     int         `bson:"logo" codec:"logo"`
	Frame    int         `bson:"frame" codec:"frame"`
	Level    int         `bson:"level" codec:"level"`
	Figure   int         `bson:"figure" codec:"figure"`
}

type UnionFgihtUnion struct {
	UnionID document.ID `bson:"union_id" codec:"union_id"`
	Name    string      `codec:"name"`
	Logo    int         `codec:"logo"`
	Level   int         `codec:"level"`
}

type UnionBattleRole struct {
	UnionFightRole `bson:",inline"`
	FightingPoint  int         `bson:"fighting_point" codec:"fighting_point"`
	Cards          []CardTuple `bson:"cards" codec:"cards"`
	// fighting_point, top_card
	Display map[string]int `bson:"display,omitempty" codec:"display,omitempty"`
}

type UnionFightBattleHistory struct {
	Time   float64 `bson:"time" codec:"time"`
	Round  string  `bson:"round" codec:"round"`
	Result string  `bson:"result" codec:"result"`
	Point  int     `bson:"point" codec:"point"`

	FightingPoint int         `bson:"fighting_point" codec:"fighting_point"`
	Cards         []CardTuple `bson:"cards" codec:"cards"`

	Enemy        *UnionBattleRole `bson:"enemy,omitempty" codec:"enemy,omitempty"`
	PlayRecordID *document.ID     `bson:"prid,omitempty" codec:"prid,omitempty"`
}

// 公会战记录
type UnionFightRoleRecord struct {
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
	Cards UnioinFightCards `bson:"cards" codec:"cards"`
	// 卡牌离线属性 (prepare阶段复制自HoldCardAttrs)
	CardAttrs map[document.ID]*CardBattleModel `bson:"card_attrs" codec:"card_attrs"`
	// 卡牌离线属性 (prepare阶段复制自HoldCardAttrs)
	CardAttrs2 map[document.ID]*CardBattleModel `bson:"card_attrs2" codec:"card_attrs2"`
	// 部署卡牌列表
	HoldCards UnioinFightCards `bson:"hold_cards" codec:"hold_cards"`
	// 卡牌离线属性 (prepare阶段复制自HoldCardAttrs)
	HoldCardAttrs map[document.ID]*CardBattleModel `bson:"hold_card_attrs" codec:"hold_card_attrs"`
	// 卡牌离线属性 (prepare阶段复制自HoldCardAttrs)
	HoldCardAttrs2 map[document.ID]*CardBattleModel `bson:"hold_card_attrs2" codec:"hold_card_attrs2"`
	// 全局被动技能 (prepare阶段复制自HoldPassiveSkills)
	PassiveSkills map[document.Integer]int `bson:"passive_skills" codec:"passive_skills"`
	// 战斗历史
	History []UnionFightBattleHistory `bson:"history" codec:"history"`
	// 公会ID
	UnionDbId document.ID `bson:"union_db_id" codec:"union_db_id"`
	// 公会名称
	UnionName string `bson:"union_name" codec:"union_name"`
}

func (*UnionFightRoleRecord) CollectionName() string {
	return "UnionFightRoleRecord"
}

// 公会战公会记录
type UnionFightUnionRecord struct {
	document.DocumentID `bson:",inline"`

	// Union.id
	UnionDbId document.ID `bson:"union_db_id" codec:"union_db_id" unique:"true"`
	// Union.name
	UnionName string `bson:"union_name" codec:"union_name"`
	// Union.logo
	UnionLogo int `bson:"union_logo" codec:"union_logo"`
	// Union.level
	UnionLevel int `bson:"union_level" codec:"union_level"`
	// 战斗结果
	RoundResults map[string][]UnionFightResultInfo `bson:"round_results" codec:"round_results"`
	// 战斗结果
	YesterdayRoundResults map[string][]UnionFightResultInfo `bson:"yesterday_round_results" codec:"yesterday_round_results"`
	// 昨日信息
	YesterdayInfo UnionFightUUnionYesterdayInfo `bson:"yesterday_info" codec:"yesterday_info"`
	// 战斗之星数量
	BattleStarNum int `bson:"battle_star_num" codec:"battle_star_num"`
}

type UnionFightUUnionYesterdayInfo struct {
	Members      int    `bson:"members" codec:"members"`
	Signs        int    `bson:"signs" codec:"signs"`
	LiveNum      int    `bson:"live_num" codec:"live_num"`
	LastRoleName string `bson:"last_role_name" codec:"last_role_name"`
	IsOut        bool   `bson:"is_out" codec:"is_out"`
}

func (*UnionFightUnionRecord) CollectionName() string {
	return "UnionFightUnionRecord"
}

type UnionFightPlayRecord struct {
	document.DocumentID `bson:",inline"`

	// 战斗日期
	Date int `bson:"date" codec:"date" default:"todaydate2int"`
	// 战斗时间
	Time float64 `bson:"time" codec:"time" default:"nowtime_t"`
	// 战斗随机种子
	RandSeed int32 `bson:"rand_seed" codec:"rand_seed"`
	// 战斗场次
	Round string `bson:"round" codec:"round"`
	// top8 战斗场次内的3v3场次
	Top83V3Round int `bson:"top8_3v3_round" codec:"top8_3v3_round"`

	// 主动进攻方 Role.id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id"`
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
	// 主动进攻卡牌状态 {cardID:{hp, mp)}
	CardStates map[document.ID][2]float64 `bson:"card_states" codec:"card_states"`
	// 队伍
	Troops int `bson:"troops" codec:"troops"`

	// 被动防御方 Role.id
	DefenceRoleDbId document.ID `bson:"defence_role_db_id" codec:"defence_role_db_id"`
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
	// 队伍
	DefenceTroops int `bson:"defence_troops" codec:"defence_troops"`

	// 战斗结果
	Result string `bson:"result" codec:"result" default:"unknown"`
	// 选手1的积分
	Point int `bson:"point" codec:"point"`
	// 选手2的积分
	DefencePoint int `bson:"defence_point" codec:"defence_point"`
}

func (*UnionFightPlayRecord) CollectionName() string {
	return "UnionFightPlayRecord"
}

type UnionFightBet struct {
	Union UnionFgihtUnion     `bson:"union" codec:"union"`
	Rank  int                 `bson:"rank" codec:"rank"`
	Rate  float64             `bson:"rate" codec:"rate"`
	Gold  map[document.ID]int `bson:"gold" codec:"gold"`

	Point int `bson:"point" codec:"point"`
}

// 工会战全局数据
type UnionFightGameGlobal struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key"`
	// CraftGlobal.time
	Time int64 `bson:"time" codec:"time"`
	// 日期
	Date int `bson:"date" codec:"date"`
	// 上次结算日期
	LastAwardTime int `bson:"last_award_time" codec:"last_award_time"`
	// 报名 {Role.id: RoleSignItem}
	Signup map[document.ID]UnionFightRoleSignItem `bson:"signup" codec:"signup"`
	// closed, signup, prepare, over, battle
	Round string `bson:"round" codec:"round" default:"'closed'"`
	// 胜场数 {weekday:{roleID:winCount}}
	//RolesWin document.RawMap `bson:"roles_win" codec:"roles_win"`
	// 上次playrecord最大dbkey
	//LastPkeyMax int `bson:"last_pkey_max" codec:"last_pkey_max" default:"1"`
	// 预选赛最后一个玩家[lastround,roleID,unionID]
	//LastRole document.Raw `bson:"last_role" codec:"last_role" default:"list"`
	// 周六决赛前前8公会[(unionID,name,logo,point)]
	//PreTop8Union document.Raw `bson:"pre_top8_union" codec:"pre_top8_union" default:"list"`
	// 8强对阵信息{1:(unionID1,unionID2,winUnionID),...7:(unionID1,unionID2,winUnionID)}
	//SceneVsInfo document.RawMap `bson:"scene_vs_info" codec:"scene_vs_info"`
	// 8强对阵每轮信息 {sceneNum:(field, round, lastUnionID)}
	//FinalBattleInfo document.RawMap `bson:"final_battle_info" codec:"final_battle_info"`
	// 角色连胜数排名{weekday:[(roleID,roleName,unionName,score)]}
	//RoleRanks document.RawMap `bson:"role_ranks" codec:"role_ranks"`
	// {unionID:{rank:,name:,logo:,level:,rate:,gold:{roleID:gold}}}
	//Bet document.RawMap `bson:"bet" codec:"bet"`
	// {field:{round:{union_db_id:(deadcount,membercount,name)}}}
	//DeadRounds document.RawMap `bson:"dead_rounds" codec:"dead_rounds"`
	// {sceneNum:{round:{unionID: (deadcount, membercount, name)}}}
	//FinalDeadRounds document.RawMap `bson:"final_dead_rounds" codec:"final_dead_rounds"`
	// 八强公会
	Top8VSUnion map[document.ID][]document.ID `bson:"top8_vs_union" codec:"top8_vs_union"`
	// 历史前5公会ID，用于确定跨服公会战参赛名单
	Top5History [][]document.ID `bson:"top5_history" codec:"top5_history"`
}

func (*UnionFightGameGlobal) CollectionName() string {
	return "UnionFightGameGlobal"
}

type UnionFightRoleSignItem struct {
	ID             document.ID `bson:"id" codec:"id"`
	Name           string      `bson:"name" codec:"name"`
	Logo           int         `bson:"logo" codec:"logo"`
	Frame          int         `bson:"frame" codec:"frame"`
	Level          int         `bson:"level" codec:"level"`
	Figure         int         `bson:"figure" codec:"figure"`
	Title          int         `bson:"title_id" codec:"title_id"`
	Vip            int         `bson:"vip_level" codec:"vip_level"`
	RecordID       document.ID `bson:"union_fight_record_db_id" codec:"union_fight_record_db_id"`
	UnionID        document.ID `bson:"union_db_id" codec:"union_db_id"`
	UnionName      string      `bson:"union_name" codec:"union_name"`
	UnionLogo      int         `bson:"union_logo" codec:"union_logo"`
	UnionLevel     int         `bson:"union_level" codec:"union_level"`
	UnionMemberNum int         `bson:"union_member_num" codec:"union_member_num"`
	Manual         bool        `bson:"manual" codec:"manual"` // 是否是手动报名
}

type UnionFightSignupItem struct {
	RoleID         document.ID
	RecordID       document.ID
	UnionID        document.ID
	UnionName      string
	UnionLogo      int
	UnionLevel     int
	UnionMemberNum int
}

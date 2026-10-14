package scheme

import "tjgame/document"

// 主角卡牌
type RoleCard struct {
	document.DocumentID `bson:",inline"`

	// Role.id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// 创建时间
	CreatedTime float64 `bson:"created_time" codec:"created_time" default:"nowtime_t"`
	// 获得时候初始星级
	GetStar int `bson:"getstar" codec:"getstar" default:"1"`
	// 名字
	Name string `bson:"name" codec:"name"`
	// 卡牌CSV ID
	CardId int `bson:"card_id" codec:"card_id"`
	// 卡牌进阶
	Advance int `bson:"advance" codec:"advance" default:"1"`
	// 卡牌星级
	Star int `bson:"star" codec:"star" default:"1"`
	// 卡牌等级
	Level int `bson:"level" codec:"level" default:"1"`
	// 性别
	Gender int `bson:"gender" codec:"gender"`
	// 性格
	Character int `bson:"character" codec:"character"`
	// 个体值
	NValue map[string]int `bson:"nvalue" codec:"nvalue"`
	// 激活的卡牌技能id列表 {skill_id:level}
	Skills map[document.Integer]int `bson:"skills" codec:"skills"`
	// 卡牌战斗力
	FightingPoint int `bson:"fighting_point" codec:"fighting_point"`
	// 锁定状态
	Locked bool `bson:"locked" codec:"locked"`
	// 自然属性选择
	NatureChoose int `bson:"nature_choose" codec:"nature_choose" default:"1"`
	// 卡牌进化
	Develop int `bson:"develop" codec:"develop" default:"1"`
	// 分支或形态切换次数
	BranchSwitchTimes int `bson:"branch_switch_times" codec:"branch_switch_times"`
	// 当前等级下卡牌积累的经验
	LevelExp int `bson:"level_exp" codec:"level_exp"`
	// 卡牌当前获得的总经验
	SumExp int `bson:"sum_exp" codec:"sum_exp"`
	// 个体值锁定状态
	NValueLocked map[string]bool `bson:"nvalue_locked" codec:"nvalue_locked"`
	// 个体值洗炼累计次数
	NValueRecastTotal int `bson:"nvalue_recast_total" codec:"nvalue_recast_total"`
	// 个体值洗炼累计消耗钻石
	NValueCostRmbTotal int `bson:"nvalue_cost_rmb_total" codec:"nvalue_cost_rmb_total"`
	// 个体值锁定数量洗炼次数
	NValueLockNumRecastTotal int `bson:"nvalue_locknum_recast_total" codec:"nvalue_locknum_recast_total"`
	// 个体值锁定保底洗炼触发次数
	NvalueLockNumRecastProcess int `bson:"nvalue_locknum_recast_process" codec:"nvalue_locknum_recast_process"`
	// 努力值
	EffortValues map[string]int `bson:"effort_values" codec:"effort_values"`
	// 努力值突破
	EffortAdvance int `bson:"effort_advance" codec:"effort_advance"`
	// 装备 {1:{equipd_id,star,level,advance,exp},2:{...},...}
	Equips map[document.Integer]Equip `bson:"equips" codec:"equips"`
	// 携带道具
	HeldItem document.ID `bson:"held_item" codec:"held_item"`
	// 卡牌属性，一定策略才会记录
	DBAttrs map[string]float64 `bson:"db_attrs" codec:"db_attrs"`
	// 当前使用的皮肤，0表示未使用
	SkinId int `bson:"skin_id" codec:"skin_id"`
	// 是否存在（可能已经被分解）
	ExistFlag bool `bson:"exist_flag" codec:"exist_flag" index:"true" default:"True"`
	// 升星消耗的万能整卡数量
	CostUniversalCards map[document.Integer]int `bson:"cost_universal_cards" codec:"cost_universal_cards"`
	// 特性 {csvID: strengthLevel}
	Abilities map[document.Integer]int `bson:"abilities" codec:"abilities"`
	// 宝石镶嵌 {位置: gemDbID}
	Gems map[document.Integer]document.ID `bson:"gems" codec:"gems"`
	// 技能等级
	SkillLevel []int `bson:"skill_level" codec:"skill_level"`
	// 满星技能等级
	StarSkillLevel []int `bson:"star_skill_level" codec:"star_skill_level"`
	// 守护勋章
	BadgeGuard []int `bson:"badge_guard" codec:"badge_guard"`
	// z觉醒技能
	ZawakeSkills []int `bson:"zawake_skills" codec:"zawake_skills"`
	// 芯片的装备 {栏位:chip}
	Chip map[document.Integer]document.ID `bson:"chip" codec:"chip"`
}

func (*RoleCard) CollectionName() string {
	return "RoleCard"
}

type CardSpec struct {
	_struct struct{}    `codec:",toarray"`
	ID      document.ID `bson:"id"`
	CardID  int         `bson:"card_id"`
	SkinID  int         `bson:"skin_id"`
}

type CardTuple struct {
	_struct struct{} `codec:",toarray"`

	ID     document.ID `bson:"id"`
	CardID int         `bson:"card_id"`
	SkinID int         `bson:"skin_id"`
}

type CardBattleModel struct {
	ID            document.ID `bson:"id" codec:"id"`
	CardId        int         `bson:"card_id" codec:"card_id"`
	SkinId        int         `bson:"skin_id" codec:"skin_id"`
	Level         int         `bson:"level" codec:"level"`
	FightingPoint int         `bson:"fighting_point" codec:"fighting_point"`
	Star          int         `bson:"star" codec:"star"`
	Advance       int         `bson:"advance" codec:"advance"`
	StarEffect    int         `bson:"star_effect" codec:"star_effect"`

	Skills        map[document.Integer]int `bson:"skills" codec:"skills"`
	PassiveSkills map[document.Integer]int `bson:"passive_skills" codec:"passive_skills"`
	Attrs         map[string]float64       `bson:"attrs" codec:"attrs"`
	Attrs2        map[string]float64       `bson:"attrs2" codec:"attrs2"`

	NatureChoose int `bson:"nature_choose" codec:"nature_choose" default:"1"`
	// 远征修正战力
	FightingPoint2 int `bson:"fighting_point2,omitempty" codec:"fighting_point2,omitempty"`
	// 夏日挑战修正unitID
	UnitId int `bson:"unit_id,omitempty" codec:"unit_id,omitempty"`
}

type Equip struct {
	EquipID       int `bson:"equip_id" codec:"equip_id"`
	Star          int `bson:"star" codec:"star"`
	Level         int `bson:"level" codec:"level"`
	Advance       int `bson:"advance" codec:"advance"`
	Exp           int `bson:"exp" codec:"exp"`
	Awake         int `bson:"awake" codec:"awake"`
	Ability       int `bson:"ability" codec:"ability"`
	Signet        int `bson:"signet" codec:"signet"`
	SignetAdvance int `bson:"signet_advance" codec:"signet_advance"`
	AwakeAbility  int `bson:"awake_ability" codec:"awake_ability"`
}

type Metals struct {
	_struct struct{} `codec:",toarray"`

	Matrix1 [4]document.ID `bson:"matrix1"`
	Matrix2 [6]document.ID `bson:"matrix2"`
	Matrix3 [8]document.ID `bson:"matrix3"`
}

// 精灵评论
type CardComment struct {
	document.DocumentID `bson:",inline"`

	// 发表评论的角色 ID
	RoleID document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// 内容
	Content string `bson:"content" codec:"content"`
	// 发布时间
	Time int `bson:"time" codec:"time" index:"true"`
	// 卡牌 Mark ID
	MarkID int `bson:"mark_id" codec:"mark_id" index:"true"`
	// 点赞的玩家
	Like int `bson:"like" codec:"like" index:"true"`
	// 踩的玩家
	Dislike int `bson:"dislike" codec:"dislike"`
}

func (*CardComment) CollectionName() string {
	return "CardComment"
}

// 精灵评论角色信息
type CardCommentRole struct {
	document.DocumentID `bson:",inline"`

	// 角色 DB ID
	RoleID document.ID `bson:"role_db_id" codec:"role_db_id" unique:"true"`
	// 角色区服
	GameKey string `bson:"game_key" codec:"game_key"`
	// 角色名字
	Name string `bson:"name" codec:"name"`
	// 角色头像
	Logo int `bson:"logo" codec:"logo"`
	// 角色头像框
	Frame int `bson:"frame" codec:"frame"`
	// 角色等级
	Level int `bson:"level" codec:"level"`
	// 角色 VIP
	Vip int `bson:"vip" codec:"vip"`
	// 点赞的评论
	CommentLike []document.ID `bson:"comment_like" codec:"comment_like"`
	// 踩的评论
	CommentDisLike []document.ID `bson:"comment_dislike" codec:"comment_dislike"`
}

func (*CardCommentRole) CollectionName() string {
	return "CardCommentRole"
}

// 精灵评论
type CardScoreGlobal struct {
	document.DocumentID `bson:",inline"`

	// key
	Key string `bson:"key" codec:"key"`
	// 最后一次更新的日期
	LastDate int `bson:"last_date" codec:"last_date"`
	// 所有卡牌
	Cards map[document.Integer]*CardScoreInfo `bson:"cards" codec:"cards"`
}

type CardScoreInfo struct {
	// 卡牌 mark_id
	MarkID int `bson:"mark_id" codec:"mark_id"`
	// 卡牌稀有度
	Rarity int `bson:"rarity" codec:"rarity"`
	// 排名
	Rank int `bson:"rank" codec:"rank"`
	// 总评分结果
	Score float64 `bson:"score" codec:"score"`
	// 总评分之和
	ScoreSum int `bson:"score_sum" codec:"score_sum"`
	// 总评分人数
	ScoreNum int `bson:"score_num" codec:"score_num"`
	// 上一次排名
	LastRank int `bson:"last_rank" codec:"last_rank"`
	// 上一次评分
	LastScore float64 `bson:"last_score" codec:"last_score"`
}

func (*CardScoreGlobal) CollectionName() string {
	return "CardScoreGlobal"
}

// 精灵评论角色信息
type CardScoreRole struct {
	document.DocumentID `bson:",inline"`

	// 角色 DB ID
	RoleID document.ID `bson:"role_db_id" codec:"role_db_id" unique:"true"`
	// 角色区服
	GameKey string `bson:"game_key" codec:"game_key"`
	// 最后一次操作时间
	LastTime int `bson:"last_time" codec:"last_time"`
	// 精灵评分
	CardScore map[document.Integer]int `bson:"card_score" codec:"card_score"`
}

func (*CardScoreRole) CollectionName() string {
	return "CardScoreRole"
}

// 精灵战力榜
type CardFightGlobal struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key"`
	// 卡牌
	Cards map[document.Integer]map[document.ID]*CardFightRankItem `bson:"cards" codec:"cards"`
	// 是否初始化过数据
	HasInitData bool `bson:"has_init_data" codec:"has_init_data"`
}

// 精灵战力具体信息
type CardFightRankItem struct {
	Role CardFightRankItemRole `bson:"role" codec:"role"`
	Card CardFightRankItemCard `bson:"card" codec:"card"`
	Rank int                   `bson:"rank" codec:"rank"`
}

type CardFightRankItemRole struct {
	ID     document.ID `bson:"id" codec:"id"`
	Name   string      `bson:"name" codec:"name"`
	Logo   int         `bson:"logo" codec:"logo"`
	Frame  int         `bson:"frame" codec:"frame"`
	Title  int         `bson:"title" codec:"title"`
	Level  int         `bson:"level" codec:"level"`
	Figure int         `bson:"figure" codec:"figure"`
	Vip    int         `bson:"vip" codec:"vip"`
}

type CardFightRankItemCard struct {
	ID            document.ID `bson:"id" codec:"id"`
	CardID        int         `bson:"card_id" codec:"card_id"`
	Level         int         `bson:"level" codec:"level"`
	Star          int         `bson:"star" codec:"star"`
	Advance       int         `bson:"advance" codec:"advance"`
	FightingPoint int         `bson:"fighting_point" codec:"fighting_point"`
	SkinId        int         `bson:"skin_id" codec:"skin_id"`
}

func (*CardFightGlobal) CollectionName() string {
	return "CardFightGlobal"
}

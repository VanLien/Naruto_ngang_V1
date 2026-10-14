package scheme

import "tjgame/document"

// 服务器全局记录
type ServerGlobalRecord struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key"`
	// 战力排行历史 {yyID:[排名缓存]}
	FightRankHistory document.Raw `bson:"fight_rank_history" codec:"fight_rank_history" default:"dict"`
	// 记录运营活动开始日期，只用于3-相对开服日期
	YyhuodongsOpen document.Raw `bson:"yyhuodongs_open" codec:"yyhuodongs_open" default:"dict"`
	// 克隆兽列表
	CloneMonsters document.Raw `bson:"clone_monsters" codec:"clone_monsters" default:"list"`
	// 玩家头衔 {titleID: [role.id, opentime]}  // 废弃
	TitleRoles map[document.Integer]TitleRole `bson:"title_roles" codec:"title_roles"`
	// 玩家头衔 {titleID: {role.id: opentime}}
	TitleRolesInfo map[document.Integer]map[document.ID]float64 `bson:"title_roles_info" codec:"title_roles_info"`
	// 活动副本 礼物本的分组
	HuodongGiftGroup int `bson:"huodong_gift_group" codec:"huodong_gift_group"`
	// 活动副本 礼物本的怪物 免疫类型 (物免:1  特免:2)
	HuodongGiftImmuneType int `bson:"huodong_gift_immune_type" codec:"huodong_gift_immune_type"`
	// 活动副本 碎片本的分组
	HuodongFragGroup int `bson:"huodong_frag_group" codec:"huodong_frag_group"`
	// 碎片本 最后一次出现的日期
	FragLastDate map[document.Integer]int `bson:"frag_last_date" codec:"frag_last_date"`
	// 最近更新时间
	LastTime float64 `bson:"last_time" codec:"last_time"`
	// 饰品抽卡商店刷新时间
	EquipShopRefresh int `bson:"equip_shop_refresh" codec:"equip_shop_refresh" default:"todayinclock5date2int"`
	// 运营活动红包
	YYhuodongsRedPacket map[document.Integer]YYHuoDongRedPacket `bson:"yyhuodongs_redPacket" codec:"yyhuodongs_redPacket"`
	// 活动Boss跨服key
	HuoDongBossCrossKey string `bson:"huodongboss_cross_key" codec:"huodongboss_cross_key"`
	// 双十一活动开奖号 {游戏场次csvID: {中奖号:奖励csvID}}
	YYHuodongDouble11LotteryInfo map[document.Integer]map[document.Integer]map[document.Integer]int `bson:"yyHuodong_double11_Lottery_info" codec:"yyHuodong_double11_Lottery_info"`
	// 用于解决合服半周期问题
	AreaCrossKeys  map[string]map[string]string `bson:"area_cross_keys" codec:"area_cross_keys"`
	HalfPeriodKeys map[string][]string          `bson:"half_period_keys" codec:"half_period_keys"`
	// 公会头衔 {titleID: [union.id, opentime]}
	UnionRoles map[document.Integer]TitleUnion `bson:"union_roles" codec:"union_roles"`
	// 公会问答跨服server key
	UnionQACrossKey string `bson:"unionqa_cross_key" codec:"unionqa_cross_key"`
	// 公会问答round
	UnionQARound string `bson:"unionqa_round" codec:"unionqa_round"`
	// 公会问答上期跨服server key
	UnionQALastCrossKey string `bson:"unionqa_last_cross_key" codec:"unionqa_last_cross_key"`
	// 跨服红包跨服key
	RedPacketCrossKey string `bson:"redpacket_cross_key" codec:"redpacket_cross_key"`
	// 摩天大楼跨服key
	SkyscraperCrossKey string `bson:"skyscraper_cross_key" codec:"skyscraper_cross_key"`
	// 赛马跨服key
	HorseRaceCrossKey string `bson:"horse_race_cross_key" codec:"horse_race_cross_key"`
	// 各种玩法的排行榜key
	PlayRankingCrossKeys map[string]string `bson:"play_ranking_cross_keys" codec:"play_ranking_cross_keys"`
	// 普通勇者
	NormalBraveChallenge map[string]int `bson:"normal_brave_challenge" codec:"normal_brave_challenge"`
}

func (*ServerGlobalRecord) CollectionName() string {
	return "ServerGlobalRecord"
}

type TitleRole struct {
	_struct  struct{}    `codec:",toarray"`
	RoleID   document.ID `bson:"roleID"`
	OpenTime float64     `bson:"openTime"`
}

type TitleUnion struct {
	_struct  struct{}    `codec:",toarray"`
	UnionID  document.ID `bson:"union_id"`
	OpenTime float64     `bson:"open_time"`
}

type YYHuoDongRedPacketMember struct {
	ID    document.ID `bson:"id" codec:"id"`
	Logo  int         `bson:"logo" codec:"logo"`
	Name  string      `bson:"name" codec:"name"`
	Vip   int         `bson:"vip" codec:"vip"`
	Frame int         `bson:"frame" codec:"frame"`
	Val   int         `bson:"val" codec:"val"`
	Union string      `bson:"union" codec:"union"`
}

type YYHuoDongRedPacket struct {
	Idx         int                                      `bson:"idx" codec:"idx"`
	CreatedTime float64                                  `bson:"created_time" codec:"created_time"`
	RoleID      document.ID                              `bson:"role_id" codec:"role_id"`
	RoleName    string                                   `bson:"role_name" codec:"role_name"`
	RoleLogo    int                                      `bson:"role_logo" codec:"role_logo"`
	RoleFrame   int                                      `bson:"role_frame" codec:"role_frame"`
	TotalVal    int                                      `bson:"total_val" codec:"total_val"`
	TotalCount  int                                      `bson:"total_count" codec:"total_count"`
	Message     string                                   `bson:"message" codec:"message"`
	Members     map[document.ID]YYHuoDongRedPacketMember `bson:"members" codec:"members"`
}

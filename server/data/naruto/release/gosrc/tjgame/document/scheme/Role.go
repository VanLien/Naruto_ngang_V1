package scheme

import (
	"tjgame/document"
)

// 主角属性
type Role struct {
	document.DocumentID `bson:",inline"`

	// 用于方面查找Role，单服唯一
	UID int `bson:"uid" codec:"uid" unique:"true"`
	// Account.id
	AccountId document.ID `bson:"account_id" codec:"account_id" index:"true"`
	// 用户来源渠道，只有QQ消费钻石的时候用
	Channel string `bson:"channel" codec:"channel" index:"true" default:"'none'"`
	// 账号所选区服，合服用
	Area int `bson:"area" codec:"area" default:"1"`
	// 角色名字
	Name string `bson:"name" codec:"name" unique:"true"`
	// 个性签名
	PersonalSign string `bson:"personal_sign" codec:"personal_sign"`
	// 创建时间
	CreatedTime float64 `bson:"created_time" codec:"created_time" default:"nowtime_t"`
	// 上次操作时间
	LastTime float64 `bson:"last_time" codec:"last_time" index:"true" default:"nowtime_t"`
	// 角色头像ID
	Logo int `bson:"logo" codec:"logo" default:"1"`
	// 角色头像框ID
	Frame int `bson:"frame" codec:"frame" default:"1"`
	// 角色形象
	Figure int `bson:"figure" codec:"figure"`
	// 玩家选择的头衔, -1表示置空
	TitleId int `bson:"title_id" codec:"title_id"`
	// 主角等级
	Level int `bson:"level" codec:"level" index:"true" default:"1"`
	// 当前玩家VIP等级
	VipLevel int `bson:"vip_level" codec:"vip_level" index:"true"`
	// 是否隐藏VIP
	VipHide bool `bson:"vip_hide" codec:"vip_hide"`
	// 拥有的头像 {id: time} 头像id和获得时间
	Logos map[document.Integer]float64 `bson:"logos" codec:"logos"`
	// 拥有的头像框 {id: time} 头像框id和获得时间
	Frames map[document.Integer]float64 `bson:"frames" codec:"frames"`
	// 拥有的角色形象 {id: time} 角色形象id和获得时间
	Figures map[document.Integer]float64 `bson:"figures" codec:"figures"`
	// 形象技能所属的角色形象id
	SkillFigure map[document.Integer]int `bson:"skill_figure" codec:"skill_figure"`
	// 形象技能设置
	SkillFigures map[document.Integer][]int `bson:"skill_figures" codec:"skill_figures"`
	// 形象可装备技能数量
	FigureSkillCount int `bson:"figure_skill_count" codec:"figure_skill_count" default:"1"`
	// 头衔 {id: dateint}
	Titles map[document.Integer][2]float64 `bson:"titles" codec:"titles"`
	// 称号计数器
	TitleCounter map[document.Integer]int `bson:"title_counter" codec:"title_counter"`
	// 卡牌战斗力
	BattleFightingPoint int `bson:"battle_fighting_point" codec:"battle_fighting_point"`
	// 主角当前体力值
	Stamina int `bson:"stamina" codec:"stamina" default:"100"`
	// 玩家上次体力恢复时间
	StaminaLastRecoverTime float64 `bson:"stamina_last_recover_time" codec:"stamina_last_recover_time" default:"nowtime_t"`
	// 主角当前技能点数
	SkillPoint int `bson:"skill_point" codec:"skill_point" default:"20"`
	// 玩家上次技能点数恢复时间
	SkillPointLastRecoverTime float64 `bson:"skill_point_last_recover_time" codec:"skill_point_last_recover_time" default:"nowtime_t"`
	// 达到等级上限后玩家溢出的经验
	OverflowExp int `bson:"overflow_exp" codec:"overflow_exp"`
	// 溢出经验兑换记录
	OverflowExpExchanges map[document.Integer]int `bson:"overflow_exp_exchanges" codec:"overflow_exp_exchanges"`
	// 当前等级下玩家积累的经验
	LevelExp int `bson:"level_exp" codec:"level_exp"`
	// 当前玩家积累的总经验
	SumExp int `bson:"sum_exp" codec:"sum_exp"`
	// 金币
	Gold int `bson:"gold" codec:"gold"`
	// RMB钻石
	Rmb int `bson:"rmb" codec:"rmb"`
	// QQ托管钻石
	QqRmb int `bson:"qq_rmb" codec:"qq_rmb"`
	// QQ充值总额
	QqRecharge int `bson:"qq_recharge" codec:"qq_recharge"`
	// 代币1 - 竞技场
	Coin1 int `bson:"coin1" codec:"coin1"`
	// 代币2 - 远征
	Coin2 int `bson:"coin2" codec:"coin2"`
	// 代币3 - 公会
	Coin3 int `bson:"coin3" codec:"coin3"`
	// 代币4 - 寻宝币
	Coin4 int `bson:"coin4" codec:"coin4"`
	// 代币5 - 精灵魂石(碎片商店消耗）
	Coin5 int `bson:"coin5" codec:"coin5"`
	// 代币6 - Craft
	Coin6 int `bson:"coin6" codec:"coin6"`
	// 代币7 - Craft
	Coin7 int `bson:"coin7" codec:"coin7"`
	// 代币8 - Cross Craft
	Coin8 int `bson:"coin8" codec:"coin8"`
	// 代币9 - Cross Craft
	Coin9 int `bson:"coin9" codec:"coin9"`
	// 代币10 - UnionFight
	Coin10 int `bson:"coin10" codec:"coin10"`
	// 代币11 - UnionFight
	Coin11 int `bson:"coin11" codec:"coin11"`
	// 代币12 - Cross Arena
	Coin12 int `bson:"coin12" codec:"coin12"`
	// 代币13 - Cross Mine
	Coin13 int `bson:"coin13" codec:"coin13"`
	// 代币14 - Hunting
	Coin14 int `bson:"coin14" codec:"coin14"`
	// RMB钻石消耗
	RmbConsume int `bson:"rmb_consume" codec:"rmb_consume"`
	// 天赋点
	TalentPoint int `bson:"talent_point" codec:"talent_point"`
	// 先手值
	Fightgo int `bson:"fightgo" codec:"fightgo"`
	// 装备觉醒碎片数量
	EquipAwakeFrag int `bson:"equip_awake_frag" codec:"equip_awake_frag"`
	// 卡牌背包购买容量
	CardCapacityBuy int `bson:"card_capacity_buy" codec:"card_capacity_buy"`
	// 卡牌背包容量购买次数
	CardCapacityTimes int `bson:"card_capacity_times" codec:"card_capacity_times"`
	// 玩家卡牌RoleCard.id列表 [RoleCard.id]
	Cards []document.ID `bson:"cards" codec:"cards"`
	// 玩家道具字典 {item_id:count}
	Items map[document.Integer]int `bson:"items" codec:"items"`
	// 玩家碎片字典 {frag_id:count}
	Frags map[document.Integer]int `bson:"frags" codec:"frags"`
	// 携带道具
	HeldItems []document.ID `bson:"held_items" codec:"held_items"`
	// 开放的世界地图列表 [world_id]
	WorldOpen []int `bson:"world_open" codec:"world_open"`
	// 开放的章节地图列表 [map_id]
	MapOpen []int `bson:"map_open" codec:"map_open"`
	// 开放的关卡列表 [gate_id]
	GateOpen []int `bson:"gate_open" codec:"gate_open"`
	// 关卡星级字典 {gate_id:{star:0,chest:-1表示未达成 1表示可领取 0表示已领取,win_award:-1表示未达成 1表示可领取 0表示已领取,star3_award:-1表示未达成 1表示可领取 0表示已领取}}
	GateStar map[document.Integer]map[string]int `bson:"gate_star" codec:"gate_star"`
	// 章节星级字典 {map_id:{star_award:[0,0,0]}}
	MapStar map[document.Integer]map[string][]int `bson:"map_star" codec:"map_star"`
	// 日常任务字典{date:{task_id:{arg:0, flag:0}}} flag参见TaskDefs
	DailyTask map[document.Integer]map[document.Integer]map[string]int `bson:"daily_task" codec:"daily_task"`
	// 主线任务字典 {task_id:{arg:0, flag:0}} flag参见TaskDefs
	MainTask map[document.Integer]map[string]int `bson:"main_task" codec:"main_task"`
	// 活动字典 {date:{huodong_id:{times:今日次数, last_time:今日挑战时间}, ...}}
	Huodongs map[document.Integer]map[document.Integer]Huodong `bson:"huodongs" codec:"huodongs"`
	// 活动通关字典 {huodong_id:{gateID:star}}
	HuodongsGate map[document.Integer]map[document.Integer]int `bson:"huodongs_gate" codec:"huodongs_gate"`
	// 运营活动字典 各活动异构 -1表示未达成 1表示可领取 0表示已领取
	Yyhuodongs map[document.Integer]YYHuodong `bson:"yyhuodongs" codec:"yyhuodongs"`
	// 新手指引 含有已完成的阶段
	NewbieGuide []int `bson:"newbie_guide" codec:"newbie_guide"`
	// 新手指引选卡记录 csv id
	NewbieCardChoice int `bson:"newbie_card_choice" codec:"newbie_card_choice"`
	// 客户端事件标记，服务器不使用
	ClientFlag int `bson:"client_flag" codec:"client_flag"`
	// 购买的充值字典 {csv_id:{cnt:0, date:20141206, orders:[PayOrder.id], reset:0 or yyid or -yyid}}
	Recharges map[document.Integer]Recharge `bson:"recharges" codec:"recharges"`
	// 离线充值缓存
	RechargesCache []RechargeCache `bson:"recharges_cache" codec:"recharges_cache"`
	// 已领取礼包字典 {gift_id: 0, -gift_type: 0}
	Gifts map[document.Integer]int `bson:"gifts" codec:"gifts"`
	// 玩家稳定掉落概率权值字典 {stable_drop_id:weight}
	StableDropWeights map[document.Integer]float64 `bson:"stable_drop_weights" codec:"stable_drop_weights"`
	// 出战部署卡牌RoleCard.id列表
	BattleCards [6]document.ID `bson:"battle_cards" codec:"battle_cards"`
	// 活动关卡部署卡牌RoleCard.id列表 {huodongID:[]}
	HuodongCards map[document.Integer][]document.ID `bson:"huodong_cards" codec:"huodong_cards"`
	// 阵容同步 阵容同步 {key: flag}
	DeploymentsSync map[string]bool `bson:"deployments_sync" codec:"deployments_sync"`
	// 当日 DailyRecord.id
	DailyRecordDbId document.ID `bson:"daily_record_db_id" codec:"daily_record_db_id"`
	// 当月 MonthlyRecord.id
	MonthlyRecordDbId document.ID `bson:"monthly_record_db_id" codec:"monthly_record_db_id"`
	// pvp竞技场数据 PVPRecord.id
	PvpRecordDbId document.ID `bson:"pvp_record_db_id" codec:"pvp_record_db_id"`
	// 排位赛主动战斗排队中的数据 PVPPlayRecord.id
	PwPlayingDbId document.ID `bson:"pw_playing_db_id" codec:"pw_playing_db_id"`
	// pvp竞技场商店数据 PVPShop.id
	PwShopDbId document.ID `bson:"pw_shop_db_id" codec:"pw_shop_db_id"`
	// 固定商店数据 FixShop.id
	FixShopDbId document.ID `bson:"fix_shop_db_id" codec:"fix_shop_db_id"`
	// 抽奖数据 LotteryRecord.id
	LotteryDbId document.ID `bson:"lottery_db_id" codec:"lottery_db_id"`
	// 社交数据 Society.id
	SocietyDbId document.ID `bson:"society_db_id" codec:"society_db_id"`
	// 邮件缩略数据 [{db_id:Mail.id, subject:Mail.subject, time:Mail.time, type=Mail.type, sender:Mail.sender, global:Mail.role_db_id==0}, ...]
	Mailbox []MailThumb `bson:"mailbox" codec:"mailbox"`
	// 已读邮件数据 [Mail, ...]
	ReadMailbox []Mail `bson:"read_mailbox" codec:"read_mailbox"`
	// 卡牌获得总次数
	CardGainTimes int `bson:"card_gain_times" codec:"card_gain_times"`
	// 卡牌进阶总次数
	CardAdvanceTimes int `bson:"card_advance_times" codec:"card_advance_times"`
	// 卡牌升星总次数
	CardStarTimes int `bson:"card_star_times" codec:"card_star_times"`
	// 收取全局邮件的游标
	GlobalMailIdx int `bson:"global_mail_idx" codec:"global_mail_idx"`
	// cardNum rank排名，这里只是客户端显示用，不加索引，正确数据从RankGlobal获取
	CardnumRank int `bson:"cardNum_rank" codec:"cardNum_rank"`
	// fight rank排名
	FightRank int `bson:"fight_rank" codec:"fight_rank"`
	// gate star排名
	GateStarRank int `bson:"gate_star_rank" codec:"gate_star_rank"`
	// 单张卡牌战斗力排名
	Card1FightRank int `bson:"card1fight_rank" codec:"card1fight_rank"`
	// 竞技场排名（缓存）
	PwRank int `bson:"pw_rank" codec:"pw_rank"`
	// 历史最高前6卡牌战斗力
	Top6FightingPoint int `bson:"top6_fighting_point" codec:"top6_fighting_point"`
	// 历史最高前12卡牌战斗力
	Top12FightingPoint int `bson:"top12_fighting_point" codec:"top12_fighting_point"`
	// 公会数据 Union.id
	UnionDbId document.ID `bson:"union_db_id" codec:"union_db_id"`
	// 上次离开的公会id
	UnionLastDbId document.ID `bson:"union_last_db_id" codec:"union_last_db_id"`
	// 公会商店数据 UnionShop.id
	UnionShopDbId document.ID `bson:"union_shop_db_id" codec:"union_shop_db_id"`
	// 公会训练所数据 UnionTraining.id
	UnionTrainingDbId document.ID `bson:"union_training_db_id" codec:"union_training_db_id"`
	// 加入公会时间
	UnionJoinTime float64 `bson:"union_join_time" codec:"union_join_time"`
	// 退出公会时间
	UnionQuitTime float64 `bson:"union_quit_time" codec:"union_quit_time"`
	// 上次操作公会时间
	UnionLastTime float64 `bson:"union_last_time" codec:"union_last_time"`
	// 申请加入的公会列表(最多三个,RoleJoinUnionPendingMax)
	UnionJoinQue []document.ID `bson:"union_join_que" codec:"union_join_que"`
	// 公会活动{huodong: {各活动异构}} 未使用
	//UnionHuodongs  `bson:"union_huodongs" codec:"union_huodongs"`
	// 收取公会邮件的游标
	UnionMailIdx int `bson:"union_mail_idx" codec:"union_mail_idx"`
	// 公会副本奖励{union_fuben.csv ID: (最近领取月份, 次数)}
	UnionFbAward map[document.Integer][]int `bson:"union_fb_award" codec:"union_fb_award"`
	// GM封号
	DisableFlag bool `bson:"disable_flag" codec:"disable_flag"`
	// GM禁言
	SilentFlag bool `bson:"silent_flag" codec:"silent_flag"`
	// 总的签到次数
	SignInCount int `bson:"sign_in_count" codec:"sign_in_count"`
	// [id,flag:-1 未达成 1 可领取]
	SignInGift [2]int `bson:"sign_in_gift" codec:"sign_in_gift"`
	// 最近一次签到日期
	LastSignInDate int `bson:"last_sign_in_date" codec:"last_sign_in_date"`
	// 连续签到天数
	SignInDays int `bson:"sign_in_days" codec:"sign_in_days" default:"0"`
	// {id:flag:-1: 未达成 0: 已领取 1: 可领取}
	PwRankAward map[document.Integer]int `bson:"pw_rank_award" codec:"pw_rank_award"`
	// {vip_level:flag  0: 已购买}
	VipGift map[document.Integer]int `bson:"vip_gift" codec:"vip_gift"`
	// {treeID:{cost:talent_point, talnet: {talentID:level}}}
	TalentTrees map[document.Integer]TalentTree `bson:"talent_trees" codec:"talent_trees"`
	// 重命名的次数
	RenameCount int `bson:"rename_count" codec:"rename_count"`
	// 历史最佳雪球得分
	SnowballMaxpoint int `bson:"snowball_maxpoint" codec:"snowball_maxpoint"`
	// 公会扭蛋游戏火神兽个数,-1表示没开始
	LuckyeggCount int `bson:"luckyegg_count" codec:"luckyegg_count" default:"-1"`
	// 公会扭蛋游戏局内次数，获得奖励后重置
	LuckyeggTimes int `bson:"luckyegg_times" codec:"luckyegg_times"`
	// 神秘商店数据 MysteryShop.id
	MysteryShopDbId document.ID `bson:"mystery_shop_db_id" codec:"mystery_shop_db_id"`
	// 所选择的克隆人房间CloneRoom.id
	CloneRoomDbId document.ID `bson:"clone_room_db_id" codec:"clone_room_db_id"`
	//元素挑战上阵卡牌ID card.id
	CloneDeployCardDbId document.ID `bson:"clone_deploy_card_db_id" codec:"clone_deploy_card_db_id"`
	// 上次元素挑战房间邀请时间
	CloneWorldInviteLastTime float64 `bson:"clone_world_invite_last_time" codec:"clone_world_invite_last_time"`
	// 上次元素挑战房间邀请时间
	CloneUnionInviteLastTime float64 `bson:"clone_union_invite_last_time" codec:"clone_union_invite_last_time"`
	// 元素挑战每日被踢次数
	CloneDailyBeKickedNum int `bson:"clone_daily_be_kicked_num" codec:"clone_daily_be_kicked_num"`
	// 元素挑战房间创建时间
	CloneRoomCreateTime int `bson:"clone_room_create_time" codec:"clone_room_create_time"`
	// 上一次进入元素的日期
	CloneLastDate int `bson:"clone_last_date" codec:"clone_last_date"`
	// 拳皇争霸数据 CraftRecord.id
	CraftRecordDbId document.ID `bson:"craft_record_db_id" codec:"craft_record_db_id"`
	// 跨服拳皇争霸数据 CrossCraftRecord.id
	CrossCraftRecordDbId document.ID `bson:"cross_craft_record_db_id" codec:"cross_craft_record_db_id"`
	// 玩家前10卡牌RoleCard.id列表 [(RoleCard.id, RoleCard.card_id, RoleCard.skin_id)]
	Top10Cards [10]CardSpec `bson:"top10_cards" codec:"top10_cards"`
	// 玩家前12卡牌RoleCard.id列表 [(RoleCard.id, RoleCard.card_id, RoleCard.skin_id)]
	Top12Cards [12]CardSpec `bson:"top12_cards" codec:"top12_cards"`
	// 玩家前N卡牌RoleCard.id列表 [Card.id, ...]，markID不重复
	TopCards []document.ID `bson:"top_cards" codec:"top_cards"`
	// 拥有的所有皮肤 {skin_id:time} 皮肤id和过期时间
	Skins map[document.Integer]float64 `bson:"skins" codec:"skins"`
	// 公会战数据 UnionFightRoleRecord.id
	UnionFightRecordDbId document.ID `bson:"union_fight_record_db_id" codec:"union_fight_record_db_id"`
	// [date,point,gold] 2048游戏当日还未结算的金币
	Yy2048Gold [3]int `bson:"yy2048_gold" codec:"yy2048_gold"`
	// 报名跨服拳皇争霸日子
	CrossCraftSignUpDate int `bson:"cross_craft_sign_up_date" codec:"cross_craft_sign_up_date"`
	// 图鉴
	Pokedex map[document.Integer]float64 `bson:"pokedex" codec:"pokedex"`
	// 图鉴突破
	PokedexAdvance map[document.Integer]int `bson:"pokedex_advance" codec:"pokedex_advance"`
	// 无尽之塔最高层数
	EndlessTowerMaxGate int `bson:"endless_tower_max_gate" codec:"endless_tower_max_gate"`
	// 无尽之塔当前层数
	EndlessTowerCurrent int `bson:"endless_tower_current" codec:"endless_tower_current"`
	// 无尽之塔关卡奖励 1-首通 2-扫荡（战斗）
	EndlessTowerAwards map[document.Integer]int `bson:"endless_tower_awards" codec:"endless_tower_awards"`
	// endless rank排名
	EndlessRank int `bson:"endless_rank" codec:"endless_rank"`
	// 公会修炼中心
	UnionSkills map[document.Integer]int `bson:"union_skills" codec:"union_skills"`
	// 公会捐献任务 {csvid: (count, flag)}
	UnionContribTasks map[document.Integer][]int `bson:"union_contrib_tasks" codec:"union_contrib_tasks"`
	// 可发送的公会成就红包
	UnionRedPackets []UnionRedPacketCanSend `bson:"union_redpackets" codec:"union_redpackets"`
	// 竞技场商店 {csvid: [count, lastRecoverTime]}
	PVPShop map[document.Integer]RecoverShopItem `bson:"pvp_shop" codec:"pvp_shop"`
	// 公会成就红包获取次数
	UnionRedPacketTimes map[document.Integer]int `bson:"union_redpacket_times" codec:"union_redpacket_times"`
	// 训练师等级
	TrainerLevel int `bson:"trainer_level" codec:"trainer_level" default:"1"`
	// 训练师总经验
	TrainerSumExp int `bson:"trainer_sum_exp" codec:"trainer_sum_exp"`
	// 训练师特权等级 {csvid: level}
	TrainerSkills map[document.Integer]int `bson:"trainer_skills" codec:"trainer_skills"`
	// 训练师属性加成 {csvid: level}
	TrainerAttrSkills map[document.Integer]int `bson:"trainer_attr_skills" codec:"trainer_attr_skills"`
	// 派遣任务 [{csvid, fightingPoint, status, cardIDs, endingTime, extraAwardPoint}]
	DispatchTasks []DispatchTask `bson:"dispatch_tasks" codec:"dispatch_tasks"`
	// 派遣任务最新刷新时间int
	DispatchTaskLastTime int `bson:"dispatch_task_last_time" codec:"dispatch_task_last_time"`
	// 卡牌好感度
	CardFeels map[document.Integer]CardFeel `bson:"card_feels" codec:"card_feels"`
	// 主城场景精灵
	CitySprites CitySprites `bson:"city_sprites" codec:"city_sprites"`
	// 探险器 {csvID: explorer}
	Explorers map[document.Integer]Explorer `bson:"explorers" codec:"explorers"`
	// 探险寻宝商店数据 ExplorerShop.id
	ExplorerShopDbId document.ID `bson:"explorer_shop_db_id" codec:"explorer_shop_db_id"`
	// 商店限购记录 {key: {position: (count, date)}}
	ShopLimit map[string]map[document.Integer][2]int `bson:"shop_limit" codec:"shop_limit"`
	// 碎片商店数据 FragShop.id
	FragShopDbId document.ID `bson:"frag_shop_db_id" codec:"frag_shop_db_id"`
	// 王者商店 {csvid: [count, lastRecoverTime]}
	CraftShop map[document.Integer]RecoverShopItem `bson:"craft_shop" codec:"craft_shop"`
	// 跨服王者商店 {csvid: [count, lastRecoverTime]}
	CrossCraftShop map[document.Integer]RecoverShopItem `bson:"cross_craft_shop" codec:"cross_craft_shop"`
	// 公会战商店 {csvid: [count, lastRecoverTime]}
	UnionFightShop map[document.Integer]RecoverShopItem `bson:"union_fight_shop" codec:"union_fight_shop"`
	// 精灵皮肤商店 {csvid: [count, lastRecoverTime]}
	CardSkinShop map[document.Integer]RecoverShopItem `bson:"card_skin_shop" codec:"card_skin_shop"`
	// 试炼塔数据 RandomTower.id
	RandomTowerDbId document.ID `bson:"random_tower_db_id" codec:"random_tower_db_id"`
	// 试炼塔商店 RandomTowerShop.id
	RandomTowerShopDbId document.ID `bson:"random_tower_shop_db_id" codec:"random_tower_shop_db_id"`
	// 通行证 {yyID: 运营活动ID; buy: 购买情况; level: 等级; exp: 经验; normal_award: 普通奖励; elite_award: 进阶奖励;
	// task: 任务完成情况; lastWeek: 最近一次周任务时间; weekNum: 第几周; lastDay: 最近一天;}
	Passport Passport `bson:"passport" codec:"passport"`
	// 成长向导 {csv_id: (flag, count)} flag=1可领取, flag=0已领取
	GrowGuide map[document.Integer][2]int `bson:"grow_guide" codec:"grow_guide"`
	// 饰品商店数据 EquipShop.id
	EquipShopDbId document.ID `bson:"equip_shop_db_id" codec:"equip_shop_db_id"`
	// 钓鱼商店数据 FishingShop.id
	FishingShopDbId document.ID `bson:"fishing_shop_db_id" codec:"fishing_shop_db_id"`
	// 精灵捕捉数据 Capture.id
	CaptureDbId document.ID `bson:"capture_db_id" codec:"capture_db_id"`
	// 钓鱼数据 Fishing.id
	FishingDbId document.ID `bson:"fishing_db_id" codec:"fishing_db_id"`
	// 抽卡累计宝箱 {drawType: {csvID: 0}}
	DrawSumBox map[document.Integer]map[document.Integer]int `bson:"draw_sum_box" codec:"draw_sum_box"`
	// 成就点 {成就类别: points}
	AchievementPoints map[document.Integer]int `bson:"achievement_points" codec:"achievement_points"`
	// 成就任务 {csv_id: (flag, time)} (可领:1  已领: 0)
	AchievementTasks map[document.Integer]AchievementTask `bson:"achievement_tasks" codec:"achievement_tasks"`
	// 成就宝箱奖励 {csv_id: flag} (可领:1  已领: 0)
	AchievementBoxAwards map[document.Integer]int `bson:"achievement_box_awards" codec:"achievement_box_awards"`
	// 成就rank排名
	AchievementRank int `bson:"achievement_rank" codec:"achievement_rank"`
	// 各类成就计数器 {type: count}
	AchievementCounter map[document.Integer]int `bson:"achievement_counter" codec:"achievement_counter"`
	// 公会碎片赠予历史记录
	UnionFragDonateHistorys []UnionFragDonateHistory `bson:"union_frag_donate_historys" codec:"union_frag_donate_historys"`
	// 公会碎片赠予热心人点数
	UnionFragDonatePoint int `bson:"union_frag_donate_point" codec:"union_frag_donate_point"`
	// 公会碎片赠予热心人点数宝箱奖励 {csv_id: flag} (可领:1  已领: 0)
	UnionFragDonateAwards map[document.Integer]int `bson:"union_frag_donate_awards" codec:"union_frag_donate_awards"`
	// 宝石
	Gems []document.ID `bson:"gems" codec:"gems"`
	// 满星技能极限点
	StarSkillPoints map[document.Integer]int `bson:"star_skill_points" codec:"star_skill_points"`
	// 跨服竞技场数据 CrossArenaRecord.id
	CrossArenaRecordDbId document.ID `bson:"cross_arena_record_db_id" codec:"cross_arena_record_db_id"`
	// 跨服竞技场数据
	CrossArenaDatas CrossArenaDataInfo `bson:"cross_arena_datas" codec:"cross_arena_datas"`
	// 跨服竞技场商店 {csvid: [count, lastRecoverTime]}
	CrossArenaShop map[document.Integer]RecoverShopItem `bson:"cross_arena_shop" codec:"cross_arena_shop"`
	// 进化石可转化总次数 {csvID: 次数}
	MegaConvertTimes map[document.Integer]int `bson:"mega_convert_times" codec:"mega_convert_times"`
	// 进化石转化次数 上次恢复时间
	MegaLastDate int `bson:"mega_last_date" codec:"mega_last_date" default:"todayinclock5date2int"`
	// 实时对战数据 CrossOnlineFightRecord.id
	CrossOnlineFightRecordDbID document.ID `bson:"cross_online_fight_record_db_id" codec:"cross_online_fight_record_db_id"`
	// 实时对战赛季数据
	CrossOnlineFightInfo CrossOnlineFightInfo `bson:"cross_online_fight_info" codec:"cross_online_fight_info"`
	// 实时对战公平赛卡牌 [card_id, ]
	CrossOnlineFightLimitedCards []int `bson:"cross_online_fight_limited_cards" codec:"cross_online_fight_limited_cards"`
	// 实时对战商店 {csvid: [count, lastRecoverTime]}
	CrossOnlineFightShop map[document.Integer]RecoverShopItem `bson:"cross_online_fight_shop" codec:"cross_online_fight_shop"`
	// 精英关卡扫荡收藏列表
	MopUpCollection []int `bson:"mop_up_collection" codec:"mop_up_collection"`
	// 道馆数据 GymRecord.id
	GymRecordDbId document.ID `bson:"gym_record_db_id" codec:"gym_record_db_id"`
	// 道馆数据
	GymDatas GymDataInfo `bson:"gym_datas" codec:"gym_datas"`
	// 勋章数据
	Badges map[document.Integer]Badge `bson:"badges" codec:"badges"`
	// 重聚活动ReunionRecord.id
	ReunionRecordDbId document.ID `bson:"reunion_record_db_id" codec:"reunion_record_db_id"`
	// 重聚
	Reunion Reunion `bson:"reunion" codec:"reunion"`
	// 预备队伍 {1:{name:string, cards:[dbIDs]}}
	ReadyCards map[document.Integer]ReadyCardsInfo `bson:"ready_cards" codec:"ready_cards"`
	// 跨服资源战Record数据 CrossMineRecord.id
	CrossMineRecordDbId document.ID `bson:"cross_mine_record_db_id" codec:"cross_mine_record_db_id"`
	// 跨服资源战商店 {csvid: [count, lastRecoverTime]}
	CrossMineShop map[document.Integer]RecoverShopItem `bson:"cross_mine_shop" codec:"cross_mine_shop"`
	// 日常助手 设置
	DailyAssistant DailyAssistant `bson:"daily_assistant" codec:"daily_assistant"`
	// 走格子
	GridWalk *GridWalk `bson:"grid_walk" codec:"grid_walk"`
	// 勇者挑战Record数据 BraveChallengeRecord.id
	BraveChallengeRecordDbId document.ID `bson:"brave_challenge_record_db_id" codec:"brave_challenge_record_db_id"`
	// 普通勇者挑战Record数据 BraveChallengeRecord.id
	NormalBraveChallengeRecordDbId document.ID `bson:"normal_brave_challenge_record_db_id" codec:"normal_brave_challenge_record_db_id"`
	// 普通勇者挑战的数据
	NormalBraveChallenge NormalBraveChallenge `bson:"normal_brave_challenge" codec:"normal_brave_challenge"`
	// z觉醒碎片
	ZFrags map[document.Integer]int `bson:"zfrags" codec:"zfrags"`
	// Z觉醒数据 {zawakeID: {stage: level}}
	Zawake map[document.Integer]map[document.Integer]int `bson:"zawake" codec:"zawake"`
	// Z觉醒生效技能数据 {zawakeID: skills}
	ZawakeSkills map[document.Integer][]int `bson:"zawake_skills" codec:"zawake_skills"`
	// 芯片 [chip]
	Chips []document.ID `bson:"chips" codec:"chips"`
	// 远征Record数据 HuntingRecord.id
	HuntingRecordDbId document.ID `bson:"hunting_record_db_id" codec:"hunting_record_db_id"`
	// 远征商店 {csvid: [count, lastRecoverTime]}
	HuntingShop map[document.Integer]RecoverShopItem `bson:"hunting_shop" codec:"hunting_shop"`
	// 芯片方案
	ChipPlans map[document.Integer]ChipPlan `bson:"chip_plans" codec:"chip_plans"`
	// 跨服公会战 Record数据 CrossUnionFightRecord.id
	CrossUnionFightRecordDbId document.ID `bson:"cross_union_fight_record_db_id" codec:"cross_union_fight_record_db_id"`
}

func (*Role) CollectionName() string {
	return "Role"
}

type Huodong struct {
	Times    int     `bson:"times" codec:"times"`
	LastTime float64 `bson:"last_time" codec:"time"`
}

type Recharge struct {
	Cnt    int           `codec:"cnt,omitempty" bson:"cnt,omitempty"`
	Date   int           `codec:"date,omitempty" bson:"date,omitempty"`
	Orders []document.ID `codec:"orders,omitempty" bson:"orders,omitempty"`
	Reset  int           `codec:"reset,omitempty" bson:"reset,omitempty"`
}

type RechargeCache struct {
	_struct struct{} `codec:",toarray"`

	RechargeID int         `codec:"recharge_id" bson:"recharge_id"`
	OrderID    document.ID `codec:"order_id" bson:"order_id"`
	YYID       int         `codec:"yy_id" codec:"yy_id"`
	CSVID      int         `codec:"csv_id" codec:"csv_id"`
}

type TalentTree struct {
	// talent point cost
	Cost int `bson:"cost" codec:"cost"`
	// talent level
	Talent map[document.Integer]int `bson:"talent" codec:"talent"`
}

type YYHuodong struct {
	Lastday int `bson:"lastday,omitempty" codec:"lastday,omitempty"`
	// 奖励获得/计数
	Stamps map[document.Integer]int `bson:"stamps,omitempty" codec:"stamps,omitempty"`
	// 另一个奖励获得/计数
	Stamps1 map[document.Integer]int `bson:"stamps1,omitempty" codec:"stamps1,omitempty"`
	// 数组记录选择
	Choose map[document.Integer][]int `bson:"choose,omitempty" codec:"choose,omitempty"`
	// 额外信息记录
	Info map[string]int `bson:"info,omitempty" codec:"info,omitempty"`

	Enddate  int `bson:"enddate,omitempty" codec:"enddate,omitempty"`
	Buy      int `bson:"buy,omitempty" codec:"buy,omitempty"`
	Flag     int `bson:"flag,omitempty" codec:"flag,omitempty"`
	BoxPoint int `bson:"box_point,omitempty" codec:"box_point,omitempty"`

	// 通用任务
	Valsums  map[document.Integer]int                      `bson:"valsums,omitempty" codec:"valsums,omitempty"`
	Valsums1 map[document.Integer]map[document.Integer]int `bson:"valsums1,omitempty" codec:"valsums1,omitempty"`
	Valinfo  map[document.Integer]map[string]int           `bson:"valinfo,omitempty" codec:"valinfo,omitempty"`

	// 全目标记录
	Targets map[string]int `bson:"targets,omitempty" codec:"targets,omitempty"`

	// 资源找回奖励 {gold: {free: 免费找回, rmb: 钻石找回}}  1为已找回
	RetrieveAward map[string]map[string]int `bson:"retrieve_award,omitempty" codec:"retrieve_award,omitempty"`
	// 活动boss
	HuoDongBoss map[string]float64 `bson:"huodong_boss,omitempty" codec:"huodong_boss,omitempty"`

	// 双十一
	Double11 map[document.Integer]YYHuodongDouble11 `bson:"double11,omitempty" codec:"double11,omitempty"`

	// 集福赢头奖 连线奖励
	LinkAward map[document.Integer]int `bson:"link_award,omitempty" codec:"link_award,omitempty"`

	// 赛马
	HorseRace HorseRace `bson:"horse_race,omitempty" codec:"horse_race,omitempty"`

	// 派遣
	Dispatch map[document.Integer]YYDispatchTask `bson:"dispatch,omitempty" codec:"dispatch,omitempty"`

	// 月圆祈福
	MidAutumnDraw document.Raw `bson:"mid_autumn_draw,omitempty" codec:"mid_autumn_draw,omitempty"`
}

type HorseRace struct {
	// 赛马 押注奖励 {date: {play: (idx, rank, flag)}} (-1: 已押注; 1: 已领; 0: 已领)
	BetAward map[document.Integer]map[document.Integer][3]int `bson:"bet_award,omitempty" codec:"bet_award,omitempty"`
	// 赛马 积分奖励 {csvID: flag} (1: 可领; 0: 已领)
	PointAward map[document.Integer]int `bson:"point_award,omitempty" codec:"point_award,omitempty"`
	// 赛马 积分
	Point int `bson:"point,omitempty" codec:"point,omitempty"`
	// 赛马 成就计数器 {rank: count}
	AchievementCounter map[document.Integer]int `bson:"achievement_counter,omitempty" codec:"achievement_counter,omitempty"`
}

type YYHuodongDouble11 struct {
	// 红包数据量
	RedPacketNum int `bson:"red_packet_num" codec:"red_packet_num"`
	// 刮刮卡状态,0 未获得，1 可开启，-1 已开启
	CardStatus int `bson:"card_status" codec:"card_status"`
	// 刮刮卡号
	CardNum int `bson:"card_num" codec:"card_num"`
	// 中奖的 CsvID
	LotteryCsvId int `bson:"lottery_csv_id" codec:"lottery_csv_id"`
	// 本场游戏结束时间
	GameEndTime int `bson:"game_end_time" codec:"game_end_time"`
}

type YYDispatchCard struct {
	ID      document.ID `bson:"id" codec:"id"`
	CardID  int         `bson:"card_id" codec:"card_id"`
	Level   int         `bson:"level" codec:"level"`
	Star    int         `bson:"star" codec:"star"`
	Advance int         `bson:"advance" codec:"advance"`
	SkinId  int         `bson:"skin_id" codec:"skin_id"`
}

type YYDispatchTask struct {
	Status int `bson:"status" codec:"status"`
	// 派遣的卡牌
	Cards []YYDispatchCard `bson:"cards" codec:"cards"`
	// 结束时间
	EndTime float64 `bson:"end_time" codec:"end_time"`
	// 已派遣次数
	Times int `bson:"times" codec:"times"`
	// 是否额外奖励
	Extra bool `bson:"extra" codec:"extra"`
	// 冷却结束时间
	CdTime float64 `bson:"cd_time" codec:"cd_time"`
}

type UnionRedPacketCanSend struct {
	_struct struct{} `codec:",toarray"`

	CSVID int
	Time  float64
}

type RecoverShopItem struct {
	_struct struct{} `codec:",toarray"`

	Count int
	Time  float64
}

type DispatchTask struct {
	CsvID              int     `bson:"csvID" codec:"csvID"`
	FightingPoint      int     `bson:"fighting_point" codec:"fighting_point"`
	Status             int     `bson:"status" codec:"status"`
	EndingTime         float64 `bson:"ending_time,omitempty" codec:"ending_time,omitempty"`
	ExtraAwardPoint    float64 `bson:"extra_award_point" codec:"extra_award_point"`
	ReachFightingPoint int     `bson:"reach_fighting_point,omitempty" codec:"reach_fighting_point,omitempty"`
	Reach              []int   `bson:"reach,omitempty" codec:"reach,omitempty"`
	ReachNatures       []int   `bson:"reach_natures,omitempty" codec:"reach_natures,omitempty"`
}

type CardFeel struct {
	// 好感度等级
	Level int `bson:"level" codec:"level"`
	// 好感度总经验
	SumExp int `bson:"sum_exp" codec:"sum_exp"`
	// 当前等级下好感度经验
	LevelExp int `bson:"level_exp" codec:"level_exp"`
}

type CitySprites struct {
	// 主城场景精灵刷新日期 2019073020
	Date   int   `bson:"date" codec:"date"`
	Groups []int `bson:"groups" codec:"groups"`

	// 百变怪 {period: 20190730, times: 0, last: timestamp, id: 1}
	Baibian map[string]int `bson:"baibain" codec:"baibian"`
	// 谜拟Q {period: 20190730, times: 0,  last: timestamp, id: 1}
	MiniQ map[string]int `bson:"miniQ" codec:"miniQ"`
}

type Explorer struct {
	Advance int `bson:"advance" codec:"advance"`
	// {componentCsvID: level}
	Components map[document.Integer]int `bson:"components" codec:"components"`
}

type Passport struct {
	// 运营ID
	YyID int `codec:"yy_id" bson:"yy_id"`
	// 购买情况 1为已购买 {type1: 普通通行证, type2: 直升通行证}
	Buy map[string]int `codec:"buy" bson:"buy"`
	// 等级
	Level int `codec:"level" bson:"level"`
	// 经验
	Exp int `codec:"exp" exp:"exp"`
	// 普通奖励 {csvID: 状态} (可领:1  已领: 0)
	NormalAward map[document.Integer]int `codec:"normal_award" bson:"normal_award"`
	// 进阶奖励 {csvID: 状态} (可领:1  已领: 0)
	EliteAward map[document.Integer]int `codec:"elite_award" bson:"elite_award"`
	// 任务领取状态 {csvID: (count, flag)} (没有奖励:0 可领:1  已领: 2)
	Task map[document.Integer][2]int `codec:"task" bson:"task"`
	// 任务额外记录信息
	Info map[document.Integer]map[string]int `bson:"info" codec:"info"`
	// 最新周时间
	LastWeek int `codec:"last_week" exp:"last_week"`
	// 第几周
	WeekNum int `codec:"week_num" exp:"week_num"`
	// 最近一天
	LastDay int `codec:"last_day" exp:"last_day"`
	// 通行证商店
	Shop map[document.Integer]int `codec:"shop" bson:"shop"`
}

type AchievementTask struct {
	_struct struct{} `codec:",toarray"`

	Status int // (可领:1  已领: 0)
	Time   float64
}

type UnionFragDonateHistory struct {
	RoleID document.ID `bson:"role_id" codec:"role_id"`
	Name   string      `bson:"name" codec:"name"`
	Logo   int         `bson:"logo" codec:"logo"`
	Frame  int         `bson:"frame" codec:"frame"`
	Level  int         `bson:"level" codec:"level"`
	Frag   int         `bson:"frag" codec:"frag"`
	Time   int         `bson:"time" codec:"time"`
}

// 跨服玩法使用
type RoleKey struct {
	_struct struct{} `codec:",toarray"`

	GameKey string      `bson:"game_key"`
	ID      document.ID `bson:"id"`
}

// 跨服竞技场数据
type CrossArenaDataInfo struct {
	// 段位奖励 {csv_id: flag} (可领:1  已领: 0)
	StageAwards map[document.Integer]int `bson:"stage_awards,omitempty" codec:"stage_awards,omitempty"`
	// 7日排行奖励已领取 段位
	SevenAwardStage int `bson:"seven_award_stage" codec:"seven_award_stage"`
	// 结束排行奖励已领取 段位
	FinishAwardStage int `bson:"finish_award_stage" codec:"finish_award_stage"`
	// 上期的展示卡牌
	LastDisplay int `bson:"last_display" codec:"last_display"`
}

// 实时对战赛季记录
type CrossOnlineFightInfo struct {
	// 当前赛季开始时间
	StartDate int `bson:"start_date,omitempty" codec:"start_date"`
	// 当前赛季无限制赛历史最高积分
	UnlimitedTopScore int `bson:"unlimited_top_score,omitempty" codec:"unlimited_top_score"`
	// 当前赛季公平赛历史最高积分
	LimitedTopScore int `bson:"limited_top_score,omitempty" codec:"limited_top_score"`
	// 周目标奖励刷新时间
	WeeklyDate int `bson:"weekly_date,omitempty" codec:"weekly_date"`
	// 每周目标奖励
	WeeklyTarget map[document.Integer]int `bson:"weekly_target,omitempty" codec:"weekly_target,omitempty"`
	// 每周胜场次数
	WeeklyWinTimes int `bson:"weekly_win_times" codec:"weekly_win_times"`
	// 每周参与次数
	WeeklyBattleTimes int `bson:"weekly_battle_times" codec:"weekly_battle_times"`
}

// 道馆数据
type GymDataInfo struct {
	// 副本状态 {gym_id: degree}
	GymFuben map[document.Integer]int `bson:"gym_fuben" codec:"gym_fuben,omitempty"`
	// 通关奖励 {gym_id: flag} (可领:1  已领: 0)
	GymPassAwards map[document.Integer]int `bson:"gym_pass_awards" codec:"gym_pass_awards,omitempty"`
	// 天赋树 {treeID:{cost: talent_point, talent: {talentID: level}}}
	GymTalentTrees map[document.Integer]TalentTree `bson:"gym_talent_trees" codec:"gym_talent_trees,omitempty"`
	// 天赋buff点
	GymTalentPoint int `bson:"gym_talent_point" codec:"gym_talent_point"`
	// 上次挑战馆主时间（用作冷却cd）
	GymPwLastTime float64 `bson:"gym_pw_last_time" codec:"gym_pw_last_time"`
	// 上次挑战跨服馆员时间（用作冷却cd）
	CrossGymPwLastTime float64 `bson:"cross_gym_pw_last_time" codec:"cross_gym_pw_last_time"`
	// 最近时间
	LastDate int `bson:"last_date" codec:"last_date"`
	// 天赋点数恢复时间
	RecoverDate int `bson:"recover_date" codec:"recover_date"`
	// 天赋点重置次数
	GymTalentResetTimes int `bson:"gym_talent_reset_times" codec:"gym_talent_reset_times"`
	// 可跳过 历史记录
	LastJump map[document.Integer]int `bson:"last_jump" codec:"last_jump"`
	// 可跳过 上次记录
	HistoryJump map[document.Integer]int `bson:"history_jump" codec:"history_jump"`
}

// 勋章
type Badge struct {
	// 勋章觉醒等级
	Awake int `codec:"awake" bson:"awake"`
	// 勋章天赋 {talentID: level}
	Talents map[document.Integer]int `codec:"talents" bson:"talents"`
	// 勋章守护精灵
	Guards map[document.Integer]document.ID `codec:"guards" bson:"guards"`
	// 勋章栏位解锁
	Positions map[document.Integer]bool `codec:"positions" bson:"positions"`
}

// 重聚活动数据
type Reunion struct {
	// 额外信息记录
	Info ReunionInfo `bson:"info,omitempty" codec:"info,omitempty"`
	// 重聚礼包 {reunion: [csvID, 0], bind: [csvID, 0]}
	Gift map[string][2]int `bson:"gift,omitempty" codec:"gift,omitempty"`
	// 积分奖励 {csvID: 0}
	PointBox map[document.Integer]int `bson:"point_box,omitempty" codec:"point_box,omitempty"`
	// 活动角色类型 0 活动结束 1回归玩家 2 老玩家
	RoleType int `bson:"role_type" codec:"role_type"`

	// 回归玩家独有数据
	// 冷却时间 {yyID: timestamps}
	CD map[document.Integer]float64 `bson:"cd,omitempty" codec:"cd,omitempty"`
	// 邀请时间
	InviteTime map[document.ID]float64 `bson:"invite_time,omitempty" codec:"invite_time,omitempty"`
	// 世界邀请时间
	WorldInviteTime float64 `bson:"world_invite_time,omitempty" codec:"world_invite_time,omitempty"`
	// 限购礼包
	Recharge map[document.Integer][2]int `bson:"recharge,omitempty" codec:"recharge,omitempty"`
	// 进度赶超
	Catchup map[document.Integer]int `bson:"catchup,omitempty" codec:"catchup,omitempty"`
	// 奖励获得/计数
	Stamps map[document.Integer]int `bson:"stamps,omitempty" codec:"stamps,omitempty"`

	// 老玩家独有的数据
	BindCD float64 `bson:"bind_cd,omitempty" codec:"bind_cd,omitempty"`
}

// 重聚活动额外信息
type ReunionInfo struct {
	// 离线天数
	Days int `bson:"days,omitempty" codec:"days,omitempty"`
	// 回归时间
	ReunionTime float64 `bson:"reunion_time,omitempty" codec:"reunion_time,omitempty"`
	// 活动结束时间
	EndTime float64 `bson:"end_time" codec:"end_time"`
	// 重聚csvID
	YYID int `bson:"yyID" codec:"yyID"`
	// 重聚活动版本id
	HuodongID int `bson:"huodongID" codec:"huodongID"`
	// 回归玩家id
	RoleID document.ID `bson:"role_id" codec:"role_id"`
	// 关卡进度
	Gate document.Integer `bson:"gate,omitempty" codec:"gate,omitempty"`
}

type ReadyCardsInfo struct {
	Name  string         `bson:"name" codec:"name"`
	Cards [6]document.ID `bson:"cards" codec:"cards"`
}

// 日常助手 选择信息
type DailyAssistant struct {
	// 公会捐献选择 csvID
	UnionContrib int `bson:"union_contrib,omitempty" codec:"union_contrib,omitempty"`
	// 公会许愿选择 csvID
	UnionFragDonateCardID int `bson:"union_frag_donate_card_id,omitempty" codec:"union_frag_donate_card_id,omitempty"`
	// 冒险之路购买重置 (1: 购买; 0: 没有购买)
	EndlessBuyReset int `bson:"endless_buy_reset,omitempty" codec:"endless_buy_reset,omitempty"`
	// 钓鱼大赛是否跳过 (1: 跳过; 0: 不跳过)
	FishingSkip int `bson:"fishing_skip,omitempty" codec:"fishing_skip,omitempty"`
}

type GridWalk struct {
	YYID int `bson:"yy_id" codec:"yy_id"`
	// 朝向
	DirectionUp bool `bson:"direction_up" codec:"direction_up"`
	// 位置
	Pos int `bson:"pos" codec:"pos"`
	// 宝箱位置
	Treasure int `bson:"treasure" codec:"treasure"`
	// 本回合状态
	Action GridWalkAction `bson:"action" codec:"action"`
	// 最近6条记录
	History []GridWalkLog `bson:"history" codec:"history"`
	// 索引小于EventPos的事件已生效
	EventPos int `bson:"event_pos" codec:"event_pos"`
}

type GridWalkAction struct {
	// 使用的道具
	ItemUsed int `bson:"item_used" codec:"item_used"`
	// 最终位置
	EndPos int `bson:"end_pos" codec:"end_pos"`
	// 最终朝向
	EndDirectionUp bool `bson:"end_direction_up" codec:"end_direction_up"`
	// 骰子csvID
	DieUsed int `bson:"die_used" codec:"die_used"`
	// 骰子点数
	DieRolled int `bson:"die_rolled" codec:"die_rolled"`
	// 经过事件
	Events []GridWalkLog `bson:"events" codec:"events"`
}

type GridWalkLog struct {
	CsvID int `bson:"csv_id" codec:"csv_id"`
	// 事件发生点
	Index int `bson:"index" codec:"index"`
	// 是事件，否则是道具
	IsEvent bool `bson:"is_event" codec:"is_event"`
	// 额外信息
	Params map[string]int `bson:"params" codec:"params"`
}

type ChipPlan struct {
	CreatedTime float64                          `bson:"created_time" codec:"created_time" default:"nowtime_t"`
	Chips       map[document.Integer]document.ID `bson:"chips" codec:"chips"`
	Name        string                           `bson:"name" codec:"name"`
}

type NormalBraveChallenge struct {
	Lastday int `bson:"lastday,omitempty" codec:"lastday,omitempty"`
	// 奖励获得/计数
	Stamps map[document.Integer]int `bson:"stamps,omitempty" codec:"stamps,omitempty"`
	// 额外信息记录
	Info map[string]int `bson:"info,omitempty" codec:"info,omitempty"`
	// 通用任务
	Valsums map[document.Integer]int `bson:"valsums,omitempty" codec:"valsums,omitempty"`
}

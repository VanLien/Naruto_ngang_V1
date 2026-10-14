package scheme

import "tjgame/document"

// 日常记录凌晨5点刷新
type DailyRecord struct {
	document.DocumentID `bson:",inline"`

	// 日常日期
	Date int `bson:"date" codec:"date" index:"true" default:"todayinclock5date2int"`
	// Role.id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// 挑战关卡次数
	GateChanllenge int `bson:"gate_chanllenge" codec:"gate_chanllenge"`
	// 挑战精英关卡次数
	HeroGateChanllenge int `bson:"hero_gate_chanllenge" codec:"hero_gate_chanllenge"`
	// 挑战噩梦关卡次数
	NightmareGateChanllenge int `bson:"nightmare_gate_chanllenge" codec:"nightmare_gate_chanllenge"`
	// 挑战活动副本次数
	HuodongChanllenge int `bson:"huodong_chanllenge" codec:"huodong_chanllenge"`
	// 抽卡次数
	DrawCard int `bson:"draw_card" codec:"draw_card"`
	// 抽卡钻石单抽次数
	DrawCardRmb1Half int `bson:"draw_card_rmb1_half" codec:"draw_card_rmb1_half"`
	// 训练师等级特权免费金币抽取
	DrawCardGold1Trainer int `bson:"draw_card_gold1_trainer" codec:"draw_card_gold1_trainer"`
	// 抽装备次数
	DrawEquip int `bson:"draw_equip" codec:"draw_equip"`
	// 免费抽卡次数
	Dc1FreeCount int `bson:"dc1_free_count" codec:"dc1_free_count"`
	// 免费金币抽卡次数
	Gold1FreeCount int `bson:"gold1_free_count" codec:"gold1_free_count"`
	// 玩家上次免费金币抽卡时间
	Gold1FreeLastTime float64 `bson:"gold1_free_last_time" codec:"gold1_free_last_time"`
	// 免费装备单抽
	EqDc1FreeCounter int `bson:"eq_dc1_free_counter" codec:"eq_dc1_free_counter"`
	// 免费限时宝箱单抽
	LimitBoxFreeCounter int `bson:"limit_box_free_counter" codec:"limit_box_free_counter"`
	// 升级装备次数
	EquipStrength int `bson:"equip_strength" codec:"equip_strength"`
	// 进阶装备次数
	EquipAdvance int `bson:"equip_advance" codec:"equip_advance"`
	// 卡牌技能升级
	SkillUp int `bson:"skill_up" codec:"skill_up"`
	// 卡牌升级
	LevelUp int `bson:"level_up" codec:"level_up"`
	// 关卡挑战次数字典 {gate_id:count}
	GateTimes map[document.Integer]int `bson:"gate_times" codec:"gate_times"`
	// pvp排位赛次数
	PvpPwTimes int `bson:"pvp_pw_times" codec:"pvp_pw_times"`
	// 玩家上次挑战排位时间
	PvpPwLastTime float64 `bson:"pvp_pw_last_time" codec:"pvp_pw_last_time"`
	// 竞技场积分
	PvpResultPoint int `bson:"pvp_result_point" codec:"pvp_result_point"`
	// 竞技场换一批次数
	PvpEnermysRefreshTimes int `bson:"pvp_enermys_refresh_times" codec:"pvp_enermys_refresh_times"`
	// 竞技场积分奖励 {id:flag:-1: 未达成 0: 已领取 1: 可领取}
	ResultPointAward map[document.Integer]int `bson:"result_point_award" codec:"result_point_award"`
	// 购买体力次数
	BuyStaminaTimes int `bson:"buy_stamina_times" codec:"buy_stamina_times"`
	// 月卡免费购买体力次数
	BuyStaminaFreeTimes int `bson:"buy_stamina_free_times" codec:"buy_stamina_free_times"`
	// 购买排位赛次数
	BuyPwTimes int `bson:"buy_pw_times" codec:"buy_pw_times"`
	// 道具增加排位赛次数
	ItemPwTimes int `bson:"item_pw_times" codec:"item_pw_times"`
	// 购买重置英雄关卡次数字典 {gate_id:count}
	BuyHerogateTimes map[document.Integer]int `bson:"buy_herogate_times" codec:"buy_herogate_times"`
	// 购买重置排位赛CD时间次数
	BuyPwCdTimes int `bson:"buy_pw_cd_times" codec:"buy_pw_cd_times"`
	// 购买技能点次数
	BuySkillPointTimes int `bson:"buy_skill_point_times" codec:"buy_skill_point_times"`
	// 炼金次数
	LianjinTimes int `bson:"lianjin_times" codec:"lianjin_times"`
	// 月卡免费炼金次数
	LianjinFreeTimes int `bson:"lianjin_free_times" codec:"lianjin_free_times"`
	// 炼金每日礼包
	LianjinGifts map[document.Integer]int `bson:"lianjin_gifts" codec:"lianjin_gifts"`
	// 远征商店刷新次数
	YzShopRefreshTimes int `bson:"yz_shop_refresh_times" codec:"yz_shop_refresh_times"`
	// 远征刷新次数
	YzRefreshTimes int `bson:"yz_refresh_times" codec:"yz_refresh_times"`
	// 远征次数
	YzTimes int `bson:"yz_times" codec:"yz_times"`
	// boss战次数
	BossGate int `bson:"boss_gate" codec:"boss_gate"`
	// boss战购买次数
	BossGateBuy int `bson:"boss_gate_buy" codec:"boss_gate_buy"`
	// 世界boss伤害排名
	BossDamageRank int `bson:"boss_damage_rank" codec:"boss_damage_rank"`
	// 世界boss伤害最大值
	BossDamageMax int `bson:"boss_damage_max" codec:"boss_damage_max"`
	// 世界boss记录伤害的公会ID
	BossUnionDbId document.ID `bson:"boss_union_db_id" codec:"boss_union_db_id"`
	// 聊天次数
	ChatTimes int `bson:"chat_times" codec:"chat_times"`
	// 今日公会币获得
	UnionCoin int `bson:"union_coin" codec:"union_coin"`
	// 公会副本挑战次数
	UnionFbTimes int `bson:"union_fb_times" codec:"union_fb_times"`
	// 公会商店刷新次数
	UnionShopRefreshTimes int `bson:"union_shop_refresh_times" codec:"union_shop_refresh_times"`
	// 当日抢的玩家红包记录[(红包类型,红包角色名,红包金额),...]
	UnionRedpacketRobs []UnionRedpacketRob `bson:"union_redPacket_robs" codec:"union_redPacket_robs"`
	// 固定商店刷新次数 times
	FixShopRefreshTimes int `bson:"fix_shop_refresh_times" codec:"fix_shop_refresh_times"`
	// 好友体力赠送列表 [Role.id]
	FriendStaminaSend []document.ID `bson:"friend_stamina_send" codec:"friend_stamina_send"`
	// 领取好友赠送体力次数
	FriendStaminaGain int `bson:"friend_stamina_gain" codec:"friend_stamina_gain"`
	// 每日分享次数
	ShareTimes int `bson:"share_times" codec:"share_times"`
	// 每日升品次数
	CardAdvanceTimes int `bson:"card_advance_times" codec:"card_advance_times"`
	// 每日累计消费钻石数
	ConsumeRmbSum int `bson:"consume_rmb_sum" codec:"consume_rmb_sum"`
	// 每日累计消耗体力数
	CostStaminaSum int `bson:"cost_stamina_sum" codec:"cost_stamina_sum"`
	// 公会训练所给别人加速次数
	UnionTrainingSpeedup int `bson:"union_training_speedup" codec:"union_training_speedup"`
	// 公会贡献次数
	UnionContribTimes int `bson:"union_contrib_times" codec:"union_contrib_times"`
	// 神秘商店权重
	MysteryShopWeight float64 `bson:"mystery_shop_weight" codec:"mystery_shop_weight"`
	// 神秘商店激活次数
	MysteryActiveTimes int `bson:"mystery_active_times" codec:"mystery_active_times"`
	// 限时捕捉出现权重
	CaptureLimitWeight float64 `bson:"capture_limit_weight" codec:"capture_limit_weight"`
	// 限时捕捉出现次数
	CaptureLimitTimes int `bson:"capture_limit_times" codec:"capture_limit_times"`
	// 克隆人玩法次数
	CloneTimes int `bson:"clone_times" codec:"clone_times"`
	// 公会红包发红包次数
	RedpacketSendCount int `bson:"redPacket_send_count" codec:"redPacket_send_count"`
	// 公会红包抢红包次数
	RedpacketRobCount int `bson:"redPacket_rob_count" codec:"redPacket_rob_count"`
	// 每日获得砸金蛋次数
	BreakeggGainTimes int `bson:"breakegg_gain_times" codec:"breakegg_gain_times"`
	// 每日砸金蛋获得金额数
	BreakeggAmount float64 `bson:"breakegg_amount" codec:"breakegg_amount"`
	// 是否已报名拳皇争霸
	CraftSignUp bool `bson:"craft_sign_up" codec:"craft_sign_up"`
	// 拳皇争霸排名
	CraftRank int `bson:"craft_rank" codec:"craft_rank"`
	// 王者下注信息 {rank1: (role.id, gold)}
	CraftBets CraftBets `bson:"craft_bets" codec:"craft_bets"`
	// 是否已报名公会战
	UnionfightSignUp bool `bson:"union_fight_sign_up" codec:"union_fight_sign_up"`
	// 在线礼包 {starttime=开始时间, idx=礼包下标, flag=0不可领，1可领，2已领}
	OnlineGift OnlineGift `bson:"online_gift" codec:"online_gift"`
	// 在线礼包翻倍次数
	OnlineGiftDoubleTimes int `bson:"online_gift_double_times" codec:"online_gift_double_times"`
	// 下注信息 [union.id, gold]
	UnionFightBets UnionfightBets `bson:"union_fight_bets" codec:"union_fight_bets"`
	// 活跃度点数
	LivenessPoint int `bson:"liveness_point" codec:"liveness_point"`
	// 活跃度阶段奖励领取记录
	LivenessStageAward map[document.Integer]int `bson:"liveness_stage_award" codec:"liveness_stage_award"`
	// 无尽之塔重置次数
	EndlessTowerResetTimes int `bson:"endless_tower_reset_times" codec:"endless_tower_reset_times"`
	// 公会每日礼包领取次数
	UnionDailyGiftTimes int `bson:"union_daily_gift_times" codec:"union_daily_gift_times"`
	// 每日充值钻石数
	RechargeRmbSum int `bson:"recharge_rmb_sum" codec:"recharge_rmb_sum"`
	// 训练师等级每日礼包
	TrainerGiftTimes int `bson:"trainer_gift_times" codec:"trainer_gift_times"`
	// 派遣任务当日派遣卡牌
	DispatchCardIDs []document.ID `bson:"dispatch_cardIDs" codec:"dispatch_cardIDs"`
	// 派遣任务免费刷新次数
	DispatchRefreshFreeTimes int `bson:"dispatch_refresh_free_times" codec:"dispatch_refresh_free_times"`
	// 主城常规彩蛋奖励领取次数
	CitySpriteGiftTimes int `bson:"city_sprite_gift_times" codec:"city_sprite_gift_times"`
	// 寻宝商店刷新次数
	ExplorerShopRefreshTimes int `bson:"explorer_shop_refresh_times" codec:"explorer_shop_refresh_times"`
	// 免费道具单抽
	ItemDc1FreeCounter int `bson:"item_dc1_free_counter" codec:"item_dc1_free_counter"`
	// 抽道具次数
	DrawItem int `bson:"draw_item" codec:"draw_item"`
	// 道具（探险寻宝）钻石半价单抽次数
	DrawItemRmb1Half int `bson:"draw_item_rmb1_half" codec:"draw_item_rmb1_half"`
	// 碎片商店刷新次数
	FragShopRefreshTimes int `bson:"frag_shop_refresh_times" codec:"frag_shop_refresh_times"`
	// 公会每日一次红包
	RedpacketDaily []int `bson:"redPacket_daily" codec:"redPacket_daily"`
	// 精灵分享次数
	CardShareTimes int `bson:"card_share_times" codec:"card_share_times"`
	// 随机塔商店刷新次数
	RandomTowerShopRefreshTimes int `bson:"randomTower_shop_refresh_times" codec:"randomTower_shop_refresh_times"`
	// 钓鱼商店刷新次数
	FishingShopRefreshTimes int `bson:"fishing_shop_refresh_times" codec:"fishing_shop_refresh_times"`
	// 竞技场分享次数
	BattleShareTimes int `bson:"battle_share_times" codec:"battle_share_times"`
	// 金币抽卡次数
	DcGoldCount int `bson:"dc_gold_count" codec:"dc_gold_count"`
	// 无尽塔挑战/扫荡次数
	EndlessChallenge int `bson:"endless_challenge" codec:"endless_challenge"`
	// 扭蛋机每日免费单抽计数器
	LuckyEggFreeCounter int `bson:"lucky_egg_free_counter" codec:"lucky_egg_free_counter"`
	// 钓鱼今日次数
	FishingCounter int `bson:"fishing_counter" codec:"fishing_counter"`
	// 钓鱼今日成功次数
	FishingWinCounter int `bson:"fishing_win_counter" codec:"fishing_win_counter"`
	// 钓鱼今日记录
	FishingRecord map[document.Integer]int `bson:"fishing_record" codec:"fishing_record"`
	// 运营活动发红包次数
	HuodongRedPacketSend int `bson:"huodong_redPacket_send" codec:"huodong_redPacket_send"`
	// 运营活动抢红包次数
	HuodongRedPacketRob int `bson:"huodong_redPacket_rob" codec:"huodong_redPacket_rob"`
	// 公会碎片赠予次数
	UnionFragDonateTimes int `bson:"union_frag_donate_times" codec:"union_frag_donate_times"`
	// 公会碎片赠予发起次数
	UnionFragDonateStartTimes int `bson:"union_frag_donate_start_times" codec:"union_frag_donate_start_times"`
	// 私聊聊天次数
	RoleChatTimes int `bson:"role_chat_times" codec:"role_chat_times"`
	// 免费宝石钻石单抽
	GemRmbDc1FreeCount int `bson:"gem_rmb_dc1_free_count" codec:"gem_rmb_dc1_free_count"`
	// 钻石抽宝石次数
	DrawGemRmb int `bson:"draw_gem_rmb" codec:"draw_gem_rmb"`
	// 免费宝石金币单抽
	GemGoldDc1FreeCount int `bson:"gem_gold_dc1_free_count" codec:"gem_gold_dc1_free_count"`
	// 金币抽宝石次数
	DrawGemGold int `bson:"draw_gem_gold" codec:"draw_gem_gold"`
	// 抽宝石次数
	DrawGem int `bson:"draw_gem" codec:"draw_gem"`
	// 免费芯片钻石单抽
	ChipRmbDc1FreeCount int `bson:"chip_rmb_dc1_free_count" codec:"chip_rmb_dc1_free_count"`
	// 钻石抽芯片次数
	DrawChipRmb int `bson:"draw_chip_rmb" codec:"draw_chip_rmb"`
	// 免费芯片道具单抽
	ChipItemDc1FreeCount int `bson:"chip_item_dc1_free_count" codec:"chip_item_dc1_free_count"`
	// 道具抽芯片次数
	DrawChipItem int `bson:"draw_chip_item" codec:"draw_chip_item"`
	// 抽芯片次数
	DrawChip int `bson:"draw_chip" codec:"draw_chip"`
	// 跨服竞技场挑战次数
	CrossArenaPwTimes int `bson:"cross_arena_pw_times" codec:"cross_arena_pw_times"`
	// 跨服竞技场更换对手次数
	CrossArenaRefreshTimes int `bson:"cross_arena_refresh_times" codec:"cross_arena_refresh_times"`
	// 跨服竞技场每日奖励 {id: flag}（-1: 未达成  0: 已领取  1: 可领取）
	CrossArenaPointAward map[document.Integer]int `bson:"cross_arena_point_award" codec:"cross_arena_point_award"`
	// 跨服竞技场购买挑战次数
	CrossArenaBuyTimes int `bson:"cross_arena_buy_times" codec:"cross_arena_buy_times"`
	// 跨服竞技场分享次数
	CrossArenaBattleShareTimes int `bson:"cross_arena_battle_share_times" codec:"cross_arena_battle_share_times"`
	// 实时对战每日已经挑战的次数
	CrossOnlineFightTimes int `bson:"cross_online_fight_times" codec:"cross_online_fight_times"`
	// 实时对战每日分享次数
	CrossOnlineFightShareTimes int `bson:"cross_online_fight_share_times" codec:"cross_online_fight_share_times"`
	// 限时up符石免费单抽
	LimitUpGemFreeCount int `bson:"limit_up_gem_free_count" codec:"limit_up_gem_free_count"`
	// 进化石每日购买机会 {csvID: 机会}
	MegaConvertBuyTimes map[document.Integer]int `bson:"mega_convert_buy_times" codec:"mega_convert_buy_times"`
	// 每日精灵评论计数
	CardCommentCounter map[document.Integer]int `bson:"card_comment_counter" codec:"card_comment_counter"`
	// 每日评分计数
	CardScoreCounter map[document.Integer]int `bson:"card_score_counter" codec:"card_score_counter"`
	// 道馆成功挑战次数
	GymBattleTimes int `bson:"gym_battle_times" codec:"gym_battle_times"`
	// 道馆天赋buff点购买次数
	GymTalentPointBuyTimes int `bson:"gym_talent_point_buy_times" codec:"gym_talent_point_buy_times"`
	// 道馆副本挑战购买次数
	GymBattleBuyTimes int `bson:"gym_battle_buy_times" codec:"gym_battle_buy_times"`
	// 活动boss发现次数
	HuodongBossCount int `bson:"huodong_boss_count" codec:"huodong_boss_count"`
	// 活动boss挑战次数
	HuodongBossTimes int `bson:"huodong_boss_times" codec:"huodong_boss_times"`
	// 跨服资源战抢夺次数
	CrossMineRobTimes int `bson:"cross_mine_rob_times" codec:"cross_mine_rob_times"`
	// 跨服资源战报仇次数
	CrossMineRevengeTimes int `bson:"cross_mine_revenge_times" codec:"cross_mine_revenge_times"`
	// 跨服资源战 Boss 挑战次数
	CrossMineBossTimes map[document.ID]int `bson:"cross_mine_boss_times" codec:"cross_mine_boss_times"`
	// 跨服资源战抢夺购买次数
	CrossMineRobBuyTimes int `bson:"cross_mine_rob_buy_times" codec:"cross_mine_rob_buy_times"`
	// 跨服资源战报仇购买次数
	CrossMineRevengeBuyTimes int `bson:"cross_mine_revenge_buy_times" codec:"cross_mine_revenge_buy_times"`
	// 跨服资源战 Boss 挑战购买次数
	CrossMineBossBuyTimes map[document.ID]int `bson:"cross_mine_boss_buy_times" codec:"cross_mine_boss_buy_times"`
	// 跨服资源战 buff喂养 {'server':{csvID:count},'role':{csvID:count}}
	CrossMineBuffFeed CrossMineBuffFeedInfo `bson:"cross_mine_buff_feed" codec:"cross_mine_buff_feed"`
	// 跨服资源战换一批次数
	CrossMineEnemyRefreshTimes int `bson:"cross_mine_enemy_refresh_times" codec:"cross_mine_enemy_refresh_times"`
	// 跨服资源战每日分享次数
	CrossMineShareTimes int `bson:"cross_mine_share_times" codec:"cross_mine_share_times"`
	// 公会问答次数
	UnionQATimes int `bson:"union_qa_times" codec:"union_qa_times"`
	// 公会问答购买
	UnionQABuyTimes int `bson:"union_qa_buy_times" codec:"union_qa_buy_times"`
	// 公会问答 每日首次参加时所在公会id
	UnionQAUnionDbId document.ID `bson:"union_qa_union_db_id" codec:"union_qa_union_db_id"`
	// 公会问答 每日最高分
	UnionQATopScore int `bson:"union_qa_top_score" codec:"union_qa_top_score"`
	// 运营活动跨服发红包次数
	HuodongCrossRedPacketSend int `bson:"huodong_cross_redPacket_send" codec:"huodong_cross_redPacket_send"`
	// 运营活动跨服抢红包次数
	HuodongCrossRedPacketRob int `bson:"huodong_cross_redPacket_rob" codec:"huodong_cross_redPacket_rob"`
	// 勇者挑战次数
	BraveChallengeTimes int `bson:"brave_challenge_times" codec:"brave_challenge_times"`
	// 勇者挑战购买次数
	BraveChallengeBuyTimes int `bson:"brave_challenge_buy_times" codec:"brave_challenge_buy_times"`
	// 自选限定抽卡切换次数
	DrawCardUpChangeTimes int `bson:"draw_card_up_change_times" codec:"draw_card_up_change_times"`
}

func (*DailyRecord) CollectionName() string {
	return "DailyRecord"
}

type UnionRedpacketRob struct {
	_struct struct{} `codec:",toarray"`
	Type    int      `bson:"type"`
	Name    string   `bson:"name"`
	Value   int      `bson:"value"`
}

type OnlineGift struct {
	StartTime float64 `bson:"starttime" codec:"starttime"`
	Idx       int     `bson:"idx" codec:"idx"`
	TotalTime float64 `bson:"totaltime" codec:"totaltime"`
}

type Bet struct {
	_struct struct{} `codec:",toarray"`

	RoleID document.ID
	Gold   int
}

type CraftBets struct {
	Rank1 *Bet `bson:"rank1,omitempty" codec:"rank1,omitempty"`
}

type UnionBet struct {
	_struct struct{} `codec:",toarray"`

	UnionID document.ID
	Gold    int
}

type UnionfightBets struct {
	Rank1 *UnionBet `bson:"rank1,omitempty" codec:"rank1,omitempty"`
}

type CrossMineBuffFeedInfo struct {
	Server map[document.Integer]int `bson:"server,omitempty" codec:"server,omitempty"`
	Role   map[document.Integer]int `bson:"role,omitempty" codec:"role,omitempty"`
}

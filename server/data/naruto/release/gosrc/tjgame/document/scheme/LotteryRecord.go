package scheme

import "tjgame/document"

// 抽奖记录
type LotteryRecord struct {
	document.DocumentID `bson:",inline"`

	// Role.id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// 金币单抽
	Dc1GoldCounter int `bson:"dc1_gold_counter" codec:"dc1_gold_counter"`
	// 金币10连抽
	Dc10GoldCounter int `bson:"dc10_gold_counter" codec:"dc10_gold_counter"`
	// 钻石单抽计数器
	Dc1Counter int `bson:"dc1_counter" codec:"dc1_counter"`
	// 钻石10连抽计数器
	Dc10Counter int `bson:"dc10_counter" codec:"dc10_counter"`
	// 装备钻石单抽计数器
	EqDc1Counter int `bson:"eq_dc1_counter" codec:"eq_dc1_counter"`
	// 装备钻石10连抽计数器
	EqDc10Counter int `bson:"eq_dc10_counter" codec:"eq_dc10_counter"`
	// 远征免费宝箱抽取计数器
	YzFreeboxCounter int `bson:"yz_freeBox_counter" codec:"yz_freeBox_counter"`
	// 权值浮动 {key:{csvID:weight}}
	WeightInfo map[string]map[document.Integer]float64 `bson:"weight_info" codec:"weight_info"`
	// 生效次数 {key:{csvID:count}}
	EffectInfo map[string]map[document.Integer]int `bson:"effect_info" codec:"effect_info"`
	// 道具单抽计数器
	ItemDc1Counter int `bson:"item_dc1_counter" codec:"item_dc1_counter"`
	// 宝石钻石单抽计数器
	GemRmbDc1Counter int `bson:"gem_rmb_dc1_counter" codec:"gem_rmb_dc1_counter"`
	// 宝石钻石10连抽计数器
	GemRmbDc10Counter int `bson:"gem_rmb_dc10_counter" codec:"gem_rmb_dc10_counter"`
	// 宝石金币单抽计数器
	GemGoldDc1Counter int `bson:"gem_gold_dc1_counter" codec:"gem_gold_dc1_counter"`
	// 宝石金币10连抽计数器
	GemGoldDc10Counter int `bson:"gem_gold_dc10_counter" codec:"gem_gold_dc10_counter"`
	// 芯片钻石单抽计数器
	ChipRmbDc1Counter int `bson:"chip_rmb_dc1_counter" codec:"chip_rmb_dc1_counter"`
	// 芯片钻石10连抽计数器
	ChipRmbDc10Counter int `bson:"chip_rmb_dc10_counter" codec:"chip_rmb_dc10_counter"`
	// 芯片道具单抽计数器
	ChipItemDc1Counter int `bson:"chip_item_dc1_counter" codec:"chip_item_dc1_counter"`
	// 芯片道具10连抽计数器
	ChipGoldDc10Counter int `bson:"chip_item_dc10_counter" codec:"chip_item_dc10_counter"`
	// 运营活动相关抽卡计数器 {yyType: count}
	YyhuodongsCounters map[document.Integer]int `bson:"yyhuodong_counters" codec:"yyhuodong_counters"`
	// 掉落库权值浮动 {key:{csvID:weight}}
	LibWeightInfo map[string]map[document.Integer]float64 `bson:"lib_weight_info" codec:"lib_weight_info"`
	// 掉落库生效次数 {key:{csvID:count}}
	LibEffectInfo map[string]map[document.Integer]int `bson:"lib_effect_info" codec:"lib_effect_info"`
	// 抽取芯片掉落库生效次数
	DrawChipLibCounter map[document.Integer]int `bson:"draw_chip_lib_counter" codec:"draw_chip_lib_counter"`
	// 自选限定抽卡单抽
	DrawCardUp1Counters map[document.Integer]int `bson:"draw_card_up1_counters" codec:"draw_card_up1_counters"`
	// 自选限定抽卡10连抽
	DrawCardUp10Counters map[document.Integer]int `bson:"draw_card_up10_counters" codec:"draw_card_up10_counters"`
	// 自选限定抽卡选择up
	DrawCardUpChoose int `bson:"draw_card_up_choose" codec:"draw_card_up_choose"`
}

func (*LotteryRecord) CollectionName() string {
	return "LotteryRecord"
}

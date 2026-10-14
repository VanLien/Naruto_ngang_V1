package scheme

import "tjgame/document"

// 钓鱼
type Fishing struct {
	document.DocumentID `bson:",inline"`

	// Role.id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// 钓鱼等级
	Level int `bson:"level" codec:"level" default:"1"`
	// 钓到过的鱼
	Fish map[document.Integer]*FishingFish `bson:"fish" codec:"fish"`
	// 解锁的伙伴
	Partner map[document.Integer]int `bson:"partner" codec:"partner"`
	// 历史最大长度
	LengthMax int `bson:"length_max" codec:"length_max"`
	// 选择的场景
	SelectScene int `bson:"select_scene" codec:"select_scene"`
	// 选择的鱼竿
	SelectRod int `bson:"select_rod" codec:"select_rod"`
	// 选择的鱼饵
	SelectBait int `bson:"select_bait" codec:"select_bait"`
	// 选择的伙伴
	SelectPartner int `bson:"select_partner" codec:"select_partner"`
	// 钓鱼计数器
	FishCounter map[document.Integer]int `bson:"fish_counter" codec:"fish_counter"`
	// 目标鱼计数器
	TargetCounter int `bson:"target_counter" codec:"target_counter"`
	// 是否自动
	IsAuto bool `bson:"is_auto" codec:"is_auto"`
	// 自动钓鱼是否已经停止
	AutoStopped bool `bson:"auto_stopped" codec:"auto_stopped"`
	// 开始自动钓鱼的时间
	AutoStartTime float64 `bson:"auto_start_time" codec:"auto_start_time"`
	// 自动钓鱼消耗掉的时间
	AutoUsedTime int `bson:"auto_used_time" codec:"auto_used_time"`
	// 可自动钓鱼的次数
	AutoLastTimes int `bson:"auto_last_times" codec:"auto_last_times"`
	// 自动钓鱼成功次数
	AutoWinCounter int `bson:"auto_win_counter" codec:"auto_win_counter"`
	// 自动钓鱼失败次数
	AutoFailCounter int `bson:"auto_fail_counter" codec:"auto_fail_counter"`
	// 自动钓鱼奖励
	AutoAward AutoAwardMap `bson:"auto_award" codec:"auto_award"`
	// 权值记录
	WeightRecord map[document.Integer]float64 `bson:"weight_record" codec:"weight_record"`
	// 最后一次操作周
	LastWeek int `bson:"last_week" codec:"last_week"`
	// 每周鱼出现次数
	WeekRecord map[document.Integer]int `bson:"week_record" codec:"week_record"`
	// 最后参加钓鱼大赛日期
	LastPlayDate int `bson:"last_play_date" codec:"last_play_date"`
	// 钓鱼大赛积分
	Point int `bson:"point" codec:"point"`
	// 钓鱼大赛特殊鱼积分
	SpecialFishNum int `bson:"special_fish_num" codec:"special_fish_num"`
}

func (*Fishing) CollectionName() string {
	return "Fishing"
}

type FishingFish struct {
	// 钓到该鱼的数量
	Counter int `bson:"counter" codec:"counter"`
	// 大鱼次数计数器
	BigCounter int `bson:"big_counter" codec:"big_counter"`
	// 钓到的该鱼的最大长度
	LengthMax int `bson:"length_max" codec:"length_max"`
}

type AutoAwardMap struct {
	document.GoodsMap `bson:",inline"`

	Fish map[document.Integer]int `bson:"fish" codec:"fish"`
}

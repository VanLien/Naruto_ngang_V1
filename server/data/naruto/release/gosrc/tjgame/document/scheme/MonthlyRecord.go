package scheme

import "tjgame/document"

// 每月记录自然月刷新
type MonthlyRecord struct {
	document.DocumentID `bson:",inline"`

	// 年月
	Month int `bson:"month" codec:"month" index:"true" default:"todaymonth2int"`
	// Role.id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// 签到次数
	SignIn int `bson:"sign_in" codec:"sign_in"`
	// 最新签到日
	LastSignInDay int `bson:"last_sign_in_day" codec:"last_sign_in_day"`
	// 最新签到csvid
	LastSignInIdx int `bson:"last_sign_in_idx" codec:"last_sign_in_idx"`
	// 月签到奖励
	SignInGift map[document.Integer]int `bson:"sign_in_gift" codec:"sign_in_gift"`
	// 补签次数
	SignInBuyTimes int `bson:"sign_in_buy_times" codec:"sign_in_buy_times"`
	// 签到奖励倍数(含补签) {day: {csvid: multiple}}
	SignInAwards map[document.Integer]map[document.Integer]int `bson:"sign_in_awards" codec:"sign_in_awards"`
	// 刷新时的 vip
	Vip int `bson:"vip" codec:"vip"`
	// vip 月度礼包
	VipGift map[document.Integer]int `bson:"vip_gift" codec:"vip_gift"`
	// 公会副本击杀奖励次数 {csvID: times}
	UnionFubenDeadlyTimes map[document.Integer]int `bson:"union_fuben_deadly_times" codec:"union_fuben_deadly_times"`
}

func (*MonthlyRecord) CollectionName() string {
	return "MonthlyRecord"
}

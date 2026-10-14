package scheme

import "tjgame/document"

// 支付信息
type PayOrder struct {
	document.DocumentID `bson:",inline"`

	// Account.id
	AccountID document.ID `bson:"account_id" codec:"account_id" index:"true"`
	// game server defines
	ServerKey string `bson:"server_key" codec:"server_key" index:"true"`
	// Role.id
	RoleID document.ID `bson:"role_id" codec:"role_id" index:"true"`
	// 支付回调时间
	Time float64 `bson:"time" codec:"time" index:"true" default:"nowtime_t"`
	// 用户来源渠道
	Channel string `bson:"channel" codec:"channel" index:"true"`
	// 支付结果 ok, err
	Result string `bson:"result" codec:"result" index:"true"`
	// 支付记录回调数据
	SdkMsg string `bson:"sdkmsg" codec:"sdkmsg"`
	// 支付唯一订单号
	OrderID string `bson:"order_id" codec:"order_id" unique:"true"`
	// recharges.csv ID
	RechargeID int `bson:"recharge_id" codec:"recharge_id" index:"true"`
	// 充值金额
	Amount float64 `bson:"amount" codec:"amount"`
	// 是否已经充值到游戏账户
	RechargeFlag bool `bson:"recharge_flag" codec:"recharge_flag" index:"true"`
	// 是否是坏账，可能cdata数据有问题，可能支付失败
	BadFlag bool `bson:"bad_flag" codec:"bad_flag" index:"true"`
	// 运营活动 yyid
	YYID int `bson:"yy_id" codec:"yy_id"`
	// 运营活动 CSV ID
	CSVID int `bson:"csv_id" codec:"csv_id"`
}

func (*PayOrder) CollectionName() string {
	return "PayOrder"
}

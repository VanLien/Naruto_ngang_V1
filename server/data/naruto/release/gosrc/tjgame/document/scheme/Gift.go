package scheme

import "tjgame/document"
 
// 礼包
type Gift struct {
	document.DocumentID `bson:",inline"`

	// 礼包码
	Key string `bson:"key" codec:"key" unique:"true"`
	// 礼包CSV ID
	CSVID int `bson:"csv_id" codec:"csv_id" index:"true"`
	// Available regional servers, if empty, it means all servers are used
	OptServerKeys []string `bson:"opt_server_keys" codec:"opt_server_keys"`
	// District uniform received
	UseServerKey string `bson:"use_server_key" codec:"use_server_key"`
	// Pick up time
	UseTime int64 `bson:"use_time" codec:"use_time"`
	// 领取者Account.id
	AccountDBID document.ID `bson:"account_db_id" codec:"account_db_id"`

	// 支付唯一订单号
	OrderID string `bson:"order_id,omitempty" codec:"order_id,omitempty"`
}

func (*Gift) CollectionName() string {
	return "Gift"
}

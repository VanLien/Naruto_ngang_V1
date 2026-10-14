package scheme

import "tjgame/document"

// 运营动态配置
type GMYYConfig struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key"`
	// yyhuodong.csv的在线配置，结构与csv相同
	Yyhuodong document.RawMap `bson:"yyhuodong" codec:"yyhuodong"`
	// loginweal.csv的在线配置，结构与csv相同
	LoginWeal document.RawMap `bson:"login_weal" codec:"login_weal"`
	// levelaward.csv的在线配置，结构与csv相同
	LevelAward document.RawMap `bson:"level_award" codec:"level_award"`
	// rechargegift.csv的在线配置，结构与csv相同
	RechargeGift document.RawMap `bson:"recharge_gift" codec:"recharge_gift"`
	// placard.csv的在线配置，结构与csv相同
	Placard document.RawMap `bson:"placard" codec:"placard"`
}

func (*GMYYConfig) CollectionName() string {
	return "GMYYConfig"
}

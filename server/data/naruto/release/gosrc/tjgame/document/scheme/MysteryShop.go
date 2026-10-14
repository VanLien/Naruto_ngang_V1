package scheme

import "tjgame/document"

// 神秘商店每日刷新，刷新时间由ShopRefreshTime控制
type MysteryShop struct {
	document.DocumentID `bson:",inline"`

	// Role.id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// 商店商品列表 {栏位ID: (商店CSV ID, 商品ID)}
	Items map[document.Integer][2]int `bson:"items" codec:"items"`
	// 已购买商店格子下标（0下标开始） {index:1}
	Buy map[document.Integer]bool `bson:"buy" codec:"buy"`
	// 商店刷新时间
	LastTime float64 `bson:"last_time" codec:"last_time"`
	// 商店上次激活时间
	LastActiveTime float64 `bson:"last_active_time" codec:"last_active_time"`
	// 商店刷新次数
	RefreshTimes int `bson:"refresh_times" codec:"refresh_times"`
}

func (*MysteryShop) CollectionName() string {
	return "MysteryShop"
}

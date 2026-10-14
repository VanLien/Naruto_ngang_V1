package scheme

import "tjgame/document"

// 固定商店
type FixShop struct {
	document.DocumentID `bson:",inline"`

	// Role.id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// 商店商品列表 {栏位ID: (商店CSV ID, 商品ID)}
	Items map[document.Integer][2]int `bson:"items" codec:"items"`
	// 已购买商店格子下标（0下标开始） {index:1}
	Buy map[document.Integer]bool `bson:"buy" codec:"buy"`
	// 商店刷新时间
	LastTime float64 `bson:"last_time" codec:"last_time"`
}

func (*FixShop) CollectionName() string {
	return "FixShop"
}

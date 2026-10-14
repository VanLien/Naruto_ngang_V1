package scheme

import "tjgame/document"

// 携带道具
type RoleHeldItem struct {
	document.DocumentID `bson:",inline"`

	// Role.id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// 携带道具上的RoleCard.id
	CardDbId document.ID `bson:"card_db_id" codec:"card_db_id"`
	// 携带道具 CSV ID
	HeldItemId int `bson:"held_item_id" codec:"held_item_id"`
	// 进阶突破等级
	Advance int `bson:"advance" codec:"advance"`
	// 强化等级
	Level int `bson:"level" codec:"level" default:"1"`
	// 是否存在（可能已经被熔炼）
	ExistFlag bool `bson:"exist_flag" codec:"exist_flag" index:"true" default:"True"`
	// 道具经验
	SumExp int `bson:"sum_exp" codec:"sum_exp"`
	// 突破消耗的万能道具数量
	CostUniversalItems map[document.Integer]int `bson:"cost_universal_items" codec:"cost_universal_items"`
}

func (*RoleHeldItem) CollectionName() string {
	return "RoleHeldItem"
}

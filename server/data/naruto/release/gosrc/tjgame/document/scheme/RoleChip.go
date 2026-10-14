package scheme

import "tjgame/document"

// 芯片
type RoleChip struct {
	document.DocumentID `bson:",inline"`

	// 芯片嵌套后的RoleCard.id
	CardDbId document.ID `bson:"card_db_id" codec:"card_db_id"`
	// Role.id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// 芯片 CSV ID
	ChipId int `bson:"chip_id" codec:"chip_id"`
	// 初次随机到的附属性：[副属性随机库的csvID]
	First []int `bson:"first" codec:"first"`
	// 当前的附属性：[(副属性随机库的csvID, 洗炼次数, 强化次数)]
	Now [][]int `bson:"now" codec:"now"`
	// 重生前副属性 [[csvID, 洗练次数, 强化次数]]
	Before [][]int `bson:"before" codec:"before"`
	// 重生后是否洗练
	RecastFlag bool `bson:"recast_flag" codec:"recast_flag" default:"False"`
	// 强化等级
	Level int `bson:"level" codec:"level" default:"1"`
	// 强化当前等级下的经验
	LevelExp int `bson:"level_exp" codec:"level_exp"`
	// 当前获得的总经验
	SumExp int `bson:"sum_exp" codec:"sum_exp"`
	// 是否存在（可能已经被当作强化消耗）
	ExistFlag bool `bson:"exist_flag" codec:"exist_flag" index:"true" default:"True"`
	// 锁定状态
	Locked bool `bson:"locked" codec:"locked" default:"False"`
}

func (*RoleChip) CollectionName() string {
	return "RoleChip"
}

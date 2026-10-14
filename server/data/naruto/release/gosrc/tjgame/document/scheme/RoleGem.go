package scheme

import "tjgame/document"

// 宝石
type RoleGem struct {
	document.DocumentID `bson:",inline"`

	// Role.id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// 宝石嵌套后的RoleCard.id
	CardDbId document.ID `bson:"card_db_id" codec:"card_db_id"`
	// 宝石 CSV ID
	GemId int `bson:"gem_id" codec:"gem_id"`
	// 强化等级
	Level int `bson:"level" codec:"level" default:"1"`
	// 是否存在（可能已经被分解）
	ExistFlag bool `bson:"exist_flag" codec:"exist_flag" index:"true" default:"True"`
}

func (*RoleGem) CollectionName() string {
	return "RoleGem"
}

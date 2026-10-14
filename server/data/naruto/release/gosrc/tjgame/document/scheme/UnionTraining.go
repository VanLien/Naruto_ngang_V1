package scheme

import "tjgame/document"

// 公会训练所从属于Role
type UnionTraining struct {
	document.DocumentID `bson:",inline"`

	// Role.id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// 训练所栏位 {idx: {who: RoleCard.id（0表示空）, last_time: 经验奖励最后更新时间, card:缓存客户端显示用的属性}}
	Slots map[document.Integer]*UnionTrainingSlot `bson:"slots" codec:"slots"`
	// 栏位开通
	Opened map[document.Integer]bool `bson:"opened" codec:"opened"`
	// 离线经验获得（别人的加速）{card.id: exp}
	OfflineExp map[document.ID]int `bson:"offline_exp" codec:"offline_exp"`
	// 离线被别人加速 {date: [roleName]}
	OfflineSpeedup map[document.Integer][]string `bson:"offline_speedup" codec:"offline_speedup"`
}

func (*UnionTraining) CollectionName() string {
	return "UnionTraining"
}

type UnionTrainingCard struct {
	ID       document.ID `bson:"id" codec:"id"`
	CardID   int         `bson:"card_id" codec:"card_id"`
	Name     string      `bson:"name" codec:"name"`
	Advance  int         `bson:"advance" codec:"advance"`
	Star     int         `bson:"star" codec:"star"`
	Level    int         `bson:"level" codec:"level"`
	LevelExp int         `bson:"level_exp" codec:"level_exp"`
	SumExp   int         `bson:"sum_exp" codec:"sum_exp"`
}

type UnionTrainingSlot struct {
	UnionTrainingCard `bson:",inline"`

	// 经验奖励最后更新时间
	LastTime float64 `bson:"last_time" codec:"last_time"`
}

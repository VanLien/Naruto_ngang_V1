package scheme

import "tjgame/document"

// 社交
type Society struct {
	document.DocumentID `bson:",inline"`

	// Role.id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// 好友列表 [Role.id]
	Friends []document.ID `bson:"friends" codec:"friends"`
	// 好友申请列表 [Role.id]
	FriendReqs []document.ID `bson:"friend_reqs" codec:"friend_reqs"`
	// 好友体力可领取列表 [Role.id]
	StaminaRecv []document.ID `bson:"stamina_recv" codec:"stamina_recv"`
	// 黑名单列表 [Role.id]
	BlackList []document.ID `bson:"black_list" codec:"black_list"`
}

func (*Society) CollectionName() string {
	return "Society"
}

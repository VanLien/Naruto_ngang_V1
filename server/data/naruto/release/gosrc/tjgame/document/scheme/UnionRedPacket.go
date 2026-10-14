package scheme

import "tjgame/document"

// 公会红包从属于Union
type UnionRedPacket struct {
	document.DocumentID `bson:",inline"`

	// union.id
	UnionDbId document.ID `bson:"union_db_id" codec:"union_db_id" index:"true"`
	// 0:玩家红包 1:系统红包
	PacketFlag int `bson:"packet_flag" codec:"packet_flag"`
	// 0:金币红包 1:钻石红包 2:神器红包
	PacketType int `bson:"packet_type" codec:"packet_type"`
	// 上次重置时间
	Date int `bson:"date" codec:"date"`
	// 创建红包时间
	CreatedTime float64 `bson:"created_time" codec:"created_time"`
	// Role.id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id"`
	// 角色名字
	RoleName string `bson:"role_name" codec:"role_name"`
	// CSVID
	CSVID int `bson:"csv_id" codec:"csv_id"`
	// 总量
	TotalVal int `bson:"total_val" codec:"total_val"`
	// 总个数
	TotalCount int `bson:"total_count" codec:"total_count"`
	// 公会成员 {Role.id: {id:Role.id, lg:Role.logo, n:Role.name, vip:Role.vip_level, val:val}, ...}
	Members map[document.ID]UnionRedPacketMember `bson:"members" codec:"members"`
	// 是否已废弃
	DiscardFlag bool `bson:"discard_flag" codec:"discard_flag" index:"true"`
}

func (*UnionRedPacket) CollectionName() string {
	return "UnionRedPacket"
}

type UnionRedPacketMember struct {
	UnionMemberRole `bson:",inline"`

	Val int `bson:"val" codec:"val"`
}

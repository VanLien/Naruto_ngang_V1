package scheme

import "tjgame/document"

// 跨服红包活动
type CrossRedPacketGlobal struct {
	document.DocumentID `bson:",inline"`
	// servkey
	Key string `bson:"key" codec:"key" index:"true"`
	// 组
	Group int `bson:"group" codec:"group"`
	// 参与的server [node key list]
	Servers []string `bson:"servers" codec:"servers"`
	// 日期
	EndDate int `bson:"end_date" codec:"end_date"`
	// yyID
	YYID int `bson:"yyID" codec:"yyID"`
	// 红包
	RedPackets map[document.Integer]*RedPacketInfo `bson:"red_packets" codec:"red_packets"`
	// status
	Status string `bson:"status" codec:"status" default:"closed"`
}

func (*CrossRedPacketGlobal) CollectionName() string {
	return "CrossRedPacketGlobal"
}

type RedPacketInfo struct {
	Idx         document.Integer           `bson:"idx" codec:"idx"`
	GameKey     string                     `bson:"game_key" codec:"game_key"`
	CreatedTime int                        `bson:"created_time" codec:"created_time"`
	RoleId      document.ID                `bson:"role_id" codec:"role_id"`
	RoleName    string                     `bson:"role_name" codec:"role_name"`
	RoleLogo    int                        `bson:"role_logo" codec:"role_logo"`
	RoleFrame   int                        `bson:"role_frame" codec:"role_frame"`
	TotalVal    int                        `bson:"total_val" codec:"total_val"`
	TotalCount  int                        `bson:"total_count" codec:"total_count"`
	Message     string                     `bson:"message" codec:"message"`
	Members     map[document.ID]MemberInfo `bson:"members" codec:"members"`
}

type MemberInfo struct {
	// role.id
	Id      document.ID `bson:"id" codec:"id"`
	GameKey string      `bson:"game_key" codec:"game_key"`
	Logo    int         `bson:"logo" codec:"logo"`
	Name    string      `bson:"name" codec:"name"`
	Vip     int         `bson:"vip" codec:"vip"`
	Frame   int         `bson:"frame" codec:"frame"`
	Val     int         `bson:"val" codec:"val"`
	Union   string      `bson:"union" codec:"union"`
}

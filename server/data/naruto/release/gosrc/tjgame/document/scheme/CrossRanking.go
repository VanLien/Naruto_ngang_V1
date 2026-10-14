package scheme

import "tjgame/document"

type RoleRankInfo struct {
	RoleID  document.ID `bson:"role_id" codec:"role_id"`
	Logo    int         `bson:"logo" codec:"logo"`
	Frame   int         `bson:"frame" codec:"frame"`
	Name    string      `bson:"name" codec:"name"`
	Level   int         `bson:"level" codec:"level"`
	Vip     int         `bson:"vip" codec:"vip"`
	GameKey string      `bson:"game_key" codec:"game_key"` // 区服

	RankData               []int    `bson:"rank_data" codec:"rank_data"`                       // 排行数据
	OtherData              []int    `bson:"other_data,omitempty" codec:"other_data,omitempty"` // 其他数据
	BraveChallengeRankInfo RankInfo `bson:"brave_challenge_rank_info,omitempty" codec:"brave_challenge_rank_info,omitempty"`

	Timestamp int64 `bson:"timestamp" codec:"timestamp"` // 时间戳
}

type CrossRankingGlobal struct {
	document.DocumentID `bson:",inline"`
	// servkey
	Key string `bson:"key" codec:"key" index:"true"`
	// 玩法名称
	GamePlay string `bson:"game_paly" codec:"game_paly"`
	// 组
	Group int `bson:"group" codec:"group"`
	// 参与的server [node key list]
	Servers []string `bson:"servers" codec:"servers"`
	// 日期
	EndDate int `bson:"end_date" codec:"end_date"`
	// yyID
	YYID int `bson:"yyID" codec:"yyID"`
	// 排名信息
	RankInfo map[document.ID]*RoleRankInfo `bson:"rank_info" codec:"rank_info"`
	// status
	Status string `bson:"status" codec:"status" default:"closed"`
}

func (*CrossRankingGlobal) CollectionName() string {
	return "CrossRankingGlobal"
}

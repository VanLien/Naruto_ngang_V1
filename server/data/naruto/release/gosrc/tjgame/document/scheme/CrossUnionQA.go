package scheme

import "tjgame/document"

type CrossUnionQAPlayKey struct {
	CrossKey string `bson:"cross_key" codec:"cross_key"`
	Group    int    `bson:"group" codec:"group"`
}

// 跨服公会问答
type CrossUnionQAGlobal struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key" index:"true"`
	// 组
	Group int `bson:"group" codec:"group"`
	// 参与的server [node key list]
	Servers []string `bson:"servers" codec:"servers"`
	// 开始日期
	Date int `bson:"date" codec:"date"`
	// 结束日期
	EndDate int `bson:"end_date" codec:"end_date"`
	// round
	Round string `bson:"round" codec:"round" default:"closed"`
	// 已经结束的区服
	ClosedServers map[string]float64 `bson:"closed_servers" codec:"closed_servers"`
	// 玩家
	Roles map[document.ID]*CrossUnionQARoleItem `bson:"roles" codec:"roles"`
	// 公会
	Unions map[document.ID]*CrossUnionQAUnionItem `bson:"unions" codec:"unions"`
	// 玩家排名
	RoleRanks map[document.Integer][]CrossUnionQARoleRankItem `bson:"role_ranks" codec:"role_ranks"`
	// 公会排名
	UnionRanks map[document.Integer][]CrossUnionQAUnionRankItem `bson:"union_ranks" codec:"union_ranks"`
}

func (*CrossUnionQAGlobal) CollectionName() string {
	return "CrossUnionQAGlobal"
}

type CrossUnionQARoleInfo struct {
	RoleID    document.ID `bson:"role_db_id" codec:"role_db_id"`
	GameKey   string      `bson:"game_key" codec:"game_key"`
	Name      string      `bson:"name" codec:"name"`
	Logo      int         `bson:"logo" codec:"logo"`
	Frame     int         `bson:"frame" codec:"frame"`
	Level     int         `bson:"level" codec:"level"`
	UnionName string      `bson:"union_name" codec:"union_name"`
}

type CrossUnionQARoleItem struct {
	CrossUnionQARoleInfo `bson:",inline"`

	RankRecord map[document.Integer]CrossUnionQAMyRankItem `bson:"rank_record" codec:"rank_record"`

	TotalScore int                      `bson:"total_score" codec:"total_score"`
	Score      map[document.Integer]int `bson:"score" codec:"score"`
	LastTime   float64                  `bson:"last_time" codec:"last_time"`
}

type CrossUnionQAUnionInfo struct {
	ID       document.ID `bson:"id" codec:"id"`
	Level    int         `bson:"level" codec:"level"`
	Logo     int         `bson:"logo" codec:"logo"`
	Name     string      `bson:"name" codec:"name"`
	GameKey  string      `bson:"game_key" codec:"game_key"`
	ChairMan string      `bson:"chairman" codec:"chairman"`
}

type CrossUnionQAUnionItem struct {
	CrossUnionQAUnionInfo `bson:",inline"`

	RankRecord map[document.Integer]CrossUnionQAMyRankItem `bson:"rank_record" codec:"rank_record"`
	TotalScore int                                         `bson:"total_score" codec:"total_score"`
	Roles      map[document.Integer]map[document.ID]int    `bson:"roles" codec:"roles"`
	Score      map[document.Integer]int                    `bson:"score" codec:"score"`
	LastTime   float64                                     `bson:"last_time" codec:"last_time"`
}

type CrossUnionQARoleRankItem struct {
	CrossUnionQARoleInfo `bson:",inline"`

	Rank  int `bson:"rank" codec:"rank"`
	Score int `bson:"score" codec:"score"`
}

type CrossUnionQAUnionRankItem struct {
	CrossUnionQAUnionInfo `bson:",inline"`

	Rank  int `bson:"rank" codec:"rank"`
	Score int `bson:"score" codec:"score"`
}

type CrossUnionQAMyRankItem struct {
	Rank  int `bson:"rank" codec:"rank"`
	Score int `bson:"score" codec:"score"`
	// 公会名字 or 会长名字
	Name string `bson:"name" codec:"name"`
}

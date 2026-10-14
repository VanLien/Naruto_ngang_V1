package scheme

import "tjgame/document"

type CrossFishingPlayKey struct {
	CrossKey string `bson:"cross_key" codec:"cross_key"`
	Group    int    `bson:"group" codec:"group"`
}

// 跨服钓鱼大赛
type CrossFishingGlobal struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key" index:"true"`
	// 组
	Group int `bson:"group" codec:"group"`
	// 参与的server [node key list]
	Servers []string `bson:"servers" codec:"servers"`
	// 开始日期
	Date int `bson:"date" codec:"date"`
	// CraftGlobal.time
	Time int64 `bson:"time" codec:"time"`
	// round
	Round string `bson:"round" codec:"round" default:"closed"`
	// 已经结束的区服
	ClosedServers map[string]float64 `bson:"closed_servers" codec:"closed_servers"`
	// 参赛玩家
	Roles map[document.ID]*CrossFishingRoleItem ` bson:"roles" codec:"roles"`
}

func (*CrossFishingGlobal) CollectionName() string {
	return "CrossFishingGlobal"
}

type CrossFishingRoleInfo struct {
	RoleID  document.ID `bson:"role_db_id" codec:"role_db_id"`
	GameKey string      `bson:"game_key" codec:"game_key"`
	Name    string      `bson:"name" codec:"name"`
	Logo    int         `bson:"logo" codec:"logo"`
	Frame   int         `bson:"frame" codec:"frame"`
	Level   int         `bson:"level" codec:"level"`
}

type CrossFishingRoleItem struct {
	CrossFishingRoleInfo `bson:",inline"`

	LastTime       float64 `bson:"last_time" codec:"last_time"`
	Rank           int     `bson:"rank" codec:"rank"`
	Point          int     `bson:"point" codec:"point"`
	SpecialFishNum int     `bson:"special_fish_num" codec:"special_fish_num"`
}

// 跨服钓鱼大赛 Game 记录
type CrossFishingGameGlobal struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key" unique:"true"`
	// 跨服server key
	CrossKey string `bson:"cross_key" codec:"cross_key"`
	// 开始日期
	Date int `bson:"date" codec:"date"`
	// CraftGlobal.time
	Round string `bson:"round" codec:"round" default:"closed"`
	// 自动钓鱼的玩家
	AutoRoles map[document.ID]CrossFishingGameGlobalAutoRole `bson:"auto_roles" codec:"auto_roles"`
	// 上期排名
	LastRanks []CrossFishingRoleItem `bson:"last_ranks" codec:"last_ranks"`
	// 上期匹配服务
	LastServers []string `bson:"last_servers" codec:"last_servers"`
}

type CrossFishingGameGlobalAutoRole struct {
	// 日期
	Time float64 `bson:"time" codec:"time"`
	// 失败次数, 成功次数根据钓的鱼计算
	Fail int `bson:"fail" codec:"fail"`
	// 排名相关信息
	Info struct {
		CrossFishingRoleInfo `bson:",inline"`
		Point                int `bson:"point" codec:"point"`
		SpecialFishNum       int `bson:"special_fish_num" codec:"special_fish_num"`
	} `bson:"info" codec:"info"`
	// 钓到的鱼
	Fish map[document.Integer]int `bson:"fish" codec:"fish"`
	// 奖励
	Award document.GoodsMap `bson:"award" codec:"award"`
	// 鱼饵消耗
	Cost map[document.Integer]int `bson:"cost" codec:"cost"`
	// 权值记录
	WeightRecord map[document.Integer]float64 `bson:"weight_record" codec:"weight_record"`
}

func (*CrossFishingGameGlobal) CollectionName() string {
	return "CrossFishingGameGlobal"
}

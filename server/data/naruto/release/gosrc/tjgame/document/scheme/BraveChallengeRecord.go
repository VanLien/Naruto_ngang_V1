package scheme

import (
	"tjgame/document"
)

// 勇者挑战记录
type BraveChallengeRecord struct {
	document.DocumentID `bson:",inline"`

	// 玩家id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// 刷新日期
	LastDate int `bson:"last_date" codec:"last_date" default:"todayinclock5date2int"`
	// yyID
	YYId int `bson:"yyID" codec:"yyID"`
	// 主题开放时间 普通勇者用
	LastOpenDate int `bson:"last_open_date" codec:"last_open_date"`
	// 解锁卡池
	UnlockCards []int `bson:"unlock_cards" codec:"unlock_cards"`
	// 新增解锁 用于客户端展示
	Add []int `bson:"add" codec:"add"`
	// 已获得的勋章 {type: [id ...]}
	Badges map[document.Integer][]int `bson:"badges" codec:"badges"`
	// 勋章全局计数
	BadgeCounter map[document.Integer]int `bson:"badge_counter" codec:"badge_counter"`
	// 状态 prepare-准备中 start-挑战中 end-未挑战
	Status string `bson:"status" codec:"status"`
	// 排行信息
	Rank *RankInfo `bson:"rank" codec:"rank"`
	// 首通记录
	Floors map[document.Integer]int `bson:"floors" codec:"floors"`
	// 一轮游戏
	Game *GameInfo `bson:"game" codec:"game"`
	// 卡牌获取计数
	CardCounter map[document.Integer]int `bson:"card_counter" codec:"card_counter"`
	// 指定关卡失败次数
	WeightFail int `bson:"weight_fail" codec:"weight_fail"`
	// 勋章库2新增权重
	Weight int `bson:"weight" codec:"weight"`
	// 通关次数
	PassTimes int `bson:"pass_times" codec:"pass_times"`
	// 失败次数
	FailTimes int `bson:"fail_times" codec:"fail_times"`
	// 上次选择阵容
	LastChoose []int `bson:"last_choose" codec:"last_choose"`
	// 连续选择次数
	TotalTimes int `bson:"total_times" codec:"total_times"`
}

func (*BraveChallengeRecord) CollectionName() string {
	return "BraveChallengeRecord"
}

type GameInfo struct {
	// 初始卡牌
	OriginCards []int `bson:"origin_cards" codec:"origin_cards"`
	// 可用卡牌 {cardID: (hp, mp)}
	Cards map[document.Integer][2]float64 `bson:"cards" codec:"cards"`
	// 怪物 [[hp,mp],...]
	Monsters [][2]float64 `bson:"monsters" codec:"monsters"`
	// 关卡进度
	Floor int `bson:"floor" codec:"floor"`
	// 关卡ID
	FloorID int `bson:"floorID" codec:"floorID"`
	// 怪物阵容ID
	MonsterID int `bson:"monsterID" codec:"monsterID"`
	// 布阵 [csvID]
	Deployments [6]int `bson:"deployments" codec:"deployments"`
	// 待选择的勋章 [[badgeID, libKey],...]
	NewBadges [][]int `bson:"new_badges" codec:"new_badges"`
	// 已消耗的回合
	Round int `bson:"round" codec:"round"`
	// 已过关
	Pass bool `bson:"pass" codec:"pass"`
}

type RankInfo struct {
	// 消耗的回合
	Round int `bson:"round" codec:"round"`
	// 普通勋章个数
	BadgeNum int `bson:"badge_num" codec:"badge_num"`
	// 稀有勋章个数
	RareBadgeNum int `bson:"rare_badge_num" codec:"rare_badge_num"`
	// 通关阵容
	Deployments [6]int `bson:"deployments" codec:"deployments"`
}

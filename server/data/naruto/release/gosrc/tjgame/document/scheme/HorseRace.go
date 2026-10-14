package scheme

import "tjgame/document"

// 赛马
type HorseRaceGlobal struct {
	document.DocumentID `bson:",inline"`

	// cross_key
	Key string `bson:"key" codec:"key" unique:"true"`
	// service.csv的CSV ID
	CsvId int `bson:"csv_id" codec:"csv_id"`
	// 跨服开始日期
	CrossDate int `bson:"cross_date" codec:"cross_date"`

	// 当天比赛日期
	Date int `bson:"date" codec:"date"`
	// 当天比赛第几场
	Play int `bson:"play" codec:"play"`
	// 比赛选手 (只存当前场)
	RaceCards []*RaceCardInfo `bson:"race_cards" codec:"race_cards"`
	// 历史记录 {date: {play: [RaceCard]}
	History map[document.Integer]map[document.Integer][]*HorseRaceHistoryCardInfo `bson:"history" codec:"history"`

	// 比赛状态 演算结束后为closed
	Round string `bson:"round" codec:"round" default:"closed"`
	// yy status
	Status string `bson:"status" codec:"status" default:"closed"`
}

func (*HorseRaceGlobal) CollectionName() string {
	return "HorseRaceGlobal"
}

// 玩家数据
type HorseRaceRoleInfo struct {
	RoleID document.ID `bson:"role_id" codec:"role_id"`
	Name   string      `bson:"name" codec:"name"`
	Logo   int         `bson:"logo" codec:"logo"`
	Frame  int         `bson:"frame" codec:"frame"`
	Level  int         `bson:"level" codec:"level"`
	Figure int         `bson:"figure" codec:"figure"`
	Vip    int         `bson:"vip" codec:"vip"`

	AllPoint int `bson:"all_point" codec:"all_point"` // 总积分
}

// 比赛选手数据
type RaceCardInfo struct {
	// 选手ID csv_id
	CsvID int `bson:"csv_id" codec:"csv_id"`
	// 押注玩家的人数
	BetCount int `bson:"bet_count" codec:"bet_count"`
	// 比赛名次
	Result int `bson:"result" codec:"result"`
	// 冲刺的时间段
	SprintTimeSlots []int `bson:"sprint_time_slots" codec:"sprint_time_slots"`
	// 比赛花费时间
	Time float64 `bson:"time" codec:"time"`
}

// 历史回放数据
type HorseRaceHistoryCardInfo struct {
	// 选手ID csv_id
	CsvID int `bson:"csv_id" codec:"csv_id"`
	// 比赛名次
	Result int `bson:"result" codec:"result"`
	// 冲刺的时间段
	SprintTimeSlots []int `bson:"sprint_time_slots" codec:"sprint_time_slots"`
	// 比赛花费时间
	Time float64 `bson:"time" codec:"time"`
}

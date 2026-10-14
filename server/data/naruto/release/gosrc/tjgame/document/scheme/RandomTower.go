package scheme

import "tjgame/document"

// 试炼塔
type RandomTower struct {
	document.DocumentID `bson:",inline"`

	// Role.id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// 刷新日期
	LastDate float64 `bson:"last_date" codec:"last_date"`
	// 昨日房间csvID
	LastRoom int `bson:"last_room" codec:"last_room"`
	// 历史最高房间csvID
	HistoryRoom int `bson:"history_room" codec:"history_room"`
	// 当前房间csvID
	Room int `bson:"room" codec:"room"`
	// 卡面 {roomID: [boardID, ...]}
	Boards map[document.Integer][]int `bson:"boards" codec:"boards"`
	// 房间信息 {count: 宝箱打开次数, pass: 是否通过（1表示通过）, boardID: 已选中的卡面, enemy: 怪物,
	// monsterAttrSign: 怪物属性计算标志, event: 事件选项, buff: buff选项, nextRoomScope: 下一房间选择范围}
	RoomInfo Room `bson:"room_info" codec:"room_info"`
	// 卡牌血量怒气 {cardID: (hp, mp)}
	CardStates map[document.ID][2]float64 `bson:"card_states" codec:"card_states"`
	// 怪物血量怒气 {cardID: (hp, mp)}
	EnemyStates map[string][2]float64 `bson:"enemy_states" codec:"enemy_states"`
	// 已获得的buff [buffID ...]
	Buffs []int `bson:"buffs" codec:"buffs"`
	// 历史总积分
	HistoryPoint int `bson:"history_point" codec:"history_point"`
	// 当日积分
	DayPoint int `bson:"day_point" codec:"day_point"`
	// 当日排名
	DayRank int `bson:"day_rank" codec:"day_rank"`
	// 随机库
	BuffLib []int `bson:"buff_lib" codec:"buff_lib"`
	// buff 出现次数 {buffID: count}
	BuffTime map[document.Integer]int `bson:"buff_time" codec:"buff_time"`
	// event 出现次数 {eventID: count}
	EventTime map[document.Integer]int `bson:"event_time" codec:"event_time"`
	// 被动技能使用次数 {buffID: count}
	SkillUsed map[document.Integer]int `bson:"skill_used" codec:"skill_used"`
	// 积分奖励版本
	PointAwardVersion int `bson:"point_award_version" codec:"point_award_version"`
	// 积分奖励 {awardID: status（1表示可领 0表示已领）}
	PointAward map[document.Integer]int `bson:"point_award" codec:"point_award"`
	// 跳过房间信息 {boxes: {boardID: count}, buffs: [[boardID]], events: {boardID: flag}, buff_index: buff房间索引}
	JumpInfo JumpInfo `bson:"jump_info" codec:"jump_info"`
	// 跳过步骤 1:直通高层 2:宝箱 3:加成 4:事件
	JumpStep int `bson:"jump_step" codec:"jump_step"`

}

func (*RandomTower) CollectionName() string {
	return "RandomTower"
}

type Room struct {
	// 宝箱打开的次数
	Count  int           `codec:"count,omitempty" bson:"count,omitempty"`
	// 是否通关
	Pass   int           `codec:"pass,omitempty" bson:"pass,omitempty"`
	// 已选择的卡面
	BoardID int 		 `codec:"board_id,omitempty" bson:"board_id,omitempty"`
	// 怪物选项 {boardID: enemy}
	Enemy map[document.Integer]EnemyInfo   `codec:"enemy,omitempty" bson:"enemy,omitempty"`
	// 随机事件 {boardID: csvID}
	Event map[document.Integer]int   `codec:"event,omitempty" bson:"event,omitempty"`
	// 随机buff {boardID: csvID}
	Buff map[document.Integer]int   `codec:"buff,omitempty" bson:"buff,omitempty"`
	// 随机范围index（low, high）
	NextRoomScope [2]float64   `codec:"next_room_scope" bson:"next_room_scope"`
}

type EnemyInfo struct {
	// cavID 给客户端用
	ID  int              `codec:"id,omitempty" bson:"id,omitempty"`
	// 怪物选项的基础战力
	FightingPoint   int  `codec:"fighting_point,omitempty" bson:"fighting_point,omitempty"`
	// 技能等级
	SkillLevel int 		 `codec:"skill_level,omitempty" bson:"skill_level,omitempty"`
	// 怪物
	Monsters  []Monster  `codec:"monsters,omitempty" bson:"monsters,omitempty"`
}

type Monster struct {
	// 怪物ID（模拟）
	ID  int   `codec:"id,omitempty" bson:"id,omitempty"`
	// 怪物的进阶
	Advance int     `codec:"advance,omitempty" bson:"advance,omitempty"`
	// 怪物的星级
	Star int  	`codec:"star,omitempty" bson:"star,omitempty"`
	// 怪物的等级
	Level int 		 `codec:"level,omitempty" bson:"level,omitempty"`
	// 怪物的技能
	Skills map[document.Integer]int    `codec:"skills,omitempty" bson:"skills,omitempty"`
	// 怪物的UnitID
	UnitID int    `codec:"unit_id,omitempty" bson:"unit_id,omitempty"`
	// 怪物的卡牌ID
	CardID int    `codec:"card_id,omitempty" bson:"card_id,omitempty"`
	// 怪物属性
	Attrs  map[string]float64    `codec:"attrs,omitempty" bson:"attrs,omitempty"`
	// 怪物实际战力
	FightingPoint int    `codec:"fighting_point,omitempty" bson:"fighting_point,omitempty"`
}

type JumpInfo struct {
	// 宝箱打开的次数 {boardID: count}
	Boxes  map[document.Integer]int            `codec:"boxes,omitempty" bson:"boxes,omitempty"`
	// buffs [{boardID: buffID}]
	Buffs   []map[document.Integer]int            `codec:"buffs,omitempty" bson:"buffs,omitempty"`
	// 事件 {boardID: (eventID, flag)}
	Events map[document.Integer][2]int 		 `codec:"events,omitempty" bson:"events,omitempty"`
	// buff房间索引
	BuffIndex   int           `codec:"buff_index,omitempty" bson:"buff_index,omitempty" default:"1"`
}
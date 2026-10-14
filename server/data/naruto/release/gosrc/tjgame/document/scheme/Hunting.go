package scheme

import "tjgame/document"

// 远征全局
type HuntingGlobal struct {
	document.DocumentID `bson:",inline"`

	// cross_key
	Key string `bson:"key" codec:"key" unique:"true"`

	// 阵容库 {csvID: [BattleCardInfo]}
	BattleCards map[document.Integer][]*BattleCardInfo `bson:"battle_cards" codec:"battle_cards"`
	// 生成阵容 最新日期
	LastDate int `bson:"last_date" codec:"last_date"`
}

type BattleCardInfo struct {
	// ArenaHuntingRecord.id
	RecordID document.ID `bson:"record_id" codec:"record_id" index:"true"`
	// 玩家id
	RoleDbID document.ID `bson:"role_db_id" codec:"role_db_id"`
	// 区服
	GameKey string `bson:"game_key" codec:"game_key"`
}

func (*HuntingGlobal) CollectionName() string {
	return "HuntingGlobal"
}

// 远征记录
type HuntingRecord struct {
	document.DocumentID `bson:",inline"`

	// 玩家id
	RoleDbID document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// 区服
	GameKey string `bson:"game_key" codec:"game_key"`

	// 普通挑战次数
	BattleTimes int `bson:"battle_times" codec:"battle_times"`
	// 精英挑战次数
	SpecialBattleTimes int `bson:"special_battle_times" codec:"special_battle_times"`

	// 线路的信息 {1 or 2: HuntingRouteInfo}
	HuntingRoute map[document.Integer]*HuntingRouteInfo `bson:"hunting_route" codec:"hunting_route"`
}

// 线路的信息
type HuntingRouteInfo struct {

	// 5点 刷新日期
	LastDate int `bson:"last_date" codec:"last_date"`

	// 线路状态 starting、closed
	Status string `bson:"status" codec:"status" default:"closed"`
	// 当前节点csvID
	Node int `bson:"node" codec:"node"`
	// 已获得的buff [buffID ...]
	Buffs []int `bson:"buffs" codec:"buffs"`

	// 卡牌血量怒气 {cardID: (hp, mp)}
	CardStates map[document.ID][2]float64 `bson:"card_states" codec:"card_states"`
	// 对手血量怒气 {cardID: (hp, mp)}
	EnemyStates map[document.ID][2]float64 `bson:"enemy_states,omitempty" codec:"enemy_states,omitempty"`

	// 宝箱打开次数
	BoxOpenCount int `bson:"box_open_count,omitempty" codec:"box_open_count,omitempty"`
	// 多选关卡 已选中 (1=宝箱;2=补给;100101=战斗)
	BoardID int `codec:"board_id,omitempty" bson:"board_id,omitempty"`
	// 战斗关匹配后的对手
	BattleRoleKey *BattleCardInfo `codec:"battle_role_key,omitempty" bson:"battle_role_key,omitempty"`
	// 战斗关结束随机的关卡，供三选一
	BoardBuffs []int `bson:"board_buffs,omitempty" codec:"board_buffs,omitempty"`

	// 进攻卡牌列表
	Cards []document.ID `bson:"cards" codec:"cards"`

	// 上次最大节点
	LastMaxNode int `bson:"last_max_node" codec:"last_max_node"`
	// 历史最大节点
	HistoryMaxNode int `bson:"history_max_node" codec:"history_max_node"`

	// 当前线路版本
	Version int `bson:"version" codec:"version"`
}

func (*HuntingRecord) CollectionName() string {
	return "HuntingRecord"
}

type HuntingDefenceRoleInfo struct {
	*ArenaHuntingRecord
	GameKey string `codec:"game_key"`
	Name    string `codec:"name"`
	Logo    int    `codec:"logo"`
	Frame   int    `codec:"frame"`
	Level   int    `codec:"level"`
	Figure  int    `codec:"figure"`
	Vip     int    `codec:"vip"`
}

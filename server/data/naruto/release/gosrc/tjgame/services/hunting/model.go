package hunting

import (
	"sync"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/util"
)

type Config struct {
	HuntingRouteMin   map[int]map[int]int          // {route: min}
	HuntingRouteMax   map[int]map[int]int          // {route: max}
	HuntingBuffRandom map[int][]util.WeightElement // {type: [Weight]}
}

type RespBattleInfo struct {
	// 自己的record
	Record *scheme.HuntingRecordObject `codec:"record"`
	// 对手的信息
	DefenceRoleInfo *DefenceRoleInfo `codec:"defence_role_info"`
}

type DefenceRoleInfo struct {
	RoleDbID         document.ID                `codec:"role_db_id"`
	DefenceCards     []document.ID              `codec:"defence_cards"`
	DefenceCardAttrs map[document.ID]*CardModel `codec:"defence_card_attrs"`

	GameKey string `codec:"game_key"`
	Name    string `codec:"name"`
	Logo    int    `codec:"logo"`
	Frame   int    `codec:"frame"`
	Level   int    `codec:"level"`
	Figure  int    `codec:"figure"`
	Vip     int    `codec:"vip"`
}

type CardModel struct {
	CardId         int `codec:"card_id"`
	Level          int `codec:"level"`
	FightingPoint  int `codec:"fighting_point"`
	Star           int `codec:"star"`
	Advance        int `codec:"advance"`
	FightingPoint2 int `codec:"fighting_point2"`
}

type RespBattleStart struct {
	// 自己的record
	Record *scheme.HuntingRecordObject `codec:"record"`
	// 战斗信息
	BattleModel *BattleModel `codec:"battle_model"`
}

type ReqHuntingBattleEnd struct {
	RecordID    document.ID                `codec:"record_id"`
	CrossKey    string                     `codec:"cross_key"`
	Result      string                     `codec:"result"`
	Route       int                        `codec:"route"`
	GateID      int                        `codec:"gate_id"`
	CardIDs     []document.ID              `codec:"card_ids"`
	CardStates  map[document.ID][2]float64 `codec:"card_states"`
	EnemyStates map[document.ID][2]float64 `codec:"enemy_states"`

	Damage    float64                                    `codec:"damage"`
	MaxDamage float64                                    `codec:"max_damage"`
	Actions   map[document.Integer][]scheme.BattleAction `codec:"actions"`
}

type BattleModel struct {
	ID       document.ID `codec:"id"`
	RandSeed int         `codec:"rand_seed"`
	Level    int         `codec:"level"`
	GateID   int         `codec:"gate_id"`
	Route    int         `codec:"route"`

	Cards         []document.ID                           `codec:"cards"`
	CardAttrs     map[document.ID]*scheme.CardBattleModel `codec:"card_attrs"`
	CardAttrs2    map[document.ID]*scheme.CardBattleModel `codec:"card_attrs2"`
	PassiveSkills map[document.Integer]int                `codec:"passive_skills"`

	DefenceCards         []document.ID                           `codec:"defence_cards"`
	DefenceCardAttrs     map[document.ID]*scheme.CardBattleModel `codec:"defence_card_attrs"`
	DefenceCardAttrs2    map[document.ID]*scheme.CardBattleModel `codec:"defence_card_attrs2"`
	DefencePassiveSkills map[document.Integer]int                `codec:"defence_passive_skills"`

	Actions map[document.Integer][]scheme.BattleAction `codec:"actions,omitempty"`
}

type RespRecord struct {
	// 自己的record
	Record *scheme.HuntingRecordObject `codec:"record"`
	// 是否通关
	IsPass bool `codec:"is_pass"`
}

type battleInfo struct {
	roleID   document.ID
	recordID document.ID
	battleID document.ID

	mu          sync.Mutex
	result      string // 客户端结果
	agentResult string // 反作弊结果

	model       *BattleModel
	agentFinish chan int
}

func (b *battleInfo) onAgentFinish() {
	select {
	case b.agentFinish <- 1:
	default:
	}
}

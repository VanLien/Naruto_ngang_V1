package hunting

import (
	"tjgame/document"
)

type Config struct {
	BCRanges Ranges
}

type BattleCard struct {
	// ArenaHuntingRecord.id
	RecordID document.ID `bson:"record_id" codec:"record_id" index:"true"`
	// 玩家id
	RoleDbID document.ID `bson:"role_db_id" codec:"role_db_id"`
	// 区服
	GameKey string `bson:"game_key" codec:"game_key"`
	// 防守战力和
	FightingPoint int `bson:"fighting_point" codec:"fighting_point"`
}

type BattleCardRole struct {
	// 区间ID
	CsvID int `bson:"csv_id" codec:"csv_id"`
	// 玩家
	Name string `bson:"name" codec:"name"`
	// 区服
	GameKey string `bson:"game_key" codec:"game_key"`
	// 防守战力和
	FightingPoint int `bson:"fighting_point" codec:"fighting_point"`
	// 防守战力和修正前
	BeforeFightingPoint int `bson:"before_fighting_point" codec:"before_fighting_point"`
	// 防守卡牌csvID
	DefenceCards []int `bson:"defence_cards" codec:"defence_cards"`
}

type battleCardsChan struct {
	BattleCards []*BattleCard
	GameKey     string
	genFinish   chan int
}

func (b *battleCardsChan) onGenFinish() {
	select {
	case b.genFinish <- 1:
	default:
	}
}

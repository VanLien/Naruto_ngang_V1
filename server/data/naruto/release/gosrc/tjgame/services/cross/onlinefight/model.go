package onlinefight

import (
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/services/cross/onlinefight/proto"
)

type SyncRoleModel struct {
	UnlimitedRank     int `codec:"unlimited_rank"`
	UnlimitedScore    int `codec:"unlimited_score"`
	UnlimitedTopScore int `codec:"unlimited_top_score"`
	LimitedRank       int `codec:"limited_rank"`
	LimitedScore      int `codec:"limited_score"`
	LimitedTopScore   int `codec:"limited_top_score"`

	MatchResult *MatchResult `codec:"match_result,omitempty"`
}

type newBattle struct {
	Role        *scheme.CrossOnlineFightRole `codec:"role"`
	MatchResult *MatchResult                 `codec:"match_result"`
}

type battleResult struct {
	roleKey     scheme.RoleKey
	RoleID      document.ID `codec:"role_id"`
	Pattern     int         `codec:"pattern"`
	Result      string      `codec:"result"`
	EnemyResult string      `codec:"enemy_result"`
	Delta       int         `codec:"delta"`
	TopMove     bool        `codec:"top_move"` // 历史新高

	*SyncRoleModel
}

type EventToGame struct {
	NewBattles    []newBattle     `codec:"new_battles,omitempty"`
	Discards      []document.ID   `codec:"discards,omitempty"`
	BattleResults []*battleResult `codec:"battle_results,omitempty"`
	CsvIds        []int           `codec:"csv_ids,omitempty"`
	// 排行称号
	RankTitles map[int]map[document.ID]int `codec:"rank_titles,omitempty"`
	// 赛季奖励 {role.id: rank}
	FinalAwardRanks map[document.ID]int `codec:"final_award_ranks,omitempty"`
	// 周奖励 {role.id: [score, times]}
	WeeklyAwardRanks map[document.ID][2]int `codec:"weekly_award_ranks,omitempty"`
	// 无限制赛最终排名
	UnlimitedRanks []scheme.CrossOnlineFightRankRole `codec:"unlimited_ranks,omitempty"`
	// 公平赛最终排名
	LimitedRanks []scheme.CrossOnlineFightRankRole `codec:"limited_ranks,omitempty"`
	// init同步数据
	Model *SyncGameModel `codec:"model,omitempty"`
}

type SyncGameModel struct {
	Round     string   `codec:"round"`
	ThemeID   int      `codec:"theme_id"`
	StartDate int      `codec:"start_date"`
	EndDate   int      `codec:"end_date"`
	Version   int      `codec:"version"`
	Servers   []string `codec:"servers"`

	UnlimitedTopBattleHistory []scheme.CrossOnlineFightTopBattleHistory `codec:"unlimited_top_battle_history"`
	LimitedTopBattleHistory   []scheme.CrossOnlineFightTopBattleHistory `codec:"limited_top_battle_history"`
}

type MatchResult struct {
	Matching int64             `codec:"matching"` // 开始匹配的时间戳
	Enemy    *proto.Competitor `codec:"enemy,momitempty"`
	Address  string            `codec:"address,omitempty"`
}

type view struct {
	Ranks []scheme.CrossOnlineFightRankRole `codec:"ranks,omitempty"` // 排行榜
}

type Model struct {
	*SyncRoleModel
	*SyncGameModel
}

type Response struct {
	Model *Model `codec:"model,omitempty"`
	View  *view  `codec:"view,omitempty"`
}

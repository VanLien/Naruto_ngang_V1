package arena

import (
	"sync"
	"tjgame/document"
	"tjgame/document/scheme"
)

type viefor struct {
	role        document.ID
	record      document.ID
	enemy       document.ID
	enemyRecord document.ID
	time        int64
}

// 战斗信息
type battle struct {
	playRecordID  document.ID
	enemyRoleID   document.ID
	enemyRecordID document.ID
	battleRank    int

	mu     sync.Mutex
	result result
}

// 战斗结果
type result struct {
	client    string
	anticheat string
	view      map[string]int
}

// 主界面model
type ModelResponse struct {
	_struct struct{} `codec:",toarray"`
	// 对手
	Enemys []scheme.CrossArenaRoleInfo `codec:"enemys"`
	// 自身
	Role scheme.CrossArenaRoleInfo `codec:"role"`
	// 是否添加
	Flag bool `codec:"flag"`
}

// init同步game数据
type DBForGame struct {
	Servers []string `codec:"servers"`
	CsvId   int      `codec:"csv_id"`
	Date    int      `codec:"date"`
	Round   string   `codec:"round"`
}

// event同步 cross => game（需求部分数据）
type EventToGame struct {
	// 最小开服天数
	OpenDay int `codec:"open_day,omitempty"`
	// 生成机器人排名
	RobotRanks []int `codec:"robot_ranks,omitempty"`

	// 上期排行数据
	LastRanks []*scheme.CrossArenaRoleInfo `codec:"last_ranks,omitempty"`
	// 赛季奖励排名
	RoleRanks map[document.ID]int `codec:"role_ranks,omitempty"`
	// 精彩战报
	TopBattleHistory []scheme.CrossArenaTopBattleHistory `codec:"top_battle_history,omitempty"`
	// init同步数据
	Model *DBForGame `codec:"model,omitempty"`
}

// event同步 cross => game（同步全部数据）
type SyncModel struct {
	Round string `codec:"round"`
}

// 排行榜（ranks、roleInfo)
type RankResponse struct {
	Ranks  []scheme.CrossArenaRoleInfo `codec:"ranks"`
	MyInfo scheme.CrossArenaRoleInfo   `codec:"myinfo"`
}

// 开始战斗传参
type BattleParamResponse struct {
	MyRank        int         `codec:"my_rank"`
	BattleRank    int         `codec:"battle_rank"`
	EnemyRoleID   document.ID `codec:"enemy_role_id"`
	EnemyRecordID document.ID `codec:"enemy_record_id"`
}

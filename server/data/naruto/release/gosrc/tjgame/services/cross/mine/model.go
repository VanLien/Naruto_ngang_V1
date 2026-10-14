// @Time     : 2020/12/8 11:05
// @Author   : cancan
// @File     : model.go
// @Function : 

package mine

import (
	"fmt"
	"sync"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/util"
)

type Config struct {
	RobPct                      float64   // 每次抢夺百分比
	RobHourTimes                int       // 每小时抢夺次数
	RobFight                    []float64 // 抢夺无效战力差百分比
	RobFightPct                 []float64 // 战力差值过大时的抢夺百分比
	BeRodDayLimit               int       // 玩家每日被抢夺上限次数
	BeRevengedByCommonRoleLimit int       // 玩家每日被同一玩家复仇上限次数

	ServerBuffFeedLevelLimit []int       // 每日的加成等级上限
	ServerBuffLevelExp       map[int]int // 全服 buff 等级对应的经验之和
	ServerBuffLevelMax       int         // 全服 buff 最大等级
	RoleBuffFeedLevelLimit   int         // 个人加成总等级上限
	RoleBuffLevelExp         map[int]int // 个人 buff 等级对应的经验之和
	RoleBuffLevelMax         int         // 角色 buff 最大等级

	TopBattleHistoryPeriods []int            // 精彩战报刷新阶段
	TopBattleRank           int              // 精彩战斗读取最低排名
	MatchRanges             Ranges           // 匹配区间
	ProductCfgIDSortMap     map[int][][2]int // 生产资源配置 ID 排序表 {version: [[csvID, rankMax]...]}
	ServerPointRank         int              // 各服务器记录前几名积分

	BossHpFix                  map[int]float64  // Boss 血量修正
	BossHpFixMaxServerOpenDays int              // Boss 血量修正最大开服天数
	BossMaxDamageMultiple      int              // Boss 挑战最大伤害倍数
	BossAgentCheckDamgeFix     float64          // Boss 挑反作弊伤害校验修正百分比
	BossBattleMaxTime          int              // boss 挑战最大时间
	BossRankAwardCfgIDSortMap  map[int][][2]int // boss 排名奖励

	RandEventLibs map[int]*util.WeightRandom // 事件库 {所属库ID：随机库}

	DisablenBattleProtectBeforeOver float64 // 结束前几分钟取消战斗五分钟保护
}

type BuildingRandomKey struct {
	Start int
	End   int
}

// 同步game数据
type DBForGame struct {
	Servers     []string               `codec:"servers"`
	CsvId       int                    `codec:"csv_id"`
	Date        int                    `codec:"date"`
	Round       string                 `codec:"round"`
	BossTimeMap map[document.ID][2]int `codec:"bossTimeMap,omitempty"`
}

type RespGetCrossMineModel struct {
	// 自身
	Role scheme.CrossMineRoleInfo `codec:"role"`
	// 对手
	Enemies []scheme.CrossMineRoleInfo `codec:"enemies"`
	// 前十名
	Top10 []scheme.CrossMineRoleInfo `codec:"top10"`
	// 服务器积分
	ServerPoints map[string]int `codec:"serverPoints"`
	// boss
	Boss map[document.ID]RespCrossMineBoss `codec:"boss"`
	// 击杀的 boss
	KillBoss map[document.ID]scheme.CrossMineServerKillBoss `codec:"killBoss"`
	// 精彩战closed报
	TopBattleHistory []scheme.CrossMineTopBattleHistory `codec:"topBattleHistory"`
	// npc
	Npc map[document.ID]scheme.CrossMineNpc `codec:"npc"`
	// 全服 buff 信息
	ServerBuffInfo scheme.CrossMineServerBuffInfo `codec:"serverBuffInfo"`
	// 角色 buff 信息
	RoleBuffInfo scheme.CrossMineRoleBuffInfo `codec:"roleBuffInfo"`
	// 是否新增
	IsNew bool `codec:"isNew"`
}

type RespCrossMineBoss struct {
	scheme.CrossMineBoss
	Rank     *RespGetCrossMineBossRanks `codec:"rank"`
	KillRole *RespCrossMineBossKillRole `codec:"kill_role"`
}
type RespCrossMineBossKillRole struct {
	Name    string `codec:"name"`
	GameKey string `codec:"game_key"`
}

type RespGetCrossMineRanks struct {
	Ranks  []scheme.CrossMineRoleInfo `codec:"ranks"`
	MyInfo scheme.CrossMineRoleInfo   `codec:"myInfo"`
}

type CrossMineBossRankRoleItem struct {
	scheme.CrossMineRole

	Rank   int `codec:"rank"`
	Damage int `codec:"damage"`
}

type RespGetCrossMineBossRanks struct {
	Ranks  []CrossMineBossRankRoleItem `codec:"ranks"`
	MyInfo CrossMineBossRankRoleItem   `codec:"myInfo"`
}

type RespCrossMineBattleEnd struct {
	EnemyRoleID document.ID    `codec:"enemyRoleID"`
	View        map[string]int `codec:"view"`
}

type RespCrossMineGetRoleInfo struct {
	Rank           int                                                 `codec:"rank"`
	Speed          float64                                             `codec:"speed"`
	Coin13Origin   int                                                 `codec:"coin13_origin"`
	Coin13Diff     float64                                             `codec:"coin13_diff"`
	RoleBeRoded    *scheme.CrossMineRoleBeRodedInfo                    `codec:"role_be_roded"`
	RoleBeRevenged map[document.ID]*scheme.CrossMineRoleBeRevengedInfo `codec:"role_be_revenged"`
	CanRobNum      int                                                 `codec:"canRobNum"`
	KillBoss       map[document.ID]scheme.CrossMineServerKillBoss      `codec:"killBoss"`
}

type RespCrossMineBossBattleeEnd struct {
	BossID document.ID `codec:"bossID"`
	CsvID  int         `codec:"csvID"`
	Score  int         `codec:"score"`
	IsKill bool        `codec:"isKill"`
}

type vsInfoItem struct {
	roleID        document.ID
	recordID      document.ID
	enemyRoleID   document.ID
	enemyRecordID document.ID
	time          float64
}

// 战斗信息
type battle struct {
	Flag          string
	playRecordID  document.ID
	enemyRoleID   document.ID
	enemyRecordID document.ID
	enemyRank     int
	mu            sync.Mutex
	result        string
	stats         map[document.Integer]string
	view          map[string]int
}

// boss 战斗信息
type bossBattle struct {
	battleID  document.ID
	bossID    document.ID
	RoleID    document.ID
	MaxDamage int
	startTime float64
	mu        sync.Mutex
	result    string
	view      map[string]int

	model        *CrossMineBossBattleModel
	clientDamage map[document.Integer]int
	agentDamage  map[document.Integer]int
	agentFinish  chan int
}

func (b *bossBattle) onAgentFinish() {
	select {
	case b.agentFinish <- 1:
	default:
	}
}

// event 事件
type EventToGame struct {
	// 最小开服天数
	OpenDay int `codec:"open_day,omitempty"`

	// 最后的排行数据
	LastRanks []*scheme.CrossMineRoleInfo `codec:"last_ranks,omitempty"`
	// 最后的区服积分
	LastServerPoints map[string]int `codec:"last_server_points,omitempty"`
	// 角色资源缓存
	Roles map[document.ID]int `codec:"roles,omitempty"`
	// 赛季奖励排名
	RoleRanks map[document.ID]int `codec:"role_ranks,omitempty"`
	// 精彩战报
	TopBattleHistory []scheme.CrossMineTopBattleHistory `codec:"top_battle_history,omitempty"`
	// Boss 战斗角色排名
	BossRoleRanks map[document.ID]int `codec:"boss_role_ranks,omitempty"`
	// Boss 奖励版本
	BossAwardVersion int `codec:"boss_award_version,omitempty"`
	// init同步数据
	Model *DBForGame `codec:"model,omitempty"`
	// boss 时间表
	BossTimeMap map[document.ID][2]int `codec:"bossTimeMap,omitempty"`
}

// event sync 数据
type SyncModel struct {
	Round           string  `codec:"round"`
	LastProductTime float64 `codec:"last_product_time"`
}

// Boss 上阵卡牌
type BossBattleCardInfo struct {
	Cards         []document.ID                           `codec:"cards"`
	CardAttrs     map[document.ID]*scheme.CardBattleModel `codec:"card_attrs"`
	CardAttrs2    map[document.ID]*scheme.CardBattleModel `codec:"card_attrs2"`
	PassiveSkills map[document.Integer]int                `codec:"passive_skills"`
}

// Boss 排名
type BossRankItem struct {
	RoleID document.ID
	Damage int
	Rank   int
}

// boss 战斗 model
type CrossMineBossBattleModel struct {
	ID            document.ID                                `codec:"id"`
	GateID        int                                        `codec:"gate_id"`
	RandSeed      int32                                      `codec:"rand_seed"`
	Cards         []document.ID                              `codec:"cards"`
	CardAttrs     map[document.ID]*scheme.CardBattleModel    `codec:"card_attrs"`
	CardAttrs2    map[document.ID]*scheme.CardBattleModel    `codec:"card_attrs2"`
	PassiveSkills map[document.Integer]int                   `codec:"passive_skills"`
	HP            map[document.Integer]int                   `codec:"hp"`
	HPMax         map[document.Integer]int                   `codec:"hpMax"`
	Level         int                                        `codec:"level"`
	Actions       map[document.Integer][]scheme.BattleAction `codec:"actions"`
}

type rankItem struct {
	id    document.ID
	items map[string]int
}

type rankSort struct {
	items []rankItem
	keys  [][]string
}

func (r *rankSort) Len() int {
	return len(r.items)
}

func (r *rankSort) Less(i, j int) bool {
	for _, keyItem := range r.keys {
		key := keyItem[0]
		if r.items[i].items[key] == r.items[j].items[key] {
			continue
		}
		keyType := keyItem[1]
		switch keyType {
		case "desc":
			return r.items[i].items[key] > r.items[j].items[key]
		case "asc":
			return r.items[i].items[key] < r.items[j].items[key]
		default:
			panic(fmt.Sprintf("keyType %s error", keyType))
		}
	}
	return true
}

func (r *rankSort) Swap(i, j int) {
	r.items[i], r.items[j] = r.items[j], r.items[i]
}

type bossBattleVerifyInfo struct {
	queue chan bossBattle
	over  chan int
}

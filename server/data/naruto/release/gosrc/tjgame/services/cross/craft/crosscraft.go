package craft

import (
	"errors"
	"fmt"
	"math"
	"math/rand"
	"reflect"
	"sort"
	"strings"
	"sync"
	"sync/atomic"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/document/schemeutil"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	tjutil "tjgame/server_framework/tj/util"
	anti_cheat "tjgame/services/anti-cheat"
	"tjgame/services/anti-cheat/manager"
	"tjgame/services/game"
)

const (
	LeastRoles        = 64
	FailOut           = 5
	RobotBattlePlayID = document.ID("robot-battle")
	ByeBattlePlayID   = document.ID("~bye-battle~")
)

type Config struct {
	BetRateFixGold   float64
	MinBetRateGold   float64
	MaxBetWinGold    int
	BetRateFixCoin   float64
	MinBetRateCoin   float64
	MaxBetWinCoin    int
	DamageScoreRatio float64
}

var config atomic.Value

func GetConfig() *Config {
	return config.Load().(*Config)
}

func LoadConfig() error {
	cfg := csv.GetConfig().Cross.Craft.Base[1]

	v := &Config{
		BetRateFixGold:   float64(cfg.BetRateFixGold),
		MinBetRateGold:   float64(cfg.MinBetRateGold),
		MaxBetWinGold:    cfg.MaxBetWinGold,
		BetRateFixCoin:   float64(cfg.BetRateFixCoin),
		MinBetRateCoin:   float64(cfg.MinBetRateCoin),
		MaxBetWinCoin:    cfg.MaxBetWinCoin,
		DamageScoreRatio: float64(cfg.DamageScoreRatio),
	}
	config.Store(v)
	return nil
}

var (
	TestInQuick = false

	signupTime    = tjutil.Time{Hour: 10, Minute: 0}  // 开始报名时间
	prepareTime   = tjutil.Time{Hour: 18, Minute: 50} // 战斗前准备
	signupTimeEN  = tjutil.Time{Hour: 13, Minute: 0}  // en开始报名时间
	prepareTimeEN = tjutil.Time{Hour: 21, Minute: 50} // en战斗前准备

	BattleQueryDuration      = time.Second * 2
	PrepareDuration          = time.Minute * 10
	BattlePreReadyDuration   = time.Minute * 3
	BattleFinalReadyDuration = time.Minute * 4
	BattleDuration           = time.Minute

	TestSignupDuration   = time.Second * 15
	TestPrePareDuration  = time.Second * 10
	TestReadyDuration    = time.Second * 3
	TestBattleDuration   = time.Second * 2
	TestHalftimeDuration = time.Second * 60
	TestHalftimeQuick    = false
)

type roundInfo struct {
	idx  int
	next string
}

var RoundNextMap = map[string]roundInfo{
	"signup":  {0, "prepare"},
	"prepare": {0, "pre11"},

	//  每轮持续4分钟，其中3分钟为比赛准备阶段倒计时，准备阶段倒计时剩1分钟时无法挑战阵容，还有1分钟为战斗阶段

	"pre11": {1, "pre12"},
	"pre12": {2, "pre13"},
	"pre13": {3, "pre14"},
	"pre14": {4, "pre21"},

	"pre21": {5, "pre22"},
	"pre22": {6, "pre23"},
	"pre23": {7, "pre24"},
	"pre24": {8, "halftime"},

	"halftime": {8, "prepare2"},
	"prepare2": {8, "pre31"},

	"pre31": {9, "pre32"},
	"pre32": {10, "pre33"},
	"pre33": {11, "pre34"},
	"pre34": {12, "top64"},

	"top64": {1, "top32"},
	"top32": {2, "top16"},
	"top16": {3, "final1"},

	"final1": {1, "final2"},
	"final2": {2, "final3"},
	"final3": {3, "over"},

	"over": {4, "closed"},
}

func isFirstDay(round string) bool {
	switch round {
	case "signup":
		fallthrough
	case "prepare":
		fallthrough
	case "pre11":
		fallthrough
	case "pre12":
		fallthrough
	case "pre13":
		fallthrough
	case "pre14":
		fallthrough
	case "pre21":
		fallthrough
	case "pre22":
		fallthrough
	case "pre23":
		fallthrough
	case "pre24":
		return true
	}
	return false
}

var Top8PlayKeyMap = map[[2]int]string{
	{1, 8}: "group-a1", // group stage
	{2, 7}: "group-b1", // group stage
	{3, 6}: "group-b2", // group stage
	{4, 5}: "group-a2", // group stage

	{18, 45}: "group-a3", // semifinal
	{27, 36}: "group-b3", // semifinal

	{-1845, -2736}: "third",    // 季军赛
	{1845, 2736}:   "champion", // 冠军赛
}

var Top8PlayKeyRound = [][][2]int{
	{{1, 8}, {2, 7}, {3, 6}, {4, 5}},
	{{27, 36}, {18, 45}},
	{{1845, 2736}, {-1845, -2736}},
}

type battleroles [2]document.ID

type cards struct {
	cards   []document.ID
	display map[string]int
}

type matchHistory struct {
	Round  string      `codec:"round"`
	VSID   document.ID `codec:"vsid"`
	PlayID document.ID `codec:"playid"`
	Result string      `codec:"result"`
	Point  int         `codec:"point"`
}

type BattleMessage struct {
	Round  string            `codec:"round"`
	Result string            `codec:"result"`
	Roles  [2]scheme.RoleKey `codec:"roles"`
	Names  [2]string         `codec:"names"`
	Points [2]int            `codec:"points"`
	Streak int               `codec:"streak"` // win方的连胜次数
}

type DBForGame struct {
	Servers   []string `codec:"servers"`
	CsvId     int      `codec:"csv_id"`
	Date      int      `codec:"date"`
	Buffs     []int    `codec:"buffs"`
	Round     string   `codec:"round"`
	PrepareOK bool     `codec:"prepare_ok"`
	// Top8 战斗结果
	Top8Plays map[string]map[string]*scheme.CrossCraftTop8Play `codec:"top8_plays"`
}

type BetResult struct {
	ID        document.ID `codec:"id"`         // 角色ID
	WinGold   int         `codec:"win_gold"`   // 押注成功金币
	WinCoin   int         `codec:"win_coin"`   // 押注成功代币
	WinCount  int         `codec:"win_count"`  // 押注成功次数
	FailGold  int         `codec:"fail_gold"`  // 押注失败返还金币
	FailCoin  int         `codec:"fail_coin"`  // 押注失败返还代币
	FailCount int         `codec:"fail_count"` // 押注失败次数
}

type EventToGame struct {
	BattleMessage *BattleMessage `codec:"battle_message,omitempty"`

	// 战斗结果数据 {role.id: (round, win, point)}
	CraftRoles map[document.ID][3]int `codec:"craft_roles,omitempty"`

	// 排行数据 {rank: role.id}
	CraftRanks []scheme.CrossCraftRoleInfo `codec:"craft_ranks,omitempty"`

	// 排行数据 {rank: roleInfo}
	CraftRankMap map[int]scheme.CrossCraftRoleInfo `codec:"craft_rank_map,omitempty"`

	// 预选赛积分排行数据
	PrePointRanks []scheme.PreRankRolePoint `codec:"pre_point_ranks,omitempty"`

	// 下注结果数据
	CraftBets map[document.ID]BetResult `codec:"craft_bets,omitempty"`

	// 竞猜数据缓存
	LastBetInfo *scheme.LastBetInfo `codec:"last_bet_info,omitempty"`

	// 机器人数量
	Robot int `codec:"robot,omitempty"`

	Model *DBForGame `codec:"model,omitempty"`
}

type SyncModel struct {
	Round string `codec:"round"`
	Time  int64  `codec:"time"`
	// Top8 战斗结果
	Top8Plays map[string]map[string]*scheme.CrossCraftTop8Play `codec:"top8_plays"`
}

func makeRandomBuffs() []int {
	need := 1
	if rand.Int31n(100) < 50 {
		need = 2
	}

	csvbuffs := csv.GetConfig().Cross.Craft.Buffs
	count := len(csvbuffs)
	buffs := make([]int, 0, count)
	for id := range csvbuffs {
		buffs = append(buffs, id)
	}
	rand.Shuffle(count, func(i, j int) {
		buffs[i], buffs[j] = buffs[j], buffs[i]
	})
	return buffs[:need]
}

type Craft struct {
	*scheme.CrossCraftGlobalObject
	builder   *Builder
	container service.IContainer
	key       string

	winRoleMap map[int][]document.ID

	playstatus int32                     // 0-continue, 1-make_play_end, 2-finished
	lockcard   int32                     // 0-unlocked, 1-locked
	prepareok  int32                     // 0-not ok, 1-ok
	playMap    sync.Map                  // {playID: [roleID1, roleID2]} map[document.ID]battleroles
	battleKeys map[battleroles][2]string // {battleroles: (teamKey, key)}

	// 对阵历史
	roleMatchHistory sync.Map // map[document.ID]*matchHistory
	// 匹配列表
	matchList map[document.ID]document.ID
	// 淘汰列表
	outList []document.ID
	// 淘汰的玩家
	outs sync.Map // {role.id: true}
	// 连胜次数
	winningstreak sync.Map // {role.id: count}

	ranks         []scheme.CrossCraftRoleInfo // 排行榜
	prePointRanks map[string][]preRankRole    // 预选赛单服积分排行榜
	// 角色胜负结果
	roleResults map[scheme.RoleKey][3]int // {Role.id: (win, fail, point)}

	// 下注总额
	betgoldsum int
	betcoinsum int

	// 玩家卡牌总战力 下注用
	roleCardFightPoint map[document.ID]int

	mgr *manager.AgentManager

	// 状态定时器
	timer *time.Timer
}

func (c *Craft) SetRound(v string) {
	c.CrossCraftGlobalObject.SetRound(v)
	c.SetTime(tjutil.Now().Unix())
}

func (c *Craft) getElapsedDuration() time.Duration {
	return time.Duration(tjutil.Now().Unix()-c.Time()) * time.Second
}

func (c *Craft) init(builder *Builder) {
	c.builder = builder
	c.key = c.Key()
	c.cleanCache()
}

func (c *Craft) reset() {
	c.clean()
	log.Infof("Cross Craft Reset %d %s", c.Date(), c.Round())
	c.SetDate(0)
	c.SetCraftRoles(map[document.ID]*scheme.CrossCraftRoleInfo{})
	c.SetBuffs([]int{})
	c.SetTop8Plays(map[string]map[string]*scheme.CrossCraftTop8Play{})
	c.SetRoundResults(map[string]map[string]*scheme.CrossCraftResultInfo{})
	c.SetPreBet(map[document.ID][]*scheme.CrossCraftBet{})
	c.SetTop4Bet(map[document.ID][]*scheme.CrossCraftBet{})
	c.SetChampionBet(map[document.ID]*scheme.CrossCraftChampionBet{})
	c.SetRoleServKeys(map[document.ID]string{})
	c.SetPrePointRanks(map[string][]scheme.PreRankRolePoint{})
}

// 玩法结束就进行clean，等下一次开始才进行reset
func (c *Craft) clean() {
	log.Infof("Cross Craft Clean %d %s", c.Date(), c.Round())
	c.SetRound("closed")

	c.cleanCache()
}

func (c *Craft) cleanCache() {
	atomic.StoreInt32(&c.playstatus, 0)
	atomic.StoreInt32(&c.lockcard, 0)
	atomic.StoreInt32(&c.prepareok, 0)
	c.playMap = sync.Map{}
	c.roleMatchHistory = sync.Map{}
	c.outs = sync.Map{}
	c.winningstreak = sync.Map{}
	c.ranks = []scheme.CrossCraftRoleInfo{}
	c.prePointRanks = make(map[string][]preRankRole)
	c.roleResults = make(map[scheme.RoleKey][3]int)
	c.roleCardFightPoint = make(map[document.ID]int)
	c.betgoldsum = 0
	c.betcoinsum = 0
	c.timer = nil
}

func (c *Craft) IsOver() bool {
	return c.isAllOver()
}

func (c *Craft) OnInit(id int, servers []string) {
	c.onInit(id, servers)
}

func (c *Craft) isAllOver() bool {
	// over 也认为结束，over状态重启只能手动处理了
	if c.Round() == "closed" || c.Round() == "over" {
		return true
	}
	date := c.Date()	
	if date == 0 {		
		return true
	}
	

	startdate := tjutil.Int2Date(date)
	nowdate := tjutil.Int2Date(tjutil.Todayinclock5date2int())
	duration := nowdate.Sub(startdate)
	return duration > tjutil.OneDay
}

func (c *Craft) ResetToday() {
	round := c.Round()
	date := c.Date()
	log.Infof("Craft.ResetToday date %d round %s", date, round)
	now := tjutil.Now()

	resetSecondDay := func() {
		round = "halftime"
		duration := prepareTime.CombineDateInt(date).Add(tjutil.OneDay).Sub(now)
		log.Infof("round %s next %s time delta %s", round, RoundNextMap[round].next, duration)
		c.SetRound(round)
		c.timer = time.AfterFunc(duration, c.onStartPrepare2)
	}

	ndt := tjutil.Todaydate2int()
	if date == ndt {
		// 第一天重启
		if round == "halftime" {
			// 第一天的战斗已结束
			resetSecondDay()
		} else {
			round = "signup"
			signup := signupTime.CombineDateInt(date)
			prepare := prepareTime.CombineDateInt(date)
			c.SetRound(round)
			if signup.Sub(now).Seconds() > 0 {
				c.onInit(c.CsvId(), c.Servers())
			} else if prepare.Sub(now).Seconds() > 0 {
				// onStartSignUp 里面同步执行 eventToGame, 存在game还在启动中的情况, 与当前服务器相互依赖,
				// 造成无法启动的情况, 所以在这里放到另一个 goroutine 里执行。
				go c.onStartSignUp()
			} else {
				c.onStartPrepare()
			}
		}
	} else {
		// 第二天重启
		if isFirstDay(round) {
			// 第一天战斗还未结束
			c.SetRound("signup")
			c.onStartPrepare() // no more time, start fight
		} else {
			resetSecondDay()
		}
	}
	_, unlock := c.LockAndGetDB()
	defer unlock()
	c.refreshRank()
}

func (c *Craft) SetAgentManager(name string, agent service.IService) {
	if c.mgr != nil {
		c.mgr.Stop()
		c.mgr = nil
	}
	c.mgr = manager.NewAgentManager(name, "NewCrossCraftBattle", agent)
}

func (c *Craft) dbForGame() *DBForGame {
	db := c.GetLockedDB()
	return &DBForGame{
		Servers:   db.Servers,
		CsvId:     db.CsvId,
		Date:      db.Date,
		Buffs:     db.Buffs,
		Round:     db.Round,
		PrepareOK: atomic.LoadInt32(&c.prepareok) == 1,
		Top8Plays: db.Top8Plays,
	}
}

func (c *Craft) isServerOK(key string) bool {
	db := c.GetLockedDB()
	if csv.GetMergeConfig().IsMergeKeyInServers(key, db.Servers) {
		return true
	}
	return false
}

func (c *Craft) addSignupRole(signup []scheme.CrossCraftRoleSignItem) {
	var wg sync.WaitGroup
	wg.Add(len(signup))

	infos := make(map[document.ID]*scheme.CrossCraftRoleInfo)
	roles := make(chan scheme.CrossCraftRoleSignItem, 64)
	go func() {
		for role := range roles {
			infos[role.ID] = &scheme.CrossCraftRoleInfo{
				CrossCraftRole: scheme.CrossCraftRole{
					RoleID:   role.ID,
					RecordID: role.RecordID,
					Name:     role.Name,
					GameKey:  role.GameKey,
					Logo:     role.Logo,
					Frame:    role.Frame,
					Level:    role.Level,
					Figure:   role.Figure,
					Title:    role.Title,
					Vip:      role.Vip,
				},
			}
			wg.Done()
		}
	}()

	for _, role := range signup {
		go func(r scheme.CrossCraftRoleSignItem) {
			s := c.container.GetService(service.Game2PVPService(r.GameKey))
			resp, err := service.Call(s, "CrossCraftRecordPrepare", r.RecordID, r.Manual)
			if err == nil && resp.(bool) == false {
				roles <- r
			} else {
				log.Warningf("role %v record %v broken %v error %v", r.ID, r.RecordID, resp, err)
				wg.Done()
			}
		}(role)
	}

	wg.Wait()
	close(roles)

	tjutil.WithGuard(c, func() {
		roles := c.CraftRoles()
		for roleID, info := range infos {
			roles[roleID] = info
		}
		c.SetCraftRoles(roles)
	})
}

func (c *Craft) updateRoleInfo(roleID document.ID, result string, point int) {
	roundMax := 4 + 4 + 4 + 3 + 3
	roles := c.CraftRoles()
	role := roles[roleID]
	role.Round += 1
	if role.Round > roundMax {
		role.Round = roundMax
	}
	role.Point += point
	if result == "win" {
		role.Win += 1
	}
	c.SetCraftRoles(roles)
}

func (c *Craft) updateRoleResult(key scheme.RoleKey, result string, point int) {
	win, fail, oldPoint := 0, 0, 0
	if v, ok := c.roleResults[key]; ok {
		win, fail, oldPoint = v[0], v[1], v[2]
	}
	oldPoint += point
	if result == "win" {
		win += 1
	} else {
		fail += 1
	}

	c.roleResults[key] = [3]int{win, fail, oldPoint}
}

func (c *Craft) checkAndSetRound(round string, expect string) (string, bool) {
	db, unlock := c.LockAndGetDB()
	defer unlock()
	if db.Round == expect {
		c.SetRound(round)
		return round, true
	}
	return db.Round, false
}

func (c *Craft) onInit(id int, servers []string) {
	log.Infof("Craft.onInit")

	var model *DBForGame
	round := "closed"
	buffs := makeRandomBuffs()
	tjutil.WithGuard(c, func() {
		c.reset()
		ndt := tjutil.Todaydate2int()
		c.SetDate(ndt)
		c.SetCsvId(id)
		c.SetServers(servers)
		c.SetBuffs(buffs)
		model = c.dbForGame()
	})
	log.Infof("Cross Craft Buffs %v", buffs)

	// event to game
	c.eventToGame("init", EventToGame{Model: model}, true, false)

	// 报名倒计时
	elapsed := c.getElapsedDuration()
	now := tjutil.Now()
	duration := signupTime.Combine(now).Sub(now) - elapsed
	if TestInQuick {
		duration = 5*time.Second - elapsed
	}
	log.Infof("round %s next signup time delta %s, elapsed %s", round, duration, elapsed)
	c.timer = time.AfterFunc(duration, c.onStartSignUp)
}

// 开始报名 closed -> signup
func (c *Craft) onStartSignUp() {
	log.Infof("Craft.onStartSignUp")
	round := "signup"
	tjutil.WithGuard(c, func() {
		c.SetRound(round)
	})

	c.eventToGame("signup", EventToGame{}, true, false)

	// 报名结束倒计时
	elapsed := c.getElapsedDuration()
	now := tjutil.Now()
	duration := prepareTime.Combine(now).Sub(now) - elapsed
	if TestInQuick {
		duration = TestSignupDuration - elapsed
	}
	log.Infof("round %s next %s time delta %s, elapsed %s", round, RoundNextMap[round].next, duration, elapsed)
	c.timer = time.AfterFunc(duration, c.onStartPrepare)
}

// 报名结束,开始准备参赛名单和匹配 signup -> prepare
func (c *Craft) onStartPrepare() {
	round, ok := c.checkAndSetRound("prepare", "signup")
	if !ok {
		log.Warningf("error round %s enter in onStartPrepare", round)
	}
	log.Infof("Craft.onStartPrepare %s", round)

	tjutil.WithGuard(c, func() {
		c.SetCraftRoles(map[document.ID]*scheme.CrossCraftRoleInfo{})
	})

	go func() {
		// 冻结报名, 强制与game同步报名列表
		response := c.eventToGame("prepare", EventToGame{}, true, false)
		if response == nil {
			log.Warningf("may be some error happened")
			return
		}
		totalSignupNum := 0
		for key, resp := range response {
			totalSignupNum += len(resp.Signup)
			c.addSignupRole(resp.Signup)
			log.Infof("%s signup %d in prepare, all signup %d, craft roles %d", key, len(resp.Signup), totalSignupNum, len(c.CraftRoles()))
		}
		atomic.StoreInt32(&c.prepareok, 1)
		c.eventToGame("prepare_ok", EventToGame{}, false, false)

		// 机器人加入
		robotnum := calcRobotNum(totalSignupNum)
		response = c.eventToGame("robot", EventToGame{Robot: robotnum / len(c.Servers())}, true, false)
		if response == nil {
			log.Warningf("may be some error happened")
			return
		}
		for key, resp := range response {
			c.addSignupRole(resp.Signup)
			log.Infof("%s robot %d in prepare, craft roles %d", key, len(resp.Signup), len(c.CraftRoles()))
		}

		// 倒计时
		elapsed := c.getElapsedDuration()
		duration := PrepareDuration - elapsed
		if TestInQuick {
			duration = TestPrePareDuration - elapsed
		}
		log.Infof("round %s next %s time delta %s, elapsed %s", round, RoundNextMap[round].next, duration, elapsed)
		c.timer = time.AfterFunc(duration, c.onStartRound)
		c.onMatch()
	}()
}

// 中场休息结束 halftime -> prepare2
func (c *Craft) onStartPrepare2() {
	round, ok := c.checkAndSetRound("prepare2", "halftime")
	if !ok {
		log.Warningf("error round %s enter in onStartPrepare2", round)
	}
	log.Infof("Craft.onStartPrepare2 %s", round)
	atomic.StoreInt32(&c.prepareok, 1)

	c.eventToGame("prepare2", EventToGame{}, true, false)

	// 倒计时
	elapsed := c.getElapsedDuration()
	duration := PrepareDuration - elapsed
	if TestInQuick {
		duration = TestPrePareDuration - elapsed
	}
	log.Infof("round %s next %s time delta %s, elapsed %s", round, RoundNextMap[round].next, duration, elapsed)
	c.timer = time.AfterFunc(duration, c.onStartRound)
	c.onMatch()
}

// 匹配
func (c *Craft) onMatch() {
	var round string
	tjutil.WithGuard(c, func() {
		round = RoundNextMap[c.Round()].next
	})

	if !isInBattle(round) {
		return
	}

	log.Infof("Craft.startMatch %s", round)

	// 未被淘汰名单
	players, playerFails := c.nextRoundPlayer(round)

	signList := make(map[document.ID]cards)
	for roleID, recordID := range players {
		// 重新获取cards上阵
		gameKey := c.CraftRoles()[roleID].GameKey
		svc := c.container.GetService(service.Game2PVPService(gameKey))
		if svc == nil || reflect.ValueOf(svc).IsNil() {
			log.Errorf("[CrossCraft] service not found for roleID=%v gameKey=%v", roleID, gameKey)
			continue // skip, tránh panic
		}
		record := GetRemoteCraftRecord(svc, recordID, 15*time.Second)
		if record == nil {
			log.Warningf("[CrossCraft] skip roleID=%v recordID=%v because record is nil.", roleID, recordID)
        	continue // skip vòng này, tránh crash
    	}
		signList[roleID] = cards{
			cards:   record.Cards,
			display: CrossCraftRecordTopDisplay(record),
		}
		if RoundNextMap[round].idx < 9 { // unti halftime
			// 更新玩家战力
			if _, ok := c.roleCardFightPoint[roleID]; !ok {
				c.roleCardFightPoint[roleID] = signList[roleID].display["fighting_point"]
			}
		}
	}

	// 修正signList，并且匹配
	signList, c.matchList, playerFails = c.nextRoundMatch(round, signList, playerFails)

	c.outList = []document.ID{}
	// 确定淘汰名单
	outs := 0
	for roleID, cnt := range playerFails {
		if cnt >= FailOut {
			c.outList = append(c.outList, roleID)
			outs++
		}
	}

	log.Infof("Craft.startRound %s Signup %d Roles %d Matches %d Outs %d", round, len(c.CraftRoles()), len(signList), len(c.matchList), outs)
}

// 开始一局准备, 计算参赛名单和匹配
func (c *Craft) onStartRound() {
	var round string
	tjutil.WithGuard(c, func() {
		round = RoundNextMap[c.Round()].next
		c.SetRound(round)
	})
	log.Infof("Craft.startRound %s", round)

	// 停止上次的查询定时器
	c.mgr.Stop()

	for _, outRoleID := range c.outList {
		c.outs.Store(outRoleID, true)
	}
	c.makeMatchHistory(round, c.matchList)

	c.eventToGame("matches", EventToGame{}, true, true)
	atomic.StoreInt32(&c.lockcard, 0)

	// 战斗开始始倒计时
	elapsed := c.getElapsedDuration()
	duration := BattlePreReadyDuration - elapsed
	if isInTopOrFinal(round) {
		duration = BattleFinalReadyDuration - elapsed
	}
	if TestInQuick {
		duration = TestReadyDuration
	}
	c.timer = time.AfterFunc(duration, c.onPlayStart)
}

// 构造Play数据, 通知服务器计算战斗
func (c *Craft) onPlayStart() {
	round := c.Round()
	c.initPlay()
	log.Infof("Craft.onPlayStart %s", round)

	s1 := tjutil.Now().Unix()
	// 冻结布阵
	c.eventToGame("play", EventToGame{}, true, false)
	atomic.StoreInt32(&c.lockcard, 1)
	elapsed := time.Duration(tjutil.Now().Unix()-s1) * time.Second

	// 战斗结束倒计时
	duration := BattleDuration - elapsed
	if TestInQuick {
		duration = TestBattleDuration - elapsed
	}
	c.timer = time.AfterFunc(duration, c.onPlayEnd)

	// 开始运算
	count := len(c.RoundResults()[round])
	log.Infof("Craft.onPlayStart %s Plays %d", round, count)
	if count > 0 {
		// 启动定时器，构建战斗
		c.mgr.Start()
		go func() {
			t := time.NewTimer(BattleQueryDuration)
			defer t.Stop()
			for {
				<-t.C
				if !c.isFirstMakeEnd() {
					log.Warningf("queryAgentMgr waiting first make end")
					t.Reset(BattleQueryDuration)
					continue
				}
				resume := true
				s1 := tjutil.Now()
				results := c.mgr.GetPlayResults()
				var wg sync.WaitGroup
				wg.Add(len(results))
				for _, result := range results {
					go func(r manager.Result) {
						c.onAgentResult(r)
						wg.Done()
					}(result)
				}
				wg.Wait()
				s2 := tjutil.Now()
				leftPlays := c.checkPlayEnd()
				if leftPlays == 0 {
					resume = false
				}
				now := tjutil.Now()
				log.Infof("queryAgentMgr result %d local %d timer %v, dlt1 %s dlt2 %s", len(results), leftPlays, resume, now.Sub(s1), now.Sub(s2))
				if resume {
					t.Reset(BattleQueryDuration)
				} else {
					break
				}
			}
		}()

		c.makePlayAndRun()
	}
}

func (c *Craft) makePlayAndRun() {
	round := c.Round()
	start := time.Now()

	type battleInfo struct {
		roleKey1 scheme.RoleKey
		record1  document.ID
		roleKey2 scheme.RoleKey
		record2  document.ID
	}

	newJob := func(roleKey1 scheme.RoleKey, recordID1 document.ID, roleKey2 scheme.RoleKey, recordID2 document.ID) func() {
		return func() {
			var v [2]*scheme.CrossCraftRecord
			v[0] = GetRemoteCraftRecord(c.container.GetService(service.Game2PVPService(roleKey1.GameKey)), recordID1, 15*time.Second)
			if roleKey2.ID != "" {
				v[1] = GetRemoteCraftRecord(c.container.GetService(service.Game2PVPService(roleKey2.GameKey)), recordID2, 15*time.Second)
				c.recordBack(round, roleKey1, v[0], roleKey2, v[1])
			} else { // 轮空
				c.recordBack(round, roleKey1, v[0], roleKey2, nil)
			}
		}
	}

	roundResults := c.RoundResults()[round]
	total := len(roundResults)
	battles := make([]battleInfo, 0, total)
	for _, roundResult := range roundResults {
		if roundResult.PlayID != "" { // 已经构建了战斗
			continue
		}
		role1 := c.CraftRoles()[roundResult.Roles[0]]
		battle := battleInfo{
			roleKey1: scheme.RoleKey{ID: role1.RoleID, GameKey: role1.GameKey},
			record1:  role1.RecordID,
		}
		if len(roundResult.Roles) == 2 {
			role2 := c.CraftRoles()[roundResult.Roles[1]]
			battle.roleKey2 = scheme.RoleKey{ID: role2.RoleID, GameKey: role2.GameKey}
			battle.record2 = role2.RecordID
		}
		battles = append(battles, battle)
	}
	count := len(battles)
	var wg sync.WaitGroup
	wg.Add(count)
	for _, battle := range battles {
		job := newJob(battle.roleKey1, battle.record1, battle.roleKey2, battle.record2)
		go func() {
			job()
			wg.Done()
		}()
	}
	wg.Wait()

	log.Infof("makePlayAndRun %d make %d play cost %v", total, count, time.Now().Sub(start))

	c.makePlayEnd()
}

func (c *Craft) recordBack(round string, roleKey1 scheme.RoleKey, record1 *scheme.CrossCraftRecord, roleKey2 scheme.RoleKey, record2 *scheme.CrossCraftRecord) {
	var display1, display2 map[string]int
	if isInFinal(round) {
		display1 = CrossCraftRecordTopDisplay(record1)
		display2 = CrossCraftRecordTopDisplay(record2)
	}
	if record2 == nil { // 轮空
		model := NewByePlayModel(round, roleKey1, record1)
		tjutil.WithGuard(c, func() {
			c.newPlay(ByeBattlePlayID, model, display1, display2)
			c.recordPlayResult(ByeBattlePlayID, "win", [2]int{model.Point, model.DefencePoint})
		})
		// Record 记录历史
		_, _ = service.Call(c.container.GetService(service.Game2PVPService(roleKey1.GameKey)), "CrossCraftAddHistory", record1.ID, model, c.key)
		c.pushPlayResultToGame(model)
	} else {
		roleID1, roleID2 := record1.RoleDbId, record2.RoleDbId
		model := NewPlayModel(round, roleKey1, record1, roleKey2, record2, c.Buffs())
		if isRobot(roleID1) && isRobot(roleID2) { // 机器人对机器人直接计算胜负
			result, points := CalcRobotPlayResult(model)
			tjutil.WithGuard(c, func() {
				c.newPlay(RobotBattlePlayID, model, display1, display2)
				c.recordPlayResult(RobotBattlePlayID, result, points)
			})
			model.ID = RobotBattlePlayID
			model.Result = result
			model.Point = points[0]
			model.DefencePoint = points[1]
			// Record 记录历史
			_, _ = service.Call(c.container.GetService(service.Game2PVPService(roleKey1.GameKey)), "CrossCraftAddHistory", record1.ID, model, c.key)
			_, _ = service.Call(c.container.GetService(service.Game2PVPService(roleKey2.GameKey)), "CrossCraftAddHistory", record2.ID, model, c.key)
			c.pushPlayResultToGame(model)
		} else {
			play := c.builder.CreateCrossCraftPlayRecord(model)
			tjutil.WithGuard(c, func() {
				c.newPlay(play.GetID(), model, display1, display2)
			})
			// 发送给反作弊计算
			db, unlock := play.RLockAndGetDB()
			defer unlock()
			c.mgr.SendPlay(play.GetID(), db)
		}
	}
}
func (c *Craft) checkPlayEnd() int {
	if atomic.LoadInt32(&c.playstatus) == 2 {
		return 0
	}
	leftPlay := 0
	c.playMap.Range(func(key, value interface{}) bool {
		leftPlay++
		return true
	})
	db, unlock := c.RLockAndGetDB()
	round := db.Round
	results := db.RoundResults[round]
	unlock()

	log.Infof("checkPlayEnd %s Plays %d", round, leftPlay)
	if leftPlay == 0 {
		// 检查是否真全部结束了
		for _, info := range results {
			if info.PlayID == "" {
				log.Warningf("checkPlayEnd %s invalid %v", round, info.Roles)
			} else if info.Result == "unknown" {
				c.playMap.Store(info.PlayID, battleroles{info.Roles[0], info.Roles[1]})
			}
		}

		// 本轮结束
		leftPlay := 0
		c.playMap.Range(func(key, value interface{}) bool {
			leftPlay++
			return true
		})
		if leftPlay == 0 {
			log.Infof("checkPlayEnd %s -> %s", round, RoundNextMap[round].next)
			c.onMatch()
			atomic.StoreInt32(&c.playstatus, 2)
			c.mgr.Stop()
		}
	}
	return leftPlay
}

func (c *Craft) onAgentResult(result manager.Result) {
	id := result.ID
	resend := false
	resetSeed := false
	if result.Error != nil {
		resend = true
	} else {
		ret := result.Result.(anti_cheat.CraftBattleResult)
		if ret.Result != "win" && ret.Result != "fail" {
			resend = true
			resetSeed = true
			log.Warningf("agent play %v result %s", id, ret.Result)
		} else {
			var recordID1, recordID2 document.ID
			var gameKey1, gameKey2 string
			tjutil.WithGuard(c, func() {
				rr := c.recordPlayResult(id, ret.Result, [2]int{ret.Point1, ret.Point2})
				roleID1, roleID2 := rr[0], rr[1]
				recordID1 = c.CraftRoles()[roleID1].RecordID
				gameKey1 = c.CraftRoles()[roleID1].GameKey
				recordID2 = c.CraftRoles()[roleID2].RecordID
				gameKey2 = c.CraftRoles()[roleID2].GameKey
			})
			playRecord := c.builder.GetCrossCraftPlayRecord(id)
			model, unlock := playRecord.LockAndGetDB()
			tjutil.WithDefer(func() {
				playRecord.SetResult(ret.Result)
				playRecord.SetPoint(ret.Point1)
				playRecord.SetDefencePoint(ret.Point2)
			}, unlock)
			_, _ = service.Call(c.container.GetService(service.Game2PVPService(gameKey1)), "CrossCraftAddHistory", recordID1, model, c.key)
			_, _ = service.Call(c.container.GetService(service.Game2PVPService(gameKey2)), "CrossCraftAddHistory", recordID2, model, c.key)
			c.pushPlayResultToGame(model)
		}
	}
	if resend {
		log.Warningf("resend play %v", id)
		playRecord := c.builder.GetCrossCraftPlayRecord(id)
		model, unlock := playRecord.LockAndGetDB()
		defer unlock()
		if resetSeed {
			playRecord.resetRandSeed()
		}
		c.mgr.SendPlay(id, model)
	}
}

func (c *Craft) onPlayEnd() {
	for atomic.LoadInt32(&c.playstatus) != 2 {
		time.Sleep(time.Second * 5)
	}
	// 停止查询定时器
	c.mgr.Stop()

	// 刷新排行榜
	db, unlock := c.LockAndGetDB()
	round := db.Round
	tjutil.WithDefer(func() {
		c.refreshRank()
		if isInPreRound(round) {
			c.onPrePointRank()
		}
	}, unlock)

	nextRound := RoundNextMap[round].next
	if nextRound == "over" {
		c.onOver()
	} else if nextRound == "halftime" {
		c.onHalftime()
	} else {
		if nextRound == "top64" {
			// 第一天预选下注奖励
			c.onPreBetAward()
		}
		c.onStartRound()
	}
}

func (c *Craft) onHalftime() {
	round := "halftime"
	date := 0
	tjutil.WithGuard(c, func() {
		c.SetRound(round)
		date = c.Date()
	})
	c.roleMatchHistory = sync.Map{}

	// 第一天战斗奖励
	d := make(map[string]*EventToGame)
	for key, info := range c.roleResults {
		if isRobot(key.ID) {
			continue
		}
		if _, ok := d[key.GameKey]; !ok {
			d[key.GameKey] = &EventToGame{
				CraftRoles: make(map[document.ID][3]int),
			}
		}
		d[key.GameKey].CraftRoles[key.ID] = info
	}
	c.eventToSomeGame("battle_award", d, true)
	c.roleResults = make(map[scheme.RoleKey][3]int)

	c.eventToGame("halftime", EventToGame{}, true, false)

	// 计算前64战斗力作为下注人选
	tjutil.WithGuard(c, c.makeTop4AndChampionBetRole)

	// 准备开始倒计时
	now := tjutil.Now()
	elapsed := c.getElapsedDuration()
	duration := prepareTime.CombineDateInt(date).Add(tjutil.OneDay).Sub(now)
	duration -= elapsed
	if TestHalftimeQuick {
		duration = TestHalftimeDuration - elapsed
	}
	log.Infof("round %s next %s time delta %s, elapsed %s", round, RoundNextMap[round].next, duration, elapsed)
	c.timer = time.AfterFunc(duration, c.onStartPrepare2)
}

func (c *Craft) onOver() {
	tjutil.WithGuard(c, func() {
		c.SetRound("over")
	})

	c.eventToGame("over", EventToGame{CraftRanks: c.ranks}, true, false)

	// 排行奖励
	rankAward := make(map[string]*EventToGame)
	for idx, info := range c.ranks {
		if isRobot(info.RoleID) {
			continue
		}
		if _, ok := rankAward[info.GameKey]; !ok {
			rankAward[info.GameKey] = &EventToGame{
				CraftRankMap: make(map[int]scheme.CrossCraftRoleInfo),
			}
		}
		rankAward[info.GameKey].CraftRankMap[idx+1] = info
	}
	c.eventToSomeGame("rank_award", rankAward, false)

	// 第二天战斗奖励
	d := make(map[string]*EventToGame)
	for key, info := range c.roleResults {
		if _, ok := d[key.GameKey]; !ok {
			d[key.GameKey] = &EventToGame{
				CraftRoles: make(map[document.ID][3]int),
			}
		}
		d[key.GameKey].CraftRoles[key.ID] = info
	}
	c.eventToSomeGame("battle_award", d, false)

	// 4强下注奖励
	champion := c.ranks[0].RoleID
	top4 := make(map[document.ID]bool)
	for _, role := range c.ranks[:4] {
		top4[role.RoleID] = true
	}
	c.onTop4BetAward(top4)
	// 冠军下注奖励
	c.onChampionBetAward(champion)

	// game保存竞猜数据
	c.onCacheBetInfo()

	// 保存预选赛积分排名
	cfg := csv.GetMergeConfig()
	d = make(map[string]*EventToGame)
	db, unlock := c.RLockAndGetDB()
	tjutil.WithDefer(func() {
		for key, ranks := range db.PrePointRanks {
			key = cfg.GetSrcServKeys(key)[0]
			d[key] = &EventToGame{
				PrePointRanks: ranks,
			}
		}
	}, unlock)
	c.eventToSomeGame("pre_point_rank", d, false)

	tjutil.WithGuard(c, c.clean)
}

// 获取每个服务器top3的积分
func (c *Craft) getServerTop3PointRoles() map[string]map[document.ID]int {
	db := c.GetLockedDB()
	roles := make(map[string]map[document.ID]int)
	for key, v := range db.PrePointRanks {
		roles[key] = make(map[document.ID]int)
		for _, vv := range v[:3] { // 前3名
			roles[key][vv.ID] = vv.Point
		}
	}
	return roles
}

func (c *Craft) onPrePointRank() {
	cfg := csv.GetMergeConfig()
	db := c.GetLockedDB()
	servroles := make(map[string]sortpoint) // 合服后的key
	for _, role := range db.CraftRoles {
		key := cfg.GetMergeServKey(role.GameKey)
		if _, ok := servroles[key]; !ok {
			servroles[key] = make(sortpoint, 0, 64)
		}
		servroles[key] = append(servroles[key], point{id: role.RoleID, point: role.Point})
	}
	for _, roles := range servroles {
		sort.Sort(sort.Reverse(roles))
	}

	ranks := make(map[string][]scheme.PreRankRolePoint)
	for key, v := range servroles {
		roles := make([]scheme.PreRankRolePoint, 0, len(v))
		for _, vv := range v {
			roles = append(roles, scheme.PreRankRolePoint{ID: vv.id, Point: vv.point, FightingPoint: c.roleCardFightPoint[vv.id]})
		}
		ranks[key] = roles
	}
	c.SetPrePointRanks(ranks)
}

// 第一天预选下注奖励
func (c *Craft) onPreBetAward() {
	cfg := csv.GetMergeConfig()
	rolebets := make(map[string]map[document.ID]BetResult)
	db, unlock := c.LockAndGetDB()
	tjutil.WithDefer(func() {
		top3roles := c.getServerTop3PointRoles() // key 是合服之后的key
		for betRoleID, bet := range db.PreBet {
			key := db.RoleServKeys[betRoleID]
			if _, ok := rolebets[key]; !ok {
				rolebets[key] = make(map[document.ID]BetResult)
			}
			top3 := top3roles[cfg.GetMergeServKey(key)]
			result := BetResult{ID: betRoleID}
			for _, info := range bet {
				if _, ok := top3[info.Role.RoleID]; ok {
					// 押注成功获得双倍货币
					info.Success = true
					result.WinCount += 1
					if info.Coin == "gold" {
						result.WinGold += info.Amount * 2
					} else {
						result.WinCoin += info.Amount * 2
					}
				} else {
					// 押注失败返回一半货币
					result.FailCount += 1
					if info.Coin == "gold" {
						result.FailGold += info.Amount / 2
					} else {
						result.FailCoin += info.Amount / 2
					}
				}
			}
			result.FailCount = 3 - result.WinCount // 可能存在玩家没有使用完3次押注
			rolebets[key][betRoleID] = result
		}
		c.SetPreBet(db.PreBet)
	}, unlock)

	d := make(map[string]*EventToGame)
	for key, v := range rolebets {
		d[key] = &EventToGame{CraftBets: v}
	}
	c.eventToSomeGame("pre_bet", d, false)
}

// 第二天4强下注奖励
func (c *Craft) onTop4BetAward(top4 map[document.ID]bool) {
	rolebets := make(map[string]map[document.ID]BetResult)
	db, unlock := c.LockAndGetDB()
	tjutil.WithDefer(func() {
		for betRoleID, bet := range db.Top4Bet {
			key := db.RoleServKeys[betRoleID]
			if _, ok := rolebets[key]; !ok {
				rolebets[key] = make(map[document.ID]BetResult)
			}
			result := BetResult{ID: betRoleID}
			for _, info := range bet {
				if success := top4[info.Role.RoleID]; success {
					// 押注成功获得双倍货币
					info.Success = true
					result.WinCount += 1
					if info.Coin == "gold" {
						result.WinGold += info.Amount * 2
					} else {
						result.WinCoin += info.Amount * 2
					}
				} else {
					// 押注失败返回一半货币
					result.FailCount += 1
					if info.Coin == "gold" {
						result.FailGold += info.Amount / 2
					} else {
						result.FailCoin += info.Amount / 2
					}
				}
			}
			result.FailCount = 3 - result.WinCount // 可能存在玩家没有使用完3次押注
			rolebets[key][betRoleID] = result
		}
		c.SetTop4Bet(db.Top4Bet)
	}, unlock)

	d := make(map[string]*EventToGame)
	for key, v := range rolebets {
		d[key] = &EventToGame{CraftBets: v}
	}
	c.eventToSomeGame("top4_bet", d, false)
}

// 第二天冠军下注奖励
func (c *Craft) onChampionBetAward(champion document.ID) {
	rolebets := make(map[string]map[document.ID]BetResult)
	cfg := GetConfig()
	db, unlock := c.RLockAndGetDB()
	tjutil.WithDefer(func() {
		for id, v := range db.ChampionBet {
			// 金币下注
			for betRoleID, amount := range v.Gold {
				key := db.RoleServKeys[betRoleID]
				if _, ok := rolebets[key]; !ok {
					rolebets[key] = make(map[document.ID]BetResult)
				}
				result := BetResult{ID: betRoleID}
				if id == champion { // 冠军
					amount = int(float64(amount) * v.GoldRate)
					if amount > cfg.MaxBetWinGold {
						amount = cfg.MaxBetWinGold
					}
					result.WinGold = amount
				} else { // 未获得冠军,获得一半货币返还补偿
					result.FailGold = amount / 2
				}
				rolebets[key][betRoleID] = result
			}

			// 代币下注
			for betRoleID, amount := range v.Coin {
				key := db.RoleServKeys[betRoleID]
				if _, ok := rolebets[key]; !ok {
					rolebets[key] = make(map[document.ID]BetResult)
				}
				result := BetResult{ID: id}
				if id == champion { // 冠军
					amount = int(float64(amount) * v.CoinRate)
					if amount > cfg.MaxBetWinCoin {
						amount = cfg.MaxBetWinCoin
					}
					result.WinCoin = amount
				} else { // 未获得冠军,获得一半货币返还补偿
					result.FailCoin = amount / 2
				}
				rolebets[key][betRoleID] = result
			}
		}
	}, unlock)

	d := make(map[string]*EventToGame)
	for key, v := range rolebets {
		d[key] = &EventToGame{CraftBets: v}
	}
	c.eventToSomeGame("champion_bet", d, false)
}

func (c *Craft) onCacheBetInfo() {
	infos := make(map[string]*scheme.LastBetInfo)
	db, unlock := c.LockAndGetDB()
	tjutil.WithDefer(func() {
		for _, key := range db.Servers {
			infos[key] = &scheme.LastBetInfo{
				PreBet:          make(map[document.ID][]scheme.CrossCraftBet),
				Top4Bet:         make(map[document.ID][]scheme.CrossCraftBet),
				ChampionBet:     make(map[document.ID]scheme.CrossCraftChampionBet),
				RoleBetChampion: make(map[document.ID]scheme.RoleBetChampion),
			}
		}
		// 预选押注
		for betRoleID, bet := range db.PreBet {
			key := db.RoleServKeys[betRoleID]
			infos[key].PreBet[betRoleID] = make([]scheme.CrossCraftBet, 0, 3)
			for _, v := range bet {
				infos[key].PreBet[betRoleID] = append(infos[key].PreBet[betRoleID], *v)
			}
		}
		// Top4押注
		for betRoleID, bet := range db.Top4Bet {
			key := db.RoleServKeys[betRoleID]
			infos[key].Top4Bet[betRoleID] = make([]scheme.CrossCraftBet, 0, 3)
			for _, v := range bet {
				infos[key].Top4Bet[betRoleID] = append(infos[key].Top4Bet[betRoleID], *v)
			}
		}
		// 冠军押注
		championBet := make(map[document.ID]scheme.CrossCraftChampionBet)
		for id, d := range db.ChampionBet {
			championBet[d.Role.RoleID] = scheme.CrossCraftChampionBet{
				Role:          d.Role,
				Rank:          d.Rank,
				GoldRate:      d.GoldRate,
				CoinRate:      d.CoinRate,
				FightingPoint: d.FightingPoint,
			}
			for betRoleID := range d.Gold {
				key := db.RoleServKeys[betRoleID]
				infos[key].RoleBetChampion[betRoleID] = scheme.RoleBetChampion{RoleID: id, Coin: "gold"}
			}
			for betRoleID := range d.Coin {
				key := db.RoleServKeys[betRoleID]
				infos[key].RoleBetChampion[betRoleID] = scheme.RoleBetChampion{RoleID: id, Coin: "coin"}
			}
		}
		for key := range infos {
			infos[key].ChampionBet = championBet
		}
	}, unlock)

	d := make(map[string]*EventToGame)
	for key, v := range infos {
		d[key] = &EventToGame{LastBetInfo: v}
	}
	c.eventToSomeGame("last_bet_info", d, false)
}

func (c *Craft) nextRoundPlayer(round string) (map[document.ID]document.ID, map[document.ID]int) {
	if round[:3] == "pre" {
		return c.nextPreRoundPlayer(round)
	} else if round[:3] == "top" || round[:5] == "final" {
		return c.nextTopAndFinalRoundPlayer(round)
	}
	return nil, nil
}

func (c *Craft) nextRoundMatch(round string, signList map[document.ID]cards, playerFails map[document.ID]int) (map[document.ID]cards, map[document.ID]document.ID, map[document.ID]int) {
	if round[:3] == "pre" {
		return c.nextPreRoundMatch(round, signList, playerFails)
	} else if round[:3] == "top" || round[:5] == "final" {
		return c.nextTopAndFinalRoundMatch(round, signList, playerFails)
	}
	return nil, nil, nil
}

func (c *Craft) nextPreRoundPlayer(round string) (map[document.ID]document.ID, map[document.ID]int) {
	players := make(map[document.ID]document.ID) // {role.id: record.id}
	playerFails := make(map[document.ID]int)
	// 如果玩家负场累计至五场，则自动淘汰出局
	// self.round是未开始的本轮
	total := RoundNextMap[round].idx - 1
	c.winRoleMap = make(map[int][]document.ID)
	for id, info := range c.CraftRoles() {
		if total-info.Win < FailOut {
			players[id] = info.RecordID
			if _, ok := c.winRoleMap[info.Win]; ok {
				c.winRoleMap[info.Win] = append(c.winRoleMap[info.Win], id)
			} else {
				c.winRoleMap[info.Win] = []document.ID{id}
			}
		}
		playerFails[id] = total - info.Win
	}
	return players, playerFails
}

func (c *Craft) nextTopAndFinalRoundPlayer(round string) (map[document.ID]document.ID, map[document.ID]int) {
	/*
		Top64, 32, 16:
		T0 T1 T2 T3 T4 T5 T6 T7
		1  2  3  4  5  6  7  8
		16 15 14 13 12 11 10 9
		...
		64 63 62 61 60 59 58 57
		竖列8人为一组，决出8个组内冠军，然后参加最后8强赛
	*/
	top8Map := make(map[string]map[int]document.ID)
	playerFails := make(map[document.ID]int)
	roundIdx := RoundNextMap[round].idx - 1
	if roundIdx == 0 {
		if round == "top64" {
			// 根据胜场数和积分的排名，选出前8的玩家进入64强决赛
			roles := make(sortRoles, 0, len(c.CraftRoles()))
			for _, role := range c.CraftRoles() {
				roles = append(roles, role)
				playerFails[role.RoleID] = FailOut // 全部人员先当淘汰
			}
			sort.Sort(roles)
			for rank, role := range roles[:64] {
				playerFails[role.RoleID] = 0 // 保留
				tRank := rank / 8
				tIdx := 0
				if tRank%2 == 0 {
					tIdx = rank % 8
				} else {
					tIdx = 7 - rank%8
				}
				key := fmt.Sprintf("t%d", tIdx)
				if _, ok := top8Map[key]; !ok {
					top8Map[key] = make(map[int]document.ID)
				}
				top8Map[key][tRank+1] = role.RoleID
			}
		} else {
			// 8强决赛是64，32, 16的各组冠军
			craftRoles := c.CraftRoles()
			teamChampions := make(sortRoles, 0, 8)
			for _, plays := range c.Top8Plays() {
				play := plays["champion"]
				var champion, failRoleID document.ID
				if play.Result == "win" {
					champion = play.Role1.RoleID
					failRoleID = play.Role2.RoleID
				} else {
					champion = play.Role2.RoleID
					failRoleID = play.Role1.RoleID
				}
				teamChampions = append(teamChampions, craftRoles[champion])
				playerFails[failRoleID] = FailOut
			}
			sort.Sort(teamChampions)
			top8Map["final"] = make(map[int]document.ID)
			for rank, role := range teamChampions {
				top8Map["final"][rank+1] = role.RoleID
			}
		}
	} else {
		// 从上一场战斗数据中计算
		preRoundIdx := roundIdx - 1
		teamKeys := []string{"final"}
		if round[:3] == "top" {
			teamKeys = []string{"t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7"}
		}
		for _, teamKey := range teamKeys {
			for _, kk := range Top8PlayKeyRound[preRoundIdx] {
				play := c.Top8Plays()[teamKey][Top8PlayKeyMap[kk]]
				var winRoleID, failRoleID document.ID
				if play.Result == "win" {
					winRoleID = play.Role1.RoleID
					failRoleID = play.Role2.RoleID
				} else {
					winRoleID = play.Role2.RoleID
					failRoleID = play.Role1.RoleID
				}
				key := calcNextTop8PlayKey(kk[0], kk[1])
				if _, ok := top8Map[teamKey]; !ok {
					top8Map[teamKey] = make(map[int]document.ID)
				}
				top8Map[teamKey][key] = winRoleID
				if round == "final3" {
					top8Map[teamKey][-key] = failRoleID // 参加季军赛
				} else {
					playerFails[failRoleID] = FailOut // 淘汰
				}
			}
		}
	}

	players := make(map[document.ID]document.ID) // {role.id: record.id}
	for _, plays := range top8Map {
		for _, roleID := range plays {
			players[roleID] = c.CraftRoles()[roleID].RecordID
		}
	}

	// 初始化每轮top8_plays对阵
	c.battleKeys = make(map[battleroles][2]string)
	for teamKey, plays := range top8Map {
		keys := Top8PlayKeyRound[roundIdx]
		if round == "top16" { // top16 不进行季军赛
			keys = keys[:1]
		}
		for _, kk := range keys {
			role1, role2 := plays[kk[0]], plays[kk[1]]
			key := battleroles{role1, role2}
			c.battleKeys[key] = [2]string{teamKey, Top8PlayKeyMap[kk]}
		}
	}

	return players, playerFails
}

func (c *Craft) makeRandomMatch(roles []document.ID) ([]battleroles, document.ID) {
	n := len(roles) / 2
	matchs := make([]battleroles, 0, n)
	rand.Shuffle(len(roles), func(i, j int) {
		roles[i], roles[j] = roles[j], roles[i]
	})
	for i := 0; i < n; i++ {
		matchs = append(matchs, battleroles{roles[i*2], roles[i*2+1]})
	}
	// 最后一人轮空
	if len(roles)%2 == 1 {
		return matchs, roles[len(roles)-1]
	}
	return matchs, ""
}

func (c *Craft) nextPreRoundMatch(round string, signList map[document.ID]cards, playerFails map[document.ID]int) (map[document.ID]cards, map[document.ID]document.ID, map[document.ID]int) {
	// 处理没有卡牌的情况
	// 跟普通的王者不同，4个队伍是循环上阵
	emptyroles := make(map[document.ID]bool)
	total := RoundNextMap[round].idx - 1
	// 预选赛每场比赛为3V3
	cardIdx := (total * 3) % 12
	for id, v := range signList {
		if v.cards[cardIdx] == "" {
			emptyroles[id] = true
			playerFails[id] = FailOut // 没有卡牌上阵当做失败
		}
	}
	if len(emptyroles) > 0 {
		// 忽略由于没有后续卡牌的匹配
		for win, roles := range c.winRoleMap {
			validroles := make([]document.ID, 0, len(roles))
			for _, id := range roles {
				if !emptyroles[id] {
					validroles = append(validroles, id)
				}
			}
			c.winRoleMap[win] = validroles
		}
	}

	c.battleKeys = make(map[battleroles][2]string)
	matchList := make(map[document.ID]document.ID)
	// 初始化 round_results
	vsResult := make(map[string]*scheme.CrossCraftResultInfo)
	// 每轮玩家匹配和自己胜场数一致的玩家，优先从高胜场的玩家开始排位
	wins := make([]int, 0, len(c.winRoleMap))
	for win := range c.winRoleMap {
		wins = append(wins, win)
	}
	sort.Sort(sort.Reverse(sort.IntSlice(wins)))
	count := 0
	for _, win := range wins {
		roleIDs := c.winRoleMap[win]
		matchs, leftRoleID := c.makeRandomMatch(roleIDs)
		// 如果为奇数的话，从下一个胜场选取一个玩家进入战斗
		if leftRoleID != "" {
			if nextRoleIDs, ok := c.winRoleMap[win-1]; ok {
				idx := rand.Int31n(int32(len(nextRoleIDs)))
				matchs = append(matchs, battleroles{leftRoleID, nextRoleIDs[idx]})
				c.winRoleMap[win-1] = append(nextRoleIDs[:idx], nextRoleIDs[idx+1:]...)
			} else {
				// 没人的话，只能轮空
				matchs = append(matchs, battleroles{leftRoleID, ""})
			}
		}

		for _, roles := range matchs {
			count++
			key := fmt.Sprintf("%s_%d", round, count)
			c.battleKeys[roles] = [2]string{"", key}
			info := &scheme.CrossCraftResultInfo{}
			if roles[1] == "" {
				info.Roles = []document.ID{roles[0]}
			} else {
				info.Roles = []document.ID{roles[0], roles[1]}
			}
			vsResult[key] = info
			matchList[roles[0]] = roles[1]
			if roles[1] != "" {
				matchList[roles[1]] = roles[0]
			}
		}
	}
	c.Lock()
	v := c.RoundResults()
	v[round] = vsResult
	c.SetRoundResults(v)
	c.Unlock()
	return signList, matchList, playerFails
}

func (c *Craft) nextTopAndFinalRoundMatch(round string, signList map[document.ID]cards, playerFails map[document.ID]int) (map[document.ID]cards, map[document.ID]document.ID, map[document.ID]int) {
	// 固定对阵
	matchList := make(map[document.ID]document.ID)
	// 初始化round_results
	vsResult := make(map[string]*scheme.CrossCraftResultInfo)
	// 初始化每轮top8_plays对阵
	plays := c.Top8Plays()
	for roles, v := range c.battleKeys {
		teamKey, key := v[0], v[1]
		roleID1, roleID2 := roles[0], roles[1]
		matchList[roleID1] = roleID2
		matchList[roleID2] = roleID1
		if _, ok := plays[teamKey]; !ok {
			plays[teamKey] = make(map[string]*scheme.CrossCraftTop8Play)
		}
		plays[teamKey][key] = &scheme.CrossCraftTop8Play{
			Role1: scheme.CrossCraftBattleRole{
				CrossCraftRole: c.CraftRoles()[roleID1].CrossCraftRole,
				Display:        signList[roleID1].display,
			},
			Role2: scheme.CrossCraftBattleRole{
				CrossCraftRole: c.CraftRoles()[roleID2].CrossCraftRole,
				Display:        signList[roleID2].display,
			},
		}

		key = fmt.Sprintf("%s_%s", teamKey, key)
		vsResult[key] = &scheme.CrossCraftResultInfo{Roles: []document.ID{roles[0], roles[1]}}
	}

	c.Lock()
	v := c.RoundResults()
	v[round] = vsResult
	c.SetRoundResults(v)
	c.SetTop8Plays(plays)
	c.Unlock()
	return signList, matchList, playerFails
}

func (c *Craft) initPlay() {
	c.playMap = sync.Map{}
	atomic.StoreInt32(&c.playstatus, 0)
}

func (c *Craft) makePlayEnd() {
	// 可能会有多次make
	atomic.CompareAndSwapInt32(&c.playstatus, 0, 1)
}

func (c *Craft) isFirstMakeEnd() bool {
	return atomic.LoadInt32(&c.playstatus) > 0
}

func (c *Craft) makeMatchHistory(round string, matchs map[document.ID]document.ID) {
	roleMatchHistory := sync.Map{}
	for roleID, vsRoleID := range matchs {
		result := "unknown"
		if vsRoleID == "" {
			result = "win"
		}
		roleMatchHistory.Store(roleID, &matchHistory{
			Round:  round,
			VSID:   vsRoleID,
			PlayID: "",
			Result: result,
			Point:  0,
		})
	}
	c.roleMatchHistory = roleMatchHistory
}

func (c *Craft) newPlay(playID document.ID, model *scheme.CrossCraftPlayRecord, display1, display2 map[string]int) {
	rr := battleroles{model.RoleKey.ID, model.DefenceRoleKey.ID}
	teamKey, key := c.battleKeys[rr][0], c.battleKeys[rr][1]
	key2 := key
	if teamKey != "" {
		key2 = fmt.Sprintf("%s_%s", teamKey, key)
	}
	v := c.RoundResults()
	vv := v[c.Round()]
	vv[key2].PlayID = playID
	vv[key2].Result = "unknown"
	c.SetRoundResults(v)
	c.playMap.Store(playID, rr)

	// 保存top8_plays信息
	if isInTopOrFinal(c.Round()) {
		cards, fightingPoint := schemeutil.FilterEmptyCards(model.Cards, model.CardAttrs)
		cards2, fightingPoint2 := schemeutil.FilterEmptyCards(model.DefenceCards, model.DefenceCardAttrs)
		role1 := *c.CraftRoles()[model.RoleKey.ID]
		role2 := *c.CraftRoles()[model.DefenceRoleKey.ID]
		plays := c.Top8Plays()
		if _, ok := plays[teamKey]; !ok {
			plays[teamKey] = make(map[string]*scheme.CrossCraftTop8Play)
		}
		plays[teamKey][key] = &scheme.CrossCraftTop8Play{
			CrossKey: c.key,
			PlayID:   playID,
			Role1: scheme.CrossCraftBattleRole{
				CrossCraftRole: role1.CrossCraftRole,
				FightingPoint:  fightingPoint,
				Cards:          cards,
				Display:        display1,
			},
			Role2: scheme.CrossCraftBattleRole{
				CrossCraftRole: role2.CrossCraftRole,
				FightingPoint:  fightingPoint2,
				Cards:          cards2,
				Display:        display2,
			},
		}
		c.SetTop8Plays(plays)
	}
}

func (c *Craft) recordPlayResult(playID document.ID, result string, points [2]int) battleroles {
	roles, ok := c.playMap.Load(playID)
	c.playMap.Delete(playID)
	if !ok {
		return battleroles{}
	}

	rr := roles.(battleroles)
	teamKey, key := c.battleKeys[rr][0], c.battleKeys[rr][1]
	key2 := key
	if teamKey != "" {
		key2 = fmt.Sprintf("%s_%s", teamKey, key)
	}
	v := c.RoundResults()
	vv := v[c.Round()]
	vv[key2].Result = result
	vv[key2].Points = points
	c.SetRoundResults(v)

	key1 := scheme.RoleKey{ID: rr[0], GameKey: c.CraftRoles()[rr[0]].GameKey}
	c.updateRoleResult(key1, result, points[0])
	c.updateRoleInfo(rr[0], result, points[0])
	if rr[1] != "" {
		result2 := "win"
		if result == "win" {
			result2 = "fail"
		}
		key2 := scheme.RoleKey{ID: rr[1], GameKey: c.CraftRoles()[rr[1]].GameKey}
		c.updateRoleResult(key2, result2, points[1])
		c.updateRoleInfo(rr[1], result2, points[1])
	}

	// 如果是决赛，另外要保存到top8_plays
	if isInTopOrFinal(c.Round()) {
		plays := c.Top8Plays()
		plays[teamKey][key].Result = result
		plays[teamKey][key].Points = points
		c.SetTop8Plays(plays)
		// 冠军赛和季军赛特殊处理，使其排名最高
		// 冠军+3(21)，亚军+2(20)，季军+1(19)
		if teamKey == "final" {
			winRole, failRole := rr[0], rr[1]
			if result == "fail" {
				winRole, failRole = rr[1], rr[0]
			}
			roles := c.CraftRoles()
			if key == "third" {
				roles[winRole].Round = 19
			}
			if key == "champion" {
				roles[failRole].Round = 20
				roles[winRole].Round = 21
			}
			c.SetCraftRoles(roles)
		}
	}

	return rr
}

func (c *Craft) pushPlayResultToGame(model *scheme.CrossCraftPlayRecord) {
	// 本轮战况
	if match, ok := c.roleMatchHistory.Load(model.RoleKey.ID); ok {
		history := match.(*matchHistory)
		history.Result = model.Result
		history.Point = model.Point
	}
	if model.DefenceRoleKey.ID != "" {
		if match, ok := c.roleMatchHistory.Load(model.RoleKey.ID); ok {
			history := match.(*matchHistory)
			if model.Result == "win" {
				history.Result = "fail"
			} else {
				history.Result = "win"
			}
			history.Point = model.DefencePoint
		}
	}

	// 更新连胜次数
	streak := 1
	if model.Result == "win" {
		if count, loaded := c.winningstreak.LoadOrStore(model.RoleKey.ID, 1); loaded {
			streak = count.(int) + 1
			c.winningstreak.Store(model.RoleKey.ID, streak)
		}
		c.winningstreak.Delete(model.DefenceRoleKey.ID)
	} else {
		if count, loaded := c.winningstreak.LoadOrStore(model.DefenceRoleKey.ID, 1); loaded {
			streak = count.(int) + 1
			c.winningstreak.Store(model.DefenceRoleKey.ID, streak)
		}
		c.winningstreak.Delete(model.RoleKey.ID)
	}

	message := &BattleMessage{
		Round:  model.Round,
		Result: model.Result,
		Roles:  [2]scheme.RoleKey{model.RoleKey, model.DefenceRoleKey},
		Names:  [2]string{model.Name, model.DefenceName},
		Points: [2]int{model.Point, model.DefencePoint},
		Streak: streak,
	}

	go c.eventToGame("new_play", EventToGame{BattleMessage: message}, false, true)
}

func (c *Craft) refreshRank() {
	db := c.GetLockedDB()
	roles := db.CraftRoles
	total := len(roles)
	ranks := &ranks{
		items: make([]rankitem, 0, total),
		keys:  []string{"round", "win", "point"},
	}
	for _, role := range roles {
		ranks.items = append(ranks.items, rankitem{
			id: role.RoleID,
			items: map[string]int{
				"round": role.Round,
				"win":   role.Win,
				"point": role.Point,
			},
		})
	}
	sort.Sort(ranks)

	cache := make([]scheme.CrossCraftRoleInfo, 0, total)
	for rank, v := range ranks.items {
		id := v.id
		roles[id].Rank = rank + 1
		cache = append(cache, *roles[id])
	}
	c.ranks = cache
	c.SetCraftRoles(roles)
}

func (c *Craft) GetRankList(offest, size int) []scheme.CrossCraftRoleInfo {
	right := offest + size
	if right > len(c.ranks) {
		right = len(c.ranks)
	}
	return c.ranks[offest:right]
}

func (c *Craft) GetCrossCraftRole(id document.ID) (scheme.CrossCraftRoleInfo, bool) {
	db, unlock := c.RLockAndGetDB()
	defer unlock()
	role := db.CraftRoles[id]
	if role == nil {
		return scheme.CrossCraftRoleInfo{}, false
	}
	return *role, true
}

func (c *Craft) GetVSRole(roleID document.ID) (bool, *scheme.CrossCraftRole) {
	if _, ok := c.outs.Load(roleID); ok {
		return true, nil
	}
	vs, ok := c.roleMatchHistory.Load(roleID)
	if !ok {
		return false, nil
	}
	vsid := vs.(*matchHistory).VSID
	if vsid == "" { // 轮空
		return false, nil
	}
	db, unlock := c.RLockAndGetDB()
	defer unlock()
	role := db.CraftRoles[vsid].CrossCraftRole
	return false, &role
}

func (c *Craft) BetPreRole(key string, roleID document.ID, target scheme.CrossCraftRole, coin string, amount int) (*BetInfo, error) {
	db, unlock := c.LockAndGetDB()
	defer unlock()
	if _, ok := db.PreBet[roleID]; !ok {
		db.PreBet[roleID] = []*scheme.CrossCraftBet{}
	}
	for _, v := range db.PreBet[roleID] {
		if v.Role.RoleID == target.RoleID {
			return nil, errors.New("already bet")
		}
	}
	if len(db.PreBet[roleID]) >= 3 {
		return nil, errors.New("no times")
	}
	db.RoleServKeys[roleID] = key
	c.SetRoleServKeys(db.RoleServKeys)
	db.PreBet[roleID] = append(db.PreBet[roleID], &scheme.CrossCraftBet{
		Role:   target,
		Coin:   coin,
		Amount: amount,
	})
	c.SetPreBet(db.PreBet)
	return c.getBetInfo(roleID), nil
}

func (c *Craft) makeTop4AndChampionBetRole() {
	// 根据top12的战斗力选出bet2下注人选
	ranks := make(sortpoint, 0, 64)
	for id, fp := range c.roleCardFightPoint {
		ranks = append(ranks, point{id: id, point: fp})
	}
	sort.Sort(sort.Reverse(ranks))
	ranks = ranks[:64]

	db := c.GetLockedDB()
	championBets := make(map[document.ID]*scheme.CrossCraftChampionBet)
	cfg := GetConfig()
	for i, v := range ranks {
		role := db.CraftRoles[v.id]
		championBets[v.id] = &scheme.CrossCraftChampionBet{
			Role:          role.CrossCraftRole,
			Rank:          i,
			GoldRate:      cfg.MinBetRateGold,
			Gold:          map[document.ID]int{},
			CoinRate:      cfg.MinBetRateCoin,
			Coin:          map[document.ID]int{},
			FightingPoint: v.point,
		}
	}
	c.SetTop4Bet(map[document.ID][]*scheme.CrossCraftBet{})
	c.SetChampionBet(championBets)
}

func (c *Craft) BetTop4Role(key string, roleID, target document.ID, coin string, amount int) (*BetInfo, error) {
	db, unlock := c.LockAndGetDB()
	defer unlock()
	top4bet := db.Top4Bet
	role, ok := db.CraftRoles[target]
	if !ok {
		return nil, errors.New("not this role")
	}
	if _, ok := top4bet[roleID]; !ok {
		top4bet[roleID] = []*scheme.CrossCraftBet{}
	}
	for _, v := range top4bet[roleID] {
		if v.Role.RoleID == target {
			return nil, errors.New("already bet top4")
		}
	}
	if len(top4bet[roleID]) >= 3 {
		return nil, errors.New("no times")
	}
	if v, ok := db.ChampionBet[target]; ok {
		if v.Gold[roleID] != 0 || v.Coin[roleID] != 0 { // 已经押注冠军了
			return nil, errors.New("already bet champion")
		}
	}
	db.RoleServKeys[roleID] = key
	c.SetRoleServKeys(db.RoleServKeys)
	top4bet[roleID] = append(top4bet[roleID], &scheme.CrossCraftBet{
		Role:   role.CrossCraftRole,
		Coin:   coin,
		Amount: amount,
	})
	c.SetTop4Bet(top4bet)
	return c.getBetInfo(roleID), nil
}

func (c *Craft) BetChampion(key string, roleID, target document.ID, coin string, amount int) (*BetInfo, error) {
	db, unlock := c.LockAndGetDB()
	defer unlock()

	for _, v := range db.Top4Bet[roleID] {
		if v.Role.RoleID == target { // 已经下注4强
			return nil, errors.New("already bet top4")
		}
	}
	for _, v := range db.ChampionBet {
		if v.Gold[roleID] != 0 || v.Coin[roleID] != 0 { // 已经下注冠军
			return nil, errors.New("already bet champion")
		}
	}
	info, ok := db.ChampionBet[target]
	if !ok {
		return nil, errors.New("cross craft bet no such role")
	}
	if coin == "gold" {
		info.Gold[roleID] = amount
		c.betgoldsum += amount
	} else {
		info.Coin[roleID] = amount
		c.betcoinsum += amount
	}
	db.RoleServKeys[roleID] = key
	c.SetRoleServKeys(db.RoleServKeys)

	cfg := GetConfig()
	betgoldsum, betcoinsum := 0, 0
	for _, d := range db.ChampionBet {
		// 金币下注
		goldsum := 0
		for _, bet := range d.Gold {
			goldsum += bet
		}
		betgoldsum += goldsum
		goldrate := cfg.MinBetRateGold
		if goldsum > 0 {
			rate := float64(c.betgoldsum) * cfg.BetRateFixGold / float64(goldsum)
			if rate > goldrate {
				goldrate = rate
			}
		}
		d.GoldRate = goldrate

		// 代币下注
		coinsum := 0
		for _, bet := range d.Coin {
			coinsum += bet
		}
		betcoinsum += coinsum
		coinrate := cfg.MinBetRateCoin
		if coinsum > 0 {
			rate := float64(c.betcoinsum) * cfg.BetRateFixCoin / float64(coinsum)
			if rate > coinrate {
				coinrate = rate
			}
			d.CoinRate = rate
		}
		d.CoinRate = coinrate
	}

	c.betgoldsum = betgoldsum
	c.betcoinsum = betcoinsum
	c.SetChampionBet(db.ChampionBet)
	return c.getBetInfo(roleID), nil
}

type preRankRole struct {
	scheme.CrossCraftRole
	Point         int `codec:"point"`
	FightingPoint int `codec:"fighting_point"`
}

func (c *Craft) getPrePointRank(key string, offest, size int) []preRankRole {
	right := offest + size
	db := c.GetLockedDB()
	if ranks, ok := c.prePointRanks[key]; ok {
		if right > len(ranks) {
			right = len(ranks)
		}
		return ranks[offest:right]
	}

	preRanks := make(map[string][]preRankRole)
	for key, v := range db.PrePointRanks {
		ranks := make([]preRankRole, 0, len(v))
		for _, vv := range v {
			ranks = append(ranks, preRankRole{
				CrossCraftRole: db.CraftRoles[vv.ID].CrossCraftRole,
				Point:          vv.Point,
				FightingPoint:  vv.FightingPoint,
			})
		}
		preRanks[key] = ranks
	}
	c.prePointRanks = preRanks
	if right > len(c.prePointRanks[key]) {
		right = len(c.prePointRanks[key])
	}
	return c.prePointRanks[key][offest:right]
}

func (c *Craft) GetPrePointRank(key string, offest, size int) []preRankRole {
	_, unlock := c.RLockAndGetDB()
	defer unlock()
	key = csv.GetMergeConfig().GetMergeServKey(key)
	return c.getPrePointRank(key, offest, size)
}

type BetInfo struct {
	PreBet        []scheme.CrossCraftBet                       `codec:"pre_bet"`
	Top4Bet       []scheme.CrossCraftBet                       `codec:"top4_bet"`
	ChampionBet   map[document.ID]scheme.CrossCraftChampionBet `codec:"champion_bet"`
	MyChampionBet scheme.RoleBetChampion                       `codec:"mychampion_bet"`
}

func (c *Craft) getBetInfo(roleID document.ID) *BetInfo {
	db := c.GetLockedDB()
	info := &BetInfo{
		PreBet:  make([]scheme.CrossCraftBet, 0, 3),
		Top4Bet: make([]scheme.CrossCraftBet, 0, 3),
	}
	if db.PreBet[roleID] != nil {
		for _, v := range db.PreBet[roleID] {
			info.PreBet = append(info.PreBet, *v)
		}
	}
	if db.Top4Bet[roleID] != nil {
		for _, v := range db.Top4Bet[roleID] {
			info.Top4Bet = append(info.Top4Bet, *v)
		}
	}
	champion := make(map[document.ID]scheme.CrossCraftChampionBet)
	for _, d := range db.ChampionBet {
		champion[d.Role.RoleID] = scheme.CrossCraftChampionBet{
			Role:          d.Role,
			Rank:          d.Rank,
			GoldRate:      d.GoldRate,
			CoinRate:      d.CoinRate,
			FightingPoint: d.FightingPoint,
		}
		if info.MyChampionBet.RoleID == "" {
			for id := range d.Gold {
				if roleID == id {
					info.MyChampionBet.RoleID = d.Role.RoleID
					info.MyChampionBet.Coin = "gold"
					break
				}
			}
		}
		if info.MyChampionBet.RoleID == "" {
			for id := range d.Coin {
				if roleID == id {
					info.MyChampionBet.RoleID = d.Role.RoleID
					info.MyChampionBet.Coin = "coin"
					break
				}
			}
		}
	}
	info.ChampionBet = champion
	return info
}

func (c *Craft) GetBetInfo(roleID document.ID) *BetInfo {
	_, unlock := c.RLockAndGetDB()
	defer unlock()
	return c.getBetInfo(roleID)
}

func (c *Craft) syncModel() *SyncModel {
	return &SyncModel{
		Round:     c.Round(),
		Time:      c.Time(),
		Top8Plays: c.Top8Plays(),
	}
}

func (c *Craft) eventToGame(event string, data EventToGame, sync bool, mergeFilter bool) map[string]*game.CrossCraftEventResponse {
	var model *SyncModel
	if sync {
		model = c.syncModel()
	}

	servers := c.Servers()
	if mergeFilter {
		servers = csv.GetMergeConfig().FilterMergeServer(servers)
	}

	keys := make([]string, 0, len(servers))
	futures := make([]*service.Future, 0, len(servers))
	for _, key := range servers {
		keys = append(keys, key)
		s := c.container.GetService(key)
		future := service.CallAsync(s, "CrossCraftEvent", event, key, data, model)
		futures = append(futures, future)
	}

	ret := make(map[string]*game.CrossCraftEventResponse)
	resp, err := service.MultiFuture(futures, false).Get()
	if err != nil {
		log.Warningf("CrossCraftEvent %s response error %v", event, err)
		return nil
	}
	response := resp.([]interface{})
	for i, key := range keys {
		ret[key] = response[i].(*game.CrossCraftEventResponse)
	}
	return ret
}

func (c *Craft) eventToSomeGame(event string, d map[string]*EventToGame, sync bool) map[string]*game.CrossCraftEventResponse {
	var model *SyncModel
	if sync {
		model = c.syncModel()
	}
	keys := make([]string, 0, len(d))
	futures := make([]*service.Future, 0, len(d))
	for key, data := range d {
		s := c.container.GetService(key)
		if s == nil {
			log.Warningf("CrossCraft.eventToSomeGame: no service found for key=%s, event=%s (skip)", key, event)
			continue
		}
		keys = append(keys, key)
		future := service.CallAsync(s, "CrossCraftEvent", event, key, data, model)
		futures = append(futures, future)
	}

	ret := make(map[string]*game.CrossCraftEventResponse)
	resp, err := service.MultiFuture(futures, false).Get()
	if err != nil {
		log.Warningf("CrossCraftEvent %s response error %v", event, err)
		return nil
	}
	response := resp.([]interface{})
	for i, key := range keys {
		ret[key] = response[i].(*game.CrossCraftEventResponse)
	}
	return ret
}

func isInPreRound(round string) bool {
	return strings.HasPrefix(round, "pre")
}

func isInFinal(round string) bool {
	return strings.HasPrefix(round, "final")
}

func isInTopOrFinal(round string) bool {
	return round[:3] == "top" || round[:5] == "final"
}

func isInBattle(round string) bool {
	if !strings.HasPrefix(round, "prepare") {
		return strings.HasPrefix(round, "pre") || strings.HasPrefix(round, "top") || strings.HasPrefix(round, "fin")
	}
	return false
}

func calcNextTop8PlayKey(key1, key2 int) int {
	if key1 > key2 {
		key1, key2 = key2, key1
	}
	carry := func(i int) int {
		return int(math.Pow10(1 + int(math.Log10(float64(i)))))
	}
	return key1*carry(key2) + key2
}

func calcRobotNum(signupNum int) int {
	robotNum := 0
	config := csv.GetConfig()
	for i := 1; i < 999; i++ {
		cfg := config.Cross.Craft.Robot_num[i]
		if cfg == nil {
			break
		}
		if cfg.RealNum >= signupNum {
			robotNum = cfg.TotalNum - signupNum
			break
		}
	}
	return robotNum
}

type sortRoles []*scheme.CrossCraftRoleInfo

func (rs sortRoles) Len() int {
	return len(rs)
}
func (rs sortRoles) Less(i, j int) bool {
	if isRobot(rs[i].RoleID) && !isRobot(rs[j].RoleID) {
		return false
	}
	if !isRobot(rs[i].RoleID) && isRobot(rs[j].RoleID) {
		return true
	}
	if rs[i].Win != rs[j].Win {
		return rs[i].Win > rs[j].Win
	}
	if rs[i].Point != rs[j].Point {
		return rs[i].Point > rs[j].Point
	}
	return false
}

func (rs sortRoles) Swap(i, j int) {
	rs[i], rs[j] = rs[j], rs[i]
}

func isRobot(id document.ID) bool {
	s := string(id)
	return strings.HasPrefix(s, "rbt")
}

type rankitem struct {
	id    document.ID
	items map[string]int
}

type ranks struct {
	items []rankitem
	keys  []string
}

func (r *ranks) Len() int {
	return len(r.items)
}

func (r *ranks) Less(i, j int) bool {
	for _, key := range r.keys {
		if r.items[i].items[key] == r.items[j].items[key] {
			continue
		}
		return r.items[i].items[key] > r.items[j].items[key]
	}
	return true
}

func (r *ranks) Swap(i, j int) {
	r.items[i], r.items[j] = r.items[j], r.items[i]
}

type point struct {
	id    document.ID
	point int
}

type sortpoint []point

func (s sortpoint) Len() int {
	return len(s)
}

func (s sortpoint) Less(i, j int) bool {
	return s[i].point < s[j].point
}

func (s sortpoint) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}

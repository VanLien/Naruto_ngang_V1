package craft

import (
	"errors"
	"fmt"
	"math"
	"math/rand"
	"sort"
	"strings"
	"sync"
	"sync/atomic"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/util"
	anti_cheat "tjgame/services/anti-cheat"
	"tjgame/services/anti-cheat/manager"
	"tjgame/services/game"

	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
)

const (
	LeastRoles        = 8
	FailOut           = 3
	RobotBattlePlayID = document.ID("robot-battle")
	ByeBattlePlayID   = document.ID("~bye-battle~")
)

type Config struct {
	BetRateFix       float64
	MinBetRate       float64
	MaxBetWin        int
	DamageScoreRatio float64
}

var config atomic.Value

func GetConfig() *Config {
	return config.Load().(*Config)
}

func LoadConfig() error {
	cfg := csv.GetConfig().Craft.Base[1]

	v := &Config{
		BetRateFix:       float64(cfg.BetRateFix),
		MinBetRate:       float64(cfg.MinBetRate),
		MaxBetWin:        cfg.MaxBetWin,
		DamageScoreRatio: float64(cfg.DamageScoreRatio),
	}
	config.Store(v)
	return nil
}

type roundinfo struct {
	idx  int
	next string
}

var RoundNextMap = map[string]roundinfo{
	"signup":  {0, "prepare"},
	"prepare": {0, "pre1"},
	"pre1":    {1, "pre2"},
	"pre2":    {2, "pre3"},
	"pre3":    {3, "pre4"},
	"pre4":    {4, "pre5"},
	"pre5":    {5, "pre6"},
	"pre6":    {6, "pre7"},
	"pre7":    {7, "pre8"},
	"pre8":    {8, "pre9"},
	"pre9":    {9, "pre10"},
	"pre10":   {10, "final1"},
	"final1":  {11, "final2"},
	"final2":  {12, "final3"},
	"final3":  {13, "over"},
	"over":    {14, "closed"},
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
	Round  string         `codec:"round"`
	Result string         `codec:"result"`
	Roles  [2]document.ID `codec:"roles"`
	Points [2]int         `codec:"points"`
	Streak int            `codec:"streak"` // win方的连胜次数
}

type EventToGame struct {
	BattleMessage *BattleMessage `codec:"battle_message,omitempty"`

	// 战斗结果数据 {role.id: (round, win, point)}
	CraftRoles map[document.ID][4]int `codec:"craft_roles,omitempty"`

	// 排行数据 {rank: role.id}
	CraftRanks map[int]EventToGameCraftRankItem `codec:"craft_ranks,omitempty"`

	// 下注结果数据
	CraftBets map[document.ID][3]interface{} `codec:"craft_bets,omitempty"`

	// 上一轮战斗的玩家 用于更新game的排行榜 {role.id: (round, win, point)}
	LastRankRoles map[document.ID][3]int `codec:"last_rank_roles,omitempty"`
}

type EventToGameCraftRankItem struct {
	_struct struct{} `codec:",toarray"`

	RoleID document.ID `codec:"roleID"`
	Level  int         `codec:"level"`
}

type SyncModel struct {
	Round string `codec:"round"`
	Time  int64  `codec:"time"`
	// Top8 战斗结果
	Top8Plays map[string]*scheme.CraftTop8Play `codec:"top8_plays"`
}

type Craft struct {
	*scheme.CraftGlobalObject
	builder *Builder
	game    service.IService

	winRoleMap map[int][]document.ID

	playstatus int32                  // 0-continue, 1-make_play_end, 2-finished
	lockcard   int32                  // 0-unlocked, 1-locked
	prepareok  int32                  // 0-not ok, 1-ok
	playMap    sync.Map               // {playID: [roleID1, roleID2]} map[document.ID]battleroles
	battleKeys map[battleroles]string // {battleroles: key}

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

	// 下注总额
	betsum int

	mgr *manager.AgentManager

	// 状态定时器
	timer *time.Timer
}

func (c *Craft) SetRound(v string) {
	c.CraftGlobalObject.SetRound(v)
	c.SetTime(util.Now().Unix())
}

func (c *Craft) getElapsedDuration() time.Duration {
	return time.Duration(util.Now().Unix()-c.Time()) * time.Second
}

func (c *Craft) init(game service.IService, builder *Builder) {
	c.game = game
	c.builder = builder

	betsum := 0
	for _, d := range c.Bet() {
		for _, bet := range d.Gold {
			betsum += bet
		}
	}
	c.betsum = betsum
}

func (c *Craft) reset() bool {
	c.clean()
	ndt := util.Todaydate2int()
	log.Infof("Craft Reset %d %s, %d", c.Date(), c.Round(), ndt)
	c.SetDate(ndt)
	c.SetCraftRoles(map[document.ID]*scheme.CraftRoleInfo{})
	c.SetTop8Plays(map[string]*scheme.CraftTop8Play{})
	c.SetRoundResults(map[string]map[string]*scheme.CraftResultInfo{})
	c.SetBuffs([]int{})

	return true
}

// 战斗结束就进行clean，等下一次开始才进行reset
func (c *Craft) clean() {
	log.Infof("Craft Clean %d %s", c.Date(), c.Round())
	c.SetRound("closed")
	atomic.StoreInt32(&c.playstatus, 0)
	atomic.StoreInt32(&c.lockcard, 0)
	atomic.StoreInt32(&c.prepareok, 0)
	c.playMap = sync.Map{}
	c.roleMatchHistory = sync.Map{}
	c.outs = sync.Map{}
	c.winningstreak = sync.Map{}
	c.betsum = 0
	c.timer = nil
}

func (c *Craft) isAllOver() bool {
	round := c.Round()
	date := c.Date()
	if date == 0 {
		return true
	}
	if round != "closed" {
		return false
	}
	return util.Todaydate2int() != date
}

func (c *Craft) ResetToday() {
	round := c.Round()
	date := c.Date()
	log.Debugf("Craft.ResetToday date %d round %s", date, round)

	switch round {
	case "prepare":
		c.onStartPrepare(c.Buffs())
	case "over":
		// 结算的时候出错了，估计只能手动处理了
	case "closed":
	// 这里是不可能会到达
	default:
		c.onStartPrepare(c.Buffs())
	}
}

func (c *Craft) addSignupRole(signup []scheme.CraftRoleSignItem) {
	var wg sync.WaitGroup
	wg.Add(len(signup))

	infos := make(map[document.ID]*scheme.CraftRoleInfo)
	roles := make(chan scheme.CraftRoleSignItem, 64)
	go func() {
		for role := range roles {
			infos[role.ID] = &scheme.CraftRoleInfo{
				CraftRole: scheme.CraftRole{
					RoleID:   role.ID,
					RecordID: role.RecordID,
					Name:     role.Name,
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
		go func(r scheme.CraftRoleSignItem) {
			record := c.builder.GetCraftRecord(r.RecordID)
			if record == nil {
				wg.Done()
				return
			}
			record.prepare(r.Manual) // 清理历史记录，整理阵容、卡牌属性
			broken := record.checkBroken()
			if broken {
				wg.Done()
			} else {
				roles <- r
			}
		}(role)
	}

	wg.Wait()
	close(roles)

	util.WithGuard(c, func() {
		roles := make(map[document.ID]*scheme.CraftRoleInfo)
		for roleID, info := range infos {
			roles[roleID] = info
		}
		c.SetCraftRoles(roles)
	})
}

func (c *Craft) updateRoleInfo(roleID document.ID, result string, point int) {
	roundidx := RoundNextMap[c.Round()].idx
	roles := c.CraftRoles()
	role := roles[roleID]
	role.Round = roundidx
	role.Point += point
	if result == "win" {
		role.Win += 1
	}
	c.SetCraftRoles(roles)
}

func (c *Craft) SetAgentManager(name string, agent service.IService) {
	if c.mgr != nil {
		c.mgr.Stop()
		c.mgr = nil
	}
	c.mgr = manager.NewAgentManager(name, "NewCraftBattle", agent)
}

// 开始准备参赛名单和匹配 closed -> prepare
func (c *Craft) onStartPrepare(buff []int) {
	var round string
	util.WithGuard(c, func() {
		c.reset()
		round = "prepare"
		c.SetRound(round)
		c.SetBuffs(buff)
	})
	log.Infof("Craft.onStartPrepare %s", round)

	go func() {
		// 冻结报名, 强制与game同步报名列表
		response := c.eventToGame("prepare", EventToGame{}, true)
		if response == nil {
			log.Warningf("may be some error happened")
			return
		}
		signup := response.Signup
		c.addSignupRole(signup)
		log.Debugf("signup %d, craft roles %d", len(signup), len(c.CraftRoles()))
		atomic.StoreInt32(&c.prepareok, 1)

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

// 匹配
func (c *Craft) onMatch() {
	var round string
	util.WithGuard(c, func() {
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
		record := c.builder.GetCraftRecord(recordID)
		signList[roleID] = cards{
			cards:   record.Cards(),
			display: record.TopDisplay(),
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
	log.Infof("Craft.startRound %s prepare Signup %d Roles %d Matches %d Outs %d", round, len(c.CraftRoles()), len(signList), len(c.matchList), outs)
}

// 开始一局准备, 计算参赛名单和匹配
func (c *Craft) onStartRound() {
	var round string
	util.WithGuard(c, func() {
		round = RoundNextMap[c.Round()].next
		c.SetRound(round)
	})
	log.Infof("Craft.startRound %s", round)

	// 停止上次的查询定时器
	c.mgr.Stop()

	for _, outRoleID := range c.outList {
		c.outs.Store(outRoleID, true)
	}
	roles := c.getLastRankRoles()
	c.makeMatchHistory(round, c.matchList)

	c.eventToGame("matches", EventToGame{LastRankRoles: roles}, true)
	atomic.StoreInt32(&c.lockcard, 0)

	// 战斗开始始倒计时
	elapsed := c.getElapsedDuration()
	duration := BattlePreReadyDuration - elapsed
	if isInFinal(round) {
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

	// 冻结布阵
	c.eventToGame("play", EventToGame{}, true)
	atomic.StoreInt32(&c.lockcard, 1)

	// 战斗结束倒计时
	duration := BattleDuration
	if TestInQuick {
		duration = TestBattleDuration
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
					log.Warningf("queryAgentMgr waitting first make end")
					t.Reset(BattleQueryDuration)
					continue
				}
				resume := true
				s1 := util.Now()
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
				s2 := util.Now()
				leftplays := c.checkPlayEnd()
				if leftplays == 0 {
					resume = false
				}
				now := util.Now()
				log.Infof("queryAgentMgr result %d local %d timer %v, dlt1 %s dlt2 %s", len(results), leftplays, resume, now.Sub(s1), now.Sub(s2))
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

type battleinfo struct {
	role1   document.ID
	record1 document.ID
	role2   document.ID
	record2 document.ID
}

func (c *Craft) makePlayAndRun() {
	// 可能多次进入
	round := c.Round()
	start := time.Now()

	newjob := func(roleID1, recordID1, roleID2, recordID2 document.ID) func() {
		return func() {
			time.Sleep(time.Second * time.Duration(rand.Intn(5))) // TODO: 临时分摊mongo的创建数据量
			var v [2]*Record
			v[0] = c.builder.GetCraftRecord(recordID1)
			if roleID2 != "" {
				v[1] = c.builder.GetCraftRecord(recordID2)
				c.recordBack(round, battleroles{roleID1, roleID2}, v[0], v[1])
			} else { // 轮空
				c.recordBack(round, battleroles{roleID1, roleID2}, v[0], nil)
			}
		}
	}

	roundresults := c.RoundResults()[round]
	total := len(roundresults)
	battles := make([]battleinfo, 0, total)
	for _, roundresult := range roundresults {
		if roundresult.PlayID != "" { // 已经构建了战斗
			continue
		}
		role1 := c.CraftRoles()[roundresult.Roles[0]]
		battle := battleinfo{
			role1:   role1.RoleID,
			record1: role1.RecordID,
		}
		if len(roundresult.Roles) == 2 {
			role2 := c.CraftRoles()[roundresult.Roles[1]]
			battle.role2 = role2.RoleID
			battle.record2 = role2.RecordID
		}
		battles = append(battles, battle)
	}
	count := len(battles)
	var wg sync.WaitGroup
	wg.Add(count)
	for _, battle := range battles {
		job := newjob(battle.role1, battle.record1, battle.role2, battle.record2)
		go func() {
			job()
			wg.Done()
		}()
	}
	wg.Wait()

	log.Infof("makePlayAndRun %d make %d play cost %v", total, count, time.Now().Sub(start))

	c.makePlayEnd()
}

func (c *Craft) recordBack(round string, roles battleroles, record1 *Record, record2 *Record) {
	var display1, display2 map[string]int
	if isInFinal(round) {
		display1 = record1.TopDisplay()
		display2 = record2.TopDisplay()
	}
	if record2 == nil { // 轮空
		model := NewByePlayModel(round, record1)
		util.WithGuard(c, func() {
			c.newPlay(ByeBattlePlayID, roles, model, display1, display2)
			c.recordPlayResult(ByeBattlePlayID, "win", [2]int{model.Point, model.DefencePoint})
		})
		// Record 记录历史
		record1.addByeHistory(model)
		c.pushPlayResultToGame(model)
	} else {
		roleID1, roleID2 := record1.RoleDbId(), record2.RoleDbId()
		model := NewPlayModel(round, record1, record2, c.Buffs())
		if isRobot(roleID1) && isRobot(roleID2) { // 机器人对机器人直接计算胜负
			result, points := CalcRobotPlayResult(model)
			util.WithGuard(c, func() {
				c.newPlay(RobotBattlePlayID, roles, model, display1, display2)
				c.recordPlayResult(RobotBattlePlayID, result, points)
			})
			model.ID = RobotBattlePlayID
			model.Result = result
			model.Point = points[0]
			model.DefencePoint = points[1]
			// Record 记录历史
			record1.addHistoryFromPlay(model)
			record2.addHistoryFromPlay(model)
			c.pushPlayResultToGame(model)
		} else {
			play := c.builder.CreateCraftPlayRecord(model)
			util.WithGuard(c, func() {
				c.newPlay(play.GetID(), roles, model, display1, display2)
			})
			// 发送给反作弊计算
			db, unlock := play.LockAndGetDB()
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
	c.RLock()
	round := c.Round()
	results := c.RoundResults()[round]
	c.RUnlock()

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
			util.WithGuard(c, func() {
				rr := c.recordPlayResult(id, ret.Result, [2]int{ret.Point1, ret.Point2})
				roleID1, roleID2 := rr[0], rr[1]
				recordID1 = c.CraftRoles()[roleID1].RecordID
				recordID2 = c.CraftRoles()[roleID2].RecordID
			})
			playRecord := c.builder.GetCraftPlayRecord(id)
			playRecord.SetResult(ret.Result)
			playRecord.SetPoint(ret.Point1)
			playRecord.SetDefencePoint(ret.Point2)
			record1 := c.builder.GetCraftRecord(recordID1)
			record2 := c.builder.GetCraftRecord(recordID2)

			db, unlock := playRecord.LockAndGetDB()
			defer unlock()
			record1.addHistoryFromPlay(db)
			record2.addHistoryFromPlay(db)
			c.pushPlayResultToGame(db)
		}
	}
	if resend {
		// log.Warningf("resend play %v", id)
		model := c.builder.GetCraftPlayRecord(id)
		db, unlock := model.LockAndGetDB()
		defer unlock()
		if resetSeed {
			model.resetRandSeed()
		}
		c.mgr.SendPlay(id, db)
	}
}

func (c *Craft) onPlayEnd() {
	for atomic.LoadInt32(&c.playstatus) != 2 {
		time.Sleep(time.Second * 5)
	}
	// 停止查询定时器
	c.mgr.Stop()

	round := c.Round()
	nextRound := RoundNextMap[round].next
	if nextRound == "over" {
		c.onOver()
	} else {
		c.onStartRound()
	}
}

func (c *Craft) getLastRankRoles() map[document.ID][3]int {
	roles := make(map[document.ID][3]int)
	c.roleMatchHistory.Range(func(key, value interface{}) bool {
		id := key.(document.ID)
		if isRobot(id) {
			return true
		}
		role := c.CraftRoles()[id]
		roles[id] = [3]int{role.Round, role.Win, role.Point}
		return true
	})
	return roles
}

func (c *Craft) getFinalRoleRanks() map[int]EventToGameCraftRankItem {
	ranks := &ranks{
		items: make([]rankitem, 0, len(c.CraftRoles())),
	}
	for _, role := range c.CraftRoles() {
		ranks.items = append(ranks.items, rankitem{
			id: role.RoleID,
			items: map[string]int{
				"round": role.Round,
				"win":   role.Win,
				"point": role.Point,
				"level": role.Level,
			},
		})
	}
	ranks.keys = []string{"round", "win", "point"}
	sort.Sort(ranks)

	rr := make(map[int]EventToGameCraftRankItem)
	for i, v := range ranks.items {
		rr[i+1] = EventToGameCraftRankItem{RoleID: v.id, Level: v.items["level"]}
		if i < 20 {
			log.Infof("final rank %d %v %v", i+1, v.id, v.items)
		}
	}
	return rr
}

func (c *Craft) onOver() {
	util.WithGuard(c, func() {
		c.SetRound("over")
	})
	c.eventToGame("over", EventToGame{LastRankRoles: c.getLastRankRoles()}, true)

	// 排行奖励
	ranks := c.getFinalRoleRanks()
	c.eventToGame("rank_award", EventToGame{CraftRanks: ranks}, false)

	// 战斗奖励
	roles := make(map[document.ID][4]int)
	for _, role := range c.CraftRoles() {
		if isRobot(role.RoleID) {
			continue
		}
		roles[role.RoleID] = [4]int{role.Round, role.Win, role.Point, role.Level}
	}
	c.eventToGame("battle_award", EventToGame{CraftRoles: roles}, false)

	// 下注奖励
	c.RLock()
	bets := c.Bet()
	rolebets := make(map[document.ID][3]interface{}) // {roleiD: (winName, winGold, level)}
	top8 := make(map[document.ID]bool)
	for i := 1; i <= 8; i++ {
		roleID := ranks[i].RoleID
		top8[roleID] = true
		bet, ok := bets[roleID]
		if !ok {
			continue
		}
		name := bet.Role.Name
		rate := bet.Rate
		cfg := GetConfig()
		for betRoleID, gold := range bet.Gold {
			if i == 1 { // 冠军
				gold := int(float64(gold) * rate)
				if gold > cfg.MaxBetWin {
					gold = cfg.MaxBetWin
				}
				rolebets[betRoleID] = [3]interface{}{name, gold, "champion"}
			} else { // 未获得冠军，但是进入八强，会获得一半的金币返还补偿
				rolebets[betRoleID] = [3]interface{}{name, gold / 2, "top8"}
			}
		}
	}
	// 下注失败
	for roleID, d := range bets {
		if top8[roleID] {
			continue
		}
		name := d.Role.Name
		for betRoleID := range d.Gold {
			rolebets[betRoleID] = [3]interface{}{name, 0, "fail"}
		}
	}
	c.RUnlock()
	c.eventToGame("bet_award", EventToGame{CraftBets: rolebets}, false)

	// 保存前20，供下期下注使用
	nextbets := make(map[document.ID]*scheme.CraftBet)
	for i := 1; i <= 20; i++ {
		rankItem, ok := ranks[i]
		if !ok {
			log.Warningf("rank %d no role", i)
			continue
		}
		roleID := rankItem.RoleID
		role := c.CraftRoles()[roleID]
		record := c.builder.GetCraftRecord(role.RecordID)
		nextbets[roleID] = &scheme.CraftBet{
			Role:          role.CraftRole,
			Rank:          i,
			Rate:          GetConfig().MinBetRate,
			Gold:          map[document.ID]int{},
			FightingPoint: record.TotalFightingPoint(),
		}
	}
	util.WithGuard(c, func() {
		c.SetBet(nextbets)
		c.clean()
	})
}

func (c *Craft) nextRoundPlayer(round string) (map[document.ID]document.ID, map[document.ID]int) {
	if strings.HasPrefix(round, "pre") {
		return c.nextPreRoundPlayer(round)
	} else if strings.HasPrefix(round, "final") {
		return c.nextFinalRoundPlayer(round)
	}
	return nil, nil
}

func (c *Craft) nextRoundMatch(round string, signList map[document.ID]cards, playerFails map[document.ID]int) (map[document.ID]cards, map[document.ID]document.ID, map[document.ID]int) {
	if round[:3] == "pre" {
		return c.nextPreRoundMatch(round, signList, playerFails)
	} else if round[:5] == "final" {
		return c.nextFinalRoundMatch(round, signList, playerFails)
	}
	return nil, nil, nil
}

func (c *Craft) nextPreRoundPlayer(round string) (map[document.ID]document.ID, map[document.ID]int) {
	players := make(map[document.ID]document.ID) // {role.id: record.id}
	playerFails := make(map[document.ID]int)
	// 如果玩家负场累计至三场，则自动淘汰出局
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

func (c *Craft) nextFinalRoundPlayer(round string) (map[document.ID]document.ID, map[document.ID]int) {
	top8Map := make(map[int]document.ID)
	playerFails := make(map[document.ID]int)
	roundIdx := RoundNextMap[round].idx - RoundNextMap["final1"].idx
	if round == "final1" {
		// 根据胜场数和积分的排名，选出前8的玩家进入8强决赛
		roles := make(sortRoles, 0, len(c.CraftRoles()))
		for _, role := range c.CraftRoles() {
			roles = append(roles, role)
			playerFails[role.RoleID] = FailOut // 全部人员先当淘汰
		}
		sort.Sort(roles)
		rank := 0
		for _, role := range roles {
			rank += 1
			top8Map[rank] = role.RoleID
			playerFails[role.RoleID] = 0 // 0表示没淘汰
			log.Infof("final player rank %d role %v win %d point %d robot %v", rank, role.RoleID, role.Win, role.Point, isRobot(role.RoleID))
			if rank >= 8 {
				break
			}
		}
	} else {
		// 从上一场战斗数据中计算
		preRoundIdx := roundIdx - 1
		for _, kk := range Top8PlayKeyRound[preRoundIdx] {
			play := c.Top8Plays()[Top8PlayKeyMap[kk]]
			var winRoleID, failRoleID document.ID
			if play.Result == "win" {
				winRoleID = play.Role1.RoleID
				failRoleID = play.Role2.RoleID
			} else {
				winRoleID = play.Role2.RoleID
				failRoleID = play.Role1.RoleID
			}
			key := calcNextTop8PlayKey(kk[0], kk[1])
			top8Map[key] = winRoleID
			if round == "final3" {
				top8Map[-key] = failRoleID // 参加季军赛
			} else {
				playerFails[winRoleID] = 0
				playerFails[failRoleID] = FailOut // 淘汰
			}
		}
	}

	players := make(map[document.ID]document.ID) // {role.id: record.id}
	for _, roleID := range top8Map {
		players[roleID] = c.CraftRoles()[roleID].RecordID
	}

	// 初始化每轮top8_plays对阵
	c.battleKeys = make(map[battleroles]string)
	for _, kk := range Top8PlayKeyRound[roundIdx] {
		role1, role2 := top8Map[kk[0]], top8Map[kk[1]]
		key := battleroles{role1, role2}
		c.battleKeys[key] = Top8PlayKeyMap[kk]
	}

	return players, playerFails
}

func (c *Craft) makeMatch(roles []document.ID) ([]battleroles, document.ID) {
	// 优先匹配人vs机器人
	matchs := make([]battleroles, 0, len(roles)/2)
	robotRoleIDs := make([]document.ID, 0, len(roles))
	realRoleIDs := make([]document.ID, 0, len(roles))
	for _, id := range roles {
		if isRobot(id) {
			robotRoleIDs = append(robotRoleIDs, id)
		} else {
			realRoleIDs = append(realRoleIDs, id)
		}
	}
	least := len(robotRoleIDs)
	var leftRoleIDs []document.ID
	if least > len(realRoleIDs) {
		least = len(realRoleIDs)
		leftRoleIDs = robotRoleIDs[least:]
	} else {
		leftRoleIDs = realRoleIDs[least:]
	}
	for i := 0; i < least; i++ {
		matchs = append(matchs, battleroles{realRoleIDs[i], robotRoleIDs[i]})
	}
	if len(leftRoleIDs) > 0 {
		rand.Shuffle(len(leftRoleIDs), func(i, j int) {
			leftRoleIDs[i], leftRoleIDs[j] = leftRoleIDs[j], leftRoleIDs[i]
		})
		n := len(leftRoleIDs) / 2
		for i := 0; i < n; i++ {
			matchs = append(matchs, battleroles{leftRoleIDs[i*2], leftRoleIDs[i*2+1]})
		}
		// 最后一人轮空
		if len(leftRoleIDs)%2 == 1 {
			return matchs, leftRoleIDs[len(leftRoleIDs)-1]
		}
	}

	return matchs, ""
}

func (c *Craft) nextPreRoundMatch(round string, signList map[document.ID]cards, playerFails map[document.ID]int) (map[document.ID]cards, map[document.ID]document.ID, map[document.ID]int) {
	// 处理没有卡牌的情况
	emptyroles := make(map[document.ID]bool)
	total := RoundNextMap[round].idx - 1
	for id, v := range signList {
		if v.cards[total] == "" {
			emptyroles[id] = true
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

	c.battleKeys = make(map[battleroles]string)
	matchList := make(map[document.ID]document.ID)
	// 初始化 round_results
	vsResult := make(map[string]*scheme.CraftResultInfo)
	// 每轮玩家匹配和自己胜场数一致的玩家，优先从高胜场的玩家开始排位
	wins := make([]int, 0, len(c.winRoleMap))
	for win := range c.winRoleMap {
		wins = append(wins, win)
	}
	sort.Sort(sort.Reverse(sort.IntSlice(wins)))
	count := 0
	for _, win := range wins {
		roleIDs := c.winRoleMap[win]
		matchs, leftRoleID := c.makeMatch(roleIDs)
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
			c.battleKeys[roles] = key
			info := &scheme.CraftResultInfo{}
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

func (c *Craft) nextFinalRoundMatch(round string, signList map[document.ID]cards, playerFails map[document.ID]int) (map[document.ID]cards, map[document.ID]document.ID, map[document.ID]int) {
	// 固定对阵
	matchList := make(map[document.ID]document.ID)
	// 初始化round_results
	vsResult := make(map[string]*scheme.CraftResultInfo)
	// 初始化每轮top8_plays对阵
	plays := c.Top8Plays()
	for roles, key := range c.battleKeys {
		roleID1, roleID2 := roles[0], roles[1]
		vsResult[key] = &scheme.CraftResultInfo{Roles: []document.ID{roles[0], roles[1]}}
		matchList[roleID1] = roleID2
		matchList[roleID2] = roleID1

		plays[key] = &scheme.CraftTop8Play{
			Role1: scheme.CraftBattleRole{
				CraftRole: c.CraftRoles()[roleID1].CraftRole,
				Display:   signList[roleID1].display,
			},
			Role2: scheme.CraftBattleRole{
				CraftRole: c.CraftRoles()[roleID2].CraftRole,
				Display:   signList[roleID2].display,
			},
		}
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

func (c *Craft) newPlay(playID document.ID, roles battleroles, model *scheme.CraftPlayRecord, display1, display2 map[string]int) {
	key := c.battleKeys[roles]
	v := c.RoundResults()
	vv := v[c.Round()]
	vv[key].PlayID = playID
	vv[key].Result = "unknown"
	c.SetRoundResults(v)
	c.playMap.Store(playID, roles)

	// 保存top8_plays信息
	if isInFinal(c.Round()) {
		cards, fightingpoint := filterEmptyCards(model.Cards, model.CardAttrs)
		cards2, fightingpoint2 := filterEmptyCards(model.DefenceCards, model.DefenceCardAttrs)
		role1 := *c.CraftRoles()[roles[0]]
		role2 := *c.CraftRoles()[roles[1]]
		plays := c.Top8Plays()
		plays[key] = &scheme.CraftTop8Play{
			PlayID: playID,
			Role1: scheme.CraftBattleRole{
				CraftRole:     role1.CraftRole,
				FightingPoint: fightingpoint,
				Cards:         cards,
				Display:       display1,
			},
			Role2: scheme.CraftBattleRole{
				CraftRole:     role2.CraftRole,
				FightingPoint: fightingpoint2,
				Cards:         cards2,
				Display:       display2,
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
	key := c.battleKeys[rr]
	v := c.RoundResults()
	vv := v[c.Round()]
	vv[key].Result = result
	vv[key].Points = points
	c.SetRoundResults(v)

	c.updateRoleInfo(rr[0], result, points[0])
	if rr[1] != "" {
		result2 := "win"
		if result == "win" {
			result2 = "fail"
		}
		c.updateRoleInfo(rr[1], result2, points[1])
	}

	// 如果是决赛，另外要保存到top8_plays
	if isInFinal(c.Round()) {
		plays := c.Top8Plays()
		plays[key].Result = result
		plays[key].Points = points
		c.SetTop8Plays(plays)
		// 冠军赛和季军赛特殊处理，使其排名最高
		// 冠军+3(16)，亚军+2(15)，季军+1(14)
		winRole, failRole := rr[0], rr[1]
		if result == "fail" {
			winRole, failRole = rr[1], rr[0]
		}
		roles := c.CraftRoles()
		if key == "third" {
			roles[winRole].Round = 14
		}
		if key == "champion" {
			roles[failRole].Round = 15
			roles[winRole].Round = 16
		}
		c.SetCraftRoles(roles)
	}
	return rr
}

func (c *Craft) pushPlayResultToGame(model *scheme.CraftPlayRecord) {
	// 本轮战况
	if match, ok := c.roleMatchHistory.Load(model.RoleDbId); ok {
		history := match.(*matchHistory)
		history.Result = model.Result
		history.Point = model.Point
	}
	if model.DefenceRoleDbId != "" {
		if match, ok := c.roleMatchHistory.Load(model.DefenceRoleDbId); ok {
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
		if count, loaded := c.winningstreak.LoadOrStore(model.RoleDbId, 1); loaded {
			streak = count.(int) + 1
			c.winningstreak.Store(model.RoleDbId, streak)
		}
		c.winningstreak.Delete(model.DefenceRoleDbId)
	} else {
		if count, loaded := c.winningstreak.LoadOrStore(model.DefenceRoleDbId, 1); loaded {
			streak = count.(int) + 1
			c.winningstreak.Store(model.DefenceRoleDbId, streak)
		}
		c.winningstreak.Delete(model.RoleDbId)
	}

	message := &BattleMessage{
		Round:  model.Round,
		Result: model.Result,
		Roles:  [2]document.ID{model.RoleDbId, model.DefenceRoleDbId},
		Points: [2]int{model.Point, model.DefencePoint},
		Streak: streak,
	}

	c.eventToGame("new_play", EventToGame{BattleMessage: message}, false)
}

func (c *Craft) GetCraftRole(id document.ID) (scheme.CraftRoleInfo, bool) {
	c.RLock()
	defer c.RUnlock()
	role := c.CraftRoles()[id]
	if role == nil {
		return scheme.CraftRoleInfo{}, false
	}
	return *role, true
}

func (c *Craft) GetVSRole(roleID document.ID) (bool, *scheme.CraftRole, string) {
	var round string
	util.WithGuard(c, func() {
		round = c.Round()
	})
	if _, ok := c.outs.Load(roleID); ok {
		return true, nil, round
	}
	vs, ok := c.roleMatchHistory.Load(roleID)
	if !ok {
		return false, nil, round
	}
	vsid := vs.(*matchHistory).VSID
	if vsid == "" { // 轮空
		return false, nil, round
	}
	if !isInBattle(round) { // 异步，round可能已经改变，roleMatchHistory还未清空
		return false, nil, round
	}
	role := c.CraftRoles()[vsid].CraftRole
	return false, &role, round
}

func (c *Craft) CurrentCardLockState() (locknum int, lockcardattrs bool) {
	c.RLock()
	round := c.Round()
	c.RUnlock()
	lockcardattrs = round != "signup" && round != "closed"
	if atomic.LoadInt32(&c.lockcard) == 1 {
		locknum = RoundNextMap[round].idx
		if isInFinal(round) {
			locknum = (locknum - 10) * 3
		}
	} else {
		locknum = RoundNextMap[round].idx - 1
		if isInFinal(round) {
			locknum = (locknum - 10) * 3
		}
	}
	return
}

func (c *Craft) PrepareOK() bool {
	return atomic.LoadInt32(&c.prepareok) == 1
}

func (c *Craft) syncModel() *SyncModel {
	return &SyncModel{
		Round:     c.Round(),
		Time:      c.Time(),
		Top8Plays: c.Top8Plays(),
	}
}

func (c *Craft) eventToGame(event string, data EventToGame, sync bool) *game.CraftEventResponse {
	if c.game == nil { // maybe in test model
		return nil
	}
	var model *SyncModel
	if sync {
		model = c.syncModel()
	}
	resp, err := service.Call(c.game, "CraftEvent", event, data, model)
	if err != nil {
		log.Warningf("CraftEvent %s response error %v", event, err)
		return nil
	}
	return resp.(*game.CraftEventResponse)
}

func (c *Craft) BetRole(roleID, target document.ID, gold int) (map[document.ID]scheme.CraftBet, error) {
	c.Lock()
	defer c.Unlock()

	bet := c.Bet()
	info, ok := bet[target]
	if !ok {
		return nil, errors.New("craft bet no such role")
	}
	info.Gold[roleID] = gold
	c.betsum += gold

	cfg := GetConfig()
	betsum := 0
	for _, d := range bet {
		goldsum := 0
		for _, bet := range d.Gold {
			goldsum += bet
		}
		betsum += goldsum
		if goldsum > 0 {
			rate := float64(c.betsum) * cfg.BetRateFix / float64(goldsum)
			if rate < cfg.MinBetRate {
				rate = cfg.MinBetRate
			}
			d.Rate = rate
		} else {
			d.Rate = cfg.MinBetRate
		}
	}
	c.betsum = betsum
	c.SetBet(bet)
	return c.getBetInfo(), nil
}

func (c *Craft) getBetInfo() map[document.ID]scheme.CraftBet {
	v := make(map[document.ID]scheme.CraftBet)
	for _, d := range c.Bet() {
		v[d.Role.RoleID] = scheme.CraftBet{
			Role:          d.Role,
			Rank:          d.Rank,
			Rate:          d.Rate,
			FightingPoint: d.FightingPoint,
		}
	}
	return v
}

func (c *Craft) GetBetInfo() map[document.ID]scheme.CraftBet {
	c.Lock()
	defer c.Unlock()
	return c.getBetInfo()
}

func isInFinal(round string) bool {
	return strings.HasPrefix(round, "final")
}

func isInBattle(round string) bool {
	idx := RoundNextMap[round].idx
	return idx > 0 && idx < 14
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

type sortRoles []*scheme.CraftRoleInfo

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
	return strings.HasPrefix(s, "robot")
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

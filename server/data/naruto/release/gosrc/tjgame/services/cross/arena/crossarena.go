package arena

import (
	"errors"
	"math/rand"
	"sync"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/document/schemeutil"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	tjutil "tjgame/server_framework/tj/util"
	"tjgame/services/anti-cheat/manager"
	"tjgame/services/game"
	"tjgame/ta"
)

// CrossArenaGlobalObject
type Arena struct {
	*scheme.CrossArenaGlobalObject
	container service.IContainer
	builder   *Builder
	key       string

	mgr *manager.AgentManager
	// 状态定时器
	timer *time.Timer

	vieRankQue map[document.ID]viefor // 记录挑战 因为有start end 防止同一个人被同时挑战
	battles    sync.Map               // 预存挑战 {roleID: battle}

	roleRanks map[document.ID]document.Integer // {roleID: rank}

	track *ta.BattleCardTrack
}

func (arena *Arena) init(builder *Builder) {
	arena.builder = builder
	arena.key = arena.Key()

	arena.vieRankQue = make(map[document.ID]viefor)
	arena.roleRanks = make(map[document.ID]document.Integer, arena.RankMax())
	// 初始化 roleRanks
	ranks := arena.Ranks()
	for rank, rr := range ranks {
		arena.roleRanks[rr[0]] = rank
	}
}


// 是否结束
func (arena *Arena) IsOver() bool {
	if arena.Round() == "closed" {
		return true
	}
	date := arena.Date()
	if date == 0 {
		return true
	}
	startDate := tjutil.Int2Date(date)
	nowDate := tjutil.Int2Date(tjutil.Todayinclock5date2int())
	duration := nowDate.Sub(startDate)
	return duration > tjutil.OneDay*14
}

// 服务是否存在 server_key
func (arena *Arena) isServerOK(key string) bool {
	db := arena.GetLockedDB()
	if csv.GetMergeConfig().IsMergeKeyInServers(key, db.Servers) {
		return true
	}
	return false
}

// 反作弊管理
func (arena *Arena) SetAgentManager(name string, agent service.IService) {
	if arena.mgr != nil {
		arena.mgr.Stop()
		arena.mgr = nil
	}
	arena.mgr = manager.NewAgentManager(name, "NewCrossArenaBattle", agent)
}

// 重新初始化
func (arena *Arena) OnInit(id int, servers []string) {
	log.Infof("CrossArena.OnInit")

	// 给game的数据
	var model *DBForGame
	round := "closed"
	tjutil.WithGuard(arena, func() {
		arena.reset()
		ndt := tjutil.Todaydate2int()
		arena.SetDate(ndt)
		arena.SetCsvId(id)
		arena.SetServers(servers)
		model = arena.dbForGame()
		arena.SetNextAwardDate(0)
		arena.SetLastRefreshTime(0)
	})

	// event to game
	arena.eventToGame("init", EventToGame{Model: model}, true, false)

	log.Infof("round %s next prepare", round)
	// 初始化完立即准备
	arena.onPrepare()
}

// 准备 init -> prepare -> robot
func (arena *Arena) onPrepare() {
	log.Infof("CrossArena.onPrepare")
	round := "closed"

	prepareRes := arena.eventToGame("prepare", EventToGame{}, true, false)
	if prepareRes == nil {
		log.Warningf("may be some error happened")
		return
	}
	log.Infof("round %s next robot", round)
	minOpenDays := 0
	for _, resp := range prepareRes {
		days := resp.OpenServerDays
		if minOpenDays == 0 || days < minOpenDays {
			minOpenDays = days
		}
	}
	// 机器人加入
	robotNum := calcRobotNum(int64(minOpenDays))
	go func() {
		beforeTime := tjutil.Now()
		robots := make([]int, 0, robotNum)
		for i := 1; i <= robotNum; i++ {
			robots = append(robots, i)
		}
		rand.Shuffle(robotNum, func(i, j int) {
			robots[i], robots[j] = robots[j], robots[i]
		})
		servers := arena.Servers()
		count := len(servers)
		step := robotNum / count
		d := make(map[string]*EventToGame)
		for i, key := range servers {
			left, right := i*step, (i+1)*step
			if i == (count - 1) {
				right = robotNum
			}
			d[key] = &EventToGame{
				OpenDay:    minOpenDays,
				RobotRanks: robots[left:right],
			}
		}
		robotResp := arena.eventToSomeGame("robot", d, false)
		if robotResp == nil {
			log.Warningf("may be some error happened")
			return
		}
		_, unlock := arena.LockAndGetDB()
		defer unlock()
		for key, resp := range robotResp {
			arena.addRobotArenaRoles(key, resp.Robots)
			log.Infof("%s robot %d in prepare, Cross Arena roles %d", key, len(resp.Robots), len(arena.ArenaRoles()))
		}
		// 计算构建机器人时间
		runTime := tjutil.Now().Sub(beforeTime)
		log.Infof("makeRobots runTime %s", runTime)
		// 检查机器人是否正确
		if !arena.checkRoleRankRight() {
			log.Warningf("make robot error")
			return
		}

		// 倒计时
		now := tjutil.Now()
		duration := startTime.Combine(now).Sub(now)

		if TestInQuick {
			duration = TestRobotDuration
		}
		log.Infof("round %s next %s time delta %s", round, "start", duration)
		arena.timer = time.AfterFunc(duration, arena.onStart)
	}()
}

// 赛季开始 robot -> start
func (arena *Arena) onStart() {
	round := "start"
	nextAwardDate := arena.NextAwardDate()
	tjutil.WithGuard(arena, func() {
		arena.SetRound(round)
		arena.SetNextAwardDate(arena.NextAwardDate() + 1)
	})
	log.Infof("CrossArena.onStart %s", round)

	arena.eventToGame("start", EventToGame{}, true, false)

	// 倒计时 首日结算称号
	duration := closeTime.CombineDateInt(arena.Date()).AddDate(0, 0, nextAwardDate).Sub(tjutil.Now())
	if duration < 0 {
		duration = closeTime.CombineDateInt(arena.Date()).AddDate(0, 0, arena.NextAwardDate()).Sub(tjutil.Now())
	}
	log.Infof("Start nextAwardDate %d delta %s", arena.NextAwardDate(), duration)
	arena.timer = time.AfterFunc(duration, arena.onEventStage)
}

// 赛季7日奖励 start -> sevenDaysAward
func (arena *Arena) onSevenDaysAward() {
	log.Infof("CrossArena.onSevenDaysAward")
	// 七日奖励发放
	d := arena.onRankAward()
	arena.eventToSomeGame("sevenDaysAward", d, true)
	log.Infof("round %s next %s", "start", "closed")
}

// 赛季结束 sevenDaysAward -> closed
func (arena *Arena) onClosed() {
	round := "closed"
	tjutil.WithGuard(arena, func() {
		arena.SetRound(round)
	})
	log.Infof("CrossArena.onClosed %s", round)

	lastRanks := arena.transRankModels()
	// 返回game上次最新的精彩战报
	topBattleHistories := arena.LastTopBattleHistory()
	arena.eventToGame("closed", EventToGame{LastRanks: lastRanks, TopBattleHistory: topBattleHistories}, true, false)

	log.Infof("round %s next finishAward", round)

	// 发赛季结束奖励
	arena.onFinishAward()
	tjutil.WithGuard(arena, arena.clean)
}

// 赛季结束奖励 closed -> finishAward
func (arena *Arena) onFinishAward() {
	log.Infof("CrossArena.onFinishAward")

	d := arena.onRankAward()
	arena.eventToSomeGame("finishAward", d, true)
}

func (arena *Arena) onEventStage() {
	log.Infof("CrossArena.onEventStage nextAwardDate %d", arena.NextAwardDate())
	nextAwardDate := arena.NextAwardDate()
	tjutil.WithGuard(arena, func() {
		arena.SetNextAwardDate(arena.NextAwardDate() + 1)
	})
	if nextAwardDate == 7 {
		arena.onSevenDaysAward()
	} else if nextAwardDate >= 14 {
		arena.onClosed()
	}

	// 结束日不发每日称号
	if arena.Round() == "start" {
		duration := closeTime.CombineDateInt(arena.Date()).AddDate(0, 0, nextAwardDate).Sub(tjutil.Now())
		if duration < 0 {
			arena.onEventStage()
		} else {
			arena.onRankTitle()
			log.Infof("Next nextAwardDate %d delta %s", arena.NextAwardDate(), duration)
			arena.timer = time.AfterFunc(duration, arena.onEventStage)
		}
	}
}

// 赛季中每日结算发放称号
func (arena *Arena) onRankTitle() {
	log.Infof("CrossArena.onRankTitle")
	d := arena.onRankAward()
	arena.eventToSomeGame("rankTitle", d, true)
}

// 中途重启
func (arena *Arena) ResetToday() {
	round := arena.Round()
	date := arena.Date()
	server := arena.Servers()
	csvID := arena.CsvId()
	log.Infof("Cross Arena.ResetToday date %d round %s", date, round)
	ndt := tjutil.Todaydate2int()

	if round == "closed" {
		// 如果是今天，重新 OnInit
		if ndt == date {
			arena.OnInit(csvID, server)
		}
	} else if round == "start" {
		// 定时器
		nextAwardDate := arena.NextAwardDate()
		days := nextAwardDate - 1
		duration := closeTime.CombineDateInt(arena.Date()).AddDate(0, 0, days).Sub(tjutil.Now())
		log.Infof("Restart %s nextAwardDate %d delta %s", round, nextAwardDate, duration)
		arena.timer = time.AfterFunc(duration, arena.onEventStage)

		db, unlock := arena.LockAndGetDB()
		tjutil.WithDefer(func() {
			// 初始化精彩战报
			cfg := GetConfig()
			lastTime := tjutil.NowTime2Peroid(cfg.TopBattleHistoryPeriods)
			if db.LastRefreshTime != lastTime {
				arena.SetLastRefreshTime(lastTime)
				arena.refreshTopBattleHistories()
			}
		}, unlock)
	} else {
		panic("Restart round error")
	}
}

// OnInit 时需要重置数据
func (arena *Arena) reset() {
	arena.clean()
	log.Infof("Cross Arena Reset %d %s", arena.Date(), arena.Round())
	arena.SetDate(0)

	arena.SetArenaRoles(map[document.ID]*scheme.CrossArenaRoleInfo{})
	arena.SetEnemyRanks(map[document.ID][]int{})
	arena.SetRanks(map[document.Integer][2]document.ID{})
	arena.SetRankMax(0)
	arena.SetTopBattleHistory([]scheme.CrossArenaTopBattleHistory{})
	arena.SetLastTopBattleHistory([]scheme.CrossArenaTopBattleHistory{})
}

// 赛季结束就进行clean
func (arena *Arena) clean() {
	log.Infof("Cross Arena Clean %d %s", arena.Date(), arena.Round())
	arena.SetRound("closed")
}

// 事件触发到game (init、prepare、robot、start、close)
func (arena *Arena) eventToGame(event string, data EventToGame, sync bool, mergeFilter bool) map[string]*game.CrossArenaEventResponse {
	servers := arena.Servers()
	if mergeFilter {
		servers = csv.GetMergeConfig().FilterMergeServer(servers)
	}

	d := make(map[string]*EventToGame)
	for _, key := range servers {
		d[key] = &data
	}
	return arena.eventToSomeGame(event, d, sync)
}

// 事件触发到对应game (sevenDaysAward、finishAward)
func (arena *Arena) eventToSomeGame(event string, d map[string]*EventToGame, sync bool) map[string]*game.CrossArenaEventResponse {
	var model *SyncModel
	if sync {
		model = arena.syncModel()
	}
	keys := make([]string, 0, len(d))
	futures := make([]*service.Future, 0, len(d))
	for key, data := range d {
		s := arena.container.GetService(key)
        if s == nil {
            log.Warningf("eventToSomeGame: service for key=%s is nil, skip event=%s", key, event)
            continue
        }
		keys = append(keys, key)
		future := service.CallAsync(s, "CrossArenaEvent", event, key, data, model)
		futures = append(futures, future)
	}

	ret := make(map[string]*game.CrossArenaEventResponse)
	resp, err := service.MultiFuture(futures, false).Get()
	if err != nil {
		log.Warningf("CrossArenaEvent %s response error %v", event, err)
		return nil
	}
	response := resp.([]interface{})
	for i, key := range keys {
		ret[key] = response[i].(*game.CrossArenaEventResponse)
	}
	return ret
}

// 机器人批量添加到ArenaRoles
func (arena *Arena) addRobotArenaRoles(key string, robots map[int]*scheme.CrossArenaRoleInfo) {
	db := arena.GetLockedDB()

	// RankMax、ArenaRoles、Ranks
	for rank, robot := range robots {
		robot.GameKey = key
		robot.Rank = rank
		robot.TopRank = rank

		db.ArenaRoles[robot.RoleID] = robot
		db.Ranks[document.Integer(rank)] = [2]document.ID{robot.RoleID, robot.RecordID}
		if int64(rank) > db.RankMax {
			db.RankMax = int64(rank)
		}
		arena.roleRanks[robot.RoleID] = document.Integer(rank)
	}
	arena.SetRankMax(db.RankMax)
	arena.SetArenaRoles(db.ArenaRoles)
	arena.SetRanks(db.Ranks)
}

func (arena *Arena) checkRoleRankRight() bool {
	db := arena.GetLockedDB()
	flag := true
	for i := 1; i <= int(db.RankMax); i++ {
		if v, ok := db.Ranks[document.Integer(i)]; ok {
			if _, ok := db.ArenaRoles[v[0]]; !ok {
				flag = false
				log.Warningf("not found role %v, rank %v", v[0], i)
			}
		} else {
			flag = false
			log.Warningf("not found rank %d", i)
		}
	}
	return flag
}

// 同步model
func (arena *Arena) syncModel() *SyncModel {
	return &SyncModel{
		Round: arena.Round(),
	}
}

// 获取角色排名
func (arena *Arena) getRoleRank(roleID document.ID) (int, error) {
	db, unlock := arena.LockAndGetDB()
	defer unlock()

	if rank, ok := arena.roleRanks[roleID]; ok {
		return int(rank), nil
	}
	if roleInfo, ok := db.ArenaRoles[roleID]; ok {
		return roleInfo.Rank, nil
	} else {
		return 0, errors.New("ArenaRoles not found the role")
	}
}

// 同步到game
func (arena *Arena) dbForGame() *DBForGame {
	db := arena.GetLockedDB()
	return &DBForGame{
		Servers: db.Servers,
		CsvId:   db.CsvId,
		Date:    db.Date,
		Round:   db.Round,
	}
}

// 战斗缓存
func (arena *Arena) storeForRole(rank int, roleID, enemyRoleID, recordID, enemyRecordID document.ID) error {
	db, unlock := arena.LockAndGetDB()
	defer unlock()

	// 判断对手排名是否发生改变
	rr := db.Ranks[document.Integer(rank)] //（roleID, recordID)
	if rr[0] != enemyRoleID && rr[1] != enemyRecordID {
		return ErrRankEnemyChanged
	}

	// 判断对手是否正在战斗
	if v, ok := arena.vieRankQue[enemyRoleID]; ok {
		if time.Now().Unix()-v.time < 60 {
			return ErrInBattle
		}
	}

	arena.vieRankQue[enemyRoleID] = viefor{roleID, recordID, enemyRoleID, enemyRecordID, time.Now().Unix()}
	return nil
}

// 战斗结果处理
func (arena *Arena) resultForRole(roleID, enemyRoleID document.ID, result string) (int, int, error) {
	// lock for swapRank and cross arena self
	db, unlock := arena.LockAndGetDB()
	defer unlock()

	v, ok := arena.vieRankQue[enemyRoleID]
	if !ok {
		return 0, 0, ErrNotInBattle
	}
	if v.role != roleID {
		return 0, 0, errors.New("not your battle")
	}
	// 删除战斗缓存
	delete(arena.vieRankQue, enemyRoleID)
	// 排名交换
	oldRank := arena.roleRanks[roleID]
	newRank := arena.roleRanks[enemyRoleID]
	// 赢和排名交换都清对手
	if result == "win" {
		delete(db.EnemyRanks, roleID)
		if oldRank > newRank {
			arena.swapRank(oldRank, newRank)
			delete(db.EnemyRanks, enemyRoleID)
		}
		arena.SetEnemyRanks(db.EnemyRanks)
	}
	return int(oldRank), int(newRank), nil
}

// 战斗后交换排名
func (arena *Arena) swapRank(oldRank document.Integer, newRank document.Integer) {
	db := arena.GetLockedDB()

	ranks := db.Ranks
	oldrole := ranks[oldRank]
	newrole := ranks[newRank]
	// 更新ArenaRoles的排名
	arenaRoles := db.ArenaRoles
	oldRoleRank := arenaRoles[oldrole[0]].Rank
	newRoleRank := arenaRoles[newrole[0]].Rank
	arenaRoles[oldrole[0]].Rank = newRoleRank
	arenaRoles[newrole[0]].Rank = oldRoleRank
	arena.SetArenaRoles(arenaRoles)
	// 更新ranks
	ranks[oldRank] = newrole
	ranks[newRank] = oldrole
	arena.SetRanks(ranks)
	// 更新roleRanks缓存
	arena.roleRanks[newrole[0]] = oldRank
	arena.roleRanks[oldrole[0]] = newRank
}

// 匹配对手 跟段位无关
func (arena *Arena) matchingEnemys(roleID document.ID) []int {
	db := arena.GetLockedDB()

	enemys := make([]int, 0, 4)
	var rank int
	if r, ok := arena.roleRanks[roleID]; ok {
		rank = int(r)
	} else if roleInfo, ok := db.ArenaRoles[roleID]; ok {
		rank = int(roleInfo.Rank)
	}
	ranges := GetConfig().PWRanges

	if rr := ranges.GetRange(rank); rr != nil {
		pwrange := rr.(*PWRange)
		enemys = pwrange.getEnemys(rank, 4, int(db.RankMax))
	} else {
		log.Warningf("rank %d can not get range", rank)
	}
	enemyRanks := db.EnemyRanks
	enemyRanks[roleID] = enemys
	arena.SetEnemyRanks(enemyRanks)

	return enemys
}

// 获取要挑战的对手
func (arena *Arena) getBattleEnemys(roleID document.ID, refresh bool) []scheme.CrossArenaRoleInfo {
	db := arena.GetLockedDB()

	enemys := make([]scheme.CrossArenaRoleInfo, 0)
	ranks := make([]int, 0, 4)
	// 重新匹配对手
	if refresh {
		ranks = arena.matchingEnemys(roleID)
	} else {
		if _, ok := db.EnemyRanks[roleID]; !ok {
			ranks = arena.matchingEnemys(roleID)
		} else {
			ranks = db.EnemyRanks[roleID]
		}
	}
	for _, rank := range ranks {
		enemyRoleID := db.Ranks[document.Integer(rank)][0]
		roleInfo := db.ArenaRoles[enemyRoleID]
		enemys = append(enemys, *roleInfo)
	}
	return enemys
}

// 前几名排行榜
func (arena *Arena) topRanks(offset int, size int) []scheme.CrossArenaRoleInfo {
	db := arena.GetLockedDB()
	top := make([]scheme.CrossArenaRoleInfo, 0, size)
	end := offset + size
	if end >= int(db.RankMax) {
		end = int(db.RankMax)
	}
	for i := offset; i < end; i++ {
		roleID := db.Ranks[document.Integer(i+1)][0]
		top = append(top, *db.ArenaRoles[roleID])
	}
	return top
}

// 排名转换为rankModels
func (arena *Arena) transRankModels() []*scheme.CrossArenaRoleInfo {
	db, unlock := arena.RLockAndGetDB()
	defer unlock()
	rankModels := make([]*scheme.CrossArenaRoleInfo, 0)

	for i := 1; i <= int(db.RankMax); i++ {
		rr := db.Ranks[document.Integer(i)]
		roleInfo := db.ArenaRoles[rr[0]]
		rankModels = append(rankModels, roleInfo)
	}
	return rankModels
}

// 战斗结束更新排名
func (arena *Arena) battleEndUpdate(bb *battle, roleID, recordID document.ID, result string, fromAnti bool, isTopBattle bool) (map[string]int, error) {
	bb.mu.Lock()
	defer bb.mu.Unlock()

	if bb.result.anticheat != "" && bb.result.anticheat != result {
		log.Warningf("cross arena role %v play %v anti %v client %v is diff after anti", roleID, bb.playRecordID, bb.result.anticheat, result)
		return nil, ErrRankCheat
	}

	playRecord := arena.builder.GetCrossArenaPlayRecord(bb.playRecordID)
	playRecord.SetResult(result)

	// 战斗结果处理（战斗结果、排名、战斗历史）
	oldRank, newRank, err := arena.resultForRole(roleID, bb.enemyRoleID, result)
	if err != nil {
		return nil, err
	}

	var gameKey string
	var gameKey2 string
	move := 0
	rank := oldRank
	topMove := 0
	isNotice := false
	db, unlock := arena.LockAndGetDB()
	tjutil.WithDefer(func() {
		gameKey = db.ArenaRoles[roleID].GameKey
		gameKey2 = db.ArenaRoles[bb.enemyRoleID].GameKey

		topRank := db.ArenaRoles[roleID].TopRank
		if result == "win" {
			if newRank < oldRank {
				move = oldRank - newRank
				rank = newRank
				if newRank < topRank {
					db.ArenaRoles[roleID].TopRank = newRank
					arena.SetArenaRoles(db.ArenaRoles)
					topMove = topRank - newRank
				}
			}
		}

		// 加入精彩战报
		if isTopBattle && arena.isTopPlayRecord(newRank, oldRank, playRecord) {
			arena.addTopBattleHistories(newRank, oldRank, playRecord, arena.key)
		}
		// 若刷新 DB同步缓存
		cfg := GetConfig()
		lastTime := tjutil.NowTime2Peroid(cfg.TopBattleHistoryPeriods)
		if db.LastRefreshTime != lastTime {
			size := arena.refreshTopBattleHistories()
			arena.SetLastRefreshTime(lastTime)
			if size > 0 {
				isNotice = true
			}
		}
	}, unlock)
	if isNotice {
		arena.onNoticeBattleHistories()
	}

	view := map[string]int{
		"rank":      rank,
		"rank_move": move,
		"top_move":  topMove,
	}
	bb.result.view = view

	_, _ = service.Call(arena.container.GetService(service.Game2PVPService(gameKey)), "CrossArenaAddHistory", recordID, newRank, oldRank, move, playRecord, arena.key)
	_, _ = service.Call(arena.container.GetService(service.Game2PVPService(gameKey2)), "CrossArenaAddHistory", bb.enemyRecordID, oldRank, newRank, -move, playRecord, arena.key)

	if arena.track != nil && !isRobot(playRecord.DefenceRoleKey().ID) && (oldRank <= 1000 || newRank <= 1000) {
		win := result == "win"
		cards := make([]int, 0, 12)
		defencecards := make([]int, 0, 12)
		for _, v := range playRecord.Cards() {
			cards = append(cards, schemeutil.CalcBattleCards(playRecord.CardAttrs(), v)...)
		}
		for _, v := range playRecord.DefenceCards() {
			defencecards = append(defencecards, schemeutil.CalcBattleCards(playRecord.DefenceCardAttrs(), v)...)
		}
		arena.track.Track(win, cards)
		arena.track.Track(!win, defencecards)
	}

	return view, nil
}

// 添加精彩战报
func (arena *Arena) addTopBattleHistories(newRank int, oldRank int, playRecord *PlayRecord, crossKey string) {
	db := arena.GetLockedDB()

	h := scheme.CrossArenaTopBattleHistory{
		Time:     tjutil.NowTime(),
		Result:   playRecord.Result(),
		CrossKey: crossKey,

		PlayRecordID: playRecord.GetID(),

		RoleKey:  playRecord.RoleKey(),
		RecordID: playRecord.RecordDbId(),
		Name:     playRecord.Name(),
		Logo:     playRecord.Logo(),
		Frame:    playRecord.Frame(),
		Level:    playRecord.Level(),
		Vip:      playRecord.Vip(),
		Rank:     oldRank,

		DefenceRoleKey:  playRecord.DefenceRoleKey(),
		DefenceRecordID: playRecord.DefenceRecordId(),
		DefenceName:     playRecord.DefenceName(),
		DefenceLogo:     playRecord.DefenceLogo(),
		DefenceFrame:    playRecord.DefenceFrame(),
		DefenceLevel:    playRecord.DefenceLevel(),
		DefenceVip:      playRecord.DefenceVip(),
		DefenceRank:     newRank,
	}
	tempHistory := db.TopBattleHistory
	// 重复对战玩家 去重
	histories := make([]scheme.CrossArenaTopBattleHistory, 0, 10)
	for i, h := range tempHistory {
		if h.RoleKey.ID == playRecord.RoleKey().ID {
			histories = append(histories, tempHistory[:i]...)
			histories = append(histories, tempHistory[i+1:]...)
			break
		}
	}
	// 根据排名排序。排名相同最近时间的排前面
	newTopBattleHistories := make([]scheme.CrossArenaTopBattleHistory, 0, 12)
	rank := min(newRank, oldRank)
	if len(histories) == 0 {
		histories = append(histories, h)
		newTopBattleHistories = histories
	} else {
		for i, history := range histories {
			if rank <= min(history.Rank, history.DefenceRank) {
				newTopBattleHistories = append(newTopBattleHistories, histories[:i]...)
				newTopBattleHistories = append(newTopBattleHistories, h)
				newTopBattleHistories = append(newTopBattleHistories, histories[i:]...)
				break
			}
			if i == len(histories)-1 {
				histories = append(histories, h)
				newTopBattleHistories = histories
			}
		}
	}
	// 只存10场
	if len(newTopBattleHistories) > 10 {
		newTopBattleHistories = newTopBattleHistories[:10]
	}
	arena.SetTopBattleHistory(newTopBattleHistories)
}

// 刷新精彩战报
func (arena *Arena) refreshTopBattleHistories() int {
	log.Infof("CrossArena.refreshTopBattleHistories")
	db := arena.GetLockedDB()

	// 新的在前，不够的用上期数据在后面补
	h := db.TopBattleHistory
	temp := h
	lastHistory := db.LastTopBattleHistory
	if len(h) < 10 {
		h = append(h, lastHistory...)
		// 只展示10场
		if len(h) > 10 {
			h = h[:10]
		}
	}
	arena.SetLastTopBattleHistory(h)

	// 重置 重新收集新时间段数据
	arena.SetTopBattleHistory([]scheme.CrossArenaTopBattleHistory{})
	return len(temp)
}

// 通知 已刷新精彩战报
func (arena *Arena) onNoticeBattleHistories() {
	log.Infof("CrossArena.onNoticeBattleHistories")
	arena.eventToGame("refreshTopHistory", EventToGame{}, true, true)
}

// 判断战报是精彩对战
func (arena *Arena) isTopPlayRecord(newRank, oldRank int, playRecord *PlayRecord) bool {
	if isRobot(playRecord.RoleKey().ID) || isRobot(playRecord.DefenceRoleKey().ID) {
		return false
	}
	flag := false
	version := csv.GetConfig().Cross.Service[arena.CsvId()].Version
	cfg := GetConfig()
	if newRank < cfg.MinStageToRank[version] && oldRank < cfg.MinStageToRank[version] {
		flag = true
	}
	return flag
}

// 更新展示卡牌
func (arena *Arena) updateDisplay(roleID document.ID, display int) {
	db := arena.GetLockedDB()
	db.ArenaRoles[roleID].Display = display
	arena.SetArenaRoles(db.ArenaRoles)
}

// 赛季排行奖励
func (arena *Arena) onRankAward() map[string]*EventToGame {
	db, unlock := arena.RLockAndGetDB()
	defer unlock()

	d := make(map[string]*EventToGame) // {gameKey: EventToGame}
	for rank, rr := range db.Ranks {
		if isRobot(rr[0]) {
			continue
		}
		gameKey := db.ArenaRoles[rr[0]].GameKey
		if _, ok := d[gameKey]; !ok {
			d[gameKey] = &EventToGame{
				RoleRanks: make(map[document.ID]int),
			}
		}
		d[gameKey].RoleRanks[rr[0]] = int(rank)
	}
	return d
}

// @Time     : 2020/12/2 16:14
// @Author   : cancan
// @File     : mine.go
// @Function :

package mine

import (
	"errors"
	"math"
	"math/rand"
	"tjgame/document/schemeutil"
	anti_cheat "tjgame/services/anti-cheat"
	"tjgame/ta"

	//"math"
	//"math/rand"
	"sort"
	"sync"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	tjcsv "tjgame/server_framework/tj/csv"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	tjutil "tjgame/server_framework/tj/util"
	"tjgame/services/game"
)

type Mine struct {
	*scheme.CrossMineGlobalObject
	builder   *Builder
	container service.IContainer
	key       string
	CrossKey  string

	roleRanks       map[document.ID]document.Integer // {roleID: rank}
	vsInfos         map[document.ID]vsInfoItem       // 记录挑战 因为有start end 防止同一个人被同时挑战
	battles         sync.Map                         // 所有战斗 {roleID: *battle}
	bossBattles     sync.Map                         // 所有 boss 战斗 {roleID: *bossBattle}
	serverPoints    map[string]int                   // 服务器积分
	bossRanks       map[document.ID][]document.ID    // Boss 挑战排名
	ServerFeedRanks []document.ID                    // 全服 buff 贡献排名

	agent                 service.IService // 反作弊
	bossBattleVerifyQueue chan *bossBattle // boss 战斗校验队列

	track *ta.BattleCardTrack
}

func (m *Mine) init(builder *Builder, crossKey string, agent service.IService) {
	m.builder = builder
	m.key = m.Key()
	m.CrossKey = crossKey
	m.agent = agent

	m.vsInfos = make(map[document.ID]vsInfoItem)
	m.roleRanks = make(map[document.ID]document.Integer)
	ranks := m.Ranks()
	for rank, rr := range ranks {
		m.roleRanks[rr[0]] = rank
	}

	db, unlock := m.LockAndGetDB()
	defer unlock()
	m.resetServerFeedRanks()

	m.bossRanks = make(map[document.ID][]document.ID)

	for _, bossInfo := range db.Boss {
		m.updateBossRanks(bossInfo)
	}

	m.bossBattleVerifyQueue = make(chan *bossBattle, BossBattleVerifyQueueSize)
	go m.runBossBattleAgentVerify()
}

func (m *Mine) IsOver() bool {
	return m.isAllOver()
}

// 测试开始还没有 start 状态时姐切换
func (m *Mine) OnInit(csvID int, servers []string) {
	log.Info("CrossMine OnInit")
	var model *DBForGame
	round := "closed"
	tjutil.WithGuard(m, func() {
		m.reset()
		m.SetDate(tjutil.Todaydate2int())
		m.SetCsvId(csvID)
		m.SetServers(servers)
		m.SetNextAwardDate(0)
		m.SetLastRefreshTime(0)
		model = m.dbForGame()
	})

	resp := m.eventToGame("init", EventToGame{Model: model}, true, false)
	if resp == nil {
		log.Warningf("CrossMine prepare may be some error happened")
		return
	}
	minServerOpenDays := 0
	for _, info := range resp {
		if minServerOpenDays == 0 || info.ServerOpenDays < minServerOpenDays {
			minServerOpenDays = info.ServerOpenDays
		}
	}

	tjutil.WithGuard(m, func() {
		m.SetServerOpenDays(minServerOpenDays)
		m.initEvent()
	})

	now := tjutil.Now()
	duration := startTime.Combine(now).Sub(now)
	log.Infof("CrossMine round %s next start time delta %s", round, duration)
	// 在 onStart 切换完状态再启动资源生产
	time.AfterFunc(duration, func() {
		m.onStart()
		// closed -> start 中间有空闲时间，先重置下生产时间
		m.SetLastProductTime(tjutil.NowTime())
		go m.productMineTimer()
	})
}

func (m *Mine) reset() {
	log.Info("CrossMine reset")
	m.SetRoles(make(map[document.ID]*scheme.CrossMineRoleInfo))
	m.SetRanks(make(map[document.Integer][2]document.ID))
	m.SetRankMax(0)
	m.SetEnemyRanks(make(map[document.ID][]int))
	m.SetServerBuffInfo(make(map[string]*scheme.CrossMineServerBuffInfo))
	m.SetRoleBuffInfo(make(map[document.ID]*scheme.CrossMineRoleBuffInfo))
	m.SetLastProductTime(tjutil.NowTime())
	m.SetRoleBeRoded(make(map[document.ID]*scheme.CrossMineRoleBeRodedInfo))
	m.SetRoleBeRevenged(make(map[document.ID]map[document.ID]*scheme.CrossMineRoleBeRevengedInfo))
	m.SetBoss(make(map[document.ID]*scheme.CrossMineBoss))
	m.SetServerKillBoss(make(map[string]map[document.ID]*scheme.CrossMineServerKillBoss))
	m.SetNpc(make(map[document.ID]*scheme.CrossMineNpc))
	m.SetEventRecrod(make(map[document.Integer]bool))
	m.SetTopBattleHistory([]scheme.CrossMineTopBattleHistory{})
	m.SetLastTopBattleHistory([]scheme.CrossMineTopBattleHistory{})

	// 清理缓存排名
	m.vsInfos = make(map[document.ID]vsInfoItem)
	m.roleRanks = make(map[document.ID]document.Integer)
	m.ServerFeedRanks = []document.ID{}
	m.bossRanks = make(map[document.ID][]document.ID)
	m.serverPoints = make(map[string]int)
}

func (m *Mine) onStart() {
	round := "start"
	var date, nextAwardDate int
	bossTimeMap := make(map[document.ID][2]int)
	tjutil.WithGuard(m, func() {
		m.SetRound(round)
		m.SetRoleBeRoded(make(map[document.ID]*scheme.CrossMineRoleBeRodedInfo))
		m.SetRoleBeRevenged(make(map[document.ID]map[document.ID]*scheme.CrossMineRoleBeRevengedInfo))
		date = m.Date()
		nextAwardDate = m.NextAwardDate()
		bossTimeMap = m.getBossTimeMap()
	})

	m.eventToGame("start", EventToGame{BossTimeMap: bossTimeMap}, true, false)

	duration := overTime.CombineDateInt(date).AddDate(0, 0, nextAwardDate).Sub(tjutil.Now())
	log.Infof("CrossMine round %s nextAwardDate %d dailyAward time delta %s", round, nextAwardDate, duration)
	time.AfterFunc(duration, m.onOver)
}

func (m *Mine) getBossTimeMap() map[document.ID][2]int {
	db := m.GetLockedDB()

	ret := make(map[document.ID][2]int)
	bossCfg := csv.GetConfig().Cross.Mine.Boss
	nt := tjutil.NowTime()

	for k, v := range db.Boss {
		// 已经被击杀
		if v.KillRoleID != "" {
			continue
		}

		// 已经过了开放时间看是否过了结束时间
		if nt > v.OpenTime && !inValidTime(v.OpenTime, bossCfg[v.CsvID].Duration) {
			continue
		}

		ret[k] = [2]int{v.CsvID, int(v.OpenTime)}
	}

	return ret
}

// 每天结束
func (m *Mine) onOver() {
	round := "over"
	var date, nextAwardDate int
	tjutil.WithGuard(m, func() {
		m.SetRound(round)
		date = m.Date()
		nextAwardDate = m.NextAwardDate() + 1
		m.SetNextAwardDate(nextAwardDate)
	})

	if nextAwardDate >= CrossMineDayDuration {
		m.onClosed()
	} else {
		m.eventToSomeGame("dayRankAward", m.onRoleRankAward(), true)

		duration := startTime.CombineDateInt(date).AddDate(0, 0, nextAwardDate).Sub(tjutil.Now())
		log.Infof("CrossMine round %s start time delta %s", round, duration)
		time.AfterFunc(duration, m.onStart)
	}
}

func (m *Mine) isDisableProtect() bool {
	m.RLock()
	defer m.RUnlock()

	date := m.Date()
	nextAwardDate := m.NextAwardDate()

	if nextAwardDate+1 >= CrossMineDayDuration {
		duration := overTime.CombineDateInt(date).AddDate(0, 0, nextAwardDate).Sub(tjutil.Now())
		if duration.Seconds() <= GetConfig().DisablenBattleProtectBeforeOver*60 {
			return true
		}
	}

	return false
}

func (m *Mine) onClosed() {
	log.Infof("CrossMine onClosed")

	tjutil.WithGuard(m, func() {
		m.SetRound("closed")

		// 结束后再触发一次，以防遗漏
		m.productMine()
	})

	m.eventToGame("closed", m.onClosedEventData(), false, false)
	m.eventToSomeGame("allRankAward", m.onAllRankAward(), false)

	m.clean()

	ta.TrackCrossMineBoss(m.key, m.Boss())
}

func (m *Mine) onClosedEventData() EventToGame {
	db, unlock := m.LockAndGetDB()
	defer unlock()

	lastRanks := make([]*scheme.CrossMineRoleInfo, 0, db.RankMax)

	for i := 1; i <= int(db.RankMax); i++ {
		rr := db.Ranks[document.Integer(i)]
		roleInfo := db.Roles[rr[0]]
		lastRanks = append(lastRanks, roleInfo)
	}

	serverPoints := make(map[string]int)
	for k, v := range m.serverPoints {
		serverPoints[k] = v
	}

	return EventToGame{
		LastRanks:        lastRanks,
		LastServerPoints: serverPoints,
		TopBattleHistory: db.LastTopBattleHistory,
	}
}

func (m *Mine) onRoleCache() map[string]*EventToGame {
	db, unlock := m.LockAndGetDB()
	defer unlock()

	d := make(map[string]*EventToGame)
	for roleID, info := range db.Roles {
		if _, ok := d[info.GameKey]; !ok {
			d[info.GameKey] = &EventToGame{Roles: make(map[document.ID]int)}
		}
		d[info.GameKey].Roles[roleID] = int(info.Coin13Diff)
	}
	return d
}

// 角色排名奖励
func (m *Mine) onRoleRankAward() map[string]*EventToGame {
	db, unlock := m.LockAndGetDB()
	defer unlock()

	d := make(map[string]*EventToGame)
	for rank, rr := range db.Ranks {
		roleID := rr[0]
		gameKey := db.Roles[roleID].GameKey
		if _, ok := d[gameKey]; !ok {
			d[gameKey] = &EventToGame{
				RoleRanks: make(map[document.ID]int),
			}
		}
		d[gameKey].RoleRanks[roleID] = int(rank)
	}

	return d
}

func (m *Mine) onAllRankAward() map[string]*EventToGame {
	roleCaches := m.onRoleCache()
	rankAwards := m.onRoleRankAward()

	// 拼装角色排名数据
	for serverKey, item := range rankAwards {
		if _, ok := roleCaches[serverKey]; !ok {
			roleCaches[serverKey] = &EventToGame{}
		}
		roleCaches[serverKey].RoleRanks = item.RoleRanks
	}

	_, unlock := m.LockAndGetDB()
	unlock()

	serverPoints := make(map[string]int)
	for serverKey, points := range m.serverPoints {
		serverPoints[serverKey] = points
	}

	// 拼装区服积分数据
	for _, item := range roleCaches {
		item.LastServerPoints = serverPoints
	}

	return roleCaches
}

func (m *Mine) isAllOver() bool {
	// over 也认为结束，over状态重启只能手动处理了
	if m.Round() == "closed" {
		return true
	}

	date := m.Date()
	if date == 0 {
		return true
	}
	startdate := tjutil.Int2Date(date)
	nowdate := tjutil.Int2Date(tjutil.Todayinclock5date2int())
	duration := nowdate.Sub(startdate)
	return duration > tjutil.OneDay*CrossMineDayDuration
}

func (m *Mine) ResetToday() {
	round := m.Round()
	date := m.Date()
	nextAwardDate := m.NextAwardDate()
	servers := m.Servers()
	csvID := m.CsvId()
	log.Infof("CrossMine.ResetToday date %d round %s", date, round)
	ndt := tjutil.Todaydate2int()

	if round == "closed" {
		// 如果是今天，重新 OnInit
		if ndt == date {
			m.OnInit(csvID, servers)
		}
	} else if round == "start" {
		duration := overTime.CombineDateInt(date).AddDate(0, 0, nextAwardDate).Sub(tjutil.Now())
		log.Infof("CrossMine round %s nextAwardDate %d dailyAward time delta %s", round, nextAwardDate, duration)
		time.AfterFunc(duration, m.onOver)

		db, unlock := m.LockAndGetDB()
		tjutil.WithDefer(func() {
			// 初始化精彩战报
			cfg := GetConfig()
			lastTime := tjutil.NowTime2Peroid(cfg.TopBattleHistoryPeriods)
			if db.LastRefreshTime != lastTime {
				m.SetLastRefreshTime(lastTime)
				m.refreshTopBattleHistories()
			}
		}, unlock)

		go m.productMineTimer()

	} else if round == "over" {
		duration := startTime.CombineDateInt(date).AddDate(0, 0, nextAwardDate).Sub(tjutil.Now())
		log.Infof("CrossMine round %s nextAwardDate %d start time delta %s", round, nextAwardDate, duration)
		time.AfterFunc(duration, m.onStart)

		go m.productMineTimer()
	} else {
		panic("Restart round error")
	}
}

func (m *Mine) clean() {
	log.Infof("CrossMrena Clean %d %s", m.Date(), m.Round())
	m.SetRound("closed")
}

// 服务是否存在 server_key
func (m *Mine) isServerOK(key string) bool {
	db := m.GetLockedDB()
	if csv.GetMergeConfig().IsMergeKeyInServers(key, db.Servers) {
		return true
	}
	return false
}

// 同步到 game
func (m *Mine) dbForGame() *DBForGame {
	db := m.GetLockedDB()
	return &DBForGame{
		Servers:     db.Servers,
		CsvId:       db.CsvId,
		Date:        db.Date,
		Round:       db.Round,
		BossTimeMap: m.getBossTimeMap(),
	}
}

func (m *Mine) syncModel() *SyncModel {
	return &SyncModel{
		Round:           m.Round(),
		LastProductTime: m.LastProductTime(),
	}
}

// 事件通知 game
func (m *Mine) eventToGame(event string, data EventToGame, sync bool, mergeFilter bool) map[string]*game.CrossMineEventResponse {
	servers := m.Servers()
	if mergeFilter {
		servers = csv.GetMergeConfig().FilterMergeServer(servers)
	}

	d := make(map[string]*EventToGame)
	for _, key := range servers {
		d[key] = &data
	}
	return m.eventToSomeGame(event, d, sync)
}

// 事件通知部分 game
func (m *Mine) eventToSomeGame(event string, d map[string]*EventToGame, sync bool) map[string]*game.CrossMineEventResponse {
	var model *SyncModel
	if sync {
		model = m.syncModel()
	}
	keys := make([]string, 0, len(d))
	futures := make([]*service.Future, 0, len(d))
	for key, data := range d {	
		s := m.container.GetService(key)
		if s == nil {
			log.Warningf("CrossMine.eventToSomeGame: no service found for key=%s, event=%s (skip)", key, event)
			continue
		}
		keys = append(keys, key)
		future := service.CallAsync(s, "CrossMineEvent", event, key, data, model)
		futures = append(futures, future)
	}

	ret := make(map[string]*game.CrossMineEventResponse)
	resp, err := service.MultiFuture(futures, false).Get()
	if err != nil {
		log.Warningf("CrossMineEvent %s response error %v", event, err)
		return nil
	}
	response := resp.([]interface{})
	for i, key := range keys {
		ret[key] = response[i].(*game.CrossMineEventResponse)
	}
	return ret
}

// 获取对手列表
func (m *Mine) getBattleEnemies(roleID document.ID, refresh bool) []scheme.CrossMineRoleInfo {
	db := m.GetLockedDB()

	enemies := make([]scheme.CrossMineRoleInfo, 0, RandomEnemiesSize)
	ranks := make([]int, 0, RandomEnemiesSize)
	// 重新匹配对手
	if refresh {
		ranks = m.matchingEnemies(roleID, false)
	} else {
		if _, ok := db.EnemyRanks[roleID]; !ok {
			ranks = m.matchingEnemies(roleID, false)
		} else if len(db.EnemyRanks[roleID]) != RandomEnemiesSize {
			ranks = m.matchingEnemies(roleID, true)
		} else {
			ranks = db.EnemyRanks[roleID]
		}
	}
	for _, rank := range ranks {
		enemyRoleID := db.Ranks[document.Integer(rank)][0]
		roleInfo := db.Roles[enemyRoleID]
		enemies = append(enemies, *roleInfo)
	}
	return enemies
}

// 匹配对手
func (m *Mine) matchingEnemies(roleID document.ID, needAdd bool) []int {
	db := m.GetLockedDB()

	enemies := make([]int, 0, RandomEnemiesSize)
	var rank int
	if r, ok := m.roleRanks[roleID]; ok {
		rank = int(r)
	} else if roleInfo, ok := db.Roles[roleID]; ok {
		rank = roleInfo.Rank
	}
	ranges := GetConfig().MatchRanges

	if rr := ranges.GetRange(rank); rr != nil {
		pwrange := rr.(*PWRange)
		enemies = pwrange.getEnemies(rank, RandomEnemiesSize, int(db.RankMax))
	} else {
		log.Warningf("rank %d can not get range", rank)
	}

	if needAdd {
		// 不是强制刷新如果原来不足则补充对手
		oldEnemiesLen := len(db.EnemyRanks[roleID])
		if len(enemies) > oldEnemiesLen {
			db.EnemyRanks[roleID] = append(db.EnemyRanks[roleID], enemies[oldEnemiesLen:]...)
		}
	} else {
		db.EnemyRanks[roleID] = enemies
	}

	m.SetEnemyRanks(db.EnemyRanks)

	return db.EnemyRanks[roleID]
}

// 获取排行榜
func (m *Mine) getRanks(offset, size int) []scheme.CrossMineRoleInfo {
	db := m.GetLockedDB()
	ranks := make([]scheme.CrossMineRoleInfo, 0, size)
	end := offset + size
	if end >= int(db.RankMax) {
		end = int(db.RankMax)
	}
	for i := offset; i < end; i++ {
		roleID := db.Ranks[document.Integer(i+1)][0]
		ranks = append(ranks, *db.Roles[roleID])
	}
	return ranks
}

func (m *Mine) getServerBuffFeedRanks(offset, size int) []scheme.CrossMineRoleInfo {
	db := m.GetLockedDB()
	ranks := make([]scheme.CrossMineRoleInfo, 0, size)
	end := offset + size
	if end >= len(m.ServerFeedRanks) {
		end = len(m.ServerFeedRanks)
	}
	for i := offset; i < end; i++ {
		roleID := m.ServerFeedRanks[i]
		ranks = append(ranks, *db.Roles[roleID])
	}
	return ranks
}

func (m *Mine) getBossRanks(bossID document.ID, offset, size int) []CrossMineBossRankRoleItem {
	db := m.GetLockedDB()
	ranks := make([]CrossMineBossRankRoleItem, 0, size)
	end := offset + size
	bossRank := m.bossRanks[bossID]
	if end >= len(bossRank) {
		end = len(bossRank)
	}
	for i := offset; i < end; i++ {
		roleID := bossRank[i]
		bossRole := db.Boss[bossID].Roles[roleID]
		ranks = append(ranks, CrossMineBossRankRoleItem{
			CrossMineRole: db.Roles[roleID].CrossMineRole,
			Rank:          bossRole.Rank,
			Damage:        bossRole.Damage,
		})
	}

	return ranks
}

func (m *Mine) getBossRanksWithMe(roleID, bossID document.ID, offset, size int) (*RespGetCrossMineBossRanks, error) {
	db := m.GetLockedDB()
	bossInfo, ok := db.Boss[bossID]
	if !ok {
		return nil, ErrBossNotFind
	}

	resp := &RespGetCrossMineBossRanks{}
	resp.Ranks = m.getBossRanks(bossID, offset, size)

	if bossRole, ok := bossInfo.Roles[roleID]; ok {
		resp.MyInfo = CrossMineBossRankRoleItem{
			CrossMineRole: db.Roles[roleID].CrossMineRole,
			Rank:          bossRole.Rank,
			Damage:        bossRole.Damage,
		}
	}

	return resp, nil
}

// 获取角色排名
func (m *Mine) getRoleRank(roleID document.ID) (int, error) {
	db, unlock := m.LockAndGetDB()
	defer unlock()

	if rank, ok := m.roleRanks[roleID]; ok {
		return int(rank), nil
	}
	if roleInfo, ok := db.Roles[roleID]; ok {
		return roleInfo.Rank, nil
	} else {
		return 0, ErrRoleNotFind
	}
}

// 战斗缓存
func (m *Mine) storeVsForRole(flag string, rank int, roleID, enemyRoleID, recordID, enemyRecordID document.ID) error {
	db, unlock := m.LockAndGetDB()
	defer unlock()

	// 判断对手排名是否发生改变
	rr := db.Ranks[document.Integer(rank)] //（roleID, recordID)
	if rr[0] != enemyRoleID && rr[1] != enemyRecordID {
		return ErrRankEnemyChanged
	}

	// 判断对手是否正在战斗
	if v, ok := m.vsInfos[enemyRoleID]; ok {
		if tjutil.NowTime()-v.time < InBattleTime {
			return ErrInBattle
		}
	}

	m.vsInfos[enemyRoleID] = vsInfoItem{
		roleID:        roleID,
		recordID:      recordID,
		enemyRoleID:   enemyRoleID,
		enemyRecordID: enemyRecordID,
		time:          tjutil.NowTime(),
	}
	return nil
}

// 战斗结束更新排名
func (m *Mine) battleEndUpdate(bb *battle, roleID, recordID document.ID, result string, stats map[document.Integer]string, isTopBattle bool) (*RespCrossMineBattleEnd, error) {
	bb.mu.Lock()
	defer bb.mu.Unlock()

	if bb.result != "" && bb.result != result {
		log.Warningf("cross mine role %v play %v anti %v client %v is diff after anti", roleID, bb.playRecordID, bb.result, result)
		return nil, ErrCheat
	}

	bb.result = result
	bb.stats = stats

	playRecord := m.builder.GetCrossMinePlayRecord(bb.playRecordID)

	flag := bb.Flag
	enemyRoleID := bb.enemyRoleID

	// 战斗结果处理（战斗结果、排名、战斗历史）
	oldRank, newRank, err := m.resultForRole(flag, roleID, enemyRoleID, result)
	if err != nil {
		return nil, err
	}

	var gameKey, enemyGameKey string
	rank := oldRank
	move := 0
	topMove := 0
	isNotice := false
	robNum := 0
	speed := 0.0
	tjutil.WithGuard(m, func() {
		db := m.GetLockedDB()

		role := db.Roles[roleID]
		speed = role.Speed
		enemy := db.Roles[enemyRoleID]

		gameKey = role.GameKey
		topRank := role.TopRank
		enemyGameKey = enemy.GameKey
		if result == "win" {
			if flag == CrossMineBattleFlagRob && newRank < oldRank {
				move = oldRank - newRank
				rank = newRank
				if newRank < topRank {
					role.TopRank = newRank
					m.SetRoles(db.Roles)
					topMove = topRank - newRank
				}
			}

			robNum = m.calcRobNumAndUpdate(flag, role, enemy)
		}

		tjutil.WithGuard(playRecord, func() {
			playRecord.SetResult(result)
			playRecord.SetStats(stats)
			playRecord.SetRobNum(robNum)
			playRecord.SetFlag(flag)
			playRecord.SetRank(role.Rank)
			playRecord.SetDefenceRank(enemy.Rank)
		})

		if flag == CrossMineBattleFlagRob && isTopBattle && m.isTopPlayRecord(oldRank, newRank) {
			m.addTopBattleHistory(oldRank, newRank, playRecord, m.key)
		}

		// 若刷新 DB同步缓存
		cfg := GetConfig()
		lastTime := tjutil.NowTime2Peroid(cfg.TopBattleHistoryPeriods)
		if m.LastRefreshTime() != lastTime {
			size := m.refreshTopBattleHistories()
			m.SetLastRefreshTime(lastTime)
			if size > 0 {
				isNotice = true
			}
		}
	})
	if isNotice {
		m.onNoticeBattleHistories()
	}

	view := map[string]int{
		"rank":      rank,
		"rank_move": move,
		"top_move":  topMove,
		"robNum":    robNum,
		"speed":     int(speed * 60),
	}
	bb.view = view

	_, _ = service.Call(m.container.GetService(service.Game2PVPService(gameKey)), "CrossMineAddHistory", recordID, newRank, oldRank, move, robNum, playRecord, m.key, flag)
	_, _ = service.Call(m.container.GetService(service.Game2PVPService(enemyGameKey)), "CrossMineAddHistory", bb.enemyRecordID, oldRank, newRank, -move, -robNum, playRecord, m.key, flag)

	if m.track != nil && (oldRank <= 1000 || newRank <= 1000) {
		win := result == "win"
		cards := make([]int, 0, 12)
		defencecards := make([]int, 0, 12)
		for _, v := range playRecord.Cards() {
			cards = append(cards, schemeutil.CalcBattleCards(playRecord.CardAttrs(), v)...)
		}
		for _, v := range playRecord.DefenceCards() {
			defencecards = append(defencecards, schemeutil.CalcBattleCards(playRecord.DefenceCardAttrs(), v)...)
		}
		m.track.Track(win, cards)
		m.track.Track(!win, defencecards)
	}

	return &RespCrossMineBattleEnd{
		EnemyRoleID: enemyRoleID,
		View:        view,
	}, nil
}

// 战斗结果处理
func (m *Mine) resultForRole(flag string, roleID, enemyRoleID document.ID, result string) (int, int, error) {
	db, unlock := m.LockAndGetDB()
	defer unlock()

	vsInfo, ok := m.vsInfos[enemyRoleID]
	if !ok {
		return 0, 0, ErrVsInfoNotFind
	}

	if vsInfo.roleID != roleID {
		return 0, 0, ErrVsInfoError
	}

	delete(m.vsInfos, enemyRoleID)

	oldRank := m.roleRanks[roleID]

	// 复仇不改变排名
	if flag == CrossMineBattleFlagRevenge {
		return int(oldRank), int(oldRank), nil
	}

	newRank := m.roleRanks[enemyRoleID]

	// 赢和排名交换都清对手
	if result == "win" {
		delete(db.EnemyRanks, roleID)
		if oldRank > newRank {
			m.swapRank(oldRank, newRank)
			delete(db.EnemyRanks, enemyRoleID)
		}
		m.SetEnemyRanks(db.EnemyRanks)
	}

	return int(oldRank), int(newRank), nil
}

// 战斗后交换排名
func (m *Mine) swapRank(oldRank, newRank document.Integer) {
	db := m.GetLockedDB()

	ranks := db.Ranks
	oldRole := ranks[oldRank]
	newRole := ranks[newRank]

	// 更新 Roles 的排名
	oldRoleRank := db.Roles[oldRole[0]].Rank
	newRoleRank := db.Roles[newRole[0]].Rank
	db.Roles[oldRole[0]].Rank = newRoleRank
	db.Roles[oldRole[0]].Speed = m.calcSpeed(db.Roles[oldRole[0]].GameKey, newRoleRank)
	db.Roles[newRole[0]].Rank = oldRoleRank
	db.Roles[newRole[0]].Speed = m.calcSpeed(db.Roles[newRole[0]].GameKey, oldRoleRank)
	m.SetRoles(db.Roles)

	// 更新ranks
	ranks[oldRank] = newRole
	ranks[newRank] = oldRole
	m.SetRanks(ranks)

	// 更新roleRanks缓存
	m.roleRanks[newRole[0]] = oldRank
	m.roleRanks[oldRole[0]] = newRank
}

// 判断是否是精彩战报
func (m *Mine) isTopPlayRecord(oldRank, newRank int) bool {
	topBattleRank := GetConfig().TopBattleRank
	return newRank < topBattleRank && oldRank < topBattleRank
}

func (m *Mine) getRoleBeRodedInfo(enemyRoleID document.ID) *scheme.CrossMineRoleBeRodedInfo {
	db := m.GetLockedDB()
	if _, ok := db.RoleBeRoded[enemyRoleID]; !ok {
		db.RoleBeRoded[enemyRoleID] = &scheme.CrossMineRoleBeRodedInfo{}
		m.SetRoleBeRoded(db.RoleBeRoded)
	}
	return db.RoleBeRoded[enemyRoleID]
}

func (m *Mine) getRoleBeRevengedInfo(enemyRoleID, roleID document.ID) *scheme.CrossMineRoleBeRevengedInfo {
	db := m.GetLockedDB()
	if _, ok := db.RoleBeRevenged[enemyRoleID]; !ok {
		db.RoleBeRevenged[enemyRoleID] = make(map[document.ID]*scheme.CrossMineRoleBeRevengedInfo)
		m.SetRoleBeRevenged(db.RoleBeRevenged)
	}
	if _, ok := db.RoleBeRevenged[enemyRoleID][roleID]; !ok {
		db.RoleBeRevenged[enemyRoleID][roleID] = &scheme.CrossMineRoleBeRevengedInfo{}
		m.SetRoleBeRevenged(db.RoleBeRevenged)
	}
	return db.RoleBeRevenged[enemyRoleID][roleID]
}

func (m *Mine) calcRobNum(flag string, role, enemy *scheme.CrossMineRoleInfo) (robNum int) {
	// 同服获得资源为 0
	if isFriendlyForces(role.GameKey, enemy.GameKey) {
		return 0
	}

	cfg := GetConfig()

	enemyRoleID := enemy.RoleID
	roleID := role.RoleID

	nt := tjutil.NowTime()
	switch flag {
	case CrossMineBattleFlagRob:
		beRobedInfo := m.getRoleBeRodedInfo(enemyRoleID)
		times := beRobedInfo.Time
		timesLen := len(times)
		// 一小时内超过五次或超过限制和超过次数没有资源
		if (timesLen >= cfg.RobHourTimes && nt-times[timesLen-cfg.RobHourTimes] < RobTimeProtectLimit) || beRobedInfo.Count >= cfg.BeRodDayLimit {
			return 0
		}
	case CrossMineBattleFlagRevenge:
		beRevengedInfo := m.getRoleBeRevengedInfo(enemyRoleID, roleID)
		times := beRevengedInfo.Time
		timesLen := len(times)
		// 一小时内超过五次或超过限制和超过次数没有资源
		if (timesLen >= cfg.RobHourTimes && nt-times[timesLen-cfg.RobHourTimes] < RobTimeProtectLimit) || beRevengedInfo.Count >= cfg.BeRevengedByCommonRoleLimit {
			return 0
		}

	default:
		// 获取个人信息时可能不需要预计算
		return 0
	}

	roleFP := role.FightingPoint
	enemyFP := enemy.FightingPoint

	// 计算战力差能获得多少资源
	fpDiffPct := float64(roleFP)/float64(enemyFP) - 1
	robInvalidFightPctIdx := 0
	for _, pct := range cfg.RobFight {
		if fpDiffPct > pct {
			robInvalidFightPctIdx++
		} else {
			break
		}
	}

	// 没有超过无效战力差
	if robInvalidFightPctIdx == 0 {
		robNum = int((float64(enemy.Coin13Origin) + enemy.Coin13Diff) * cfg.RobPct)
	} else {
		fix := cfg.RobFightPct[robInvalidFightPctIdx-1]
		robNum = int((float64(enemy.Coin13Origin) + enemy.Coin13Diff) * fix)
	}

	db := m.GetLockedDB()
	// 排名积分上限
	if robNum > 0 {
		rankCsvIDs := GetConfig().ProductCfgIDSortMap[csv.GetConfig().Cross.Service[db.CsvId].Version]
		idx := sort.Search(len(rankCsvIDs), func(i int) bool {
			return rankCsvIDs[i][1] >= enemy.Rank
		})
		byRobLimit := csv.GetConfig().Cross.Mine.Rank[rankCsvIDs[idx][0]].ByRobLimit
		if robNum > byRobLimit {
			robNum = byRobLimit
		}
	}

	roleBossBuff := m.getBossBuffAdd(role.GameKey, BossBuffTypeRob)
	enemyBossBuff := m.getBossBuffAdd(enemy.GameKey, BossBuffTypeRob)

	// 抢夺方抢夺 buff 加成，被抢夺方 buff 减免
	robNum = int(float64(robNum) * (1 + roleBossBuff - enemyBossBuff))

	return robNum
}

// 计算抢夺数据
func (m *Mine) calcRobNumAndUpdate(flag string, role, enemy *scheme.CrossMineRoleInfo) (robNum int) {
	robNum = m.calcRobNum(flag, role, enemy)

	roleID := role.RoleID
	enemyRoleID := enemy.RoleID
	cfg := GetConfig()

	db := m.GetLockedDB()

	if robNum > 0 {

		// 抢夺无效不记录敌对上次数
		switch flag {
		case CrossMineBattleFlagRob:
			beRobedInfo := m.getRoleBeRodedInfo(enemyRoleID)
			times := beRobedInfo.Time
			beRobedInfo.Time = append([]float64{}, times[max(len(times)-cfg.RobHourTimes, 0):]...)
			beRobedInfo.Time = append(beRobedInfo.Time, tjutil.NowTime())
			beRobedInfo.Count++
			m.SetRoleBeRoded(db.RoleBeRoded)
		case CrossMineBattleFlagRevenge:
			beRevengedInfo := m.getRoleBeRevengedInfo(enemyRoleID, roleID)
			times := beRevengedInfo.Time
			beRevengedInfo.Time = append([]float64{}, times[max(len(times)-cfg.RobHourTimes, 0):]...)
			beRevengedInfo.Time = append(beRevengedInfo.Time, tjutil.NowTime())
			beRevengedInfo.Count++
			m.SetRoleBeRevenged(db.RoleBeRevenged)
		}

		role.Coin13Diff += float64(robNum)
		enemy.Coin13Diff -= float64(robNum)
		m.SetRoles(db.Roles)
	}

	return
}

// 添加精彩战报
func (m *Mine) addTopBattleHistory(oldRank, newRank int, playRecord *PlayRecord, crossKey string) {
	history := scheme.CrossMineTopBattleHistory{
		Time:     tjutil.NowTime(),
		Result:   playRecord.Result(),
		CrossKey: crossKey,

		PlayRecordID: playRecord.GetID(),

		RoleKey:       playRecord.RoleKey(),
		RecordID:      playRecord.RecordDbId(),
		Name:          playRecord.Name(),
		Logo:          playRecord.Logo(),
		Frame:         playRecord.Frame(),
		Level:         playRecord.Level(),
		Vip:           playRecord.Vip(),
		FightingPoint: playRecord.getFightingPoint(),
		Rank:          oldRank,

		DefenceRoleKey:       playRecord.DefenceRoleKey(),
		DefenceRecordID:      playRecord.DefenceRecordId(),
		DefenceName:          playRecord.DefenceName(),
		DefenceLogo:          playRecord.DefenceLogo(),
		DefenceFrame:         playRecord.DefenceFrame(),
		DefenceLevel:         playRecord.DefenceLevel(),
		DefenceVip:           playRecord.DefenceVip(),
		DefenceFightingPoint: playRecord.getEnemyFightingPoint(),
		DefenceRank:          newRank,
	}

	db := m.GetLockedDB()
	oldHistory := db.TopBattleHistory

	// 去重重复对战玩家
	tmpHistory := make([]scheme.CrossMineTopBattleHistory, 0, TopBattleHistoryMax)
	hasCommon := false
	for i, h := range oldHistory {
		if h.RoleKey.ID == playRecord.RoleKey().ID {
			tmpHistory = append(tmpHistory, oldHistory[:i]...)
			tmpHistory = append(tmpHistory, oldHistory[i+1:]...)
			hasCommon = true
			break
		}
	}
	if !hasCommon {
		tmpHistory = append(tmpHistory, oldHistory...)
	}

	// 根据排名排序。排名相同最近时间的排前面
	newHistory := make([]scheme.CrossMineTopBattleHistory, 0, TopBattleHistoryMax)
	rank := min(oldRank, newRank)
	if len(tmpHistory) == 0 {
		tmpHistory = append(tmpHistory, history)
		newHistory = tmpHistory
	} else {
		for i, h := range tmpHistory {
			if rank < min(h.Rank, h.DefenceRank) {
				newHistory = append(newHistory, tmpHistory[:i]...)
				newHistory = append(newHistory, history)
				newHistory = append(newHistory, tmpHistory[i:]...)
				break
			}
			if i == len(tmpHistory)-1 {
				tmpHistory = append(tmpHistory, history)
				newHistory = tmpHistory
			}
		}
	}

	// 只有10场
	if len(newHistory) > TopBattleHistoryMax {
		newHistory = newHistory[:TopBattleHistoryMax]
	}

	m.SetTopBattleHistory(newHistory)
}

// 刷新精彩战报
func (m *Mine) refreshTopBattleHistories() int {
	log.Infof("CrossMine.refreshTopBattleHistories")
	db := m.GetLockedDB()

	// 新的在前，不够的用上期数据在后面补
	h := db.TopBattleHistory
	size := len(h)
	lastHistory := db.LastTopBattleHistory
	checkRole := make(map[document.ID]bool)
	for _, item := range h {
		checkRole[item.RoleKey.ID] = true
	}
	for _, item := range lastHistory {
		// 去重
		if _, ok := checkRole[item.RoleKey.ID]; ok {
			continue
		}
		h = append(h, item)
	}

	// 只展示10场
	if len(h) > TopBattleHistoryMax {
		h = h[:TopBattleHistoryMax]
	}

	m.SetLastTopBattleHistory(h)

	// 重置 重新收集新时间段数据
	m.SetTopBattleHistory([]scheme.CrossMineTopBattleHistory{})
	return size
}

// 通知精彩战报刷新
func (m *Mine) onNoticeBattleHistories() {
	log.Infof("CrossMine.onNoticeBattleHistories")
	m.eventToGame("refreshTopHistory", EventToGame{}, true, true)
}

// 喂养 buff
func (m *Mine) feedBuff(flag string, csvID int, roleID document.ID, gameKey string) error {
	db, unlock := m.LockAndGetDB()
	defer unlock()

	inDay := tjutil.TodayInClock5ElapseDays(tjutil.Int2Date(db.Date).Add(time.Hour * time.Duration(startTime.Hour)))
	serverBuffFeedLevelLimit := GetConfig().ServerBuffFeedLevelLimit
	roleBuffFeedLevelLimit := GetConfig().RoleBuffFeedLevelLimit
	if inDay >= len(serverBuffFeedLevelLimit) {
		return errors.New("feed time out of limit")
	}

	if inDay < 0 {
		return errors.New("feed time out of limit")
	}


	cfg, ok := csv.GetConfig().Cross.Mine.Buff_feed[csvID]
	if !ok {
		return errors.New("feed csvID not find")
	}
	switch flag {
	case "server":
		// log.Infof("[chanlong] ban phuoc may chu: roleID=%s, gameKey=%s, cfg.FeedExp=%s, inDay=%s",roleID, gameKey, cfg.FeedExp, inDay)
		m.addServerBuffExp(roleID, gameKey, cfg.FeedExp, serverBuffFeedLevelLimit[inDay])
	case "role":
		m.addRoleBuffExp(roleID, cfg.FeedExp, roleBuffFeedLevelLimit)
	default:
		return errors.New("feed flag error")
	}
	return nil
}

// 添加全服 buff 经验
func (m *Mine) addServerBuffExp(roleID document.ID, gameKey string, exp, dailyLevelLimit int) {
	db := m.GetLockedDB()
	info := m.getServerBuffInfo(gameKey, true)

	expDayMax := csv.GetConfig().Cross.Mine.Buff_add[info.Level].ServerExpDayMax
	inc := expDayMax - info.DayExp
	if inc > exp {
		inc = exp
	}
	info.SumExp += inc
	info.DayExp += inc
	db.Roles[roleID].ServerBuffFeed += inc
	m.SetRoles(db.Roles)

	m.resetServerFeedRanks()

	cfg := GetConfig()

	dailyExpLimit := cfg.ServerBuffLevelExp[dailyLevelLimit]
	if info.SumExp >= dailyExpLimit {
		info.SumExp = dailyExpLimit
	}

	for i := 0; i <= cfg.ServerBuffLevelMax; i++ {
		if info.SumExp >= cfg.ServerBuffLevelExp[i] {
			info.Level = i
		} else {
			break
		}
	}

	m.SetServerBuffInfo(db.ServerBuffInfo)
}

// 添加个人 buff 经验
func (m *Mine) addRoleBuffExp(roleID document.ID, exp, dailyLevelLimit int) {
	db := m.GetLockedDB()
	info := m.getRoleBuffInfo(roleID, true)

	info.SumExp += exp

	cfg := GetConfig()

	dailyExpLimit := cfg.RoleBuffLevelExp[dailyLevelLimit]
	if info.SumExp >= dailyExpLimit {
		info.SumExp = dailyExpLimit
	}

	for i := 0; i <= cfg.RoleBuffLevelMax; i++ {
		if info.SumExp >= cfg.RoleBuffLevelExp[i] {
			info.Level = i
		} else {
			break
		}
	}

	m.SetRoleBuffInfo(db.RoleBuffInfo)
}

// 获取全服 buff 等级
func (m *Mine) getServerBuffLevel(gameKey string) int {
	db := m.GetLockedDB()

	gameKey = getMergeServKey(gameKey)
	buffInfo, ok := db.ServerBuffInfo[gameKey]
	if !ok {
		return ServerBuffLevelInit
	} else {
		return buffInfo.Level
	}
}

// 获取角色 buff 等级
func (m *Mine) getRoleBuffLevel(roleID document.ID) int {
	db := m.GetLockedDB()
	buffInfo, ok := db.RoleBuffInfo[roleID]
	if !ok {
		return RoleBuffLevelInit
	} else {
		return buffInfo.Level
	}
}

// 生产资源定时器
func (m *Mine) productMineTimer() {
	log.Info("CrossMine start productMineTimer")
	t := time.NewTimer(ProductionMineInterval)
	for {
		db, unlock := m.LockAndGetDB()
		if db.Round == "closed" {
			unlock()
			break
		}
		m.productMine()
		unlock()

		<-t.C
		t.Reset(ProductionMineInterval)
	}
	t.Stop()
}

// 生产资源
func (m *Mine) productMine() {
	db := m.GetLockedDB()

	now := tjutil.NowTime()
	deltaMinute := int((now - db.LastProductTime) / 60)
	m.SetLastProductTime(now)

	log.Infof("CrossMine product round %v rankMax %v deltaMinute %d", db.Round, db.RankMax, deltaMinute)

	m.serverPoints = make(map[string]int)
	servCnt := make(map[string]int)
	buffAdd := make(map[string]float64)
	buffAddMap := make(map[int]map[int]float64)

	rankCfgIDs := GetConfig().ProductCfgIDSortMap[csv.GetConfig().Cross.Service[db.CsvId].Version]
	serverPointRank := GetConfig().ServerPointRank

	// boss 积分和生产加成 buff
	for gameKey, killBosses := range db.ServerKillBoss {
		for _, killBoss := range killBosses {
			bossCfg := csv.GetConfig().Cross.Mine.Boss[killBoss.CsvID]
			m.serverPoints[gameKey] += bossCfg.ServerKillPoint

			// buff 加成时间已过
			if killBoss.Time+float64(bossCfg.BuffTime) < now {
				continue
			}

			if _, ok := buffAddMap[bossCfg.ID]; !ok {
				buffAddMap[bossCfg.ID] = bossCfg.BuffAdd.ToIntFloatMap()
			}

			// 是否包含生产加成
			if buffAddNum, ok := buffAddMap[bossCfg.ID][BossBuffTypeProduct]; ok {
				buffAdd[gameKey] += buffAddNum
			}
		}
	}

	pre := 1
	rank := pre
	for _, cfgIDInfo := range rankCfgIDs {
		csvID := cfgIDInfo[0]
		cfg := csv.GetConfig().Cross.Mine.Rank[csvID]
		for rank = pre; rank <= cfg.RankMax; rank++ {
			if int64(rank) > db.RankMax {
				break
			}
			roleIDAndRecordID, ok := db.Ranks[document.Integer(rank)]
			if !ok {
				log.Warningf("CrossMine rank %v not find roleID and recordID", rank)
				continue
			}
			role := db.Roles[roleIDAndRecordID[0]]
			gameKey := getMergeServKey(role.GameKey)
			role.Speed = cfg.MinuteCoin13 * (1 + buffAdd[gameKey])
			role.Coin13Diff += role.Speed * float64(deltaMinute)
			if servCnt[gameKey] < serverPointRank {
				m.serverPoints[gameKey] += cfg.Point + role.BossScore
				servCnt[gameKey]++
			}
		}
		pre = cfg.RankMax + 1
		if int64(rank) > db.RankMax {
			break
		}
	}

}

// 创建 BOss
func (m *Mine) createBoss(csvID int, openTime float64, serverOpenDays int) *scheme.CrossMineBoss {
	bossCfg := csv.GetConfig().Cross.Mine.Boss[csvID]
	if bossCfg == nil {
		log.Warningf("CrossMine boss csvID %d create err not find config", csvID)
		return nil
	}

	bossInfo := &scheme.CrossMineBoss{
		ID:       document.NewID(),
		CsvID:    csvID,
		OpenTime: openTime,
		Roles:    make(map[document.ID]*scheme.CrossMineBossRole),
		HP:       make(map[document.Integer]int),
		Damage:   make(map[document.Integer]int),
	}

	cfg := GetConfig()

	if serverOpenDays > cfg.BossHpFixMaxServerOpenDays {
		serverOpenDays = cfg.BossHpFixMaxServerOpenDays
	}
	fix, ok := cfg.BossHpFix[serverOpenDays]
	if !ok {
		// 没找到配置保持原样
		fix = 1
		log.Warningf("CrossMine boss csvID %d serverOpenDays %d fix not find", csvID, serverOpenDays)
	}

	//bossInfo.HP = int(math.Ceil(float64(bossCfg.BaseHP) * fix))
	bossBaseHPs := bossCfg.BaseHP.ToIntSlice()
	bossIDs := bossCfg.BossID.ToIntSlice()
	if len(bossIDs) != len(bossBaseHPs) {
		log.Warningf("CrossMine boss csvID %d create err bossIDs %v bossBaseHPs %v", csvID, bossIDs, bossBaseHPs)
		return nil
	}
	for idx, k := range bossCfg.BossID.ToIntSlice() {
		bossInfo.HP[document.Integer(k)] = int(math.Ceil(float64(bossBaseHPs[idx]) * fix))
	}
	bossFigure := bossCfg.BossFigure.ToIntSlice()
	bossInfo.FigureID = bossFigure[rand.Intn(len(bossFigure))]

	return bossInfo
}

func (m *Mine) bossBattleEndPreCheck(bossID document.ID, damages map[document.Integer]int) (bool, error) {
	db, unlock := m.LockAndGetDB()
	defer unlock()

	bossInfo, ok := db.Boss[bossID]
	if !ok {
		return false, ErrBossNotFind
	}
	if m.bossIsDied(bossInfo) {
		return false, ErrBossHasKilled
	}

	for k, v := range bossInfo.HP {
		if bossInfo.Damage[k]+damages[k] < v {
			return false, nil
		}
	}
	return true, nil
}

// boss 战斗后更新
func (m *Mine) bossBattleUpdate(bb *bossBattle, roleID document.ID, damages map[document.Integer]int, actions map[document.Integer][]scheme.BattleAction) (*RespCrossMineBossBattleeEnd, error) {
	var bossID document.ID
	var battleStartTime float64
	bb.mu.Lock()
	bossID = bb.bossID
	battleStartTime = bb.startTime
	bb.model.Actions = actions
	bb.clientDamage = damages
	bb.mu.Unlock()

	if int(tjutil.NowTime()-battleStartTime) > GetConfig().BossBattleMaxTime {
		return nil, ErrBossBattleMaxTime
	}

	willKill, err := m.bossBattleEndPreCheck(bossID, damages)
	if err != nil {
		return nil, err
	}

	//如果会击杀则必须等待反作弊计算完
	if willKill {
		m.pushBossBattleToVerifyQueue(bb)
	} else {
		go m.pushBossBattleToVerifyQueue(bb)
	}

	bb.mu.Lock()
	defer bb.mu.Unlock()
	bb.result = "win"

	db, unlock := m.LockAndGetDB()
	defer unlock()

	bossInfo, ok := db.Boss[bossID]
	if !ok {
		return nil, ErrBossNotFind
	}
	if m.bossIsDied(bossInfo) {
		return nil, ErrBossHasKilled
	}

	// 该 Boss 是否开放
	if !inValidTime(bossInfo.OpenTime, csv.GetConfig().Cross.Mine.Boss[bossInfo.CsvID].Duration) {
		return nil, ErrBossNotOpen
	}

	// 上限保护
	damageSum := 0
	for _, damage := range damages {
		damageSum += damage
	}

	// 有反作弊结果则进行校验
	if bb.agentDamage != nil {
		if bossDamgeIsCheat(damages, bb.agentDamage) {
			return nil, ErrCheat
		}
	} else {
		if damageSum > bb.MaxDamage {
			return nil, ErrCheat
		}
	}

	if _, ok = bossInfo.Roles[roleID]; !ok {
		bossInfo.Roles[roleID] = &scheme.CrossMineBossRole{}
	}

	for k, damage := range damages {
		damage = min(bossInfo.HP[k]-bossInfo.Damage[k], damage)
		damage = max(damage, 0)
		bossInfo.Roles[roleID].Damage += damage
		bossInfo.Damage[k] += damage
	}

	m.SetBoss(db.Boss)
	m.updateBossRanks(bossInfo)

	score := csv.GetConfig().Cross.Mine.Boss[bossInfo.CsvID].BattleScoreAward
	db.Roles[roleID].BossScore += score
	m.SetRoles(db.Roles)

	var isKill bool
	if m.bossIsDied(bossInfo) {
		m.onBossKilled(bossInfo, roleID)
		isKill = true
	} else {
		isKill = false
	}

	return &RespCrossMineBossBattleeEnd{
		BossID: bossInfo.ID,
		CsvID:  bossInfo.CsvID,
		Score:  score,
		IsKill: isKill,
	}, nil
}

// 更新 Boss 排名
func (m *Mine) updateBossRanks(bossInfo *scheme.CrossMineBoss) {
	db := m.GetLockedDB()

	ranks := &rankSort{
		items: make([]rankItem, 0, len(bossInfo.Roles)),
	}
	for roleID, roleInfo := range bossInfo.Roles {
		ranks.items = append(ranks.items, rankItem{
			id: roleID,
			items: map[string]int{
				"damage": roleInfo.Damage,
				"level":  db.Roles[roleID].Level,
			},
		})
	}
	ranks.keys = [][]string{{"damage", "desc"}, {"level", "desc"}}
	sort.Sort(ranks)
	newRank := make([]document.ID, 0, len(bossInfo.Roles))
	for idx, item := range ranks.items {
		rank := idx + 1
		newRank = append(newRank, item.id)
		bossInfo.Roles[item.id].Rank = rank
	}
	m.SetBoss(db.Boss)

	m.bossRanks[bossInfo.ID] = newRank
}

// boss 被击杀
func (m *Mine) onBossKilled(bossInfo *scheme.CrossMineBoss, roleID document.ID) {
	db := m.GetLockedDB()

	gameKey := getMergeServKey(db.Roles[roleID].GameKey)
	if _, ok := db.ServerKillBoss[gameKey]; !ok {
		db.ServerKillBoss[gameKey] = make(map[document.ID]*scheme.CrossMineServerKillBoss)
	}

	db.ServerKillBoss[gameKey][bossInfo.ID] = &scheme.CrossMineServerKillBoss{
		CsvID: bossInfo.CsvID,
		Time:  tjutil.NowTime(),
	}
	m.SetServerKillBoss(db.ServerKillBoss)

	bossInfo.KillRoleID = roleID
	m.SetBoss(db.Boss)
}

// 发放 boss 排名奖励
func (m *Mine) onBossRankAwardSend(bossID document.ID) {
	log.Infof("CrossMine onBossRankAwardSend bossID %v", bossID)
	m.eventToSomeGame("bossRankAward", m.onBossRankAward(bossID), true)
}

// 获取击杀 boss 获得的 buff
func (m *Mine) getBossBuffAdd(gameKey string, buffType int) float64 {
	db := m.GetLockedDB()

	var ret float64
	buffAddMap := make(map[int]map[int]float64)
	gameKey = getMergeServKey(gameKey)

	killBosses := db.ServerKillBoss[gameKey]
	nt := tjutil.NowTime()
	for _, info := range killBosses {
		bossCfg := csv.GetConfig().Cross.Mine.Boss[info.CsvID]

		// 是否失效
		if nt-info.Time > float64(bossCfg.BuffTime)*60 {
			continue
		}

		if _, ok := buffAddMap[bossCfg.ID]; !ok {
			buffAddMap[bossCfg.ID] = bossCfg.BuffAdd.ToIntFloatMap()
		}

		if add, ok := buffAddMap[bossCfg.ID][buffType]; ok {
			ret += add
		}
	}

	return ret
}

// boss 伤害排名奖励
func (m *Mine) onBossRankAward(bossID document.ID) map[string]*EventToGame {
	db, unlcok := m.LockAndGetDB()
	defer unlcok()

	nd := tjutil.Nowtime2int()

	ret := make(map[string]*EventToGame)

	bossInfo, ok := db.Boss[bossID]
	if !ok {
		log.Warningf("CrossMine onBossRankAward err boss %v not fint", bossID)
		return nil
	}

	m.updateBossRanks(bossInfo)
	rankAwardVersion := csv.GetConfig().Cross.Mine.Boss[bossInfo.CsvID].RankAwardVersion
	rankAwardCfgIDs := GetConfig().BossRankAwardCfgIDSortMap[csv.GetConfig().Cross.Mine.Boss[bossInfo.CsvID].RankAwardVersion]
	bossTimeMap := m.getBossTimeMap()

	for idx, roleID := range m.bossRanks[bossInfo.ID] {
		rank := idx + 1
		cfgIDIdx := sort.Search(len(rankAwardCfgIDs), func(i int) bool {
			return rankAwardCfgIDs[i][1] >= rank
		})
		rankAwardCfg := csv.GetConfig().Cross.Mine.Boss_rank_award[rankAwardCfgIDs[cfgIDIdx][0]]
		db.Roles[roleID].BossScore += rankAwardCfg.Score
		gameKey := db.Roles[roleID].GameKey
		if _, ok = ret[gameKey]; !ok {
			ret[gameKey] = &EventToGame{
				BossRoleRanks:    make(map[document.ID]int),
				BossAwardVersion: rankAwardVersion,
				BossTimeMap:      bossTimeMap,
			}
		}
		ret[gameKey].BossRoleRanks[roleID] = rank
	}

	// 通知未参与 boss 挑战的区服 boss 已经击杀
	for _, gameKey := range db.Servers {
		if _, ok = ret[gameKey]; !ok {
			ret[gameKey] = &EventToGame{
				BossTimeMap: bossTimeMap,
			}
		}
	}

	bossInfo.AwardDate = nd

	m.SetBoss(db.Boss)
	m.SetRoles(db.Roles)

	return ret
}

// 创建 npc
func (m *Mine) createNpc(csvID int, openTime float64) *scheme.CrossMineNpc {
	npcCfg := csv.GetConfig().Cross.Mine.Npc[csvID]
	if npcCfg == nil {
		log.Warningf("CrossMine npc csvID %d create err not find config", csvID)
		return nil
	}
	return &scheme.CrossMineNpc{
		ID:       document.NewID(),
		CsvID:    csvID,
		OpenTime: openTime,
	}
}

// 初始化事件
func (m *Mine) initEvent() {
	db := m.GetLockedDB()

	randEventLibs := GetConfig().RandEventLibs

	date := db.Date
	serverOpenDays := db.ServerOpenDays

	bosses := make(map[document.ID]*scheme.CrossMineBoss)
	npcs := make(map[document.ID]*scheme.CrossMineNpc)

	for _, eventTimeCfg := range csv.GetConfig().Cross.Mine.Event_times {
		openTime := float64(tjutil.Time{
			Hour:   eventTimeCfg.Time / 100,
			Minute: eventTimeCfg.Time % 100,
		}.CombineDateInt(date).Add(tjutil.OneDay * time.Duration(eventTimeCfg.Day-1)).Unix())

		// 已经生成过事件
		if _, ok := db.EventRecrod[document.Integer(openTime)]; ok {
			log.Infof("CrossMine initEvent time %v has init", tjutil.Unix(int64(openTime)))
			continue
		}

		// 随机出随机库
		randLibWeights := []tjutil.WeightElement{}
		weightIdxToEventLibs := make(map[int]map[int]int)
		idx := 0
		csv.FieldRangeValues(eventTimeCfg, []string{"Weight%d", "RandLib%d"}, func(values []interface{}) bool {
			idx++
			randLibWeights = append(randLibWeights, tjutil.WeightInts{idx, values[0].(int)})
			weightIdxToEventLibs[idx] = values[1].(tjcsv.Map).ToIntMap()
			return true
		})
		random := tjutil.NewWeightRandom(randLibWeights)
		randIdx := random.GetRandom().(tjutil.WeightInts)[0]
		eventLibs := weightIdxToEventLibs[randIdx]

		// 随机出对应事件
		for eventLib, num := range eventLibs {
			if _, ok := randEventLibs[eventLib]; !ok {
				log.Infof("CrossMine initEvent error eventLib %d not find", eventLib)
				continue
			}
			for i := 0; i < num; i++ {
				eventCsvID := randEventLibs[eventLib].GetRandom().(tjutil.WeightInts)[0]
				eventCfg := csv.GetConfig().Cross.Mine.Event_lib[eventCsvID]

				switch eventCfg.EventType {
				// boss
				case EventTypeBoss:
					bossInfo := m.createBoss(eventCfg.EventID, openTime, serverOpenDays)
					if bossInfo != nil {
						bosses[bossInfo.ID] = bossInfo
					}
				case EventTypeNpc:
					npcInfo := m.createNpc(eventCfg.EventID, openTime)
					if npcInfo != nil {
						npcs[npcInfo.ID] = npcInfo
					}
				}
			}
		}

		db.EventRecrod[document.Integer(openTime)] = true
	}

	m.SetEventRecrod(db.EventRecrod)

	for bossID, bossInfo := range bosses {
		db.Boss[bossID] = bossInfo
		m.updateBossRanks(bossInfo)
		log.Infof("CrossMine initEvent boss csvID %v opentTime %v", bossInfo.CsvID, tjutil.Unix(int64(bossInfo.OpenTime)))
	}

	for npcID, npcInfo := range npcs {
		db.Npc[npcID] = npcInfo
		log.Infof("CrossMine initEvent npc csvID %v openTime %v", npcInfo.CsvID, tjutil.Unix(int64(npcInfo.OpenTime)))
	}

	m.SetBoss(db.Boss)
	m.SetNpc(db.Npc)
}

func (m *Mine) resetServerFeedRanks() {
	db := m.GetLockedDB()

	ranks := &rankSort{
		items: []rankItem{},
	}
	for roleID, role := range db.Roles {
		if role.ServerBuffFeed <= 0 {
			continue
		}
		ranks.items = append(ranks.items, rankItem{
			id: roleID,
			items: map[string]int{
				"server_buff_feed": role.ServerBuffFeed,
			},
		})
	}
	ranks.keys = [][]string{{"server_buff_feed", "desc"}}
	sort.Sort(ranks)
	newRank := make([]document.ID, 0, len(ranks.items))
	for idx, item := range ranks.items {
		rank := idx + 1
		db.Roles[item.id].ServerBuffFeedRank = rank
		newRank = append(newRank, item.id)
	}

	m.SetRoles(db.Roles)
	m.ServerFeedRanks = newRank
}

func (m *Mine) getServerPoints() map[string]int {
	ret := make(map[string]int)
	for k, v := range m.serverPoints {
		ret[k] = v
	}
	return ret
}

func (m *Mine) getBoss(roleID document.ID) map[document.ID]RespCrossMineBoss {
	db := m.GetLockedDB()

	ret := make(map[document.ID]RespCrossMineBoss)
	bossCfg := csv.GetConfig().Cross.Mine.Boss

	for k, v := range db.Boss {
		if !inValidTime(v.OpenTime, bossCfg[v.CsvID].Duration) {
			continue
		}

		retV := scheme.CrossMineBoss{
			ID:         v.ID,
			CsvID:      v.CsvID,
			OpenTime:   v.OpenTime,
			HP:         make(map[document.Integer]int),
			Roles:      nil, // 主界面不显示角色数据
			Damage:     make(map[document.Integer]int),
			AwardDate:  v.AwardDate,
			FigureID:   v.FigureID,
			KillRoleID: v.KillRoleID,
		}
		for kk, vv := range v.HP {
			retV.HP[kk] = vv
		}
		for kk, vv := range v.Damage {
			retV.Damage[kk] = vv
		}

		rank, _ := m.getBossRanksWithMe(roleID, v.ID, 0, 10)
		var killROle *RespCrossMineBossKillRole
		if retV.KillRoleID != "" {
			roleInfo, ok := db.Roles[retV.KillRoleID]
			if !ok {
				log.Warningf("CrossMine getBoss killRole %v not find", retV.KillRoleID)
			} else {
				killROle = &RespCrossMineBossKillRole{
					Name:    roleInfo.Name,
					GameKey: getMergeServKey(roleInfo.GameKey),
				}
			}
		}
		ret[k] = RespCrossMineBoss{
			CrossMineBoss: retV,
			Rank:          rank,
			KillRole:      killROle,
		}
	}
	return ret
}

func (m *Mine) getKillBoss(gameKey string) map[document.ID]scheme.CrossMineServerKillBoss {
	db := m.GetLockedDB()

	ret := make(map[document.ID]scheme.CrossMineServerKillBoss)
	bossCfg := csv.GetConfig().Cross.Mine.Boss
	gameKey = getMergeServKey(gameKey)

	for k, v := range db.ServerKillBoss[gameKey] {
		if !inValidTime(v.Time, bossCfg[v.CsvID].BuffTime) {
			continue
		}

		ret[k] = *v
	}
	return ret
}

func (m *Mine) getNpc() map[document.ID]scheme.CrossMineNpc {
	db := m.GetLockedDB()

	ret := make(map[document.ID]scheme.CrossMineNpc)
	npcCfg := csv.GetConfig().Cross.Mine.Npc

	for k, v := range db.Npc {
		if !inValidTime(v.OpenTime, npcCfg[v.CsvID].Duration) {
			continue
		}

		ret[k] = *v
	}

	return ret
}

func (m *Mine) getServerBuffInfo(gameKey string, insert bool) *scheme.CrossMineServerBuffInfo {
	db := m.GetLockedDB()

	gameKey = getMergeServKey(gameKey)
	info, ok := db.ServerBuffInfo[gameKey]

	if !ok {
		info = &scheme.CrossMineServerBuffInfo{
			Level: ServerBuffLevelInit,
		}
		if insert {
			db.ServerBuffInfo[gameKey] = info
			m.SetServerBuffInfo(db.ServerBuffInfo)
		} else {
			return info
		}
	}

	nd := tjutil.Todayinclock5date2int()
	if info.LastDate != nd {
		info.LastDate = nd
		info.DayExp = 0
		m.SetServerBuffInfo(db.ServerBuffInfo)
	}

	return info
}

func (m *Mine) getRoleBuffInfo(roleID document.ID, insert bool) *scheme.CrossMineRoleBuffInfo {
	db := m.GetLockedDB()
	info, ok := db.RoleBuffInfo[roleID]
	if !ok {
		info = &scheme.CrossMineRoleBuffInfo{
			Level: RoleBuffLevelInit,
		}

		if insert {
			db.RoleBuffInfo[roleID] = info
			m.SetRoleBuffInfo(db.RoleBuffInfo)
		}
	}

	return info
}

func (m *Mine) calcSpeed(gameKey string, rank int) float64 {
	buffAdd := m.getBossBuffAdd(gameKey, BossBuffTypeProduct)
	db := m.GetLockedDB()
	rankCsvIDs := GetConfig().ProductCfgIDSortMap[csv.GetConfig().Cross.Service[db.CsvId].Version]
	idx := sort.Search(len(rankCsvIDs), func(i int) bool {
		return rankCsvIDs[i][1] >= rank
	})

	return csv.GetConfig().Cross.Mine.Rank[rankCsvIDs[idx][0]].MinuteCoin13 * (1 + buffAdd)
}

func (m *Mine) runBossBattleAgentVerify() {
	log.Info("CrossMine start runBossBattleAgentVerify")
	tjutil.SimpleTry(func() {
		for {
			select {
			case b := <-m.bossBattleVerifyQueue:
				bossID := b.bossID
				if m.bossIsDieByID(bossID) {
					b.onAgentFinish()
					continue
				}

				data, err := tjutil.MsgPack(b.model)
				if err != nil {
					log.Warningf("CrossMine boss battle %v verify msgpack err %v", b.battleID, err)
					b.onAgentFinish()
					continue
				}
				resp, err := service.CallWithTimeout(m.agent, "NewCrossMineBossBattle", BossBattleVerifyTimeout, m.CrossKey, b.battleID, data)
				if err != nil {
					log.Warningf("CrossMine boss battle %v verify call err %v", b.battleID, err)
					b.onAgentFinish()
					continue
				}

				agentResp := resp.(anti_cheat.CrossMineBossResult)
				if agentResp.Result != "win" {
					log.Warningf("CrossMine boss battle %v verify result err %v", b.battleID, agentResp.Result)
					b.onAgentFinish()
					continue
				}

				log.Infof("CrossMine boss battle %s verify result %v damages %v", b.battleID, agentResp.Result, agentResp.Damages)

				if m.bossIsDieByID(bossID) {
					b.onAgentFinish()
					continue
				}

				b.mu.Lock()
				b.agentDamage = agentResp.Damages

				// 客户端伤害还没记录
				if b.result == "" {
					b.mu.Unlock()
					b.onAgentFinish()
					continue
				}

				if bossDamgeIsCheat(b.clientDamage, b.agentDamage) {
					m.bossDamgeBack(bossID, b.RoleID, b.clientDamage)
					log.Warningf("CrossMine boss battle %v verify err client %v agent %v", b.battleID, b.clientDamage, b.agentDamage)
				}
				b.mu.Unlock()
				b.onAgentFinish()
			}
		}
	}, nil)
}

func (m *Mine) pushBossBattleToVerifyQueue(b *bossBattle) {
	tjutil.SimpleTry(func() {
		t := time.NewTicker(BossBattleWaitVerifyTimeout)
		select {
		case m.bossBattleVerifyQueue <- b:
			select {
			case <-b.agentFinish:
			case <-t.C:
				log.Warningf("CrossMine boss battle %v wait verify timeout", b.battleID)
			}
		case <-t.C:
			log.Warningf("CrossMine boss battle %v push verify timeout", b.battleID)
		}
	}, nil)
}

func (m *Mine) bossIsDieByID(bossID document.ID) bool {
	db, unlock := m.RLockAndGetDB()
	defer unlock()

	bossInfo, ok := db.Boss[bossID]
	if !ok {
		return true
	}

	//return bossInfo.Damage >= bossInfo.HP
	return m.bossIsDied(bossInfo)
}

func (m *Mine) bossIsDied(bossInfo *scheme.CrossMineBoss) bool {
	for k, v := range bossInfo.HP {
		if bossInfo.Damage[k] < v {
			return false
		}
	}
	return true
}

func (m *Mine) bossDamgeBack(bossID, roleID document.ID, damage map[document.Integer]int) {
	db, unlock := m.LockAndGetDB()
	defer unlock()

	bossInfo, ok := db.Boss[bossID]
	if !ok {
		return
	}

	if _, ok = bossInfo.Roles[roleID]; !ok {
		return
	}

	for k, v := range damage {
		bossInfo.Damage[k] -= v
		bossInfo.Roles[roleID].Damage -= v
	}

	//bossInfo.Damage -= damage
	//bossInfo.Roles[roleID].Damage -= damage
	m.SetBoss(db.Boss)
	m.updateBossRanks(bossInfo)
}

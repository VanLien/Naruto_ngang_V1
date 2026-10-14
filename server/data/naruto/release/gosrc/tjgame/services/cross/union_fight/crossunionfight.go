/*
 * @Date    : 2021/9/9 22:41
 * @File    : cross_union_fight.go
 * @Version : 1.0.0
 * @Author  : hss
 * @Note    :
 *
 */

package union_fight

import (
	"sync"
	"sync/atomic"
	"time"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/anti-cheat/manager"
)

// CrossUnionFightGlobal
type CrossUnionFightGlobal struct {
	*scheme.CrossUnionFightGlobalObject
	container service.IContainer
	builder   *Builder
	key       string
	// deprecated
	CrossKey string
	mgr      *manager.AgentManager

	lock             sync.RWMutex
	groupBtResultMap map[document.Integer]map[document.Integer][]manager.Result // 每组每种类型的结果
	playStatus       int32

	agent service.IService // 反作弊

	playMap       sync.Map                                      // {playID: *PlayRecord}
	groupRolesMap sync.Map                                      // {group: [roleID]}
	rounds        map[document.Integer]map[document.Integer]int // {group: {battleType: round}}

	antiSendCount   int32
	antiAcceptCount int32
	danSendCount    int32
	allAcceptCount  int32
	antiResendCount int32

	// 状态定时器
	timer *time.Timer
}

func (g *CrossUnionFightGlobal) init(builder *Builder, crossKey string, agent service.IService) {
	g.builder = builder
	g.key = g.Key()
	g.CrossKey = crossKey
	g.agent = agent

	g.groupRolesMap = sync.Map{}
	g.cleanBattle()

	g.groupBtResultMap = map[document.Integer]map[document.Integer][]manager.Result{}
	atomic.StoreInt32(&g.playStatus, 0)
}

func (g *CrossUnionFightGlobal) SetStatus(v string) {
	g.CrossUnionFightGlobalObject.SetStatus(v)
	g.SetTime(util.Now().Unix())
}

func (g *CrossUnionFightGlobal) getElapsedDuration() time.Duration {
	return time.Duration(util.Now().Unix()-g.Time()) * time.Second
}

// 跨服初始化
func (g *CrossUnionFightGlobal) OnInit(id int, servers []string) {
	log.Infof("CrossUnionFight.OnInit")

	util.WithGuard(g, func() {
		g.reset()
		g.SetDate(util.Todaydate2int())
		g.SetCsvId(id)
		g.SetServers(servers)
		g.SetStatus(StatusStart)
	})

	g.OnStart()
}

// 跨服是否结束
func (g *CrossUnionFightGlobal) IsOver() bool {
	if g.Status() == "closed" {
		return true
	}
	date := g.Date()
	if date == 0 {
		return true
	}
	startDate := util.Int2Date(date)
	nowDate := util.Int2Date(util.Todayinclock5date2int())
	duration := nowDate.Sub(startDate)
	return duration > util.OneDay*4 // TODO 多加一天 防止如果决赛出问题周一还可重开
}

// 跨服中途重启
func (g *CrossUnionFightGlobal) ResetToday() {
	log.Infof("CrossUnionFight.ResetToday %d %s", g.Date(), g.Status())

	status := g.Status()
	switch status {
	case StatusStart:
		g.OnStart()
	case StatusPrePrepare:
		g.onPrePrepare()
	case StatusPreStart, StatusPreBattle: // 重新开始当天的战斗
		g.onPreStart()
	case StatusPreOver: // 当天战斗结束，奖励未发
		g.onPreOver()
	case StatusPreAward:
		g.onHalftime()
	case StatusTopPrepare:
		g.onTopPrepare()
	case StatusTopStart, StatusTopBattle: // 重新开始当天的战斗
		g.onTopStart()
	case StatusTopOver: // 当天战斗结束，奖励未发
		g.onTopOver()
	default:
		log.Warningf("unsupported status %s", status)
	}
}

// 跨服start
func (g *CrossUnionFightGlobal) OnStart() {
	log.Infof("CrossUnionFight.OnStart")

	var model *DBForGame
	util.WithGuard(g, func() {
		model = g.getDBForGame()
	})
	// init
	g.eventToGame("init", EventToGame{Model: model}, true, false)

	// 确定入选公会名单
	g.initJoinUnions()

	// 初始化完 周五 8点50准备
	now := util.Now()
	duration := prePrepareTime.CombineDateInt(g.Date()).AddDate(0, 0, 1).Sub(now)
	if TestInQuick {
		duration = time.Second * 2
	}
	log.Infof("CrossUnionFight status %s next prePrepare time delta %s", g.Status(), duration)
	g.timer = time.AfterFunc(duration, g.onPrePrepare)
}

// 明确参赛公会名单
func (g *CrossUnionFightGlobal) initJoinUnions() {
	log.Infof("CrossUnionFight.initJoinUnions")

	response := g.eventToGame("pointRank", EventToGame{}, true, false)
	if response == nil {
		log.Warningf("initJoinUnions may be some error happened")
		return
	}
	unionIDs, unions := g.queryJoinUnions(response)
	if len(unions) == 0 {
		log.Warningf("!!!!!! no unions")
		return
	}
	for _, union := range unions {
		log.Infof("union %s %v %s", union.ServerKey, union.UnionDbId, union.UnionName)
	}
	util.WithGuard(g, func() {
		g.SetUnions(unions)
	})
	g.eventToGame("joinUnions", EventToGame{UnionIDs: unionIDs}, true, false)
}

// 初赛 准备
func (g *CrossUnionFightGlobal) onPrePrepare() {
	log.Infof("CrossUnionFight.onPrePrepare")

	// 确定参赛玩家名单
	fightingPoints, roleIDs := g.initJoinRoles()

	// 初赛分组
	g.makePreGroups(fightingPoints)
	// 默认战场分布
	g.makeDeployRoles(PreStage)

	g.SetStatus(StatusPrePrepare)

	g.eventToGame("prePrepare", EventToGame{RoleIDs: roleIDs}, true, false)

	// 准备完 20:50 倒计时
	now := util.Now()
	duration := preStartTime.CombineDateInt(g.Date()).AddDate(0, 0, 1).Sub(now)

	if TestInQuick {
		duration = time.Second * 2
	}
	log.Infof("CrossUnionFight status %s next preStart time delta %s", g.Status(), duration)
	g.timer = time.AfterFunc(duration, g.onPreStart)
}

// 明确参赛玩家名单
func (g *CrossUnionFightGlobal) initJoinRoles() ([]int, []document.ID) {
	log.Infof("CrossUnionFight.initJoinRoles")

	fightingPoints := []int{}
	roleIDs := []document.ID{}

	// 根据公会名单 确认玩家名单
	d := make(map[string]*EventToGame)
	unions := g.Unions()
	for id, union := range unions {
		key := union.ServerKey
		if key == "" {
			continue
		}
		if _, ok := d[key]; !ok {
			d[key] = &EventToGame{UnionIDs: []document.ID{id}}
		} else {
			d[key].UnionIDs = append(d[key].UnionIDs, id)
		}
	}
	unionsMembersResp := g.eventToSomeGame("unionsMembers", d, true)
	if unionsMembersResp == nil {
		log.Warningf("unionsMembers may be some error happened")
		return fightingPoints, roleIDs
	}

	roles := map[document.ID]*scheme.CrossUnionFightRoleInfo{}
	for _, resp := range unionsMembersResp {
		for unionID, info := range resp.UnionsMembers {
			unionInfo, ok := unions[unionID]
			if !ok {
				continue
			}
			unionInfo.ServerKey = info.GameKey
			unionInfo.ChairmanDbID = info.ChairmanDbID
			chairmanInfo := g.queryChairmanInfo(info.ChairmanDbID, info.GameKey)
			unionInfo.ChairmanName = chairmanInfo.ChairmanName
			if unionInfo.ChairmanName == "" {
				unionInfo.ChairmanName = unionInfo.UnionName // 会长名字没有 则用公会名字
			}
			unionInfo.ChairmanTitle = chairmanInfo.ChairmanTitle
			unionInfo.ChairmanFigure = chairmanInfo.ChairmanFigure
			// 玩法中数据
			unionRoleIDs, fightingPoint := g.queryUnionRoles(unionID, info, roles)
			unionInfo.RoleDbIds = unionRoleIDs
			unionInfo.SignsCount = len(unionRoleIDs)
			unionInfo.LiveCount = len(unionRoleIDs)
			unionInfo.FightingPoint = fightingPoint

			fightingPoints = append(fightingPoints, fightingPoint)
			unions[unionID] = unionInfo

			roleIDs = append(roleIDs, unionRoleIDs...)
		}
	}

	if len(roles) == 0 {
		log.Warningf("!!!!!! no roles")
		return fightingPoints, roleIDs
	}
	util.WithGuard(g, func() {
		g.SetUnions(unions)
		g.SetRoles(roles)
	})
	for _, union := range unions {
		log.Infof("union %s %v %s size %d", union.ServerKey, union.UnionDbId, union.UnionName, len(union.RoleDbIds))
	}
	log.Infof("CrossUnionFight allJoinRoles size %d", len(roles))

	return fightingPoints, roleIDs
}

// 初赛 战斗倒计时
func (g *CrossUnionFightGlobal) onPreStart() {
	log.Infof("CrossUnionFight.onPreStart")

	g.SetStatus(StatusPreStart)
	g.eventToGame("preStart", EventToGame{}, true, false)

	// 准备完 21点比赛
	now := util.Now()
	duration := preBattleTime.CombineDateInt(g.Date()).AddDate(0, 0, 1).Sub(now)

	if TestInQuick {
		duration = time.Second * 2
	}

	log.Infof("CrossUnionFight status %s next preBattle time delta %s", g.Status(), duration)
	g.timer = time.AfterFunc(duration, g.onPreBattle)
}

// 初赛 战斗开始
func (g *CrossUnionFightGlobal) onPreBattle() {
	log.Infof("CrossUnionFight.onPreBattle")

	g.SetStatus(StatusPreBattle)
	g.eventToGame("preBattle", EventToGame{}, true, false)

	groupSize := len(g.PreBattleGroups())
	// 组内每个战场 四个公会全部成员混战，随机匹配
	g.mgr.SetTimerDuration(BattleAgentTimerDuration)
	g.mgr.Start()
	// 初始化
	atomic.StoreInt32(&g.playStatus, 0)
	g.groupBtResultMap = map[document.Integer]map[document.Integer][]manager.Result{}
	// 启动接收
	go g.receiveAntiPlayResult()

	var wg sync.WaitGroup
	wg.Add(groupSize * 3)
	for group := 1; group <= groupSize; group++ {
		for by := 1; by <= 3; by++ {
			go func(group int, by int) {
				g.onStartBattle(group, by)
				log.Infof("CrossUnionFight.onPreBattle group %d battleType %d battleEnd", group, by)
				wg.Done()
			}(group, by)
		}
	}
	wg.Wait()
	g.mgr.Stop()

	atomic.StoreInt32(&g.playStatus, 1)
	log.Infof("CrossUnionFight.onPreBattle antiSend %d antiAccept %d danSend %d allAccept %d resend %d",
		g.antiSendCount, g.antiAcceptCount, g.danSendCount, g.allAcceptCount, g.antiResendCount)

	g.onPreOver()
}

// 初赛 战斗结束
func (g *CrossUnionFightGlobal) onPreOver() {
	log.Infof("CrossUnionFight.onPreOver")

	g.cleanBattle()

	g.SetStatus(StatusPreOver)

	groupSize := len(g.PreBattleGroups())
	// 构建排行榜
	for group := 1; group <= groupSize; group++ {
		g.makeRanks(group)
	}

	// 确定决赛名单
	g.makeTopGroup()

	// 处理竞猜结果
	for group := 1; group <= groupSize; group++ {
		g.onBetResult(group)
	}

	toGameModel := EventToGame{
		LastRanks:   g.PrePointRanks(),
		LastResults: g.PreRoundResults(),
		LastBets:    g.Bets(),
	}
	g.eventToGame("preOver", toGameModel, true, false)

	// 比赛完 21点30 发奖励
	now := util.Now()
	duration := preAwardTime.CombineDateInt(g.Date()).AddDate(0, 0, 1).Sub(now)
	if TestInQuick {
		duration = time.Second * 2
	}
	log.Infof("CrossUnionFight status %s next preAward time delta %s", g.Status(), duration)
	g.timer = time.AfterFunc(duration, g.onPreAward)
}

// 初赛 结束 发奖励
func (g *CrossUnionFightGlobal) onPreAward() {
	log.Infof("CrossUnionFight.onPreAward")

	// 发初赛排行奖励
	d := g.onRankAward(PreStage)

	g.SetStatus(StatusPreAward)
	g.eventToSomeGame("preAward", d, true)

	g.onHalftime()
}

func (g *CrossUnionFightGlobal) onHalftime() {
	// 初赛完成 周日 9点 决赛准备
	now := util.Now()
	duration := topPrepareTime.CombineDateInt(g.Date()).AddDate(0, 0, 3).Sub(now)
	if TestInQuick {
		duration = time.Second * 2
	}
	log.Infof("CrossUnionFight status %s next topPrepare time delta %s", g.Status(), duration)
	g.timer = time.AfterFunc(duration, g.onTopPrepare)
}

// 决赛 准备
func (g *CrossUnionFightGlobal) onTopPrepare() {
	log.Infof("CrossUnionFight.onTopPrepare")
	g.SetStatus(StatusTopPrepare)
	g.eventToGame("topPrepare", EventToGame{}, true, false)

	// 原有数据重置
	g.onTopPrepareReset()

	// 默认战场分布
	g.makeDeployRoles(TopStage)

	// 周日 准备完 20:50 倒计时
	now := util.Now()
	duration := topStartTime.CombineDateInt(g.Date()).AddDate(0, 0, 3).Sub(now)
	if TestInQuick {
		duration = time.Second * 2
	}
	log.Infof("CrossUnionFight status %s next topStart time delta %s", g.Status(), duration)
	g.timer = time.AfterFunc(duration, g.onTopStart)
}

// 决赛 战斗倒计时
func (g *CrossUnionFightGlobal) onTopStart() {
	log.Infof("CrossUnionFight.onTopStart")

	g.SetStatus(StatusTopStart)
	g.eventToGame("topStart", EventToGame{}, true, false)

	// 周日 21点 决赛开始
	now := util.Now()
	duration := topBattleTime.CombineDateInt(g.Date()).AddDate(0, 0, 3).Sub(now)

	if TestInQuick {
		duration = time.Second * 2
	}

	log.Infof("CrossUnionFight status %s next topBattle time delta %s", g.Status(), duration)
	g.timer = time.AfterFunc(duration, g.onTopBattle)
}

// 决赛 战斗开始
func (g *CrossUnionFightGlobal) onTopBattle() {
	log.Infof("CrossUnionFight.onTopBattle")
	g.SetStatus(StatusTopBattle)
	g.eventToGame("topBattle", EventToGame{}, true, false)

	g.mgr.SetTimerDuration(BattleAgentTimerDuration)
	g.mgr.Start()
	// 初始化
	atomic.StoreInt32(&g.playStatus, 0)
	g.groupBtResultMap = map[document.Integer]map[document.Integer][]manager.Result{}
	// 启动接收
	go g.receiveAntiPlayResult()

	var wg sync.WaitGroup
	wg.Add(3)
	for by := 1; by <= 3; by++ {
		go func(by int) {
			g.onStartBattle(TopGroup, by)
			log.Infof("CrossUnionFight.onTopBattle group %d battleType %d battleEnd", TopGroup, by)
			wg.Done()
		}(by)
	}
	wg.Wait()
	g.mgr.Stop()

	atomic.StoreInt32(&g.playStatus, 2)
	log.Infof("CrossUnionFight.onTopBattle antiSend %d antiAccept %d danSend %d allAccept %d resend %d",
		g.antiSendCount, g.antiAcceptCount, g.danSendCount, g.allAcceptCount, g.antiResendCount)

	g.onTopOver()
}

// 决赛 战斗结束
func (g *CrossUnionFightGlobal) onTopOver() {
	log.Infof("CrossUnionFight.onTopOver")

	g.cleanBattle()

	g.SetStatus(StatusTopOver)

	// 构建排行榜
	g.makeRanks(TopGroup)

	// 处理竞猜结果
	g.onBetResult(TopGroup)

	topRanks := map[document.Integer][]*scheme.CrossUnionFightRankPoint{TopGroup: g.TopPointRanks()}
	topResults := map[document.Integer]map[document.Integer][]*scheme.CrossUnionFightResultInfo{TopGroup: g.TopRoundResults()}
	toGameModel := EventToGame{
		LastRanks:   topRanks,
		LastBets:    g.Bets(),
		LastResults: topResults,
	}
	g.eventToGame("topOver", toGameModel, true, false)

	// 周日 21点30 决赛结束 发奖励
	now := util.Now()
	duration := closeTime.CombineDateInt(g.Date()).AddDate(0, 0, 3).Sub(now)
	if TestInQuick {
		TestInQuick = false
		duration = time.Second * 2
	}
	log.Infof("CrossUnionFight status %s next closed time delta %s", g.Status(), duration)
	g.timer = time.AfterFunc(duration, g.onClosed)
}

// 决赛 结束 发奖励
func (g *CrossUnionFightGlobal) onClosed() {
	log.Infof("CrossUnionFight.onClosed")

	// 发决赛排行奖励
	d := g.onRankAward(TopStage)

	g.SetStatus(StatusClosed)
	g.eventToSomeGame("topAward", d, true)

	lastUnions := g.makeLastUnions()
	lastRoles := g.makeLastRoles()
	lastBattleGroups := g.makeLastBattleGroups()
	g.eventToGame("closed", EventToGame{LastUnions: lastUnions, LastRoles: lastRoles, LastBattleGroups: lastBattleGroups}, true, false)

	g.clean()
}

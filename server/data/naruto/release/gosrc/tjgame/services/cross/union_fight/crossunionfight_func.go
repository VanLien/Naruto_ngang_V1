/*
 * @Date    : 2021/9/19 18:56
 * @File    : crossunionfight_func.go
 * @Version : 1.0.0
 * @Author  : hss
 * @Note    :
 *
 */

package union_fight

import (
	"sort"
	"sync"
	"sync/atomic"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/anti-cheat/manager"
	"tjgame/services/game"
)

// 清理数据
func (g *CrossUnionFightGlobal) clean() {
	log.Infof("CrossUnionFight.clean %d %s", g.Date(), g.Status())
	g.SetStatus(StatusClosed)
}

// 重置
func (g *CrossUnionFightGlobal) reset() {
	log.Info("CrossUnionFight reset")

	g.SetStatus(StatusClosed)
	g.SetRoles(map[document.ID]*scheme.CrossUnionFightRoleInfo{})
	g.SetUnions(map[document.ID]*scheme.CrossUnionFightUnionInfo{})

	g.SetPreBattleGroups(map[document.Integer][]*scheme.CrossUnionFightUnion{})
	g.SetPreRoundResults(map[document.Integer]map[document.Integer][]*scheme.CrossUnionFightResultInfo{})
	g.SetPrePointRanks(map[document.Integer][]*scheme.CrossUnionFightRankPoint{})

	g.SetTopBattleGroups([]*scheme.CrossUnionFightUnion{})
	g.SetTopRoundResults(map[document.Integer][]*scheme.CrossUnionFightResultInfo{})
	g.SetTopPointRanks([]*scheme.CrossUnionFightRankPoint{})

	g.SetBets(map[document.Integer]map[document.ID]*scheme.CrossUnionFightBet{})

	g.groupRolesMap = sync.Map{}
	g.cleanBattle()
}

// 清除战斗计数
func (g *CrossUnionFightGlobal) cleanBattle() {
	atomic.StoreInt32(&g.antiSendCount, 0)
	atomic.StoreInt32(&g.antiAcceptCount, 0)
	atomic.StoreInt32(&g.danSendCount, 0)
	atomic.StoreInt32(&g.allAcceptCount, 0)
	atomic.StoreInt32(&g.antiResendCount, 0)
	g.playMap = sync.Map{}
	g.rounds = map[document.Integer]map[document.Integer]int{}
}

// 清除初赛信息
func (g *CrossUnionFightGlobal) clearPreBattle() {
	log.Info("CrossUnionFight clearPreBattle")
	g.SetStatus(StatusPreStart)

	g.SetPreRoundResults(map[document.Integer]map[document.Integer][]*scheme.CrossUnionFightResultInfo{})
	g.SetPrePointRanks(map[document.Integer][]*scheme.CrossUnionFightRankPoint{})
	g.SetTopBattleGroups([]*scheme.CrossUnionFightUnion{})

	g.SetBets(map[document.Integer]map[document.ID]*scheme.CrossUnionFightBet{})

	g.cleanBattle()
}

// 清除决赛赛信息
func (g *CrossUnionFightGlobal) clearTopBattle() {
	log.Info("CrossUnionFight clearTopBattle")
	g.SetStatus(StatusTopStart)

	g.SetTopRoundResults(map[document.Integer][]*scheme.CrossUnionFightResultInfo{})
	g.SetTopPointRanks([]*scheme.CrossUnionFightRankPoint{})

	delete(g.Bets(), TopGroup)
	g.SetBets(g.Bets())

	g.cleanBattle()
}

// 反作弊管理
func (g *CrossUnionFightGlobal) SetAgentManager(name string, agent service.IService) {
	if g.mgr != nil {
		g.mgr.Stop()
		g.mgr = nil
	}
	g.mgr = manager.NewAgentManager(name, "NewCrossUnionFightBattle", agent)
}

// 服务是否存在 server_key
func (g *CrossUnionFightGlobal) isServerOK(key string) bool {
	db := g.GetLockedDB()
	if csv.GetMergeConfig().IsMergeKeyInServers(key, db.Servers) {
		return true
	}
	return false
}

// 同步到game
func (g *CrossUnionFightGlobal) getDBForGame() *DBForGame {
	db := g.GetLockedDB()
	data := &DBForGame{
		Servers: db.Servers,
		CsvId:   db.CsvId,
		Date:    db.Date,
		Status:  db.Status,
	}
	data.JoinUnions = make([]document.ID, 0, len(db.Unions))
	for unionID := range db.Unions {
		data.JoinUnions = append(data.JoinUnions, unionID)
	}
	data.JoinRoles = make([]document.ID, 0, len(db.Roles))
	for roleID := range db.Roles {
		data.JoinRoles = append(data.JoinRoles, roleID)
	}
	return data
}

// sync数据
func (g *CrossUnionFightGlobal) syncModel() *SyncModel {
	return &SyncModel{
		Status: g.Status(),
	}
}

// 事件通知到game (init)
func (g *CrossUnionFightGlobal) eventToGame(event string, data EventToGame, sync bool, mergeFilter bool) map[string]*game.CrossUnionFightEventResponse {
	servers := g.Servers()
	if mergeFilter {
		servers = csv.GetMergeConfig().FilterMergeServer(servers)
	}

	d := make(map[string]*EventToGame)
	for _, key := range servers {
		d[key] = &data
	}
	return g.eventToSomeGame(event, d, sync)
}

// 事件通知到部分game ()
func (g *CrossUnionFightGlobal) eventToSomeGame(event string, d map[string]*EventToGame, sync bool) map[string]*game.CrossUnionFightEventResponse {
	var model *SyncModel
	if sync {
		model = g.syncModel()
	}
	keys := make([]string, 0, len(d))
	futures := make([]*service.Future, 0, len(d))
	for key, data := range d {
		keys = append(keys, key)
		s := g.container.GetService(key)
		future := service.CallAsync(s, "CrossUnionFightEvent", event, key, data, model)
		futures = append(futures, future)
	}

	ret := make(map[string]*game.CrossUnionFightEventResponse)
	resp, err := service.MultiFuture(futures, false).Get()
	if err != nil {
		log.Warningf("CrossUnionFightEvent %s response error %v", event, err)
		return nil
	}
	response := resp.([]interface{})
	for i, key := range keys {
		ret[key] = response[i].(*game.CrossUnionFightEventResponse)
	}
	return ret
}

// 入选公会名单
func (g *CrossUnionFightGlobal) queryJoinUnions(pointRankResp map[string]*game.CrossUnionFightEventResponse) ([]document.ID, map[document.ID]*scheme.CrossUnionFightUnionInfo) {
	log.Infof("CrossUnionFight.queryJoinUnions")
	// 统筹处理入选公会
	unionSet := util.NewSet()
	infos := make(map[document.ID]*scheme.UnionFightPointRankInfo)
	isFinish := false
	for i := 0; i < 16; i++ { // 找的遍数 第一遍取第一名、第二遍取第二名
		if isFinish {
			break
		}
		// 同排名的 先根据积分再排名
		rankInfos := []*scheme.UnionFightPointRankInfo{}
		for _, resp := range pointRankResp {
			unionFightPointRank := resp.UnionFightPointRank
			if i > len(unionFightPointRank)-1 {
				continue
			}
			pointRankInfo := unionFightPointRank[i]
			rankInfos = append(rankInfos, pointRankInfo)
		}
		newRankInfos := makeJoinRanks(rankInfos)
		// 取入选
		for _, pointRankInfo := range newRankInfos {
			if unionSet.Size() >= 16 { // 总找到16个结束
				isFinish = true
				break
			} else {
				unionID := pointRankInfo.UnionDbId
				if unionSet.Contains(unionID) {
					continue
				}
				unionSet.Add(unionID)
				infos[unionID] = pointRankInfo
			}
		}
	}
	size := unionSet.Size()
	if size < 16 {
		log.Warningf("CrossUnionFight.makeJoinUnions count %v not enough error", size)
	}
	unions := make(map[document.ID]*scheme.CrossUnionFightUnionInfo, size)
	unionIDs := make([]document.ID, 0, size)
	unionSet.Range(func(i interface{}) bool {
		unionID := i.(document.ID)
		unionIDs = append(unionIDs, unionID)
		unions[unionID] = &scheme.CrossUnionFightUnionInfo{
			CrossUnionFightUnion: scheme.CrossUnionFightUnion{
				UnionDbId: unionID,
				UnionName: infos[unionID].UnionName,
				UnionLogo: infos[unionID].UnionLogo,
				ServerKey: infos[unionID].GameKey,
			},
		}
		return true
	})
	return unionIDs, unions
}

// 查询会长信息
func (g *CrossUnionFightGlobal) queryChairmanInfo(chairmanDbID document.ID, serverKey string) *RespChairmanInfo {
	pvpService := g.container.GetService(service.Game2PVPService(serverKey))
	roleRecord, err := service.CallWithTimeout(pvpService, "GetCrossUnionFightRoleRecordByRoleID", 10*time.Second, chairmanDbID)
	chairmanInfo := RespChairmanInfo{}
	if err != nil {
		chairmanInfo.ChairmanFigure = 1
		chairmanInfo.ChairmanTitle = -1
		chairmanInfo.ChairmanName = ""
		return &chairmanInfo
	}
	record := roleRecord.(*scheme.CrossUnionFightRoleRecordObject)
	chairmanInfo.ChairmanFigure = record.RoleFigure()
	chairmanInfo.ChairmanTitle = record.RoleTitle()
	chairmanInfo.ChairmanName = record.RoleName()
	return &chairmanInfo
}

// 入选玩家名单
func (g *CrossUnionFightGlobal) queryUnionRoles(unionID document.ID, unionInfo *game.UnionInfo, roles map[document.ID]*scheme.CrossUnionFightRoleInfo) ([]document.ID, int) {
	members := unionInfo.Members
	fightingPoint := 0
	unionRoleIDs := make([]document.ID, 0, len(members))
	var wg sync.WaitGroup
	wg.Add(len(members))
	roleInfos := make(chan *scheme.CrossUnionFightRoleInfo, 64)
	go func() {
		for roleInfo := range roleInfos {
			roles[roleInfo.RoleDbId] = roleInfo
			fightingPoint += roleInfo.FightingPoint
			unionRoleIDs = append(unionRoleIDs, roleInfo.RoleDbId)
			wg.Done()
		}
	}()
	for _, v := range members {
		go func(member *scheme.UnionMember) {
			roleInfo, flag := g.makeRoleInfo(ReqRoleInfo{
				RoleID:    member.ID,
				UnionID:   unionID,
				ServerKey: unionInfo.GameKey, // TODO: 不准确
			})
			if !flag {
				wg.Done()
			} else {
				roleInfos <- roleInfo
			}
		}(v)
	}
	wg.Wait()
	close(roleInfos)
	return unionRoleIDs, fightingPoint
}

// 初赛准备 构建roles 每个玩家
func (g *CrossUnionFightGlobal) makeRoleInfo(req ReqRoleInfo) (*scheme.CrossUnionFightRoleInfo, bool) {
	// 判断 CrossUnionFightRoleRecord 是否存在
	pvpService := g.container.GetService(service.Game2PVPService(req.ServerKey))
	roleRecord, err := service.Call(pvpService, "GetCrossUnionFightRoleRecordByRoleID", req.RoleID)
	if err != nil {
		return nil, false
	}

	record := roleRecord.(*scheme.CrossUnionFightRoleRecordObject)
	roleInfo := &scheme.CrossUnionFightRoleInfo{}
	roleInfo.RecordID = record.GetID()
	roleInfo.RoleDbId = req.RoleID
	roleInfo.ServerKey = req.ServerKey
	roleInfo.RoleName = record.RoleName()
	roleInfo.RoleLogo = record.RoleLogo()
	roleInfo.RoleFrame = record.RoleFrame()
	roleInfo.RoleLevel = record.RoleLevel()
	project := record.InitProject()
	util.WithGuard(g, func() {
		if oldProject, ok := roleInfo.Projects[PreStage]; ok {
			if oldProject != project {
				g.updateDeployRoles(req.RoleID, req.UnionID, PreStage, project)
			}
			roleInfo.Projects[PreStage] = project
		} else {
			roleInfo.Projects = map[document.Integer]int{PreStage: project}
		}
	})
	cardIDs := record.Cards()[PreStage][document.Integer(project)]
	roleInfo.FightingPoint = makeRoleFightingPoint(cardIDs, record.CardAttrs())
	roleInfo.CurTroop = 1                                                  // 默认 队伍一
	roleInfo.CardState = map[document.Integer]map[document.ID][2]float64{} // {队伍: {卡牌: (hp, mp)}}
	roleInfo.UnionDbId = req.UnionID
	roleInfo.BattleTimes = 0 // 默认为0

	return roleInfo, true
}

// 初赛准备 战斗小组分组
func (g *CrossUnionFightGlobal) makePreGroups(fightingPoints []int) {
	log.Infof("CrossUnionFight.makePreGroups")
	db, unlock := g.LockAndGetDB()
	defer unlock()
	unions := db.Unions

	preBattleGroups := map[document.Integer][]*scheme.CrossUnionFightUnion{}
	tabs := map[document.Integer][]int{
		1: {1, 8, 9, 16},
		2: {2, 7, 10, 15},
		3: {3, 6, 11, 14},
		4: {4, 5, 12, 13},
	}
	// 逆序排序
	sort.Sort(sort.Reverse(sort.IntSlice(fightingPoints)))
	for i, fp := range fightingPoints {
		for unionID, unionInfo := range unions {
			if unionInfo.FpRank != 0 || unionInfo.UnionDbId == "" {
				continue
			}
			if unionInfo.FightingPoint == fp {
				rank := i + 1
				unions[unionID].FpRank = rank
				break
			}
		}
	}
	newUnions := map[document.ID]*scheme.CrossUnionFightUnionInfo{}
	// 分组
	for unionID, unionInfo := range unions {
		if unionInfo.UnionDbId != "" {
			for group, gRanks := range tabs {
				if InArrayInt(unionInfo.FpRank, gRanks) {
					unionBase := &scheme.CrossUnionFightUnion{
						UnionDbId:     unionInfo.UnionDbId,
						UnionName:     unionInfo.UnionName,
						UnionLogo:     unionInfo.UnionLogo,
						ServerKey:     unionInfo.ServerKey,
						SignsCount:    unionInfo.SignsCount,
						ChairmanDbID:  unionInfo.ChairmanDbID,
						FightingPoint: unionInfo.FightingPoint,
					}
					if battleGroup, ok := preBattleGroups[group]; ok {
						battleGroup = append(battleGroup, unionBase)
						preBattleGroups[group] = battleGroup
						unionInfo.Group = int(group)
					} else {
						battleGroup = []*scheme.CrossUnionFightUnion{unionBase}
						preBattleGroups[group] = battleGroup
						unionInfo.Group = int(group)
					}
				}
			}
			newUnions[unionID] = unionInfo
		}
	}
	g.SetUnions(newUnions)
	g.SetPreBattleGroups(preBattleGroups)
}

// 初/决赛准备 构建战场分布
func (g *CrossUnionFightGlobal) makeDeployRoles(stage int) {
	log.Infof("CrossUnionFight.makeDeployRoles stage %d", stage)
	db, unlock := g.LockAndGetDB()
	defer unlock()
	unions := db.Unions
	roles := db.Roles

	for _, unionInfo := range unions {
		// 是否进 决赛
		if stage == TopStage && !g.isInTopBattleGroups(unionInfo.UnionDbId) {
			continue
		}
		deployRoles := map[document.Integer][]document.ID{}
		for _, roleID := range unionInfo.RoleDbIds {
			roleInfo := roles[roleID]
			project, ok := roleInfo.Projects[document.Integer(stage)]
			if ok && project != 0 {
				if dRoles, ok := deployRoles[document.Integer(project)]; ok {
					dRoles = append(dRoles, roleID)
					deployRoles[document.Integer(project)] = dRoles
				} else {
					dRoles = []document.ID{roleID}
					deployRoles[document.Integer(project)] = dRoles
				}
			}
		}
		if stage == PreStage {
			unionInfo.PreDeployRoles = deployRoles
		} else {
			unionInfo.TopDeployRoles = deployRoles
		}
	}
	g.SetUnions(unions)
}

// 战斗中 获取战报
func (g *CrossUnionFightGlobal) getBattleResults(group, project, start int) (resp []*scheme.CrossUnionFightResultInfo) {
	db, unlock := g.LockAndGetDB()
	defer unlock()

	results := []*scheme.CrossUnionFightResultInfo{}
	if group != TopGroup {
		// {组别: {战场: [CrossUnionFightResultInfo]}}
		preRoundResults := db.PreRoundResults
		if groupResults, ok := preRoundResults[document.Integer(group)]; ok {
			if btResults, ok := groupResults[document.Integer(project)]; ok {
				results = btResults
			}
		}
	} else {
		// {战场: [CrossUnionFightResultInfo]}
		topRoundResults := db.TopRoundResults
		if btResults, ok := topRoundResults[document.Integer(project)]; ok {
			results = btResults
		}
	}
	if start <= 0 {
		resp = results
		return
	}
	// 切割后
	var newResults []*scheme.CrossUnionFightResultInfo
	if len(results) >= start {
		newResults = results[start-1:]
	} else {
		newResults = []*scheme.CrossUnionFightResultInfo{}
	}
	resp = newResults
	return
}

// 获取小组中所有玩家名单
func (g *CrossUnionFightGlobal) getGroupRoleIDs(group int) []document.ID {
	db := g.GetLockedDB()

	roleIDs := []document.ID{}
	var unionInfos []*scheme.CrossUnionFightUnion
	var unions map[document.ID]*scheme.CrossUnionFightUnionInfo

	if group != TopGroup {
		unionInfos = db.PreBattleGroups[document.Integer(group)]
	} else {
		unionInfos = db.TopBattleGroups
	}
	unions = g.Unions()

	for _, unionInfo := range unionInfos {
		for _, union := range unions {
			if unionInfo.UnionDbId == union.UnionDbId {
				roleIDs = append(roleIDs, union.RoleDbIds...)
				break
			}
		}
	}
	g.groupRolesMap.Store(group, roleIDs)
	return roleIDs
}

// 初/决赛战斗结束 构建排行榜
func (g *CrossUnionFightGlobal) makeRanks(group int) {
	log.Infof("CrossUnionFight.makeRanks group %d", group)
	db, unlock := g.LockAndGetDB()
	defer unlock()
	unions := db.Unions

	unionIDs := []document.ID{}
	if group != TopGroup {
		for _, union := range g.PreBattleGroups()[document.Integer(group)] {
			unionIDs = append(unionIDs, union.UnionDbId)
		}
	} else {
		for _, union := range g.TopBattleGroups() {
			unionIDs = append(unionIDs, union.UnionDbId)
		}
	}
	sort.Slice(unionIDs, func(i, j int) bool {
		id1 := unionIDs[i]
		id2 := unionIDs[j]
		if unions[id1].Point != unions[id2].Point {
			return unions[id1].Point > unions[id2].Point
		}
		return unions[id1].WinNum > unions[id2].WinNum
	})
	ranks := make([]*scheme.CrossUnionFightRankPoint, 0, len(unionIDs))
	for _, unionID := range unionIDs {
		unionInfo := unions[unionID]
		unionBase := scheme.CrossUnionFightUnion{
			UnionDbId:     unionInfo.UnionDbId,
			UnionName:     unionInfo.UnionName,
			UnionLogo:     unionInfo.UnionLogo,
			ServerKey:     unionInfo.ServerKey,
			SignsCount:    unionInfo.SignsCount,
			ChairmanDbID:  unionInfo.ChairmanDbID,
			FightingPoint: unionInfo.FightingPoint,
		}
		rankInfo := &scheme.CrossUnionFightRankPoint{
			CrossUnionFightUnion: unionBase,
			Point:                unionInfo.Point,
			AliveCount:           unionInfo.LiveCount,
			WinNum:               unionInfo.WinNum,
		}
		ranks = append(ranks, rankInfo)
	}

	if group != TopGroup {
		pointRanks := db.PrePointRanks
		pointRanks[document.Integer(group)] = ranks
		g.SetPrePointRanks(pointRanks)
	} else {
		g.SetTopPointRanks(ranks)
	}

}

// 初赛战斗结束 构建决赛分组
func (g *CrossUnionFightGlobal) makeTopGroup() {
	log.Infof("CrossUnionFight.makeTopGroup")
	db, unlock := g.LockAndGetDB()
	defer unlock()

	topGroups := []*scheme.CrossUnionFightUnion{}
	pointRanks := db.PrePointRanks
	// 取每个小组排行榜的第一名
	for _, ranks := range pointRanks {
		if len(ranks) > 0 {
			No1Rank := ranks[0]
			topGroups = append(topGroups, &No1Rank.CrossUnionFightUnion)
		}
	}
	g.SetTopBattleGroups(topGroups)
}

// 初/决赛战斗结束 处理竞猜结果
func (g *CrossUnionFightGlobal) onBetResult(group int) {
	log.Infof("CrossUnionFight.onBetResult group %d", group)
	db, unlock := g.LockAndGetDB()
	defer unlock()

	bets := db.Bets
	groupBets := map[document.ID]*scheme.CrossUnionFightBet{}
	if _, ok := bets[document.Integer(group)]; ok {
		groupBets = bets[document.Integer(group)]
	}
	if group != TopGroup {
		pointRanks := db.PrePointRanks
		// 取每个小组排行榜的第一名
		for _, ranks := range pointRanks {
			if len(ranks) > 0 {
				No1Rank := ranks[0]
				if betInfo, ok := groupBets[No1Rank.UnionDbId]; ok {
					betInfo.Success = true // 默认值是false 改为 true
					groupBets[No1Rank.UnionDbId] = betInfo
				}
			}
		}
	} else {
		ranks := db.TopPointRanks
		if len(ranks) > 0 {
			No1Rank := ranks[0]
			if betInfo, ok := groupBets[No1Rank.UnionDbId]; ok {
				betInfo.Success = true // 默认值是false 改为 true
				groupBets[No1Rank.UnionDbId] = betInfo
			}
		}
	}
	bets[document.Integer(group)] = groupBets
	g.SetBets(bets)
}

// 初/决赛9点30 处理排行奖励
func (g *CrossUnionFightGlobal) onRankAward(stage int) map[string]*EventToGame {
	log.Infof("CrossUnionFight.onRankAward stage %d", stage)
	db, unlock := g.RLockAndGetDB()
	defer unlock()

	unions := db.Unions
	d := make(map[string]*EventToGame) // {gameKey: EventToGame}
	if stage == PreStage {
		for _, ranks := range db.PrePointRanks {
			for _, rankInfo := range ranks {
				gameKey := rankInfo.ServerKey
				if gameKey == "" {
					continue
				}
				if _, ok := d[gameKey]; !ok {
					d[gameKey] = &EventToGame{
						UnionRoles: make(map[document.ID][]document.ID),
					}
				}
				unionID := rankInfo.UnionDbId
				d[gameKey].UnionRoles[unionID] = unions[unionID].RoleDbIds
			}
		}
	} else {
		for _, rankInfo := range db.TopPointRanks {
			gameKey := rankInfo.ServerKey
			if gameKey == "" {
				continue
			}
			if _, ok := d[gameKey]; !ok {
				d[gameKey] = &EventToGame{
					UnionRoles: make(map[document.ID][]document.ID),
				}
			}
			unionID := rankInfo.UnionDbId
			d[gameKey].UnionRoles[unionID] = unions[unionID].RoleDbIds
		}
	}
	return d
}

// 竞猜名单 (暂不用)
func (g *CrossUnionFightGlobal) onBatRoles(stage int) map[string]*EventToGame {
	log.Infof("CrossUnionFight.onBatRoles stage %d", stage)
	db, unlock := g.RLockAndGetDB()
	defer unlock()

	roles := db.Roles
	d := make(map[string]*EventToGame) // {gameKey: EventToGame}
	if stage == PreStage {
		for group := 1; group <= 4; group++ {
			bets := db.Bets[document.Integer(group)]
			for _, betInfo := range bets {
				for _, roleKey := range betInfo.RoleKeys {
					gameKey := roles[roleKey.ID].ServerKey
					if info, ok := d[gameKey]; ok {
						info.BetRoles = append(info.BetRoles, roleKey.ID)
						d[gameKey] = info
					} else {
						d[gameKey] = &EventToGame{
							BetRoles: []document.ID{roleKey.ID},
						}
					}
				}
			}
		}
	} else {
		bets := db.Bets[TopGroup]
		for _, betInfo := range bets {
			for _, roleKey := range betInfo.RoleKeys {
				gameKey := roles[roleKey.ID].ServerKey
				if info, ok := d[gameKey]; ok {
					info.BetRoles = append(info.BetRoles, roleKey.ID)
					d[gameKey] = info
				} else {
					d[gameKey] = &EventToGame{
						BetRoles: []document.ID{roleKey.ID},
					}
				}
			}
		}
	}
	return d
}

// 决赛准备 重置
func (g *CrossUnionFightGlobal) onTopPrepareReset() {
	log.Infof("CrossUnionFight.onTopPrepareReset")
	var roles map[document.ID]*scheme.CrossUnionFightRoleInfo
	groupRoles := []document.ID{} // [role.id]
	util.WithGuard(g, func() {
		roles = g.Roles()
		if roleIDs, ok := g.groupRolesMap.Load(TopGroup); ok {
			groupRoles = roleIDs.([]document.ID)
		}
		if len(groupRoles) == 0 {
			groupRoles = g.getGroupRoleIDs(TopGroup)
		}
	})

	// 原有数据重置
	recordList := make([]*scheme.CrossUnionFightRoleRecord, 0, len(groupRoles))
	for _, roleID := range groupRoles {
		if roleInfo, ok := roles[roleID]; ok {
			gameKey := roleInfo.ServerKey
			pvpService := g.container.GetService(service.Game2PVPService(gameKey))
			record := GetRemoteCrossUnionFightRoleRecord(pvpService, roleInfo.RecordID)
			recordList = append(recordList, record)
		}
	}

	util.WithGuard(g, func() {
		// Roles
		roles := g.Roles()
		for _, record := range recordList {
			roleID := record.RoleDbId
			if roleInfo, ok := roles[roleID]; ok {
				roleInfo.IsOut = false
				roleInfo.CurTroop = 1                                                  // 默认 队伍一
				roleInfo.CardState = map[document.Integer]map[document.ID][2]float64{} // {队伍: {卡牌: (hp, mp)}}
				roleInfo.BattleTimes = 0                                               // 默认为0
				project := record.TopInitProject
				if oldProject, ok := roleInfo.Projects[TopStage]; ok {
					if oldProject != project {
						g.updateDeployRoles(roleID, roleInfo.UnionDbId, TopStage, project)
					}
				}
				roleInfo.Projects[TopStage] = project
				cardIDs := record.Cards[TopStage][document.Integer(project)]
				roleInfo.FightingPoint = makeRoleFightingPoint(cardIDs, record.TopCardAttrs)
				roles[roleID] = roleInfo
			}
		}
		g.SetRoles(roles)

		// Unions
		unions := g.Unions()
		for _, top := range g.TopBattleGroups() {
			unionInfo := unions[top.UnionDbId]
			unionInfo.LiveCount = unionInfo.SignsCount
			unionInfo.IsOut = false
			unionInfo.WinNum = 0
			unionInfo.Point = 0
			unions[top.UnionDbId] = unionInfo
		}
		g.SetUnions(unions)
	})
}

// 是否进决赛
func (g *CrossUnionFightGlobal) isInTopBattleGroups(unionID document.ID) bool {
	db := g.GetLockedDB()
	topGroups := db.TopBattleGroups
	ret := false
	for _, groupInfo := range topGroups {
		if unionID == groupInfo.UnionDbId {
			ret = true
			break
		}
	}
	return ret
}

// 更新战报结果
func (g *CrossUnionFightGlobal) updateResultInfo(playRecord *CrossUnionFightPlayRecord, cardStateTmp1, cardStateTmp2 map[document.ID][2]float64, playResult string) *scheme.CrossUnionFightResultInfo {
	db := g.GetLockedDB()
	unions := db.Unions
	roles := db.Roles

	roleID1 := playRecord.RoleKey().ID
	roleID2 := playRecord.DefenceRoleKey().ID
	var unionID1, unionID2 document.ID
	if roleID1 != "" {
		unionID1 = roles[roleID1].UnionDbId
	}
	if roleID2 != "" {
		unionID2 = roles[roleID2].UnionDbId
	}

	resultInfo := &scheme.CrossUnionFightResultInfo{
		CrossKey: g.CrossKey,
		PlayID:   playRecord.GetID(),
		Round:    playRecord.Round(),
		Result:   playResult,
	}

	if roleID1 != "" && unionID1 != "" {
		union := unions[unionID1]
		resultInfo.Left = scheme.CrossUnionFightResultItem{
			RoleDbId:       roleID1,
			RoleRecordId:   roles[roleID1].RecordID,
			UnionDbId:      unionID1,
			UnionName:      union.UnionName,
			UnionPoint:     union.Point,
			UnionAlive:     union.LiveCount,
			WinNum:         union.WinNum,
			Troop:          roles[roleID1].CurTroop,
			TroopCardState: cardStateTmp1,
		}
	} else {
		resultInfo.Left = scheme.CrossUnionFightResultItem{}
	}

	if roleID2 != "" && unionID2 != "" {
		union := unions[unionID2]
		resultInfo.Right = scheme.CrossUnionFightResultItem{
			RoleDbId:       roleID2,
			RoleRecordId:   roles[roleID2].RecordID,
			UnionDbId:      unionID2,
			UnionName:      union.UnionName,
			UnionPoint:     union.Point,
			UnionAlive:     union.LiveCount,
			WinNum:         union.WinNum,
			Troop:          roles[roleID2].CurTroop,
			TroopCardState: cardStateTmp2,
		}
	} else {
		resultInfo.Right = scheme.CrossUnionFightResultItem{}
	}

	return resultInfo
}

// 构建 LastUnions
func (g *CrossUnionFightGlobal) makeLastUnions() map[document.ID]*scheme.CrossUnionFightGameUnion {
	db, unlock := g.LockAndGetDB()
	defer unlock()

	lastUnions := map[document.ID]*scheme.CrossUnionFightGameUnion{}
	for unionID, unionInfo := range db.Unions {
		unionBase := scheme.CrossUnionFightUnion{
			UnionDbId:      unionInfo.UnionDbId,
			UnionName:      unionInfo.UnionName,
			UnionLogo:      unionInfo.UnionLogo,
			ServerKey:      unionInfo.ServerKey,
			SignsCount:     unionInfo.SignsCount,
			ChairmanDbID:   unionInfo.ChairmanDbID,
			ChairmanName:   unionInfo.ChairmanName,
			ChairmanFigure: unionInfo.ChairmanFigure,
			ChairmanTitle:  unionInfo.ChairmanTitle,
			FightingPoint:  unionInfo.FightingPoint,
		}
		lastUnionInfo := &scheme.CrossUnionFightGameUnion{
			CrossUnionFightUnion: unionBase,
			PreDeployRoles:       unionInfo.PreDeployRoles,
			TopDeployRoles:       unionInfo.TopDeployRoles,
		}
		lastUnions[unionID] = lastUnionInfo
	}

	return lastUnions
}

// 构建 LastRoles
func (g *CrossUnionFightGlobal) makeLastRoles() map[document.ID]*scheme.CrossUnionFightRole {
	db, unlock := g.LockAndGetDB()
	defer unlock()

	lastRoles := map[document.ID]*scheme.CrossUnionFightRole{}
	for roleID, roleInfo := range db.Roles {
		roleBase := scheme.CrossUnionFightRole{
			RoleDbId:      roleInfo.RoleDbId,
			UnionDbId:     roleInfo.UnionDbId,
			RecordID:      roleInfo.RecordID,
			ServerKey:     roleInfo.ServerKey,
			RoleName:      roleInfo.RoleName,
			RoleLogo:      roleInfo.RoleLogo,
			RoleFrame:     roleInfo.RoleFrame,
			RoleLevel:     roleInfo.RoleLevel,
			RoleFigure:    roleInfo.RoleFigure,
			FightingPoint: roleInfo.FightingPoint,
		}
		lastRoles[roleID] = &roleBase
	}

	return lastRoles
}

// 构建 LastBattleGroups
func (g *CrossUnionFightGlobal) makeLastBattleGroups() map[document.Integer][]document.ID {
	db, unlock := g.LockAndGetDB()
	defer unlock()

	lastBattleGroups := map[document.Integer][]document.ID{}
	for group, groupUnions := range db.PreBattleGroups {
		unionIDs := make([]document.ID, 0, len(groupUnions))
		for _, unionBase := range groupUnions {
			unionIDs = append(unionIDs, unionBase.UnionDbId)
		}
		lastBattleGroups[group] = unionIDs
	}

	topUnionIDs := make([]document.ID, 0, len(db.TopBattleGroups))
	for _, unionBase := range db.TopBattleGroups {
		topUnionIDs = append(topUnionIDs, unionBase.UnionDbId)
	}
	lastBattleGroups[TopGroup] = topUnionIDs

	return lastBattleGroups
}

// 更新战斗结果积分
func (g *CrossUnionFightGlobal) updateBattleResultPoint(roleID1, roleID2, unionID1, unionID2 document.ID, battleType int, playResult string) {
	db := g.GetLockedDB()
	roles := db.Roles
	unions := db.Unions

	winPoint := GetConfig().WinPointMap[battleType]
	failPoint := GetConfig().FailPointMap[battleType]

	if roleID1 != "" && roleID2 != "" { // 轮空的不算积分

		role1 := roles[roleID1]
		if playResult == "win" {
			role1.Point += winPoint
		} else {
			role1.Point += failPoint
		}

		role2 := roles[roleID2]
		if playResult == "win" {
			role2.Point += failPoint
		} else {
			role2.Point += winPoint
		}

		if unionID1 != "" {
			unions1 := unions[unionID1]
			if playResult == "win" {
				unions1.Point += winPoint
			} else {
				unions1.Point += failPoint
			}
		}
		if unionID2 != "" {
			unions2 := unions[unionID2]
			if playResult == "win" {
				unions2.Point += failPoint
			} else {
				unions2.Point += winPoint
			}
		}
	}
	g.SetRoles(roles)
	g.SetUnions(unions)
}

// 更新战场分布
func (g *CrossUnionFightGlobal) updateDeployRoles(roleID, unionID document.ID, stage, project int) {
	db := g.GetLockedDB()
	unions := db.Unions
	unionInfo, ok := unions[unionID]

	if ok {
		// 拿
		deployRoles := make(map[document.Integer][]document.ID)
		if stage == PreStage {
			if unionInfo.PreDeployRoles != nil {
				deployRoles = unionInfo.PreDeployRoles
			}
		} else {
			if unionInfo.TopDeployRoles != nil {
				deployRoles = unionInfo.TopDeployRoles
			}
		}
		// 删
		oldProject := 0
		for pro, roleIDs := range deployRoles {
			if InArrayDbID(roleID, roleIDs) {
				oldProject = int(pro)
				break
			}
		}
		if oldProject != 0 {
			newRoleIDs := []document.ID{}
			for _, rID := range deployRoles[document.Integer(oldProject)] {
				if rID != roleID {
					newRoleIDs = append(newRoleIDs, rID)
				}
			}
			deployRoles[document.Integer(oldProject)] = newRoleIDs
		}
		// 加
		if roleIDs, ok := deployRoles[document.Integer(project)]; ok {
			roleIDs = append(roleIDs, roleID)
			deployRoles[document.Integer(project)] = roleIDs
		} else {
			roleIDs := []document.ID{roleID}
			deployRoles[document.Integer(project)] = roleIDs
		}
		if stage == PreStage {
			unionInfo.PreDeployRoles = deployRoles
		} else {
			unionInfo.TopDeployRoles = deployRoles
		}
		unions[unionID] = unionInfo
	}

	g.SetUnions(unions)
}

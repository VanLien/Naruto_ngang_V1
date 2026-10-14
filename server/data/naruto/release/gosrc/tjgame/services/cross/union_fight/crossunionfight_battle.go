/*
 * @Date    : 2021/9/21 14:31
 * @File    : crossunionfight_battle.go
 * @Version : 1.0.0
 * @Author  : hss
 * @Note    :
 *
 */

package union_fight

import (
	"math/rand"
	"sync/atomic"
	"time"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	anti_cheat "tjgame/services/anti-cheat"
	"tjgame/services/anti-cheat/manager"
)

// 战斗开始
func (g *CrossUnionFightGlobal) onStartBattle(group int, battleType int) {
	log.Infof("CrossUnionFight.onStartBattle %s group %d battleType %d", g.Status(), group, battleType)
	isOver := false
	// 匹配
	round := 0
	isOver, round = g.onMatch(group, battleType)
	for !isOver {
		// 战报结果检查
		g.onPlayResultCheck(group, battleType, round)
		// 继续匹配
		isOver, round = g.onMatch(group, battleType)
	}
}

// 战斗匹配
func (g *CrossUnionFightGlobal) onMatch(group int, battleType int) (bool, int) {
	var round int // 当前轮次
	util.WithGuard(g, func() {
		if gRound, ok := g.rounds[document.Integer(group)]; ok {
			if btRound, ok := gRound[document.Integer(battleType)]; ok {
				round = btRound + 1
			} else {
				round = 1
			}
			gRound[document.Integer(battleType)] = round
		} else {
			round = 1
			g.rounds[document.Integer(group)] = map[document.Integer]int{document.Integer(battleType): round}
		}
	})

	// 存活和出局 名单
	players, playerOuts := g.nextRoundPlayer(group, battleType)

	// 只剩下一个公会的人 比赛结束
	isOver := g.isBattleTypeOver(group, battleType, players)
	if isOver {
		return true, round
	}

	// 匹配 两两随机
	matchList, roleNum := g.nextRoundMatch(group, battleType, round, players)

	// 构建 战斗数据
	g.makeAndSendBattlePlays(group, battleType, round, players, matchList)

	log.Infof("CrossUnionFight.onMatch group %d battleType %d round %d players (%d/%d) matchList %d", group, battleType, round, roleNum, len(playerOuts), len(matchList))

	return false, round
}

// 战斗存活和出局玩家
func (g *CrossUnionFightGlobal) nextRoundPlayer(group, battleType int) (map[document.ID]*RoleInfo, []document.ID) {
	db, unlock := g.LockAndGetDB()
	defer unlock()
	roles := db.Roles

	players := make(map[document.ID]*RoleInfo) // {role.id: RoleInfo}
	playerOuts := []document.ID{}              // [role.id]
	groupRoleIDs := []document.ID{}            // [role.id] 小组所有成员
	if roleIDs, ok := g.groupRolesMap.Load(group); ok {
		groupRoleIDs = roleIDs.([]document.ID)
	}
	if len(groupRoleIDs) == 0 {
		groupRoleIDs = g.getGroupRoleIDs(group)
	}
	stage := PreStage
	if group == TopGroup {
		stage = TopStage
	}
	for _, gRoleID := range groupRoleIDs {
		if info, ok := roles[gRoleID]; ok {
			if info.Projects[document.Integer(stage)] == battleType {
				if !info.IsOut {
					players[gRoleID] = &RoleInfo{
						RoleID:    info.RoleDbId,
						RecordID:  info.RecordID,
						ServerKey: info.ServerKey,
						UnionID:   info.UnionDbId,
					}
				} else {
					playerOuts = append(playerOuts, gRoleID)
				}
			}
		}
	}
	return players, playerOuts
}

// 战场类型是否算完
func (g *CrossUnionFightGlobal) isBattleTypeOver(group, battleType int, players map[document.ID]*RoleInfo) bool {

	// 只剩下一个公会的人 比赛结束
	aliveUnions := util.NewSet()
	for _, roleInfo := range players {
		if roleInfo.UnionID != "" {
			aliveUnions.Add(roleInfo.UnionID)
		}
	}

	db, unlock := g.LockAndGetDB()
	defer unlock()
	unions := db.Unions

	if aliveUnions.Size() <= 1 {
		// 额外积分
		unionIDs := make([]document.ID, 0, aliveUnions.Size())
		aliveUnions.Range(func(i interface{}) bool {
			unionIDs = append(unionIDs, i.(document.ID))
			return true
		})
		if len(unionIDs) > 0 {
			unionID := unionIDs[0]
			extraPoint := GetConfig().ExtraPointMap[battleType]
			addPoint := len(players) * extraPoint
			unions[unionID].Point += addPoint
			g.SetUnions(unions)
		}
		return true
	}
	return false
}

// 战斗两两随机匹配
func (g *CrossUnionFightGlobal) nextRoundMatch(group, battleType, round int, players map[document.ID]*RoleInfo) ([][2]document.ID, int) {
	db, unlock := g.LockAndGetDB()
	defer unlock()
	roles := db.Roles

	playerNum := len(players)
	roleIDs := make([]document.ID, 0, playerNum)
	for roleID, _ := range players {
		roleInfo := roles[roleID]
		if roleInfo.IsOut {
			continue
		}
		roleIDs = append(roleIDs, roleID)
	}
	roleNum := len(roleIDs)
	rand.Shuffle(roleNum, func(i, j int) {
		roleIDs[i], roleIDs[j] = roleIDs[j], roleIDs[i]
	})

	matchList := [][2]document.ID{}

	matchRoleSet := util.NewSet() // 已匹配玩家
	// 从左往右 顺序匹配
	for i := 0; i < roleNum; i++ {
		if matchRoleSet.Size() == roleNum {
			break
		}
		// 自己
		lRoleID := roleIDs[i]
		if matchRoleSet.Contains(lRoleID) {
			continue
		}

		// 对手
		var rRoleID document.ID
		if i == roleNum-1 {
			rRoleID = ""
		} else {
			for j := i + 1; j < roleNum; j++ {
				rRoleID = roleIDs[j]
				// 同一个公会的人不能匹配处理
				if matchRoleSet.Contains(rRoleID) || roles[lRoleID].UnionDbId == roles[rRoleID].UnionDbId {
					rRoleID = ""
					continue
				}
				break
			}
		}

		// 匹配列表添加
		matchList = append(matchList, [2]document.ID{lRoleID, rRoleID})

		// 添加已匹配玩家
		matchRoleSet.Add(lRoleID)
		if rRoleID != "" {
			matchRoleSet.Add(rRoleID)
		}
	}

	return matchList, roleNum
}

// 构建战斗数据
func (g *CrossUnionFightGlobal) makeAndSendBattlePlays(group, battleType, round int, players map[document.ID]*RoleInfo, matchList [][2]document.ID) {
	isDanPlay := false // 轮空战报ID
	for _, match := range matchList {
		// 自己
		lRoleID := match[0]

		// 对手
		rRoleID := match[1]

		roundInfo := g.makeBattleRoundInfo(group, battleType, round, lRoleID, rRoleID)

		playRecord := g.makePlayRecord(roundInfo, lRoleID, rRoleID, players)

		playModel := PlayModel{
			ID:         playRecord.GetID(),
			Group:      playRecord.Group(),
			BattleType: playRecord.BattleType(),
			Round:      playRecord.Round(),
		}
		g.playMap.Store(playRecord.GetID(), &playModel)

		// 轮空战报处理
		if rRoleID != "" {
			if len(playRecord.Cards()) == 0 && len(playRecord.DefenceCards()) == 0 {
				isDanPlay = true
			}
		} else {
			isDanPlay = true
		}

		// 发送每轮战斗
		g.sendRoundPlay(playRecord, isDanPlay)
	}

}

// 发送每轮战斗
func (g *CrossUnionFightGlobal) sendRoundPlay(playRecord *CrossUnionFightPlayRecord, isDanPlay bool) {

	// TODO 测试 不发反作弊 直接模拟反作弊结果
	//antiResult := anti_cheat.CrossUnionFightBattleResult{}
	//antiResult.Result = "win"
	//antiResult.States = makeCardState(playRecord)
	//g.onPlayResult(manager.Result{
	//	ID:     playRecord.GetID(),
	//	Result: antiResult,
	//})

	if isDanPlay {
		// 轮空 直接模拟反作弊结果
		antiResult := anti_cheat.CrossUnionFightBattleResult{}
		antiResult.Result = "win"
		antiResult.States = makeCardState(playRecord)
		g.onPlayResult(manager.Result{
			ID:     playRecord.GetID(),
			Result: antiResult,
		})
		atomic.AddInt32(&g.danSendCount, 1)
	} else {
		// 反作弊发送战报
		g.mgr.SendPlay(playRecord.GetID(), playRecord)
		atomic.AddInt32(&g.antiSendCount, 1)
	}
}

// 构建每轮数据信息
func (g *CrossUnionFightGlobal) makeBattleRoundInfo(group, battleType, round int, lRoleID, rRoleID document.ID) BattleRoundInfo {
	db, unlock := g.LockAndGetDB()
	defer unlock()
	roles := db.Roles

	// 构建战斗playRecord
	roundInfo := BattleRoundInfo{
		Group:      group,
		BattleType: battleType,
		Round:      round,
	}
	if lRoleID != "" {
		roundInfo.Troop = roles[lRoleID].CurTroop

		curTroop := roles[lRoleID].CurTroop
		if troopCardState, ok := roles[lRoleID].CardState[document.Integer(curTroop)]; ok {
			roundInfo.CardStates = troopCardState
		} else {
			// 空 代表满血满怒
			roundInfo.CardStates = map[document.ID][2]float64{}
		}
	}
	if rRoleID != "" {
		roundInfo.DefenceTroop = roles[rRoleID].CurTroop

		curTroop := roles[rRoleID].CurTroop
		if troopCardState, ok := roles[rRoleID].CardState[document.Integer(curTroop)]; ok {
			roundInfo.DefenceCardStates = troopCardState
		} else {
			// 空 代表满血满怒
			roundInfo.DefenceCardStates = map[document.ID][2]float64{}
		}
	}

	// 都不为空则 真实战斗次数加1
	if lRoleID != "" && rRoleID != "" {
		roundInfo.BattleTimes = roles[lRoleID].BattleTimes + 1
		roundInfo.DefenceBattleTimes = roles[rRoleID].BattleTimes + 1
	}

	return roundInfo
}

// 构建战斗playRecord
func (g *CrossUnionFightGlobal) makePlayRecord(roundInfo BattleRoundInfo, lRoleID, rRoleID document.ID, players map[document.ID]*RoleInfo) *CrossUnionFightPlayRecord {
	// 自己
	lGameKey := players[lRoleID].ServerKey
	lPvpService := g.container.GetService(service.Game2PVPService(lGameKey))
	record := GetRemoteCrossUnionFightRoleRecord(lPvpService, players[lRoleID].RecordID)
	roleKey := scheme.RoleKey{ID: lRoleID, GameKey: lGameKey}

	// 对手
	enemyRecord := &scheme.CrossUnionFightRoleRecord{}
	enemyRoleKey := scheme.RoleKey{}
	if rRoleID != "" {
		rGameKey := players[rRoleID].ServerKey
		rPvpService := g.container.GetService(service.Game2PVPService(rGameKey))
		enemyRecord = GetRemoteCrossUnionFightRoleRecord(rPvpService, players[rRoleID].RecordID)
		enemyRoleKey = scheme.RoleKey{ID: rRoleID, GameKey: rGameKey}
	}

	playModel := NewPlayModel(roundInfo, roleKey, enemyRoleKey, record, enemyRecord)
	playRecord := g.builder.CreateCrossUnionFightPlayRecord(playModel)
	return playRecord
}

// 反作弊战斗结果 统一接收
func (g *CrossUnionFightGlobal) receiveAntiPlayResult() {
	util.SimpleTry(func() {
		t := time.NewTicker(BattleResultReceiveDuration)
		defer t.Stop()
		for {
			<-t.C

			if atomic.LoadInt32(&g.playStatus) == 1 {
				log.Infof("pre play run over")
				return
			}
			if atomic.LoadInt32(&g.playStatus) == 2 {
				log.Infof("top play run over")
				return
			}

			antiResults := g.mgr.GetPlayResults()
			for playID, result := range antiResults {
				value, ok := g.playMap.Load(playID)
				if ok {
					playModel := value.(*PlayModel)
					group := playModel.Group
					battleType := playModel.BattleType

					g.lock.Lock()
					if groupResults, ok := g.groupBtResultMap[document.Integer(group)]; ok {
						if btResults, ok := groupResults[document.Integer(battleType)]; ok {
							btResults := append(btResults, result)
							groupResults[document.Integer(battleType)] = btResults
							g.groupBtResultMap[document.Integer(group)] = groupResults
						} else {
							groupResults[document.Integer(battleType)] = []manager.Result{result}
							g.groupBtResultMap[document.Integer(group)] = groupResults
						}
					} else {
						btResults := []manager.Result{result}
						groupResults := map[document.Integer][]manager.Result{document.Integer(battleType): btResults}
						g.groupBtResultMap[document.Integer(group)] = groupResults
					}
					g.lock.Unlock()

				}
			}
		}
	}, nil)
}

// 战斗结果检查
func (g *CrossUnionFightGlobal) onPlayResultCheck(group, battleType, round int) {
	t := time.NewTicker(BattleResultCheckDuration)
	defer t.Stop()
	checkNum := 0
	for {
		<-t.C
		checkNum++

		over := g.checkPlayEnd(group, battleType, round, checkNum)
		if over {
			log.Infof("CrossUnionFight.onPlayResultCheck group %d battleType %d round %d playResultEnd", group, battleType, round)
			break
		}

		g.lock.Lock()
		mgrResults := []manager.Result{}
		if groupResults, ok := g.groupBtResultMap[document.Integer(group)]; ok {
			if btResults, ok := groupResults[document.Integer(battleType)]; ok {
				mgrResults = btResults
			}
		}
		if len(mgrResults) > 0 {
			g.groupBtResultMap[document.Integer(group)][document.Integer(battleType)] = []manager.Result{}
		}
		g.lock.Unlock()

		for _, mgrResult := range mgrResults {
			g.onPlayResult(mgrResult)
			atomic.AddInt32(&g.antiAcceptCount, 1)
		}
	}
}

// 检查该轮结果 是否结束
func (g *CrossUnionFightGlobal) checkPlayEnd(group, battleType, round, checkNum int) bool {
	over := false

	leftNum := 0
	g.playMap.Range(func(key, value interface{}) bool {
		playModel := value.(*PlayModel)
		if playModel.Group == group && playModel.BattleType == battleType && playModel.Round == round {
			leftNum++
		}
		return true
	})
	log.Infof("CrossUnionFight.checkPlayEnd group %d battleType %d round %d checkNum %d left %d", group, battleType, round, checkNum, leftNum)

	if leftNum == 0 {
		over = true
	}
	return over
}

// 战斗结果处理
func (g *CrossUnionFightGlobal) onPlayResult(mgrResult manager.Result) {

	atomic.AddInt32(&g.allAcceptCount, 1)

	playID := mgrResult.ID
	playRecord := g.builder.GetCrossUnionFightPlayRecord(playID)

	if mgrResult.Error != nil {
		g.resendPlay(playRecord, false)
		log.Warningf("!!!!!! CrossUnionFight.onPlayResult resendPlay group %d battleType %d round %d playID %v error %v", playRecord.Group(), playRecord.BattleType(), playRecord.Round(), playID, mgrResult.Error)
		return
	}

	result := mgrResult.Result.(anti_cheat.CrossUnionFightBattleResult)
	// 异常战斗结果重发
	if result.Result != "win" && result.Result != "fail" {
		g.resendPlay(playRecord, true)
		log.Warningf("!!!!!! CrossUnionFight.onPlayResult resendPlay group %d battleType %d round %d playID %v result %v", playRecord.Group(), playRecord.BattleType(), playRecord.Round(), playID, result.Result)
		return
	}

	group := playRecord.Group()
	battleType := playRecord.BattleType()
	round := playRecord.Round()

	// 1.更新战报play结果
	playResult := result.Result
	playRecord.SetResult(playResult)

	// 获取 roleID1, roleID2, unionID1, unionID2
	db, unlock := g.LockAndGetDB()
	defer unlock()

	roles := db.Roles
	unions := db.Unions

	var roleID1, roleID2 document.ID
	if playRecord.RoleKey().ID != "" {
		roleID1 = playRecord.RoleKey().ID
	}
	if playRecord.DefenceRoleKey().ID != "" {
		roleID2 = playRecord.DefenceRoleKey().ID
	}

	var unionID1, unionID2 document.ID
	if roleID1 != "" {
		unionID1 = roles[roleID1].UnionDbId
		if roles[roleID1].IsOut {
			log.Warningf("!!!!!! playID %v roleOut1 group %d battleType %d round %d ID %v name %v", playID, group, battleType, round, roleID1, roles[roleID1].RoleName)
		}
	}
	if roleID2 != "" {
		unionID2 = roles[roleID2].UnionDbId
		if roles[roleID2].IsOut {
			log.Warningf("!!!!!! playID %v roleOut2 group %d battleType %d round %d ID %v name %v", playID, group, battleType, round, roleID2, roles[roleID2].RoleName)
		}
	}

	// 2.更新积分 相关计算
	g.updateBattleResultPoint(roleID1, roleID2, unionID1, unionID2, battleType, playResult)

	// 3.构建战报条目 ResultInfo
	cardStateTmp1 := make(map[document.ID][2]float64)
	cardStateTmp2 := make(map[document.ID][2]float64)
	if roleID1 != "" {
		cardStateTmp1 = getBattleCardState(playRecord.Cards(), playRecord.CardStates(), result.States, battleType)
	}
	if roleID2 != "" {
		cardStateTmp2 = getBattleCardState(playRecord.DefenceCards(), playRecord.DefenceCardStates(), result.States, battleType)
	}
	resultInfo := g.updateResultInfo(playRecord, cardStateTmp1, cardStateTmp2, playResult)
	g.makeRoundResults(group, battleType, resultInfo)

	// 4.更新角色信息 Roles 的 CurTroop、CardState、IsOut、BattleTimes
	var roleOut1, roleOut2 bool
	if roleID1 != "" {
		roleOut1 = g.updateRoleState(roleID1, cardStateTmp1)
	}
	if roleID2 != "" {
		roleOut2 = g.updateRoleState(roleID2, cardStateTmp2)
	}
	if roleID1 != "" && roleID2 != "" { // 两边都是玩家 真实战斗加一
		role1 := roles[roleID1]
		role1.BattleTimes = role1.BattleTimes + 1

		role2 := roles[roleID2]
		role2.BattleTimes = role2.BattleTimes + 1

		g.SetRoles(roles)
	}

	// 5.更新公会状态 Unions的 LiveCount、IsOut、WinNum
	if roleID1 != "" {
		win1 := false
		if playResult == "win" && roleID2 != "" {
			win1 = true
		}
		g.updateUnionState(roleID1, unionID1, roleOut1, win1)
	}
	if roleID2 != "" {
		win2 := false
		if playResult == "fail" && roleID1 != "" {
			win2 = true
		}
		g.updateUnionState(roleID2, unionID2, roleOut2, win2)
	}

	g.SetUnions(unions)
	g.SetRoles(roles)

	g.playMap.Delete(playID)
}

// 重发战报计算
func (g *CrossUnionFightGlobal) resendPlay(playRecord *CrossUnionFightPlayRecord, resetSeed bool) {
	playID := playRecord.GetID()
	if resetSeed {
		old := playRecord.RandSeed()
		seed := rand.Int31n(99999999) + 1
		playRecord.SetRandSeed(seed)
		log.Warningf("CrossUnionFight.onPlayResult agent play %v result is error, reset seed %d -> %d", playID, old, seed)
	}
	g.mgr.SendPlay(playID, playRecord)
	atomic.AddInt32(&g.antiSendCount, 1)
	atomic.AddInt32(&g.antiResendCount, 1)
}

// 更新角色信息
func (g *CrossUnionFightGlobal) updateRoleState(roleID document.ID, states map[document.ID][2]float64) bool {
	db := g.GetLockedDB()
	status := db.Status
	roles := db.Roles

	roleInfo := roles[roleID]
	troop := roleInfo.CurTroop

	//  CardState 处理 {队伍: {卡牌: (hp, mp)}}
	if _, ok := roleInfo.CardState[document.Integer(troop)]; !ok {
		roleInfo.CardState[document.Integer(troop)] = make(map[document.ID][2]float64)
	}
	for cardID, cardState := range states {
		if cardID != "" {
			roleInfo.CardState[document.Integer(troop)][cardID] = cardState
		}
	}

	// hpSum: 队伍总血量;
	hpSum, _ := calcHpPercent(states)

	// IsOut 处理
	isRoleOut := false
	var maxTroop int
	if isInPre(status) {
		maxTroop = TroopNum[roleInfo.Projects[PreStage]]
	} else {
		maxTroop = TroopNum[roleInfo.Projects[TopStage]]
	}
	if float64IsEqual(hpSum, 0) {
		if troop == maxTroop {
			roleInfo.IsOut = true
			isRoleOut = true
		} else {
			roleInfo.CurTroop++
			roleInfo.CardState[document.Integer(roleInfo.CurTroop)] = map[document.ID][2]float64{}
		}
	}

	roles[roleID] = roleInfo
	g.SetRoles(roles)

	return isRoleOut
}

// 更新角色信息
func (g *CrossUnionFightGlobal) updateUnionState(roleID, unionID document.ID, roleOut bool, win bool) {
	db := g.GetLockedDB()
	unions := db.Unions

	if roleID != "" {
		if unionID != "" {
			union := unions[unionID]
			if roleOut {
				union.LiveCount = union.LiveCount - 1
				if union.LiveCount <= 0 {
					union.IsOut = true
				}
			}
			if win {
				union.WinNum = union.WinNum + 1
			}
		} else {
			log.Warningf("!!!!!! role.unionID error roleID %v", roleID)
		}
	}
	g.SetUnions(unions)
}

// 构建展示战报 RoundResults
func (g *CrossUnionFightGlobal) makeRoundResults(group, battleType int, resultInfo *scheme.CrossUnionFightResultInfo) {
	db := g.GetLockedDB()

	if group != TopGroup {
		preRoundResults := db.PreRoundResults
		if gResults, ok := preRoundResults[document.Integer(group)]; ok {
			if results, ok := gResults[document.Integer(battleType)]; ok {
				results = append(results, resultInfo)
				gResults[document.Integer(battleType)] = results
			} else {
				gResults[document.Integer(battleType)] = []*scheme.CrossUnionFightResultInfo{resultInfo}
			}
			preRoundResults[document.Integer(group)] = gResults
		} else {
			resultInfos := []*scheme.CrossUnionFightResultInfo{resultInfo}
			gResults = map[document.Integer][]*scheme.CrossUnionFightResultInfo{document.Integer(battleType): resultInfos}
			preRoundResults[document.Integer(group)] = gResults
		}
		g.SetPreRoundResults(preRoundResults)
	} else {
		topRoundResults := db.TopRoundResults
		if results, ok := topRoundResults[document.Integer(battleType)]; ok {
			results = append(results, resultInfo)
			topRoundResults[document.Integer(battleType)] = results
		} else {
			resultInfos := []*scheme.CrossUnionFightResultInfo{resultInfo}
			topRoundResults[document.Integer(battleType)] = resultInfos
		}
		g.SetTopRoundResults(topRoundResults)
	}
}

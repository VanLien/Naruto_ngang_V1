package union_fight

import (
	"errors"
	"fmt"
	"math/rand"
	"sort"
	"strconv"
	"sync"
	"sync/atomic"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	anti_cheat "tjgame/services/anti-cheat"
	"tjgame/services/anti-cheat/manager"
	"tjgame/services/game"
)

type UnionFight struct {
	*scheme.UnionFightGlobalObject
	builder   *Builder
	game      service.IService
	anticheat service.IService

	mgr *manager.AgentManager // 反作弊

	allRoles   sync.Map // {role.ID: *RoleRecord}
	fightRoles sync.Map // {role.ID: *RoleRecord}
	playMap    sync.Map // {playID: *PlayRecord}

	betsum  int // 下注总额
	weekday int

	nextRoundBattleTime  float64
	nextRoundPrepareTime float64
	prepareEndTime       float64
	roundLiveCache       map[document.ID]map[int]int
	lastRoleRecordCache  *RoleRecord
	recordCache          *util.LRUCache // cache for record

	playStatus int32

	wg sync.WaitGroup
}

func (u *UnionFight) init(game, anticheat service.IService, builder *Builder) {
	u.builder = builder
	u.game = game
	u.anticheat = anticheat

	betsum := 0
	for _, d := range u.Bet() {
		for _, bet := range d.Gold {
			betsum += bet
		}
	}
	u.betsum = betsum

	if u.recordCache == nil {
		u.recordCache = util.NewLRUCache(5000, nil)
	}
}

func (u *UnionFight) SetAgentManager(name string, agent service.IService) {
	if u.mgr != nil {
		u.mgr.Stop()
		u.mgr = nil
	}

	u.mgr = manager.NewAgentManager(name, "NewUnionFightBattle", agent)
}

func (u *UnionFight) onPrepare(signup []scheme.UnionFightSignupItem, weekday int, top8Deploys map[document.ID][]document.ID) {
	util.WithGuard(u, func() {
		u.SetRound("prepare")
		u.SetDate(util.Todaydate2int())
	})

	u.weekday = weekday

	go func() {
		switch {
		case weekday >= 2 && weekday <= 5:
			if weekday == 2 {
				u.reset()
			}
			u.clean()
			_ = u.prepare(signup, top8Deploys)
			go u.onStartBattle2345()
			elapsed := u.getElapsedDuration()
			duration := PrepareDuration2345 - elapsed
			u.prepareEndTime = float64(util.Now().Add(duration).Unix())
			log.Infof("weekday %d round prepare next battle time delta %s, elapsed %s", weekday, duration, elapsed)
			time.AfterFunc(duration, u.onStartBattle2345Timer)
		case weekday == 6:
			u.clean()
			err := u.prepare(signup, top8Deploys)
			if err != nil {
				u.SetRound("over")
				u.eventToGame("over", EventToGame{}, false)
				return
			}
			elapsed := u.getElapsedDuration()
			duration := PrepareDuration6 - elapsed
			u.prepareEndTime = float64(util.Now().Add(duration).Unix())
			log.Infof("weekday %d round %s next %s time delta %s, elapsed %s", weekday, u.Round(), RoundNextMap6[u.Round()].next, duration, elapsed)
			time.AfterFunc(duration, u.onStartBattle6)
		default:
			log.Warningf("UnionFight weekday %d not open", weekday)
		}
	}()
}

func (u *UnionFight) reset() {
	u.RLock()
	unionIDs := []document.ID{}
	for _, union := range u.Unions() {
		unionIDs = append(unionIDs, union.UnionID)
	}
	roleRecordIDs := []document.ID{}
	for _, role := range u.Roles() {
		roleRecordIDs = append(roleRecordIDs, role.RecordID)
	}
	u.RUnlock()
	roleRecords := u.getRoleRecordsByRoleRecordIDs(roleRecordIDs)
	unionRecords := u.getUnionRecordsByUnionIDs(unionIDs)

	u.Lock()
	defer u.Unlock()

	var ok bool
	var roleRecord *RoleRecord
	var unionRecord *UnionRecord
	unions := u.Unions()
	for unionID := range unions {
		unionRecord, ok = unionRecords[unionID]
		if !ok {
			log.Warningf("UnionFight.reset union %s record not exists", unionID)
			continue
		}
		util.WithGuard(unionRecord, func() {
			unionRecord.SetRoundResults(make(map[string][]scheme.UnionFightResultInfo))
			unionRecord.SetYesterdayRoundResults(make(map[string][]scheme.UnionFightResultInfo))
			unionRecord.SetBattleStarNum(0)
		})
	}
	roles := u.Roles()
	for _, role := range roles {
		roleRecord, ok = roleRecords[role.RecordID]
		if !ok {
			log.Warningf("UnionFight.reset role %s record not exists", role.RoleID)
			continue
		}
		util.WithGuard(roleRecord, func() {
			roleRecord.SetCards(scheme.UnioinFightCards{})
			roleRecord.SetCardAttrs(make(map[document.ID]*scheme.CardBattleModel))
			roleRecord.SetCardAttrs2(make(map[document.ID]*scheme.CardBattleModel))
		})
	}
	u.SetUnions(make(map[document.ID]*scheme.UnionFightUnionInfo))
	u.SetRoles(make(map[document.ID]*scheme.UnionFightRoleInfo))
	u.SetRoleRanks(make(map[document.Integer][]scheme.UnionFightRoleRankItem))
	u.SetUnionRanks(make(map[document.Integer][]scheme.UnionFightUnionRankItem))
	u.SetTop8VSInfo(make(map[document.Integer]*scheme.UnionFightTop8VSUnionInfo))
	u.SetBattleStars(make(map[document.Integer]map[document.Integer]int))
	u.SetBet(make(map[document.ID]*scheme.UnionFightBet))
}

func (u *UnionFight) getRoleRecordsByRoleRecordIDs(roleRecordIDs []document.ID) map[document.ID]*RoleRecord {
	ret := make(map[document.ID]*RoleRecord)
	wg := sync.WaitGroup{}
	wg.Add(len(roleRecordIDs))
	c := make(chan *RoleRecord)
	go func() {
		for r := range c {
			ret[r.GetID()] = r
			wg.Done()
		}
	}()
	for _, roleRecordID := range roleRecordIDs {
		go func(i document.ID) {
			if i == "" {
				wg.Done()
				return
			}
			roleRecord := u.builder.GetUnionFightRoleRecord(i)
			if roleRecord == nil {
				wg.Done()
				return
			}
			c <- roleRecord
		}(roleRecordID)
	}
	wg.Wait()
	close(c)
	return ret
}

func (u *UnionFight) getUnionRecordsByUnionIDs(unionIDs []document.ID) map[document.ID]*UnionRecord {
	ret := make(map[document.ID]*UnionRecord)
	wg := sync.WaitGroup{}
	wg.Add(len(unionIDs))
	c := make(chan *UnionRecord)
	go func() {
		for ur := range c {
			ret[ur.UnionDbId()] = ur
			wg.Done()
		}
	}()
	for _, unionID := range unionIDs {
		go func(i document.ID) {
			if i == "" {
				wg.Done()
				return
			}
			unionRecord := u.builder.GetUnionFightUnionRecord(i)
			if unionRecord == nil {
				wg.Done()
				return
			}
			c <- unionRecord
		}(unionID)
	}
	wg.Wait()
	close(c)
	return ret
}

func (u *UnionFight) clean() {
	u.RLock()
	unionIDs := []document.ID{}
	for _, union := range u.Unions() {
		unionIDs = append(unionIDs, union.UnionID)
	}
	u.RUnlock()
	unionRecords := u.getUnionRecordsByUnionIDs(unionIDs)

	u.Lock()
	defer u.Unlock()

	unions := u.Unions()
	roles := u.Roles()

	var ok bool
	var unionRecord *UnionRecord
	for unionID, union := range unions {
		//unionRecord := GetUnionFightUnionRecord(u.storage, unionID)
		unionRecord, ok = unionRecords[unionID]
		if !ok {
			log.Warningf("UnionFight.clean union %d record not exists", unionID)
			continue
		}
		util.WithGuard(unionRecord, func() {
			unionRecord.SetYesterdayInfo(scheme.UnionFightUUnionYesterdayInfo{
				Members:      union.MemberNum,
				Signs:        union.SignNum,
				LiveNum:      union.SignNum - union.DeadNum,
				LastRoleName: union.LastRoleName,
				IsOut:        union.IsOut,
			})
			unionRecord.SetYesterdayRoundResults(unionRecord.RoundResults())
			unionRecord.SetRoundResults(make(map[string][]scheme.UnionFightResultInfo))
		})
		union.SignNum = 0
		union.DeadNum = 0
		union.KillNum = 0
		union.IsOut = false
		union.RoundMax = 0
		union.Roles = []document.ID{}
		union.Point = 0
		union.LastRoleName = ""
	}

	for _, role := range roles {
		role.Point = 0
		role.CurTroop = 1
		role.CurTroopBattleNum = 0
		role.KillNum = 0
		role.DeedInfo = make(map[document.Integer]bool)
		role.CardState = make(map[document.Integer]map[document.ID][2]float64)
	}

	u.SetRoles(roles)
	u.SetUnions(unions)
}

func (u *UnionFight) prepare(signup []scheme.UnionFightSignupItem, top8Deploys map[document.ID][]document.ID) error {
	roleRecords := u.prepareRoleRecords(signup)

	u.Lock()
	defer u.Unlock()

	u.SetRound("prepare")
	u.prepareDataClear()
	u.prepareRolesAndUnions(signup, roleRecords)

	if u.weekday == 6 {
		err := u.prepareWeekday6(top8Deploys)
		if err != nil {
			return err
		}
	}

	return nil
}

func (u *UnionFight) prepareDataClear() {
	u.SetLastRoleID("")
	u.SetLastUnionID("")
	u.roundLiveCache = make(map[document.ID]map[int]int)
	u.lastRoleRecordCache = nil
	u.fightRoles = sync.Map{}

	// 清理时间节点
	u.nextRoundBattleTime = 0
	u.nextRoundPrepareTime = 0
	u.prepareEndTime = 0
}

func (u *UnionFight) prepareRoleRecords(signup []scheme.UnionFightSignupItem) map[document.ID]*RoleRecord {
	roleRecords := make(map[document.ID]*RoleRecord)
	roleRecordChan := make(chan *RoleRecord)
	wg := sync.WaitGroup{}
	wg.Add(len(signup))
	go func() {
		for role := range roleRecordChan {
			roleRecords[role.RoleDbId()] = role
			wg.Done()
		}
	}()
	for _, item := range signup {
		go func(i scheme.UnionFightSignupItem) {
			if i.UnionID == "" || i.RoleID == "" {
				log.Warningf("signup roleID %s unionID %s error", i.RoleID, i.UnionID)
				wg.Done()
				return
			}

			roleRecord := u.builder.GetUnionFightRoleRecord(i.RecordID)
			if roleRecord == nil {
				wg.Done()
				return
			}
			// 卡牌校验
			if !roleRecord.checkCardsEnough(u.weekday) {
				wg.Done()
				return
			}
			roleRecord.updateBattleCards(u.weekday)

			roleRecordChan <- roleRecord
		}(item)
	}

	wg.Wait()
	close(roleRecordChan)

	updateUnions := make(map[document.ID]bool)
	// 检测 unionRecord 是否存在
	for _, item := range signup {
		if item.UnionID == "" || item.RoleID == "" {
			continue
		}
		if _, ok := roleRecords[item.RoleID]; !ok {
			continue
		}
		unionRecord := u.builder.GetUnionFightUnionRecord(item.UnionID)
		unionInfo := unionCompetitor{
			ID:    item.UnionID,
			Name:  item.UnionName,
			Logo:  item.UnionLogo,
			Level: item.UnionLevel,
		}
		if unionRecord == nil {
			util.SimpleTry(func() {
				u.builder.CreateUnionFightUnionRecord(unionInfo)
			}, nil)
		} else {
			if _, ok := updateUnions[item.UnionID]; ok {
				continue
			}
			unionRecord.updateUnion(unionInfo)
			updateUnions[item.UnionID] = true
		}
	}

	return roleRecords
}

func (u *UnionFight) prepareRolesAndUnions(signup []scheme.UnionFightSignupItem, roleRecords map[document.ID]*RoleRecord) {
	roles := u.Roles()
	unions := u.Unions()

	var ok bool
	var roleRecord *RoleRecord
	for _, item := range signup {
		if item.UnionID == "" || item.RoleID == "" {
			continue
		}
		roleRecord, ok = roleRecords[item.RoleID]
		if !ok {
			log.Infof("UnionFight prepare role %s record not exists", item.RoleID)
			continue
		}

		if _, ok = unions[item.UnionID]; !ok {
			unions[item.UnionID] = &scheme.UnionFightUnionInfo{
				UnionID:   item.UnionID,
				Name:      item.UnionName,
				Logo:      item.UnionLogo,
				Level:     item.UnionLevel,
				MemberNum: item.UnionMemberNum,
			}
		} else {
			unions[item.UnionID].Name = item.UnionName
			unions[item.UnionID].Logo = item.UnionLogo
			unions[item.UnionID].Level = item.UnionLevel
			unions[item.UnionID].MemberNum = item.UnionMemberNum
		}

		union := unions[item.UnionID]
		union.SignNum++

		union.Roles = append(union.Roles, item.RoleID)

		// 公会发生变更
		if roleRecord.UnionDbId() != item.UnionID {
			roleRecord.SetUnionDbId(item.UnionID)
		}

		u.fightRoles.Store(item.RoleID, roleRecord)

		if _, ok := roles[item.RoleID]; !ok {
			roles[item.RoleID] = &scheme.UnionFightRoleInfo{
				RoleID:    item.RoleID,
				RecordID:  item.RecordID,
				CurTroop:  1,
				DeedInfo:  make(map[document.Integer]bool),
				CardState: make(map[document.Integer]map[document.ID][2]float64),
			}
		}
	}

	u.SetRoles(roles)
	u.SetUnions(unions)
}

func (u *UnionFight) prepareWeekday6(top8Deploys map[document.ID][]document.ID) error {
	unions := u.Unions()
	top8VSInfo := u.Top8VSInfo()

	for unionID, roleIDs := range top8Deploys {
		unions[unionID].Roles = u.updateTop8Deploy(unions[unionID].Roles, roleIDs)
		unions[unionID].SignNum = len(unions[unionID].Roles)
	}

	// 八强赛人数不足，不进行决赛
	//if len(top8VSInfo) < 8 {
	//	log.Warningf("UnionFight.prepare top8 member %d not enough", len(top8VSInfo))
	//	return errors.New("top8 member not enough")
	//}
	top8Tmp := make(map[document.Integer]*scheme.UnionFightTop8VSUnionInfo)
	for i := 1; i <= 8; i++ {
		if _, ok := top8VSInfo[document.Integer(i)]; !ok {
			continue
		}
		union := unions[top8VSInfo[document.Integer(i)].UnionID]
		union.Top8MaxRoundKey = i
		top8Tmp[document.Integer(i)] = newUnionFightTop8VSUnionInfo(union)
	}

	u.SetTop8VSInfo(top8Tmp)
	u.SetUnions(unions)

	return nil
}

func (u *UnionFight) onStartBattle2345() {
	atomic.StoreInt32(&u.playStatus, 0)
	var isOver bool
	var matchs [][2]document.ID
	util.WithGuard(u, func() {
		u.SetRoundResultMax(0)
		isOver, matchs = u.makeMatch2345()
	})
	round := 0
	u.mgr.SetTimerDuration(Battle2345AgentTimerDuration)
	u.mgr.Start()
	for !isOver {
		round++
		log.Infof("UnionFight.onStartBattle2345 round %d matchs %d", round, len(matchs))
		u.onPlayStart(strconv.Itoa(round), matchs, &u.playMap, 0)
		u.onPlayResultCheck(&u.playMap, Battle2345ResultCheckDuration)
		util.WithGuard(u, func() {
			u.recordRoundLive(round)
			isOver, matchs = u.makeMatch2345()
		})
	}
	u.mgr.Stop()
	util.WithGuard(u, func() {
		u.SetRoundResultMax(round)
	})
	atomic.StoreInt32(&u.playStatus, 1)
}

// 周六决赛
func (u *UnionFight) onStartBattle6() {
	util.WithGuard(u, func() {
		oldRound := u.Round()
		round := RoundNextMap6[u.Round()].next
		u.SetRound(round)
		// 更新 top8 对战表
		if oldRound != "prepare" {
			top8VSInfo := u.Top8VSInfo()
			unions := u.Unions()
			for _, roundKey := range Top8RoundKeyMap[oldRound] {
				_, ok1 := top8VSInfo[document.Integer(roundKey[0])]
				_, ok2 := top8VSInfo[document.Integer(roundKey[1])]
				top8Key, _ := strconv.Atoi(fmt.Sprintf("%d%d", roundKey[0], roundKey[1]))
				if !ok1 || !ok2 {
					if ok1 {
						unionID1 := top8VSInfo[document.Integer(roundKey[0])].UnionID
						union1 := unions[unionID1]
						union1.Top8MaxRoundKey = top8Key
					}
					if ok2 {
						unionID2 := top8VSInfo[document.Integer(roundKey[1])].UnionID
						union2 := unions[unionID2]
						union2.Top8MaxRoundKey = top8Key
					}
					continue
				}
				unionID1 := top8VSInfo[document.Integer(roundKey[0])].UnionID
				unionID2 := top8VSInfo[document.Integer(roundKey[1])].UnionID
				union1 := unions[unionID1]
				union2 := unions[unionID2]
				var result string
				if union1.SignNum-union1.DeadNum != 0 {
					result = "win"
				}
				if result == "win" {
					union1.Top8MaxRoundKey = top8Key
					if top8Key == 1845 || top8Key == 2736 {
						top8VSInfo[document.Integer(-top8Key)] = newUnionFightTop8VSUnionInfo(union2)
					}
				} else {
					union2.Top8MaxRoundKey = top8Key
					if top8Key == 1845 || top8Key == 2736 {
						top8VSInfo[document.Integer(-top8Key)] = newUnionFightTop8VSUnionInfo(union1)
					}
				}
			}
			u.SetTop8VSInfo(top8VSInfo)
			u.SetUnions(unions)
		}
	})

	elapsed := u.getElapsedDuration()
	duration := Top8BattleStartDuration - elapsed
	u.nextRoundBattleTime = float64(util.Now().Add(duration).Unix())
	time.AfterFunc(duration, u.onBattle6Start)

	duration = Top8BattleSEndDuration - elapsed
	u.nextRoundPrepareTime = float64(util.Now().Add(duration).Unix())
	time.AfterFunc(duration, u.onBattle6End)

	log.Infof("UnionFight.onStartBattle6 show time battle %v prepare %v", util.Unix(int64(u.nextRoundBattleTime)), util.Unix(int64(u.nextRoundPrepareTime)))

	u.eventToGame("battle", EventToGame{}, false)
}

func (u *UnionFight) onBattle6Start() {
	atomic.StoreInt32(&u.playStatus, 0)

	roundKeys := Top8RoundKeyMap[u.Round()]
	log.Infof("UnionFight.onBattle6Start top8 battle %s", u.Round())
	top8VSInfo := make(map[document.Integer]*scheme.UnionFightTop8VSUnionInfo)
	util.WithGuard(u, func() {
		tmp := u.Top8VSInfo()
		for k := range tmp {
			v := *tmp[k]
			top8VSInfo[k] = &v
		}
	})
	u.mgr.SetTimerDuration(Battle6AgentTimerDuration)
	u.mgr.Start()
	for _, roundKey := range roundKeys {
		playMap := sync.Map{}
		_, ok1 := top8VSInfo[document.Integer(roundKey[0])]
		_, ok2 := top8VSInfo[document.Integer(roundKey[1])]
		// 存在轮空
		if !ok1 || !ok2 {
			if !ok1 && !ok2 {
				continue
			}
			top8Key, _ := strconv.Atoi(fmt.Sprintf("%d%d", roundKey[0], roundKey[1]))
			if ok1 {
				unionID := top8VSInfo[document.Integer(roundKey[0])].UnionID
				top8VSUnionInfo := newUnionFightTop8VSUnionInfo(u.Unions()[unionID])
				top8VSInfo[document.Integer(roundKey[0])] = top8VSUnionInfo
				top8VSInfo[document.Integer(top8Key)] = top8VSUnionInfo
			}
			if ok2 {
				unionID := top8VSInfo[document.Integer(roundKey[1])].UnionID
				top8VSUnionInfo := newUnionFightTop8VSUnionInfo(u.Unions()[unionID])
				top8VSInfo[document.Integer(roundKey[1])] = top8VSUnionInfo
				top8VSInfo[document.Integer(top8Key)] = top8VSUnionInfo
			}
			continue
		}
		unionID1 := top8VSInfo[document.Integer(roundKey[0])].UnionID
		unionID2 := top8VSInfo[document.Integer(roundKey[1])].UnionID

		if unionID1 == "" || unionID2 == "" {
			log.Warningf("top8 vs error roundKey %s %s u1 %s u2 %s", roundKey, unionID1, unionID2)
			return
		}

		top83v3Round := 0
		var result string
		var matchs [][2]document.ID
		util.WithGuard(u, func() {
			result, matchs = u.makeMatch6(unionID1, unionID2)
		})
		for result == "" {
			log.Infof("UnionFight onBattle6Start %d vs %d match %d", roundKey[0], roundKey[1], len(matchs))
			top83v3Round++
			u.onPlayStart(Top8PlayKeyMap[roundKey], matchs, &playMap, top83v3Round)
			u.onPlayResultCheck(&playMap, Battle6ResultCheckDuration)
			util.WithGuard(u, func() {
				result, matchs = u.makeMatch6(unionID1, unionID2)
			})
		}

		top8Key, _ := strconv.Atoi(fmt.Sprintf("%d%d", roundKey[0], roundKey[1]))

		top8VSUnionInfo1 := newUnionFightTop8VSUnionInfo(u.Unions()[unionID1])
		top8VSUnionInfo2 := newUnionFightTop8VSUnionInfo(u.Unions()[unionID2])

		// 更新当前轮结束的状态
		top8VSInfo[document.Integer(roundKey[0])] = top8VSUnionInfo1
		top8VSInfo[document.Integer(roundKey[1])] = top8VSUnionInfo2

		if result == "win" {
			top8VSInfo[document.Integer(top8Key)] = top8VSUnionInfo1
		} else {
			top8VSInfo[document.Integer(top8Key)] = top8VSUnionInfo2
		}
		curTop8 := []document.Integer{}
		for k, _ := range top8VSInfo {
			curTop8 = append(curTop8, k)
		}
		log.Infof("UnionFight onBattle6Start roundKey %v top8Key %v finish curTop8 %v", roundKey, top8Key, curTop8)
	}
	u.mgr.Stop()
	util.WithGuard(u, func() {
		u.SetTop8VSInfo(top8VSInfo)
	})

	atomic.StoreInt32(&u.playStatus, 1)
}

func (u *UnionFight) onBattle6End() {
	for atomic.LoadInt32(&u.playStatus) != 1 {
		time.Sleep(time.Second * 5)
	}

	round := RoundNextMap6[u.Round()].next
	if round == "over" {
		u.onOver()
	} else {
		u.onStartBattle6()
	}
}

func (u *UnionFight) makeMatch6(unionID1, unionID2 document.ID) (string, [][2]document.ID) {
	unions := u.Unions()
	u1 := unions[unionID1]
	u2 := unions[unionID2]

	match1 := u.getUnionTop8match(u1.Roles)
	match2 := u.getUnionTop8match(u2.Roles)

	ret := [][2]document.ID{}
	result := ""
	l1 := len(match1)
	l2 := len(match2)

	// win u1 胜利
	// fail u2 胜利
	if l1 == 0 || l2 == 0 {
		if l1 != 0 {
			result = "win"
		}
		if l2 != 0 {
			result = "fail"
		}
		// 如果双方都没有人则按积分计算胜负
		if result == "" {
			if u1.Point > u2.Point {
				result = "win"
			} else {
				result = "fail"
			}
		}
		return result, ret
	}

	l := l1
	if l2 < l1 {
		l = l2
	}

	for matchNum := 1; matchNum <= l; matchNum++ {
		ret = append(ret, [2]document.ID{})
	}

	for idx, roleID := range match1[:l] {
		ret[idx][0] = roleID
	}

	for idx, roleID := range match2[:l] {
		ret[idx][1] = roleID
	}

	return result, ret
}

func (u *UnionFight) getUnionTop8match(unionRoles []document.ID) []document.ID {
	ret := make([]document.ID, 0, 3)
	roleMap := make(map[document.ID]bool)
	roles := u.Roles()
	for troopsNum := 1; troopsNum <= 3; troopsNum++ {
		for _, roleID := range unionRoles {
			if _, ok := roleMap[roleID]; ok {
				continue
			}
			role := roles[roleID]
			if role == nil {
				log.Warningf("role %s not exists", roleID)
				continue
			}
			if !role.DeedInfo[document.Integer(troopsNum)] {
				ret = append(ret, roleID)
				roleMap[roleID] = true
			}
			if len(ret) == 3 {
				break
			}
		}
		if len(ret) == 3 {
			break
		}
	}
	return ret
}

func (u *UnionFight) onOver() {
	log.Infof("UnionFight.onOver weekday %d play end", u.weekday)
	rankRoles, rankUnions := u.updateRank()
	u.updateFinalResult()

	EventData := EventToGame{}
	EventData.RankUnions = rankUnions
	if u.weekday != 6 {
		EventData.RankRoles = rankRoles
	}

	// 通知 game 发奖励
	u.eventToGame("start_award", EventData, false)

	u.eventToGame("over", EventToGame{}, false)
	util.WithGuard(u, func() {
		u.SetRound("over")
	})
	u.clean()
}

func (u *UnionFight) onStartAward() {

}

// 更新排名
func (u *UnionFight) updateRank() ([]RoleRankAwardItem, []UnionRankAwardItem) {
	roleAwardRank := u.updateWeekRoleRank(u.weekday, true)
	_ = u.updateWeekRoleRank(RankAllWeekdayNum, false)
	unionAwardRank := u.updateWeekUnionRank(u.weekday, true)
	_ = u.updateWeekUnionRank(RankAllWeekdayNum, false)

	// 每周生成 top8 和 押注，防止周五异常，导致周六没有比赛
	if u.weekday >= 2 && u.weekday <= 5 {
		u.initTop8VSInfo()
		u.initNextBet()
	}

	if u.weekday == 6 {
		unionAwardRank = u.updateTop8UnionRank()
		u.sendBetAward()
	}
	return roleAwardRank, unionAwardRank
}

// 角色排名
func (u *UnionFight) updateWeekRoleRank(weekday int, needAwardRank bool) []RoleRankAwardItem {
	u.RLock()
	roles := u.Roles()
	ranks := &ranks{
		items: make([]rankitem, 0, len(roles)),
	}
	roleRecordIDs := []document.ID{}
	for _, role := range roles {
		point := role.Point
		if weekday == RankAllWeekdayNum {
			role.PointSum += role.Point
			point = role.PointSum
		}
		if point <= 0 {
			continue
		}
		ranks.items = append(ranks.items, rankitem{
			id: role.RoleID,
			items: map[string]int{
				"point": point,
			},
		})
		roleRecordIDs = append(roleRecordIDs, role.RecordID)
	}
	u.RUnlock()
	roleRecords := u.getRoleRecordsByRoleRecordIDs(roleRecordIDs)

	ranks.keys = []string{"point"}
	sort.Sort(ranks)

	weekRank := []scheme.UnionFightRoleRankItem{}
	// 用于发奖励的角色排名
	awardRank := []RoleRankAwardItem{}

	u.Lock()
	defer u.Unlock()

	for i, v := range ranks.items {
		rank := i + 1
		record, ok := roleRecords[roles[v.id].RecordID]
		if !ok {
			continue
		}
		if i < 20 {
			log.Infof("UnionFight.updateWeekRoleRank weekday %d final role rank %d %v %v", weekday, rank, v.id, v.items)
			weekRank = append(weekRank, scheme.UnionFightRoleRankItem{
				Rank:   rank,
				Name:   record.RoleName(),
				Logo:   record.RoleLogo(),
				Frame:  record.RoleFrame(),
				Level:  record.RoleLevel(),
				Figure: record.RoleFigure(),
				Point:  v.items["point"],
			})
		}
		if roles[v.id].RankRecord == nil {
			roles[v.id].RankRecord = make(map[document.Integer]scheme.UnionFightRankOnceItem)
		}
		roles[v.id].RankRecord[document.Integer(weekday)] = scheme.UnionFightRankOnceItem{
			Rank:  rank,
			Point: v.items["point"],
		}
		if needAwardRank {
			awardRank = append(awardRank, RoleRankAwardItem{
				RoleID:  v.id,
				KillNum: roles[v.id].KillNum,
			})
		}
	}
	u.SetRoles(roles)

	roleRanks := u.RoleRanks()
	roleRanks[document.Integer(weekday)] = weekRank
	u.SetRoleRanks(roleRanks)

	return awardRank
}

// 公会排名
func (u *UnionFight) updateWeekUnionRank(weekday int, needAwardRank bool) []UnionRankAwardItem {
	u.Lock()
	defer u.Unlock()

	unions := u.Unions()
	ranks := &ranks{
		items: make([]rankitem, 0, len(unions)),
	}

	top8Unions := make(map[document.ID]bool, 8)
	if weekday == 6 {
		top8VSInfo := u.Top8VSInfo()
		for i := 1; i <= 8; i++ {
			if _, ok := top8VSInfo[document.Integer(i)]; ok {
				top8Unions[top8VSInfo[document.Integer(i)].UnionID] = true
			}
		}
	}

	for _, union := range unions {
		point := union.Point
		if weekday == RankAllWeekdayNum {
			union.PointSum += union.Point
			point = union.PointSum
		}

		if weekday == 6 {
			if _, ok := top8Unions[union.UnionID]; !ok {
				continue
			}
		} else if point <= 0 {
			continue
		}

		ranks.items = append(ranks.items, rankitem{
			id: union.UnionID,
			items: map[string]int{
				"point": point,
			},
		})
	}

	ranks.keys = []string{"point"}
	sort.Sort(ranks)

	weekRank := []scheme.UnionFightUnionRankItem{}
	// 用于发奖励的公会排名
	awardRanks := []UnionRankAwardItem{}

	for i, v := range ranks.items {
		rank := i + 1
		if i < 20 {
			log.Infof("UnionFight.updateWeekUnionRank weekday %d final union rank %d %v %v", weekday, rank, v.id, v.items)
			weekRank = append(weekRank, scheme.UnionFightUnionRankItem{
				UnionID: v.id,
				Rank:    rank,
				Name:    unions[v.id].Name,
				Logo:    unions[v.id].Logo,
				Point:   v.items["point"],
				Level:   unions[v.id].Level,
			})
		}
		if unions[v.id].RankRecord == nil {
			unions[v.id].RankRecord = make(map[document.Integer]scheme.UnionFightRankOnceItem)
		}
		unions[v.id].RankRecord[document.Integer(weekday)] = scheme.UnionFightRankOnceItem{
			Rank:  rank,
			Point: v.items["point"],
		}
		if needAwardRank {
			awardRanks = append(awardRanks, UnionRankAwardItem{
				UnionID: v.id,
				Rank:    rank,
			})
		}
	}
	u.SetUnions(unions)

	unionRanks := u.UnionRanks()
	unionRanks[document.Integer(weekday)] = weekRank
	u.SetUnionRanks(unionRanks)

	return awardRanks
}

// 初始化 top8 信息
func (u *UnionFight) initTop8VSInfo() {
	u.Lock()
	unionRanks := u.UnionRanks()
	totalRank := unionRanks[RankAllWeekdayNum]
	//if len(totalRank) < 8 {
	//	log.Warning("top8 vs union count not enough")
	//	return
	//}
	top8VSInfo := make(map[document.Integer]*scheme.UnionFightTop8VSUnionInfo)

	l := len(totalRank)
	for i := 1; i <= 8; i++ {
		if i > l {
			continue
		}
		union := u.Unions()[totalRank[i-1].UnionID]
		union.Top8MaxRoundKey = i
		top8VSInfo[document.Integer(i)] = newUnionFightTop8VSUnionInfo(union)
	}

	u.SetTop8VSInfo(top8VSInfo)

	top8VSUnion := make(map[document.ID][]document.ID)
	for _, v := range top8VSInfo {
		top8VSUnion[v.UnionID] = []document.ID{}
	}
	u.Unlock()

	u.eventToGame("top8_vs_union", EventToGame{
		Top8VSUnion: top8VSUnion,
	}, false)
}

// 更新八强排名
func (u *UnionFight) updateTop8UnionRank() []UnionRankAwardItem {
	u.Lock()
	defer u.Unlock()

	top8Rank := []document.ID{}
	top8VSInfo := u.Top8VSInfo()
	unions := u.Unions()

	tmpCheck := make(map[document.ID]bool)
	var unionID document.ID
	// 冠军
	if info, ok := top8VSInfo[document.Integer(18452736)]; ok {
		unionID = info.UnionID
		top8Rank = append(top8Rank, unionID)
		tmpCheck[unionID] = true
	}

	// 亚军
	oldUnionID := unionID
	if info, ok := top8VSInfo[document.Integer(1845)]; ok && info.UnionID != oldUnionID {
		unionID = info.UnionID
	} else if info, ok := top8VSInfo[document.Integer(2736)]; ok && info.UnionID != oldUnionID {
		unionID = info.UnionID
	}
	if oldUnionID != unionID {
		top8Rank = append(top8Rank, unionID)
		tmpCheck[unionID] = true
	}

	// 季军
	_, ok1 := top8VSInfo[document.Integer(-1845)]
	_, ok2 := top8VSInfo[document.Integer(-2736)]
	if ok1 && ok2 {
		union1 := unions[top8VSInfo[document.Integer(-1845)].UnionID]
		union2 := unions[top8VSInfo[document.Integer(-2736)].UnionID]
		if union1.Point > union2.Point {
			top8Rank = append(top8Rank, union1.UnionID)
			top8Rank = append(top8Rank, union2.UnionID)
		} else {
			top8Rank = append(top8Rank, union2.UnionID)
			top8Rank = append(top8Rank, union1.UnionID)
		}
		tmpCheck[union1.UnionID] = true
		tmpCheck[union2.UnionID] = true
	} else if ok1 && !ok2 {
		union1 := unions[top8VSInfo[document.Integer(-1845)].UnionID]
		top8Rank = append(top8Rank, union1.UnionID)
		tmpCheck[union1.UnionID] = true
	} else if !ok1 && ok2 {
		union2 := unions[top8VSInfo[document.Integer(-2736)].UnionID]
		top8Rank = append(top8Rank, union2.UnionID)
		tmpCheck[union2.UnionID] = true
	}

	ranks := &ranks{
		items: make([]rankitem, 0, 4),
	}

	// 5678 根据积分排序
	for i := 1; i <= 8; i++ {
		if _, ok := top8VSInfo[document.Integer(i)]; !ok {
			continue
		}
		unionID = top8VSInfo[document.Integer(i)].UnionID
		if _, ok := tmpCheck[unionID]; ok {
			continue
		}
		union := unions[unionID]
		ranks.items = append(ranks.items, rankitem{
			id: union.UnionID,
			items: map[string]int{
				"point": union.Point,
			},
		})
	}

	ranks.keys = []string{"point"}
	sort.Sort(ranks)
	for _, v := range ranks.items {
		top8Rank = append(top8Rank, v.id)
	}

	unionRanks := u.UnionRanks()
	unionRank6 := unionRanks[document.Integer(6)]
	unionRanks[document.Integer(6)] = refreshTop8(top8Rank, unionRank6)
	unionRankAll := unionRanks[document.Integer(RankAllWeekdayNum)]
	unionRanks[document.Integer(RankAllWeekdayNum)] = refreshTop8(top8Rank, unionRankAll)
	u.SetUnionRanks(unionRanks)

	// 刷新决赛对应公会的排名信息
	for idx, item := range unionRanks[document.Integer(6)] {
		if _, ok := unions[item.UnionID]; !ok {
			continue
		}
		if unions[item.UnionID].RankRecord == nil {
			unions[item.UnionID].RankRecord = make(map[document.Integer]scheme.UnionFightRankOnceItem)
		}
		unions[item.UnionID].RankRecord[document.Integer(6)] = scheme.UnionFightRankOnceItem{
			Rank:  item.Rank,
			Point: item.Point,
		}

		if idx > len(unionRanks[document.Integer(RankAllWeekdayNum)])-1 {
			continue
		}
		rankAllItem := unionRanks[document.Integer(RankAllWeekdayNum)][idx]
		if rankAllItem.UnionID != item.UnionID {
			log.Warningf("UnionFight.updateTop8UnionRank rank6 %d and rankAll %d error", item.Rank, rankAllItem.Rank)
			continue
		}
		unions[rankAllItem.UnionID].RankRecord[document.Integer(RankAllWeekdayNum)] = scheme.UnionFightRankOnceItem{
			Rank:  rankAllItem.Rank,
			Point: rankAllItem.Point,
		}
	}
	u.SetUnions(unions)

	awardRank := []UnionRankAwardItem{}
	for _, v := range unionRanks[document.Integer(6)] {
		awardRank = append(awardRank, UnionRankAwardItem{
			UnionID: v.UnionID,
			Rank:    v.Rank,
		})
	}

	return awardRank
}

// 押注奖励
func (u *UnionFight) sendBetAward() {
	u.RLock()

	bets := u.Bet()
	// {roleiD: (winName, winGold, level)}
	roleBets := make(map[document.ID][3]interface{})
	unionRanks := u.UnionRanks()[RankAllWeekdayNum]
	top8 := make(map[document.ID]bool)
	num := 20
	if len(unionRanks) < num {
		num = len(unionRanks)
	}
	for i := 1; i <= num; i++ {
		unionID := unionRanks[i-1].UnionID
		top8[unionID] = true
		bet, ok := bets[unionID]
		if !ok {
			continue
		}
		name := bet.Union.Name
		rate := bet.Rate
		cfg := GetConfig()
		for betRoleID, gold := range bet.Gold {
			if i == 1 { // 冠军
				gold := int(float64(gold) * rate)
				if gold > cfg.MaxBetWin {
					gold = cfg.MaxBetWin
				}
				roleBets[betRoleID] = [3]interface{}{name, gold, "champion"}
			} else { // 未获得冠军，但是进入八强，会获得一半的金币返还补
				roleBets[betRoleID] = [3]interface{}{name, gold / 2, "top8"}
			}
		}
	}

	// 下注失败
	for unionID, b := range bets {
		if top8[unionID] {
			continue
		}
		name := b.Union.Name
		for betRoleID := range b.Gold {
			roleBets[betRoleID] = [3]interface{}{name, 0, "fail"}
		}
	}
	u.RUnlock()

	u.eventToGame("bet_award", EventToGame{UnionFightBets: roleBets}, false)

}

// 初始化押注
func (u *UnionFight) initNextBet() {
	u.Lock()
	defer u.Unlock()

	nextbets := make(map[document.ID]*scheme.UnionFightBet)
	unionRanks := u.UnionRanks()[RankAllWeekdayNum]
	unions := u.Unions()
	for idx, item := range unionRanks {
		if idx+1 > 8 {
			break
		}
		union, ok := unions[item.UnionID]
		if !ok {
			log.Info("UnionFight.initNextBet rank %d no union", item.Rank)
		}
		nextbets[item.UnionID] = &scheme.UnionFightBet{
			Union: scheme.UnionFgihtUnion{
				UnionID: item.UnionID,
				Name:    union.Name,
				Logo:    union.Logo,
				Level:   union.Level,
			},
			Rank:  item.Rank,
			Rate:  GetConfig().MinBetRate,
			Gold:  make(map[document.ID]int),
			Point: item.Point,
		}
	}
	u.SetBet(nextbets)
	u.betsum = 0
}

// 记录每轮公会存活人数用于战斗播放
func (u *UnionFight) recordRoundLive(round int) {
	unions := u.Unions()
	for _, union := range unions {
		if _, ok := u.roundLiveCache[union.UnionID]; !ok {
			u.roundLiveCache[union.UnionID] = make(map[int]int)
		}
		u.roundLiveCache[union.UnionID][round] = union.SignNum - union.DeadNum
		if union.IsOut && union.RoundMax == 0 {
			union.RoundMax = round
		} else if !union.IsOut {
			union.RoundMax = round
		}
	}
	u.SetUnions(unions)
}

// 开始预选赛播放
func (u *UnionFight) onStartBattle2345Timer() {
	u.SetRound("battle")
	u.eventToGame("battle", EventToGame{}, false)
	t := time.NewTicker(BattleStartDuration2345)
	showRound := 0
	for {
		<-t.C
		showRound++
		log.Infof("UnionFight onStartBattle timer %d RoundResultMax %d", showRound, u.RoundResultMax())
		if showRound >= u.RoundResultMax() && atomic.LoadInt32(&u.playStatus) == 1 {
			// 全部打完一分钟后切换状态
			time.AfterFunc(time.Second*60, u.onOver)
			break
		}
	}
	t.Stop()
}

// 匹配对手
func (u *UnionFight) makeMatch2345() (bool, [][2]document.ID) {
	matchs := [][2]document.ID{}
	unionRoleIDs := make(map[document.ID][]document.ID)
	unionIDs := []document.ID{}

	fightRoleNum := 0
	u.fightRoles.Range(func(key, value interface{}) bool {
		roleID := key.(document.ID)
		record := value.(*RoleRecord)
		unionID := record.UnionDbId()
		if _, ok := unionRoleIDs[unionID]; !ok {
			unionIDs = append(unionIDs, unionID)
		}
		unionRoleIDs[unionID] = append(unionRoleIDs[unionID], roleID)
		fightRoleNum++
		return true
	})

	log.Infof("UnionFight.makeMatch2345 fight role sum %d", fightRoleNum)

	if fightRoleNum == 1 {
		u.fightRoles.Range(func(key, value interface{}) bool {
			roleRecord := value.(*RoleRecord)
			u.setLastWinInfo(roleRecord)
			return true
		})
		return true, nil
	} else if fightRoleNum == 0 {
		if u.lastRoleRecordCache == nil {
			log.Warningf("UnionFight.makeMatch2345 not create last role id")
			return true, nil
		}
		u.setLastWinInfo(u.lastRoleRecordCache)
		return true, nil
	}

	unionLens := sortUnionRoleIDs(unionRoleIDs)

	// 先把最大长度的截取出来处理
	if len(unionLens) > 1 {
		unionID1 := unionLens[0]
		left := len(unionRoleIDs[unionID1]) - len(unionRoleIDs[unionLens[1]])
		for left > 0 {
			hasRemove := false
			for idx := 1; idx < len(unionLens); idx++ {
				unionID2 := unionLens[idx]
				if len(unionRoleIDs[unionID2]) > 0 {
					roleIdx1 := left - 1
					roleIdx2 := 0
					roleID1, roleID2 := unionRoleIDs[unionID1][roleIdx1], unionRoleIDs[unionID2][roleIdx2]
					matchs = append(matchs, [2]document.ID{roleID1, roleID2})
					unionRoleIDs[unionID1] = append(unionRoleIDs[unionID1][:roleIdx1], unionRoleIDs[unionID1][roleIdx1+1:]...)
					unionRoleIDs[unionID2] = append(unionRoleIDs[unionID2][:roleIdx2], unionRoleIDs[unionID2][roleIdx2+1:]...)
					left--
					hasRemove = true
					if left == 0 {
						break
					}
				}
			}
			if !hasRemove {
				break
			}
		}
	}

	unionLens = sortUnionRoleIDs(unionRoleIDs)
	initList := []document.ID{}
	unionID1 := unionLens[0]
	for x := 0; x < len(unionRoleIDs[unionID1]); x++ {
		initList = append(initList, unionRoleIDs[unionID1][x])
		for idx := 0; idx < len(unionLens); idx++ {
			unionID := unionLens[idx]
			if unionID != unionID1 && len(unionRoleIDs[unionID]) > x {
				initList = append(initList, unionRoleIDs[unionID][x])
			}
		}
	}

	for idx := 0; idx < int(len(initList)/2)*2-1; idx += 2 {
		matchs = append(matchs, [2]document.ID{initList[idx], initList[idx+1]})
	}

	// 最后一个轮空
	if len(initList)%2 == 1 {
		matchs = append(matchs, [2]document.ID{initList[len(initList)-1], ""})
	}

	return false, matchs
}

func (u *UnionFight) setLastWinInfo(roleRecord *RoleRecord) {
	union := u.Unions()[roleRecord.UnionDbId()]
	union.IsOut = false
	union.LastRoleName = roleRecord.RoleName()
	union.Point += GetConfig().LastWinRolePoint
	unionRecord := u.builder.GetUnionFightUnionRecord(roleRecord.UnionDbId())
	// 增加战斗之星
	unionBattleStar := unionRecord.BattleStarNum()
	unionRecord.SetBattleStarNum(unionBattleStar + 1)
	u.SetLastRoleID(roleRecord.GetID())
	u.SetLastUnionID(unionRecord.UnionDbId())
	log.Infof("UnionFight last role %s last union %s", roleRecord.RoleName(), unionRecord.UnionName())
}

func (u *UnionFight) isAllOver() bool {
	round := u.Round()
	date := u.Date()
	if date == 0 {
		return true
	}
	if round != "over" {
		return false
	}
	return util.Todaydate2int() != date
}

func (u *UnionFight) resetToday() {
	round := u.Round()
	date := u.Date()
	weekday := util.Now().Weekday()
	log.Debugf("Union Fight.ResetToday date %d weekday %d round %s", date, weekday, round)
	//weekday = 6
	if weekday == 7 || weekday == 1 {
		u.SetRound("over")
		return
	}
	if round != "over" {
		go func() {
			resp := u.eventToGame("reset_today", EventToGame{}, false)
			u.onPrepare(resp.Signup, int(weekday), resp.Top8Deploys)
		}()
	}
}

func (u *UnionFight) getRecordByRoleID(roleID document.ID) *RoleRecord {
	u.RLock()
	recordID := u.Roles()[roleID].RecordID
	u.RUnlock()

	return u.builder.GetUnionFightRoleRecord(recordID)
}

func (u *UnionFight) getPlayCards(record *RoleRecord) ([]document.ID, map[document.ID]*scheme.CardBattleModel, map[document.ID]*scheme.CardBattleModel, map[document.ID][2]float64, int) {
	u.Lock()
	defer u.Unlock()

	record.RLock()
	defer record.RUnlock()

	cardsRecord := record.Cards()
	cardDRecord := record.CardAttrs()
	cardDRecord2 := record.CardAttrs2()
	cards := make([]document.ID, 6)                         // 卡牌站位
	cardD := make(map[document.ID]*scheme.CardBattleModel)  // 卡牌属性
	cardD2 := make(map[document.ID]*scheme.CardBattleModel) // 卡牌双属性
	cardS := make(map[document.ID][2]float64)               // 卡牌状态

	roleState := u.Roles()[record.RoleDbId()]
	roleState.CurTroopBattleNum++

	troop := roleState.CurTroop
	if _, ok := roleState.CardState[document.Integer(troop)]; !ok {
		roleState.CardState[document.Integer(troop)] = make(map[document.ID][2]float64)
	}
	cardsInfo := cardsRecord[document.Integer(u.weekday)][document.Integer(troop)]
	for idx, cardID := range cardsInfo {
		if cardID == "" {
			continue
		}
		if attr, ok1 := cardDRecord[cardID]; !ok1 || attr == nil {
			log.Info("UnionFight role %s card attr not exists", record.RoleDbId())
			continue
		}
		if _, ok := roleState.CardState[document.Integer(troop)][cardID]; ok {
			cardS[cardID] = roleState.CardState[document.Integer(troop)][cardID]
		} else {
			cardS[cardID] = [2]float64{1, 1}
		}
		if !float64IsEqual(cardS[cardID][0], 0) {
			cardD[cardID] = u.cardFix(cardDRecord[cardID], roleState.CurTroopBattleNum)
			cards[idx] = cardID
			if attr, ok := cardDRecord2[cardID]; ok {
				cardD2[cardID] = u.cardFix(attr, roleState.CurTroopBattleNum)
			}
		}
	}
	return cards, cardD, cardD2, cardS, troop
}

func (u *UnionFight) cardFix(origin *scheme.CardBattleModel, battleNum int) *scheme.CardBattleModel {
	ret := &scheme.CardBattleModel{
		ID:            origin.ID,
		CardId:        origin.CardId,
		SkinId:        origin.SkinId,
		Level:         origin.Level,
		FightingPoint: origin.FightingPoint,
		Star:          origin.Star,
		Advance:       origin.Advance,
		Skills:        make(map[document.Integer]int),
		PassiveSkills: make(map[document.Integer]int),
	}

	for k, v := range origin.Skills {
		ret.Skills[k] = v
	}

	for k, v := range origin.PassiveSkills {
		ret.PassiveSkills[k] = v
	}

	ret.Attrs = u.attrFix(origin.Attrs, origin.CardId, battleNum)
	ret.Attrs2 = u.attrFix(origin.Attrs2, origin.CardId, battleNum)

	return ret
}

func (u *UnionFight) attrFix(originAttrs map[string]float64, cardId, battleNum int) map[string]float64 {
	ret := make(map[string]float64)
	battleStars := u.BattleStars()
	bf, hasBf := GetConfig().BattleFixMap[battleNum]
	if !hasBf {
		bf, hasBf = GetConfig().BattleFixMap[len(GetConfig().BattleFixMap)]
	}

	config := csv.GetConfig()
	for k, v := range originAttrs {
		tmp := v
		if hasBf {
			if _, ok := bf[k]; ok {
				tmp = tmp * bf[k]
			}
		}
		card := config.Cards[cardId]
		natureType := document.Integer(config.Unit[card.UnitID].NatureType)
		natureType2 := document.Integer(config.Unit[card.UnitID].NatureType2)
		attrStarKey := document.Integer(BattleStarAttrStrToInt[k])

		if _, ok := battleStars[natureType]; ok {
			if starFix, ok2 := battleStars[natureType][attrStarKey]; ok2 {
				tmp = tmp * (1 + float64(starFix)*0.01)
			}
		}

		if _, ok := battleStars[natureType2]; ok {
			if starFix, ok2 := battleStars[natureType2][attrStarKey]; ok2 {
				tmp = tmp * (1 + float64(starFix)*0.01)
			}
		}

		ret[k] = tmp
	}

	return ret
}

func (u *UnionFight) createPlayModel(round string, r1, r2 *RoleRecord, top83V3Round int) *scheme.UnionFightPlayRecord {
	if r1 == nil && r2 == nil {
		panic("r1 and r2 is nil")
	}

	var model *scheme.UnionFightPlayRecord
	model = NewPlayModel(round, r1, r2)
	model.Top83V3Round = top83V3Round

	if r1 != nil {
		cards1, cardD1, cardD12, cardS1, troops1 := u.getPlayCards(r1)
		model.Cards = cards1
		model.CardAttrs = cardD1
		model.CardAttrs2 = cardD12
		model.CardStates = cardS1
		model.Troops = troops1
	}

	if r2 != nil {
		cards2, cardD2, cardD22, cardS2, Troops2 := u.getPlayCards(r2)
		model.DefenceCards = cards2
		model.DefenceCardAttrs = cardD2
		model.DefenceCardAttrs2 = cardD22
		model.DefenceCardStates = cardS2
		model.DefenceTroops = Troops2
	}

	return model
}

func (u *UnionFight) resendPlay(playRecord *PlayRecord, resetSeed bool) {
	playID := playRecord.GetID()
	if resetSeed {
		old := playRecord.RandSeed()
		seed := rand.Int31n(99999999) + 1
		playRecord.SetRandSeed(seed)
		log.Warningf("UnionFight.onPlayResult agent play %v result is error, reset seed %d -> %d", playID, old, seed)
	}
	u.mgr.SendPlay(playID, playRecord)
}

func (u *UnionFight) onPlayResult(mgrResult manager.Result, playMap *sync.Map) {
	playID := mgrResult.ID
	playRecord := u.builder.GetUnionFightPlayRecord(playID)

	if mgrResult.Error != nil {
		u.resendPlay(playRecord, false)
		return
	}

	result := mgrResult.Result.(anti_cheat.UnionFightBattleResult)

	// 异常战斗结果重发
	if result.Result != "win" && result.Result != "fail" {
		u.resendPlay(playRecord, true)
		return
	}

	playResult := result.Result
	playRecord.SetResult(result.Result)

	var record1, record2 *RoleRecord
	var unionRecord1, unionRecord2 *UnionRecord
	var unionID1, unionID2, roleID1, roleID2 document.ID
	if playRecord.RoleDbId() != "" {
		record1 = u.getRecordByRoleID(playRecord.RoleDbId())
		unionID1 = record1.UnionDbId()
		roleID1 = record1.RoleDbId()
		unionRecord1 = u.builder.GetUnionFightUnionRecord(unionID1)
	}
	if playRecord.DefenceRoleDbId() != "" {
		record2 = u.getRecordByRoleID(playRecord.DefenceRoleDbId())
		unionID2 = record2.UnionDbId()
		roleID2 = record2.RoleDbId()
		unionRecord2 = u.builder.GetUnionFightUnionRecord(unionID2)
	}

	u.Lock()
	defer u.Unlock()

	roles := u.Roles()
	unions := u.Unions()

	winPoint := GetConfig().BattleWinPoint
	failPoint := GetConfig().BattleFailPoint
	// 处理积分相关计算
	if playResult == "win" {
		unions[unionID1].KillNum++
		unions[unionID1].Point += winPoint
		roles[roleID1].Point += winPoint
		roles[roleID1].KillNum++
		if record2 != nil {
			unions[unionID2].Point += failPoint
			roles[roleID2].Point += failPoint
		}
	} else {
		unions[unionID2].KillNum++
		unions[unionID2].Point += winPoint
		roles[roleID2].Point += winPoint
		roles[roleID2].KillNum++
		if record1 != nil {
			unions[unionID1].Point += failPoint
			roles[roleID1].Point += failPoint
		}
	}

	u.SetUnions(unions)
	u.SetRoles(roles)

	// 处理卡牌剩余血量和怒气值
	cardStateTmp1 := make(map[document.ID][2]float64)
	cardStateTmp2 := make(map[document.ID][2]float64)
	cardState1 := playRecord.CardStates()
	for k, v := range cardState1 {
		cardStateTmp1[k] = v
	}
	cardState2 := playRecord.DefenceCardStates()
	for k, v := range cardState2 {
		cardStateTmp2[k] = v
	}

	// 检测反作弊返回的卡牌状态是否正确
	agentResultStateErr := false
	for k, v := range result.States {
		if _, ok := cardStateTmp1[k]; ok {
			cardStateTmp1[k] = [2]float64{v[0], v[1]}
			if playResult == "fail" && !float64IsEqual(cardStateTmp1[k][0], 0) {
				cardStateTmp1[k] = [2]float64{0, 0}
				agentResultStateErr = true
			}
		}
		if _, ok := cardStateTmp2[k]; ok {
			cardStateTmp2[k] = [2]float64{v[0], v[1]}
			if playResult == "win" && !float64IsEqual(cardStateTmp2[k][0], 0) {
				cardStateTmp2[k] = [2]float64{0, 0}
				agentResultStateErr = true
			}
		}
	}

	if agentResultStateErr {
		log.Warningf("UnionFight.onPlayResult agent play %v result state err %v", playID, result.States)
	}

	round := playRecord.Round()

	var hp1, hp2 int

	// 更新角色状态
	if record1 != nil {
		hp1 = u.updateRoleState(round, record1, cardStateTmp1)
	}
	if record2 != nil {
		hp2 = u.updateRoleState(round, record2, cardStateTmp2)
	}

	// 双方都死情况记录最后一方获胜者，用于 match 时 fightRoles 等于 0 判定最终获胜者
	if u.weekday != 6 && hp1 == 0 && hp2 == 0 {
		if playResult == "win" {
			u.lastRoleRecordCache = record1
		} else {
			u.lastRoleRecordCache = record2
		}
	}

	resultInfo := scheme.UnionFightResultInfo{
		PlayID:       playRecord.GetID(),
		Result:       playRecord.Result(),
		Top83V3Round: playRecord.Top83V3Round(),
	}

	if record1 != nil {
		resultInfo.Left = scheme.UnionFightResultItem{
			RoleID:     record1.RoleDbId(),
			RoleName:   record1.RoleName(),
			RoleLogo:   record1.RoleLogo(),
			RoleFrame:  record1.RoleFrame(),
			RoleLevel:  record1.RoleLevel(),
			RoleFigure: record1.RoleFrame(),
			UnionID:    record1.UnionDbId(),
			UnionName:  unions[unionID1].Name,
			HP:         hp1,
			Troops:     playRecord.Troops(),
		}
	}
	if record2 != nil {
		resultInfo.Right = scheme.UnionFightResultItem{
			RoleID:     record2.RoleDbId(),
			RoleName:   record2.RoleName(),
			RoleLogo:   record2.RoleLogo(),
			RoleFrame:  record2.RoleFrame(),
			RoleLevel:  record2.RoleLevel(),
			RoleFigure: record2.RoleFigure(),
			UnionID:    record2.UnionDbId(),
			UnionName:  unions[unionID2].Name,
			HP:         hp2,
			Troops:     playRecord.DefenceTroops(),
		}
	}

	// 保存战斗记录到对应公会的 record 下面
	// 同一个公会，战斗记录保存一次
	if unionRecord1 != nil && unionRecord2 != nil && unionID1 == unionID2 {
		unionRecord1.pushUnionRoundResult(round, resultInfo)
	} else {
		if unionRecord1 != nil {
			unionRecord1.pushUnionRoundResult(round, resultInfo)
		}
		if unionRecord2 != nil {
			unionRecord2.pushUnionRoundResult(round, resultInfo)
		}
	}

	playMap.Delete(playID)
}

func (u *UnionFight) updateRoleState(round string, record *RoleRecord, states map[document.ID][2]float64) int {
	roleState := u.Roles()[record.RoleDbId()]
	troop := roleState.CurTroop
	if _, ok := roleState.CardState[document.Integer(troop)]; !ok {
		roleState.CardState[document.Integer(troop)] = make(map[document.ID][2]float64)
	}
	for k, v := range states {
		roleState.CardState[document.Integer(troop)][k] = v
	}
	hpSum, hpClient := calcHpPercent(roleState.CardState[document.Integer(troop)])
	maxTroop := len(record.Cards()[document.Integer(u.weekday)])

	// 死亡相关的处理
	if float64IsEqual(hpSum, 0) {
		// 标记对应队伍死亡
		roleState.DeedInfo[document.Integer(troop)] = true
		// 重置进入战斗的次数
		roleState.CurTroopBattleNum = 0

		// 是否是最后一个队伍
		if troop == maxTroop {
			u.fightRoles.Delete(record.RoleDbId())
			unions := u.Unions()
			union := unions[record.UnionDbId()]
			union.DeadNum++
			if union.SignNum == union.DeadNum {
				union.IsOut = true
				union.LastRoleName = record.RoleName()
			}
			// 不是决赛记录最大 round
			if _, ok := Top8PlayRoundMap[round]; !ok {
				union.RoundMax, _ = strconv.Atoi(round)
			}
			u.SetUnions(unions)
		} else {
			roleState.CurTroop++
		}
	}

	ret := int(hpClient * 100)
	// 反作弊返回的血量精度很小导致 HP 为零，和从策划确认保留 1% 的血量
	if ret == 0 && !float64IsEqual(hpClient, 0) {
		ret = 1
	}
	return ret
}

func (u *UnionFight) getRespUnionInfo(unionID document.ID, curRound string, top8Deploy []document.ID, weekday int) RespUnionInfo {
	ret := RespUnionInfo{}
	u.RLock()
	union, ok := u.Unions()[unionID]
	u.RUnlock()
	if ok {
		ret.IsOut = union.IsOut
		ret.SignNum = union.SignNum
		ret.MemberNum = union.MemberNum
		ret.CurRank = union.RankRecord[document.Integer(RankAllWeekdayNum)].Rank
		ret.CurPoint = union.Point

		// 是否是八强赛的 round result
		if _, ok := Top8PlayRoundMap[curRound]; !ok {
			curRoundInt, _ := strconv.Atoi(curRound)
			if curRoundInt > 0 && union.RoundMax > curRoundInt {
				for i := 1; i <= curRoundInt; i++ {
					if _, ok := u.roundLiveCache[unionID][i]; ok {
						ret.LiveNum = u.roundLiveCache[unionID][i]
					} else {
						break
					}
				}
				ret.IsOut = false
			} else {
				ret.IsOut = union.IsOut
				ret.LastRoleName = union.LastRoleName
				ret.LiveNum = union.SignNum - union.DeadNum
			}
			if u.Round() == "prepare" || curRoundInt == 0 {
				ret.IsOut = false
				ret.LiveNum = union.SignNum
				ret.LastRoleName = ""
			}
		} else {
			ret.LiveNum = union.SignNum - union.DeadNum
		}

		ret.TopsDeploy = u.getTop8DeployInfo(top8Deploy, weekday)
		ret.Top8RoundKey = union.Top8MaxRoundKey
		ret.Top8EnemyUnion = u.getTop8EnemyUnion(unionID)
		unionRecord := u.builder.GetUnionFightUnionRecord(unionID)
		ret.BattleStarNum = unionRecord.BattleStarNum()
		return ret
	} else {
		return ret
	}
}

// 公会战斗中的存活数和报名数
func (u *UnionFight) getUnionBattleStatus(gameRound, curRound string) map[document.ID]UnionBattleStatuItem {
	u.RLock()
	defer u.RUnlock()

	unions := u.Unions()

	ret := make(map[document.ID]UnionBattleStatuItem)

	if gameRound != "battle" {
		return ret
	}

	for _, union := range unions {
		unionID := union.UnionID

		if union.SignNum <= 0 {
			continue
		}

		item := UnionBattleStatuItem{SignNum: union.SignNum, Name: union.Name}

		if _, ok := Top8PlayRoundMap[curRound]; !ok && u.weekday != 6 {
			curRoundInt, _ := strconv.Atoi(curRound)
			if curRoundInt > 0 && union.RoundMax > curRoundInt {
				for i := 1; i <= curRoundInt; i++ {
					if _, ok := u.roundLiveCache[unionID][i]; ok {
						item.LiveNum = u.roundLiveCache[unionID][i]
					} else {
						break
					}
				}
			} else {
				item.LiveNum = union.SignNum - union.DeadNum
			}
			if curRoundInt == 0 {
				item.LiveNum = union.SignNum
			}
		} else {
			item.LiveNum = union.SignNum - union.DeadNum
		}

		ret[unionID] = item
	}

	return ret
}

func (u *UnionFight) getTop8EnemyUnion(unionID document.ID) Top8EnemyUnion {
	u.RLock()
	defer u.RUnlock()

	ret := Top8EnemyUnion{}
	if u.weekday != 6 {
		return ret
	}
	union := u.Unions()[unionID]
	if union.Top8MaxRoundKey == 0 {
		return ret
	}
	top8VSInfo := u.Top8VSInfo()
	enemyRoundkey := Top8PlayEnemyMap[union.Top8MaxRoundKey]
	enemyTop8Union, ok := top8VSInfo[document.Integer(enemyRoundkey)]
	if !ok {
		return ret
	}
	enemyUnionID := enemyTop8Union.UnionID
	enemyUnion := u.Unions()[enemyUnionID]
	ret.UnionID = enemyUnion.UnionID
	ret.Name = enemyUnion.Name
	ret.Logo = enemyUnion.Logo
	ret.Top8RoundKey = enemyRoundkey
	ret.Level = enemyUnion.Level
	return ret
}

// 预选赛 curRound 是字符串数字
// 决赛 curRound 是不为数字的字符串，空字符串返回最新的战斗记录，不是空字符串返回对应的对战记录
func (u *UnionFight) getUnionHistory(unionID document.ID, curRound string) map[interface{}][]scheme.UnionFightResultInfo {
	ret := make(map[interface{}][]scheme.UnionFightResultInfo)

	var tmpRoundResults map[string][]scheme.UnionFightResultInfo
	// 八强赛战斗记录数据
	if _, ok := Top8PlayRoundMap[curRound]; ok {
		tmpUnionID := u.Top8VSInfo()[document.Integer(Top8PlayRoundMap[curRound][0])].UnionID
		if tmpUnionID == "" {
			return ret
		}
		tmpUnionRecord := u.builder.GetUnionFightUnionRecord(tmpUnionID)
		if u.Round() != "over" {
			tmpRoundResults = tmpUnionRecord.RoundResults()
		} else {
			tmpRoundResults = tmpUnionRecord.YesterdayRoundResults()
		}
		ret[curRound] = tmpRoundResults[curRound]
		return ret
	}

	u.RLock()
	union, ok := u.Unions()[unionID]
	u.RUnlock()
	if !ok {
		return ret
	}

	unionRecord := u.builder.GetUnionFightUnionRecord(unionID)
	unionRoundResult := unionRecord.RoundResults()

	// 八强赛默认战斗记录数据
	if curRound == "" {
		// 准备状态不返回上一次战斗和最新战斗
		if u.Round() == "prepare" {
			return ret
		}
		roundKey, ok := Top8PlayKeyMap[[2]int{union.Top8MaxRoundKey, Top8PlayEnemyMap[union.Top8MaxRoundKey]}]
		if ok {
			ret[curRound] = unionRoundResult[roundKey]
		}
		roundKey, ok = Top8PlayKeyMap[[2]int{Top8PlayEnemyMap[union.Top8MaxRoundKey], union.Top8MaxRoundKey}]
		if ok {
			ret[curRound] = unionRoundResult[roundKey]
		}
		log.Info("top8 play info", curRound, ret)
		return ret
	}

	// 周2 3 4 5战斗之外的状态不返回数据
	if u.Round() != "battle" {
		return ret
	}

	l := union.RoundMax
	curROundInt, _ := strconv.Atoi(curRound)
	if l > curROundInt {
		l = curROundInt
	}

	ret[l] = append(ret[l], unionRoundResult[strconv.Itoa(l)]...)
	if len(ret[l]) <= 3 && l > 2 {
		ret[l-1] = append(ret[l-1], unionRoundResult[strconv.Itoa(l-1)]...)
	}

	//for k, v := range ret {
	//	log.Infof("req %v real %d unionRoundMax %d num %d", curRound, k, union.RoundMax, len(v))
	//}
	return ret
}

func (u *UnionFight) updateFinalResult() {
	u.Lock()
	defer u.Unlock()

	if u.weekday < 2 || u.weekday > 5 {
		return
	}

	ret := []scheme.UnionFightFinalResultItem{}
	unions := u.Unions()
	delete(unions, "")
	ranks := &ranks{
		items: make([]rankitem, 0, len(unions)),
	}

	for _, union := range unions {
		if union.Point <= 0 {
			continue
		}
		ranks.items = append(ranks.items, rankitem{
			id: union.UnionID,
			items: map[string]int{
				"point":     union.Point,
				"skill_num": union.KillNum,
			},
		})
	}

	ranks.keys = []string{"point", "skill_num"}
	sort.Sort(ranks)

	for i, v := range ranks.items {
		ret = append(ret, scheme.UnionFightFinalResultItem{
			Rank:       i + 1,
			UnionName:  unions[v.id].Name,
			UnionLogo:  unions[v.id].Logo,
			UnionLevel: unions[v.id].Level,
			SignNum:    unions[v.id].SignNum,
			KillNum:    unions[v.id].KillNum,
			Point:      unions[v.id].Point,
		})
		if i < 20 {
			log.Infof("final rank %d %v %v", i+1, v.id, v.items)
		}
	}

	u.SetFinalResult(ret)
}

func (u *UnionFight) getUnionsFinalRank() []scheme.UnionFightFinalResultItem {
	if u.Round() != "over" {
		return []scheme.UnionFightFinalResultItem{}
	}
	return u.FinalResult()
}

func (u *UnionFight) getLastRoleName(curRound string) string {
	if u.LastRoleID() == "" {
		return ""
	}

	//if u.weekday < 2 || u.weekday > 5 {
	//	return ""
	//}

	if _, ok := Top8PlayRoundMap[curRound]; !ok && u.Round() != "over" {
		curRoundInt, _ := strconv.Atoi(curRound)
		if curRoundInt < u.RoundResultMax() {
			return ""
		}
	}

	record := u.builder.GetUnionFightRoleRecord(u.LastRoleID())
	return record.RoleName()
}

func (u *UnionFight) getLastUnionName() string {
	if u.LastUnionID() == "" {
		return ""
	}

	if u.Round() != "over" {
		return ""
	}

	record := u.builder.GetUnionFightUnionRecord(u.LastUnionID())
	return record.UnionName()
}

func (u *UnionFight) getTop8DeployInfo(recordIDs []document.ID, weekday int) Top8DeployInfo {
	ret := Top8DeployInfo{
		Roles:    []document.ID{},
		RoleInfo: make(map[document.ID]Top8DeployRoleInfo),
	}

	roleRecord := u.getRoleRecordsByRoleRecordIDs(recordIDs)

	u.RLock()
	defer u.RUnlock()

	for _, recordID := range recordIDs {
		record, ok := roleRecord[recordID]
		if !ok {
			continue
		}
		if !record.checkCardsEnough(weekday) {
			continue
		}
		roleID := record.RoleDbId()
		ret.Roles = append(ret.Roles, roleID)
		info := Top8DeployRoleInfo{
			UnionFightRole: scheme.UnionFightRole{
				Name:   record.RoleName(),
				Logo:   record.RoleLogo(),
				Frame:  record.RoleFrame(),
				Level:  record.RoleLevel(),
				Figure: record.RoleFigure(),
			},
		}
		troops := make(map[int]Top8DeployRoleTroopsInfo)
		//cards := record.HoldCards()[document.Integer(6)]
		//cardAttrs := record.HoldCardAttrs()
		cards, cardAttrs := record.getWeekday6HoldCardAndAttr()
		if u.Round() == "prepare" || u.Round() == "battle" {
			//cards = record.Cards()[document.Integer(6)]
			//cardAttrs = record.CardAttrs()
			cards, cardAttrs = record.getWeekday6CardAndAttr()
		}
		for troopNum, recordTroops := range cards {
			troopsItem := Top8DeployRoleTroopsInfo{}
			tmp := [6]*Top8DeployCardInfo{}
			for idx, cardID := range recordTroops {
				if cardID == "" {
					continue
				}
				hp := 100
				if _, ok := u.Roles()[roleID]; ok {
					role := u.Roles()[roleID]
					if _, ok := role.CardState[document.Integer(troopNum)]; ok {
						if _, ok := role.CardState[document.Integer(troopNum)][cardID]; ok {
							hp = int(role.CardState[document.Integer(troopNum)][cardID][0] * 100)
							if hp == 0 && !float64IsEqual(role.CardState[document.Integer(troopNum)][cardID][0], 0) {
								hp = 1
							}
						}
					}
				}
				cardAttr := cardAttrs[cardID]
				tmp[idx] = &Top8DeployCardInfo{
					CardID:  cardAttr.CardId,
					SkinID:  cardAttr.SkinId,
					Hp:      hp,
					Level:   cardAttr.Level,
					Star:    cardAttr.Star,
					Advance: cardAttr.Advance,
				}
				if hp != 0 {
					troopsItem.TroopsFp += cardAttr.FightingPoint
				}
			}
			troopsItem.Cards = tmp
			troops[int(troopNum)] = troopsItem
			info.TotalFP += troopsItem.TroopsFp
		}
		info.Troops = troops
		ret.RoleInfo[roleID] = info
	}

	return ret
}

func (u *UnionFight) top8Deploy(unionID document.ID, roles []document.ID) error {
	u.Lock()
	defer u.Unlock()

	nt := util.NowTime()
	if nt > u.nextRoundBattleTime && nt < u.nextRoundPrepareTime {
		return errors.New("unionfightDeployLimit")
	}

	unions := u.Unions()
	unions[unionID].Roles = u.updateTop8Deploy(unions[unionID].Roles, roles)
	u.SetUnions(unions)
	return nil
}

func (u *UnionFight) updateTop8Deploy(old, new []document.ID) []document.ID {
	check := map[document.ID]bool{}
	for _, roleID := range old {
		check[roleID] = true
	}
	newRoles := make([]document.ID, 0, len(new))

	for _, roleID := range new {
		if _, ok := check[roleID]; !ok {
			log.Warningf("unionFight update top8Deploy roleID %s not exists", roleID)
			continue
		}
		newRoles = append(newRoles, roleID)
	}
	return newRoles
}

func (u *UnionFight) getRankInfo(recordID document.ID) map[int]RespRankInfo {
	ret := map[int]RespRankInfo{}
	weekDayKey := []int{2, 3, 4, 5, 6, 8}
	record := u.builder.GetUnionFightRoleRecord(recordID)

	u.RLock()
	defer u.RUnlock()

	for _, weekday := range weekDayKey {
		item := RespRankInfo{}
		if roleRank, ok := u.RoleRanks()[document.Integer(weekday)]; ok {
			item.RoleRank = roleRank
		}

		if unionRank, ok := u.UnionRanks()[document.Integer(weekday)]; ok {
			item.UnionRank = unionRank
		}
		if role, ok1 := u.Roles()[record.RoleDbId()]; ok1 {
			if myRnak, ok2 := role.RankRecord[document.Integer(weekday)]; ok2 {
				item.MyRank = myRnak
			}
		}

		if union, ok1 := u.Unions()[record.UnionDbId()]; ok1 {
			if myUnionRnak, ok2 := union.RankRecord[document.Integer(weekday)]; ok2 {
				item.MyUnionRank = myUnionRnak
			}
		}
		ret[weekday] = item
	}

	return ret
}

func (u *UnionFight) getTop8VSInfo() map[document.Integer]*scheme.UnionFightTop8VSUnionInfo {
	return u.Top8VSInfo()
}

func (u *UnionFight) syncModel() SyncModel {
	return SyncModel{
		Round: u.Round(),
	}
}

func (u *UnionFight) eventToGame(event string, data EventToGame, sync bool) *game.UnionFightEventResponse {
	if u.game == nil { // maybe in test model
		return nil
	}
	var model SyncModel
	if sync {
		model = u.syncModel()
	}
	resp, err := service.Call(u.game, "UnionFightEvent", event, data, model)
	if err != nil {
		log.Warningf("UnionFightEvent %s response error %v", event, err)
		return nil
	}
	return resp.(*game.UnionFightEventResponse)
}

func (u *UnionFight) SetRound(v string) {
	u.UnionFightGlobalObject.SetRound(v)
	u.SetTime(util.Now().Unix())
}

func (u *UnionFight) getElapsedDuration() time.Duration {
	return time.Duration(util.Now().Unix()-u.Time()) * time.Second
}

func (u *UnionFight) onPlayStart(round string, matchs [][2]document.ID, playMap *sync.Map, top83v3Round int) {
	for _, item := range matchs {
		if item[0] == "" && item[1] == "" {
			log.Warningf("match error round %s match %s", round, item)
			continue
		}

		roleID1 := item[0]
		roleID2 := item[1]

		var record1, record2 *RoleRecord
		if roleID1 != "" {
			record1 = u.getRecordByRoleID(roleID1)
		}
		if roleID2 != "" {
			record2 = u.getRecordByRoleID(roleID2)
		}

		// 构建战斗 model
		model := u.createPlayModel(round, record1, record2, top83v3Round)
		play := u.builder.CreateUnionFightPlayRecord(model)

		if roleID1 == "" || roleID2 == "" {
			byeResult := anti_cheat.UnionFightBattleResult{}
			playMap.Store(play.GetID(), play)
			if roleID1 != "" {
				byeResult.Result = "win"
				byeResult.States = play.CardStates()
			}
			if roleID2 != "" {
				byeResult.Result = "fail"
				byeResult.States = play.DefenceCardStates()
			}
			u.onPlayResult(manager.Result{
				ID:     play.GetID(),
				Result: byeResult,
			}, playMap)
		} else {
			u.mgr.SendPlay(play.GetID(), play)
			playMap.Store(play.GetID(), play)
		}
	}
}

func (u *UnionFight) onPlayResultCheck(playMap *sync.Map, d time.Duration) {
	t := time.NewTicker(d)
	checkNum := 0
	for {
		<-t.C
		checkNum++

		results := u.mgr.GetPlayResults()
		for _, result := range results {
			u.onPlayResult(result, playMap)
		}

		leftNum := 0
		playMap.Range(func(key, value interface{}) bool {
			leftNum++
			return true
		})
		log.Infof("UnionFight.onPlayResultCheck num %d left %d", checkNum, leftNum)
		if leftNum == 0 {
			break
		}
	}
	t.Stop()
}

func (u *UnionFight) getNextRoundBattleTime() float64 {
	if u.weekday != 6 && u.Round() == "battle" {
		return 0
	}
	return u.nextRoundBattleTime
}

func (u *UnionFight) getNextRoundPrepareTime() float64 {
	if u.weekday != 6 && u.Round() == "battle" {
		return 0
	}
	return u.nextRoundPrepareTime
}

func (u *UnionFight) BetUnion(roleID, target document.ID, gold int) (map[document.ID]scheme.UnionFightBet, error) {
	u.Lock()
	defer u.Unlock()

	bet := u.Bet()
	info, ok := bet[target]
	if !ok {
		return nil, errors.New("union fight bet no such union")
	}
	info.Gold[roleID] = gold
	u.betsum += gold

	cfg := GetConfig()
	betsum := 0
	for _, b := range bet {
		goldSum := 0
		for _, bet := range b.Gold {
			goldSum += bet
		}
		betsum += goldSum
		if goldSum > 0 {
			rate := float64(u.betsum) * cfg.BetRateFix / float64(goldSum)
			if rate < cfg.MinBetRate {
				rate = cfg.MinBetRate
			}
			b.Rate = rate
		} else {
			b.Rate = cfg.MinBetRate
		}
	}
	u.betsum = betsum
	u.SetBet(bet)
	return u.getBetInfo(), nil
}

func (u *UnionFight) getBetInfo() map[document.ID]scheme.UnionFightBet {
	v := make(map[document.ID]scheme.UnionFightBet)
	for _, d := range u.Bet() {
		v[d.Union.UnionID] = scheme.UnionFightBet{
			Union: d.Union,
			Rank:  d.Rank,
			Rate:  d.Rate,
			Point: d.Point,
		}
	}
	return v

}

func (u *UnionFight) GetBetInfo() map[document.ID]scheme.UnionFightBet {
	u.RLock()
	defer u.RUnlock()
	return u.getBetInfo()
}

func (u *UnionFight) getPrepareEndTime() float64 {
	if u.Round() != "prepare" {
		return 0
	}

	return u.prepareEndTime
}

func (u *UnionFight) SetBattleTop8Star(unionID document.ID, nature int, attr int, effectType int) error {
	if _, ok := BattleStarAttr[attr]; !ok {
		return errors.New(fmt.Sprintf("attr error %s", attr))
	}

	unionRecord := u.builder.GetUnionFightUnionRecord(unionID)
	var err error
	util.WithGuard(unionRecord, func() {
		battleStarNum := unionRecord.BattleStarNum()
		if battleStarNum < 1 {
			err = errors.New("battle star not enough")
		}
		unionRecord.SetBattleStarNum(battleStarNum - 1)
	})
	if err != nil {
		return err
	}

	u.Lock()
	defer u.Unlock()

	battleStars := u.BattleStars()
	if _, ok := battleStars[document.Integer(nature)]; !ok {
		battleStars[document.Integer(nature)] = make(map[document.Integer]int)
	}

	switch effectType {
	case 1:
		battleStars[document.Integer(nature)][document.Integer(attr)] += BattleStarEffectNum
	case -1:
		battleStars[document.Integer(nature)][document.Integer(attr)] -= BattleStarEffectNum
	default:
		return errors.New(fmt.Sprintf("effect type %d error", effectType))
	}

	// 清理为零的属性加成
	if battleStars[document.Integer(nature)][document.Integer(attr)] == 0 {
		delete(battleStars[document.Integer(nature)], document.Integer(attr))
	}

	u.SetBattleStars(battleStars)

	return nil
}

// 获取上期战斗记录
func (u *UnionFight) getBattleYesterday(unionID document.ID, round int) YesterdayInfo {
	ret := YesterdayInfo{}

	u.RLock()
	_, ok := u.Unions()[unionID]
	u.RUnlock()
	if !ok {
		return ret
	}

	unionRecord := u.builder.GetUnionFightUnionRecord(unionID)
	unionRecord.RLock()
	defer unionRecord.RUnlock()

	ret.UnionInfo = unionRecord.YesterdayInfo()
	ret.RoundResults = make(map[int][]scheme.UnionFightResultInfo)
	yesterday := unionRecord.YesterdayRoundResults()
	roundMax := len(yesterday)

	if roundMax == 0 {
		return ret
	}
	if round == 0 {
		round = roundMax
	}
	if round > roundMax {
		round = roundMax
	}
	ret.RoundResults[round] = append(ret.RoundResults[round], yesterday[strconv.Itoa(round)]...)
	if len(ret.RoundResults[round]) < 3 && round > 2 {
		ret.RoundResults[round-1] = append(ret.RoundResults[round-1], yesterday[strconv.Itoa(round-1)]...)
	}
	return ret
}

func (u *UnionFight) WeekClose() {
	go func() {
		u.reset()
		u.clean()
		log.Info("UnionFight.weekClose clear finish")
	}()
}

package unionqa

import (
	"sort"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/cross"
	"tjgame/services/game"
)

type UnionQA struct {
	*scheme.CrossUnionQAGlobalObject

	container service.IContainer
	manager   *Manager

	roleRanks  map[int][]scheme.CrossUnionQARoleRankItem
	unionRanks map[int][]scheme.CrossUnionQAUnionRankItem
}

func (qa *UnionQA) dbForGame() *DBForGame {
	db := qa.GetLockedDB()
	return &DBForGame{
		Servers: db.Servers,
		Date:    db.Date,
		Round:   db.Round,
		Group:   db.Group,
		Key:     db.Key,
	}
}

func (qa *UnionQA) isOver() bool {
	if qa.Round() == "start" {
		return false
	}

	date := qa.Date()
	if qa.Round() == "closed" {
		// 第一次开
		if date == 0 {
			return true
		}

		// 过了结束时间点
		duration := closedTime.CombineDateInt(qa.EndDate()).Sub(util.Now())
		if duration <= 0 {
			return true
		}

		return true
	}

	return false
}

func sortServices(services []string) []string {
	tmp := make([]int, 0, len(services))
	var serverName, serverChannel string
	for _, v := range services {
		name, channel, num := service.SplitServiceName(v)
		tmp = append(tmp, num)
		serverName = name
		serverChannel = channel
	}
	sort.Ints(tmp)
	ret := make([]string, 0, len(services))
	for _, v := range tmp {
		ret = append(ret, service.MakeServiceName(serverName, serverChannel, v))
	}

	return ret
}

func (qa *UnionQA) onInit(id int, games []string) {

	util.WithGuard(qa, func() {
		qa.SetRoles(make(map[document.ID]*scheme.CrossUnionQARoleItem))
		qa.SetUnions(make(map[document.ID]*scheme.CrossUnionQAUnionItem))
		qa.SetRoleRanks(make(map[document.Integer][]scheme.CrossUnionQARoleRankItem))
		qa.SetUnionRanks(make(map[document.Integer][]scheme.CrossUnionQAUnionRankItem))

		// 清除缓存
		qa.roleRanks = make(map[int][]scheme.CrossUnionQARoleRankItem)
		qa.unionRanks = make(map[int][]scheme.CrossUnionQAUnionRankItem)
		log.Infof("CrossUnionQA key %v group %v servers %v last data clear", qa.Key(), qa.Group(), qa.Servers())

		ndt := util.Todayinclock5date2int()
		qa.SetDate(ndt)
		cfg := csv.GetConfig().Cross.Service[id]
		qa.SetEndDate(cfg.EndDate)
		games := sortServices(games)
		qa.SetServers(games)
		qa.SetClosedServers(make(map[string]float64))
		qa.SetRound("start")
	})

	qa.eventToGame("start", eventToGame{}, false)

	duration := closedTime.CombineDateInt(qa.EndDate()).Sub(util.Now())
	log.Infof("CrossUnionQA key %v group %v Start next closed delta %s", qa.Key(), qa.Group(), duration)
	time.AfterFunc(duration, qa.onClosed)
}

func (qa *UnionQA) onClosed() {
	var round string
	util.WithGuard(qa, func() {
		round = qa.Round()
	})

	if round == "closed" {
		log.Infof("CrossUnionQA key %v group %v has closed", qa.Key(), qa.Group())
		return
	}

	util.WithGuard(qa, func() {
		qa.SetRound("closed")
	})
	qa.eventToGame("closed", eventToGame{Model: &DBForGame{Key: qa.Key()}}, false)
	log.Infof("CrossUnionQA key %v group %v servers %v closed", qa.Key(), qa.Group(), qa.Servers())

	roleRanks := make(map[string][]scheme.CrossUnionQARoleRankItem)
	if _, ok := qa.roleRanks[totalRankNum]; ok {
		for _, info := range qa.roleRanks[totalRankNum] {
			if _, ok := roleRanks[info.GameKey]; !ok {
				roleRanks[info.GameKey] = []scheme.CrossUnionQARoleRankItem{}
			}
			roleRanks[info.GameKey] = append(roleRanks[info.GameKey], info)
		}
	}
	unionRanks := make(map[string][]scheme.CrossUnionQAUnionRankItem)
	if _, ok := qa.unionRanks[totalRankNum]; ok {
		for _, info := range qa.unionRanks[totalRankNum] {
			if _, ok := unionRanks[info.GameKey]; !ok {
				unionRanks[info.GameKey] = []scheme.CrossUnionQAUnionRankItem{}
			}
			unionRanks[info.GameKey] = append(unionRanks[info.GameKey], info)
		}
	}

	// 排名奖励
	rankAward := make(map[string]*eventToGame)
	for _, servKey := range qa.Servers() {
		rankAward[servKey] = &eventToGame{}
		if _, ok := unionRanks[servKey]; ok {
			rankAward[servKey].UnionRanks = unionRanks[servKey]
		}

		if _, ok := roleRanks[servKey]; ok {
			rankAward[servKey].RoleRanks = roleRanks[servKey]
		}
	}

	dd := make(map[string]interface{})
	for k, v := range rankAward {
		dd[k] = v
	}
	qa.eventToSomeGame("rank_award", dd, false)
}

func (qa *UnionQA) resetToday() {
	if qa.Round() == "closed" {
		return
	}

	if util.Todaydate2int() > qa.EndDate() {
		qa.onClosed()
	} else {
		now := util.Now()
		duration := closedTime.CombineDateInt(qa.EndDate()).Sub(now)
		log.Infof("CrossUnionQA key %v group %v Start next closed delta %v", qa.Key(), qa.Group(), duration)
		time.AfterFunc(duration, qa.onClosed)
	}
}

func (qa *UnionQA) init(container service.IContainer, manager *Manager) {
	qa.Lock()
	defer qa.Unlock()

	qa.container = container
	qa.manager = manager
	for _, weekday := range rankNums {
		qa.resortRoleRank(weekday)
		qa.resortUnionRank(weekday)
	}
}

func (qa *UnionQA) isServerOK(key string) bool {
	db := qa.GetLockedDB()
	if csv.GetMergeConfig().IsMergeKeyInServers(key, db.Servers) {
		return true
	}
	return false
}

func (qa *UnionQA) updateRole(data ReqCrossUnionQA) {
	db, unlock := qa.LockAndGetDB()
	defer unlock()

	if db.Round == "closed" {
		log.Warningf("UnionQA round closed can updateRole role %v", data.Role)
		return
	}

	// Role
	role := data.Role
	if _, ok := db.Roles[role.RoleID]; !ok {
		db.Roles[role.RoleID] = &scheme.CrossUnionQARoleItem{
			CrossUnionQARoleInfo: role,
			Score:                make(map[document.Integer]int),
		}
	}
	db.Roles[role.RoleID].Name = role.Name
	db.Roles[role.RoleID].Logo = role.Logo
	db.Roles[role.RoleID].Frame = role.Frame
	db.Roles[role.RoleID].Level = role.Level
	db.Roles[role.RoleID].UnionName = role.UnionName
	db.Roles[role.RoleID].Score[document.Integer(data.WeekDay)] = data.Score
	totalScore := 0
	for _, score := range db.Roles[role.RoleID].Score {
		totalScore += score
	}
	db.Roles[role.RoleID].TotalScore = totalScore
	db.Roles[role.RoleID].LastTime = util.NowTime()

	qa.SetRoles(db.Roles)

	// Union
	union := data.Union
	if _, ok := db.Unions[union.ID]; !ok {
		db.Unions[union.ID] = &scheme.CrossUnionQAUnionItem{
			CrossUnionQAUnionInfo: union,
			Score:                 make(map[document.Integer]int),
			Roles:                 make(map[document.Integer]map[document.ID]int),
			TotalScore:            0,
		}
	}

	if _, ok := db.Unions[union.ID].Roles[document.Integer(data.WeekDay)]; !ok {
		db.Unions[union.ID].Roles[document.Integer(data.WeekDay)] = map[document.ID]int{}
	}

	db.Unions[union.ID].Roles[document.Integer(data.WeekDay)][role.RoleID] = data.Score
	// 当日公会总成绩
	unionScore := 0
	for _, score := range db.Unions[union.ID].Roles[document.Integer(data.WeekDay)] {
		unionScore += score
	}
	db.Unions[union.ID].Score[document.Integer(data.WeekDay)] = unionScore

	// 当周公会总成绩
	totalUnionScore := 0
	for _, score := range db.Unions[union.ID].Score {
		totalUnionScore += score
	}
	db.Unions[union.ID].TotalScore = totalUnionScore
	db.Unions[union.ID].ChairMan = union.ChairMan
	db.Unions[union.ID].LastTime = util.NowTime()

	qa.SetUnions(db.Unions)

	weekdays := []int{data.WeekDay, totalRankNum}
	for _, num := range weekdays {
		qa.resortRoleRank(num)
		qa.resortUnionRank(num)
	}
}

func (qa *UnionQA) resortUnionRank(weekday int) {
	db := qa.GetLockedDB()

	if weekday == 0 {
		qa.SetUnionRanks(map[document.Integer][]scheme.CrossUnionQAUnionRankItem{})
		qa.unionRanks = map[int][]scheme.CrossUnionQAUnionRankItem{}
	}

	ranks := &ranks{
		items: make([]rankItem, 0, len(db.Unions)),
	}
	for unionID, union := range db.Unions {
		score := union.Score[document.Integer(weekday)]
		if weekday == totalRankNum {
			score = union.TotalScore
		}
		if score == 0 {
			continue
		}
		ranks.items = append(ranks.items, rankItem{
			id: unionID,
			items: map[string]int{
				"score":     score,
				"last_time": int(union.LastTime),
			},
		})
	}
	ranks.keys = [][]string{{"score", "desc"}, {"last_time", "asc"}}
	sort.Sort(ranks)
	newUnionRanks := make([]scheme.CrossUnionQAUnionRankItem, 0, len(db.Unions))
	for idx, item := range ranks.items {
		rank := idx + 1
		if db.Unions[item.id].RankRecord == nil {
			db.Unions[item.id].RankRecord = make(map[document.Integer]scheme.CrossUnionQAMyRankItem)
		}
		db.Unions[item.id].RankRecord[document.Integer(weekday)] = scheme.CrossUnionQAMyRankItem{
			Rank:  rank,
			Score: item.items["score"],
			Name:  db.Unions[item.id].Name,
		}
		newUnionRanks = append(newUnionRanks, scheme.CrossUnionQAUnionRankItem{
			CrossUnionQAUnionInfo: db.Unions[item.id].CrossUnionQAUnionInfo,
			Rank:                  rank,
			Score:                 item.items["score"],
		})
	}
	qa.SetUnions(db.Unions)

	unionRanks := qa.UnionRanks()
	unionRanks[document.Integer(weekday)] = newUnionRanks
	qa.SetUnionRanks(unionRanks)

	if _, ok := qa.unionRanks[weekday]; !ok {
		qa.unionRanks = make(map[int][]scheme.CrossUnionQAUnionRankItem)
	}
	qa.unionRanks[weekday] = newUnionRanks
}

func (qa *UnionQA) resortRoleRank(weekday int) {
	db := qa.GetLockedDB()

	if weekday == 0 {
		qa.SetRoleRanks(map[document.Integer][]scheme.CrossUnionQARoleRankItem{})
		qa.roleRanks = map[int][]scheme.CrossUnionQARoleRankItem{}
	}

	// 玩家排名
	ranks := &ranks{
		items: make([]rankItem, 0, len(db.Roles)),
	}

	for roleID, role := range db.Roles {
		score := role.Score[document.Integer(weekday)]
		if weekday == totalRankNum {
			score = role.TotalScore
		}
		if score == 0 {
			continue
		}
		ranks.items = append(ranks.items, rankItem{
			id: roleID,
			items: map[string]int{
				"score":     score,
				"last_time": int(role.LastTime),
			},
		})
	}

	ranks.keys = [][]string{{"score", "desc"}, {"last_time", "asc"}}
	sort.Sort(ranks)
	newRoleRanks := make([]scheme.CrossUnionQARoleRankItem, 0, len(db.Roles))
	for idx, item := range ranks.items {
		rank := idx + 1
		if db.Roles[item.id].RankRecord == nil {
			db.Roles[item.id].RankRecord = make(map[document.Integer]scheme.CrossUnionQAMyRankItem)
		}
		db.Roles[item.id].RankRecord[document.Integer(weekday)] = scheme.CrossUnionQAMyRankItem{
			Rank:  rank,
			Score: item.items["score"],
			Name:  db.Roles[item.id].UnionName,
		}

		newRoleRanks = append(newRoleRanks, scheme.CrossUnionQARoleRankItem{
			CrossUnionQARoleInfo: db.Roles[item.id].CrossUnionQARoleInfo,
			Rank:                 rank,
			Score:                item.items["score"],
		})
	}
	qa.SetRoles(db.Roles)

	roleRanks := qa.RoleRanks()
	roleRanks[document.Integer(weekday)] = newRoleRanks
	qa.SetRoleRanks(roleRanks)

	if _, ok := qa.roleRanks[weekday]; !ok {
		qa.roleRanks = make(map[int][]scheme.CrossUnionQARoleRankItem)
	}
	qa.roleRanks[weekday] = newRoleRanks
}

func (qa *UnionQA) getRankInfo(roleID, unionID document.ID) map[int]RespCrossUnionQARankInfo {
	db, unlock := qa.LockAndGetDB()
	defer unlock()

	ret := map[int]RespCrossUnionQARankInfo{}

	for _, weekDay := range rankNums {
		item := RespCrossUnionQARankInfo{}
		if roleRanks, ok := db.RoleRanks[document.Integer(weekDay)]; ok {
			item.RoleRanks = roleRanks
		}
		if unionRanks, ok := db.UnionRanks[document.Integer(weekDay)]; ok {
			item.UnionRanks = unionRanks
		}

		if role, ok1 := db.Roles[roleID]; ok1 {
			if myRank, ok2 := role.RankRecord[document.Integer(weekDay)]; ok2 {
				item.MyRank = myRank
			}
		}

		if union, ok1 := db.Unions[unionID]; ok1 {
			if myRank, ok2 := union.RankRecord[document.Integer(weekDay)]; ok2 {
				item.MyUnionRank = myRank
			}
		}
		ret[weekDay] = item
	}
	return ret
}

func (qa *UnionQA) getTop10(roleID, unionID document.ID) RespCrossUnionQARankInfo {
	qa.Lock()
	defer qa.Unlock()

	ret := RespCrossUnionQARankInfo{
		RoleRanks:  []scheme.CrossUnionQARoleRankItem{},
		UnionRanks: []scheme.CrossUnionQAUnionRankItem{},
	}

	if totalRoleRanks, ok := qa.roleRanks[totalRankNum]; ok {
		if len(totalRoleRanks) <= 10 {
			ret.RoleRanks = totalRoleRanks
		} else {
			ret.RoleRanks = totalRoleRanks[:10]
		}
	}

	if totalUnionRanks, ok := qa.unionRanks[totalRankNum]; ok {
		if len(totalUnionRanks) < 10 {
			ret.UnionRanks = totalUnionRanks
		} else {
			ret.UnionRanks = totalUnionRanks[:10]
		}
	}

	if role, ok1 := qa.Roles()[roleID]; ok1 {
		if myRank, ok2 := role.RankRecord[document.Integer(totalRankNum)]; ok2 {
			ret.MyRank = myRank
		}
	}

	if union, ok1 := qa.Unions()[unionID]; ok1 {
		if myRank, ok2 := union.RankRecord[document.Integer(totalRankNum)]; ok2 {
			ret.MyUnionRank = myRank
		}
	}
	return ret
}

func (qa *UnionQA) unionDissolve(unionID document.ID) bool {
	db, unlock := qa.LockAndGetDB()
	defer unlock()

	delete(db.Unions, unionID)
	qa.SetUnions(db.Unions)
	for _, weekday := range rankNums {
		qa.resortUnionRank(weekday)
	}
	return true
}

func (qa *UnionQA) syncModel() *syncModel {
	return &syncModel{
		Round: qa.Round(),
	}
}

func (qa *UnionQA) eventToGame(event string, data eventToGame, sync bool) map[string]*game.CrossUnionQAEventResponse {
	var model *syncModel
	if sync {
		model = qa.syncModel()
	}

	servers := qa.Servers()
	keys := make([]string, 0, len(servers))
	futures := make([]*service.Future, 0, len(servers))
	for _, key := range servers {
		keys = append(keys, key)
		s := qa.container.GetService(key)
		future := service.CallAsync(s, "CrossUnionQAEvent", event, key, data, model)
		futures = append(futures, future)
	}

	ret := make(map[string]*game.CrossUnionQAEventResponse)
	resp, err := service.MultiFuture(futures, false).Get()
	if err != nil {
		log.Warningf("CrossUnionQAEvent %s response error %v", event, err)
		return nil
	}
	response := resp.([]interface{})
	for i, key := range keys {
		ret[key] = response[i].(*game.CrossUnionQAEventResponse)
	}
	return ret
}

func (qa *UnionQA) eventToSomeGame(event string, d map[string]interface{}, sync bool) map[string]*game.CrossUnionQAEventResponse {
	var model *syncModel
	if sync {
		model = qa.syncModel()
	}
	response := make(map[string]*game.CrossUnionQAEventResponse)
	err := cross.EventToSomeGame(qa.container, "CrossUnionQAEvent", event, d, model, func(key string, i interface{}) {
		response[key] = i.(*game.CrossUnionQAEventResponse)
	})
	if err != nil {
		log.Warningf("CrossUnionQAEvent %s response error %v", event, err)
		return nil
	}
	return response
}

func (qa *UnionQA) onGameClosed(gameKey string) {
	qa.Lock()
	servers := qa.Servers()
	closedServers := qa.ClosedServers()
	closedServers[gameKey] = util.NowTime()
	qa.SetClosedServers(closedServers)

	closedAll := true
	notClosed := []string{}
	for _, serverKey := range servers {
		if _, ok := closedServers[serverKey]; !ok {
			closedAll = false
			notClosed = append(notClosed, serverKey)
		}
	}
	qa.Unlock()

	if closedAll {
		go qa.onClosed()
	} else {
		log.Infof("CrossUnionQA not closed servers %v", notClosed)
	}
}

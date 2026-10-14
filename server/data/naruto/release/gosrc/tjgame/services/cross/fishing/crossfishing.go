package fishing

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

type Fishing struct {
	*scheme.CrossFishingGlobalObject

	container service.IContainer
	manager   *Manager

	ranks []scheme.CrossFishingRoleItem

	timer *time.Timer
}

func (f *Fishing) dbForGame() *DBForGame {
	db := f.GetLockedDB()
	return &DBForGame{
		Servers: db.Servers,
		Date:    db.Date,
		Round:   db.Round,
		Group:   db.Group,
	}
}

func (f *Fishing) isOver() bool {
	if f.Round() == "start" {
		return false
	}

	date := f.Date()
	nowDate := util.Todayinclock5date2int()
	if f.Round() == "closed" {
		// 第一次开
		if date == 0 {
			return true
		}

		//当天结束了，不在开启
		if date == nowDate {
			return false
		}

		// 过了结束时间点
		duration := closedTime.CombineDateInt(util.Todayinclock5date2int()).Sub(util.Now())
		if duration <= 0 {
			return false
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

func (f *Fishing) onInit(games []string) {
	var model *DBForGame

	util.WithGuard(f, func() {
		ndt := util.Todayinclock5date2int()
		f.SetDate(ndt)
		games := sortServices(games)
		f.SetServers(games)
		f.SetClosedServers(make(map[string]float64))
		f.SetRound("start")
		model = f.dbForGame()
	})

	f.eventToGame("start", eventToGame{Model: model}, false, false)

	duration := closedTime.CombineDateInt(f.Date()).Sub(util.Now())
	log.Infof("CrossFishing key %v group %v Start next closed delta %s", f.Key(), f.Group(), duration)
	f.timer = time.AfterFunc(duration, f.onNotifyClosed)
}

func (f *Fishing) onNotifyClosed() {
	f.eventToGame("closed", eventToGame{}, false, false)
}

func (f *Fishing) onClosed() {
	var round string
	util.WithGuard(f, func() {
		round = f.Round()
	})

	if round == "closed" {
		log.Infof("CrossFishing key %v group %v has closed", f.Key(), f.Group())
		return
	}

	util.WithGuard(f, func() {
		f.SetRound("closed")
	})

	f.eventToGame("save_rank", eventToGame{
		Servers:  f.Servers(),
		AllRanks: f.ranks,
	}, false, false)

	// 排名奖励
	rankAward := make(map[string]*eventToGame)
	for _, info := range f.ranks {
		if _, ok := rankAward[info.GameKey]; !ok {
			rankAward[info.GameKey] = &eventToGame{
				AllRanks: []scheme.CrossFishingRoleItem{},
			}
		}
		rankAward[info.GameKey].AllRanks = append(rankAward[info.GameKey].AllRanks, info)
	}
	dd := make(map[string]interface{})
	for k, v := range rankAward {
		dd[k] = v
	}
	f.eventToSomeGame("rank_award", dd, false)

	util.WithGuard(f, func() {
		f.SetRoles(make(map[document.ID]*scheme.CrossFishingRoleItem))
		f.resortRank()

		f.manager.clearGameToPlay(f.Servers())

		log.Infof("CrossFishing key %v group %v servers %v closed", f.Key(), f.Group(), f.Servers())
	})
}

func (f *Fishing) resetToday() {
	if f.Round() == "closed" {
		return
	}
	now := util.Now()
	duration := closedTime.Combine(now).Sub(now)
	if duration < 0 {
		duration = closedTime.Combine(now.Add(util.OneDay)).Sub(now)
	}
	log.Infof("CrossFishing key %v group %v Start next closed delta %v", f.Key(), f.Group(), duration)
	f.timer = time.AfterFunc(duration, f.onNotifyClosed)
}

func (c *Fishing) isServerOK(key string) bool {
	db := c.GetLockedDB()
	if csv.GetMergeConfig().IsMergeKeyInServers(key, db.Servers) {
		return true
	}
	return false
}

func (f *Fishing) init(container service.IContainer, manager *Manager) {
	f.Lock()
	defer f.Unlock()

	f.container = container
	f.manager = manager
	f.resortRank()
}

func (f *Fishing) reset(servers []string) {
	f.Lock()
	defer f.Unlock()

	f.SetDate(util.Todaydate2int())
	f.SetServers(servers)
	f.SetRoles(make(map[document.ID]*scheme.CrossFishingRoleItem))
	f.resortRank()
}

func (f *Fishing) updateRoles(roles []ReqCrossFishingRole) {
	db, unlock := f.LockAndGetDB()
	defer unlock()

	if db.Round == "closed" {
		log.Warningf("Fishing round closed can updateRole roles %v", roles)
		return
	}

	for _, role := range roles {
		if _, ok := db.Roles[role.RoleID]; !ok {
			db.Roles[role.RoleID] = &scheme.CrossFishingRoleItem{
				CrossFishingRoleInfo: scheme.CrossFishingRoleInfo{
					RoleID:  role.RoleID,
					GameKey: role.GameKey,
				},
			}
		}
		db.Roles[role.RoleID].Name = role.Name
		db.Roles[role.RoleID].Logo = role.Logo
		db.Roles[role.RoleID].Frame = role.Frame
		db.Roles[role.RoleID].Level = role.Level
		db.Roles[role.RoleID].Point = role.Point
		db.Roles[role.RoleID].SpecialFishNum = role.SpecialFishNum
		db.Roles[role.RoleID].LastTime = util.NowTime()
	}

	f.SetRoles(db.Roles)

	f.resortRank()
}

func (f *Fishing) resortRank() {
	db := f.GetLockedDB()
	ranks := &ranks{
		items: make([]rankItem, 0, len(db.Roles)),
	}
	for roleID, role := range db.Roles {
		ranks.items = append(ranks.items, rankItem{
			id: roleID,
			items: map[string]int{
				"point":            role.Point,
				"special_fish_num": role.SpecialFishNum,
				"last_time":        int(role.LastTime),
			},
		})
	}
	ranks.keys = [][]string{{"point", "desc"}, {"special_fish_num", "desc"}, {"last_time", "asc"}}
	sort.Sort(ranks)
	newRank := make([]scheme.CrossFishingRoleItem, 0, len(db.Roles))
	for idx, item := range ranks.items {
		rank := idx + 1
		db.Roles[item.id].Rank = rank
		newRank = append(newRank, *db.Roles[item.id])

	}
	f.SetRoles(db.Roles)
	f.ranks = newRank
}

func (f *Fishing) getRankInfo(roleID document.ID) RespCrossFishingRankInfo {
	db, unlock := f.LockAndGetDB()
	defer unlock()

	ret := RespCrossFishingRankInfo{
		Ranks: make([]scheme.CrossFishingRoleItem, 0, CrossFishingRankSize),
	}

	if role, ok := db.Roles[roleID]; ok {
		ret.Rank = role.Rank
		ret.Point = role.Point
		ret.SpecialFishNum = role.SpecialFishNum
	}

	if len(f.ranks) <= CrossFishingRankSize {
		ret.Ranks = f.ranks
	} else {
		ret.Ranks = f.ranks[:CrossFishingRankSize]
	}

	return ret
}

func (f *Fishing) getTop3() []scheme.CrossFishingRoleItem {
	f.Lock()
	defer f.Unlock()

	ret := make([]scheme.CrossFishingRoleItem, 0, CrossFishingRankTop3Size)
	if len(f.ranks) <= CrossFishingRankTop3Size {
		ret = f.ranks
	} else {
		ret = f.ranks[:CrossFishingRankTop3Size]
	}
	return ret
}

func (f *Fishing) syncModel() *syncModel {
	return &syncModel{
		Round: f.Round(),
	}
}

func (f *Fishing) eventToGame(event string, data eventToGame, sync bool, mergeFilter bool) map[string]*game.CrossFishingEventResponse {
	var model *syncModel
	if sync {
		model = f.syncModel()
	}

	servers := f.Servers()
	if mergeFilter {
		servers = csv.GetMergeConfig().FilterMergeServer(servers)
	}

	keys := make([]string, 0, len(servers))
	futures := make([]*service.Future, 0, len(servers))
	for _, key := range servers {
		keys = append(keys, key)
		s := f.container.GetService(key)
		future := service.CallAsync(s, "CrossFishingEvent", event, key, data, model)
		futures = append(futures, future)
	}

	ret := make(map[string]*game.CrossFishingEventResponse)
	resp, err := service.MultiFuture(futures, false).Get()
	if err != nil {
		log.Warningf("CrossFishingEvent %s response error %v", event, err)
		return nil
	}
	response := resp.([]interface{})
	for i, key := range keys {
		ret[key] = response[i].(*game.CrossFishingEventResponse)
	}
	return ret
}

func (f *Fishing) eventToSomeGame(event string, d map[string]interface{}, sync bool) map[string]*game.CrossFishingEventResponse {
	var model *syncModel
	if sync {
		model = f.syncModel()
	}
	response := make(map[string]*game.CrossFishingEventResponse)
	err := cross.EventToSomeGame(f.container, "CrossFishingEvent", event, d, model, func(key string, i interface{}) {
		response[key] = i.(*game.CrossFishingEventResponse)
	})
	if err != nil {
		log.Warningf("CrossFishingEvent %s response error %v", event, err)
		return nil
	}
	return response
}

func (f *Fishing) onGameClosed(gameKey string) {
	f.Lock()
	servers := f.Servers()
	closedServers := f.ClosedServers()
	closedServers[gameKey] = util.NowTime()
	f.SetClosedServers(closedServers)

	closedAll := true
	notClosed := []string{}
	for _, serverKey := range servers {
		if _, ok := closedServers[serverKey]; !ok {
			closedAll = false
			notClosed = append(notClosed, serverKey)
		}
	}
	f.Unlock()

	if closedAll {
		go f.onClosed()
	} else {
		log.Infof("CrossFishing not closed servers %v", notClosed)
	}
}

//func (f *Fishing) gmAddGames(games []string) error {
//	db, unlock := f.LockAndGetDB()
//	channel := strings.Split(db.Key, ".")[1]
//
//	check := make(map[string]bool, len(db.Servers))
//	newServers := make([]string, 0, len(db.Servers)+len(games))
//	for _, server := range db.Servers {
//		check[server] = true
//		newServers = append(newServers, server)
//	}
//
//	for _, gameKey := range games {
//		if _, ok := check[gameKey]; ok {
//			continue
//		}
//		gameChannel := strings.Split(gameKey, ">")[1]
//		if gameChannel != channel {
//			return errors.New(fmt.Sprint("game %v chaneel %v error", gameKey, channel))
//		}
//		newServers = append(newServers, gameKey)
//	}
//
//	model := f.dbForGame()
//	sort.Strings(newServers)
//	f.SetServers(newServers)
//	unlock()
//
//	f.eventToGame("start", eventToGame{Model: model}, false)
//
//	return nil
//}

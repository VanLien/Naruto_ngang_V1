package huodongboss

import (
	"sort"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
)

var (
	closedTime = util.Time{Hour: 5}
)

type HuoDongBoss struct {
	*scheme.HuoDongBossGlobalObject

	container service.IContainer
	manager   *Manager
}

func (hd *HuoDongBoss) isOver() bool {
	if hd.Status() == "start" {
		return false
	}
	return true
}

func (hd *HuoDongBoss) onInit(id int, games []string) {

	util.WithGuard(hd, func() {
		// 活动结束时间
		cfg := csv.GetConfig().Cross.Service[id]
		hd.SetEndDate(cfg.EndDate)
		hd.SetServers(games)
		hd.SetStatus("start")
	})

	//hd.eventToGame("start", struct{}{}, false)

	now := util.Now()
	duration := closedTime.Combine(now.Add(util.OneDay)).Sub(now)
	log.Infof("HuoDongBoss key %v group %v boss data reset delta %s", hd.Key(), hd.Group(), duration)
	time.AfterFunc(duration, hd.reset)
}

func (hd *HuoDongBoss) onNotifyClosed() {
	hd.eventToGame("closed", struct{}{}, false)
}

func (hd *HuoDongBoss) onClosed() {
	var status string
	util.WithGuard(hd, func() {
		status = hd.Status()
	})

	if status == "closed" {
		log.Infof("HuoDongBoss key %v group %v has closed", hd.Key(), hd.Group())
		return
	}

	util.WithGuard(hd, func() {
		hd.SetStatus("closed")
	})

	util.WithGuard(hd, func() {

		hd.manager.clearGameToPlay(hd.Servers())

		log.Infof("HuoDongBoss key %v group %v servers %v closed", hd.Key(), hd.Group(), hd.Servers())
	})
}

func (hd *HuoDongBoss) resetToday() bool {
	if hd.Status() == "closed" {
		return false
	}

	// 结束日期关闭活动
	if util.Todayinclock5date2int() >= hd.EndDate() {
		hd.SetBoss(map[string]scheme.HuoDongBossInfo{})
		hd.onClosed()
		return false
	}

	now := util.Now()
	duration := closedTime.Combine(now).Sub(now)
	if duration < 0 {
		duration = closedTime.Combine(now.Add(util.OneDay)).Sub(now)
	}
	log.Infof("HuoDongBoss key %v group %v Start next reset delta %v", hd.Key(), hd.Group(), duration)
	time.AfterFunc(duration, hd.reset)
	return true
}

func (hd *HuoDongBoss) init(container service.IContainer, manager *Manager) {
	hd.Lock()
	defer hd.Unlock()

	hd.container = container
	hd.manager = manager
}

func (hd *HuoDongBoss) reset() {
	hd.Lock()
	defer hd.Unlock()

	if hd.Status() == "closed" {
		return
	}

	hd.SetBoss(map[string]scheme.HuoDongBossInfo{})

	// 结束日期关闭活动
	if util.Todayinclock5date2int() == hd.EndDate() {
		hd.onNotifyClosed()
		hd.onClosed()
		return
	}

	now := util.Now()
	duration := closedTime.Combine(now).Sub(now)
	if duration < 0 {
		duration = closedTime.Combine(now.Add(util.OneDay)).Sub(now)
	}
	log.Infof("HuoDongBoss key %v group %v boss data clear %v", hd.Key(), hd.Group(), duration)
	time.AfterFunc(duration, hd.reset)
}

func (hd *HuoDongBoss) isServerOK(key string) bool {
	db := hd.GetLockedDB()
	if csv.GetMergeConfig().IsMergeKeyInServers(key, db.Servers) {
		return true
	}
	return false
}

func (hd *HuoDongBoss) getHuoDongBossList(roleID document.ID, size int) []scheme.HuoDongBossInfo {
	db, unlock := hd.LockAndGetDB()
	defer unlock()

	ret := make([]scheme.HuoDongBossInfo, 0)
	newBoss := map[string]scheme.HuoDongBossInfo{}
	notBattleList := &bossList{items: make([]bossInfo, 0)} // 未挑战的boss
	battleList := &bossList{items: make([]bossInfo, 0)}    // 已挑战的boss
	for uid, boss := range db.Boss {
		cfg := csv.GetConfig().Yunying.Huodongboss[boss.GateID]
		if boss.StartTime+float64(cfg.TimeLimit*60) <= util.NowTime() {
			continue
		}
		if boss.OwnerWin && len(boss.WinRoles) >= cfg.Times {
			continue
		}
		info := bossInfo{
			uid:       uid,
			startTime: boss.StartTime,
		}

		canBattle := true
		if roleID == boss.Owner.RoleID {
			info.isOwner = 1
			if boss.OwnerWin {
				canBattle = false
			}
		} else {
			info.isOwner = 0
			for _, role := range boss.WinRoles {
				if roleID == role.RoleID {
					canBattle = false
				}
			}
		}
		if canBattle {
			notBattleList.items = append(notBattleList.items, info)
		} else {
			battleList.items = append(battleList.items, info)
		}
		newBoss[uid] = boss
	}
	hd.SetBoss(newBoss)
	sort.Sort(notBattleList)
	sort.Sort(battleList)

	for ind, item := range notBattleList.items {
		if ind < size {
			ret = append(ret, db.Boss[item.uid])
		} else {
			break
		}
	}
	for _, item := range battleList.items {
		ret = append(ret, db.Boss[item.uid])
	}
	return ret
}

func (hd *HuoDongBoss) clearHuoDongBoss() []scheme.HuoDongBossInfo {
	hd.Lock()
	defer hd.Unlock()
	hd.SetBoss(map[string]scheme.HuoDongBossInfo{})

	return []scheme.HuoDongBossInfo{}
}

func (hd *HuoDongBoss) getHuoDongBossInfo(idx string, roleID document.ID) (scheme.HuoDongBossInfo, error) {
	db, unlock := hd.LockAndGetDB()
	defer unlock()

	if boss, ok := db.Boss[idx]; ok {
		cfg := csv.GetConfig().Yunying.Huodongboss[boss.GateID]
		// Boss是否过期
		if boss.StartTime+float64(cfg.TimeLimit*60) <= util.NowTime() {
			log.Warningf("HuoDongBoss %s expired", boss.Uid)
			return scheme.HuoDongBossInfo{}, ErrHuoDongBossExpired
		}

		if roleID == boss.Owner.RoleID {
			if boss.OwnerWin {
				log.Warningf("HuoDongBoss %s challenged", boss.Uid)
				return scheme.HuoDongBossInfo{}, ErrHuoDongBossChallenged
			}
		} else {
			// 挑战次数是否足够
			if cfg.Times <= len(boss.WinRoles) {
				log.Warningf("HuoDongBoss %s challenge times not enough", boss.Uid)
				return scheme.HuoDongBossInfo{}, ErrHuoDongBossNoTimes
			}
			// 是否已挑战
			for _, role := range boss.WinRoles {
				if role.RoleID == roleID {
					log.Warningf("HuoDongBoss %s challenged", boss.Uid)
					return scheme.HuoDongBossInfo{}, ErrHuoDongBossChallenged
				}
			}
		}
		return boss, nil
	} else {
		return scheme.HuoDongBossInfo{}, nil
	}
}

func (hd *HuoDongBoss) addHuoDongBoss(bossInfo scheme.HuoDongBossInfo) (scheme.HuoDongBossInfo, error) {
	db, unlock := hd.LockAndGetDB()
	defer unlock()

	if db.Status == "closed" {
		log.Warningf("HuoDongBoss status closed can not addHuoDongBoss %s", bossInfo.Uid)
		return scheme.HuoDongBossInfo{}, ErrHuoDongBossClosed
	}
	if _, ok := db.Boss[bossInfo.Uid]; !ok {
		db.Boss[bossInfo.Uid] = bossInfo
		hd.SetBoss(db.Boss)
	}
	return db.Boss[bossInfo.Uid], nil
}

func (hd *HuoDongBoss) updateHuoDongBossInfo(idx string, roleInfo scheme.HuoDongBossRoleInfo) (document.ID, error) {
	db, unlock := hd.LockAndGetDB()
	defer unlock()

	if db.Status == "closed" {
		log.Warningf("HuoDongBoss status closed can not updateHuoDongBoss")
		return "", ErrHuoDongBossClosed
	}
	if _, ok := db.Boss[idx]; !ok {
		log.Warningf("HuoDongBoss %s not exist", idx)
		return "", ErrHuoDongBossNotExist
	}
	boss := db.Boss[idx]
	cfg := csv.GetConfig().Yunying.Huodongboss[boss.GateID]
	// Boss是否过期
	if boss.StartTime+float64(cfg.TimeLimit*60) <= util.NowTime() {
		log.Warningf("HuoDongBoss %s expired", boss.Uid)
		return "", ErrHuoDongBossExpired
	}

	if roleInfo.RoleID == boss.Owner.RoleID {
		if boss.OwnerWin {
			log.Warningf("HuoDongBoss %s challenged", boss.Uid)
			return "", ErrHuoDongBossChallenged
		}
		boss.OwnerWin = true
	} else {
		// 挑战次数是否足够
		if cfg.Times <= len(boss.WinRoles) {
			log.Warningf("HuoDongBoss %s challenge times not enough", boss.Uid)
			return "", ErrHuoDongBossNoTimes
		}
		// 是否已挑战
		for _, role := range boss.WinRoles {
			if role.RoleID == roleInfo.RoleID {
				log.Warningf("HuoDongBoss %s challenged", boss.Uid)
				return "", ErrHuoDongBossChallenged
			}
		}
		boss.WinRoles = append(boss.WinRoles, roleInfo)
	}
	db.Boss[idx] = boss
	hd.SetBoss(db.Boss)
	return boss.Owner.RoleID, nil
}

func (hd *HuoDongBoss) eventToGame(event string, data struct{}, sync bool) {
	var model struct{}

	servers := hd.Servers()
	keys := make([]string, 0, len(servers))
	for _, key := range servers {
		keys = append(keys, key)
		s := hd.container.GetService(key)
		service.CallAsync(s, "HuoDongBossEvent", event, key, data, model)
	}
}

type bossInfo struct {
	uid       string
	isOwner   int
	startTime float64
}

type bossList struct {
	items []bossInfo
}

func (b *bossList) Len() int {
	return len(b.items)
}

func (b *bossList) Less(i, j int) bool {
	if b.items[i].isOwner != b.items[j].isOwner {
		return b.items[i].isOwner > b.items[j].isOwner
	}
	if b.items[i].startTime != b.items[j].startTime {
		return b.items[i].startTime > b.items[j].startTime
	}
	return true
}

func (b *bossList) Swap(i, j int) {
	b.items[i], b.items[j] = b.items[j], b.items[i]
}

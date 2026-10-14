package skyscraper

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

type Skyscraper struct {
	*scheme.SkyscraperGlobalObject

	container service.IContainer
	manager   *Manager

	rankingCache   *skyscraperList
	isRankingDirty bool
	roleRankMap    map[document.ID]int
}

func (hd *Skyscraper) isOver() bool {
	if hd.Status() == "start" {
		return false
	}
	return true
}

func (hd *Skyscraper) onInit(id int, games []string) {

	util.WithGuard(hd, func() {
		// 活动结束时间
		cfg := csv.GetConfig().Cross.Service[id]
		hd.SetEndDate(cfg.EndDate)
		hd.SetServers(games)
		hd.SetYYID(id)
		hd.SetStatus("start")

		hd.SetSkyscraper(map[document.ID]*scheme.SkyscraperInfo{})
		hd.isRankingDirty = true
		hd.roleRankMap = make(map[document.ID]int)
	})

	duration := closedTime.CombineDateInt(hd.EndDate()).Sub(util.Now())
	log.Infof("Skyscraper key %v group %v skyscraper data reset delta %s", hd.Key(), hd.Group(), duration)
	time.AfterFunc(duration, hd.onClosed)
}

func (hd *Skyscraper) resetToday() bool {
	if hd.Status() == "closed" {
		return false
	}

	// 结束日期关闭活动
	if util.Todayinclock5date2int() >= hd.EndDate() {
		hd.onClosed()
		return false
	}

	duration := closedTime.CombineDateInt(hd.EndDate()).Sub(util.Now())
	log.Infof("Skyscraper key %v group %v Start next reset delta %v", hd.Key(), hd.Group(), duration)
	time.AfterFunc(duration, hd.onClosed)
	return true
}

func (hd *Skyscraper) init(container service.IContainer, manager *Manager) {
	hd.Lock()
	defer hd.Unlock()

	hd.container = container
	hd.manager = manager
	hd.isRankingDirty = true
	hd.roleRankMap = make(map[document.ID]int)
}

func (hd *Skyscraper) onClosed() {
	hd.Lock()
	defer hd.Unlock()

	if hd.Status() == "closed" {
		log.Infof("Skyscraper key %v group %v has closed", hd.Key(), hd.Group())
		return
	}

	hd.eventToGame("closed")
	hd.SetStatus("closed")
	hd.manager.clearGameToPlay(hd.Servers())
	log.Infof("Skyscraper key %v group %v servers %v closed", hd.Key(), hd.Group(), hd.Servers())
}

func (hd *Skyscraper) getSkyscraperRanking(size int, roleID document.ID) ([]*scheme.SkyscraperInfo, int) {
	db, unlock := hd.LockAndGetDB()
	defer unlock()

	ret := make([]*scheme.SkyscraperInfo, 0) // 所有信息

	if hd.isRankingDirty {
		retList := &skyscraperList{items: make([]skyscraperInfo, 0)} // 排名信息
		for rid, skyscraper := range db.Skyscraper {
			info := skyscraperInfo{
				rid:       rid,
				highScore: skyscraper.HighScore,
				highFloor: skyscraper.HighFloor,
			}
			retList.items = append(retList.items, info)
		}
		sort.Sort(sort.Reverse(retList))
		hd.rankingCache = retList
		hd.isRankingDirty = false
		for rank, item := range hd.rankingCache.items {
			hd.roleRankMap[item.rid] = rank + 1
		}
	}

	for _, item := range hd.rankingCache.items {
		if len(ret) < size {
			ret = append(ret, db.Skyscraper[item.rid])
		}
	}
	rank := hd.roleRankMap[roleID]
	return ret, rank
}

func (hd *Skyscraper) clearSkyscraper() []scheme.SkyscraperInfo {
	hd.Lock()
	defer hd.Unlock()
	hd.SetSkyscraper(map[document.ID]*scheme.SkyscraperInfo{})

	return []scheme.SkyscraperInfo{}
}

func (hd *Skyscraper) sendSkyscraperInfo(skyscraperInfo *scheme.SkyscraperInfo) error {
	db, unlock := hd.LockAndGetDB()
	defer unlock()

	if db.Status == "closed" {
		log.Warningf("Skyscraper status closed can not sendSkyscraperInfo %s", skyscraperInfo.RoleID)
		return ErrSkyscraperClosed
	}

	db.Skyscraper[skyscraperInfo.RoleID] = skyscraperInfo
	hd.SetSkyscraper(db.Skyscraper)
	hd.isRankingDirty = true

	return nil
}

func (hd *Skyscraper) eventToGame(event string) {
	servers := hd.Servers()
	keys := make([]string, 0, len(servers))
	for _, key := range servers {
		keys = append(keys, key)
		s := hd.container.GetService(key)
		service.CallAsync(s, "HuoDongCrossSkyscraperEvent", event, key)
	}
}

type skyscraperInfo struct {
	rid       document.ID
	highScore int
	highFloor int
}

type skyscraperList struct {
	items []skyscraperInfo
}

func (b *skyscraperList) Len() int {
	return len(b.items)
}

func (b *skyscraperList) Less(i, j int) bool {
	if b.items[i].highScore != b.items[j].highScore {
		return b.items[i].highScore < b.items[j].highScore
	} else {
		return b.items[i].highFloor < b.items[j].highFloor
	}
}

func (b *skyscraperList) Swap(i, j int) {
	b.items[i], b.items[j] = b.items[j], b.items[i]
}

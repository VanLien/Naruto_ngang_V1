package ranking

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

type CrossRanking struct {
	*scheme.CrossRankingGlobalObject

	container service.IContainer
	manager   *Manager

	rankingCache   Sortable
	isRankingDirty bool
	roleRankMap    map[document.ID]int
	clearStatus    bool
}

func (r *CrossRanking) isOver() bool {
	if r.Status() == "start" {
		return false
	}
	return true
}

func (r *CrossRanking) onInit(id int, games []string) {

	util.WithGuard(r, func() {
		// 活动结束时间
		cfg := csv.GetConfig().Cross.Service[id]
		r.SetEndDate(cfg.EndDate)
		r.SetGamePlay(cfg.Service)
		r.SetServers(games)
		r.SetYYID(id)
		r.SetStatus("start")

		r.SetRankInfo(map[document.ID]*scheme.RoleRankInfo{})
		r.isRankingDirty = true
		r.roleRankMap = make(map[document.ID]int)
	})

	duration := closedTime.CombineDateInt(r.EndDate()).Sub(util.Now())
	log.Infof("%s key %v group %v %s data reset delta %s", r.GamePlay(), r.Key(), r.Group(), r.GamePlay(), duration)
	time.AfterFunc(duration, r.onClosed)
}

func (r *CrossRanking) resetToday() bool {
	if r.Status() == "closed" {
		return false
	}

	// 结束日期关闭活动
	if util.Todayinclock5date2int() >= r.EndDate() {
		r.onClosed()
		return false
	}

	duration := closedTime.CombineDateInt(r.EndDate()).Sub(util.Now())
	log.Infof("%s key %v group %v Start next reset delta %v", r.GamePlay(), r.Key(), r.Group(), duration)
	time.AfterFunc(duration, r.onClosed)
	return true
}

func (r *CrossRanking) init(container service.IContainer, manager *Manager) {
	r.Lock()
	defer r.Unlock()

	r.container = container
	r.manager = manager
	r.isRankingDirty = true
	r.roleRankMap = make(map[document.ID]int)
}

func (r *CrossRanking) onClosed() {
	r.Lock()
	defer r.Unlock()

	if r.Status() == "closed" {
		log.Infof("%s key %v group %v has closed", r.GamePlay(), r.Key(), r.Group())
		return
	}

	r.eventToGame("closed")
	r.SetStatus("closed")
	r.manager.clearGameToPlay(r.GamePlay(), r.Servers())
	log.Infof("%s key %v group %v servers %v closed", r.GamePlay(), r.Key(), r.Group(), r.Servers())
}

func (r *CrossRanking) sendRankInfo(roleRankInfo *scheme.RoleRankInfo) error {
	db, unlock := r.LockAndGetDB()
	defer unlock()

	if db.Status == "closed" {
		log.Warningf("%s status closed can not sendSkyscraperInfo %s", r.GamePlay(), roleRankInfo.RoleID)
		return ErrRankClosed
	}
	roleRankInfo.Timestamp = util.Now().Unix()
	db.RankInfo[roleRankInfo.RoleID] = roleRankInfo
	r.SetRankInfo(db.RankInfo)
	r.isRankingDirty = true

	return nil
}

func (r *CrossRanking) getRankInfo(gamePlay string, roleID document.ID, size int) ([]*scheme.RoleRankInfo, int) {
	db, unlock := r.LockAndGetDB()
	defer unlock()

	ret := make([]*scheme.RoleRankInfo, 0) // 所有信息
	if r.isRankingDirty {
		var retList Sortable // 排名信息

		if gamePlay == CrossBraveChallengeRanking || gamePlay == CrossNormalBraveChallengeRanking{
			retList = &AscendingRankList{rankList{items: make([]rankCacheInfo, 0)}}
			//} else if gamePlay == CrossHorseRaceRanking {
			//	retList = &DescendingRankList{rankList{items: make([]rankCacheInfo, 0)}}
		} else {
			retList = &DescendingRankList{rankList{items: make([]rankCacheInfo, 0)}}
		}

		for rid, rankInfo := range db.RankInfo {
			info := rankCacheInfo{
				rid:       rid,
				rankData:  rankInfo.RankData,
				timestamp: rankInfo.Timestamp,
			}
			retList.AddItem(info)
		}
		sort.Sort(retList)
		r.rankingCache = retList
		r.isRankingDirty = false
		for rank, item := range r.rankingCache.GetItems() {
			r.roleRankMap[item.rid] = rank + 1
		}
	}

	for _, item := range r.rankingCache.GetItems() {
		if len(ret) < size {
			ret = append(ret, db.RankInfo[item.rid])
		}
	}
	rank := r.roleRankMap[roleID]
	return ret, rank
}

func (r *CrossRanking) clearRankInfo() []scheme.RoleRankInfo {
	r.Lock()
	defer r.Unlock()
	if r.clearStatus {
		return []scheme.RoleRankInfo{}
	}
	r.clearStatus = true
	time.AfterFunc(time.Second*60, func() {
		r.Lock()
		defer r.Unlock()
		r.clearStatus = false
	})

	r.SetRankInfo(map[document.ID]*scheme.RoleRankInfo{})
	r.roleRankMap = map[document.ID]int{}

	return []scheme.RoleRankInfo{}
}

func (r *CrossRanking) eventToGame(event string) {
	servers := r.Servers()
	for _, key := range servers {
		s := r.container.GetService(key)
		service.CallAsync(s, "HuoDongCrossRankingEvent", r.GamePlay(), event, key)
	}
}

package union

import (
	"sort"
	"sync"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/util"

	"tjgame/server_framework/tj/log"
)

func isDayTimeReached(lastdate int, periodHour int, periodMinute int, weekdays []int, force bool) bool {
	t := util.Period2Time(periodHour, periodMinute, util.Now())
	ndi := util.Date2int(t)

	// 相同说明已经重置或者奖励过了
	if ndi == lastdate {
		return false
	}
	if force {
		return true
	}

	// 每周一，三，五的早上5点重置
	// 每周二，四，六的晚上23:30奖励
	reset := false
	for _, day := range weekdays {
		if day == int(t.Weekday()) {
			reset = true
			break
		}
	}
	return reset
}

type Fuben struct {
	*scheme.UnionFubenObject

	Passed int // 最大通关副本csvID

	union *Union

	damageranks []damagerankitem
}

func (fb *Fuben) Refresh() {
	db, unlock := fb.LockAndGetDB()
	defer unlock()
	if !fb.union.isFeatureOpen(UnionFuben) {
		fb.SetMonth(util.Todaymonth2int())
		fb.SetAwardDate(util.Perioddate2int(FubenAwardTime[0], util.Now()))
		fb.SetResetDate(util.Perioddate2int(util.DailyRefreshHour(), util.Now()))
		if _, ok := fb.States()[1]; !ok { // 自动开放第一关
			fb.SetStates(map[document.Integer]*scheme.UnionFubenState{
				1: {Members: make(map[document.ID]int)},
			})
		}
		return
	}

	fb._onMonthReset()
	fb._onDayReset(false)
	fb._onDayAward(false)

	fb.Passed = 0
	// 更新公会进度排名
	for idx, state := range db.States {
		allfubenprogress.onRefresh(int(idx), state.Damage, state.FirstTime, fb.union)
		if state.FirstTime > 0 && int(idx) > fb.Passed {
			fb.Passed = int(idx)
		}
	}
	fb.autoOpen()
}

func (fb *Fuben) _onMonthReset() {
	db := fb.GetLockedDB()
	// 每月重置，月初1号，公会副本会重置到初始状态
	nmi := util.Todaymonth2int()
	if db.Month == nmi {
		return
	}
	// 如果当月1号是周日，则顺延一天至周一进行清空
	if util.Now().Weekday() == time.Sunday {
		return
	}

	log.Infof("onMonthReset union %v date %d - %d", db.UnionDbId, db.Month, nmi)

	// 直接结算，算是额外奖励
	fb._onDayReset(true)

	fb.SetMonth(nmi)
	fb.SetStates(map[document.Integer]*scheme.UnionFubenState{
		1: {Members: make(map[document.ID]int)},
	})
}

//func (fb *Fuben) onMonthReset() {
//	_, unlock := fb.LockAndGetDB()
//	defer unlock()
//	fb._onMonthReset()
//}

type damagerankitem struct {
	_struct struct{} `codec:",toarray"`

	RoleID document.ID
	Rank   int
	CSVID  int
	Damage int
}

func (fb *Fuben) _onDayAward(force bool) {
	if !fb.union.isFeatureOpen(UnionFuben) {
		return
	}
	// 排名奖励：在会对挑战阶段内的副本进行伤害排名结算
	if !isDayTimeReached(fb.AwardDate(), FubenAwardTime[0], FubenAwardTime[1], FubenAwardWeakDay, force) {
		return
	}

	db := fb.GetLockedDB()
	ndi := util.Perioddate2int(FubenAwardTime[0], util.Now())
	log.Infof("onDayAward union %v date %d - %d", db.UnionDbId, db.AwardDate, ndi)

	ranks := make([]damagerankitem, 0, 64)
	for fubenid, state := range db.States {
		// 只针对当前周期内的副本进行奖励
		if state.Award {
			continue
		}

		// 公会内会员伤害排行
		damages := make([]int, 0, len(state.Members))
		roles := make(map[int][]document.ID) // {damage: [roleID, ]}
		for id, damage := range state.Members {
			damages = append(damages, damage)
			if _, ok := roles[damage]; ok {
				roles[damage] = append(roles[damage], id)
			} else {
				roles[damage] = []document.ID{id}
			}
		}
		sort.Sort(sort.Reverse(sort.IntSlice(damages)))
		rank := 0
		for _, damage := range damages {
			for _, id := range roles[damage] {
				rank++
				ranks = append(ranks, damagerankitem{RoleID: id, Rank: rank, CSVID: int(fubenid), Damage: damage})
			}
		}

		state.Award = true
	}
	if len(ranks) > 0 {
		if fb.damageranks == nil {
			fb.damageranks = ranks
		} else {
			fb.damageranks = append(fb.damageranks, ranks...)
		}
	}
	fb.SetStates(db.States)
	fb.SetAwardDate(ndi)
}

func (fb *Fuben) onDayAward(force bool) {
	_, unlock := fb.LockAndGetDB()
	defer unlock()
	fb._onDayAward(force)
}

func (fb *Fuben) _onDayReset(force bool) {
	// 未挑战完成的副本状况会重置，boss会恢复血量并重置伤害排行榜
	if !isDayTimeReached(fb.ResetDate(), util.DailyRefreshHour(), 0, FubenResetWeakDay, force) {
		return
	}

	db := fb.GetLockedDB()
	ndi := util.Perioddate2int(util.DailyRefreshHour(), util.Now())
	log.Infof("onDayReset union %v date %d - %d", db.UnionDbId, db.ResetDate, ndi)

	// 保证重置前奖励已经发送
	fb._onDayAward(true)

	// 重置后，当前未完成挑战的副本血量会被复原
	// 如果关卡全部通关完成后，会反复重置最后一个通关关卡
	for id, state := range db.States {
		if state.Time == 0 {
			state.Damage = 0
			state.Award = false
			state.Fail += 1
			state.Members = map[document.ID]int{}
			state.Buff = fb.calcBuff(int(id))
		} else if int(id) == GetConfig().LastFubenCsvID {
			state.Time = 0
			state.Damage = 0
			state.Award = false
			state.Members = map[document.ID]int{}
			state.Buff = fb.calcBuff(int(id))
		}
	}
	fb.SetStates(db.States)
	fb.SetResetDate(ndi)
}

//func (fb *Fuben) onDayReset(force bool) {
//	_, unlock := fb.LockAndGetDB()
//	defer unlock()
//	fb._onDayReset(force)
//}

func (fb *Fuben) StartBattle(id int) (int, error) {
	// 不进行时间上的判断，game 里面已经判了

	// 已通关
	state := fb.States()[document.Integer(id)]
	if state != nil && state.Time > 0 {
		return 0, ErrUnionFubenPassed
	}

	// 前一关是否通关
	if id > 1 {
		state := fb.States()[document.Integer(id-1)]
		if state == nil || state.Time <= 0 {
			return 0, ErrUnionFubenNoOpened
		}
	}

	return fb.calcBuff(id), nil
}

func (fb *Fuben) RecordBattle(csvID int, roleID document.ID, damage int, hpmax int) (bool, error) {
	db, unlock := fb.LockAndGetDB()
	defer unlock()

	id := document.Integer(csvID)
	state := db.States[id]
	if state.Time > 0 {
		return false, ErrUnionFubenPassed
	}

	if damage < 0 {
		damage = 0
	}
	state.Buff = fb.calcBuff(csvID)
	state.Damage += damage
	state.HPMax = hpmax
	if state.Members == nil {
		state.Members = make(map[document.ID]int)
	}
	state.Members[roleID] += damage
	deadly := false
	if state.Damage >= state.HPMax {
		state.Time = util.Now().Unix()
		// 首次通关时间，只有最后一关才有用
		// 且只有月重置时才删除
		if state.FirstTime == 0 {
			state.FirstTime = state.Time
		}
		deadly = true
		if csvID < GetConfig().LastFubenCsvID {
			// 初始化下一个副本
			db.States[id+1] = &scheme.UnionFubenState{Members: make(map[document.ID]int)}
		}
		if csvID > fb.Passed {
			fb.Passed = csvID
		}
	}
	fb.SetStates(db.States)

	// 更新公会进度排名
	allfubenprogress.onRefresh(csvID, state.Damage, state.FirstTime, fb.union)
	return deadly, nil
}

func (fb *Fuben) calcBuff(id int) int {
	// 最后一关不享受buff加成
	if id == GetConfig().LastFubenCsvID {
		return 0
	}
	state := fb.States()[document.Integer(id)]
	if state != nil && state.Time > 0 {
		return 0
	}

	passedCount, earliestTime := allfubenprogress.getPassed(id)
	buff, buff0 := 0, 0

	buffConfig := csv.GetConfig().Union.Union_fuben_buff
	// 每额外通关一个公会，会获得一个2%的buff加成
	buff0 = passedCount * buffConfig[1].Buff
	if buff0 > buffConfig[1].Max {
		buff0 = buffConfig[1].Max
	}
	buff += buff0

	// 当前时间和最快通关时间差距每多一天，也会获得一个2%的buff加成
	day := util.Now().Sub(earliestTime) / util.OneDay
	buff0 = int(day) * buffConfig[2].Buff
	if buff0 > buffConfig[2].Max {
		buff0 = buffConfig[2].Max
	}
	buff += buff0

	// 未通关buff加成
	// 每次结算周期点时，如果当前副本未通关，则会获得4%
	fail := 0
	if state != nil {
		fail = state.Fail
	}
	buff0 = fail * buffConfig[3].Buff
	if buff0 > buffConfig[3].Max {
		buff0 = buffConfig[3].Max
	}
	buff += buff0

	return buff
}

func (fb *Fuben) onRoleQuit(roleID document.ID) {
	db, unlock := fb.LockAndGetDB()
	defer unlock()

	for _, state := range db.States {
		delete(state.Members, roleID)
	}
	fb.SetStates(db.States)
}

func (fb *Fuben) GetDamageRank() []damagerankitem {
	ranks := fb.damageranks
	fb.damageranks = nil
	return ranks
}

func (fb *Fuben) autoOpen() {
	if _, ok := fb.States()[1]; !ok { // 自动开放第一关
		fb.SetStates(map[document.Integer]*scheme.UnionFubenState{
			1: {Members: make(map[document.ID]int)},
		})
	}
	if fb.Passed <= 0 {
		return
	}
	db := fb.GetLockedDB()
	state := db.States[document.Integer(fb.Passed)]
	if state.Damage >= state.HPMax {
		if fb.Passed < GetConfig().LastFubenCsvID {
			next := document.Integer(fb.Passed + 1)
			if _, ok := db.States[next]; !ok {
				// 策划新增加副本之后，对于之前已经通关最后一关的，自动开启后续的
				db.States[next] = &scheme.UnionFubenState{Members: map[document.ID]int{}}
				fb.SetStates(db.States)
			}
		}
	}
}

type FubenProgress struct {
	fubenprogress map[int]map[document.ID]fubenprogress
	unionprogress map[document.ID]fubenprogress
	sync.RWMutex
}

func (r *FubenProgress) reset() {
	r.Lock()
	defer r.Unlock()
	r.fubenprogress = make(map[int]map[document.ID]fubenprogress)
	r.unionprogress = make(map[document.ID]fubenprogress)
}

func (r *FubenProgress) onRefresh(idx int, damage int, time int64, union *Union) {
	if damage <= 0 {
		return
	}
	r.Lock()
	defer r.Unlock()
	id := union.GetID()

	v, ok := r.fubenprogress[idx]
	if !ok {
		r.fubenprogress[idx] = make(map[document.ID]fubenprogress)
		v = r.fubenprogress[idx]
	}
	v[id] = fubenprogress{IDX: idx, Damage: damage, Time: time, Name: union.Name(), Logo: union.Logo(), Level: union.Level()}
	if idx >= r.unionprogress[id].IDX {
		r.unionprogress[id] = v[id]
	}
}

func (r *FubenProgress) getPassed(idx int) (count int, earliest time.Time) {
	r.RLock()
	defer r.RUnlock()

	earliest = util.Now()
	v := r.fubenprogress[idx]
	if v == nil {
		return
	}
	t := earliest.Unix()
	for _, item := range v {
		if item.Time > 0 {
			count++
			if t > item.Time {
				t = item.Time
			}
		}
	}
	earliest = util.Unix(t)
	return
}

func (r *FubenProgress) GetUnionProgress(idx int) map[document.ID]fubenprogress {
	r.RLock()
	defer r.RUnlock()
	if idx > 0 {
		return r.fubenprogress[idx]
	}
	return r.unionprogress
}

type fubenprogress struct {
	_struct struct{} `codec:",toarray"`

	IDX    int
	Damage int
	Time   int64

	Name  string
	Logo  int
	Level int
}

// 全局公会副本进度
var allfubenprogress FubenProgress

func init() {
	allfubenprogress.fubenprogress = make(map[int]map[document.ID]fubenprogress)
	allfubenprogress.unionprogress = make(map[document.ID]fubenprogress)
}

package union

import (
	"errors"
	"math"
	"sort"
	"strings"
	"sync"
	"sync/atomic"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
	"tjgame/ugorji_go/codec"
)

type Union struct {
	*scheme.UnionObject

	joinRoles map[document.ID]bool

	rank int // 公会排名

	levelcontrib int // 当前等级贡献值
	levelcsv     *csv.Union_union_level

	camp       *TrainingCamp  // 公会训练营地
	fuben      *Fuben         // 公会副本
	redpackets *AllRedPackets // 公会红包

	inrefresh int32
	timerID   int
}

func (u *Union) memberMax() int {
	return u.levelcsv.MemberMax
}

func (u *Union) init(refresh bool) {
	cfg := GetConfig()
	u.levelcontrib = u.Contrib() - cfg.LevelSumExp[u.Level()-1]
	if u.levelcontrib < 0 || (u.Contrib() > cfg.LevelSumExp[u.Level()]) {
		u.reInitLevel()
	}

	u.levelcsv = csv.GetConfig().Union.Union_level[u.Level()]

	// 申请名单(过期在refresh里处理)
	u.joinRoles = make(map[document.ID]bool)
	for _, note := range u.JoinNotes() {
		u.joinRoles[note.ID] = true
	}
	if refresh { // refresh is false mean the union is creating
		_, unlock := u.LockAndGetDB()
		defer unlock()
		u.Refresh()
	}
	u.SynchronReset()
}

func (u *Union) reInitLevel() {
	u.addContrib(1)
	u.addContrib(-1)
}

func (u *Union) isFeatureOpen(feature string) bool {
	return isFeatureOpen(feature, u.Level())
}

func (u *Union) full() bool {
	return len(u.Members()) >= u.memberMax()
}

func (u *Union) onRefresh(id int) {
	if id != u.timerID {
		return
	}
	u.Lock()
	defer u.Unlock()
	u.Refresh()
}

func (u *Union) putEvent(duration time.Duration) {
	u.timerID++
	id := u.timerID
	time.AfterFunc(duration, func() {
		u.onRefresh(id)
	})
}

// 处理与时间相关的时间
// 1. 申请单过期处理
// 2. 会长长期未登录处理
// 3. 每日结算清理
func (u *Union) Refresh() {
	if !atomic.CompareAndSwapInt32(&u.inrefresh, 0, 1) {
		return
	}
	defer func() {
		atomic.StoreInt32(&u.inrefresh, 0)
	}()

	db := u.GetLockedDB()
	now := util.NowTime()
	nexttime := now + util.OneDay.Seconds()
	isNext := false
	// 会长长期未登录
	var chairmanLasttime float64 = 0
	if member, ok := db.Members[db.ChairmanDbId]; ok {
		chairmanLasttime = member.LastTime
	}
	chairmanRefreshTime := chairmanLasttime + ChairmanNoLoginMaxDuration.Seconds()
	if chairmanRefreshTime > now {
		nexttime = math.Min(nexttime, chairmanRefreshTime)
		isNext = true
	} else {
		roleID := u.autoChooseNewChairman()
		if roleID != "" {
			place := u.rolePlace(roleID)
			if place == ViceChairmanPlace { // 新会长以前是副会长
				u.removeViceChairman(roleID)
			}
			// 替换会长
			u.SetChairmanDbId(roleID)
			log.Infof("Union %v auto choose chairman %v", u.GetID(), roleID)
			u.addHistory(HistoryChoose, db.Members[roleID].Name, "")
			chairmanLasttime = db.Members[roleID].LastTime
			chairmanRefreshTime := chairmanLasttime + ChairmanNoLoginMaxDuration.Seconds()
			if chairmanRefreshTime > now { // 如果实在找不到符合的玩家，会随便给一个玩家, 可能存在小于now，就不处理
				nexttime = math.Min(nexttime, chairmanRefreshTime)
				isNext = true
			}
		}
	}

	// 申请入会记录处理
	notes := make([]*scheme.UnionJoinNote, 0, len(db.JoinNotes))
	for _, note := range db.JoinNotes {
		t := note.Time + JoinDiscardDuration.Seconds()
		if t > now {
			notes = append(notes, note)
			nexttime = math.Min(nexttime, t)
			isNext = true
		} else {
			delete(u.joinRoles, note.ID)
		}
	}
	u.SetJoinNotes(notes)

	// 每日结算清理
	ndi5 := util.Todayinclock5date2int()
	if db.LastDate != ndi5 {
		u.SetJoinupInviteTimes(0)
		u.SetSendMailTimes(0)
		u.SetDayContrib(0)
		u.SetLastDate(ndi5)
		// 重置玩家每日公会副本进度
		members := db.Members
		for _, member := range members {
			member.FubenTimes = 0
		}
		u.SetMembers(members)

		// 重置每日捐献任务
		u.resetContribTasks(false)

		// 重置每日碎片赠予
		u.SetFragDonate(map[document.ID]*scheme.UnionFragmentDonate{})

		// 重置每周捐献任务
		if util.Weekinclock5date2int() == ndi5 {
			u.SetWeekTaskContrib(0)
			u.resetContribTasks(true)
		}
	}

	// 系统红包刷新
	redPacketRefreshDate := util.Todaydate2int()
	redPacketRefreshTime := float64(util.DateTimeCombine(redPacketRefreshDate, RedPacketRefreshHour, 0, 0).Unix())
	if redPacketRefreshTime > now {
		nexttime = math.Min(nexttime, redPacketRefreshTime)
		isNext = true
	} else {
		u.redpackets.refreshSysPackets(u.Level())
	}

	if isNext && nexttime-now > 0 {
		// 增加事件更新
		duration := time.Duration(nexttime-now) * time.Second
		u.putEvent(duration)
	}
	return
}

func (u *Union) Dissolve() {
	u.removeMember(u.ChairmanDbId())
	u.SetDestroy()
	if u.fuben != nil {
		u.fuben.SetDestroy()
	}
}

func (u *Union) isQueForJoin(roleID document.ID) bool {
	return u.joinRoles[roleID]
}

func (u *Union) directJoin(role scheme.UnionMemberRole) {
	u.insertMember(role)
	u.addHistory(HistoryDirect, role.Name, "")
}

func (u *Union) DirectJoin(role scheme.UnionMemberRole) error {
	if u.Destroyed() {
		return ErrUnionDestroyed
	}
	if u.full() {
		return ErrUnionMemberMax
	}
	u.directJoin(role)
	return nil
}

func (u *Union) InsertJoin(role scheme.UnionMemberRole) (string, error) {
	if u.Destroyed() {
		return "", ErrUnionDestroyed
	}
	if u.full() {
		return "", ErrUnionMemberMax
	}
	if _, ok := u.joinRoles[role.ID]; ok {
		return PendingStatus, nil
	}
	if u.JoinType() == DirectJoin {
		u.directJoin(role)
		return JoinedStatus, nil
	}
	if u.JoinType() == RefuseJoin {
		return "", ErrUnionRefuseJoin
	}

	// 排队申请
	db := u.GetLockedDB()
	db.JoinNotes = append(db.JoinNotes, &scheme.UnionJoinNote{
		UnionMemberRole: role,
		Time:            util.NowTime(),
		LastTime:        util.NowTime(),
	})
	u.SetJoinNotes(db.JoinNotes)
	u.joinRoles[role.ID] = true
	u.putEvent(JoinDiscardDuration)

	return PendingStatus, nil
}

func (u *Union) AccpetJoin(who document.ID, roleID document.ID) error {
	if u.full() {
		return ErrUnionMemberMax
	}
	if _, ok := u.joinRoles[who]; !ok {
		return ErrUnionRoleJoinCancel
	}
	delete(u.joinRoles, who)
	notes := make([]*scheme.UnionJoinNote, 0, len(u.JoinNotes())-1)
	for _, note := range u.JoinNotes() {
		if note.ID == who {
			u.insertMember(note.UnionMemberRole)
			u.addHistory(HistoryAccept, note.Name, u.Members()[roleID].Name)
		} else {
			notes = append(notes, note)
		}
	}
	u.SetJoinNotes(notes)
	return nil
}

func (u *Union) RefuseJoin(roleID document.ID) {
	delete(u.joinRoles, roleID)
	notes := make([]*scheme.UnionJoinNote, 0, len(u.JoinNotes()))
	for _, note := range u.JoinNotes() {
		if note.ID != roleID {
			notes = append(notes, note)
		}
	}
	u.SetJoinNotes(notes)
}

func (u *Union) RefuseJoinAll() {
	u.joinRoles = make(map[document.ID]bool)
	notes := make([]*scheme.UnionJoinNote, 0, 8)
	u.SetJoinNotes(notes)
}

func (u *Union) CancelJoin(roleID document.ID) {
	if _, ok := u.joinRoles[roleID]; !ok {
		return
	}
	delete(u.joinRoles, roleID)
	notes := make([]*scheme.UnionJoinNote, 0, len(u.JoinNotes())-1)
	for _, note := range u.JoinNotes() {
		if note.ID != roleID {
			notes = append(notes, note)
		}
	}
	u.SetJoinNotes(notes)
}

func (u *Union) UpdateJoinNotes(role scheme.UnionMemberRole) {
	db := u.GetLockedDB()
	for _, note := range db.JoinNotes {
		if note.ID == role.ID {
			note.UnionMemberRole = role
			note.LastTime = util.NowTime()
			u.SetJoinNotes(db.JoinNotes)
			break
		}
	}
}

func (u *Union) setMemberFubenTime(roleID document.ID, val int) {
	db := u.GetLockedDB()
	member := db.Members[roleID]
	if member != nil {
		member.FubenTimes = val
		u.SetMembers(db.Members)
	}
}

func (u *Union) isMember(id document.ID) bool {
	_, ok := u.Members()[id]
	return ok
}

func (u *Union) insertMember(role scheme.UnionMemberRole) {
	join := &scheme.UnionMember{
		role,
		0,
		0,
		util.NowTime(),
	}
	members := u.GetLockedDB().Members
	members[role.ID] = join
	u.SetMembers(members)

	// 加入公会营地 (没在缓存里的会在玩家打开训练营的时候或服务器重启时加入)
	if training := GetTraining(role.ID); training != nil {
		u.camp.add(role.ID, training)
		training.onJoinUnion()
		training.AutoOpen(role.Level, role.Vip)
	}
}

func (u *Union) removeMember(id document.ID) *scheme.UnionMember {
	db := u.GetLockedDB()
	member, ok := db.Members[id]
	if !ok {
		return nil
	}
	delete(db.Members, id)
	u.SetMembers(db.Members)

	// TODO: 清出公会碎片赠予列表
	u.RemoveFragDonate(id)

	// 清出公会营地
	if training := u.camp.discard(id); training != nil {
		training.RefreshToOffline(TrainingExpPerMinute(member.Level, db.Level))
		training.onQuitUnion()
	}

	u.fuben.onRoleQuit(id)

	return member
}

func (u *Union) UpdateMember(role scheme.UnionMemberRole, lastTime float64) {
	db := u.GetLockedDB()
	member, ok := db.Members[role.ID]
	if !ok {
		return
	}
	member.UnionMemberRole = role
	member.LastTime = lastTime
	u.SetMembers(db.Members)
}

func (u *Union) QuitMember(roleID document.ID) error {
	place := u.rolePlace(roleID)
	if place == ChairmanPlace {
		return ErrUnionChairmanCanNotQuit
	} else if place == ViceChairmanPlace {
		u.removeViceChairman(roleID)
	}
	member := u.removeMember(roleID)
	u.addHistory(HistoryQuit, member.Name, "")
	return nil
}

func (u *Union) KickMember(roleID document.ID, handler document.ID) error {
	place := u.rolePlace(roleID)
	if place == NonePlace {
		return ErrUnionNotInMembers
	}
	if place >= u.rolePlace(handler) { // 不能踢高级别或同级别
		return ErrUnionNoPermission
	}
	switch place {
	case ChairmanPlace:
		return ErrUnionNoPermission
	case ViceChairmanPlace:
		u.removeViceChairman(roleID)
	}
	member := u.removeMember(roleID)
	u.addHistory(HistoryKick, member.Name, u.Members()[handler].Name)
	return nil
}

func (u *Union) PromoteMember(roleID document.ID, handler document.ID) error {
	place := u.rolePlace(roleID)
	if place != MemberPlace {
		return nil
	}
	if len(u.ViceChairmans()) >= u.levelcsv.ViceChairmanMax {
		return ErrUnionViceChairmanMax
	}
	u.addViceChairman(roleID)
	u.addHistory(HistoryPromote, u.Members()[roleID].Name, "")
	return nil
}

func (u *Union) DemoteMember(roleID document.ID, handler document.ID) error {
	place := u.rolePlace(roleID)
	if place != ViceChairmanPlace {
		return nil
	}
	u.removeViceChairman(roleID)
	u.addHistory(HistoryDemote, u.Members()[roleID].Name, "")
	return nil
}

func (u *Union) rolePlace(id document.ID) int {
	if id == u.ChairmanDbId() {
		return ChairmanPlace
	}
	for _, v := range u.ViceChairmans() {
		if v == id {
			return ViceChairmanPlace
		}
	}
	if u.isMember(id) {
		return MemberPlace
	}
	return NonePlace
}

func (u *Union) addViceChairman(id document.ID) {
	db := u.GetLockedDB()
	db.ViceChairmans = append(db.ViceChairmans, id)
	u.SetViceChairmans(db.ViceChairmans)
}

func (u *Union) removeViceChairman(id document.ID) {
	db := u.GetLockedDB()
	vcs := make([]document.ID, 0, len(db.ViceChairmans))
	for _, i := range db.ViceChairmans {
		if i != id {
			vcs = append(vcs, i)
		}
	}
	db.ViceChairmans = vcs
	u.SetViceChairmans(db.ViceChairmans)
}

func (u *Union) SwapChairman(old document.ID, new document.ID) (int, error) {
	if util.NowTime()-u.CreatedTime() < ChairmanSwapMaxDuration.Seconds() {
		return 0, ErrUnionChairmanSwapTimeLimit
	}
	place := u.rolePlace(old)
	if place != ChairmanPlace {
		return NonePlace, ErrUnionNoPermission
	}
	place = MemberPlace
	place2 := u.rolePlace(new)
	if place2 == NonePlace { // 非本公会会员
		return 0, ErrUnionNotMember
	}
	if place2 == ViceChairmanPlace {
		u.removeViceChairman(new)
		u.addViceChairman(old)
		place = ViceChairmanPlace
	}
	u.SetChairmanDbId(new)
	members := u.Members()
	u.addHistory(HistorySwap, members[new].Name, members[old].Name)
	return place, nil
}

func (u *Union) addHistory(typ int, name1 string, name2 string) {
	historys := u.GetLockedDB().History
	historys = append(historys, scheme.UnionHistory{
		typ,
		util.NowTime(),
		name1,
		name2},
	)
	if len(historys) > HistoryMax {
		historys = historys[len(historys)-HistoryMax:]
	}
	u.SetHistory(historys)
}

func (u *Union) ModifyIntro(intro string, handler document.ID) error {
	place := u.rolePlace(handler)
	if place != ChairmanPlace && place != ViceChairmanPlace {
		return ErrUnionNoPermission
	}
	u.SetIntro(intro)
	return nil
}

func (u *Union) ModifyJoin(typ int, level int, desc string, handler document.ID) error {
	place := u.rolePlace(handler)
	if place != ChairmanPlace && place != ViceChairmanPlace {
		return ErrUnionNoPermission
	}
	u.SetJoinType(typ)
	u.SetJoinLevel(level)
	u.SetJoinDesc(desc)
	return nil
}

func (u *Union) ModifyLogo(logo int, handler document.ID) error {
	place := u.rolePlace(handler)
	if place != ChairmanPlace && place != ViceChairmanPlace {
		return ErrUnionNoPermission
	}
	u.SetLogo(logo)
	return nil
}

func (u *Union) Rename(name string, handler document.ID) error {
	place := u.rolePlace(handler)
	if place != ChairmanPlace {
		return ErrUnionNoPermission
	}
	u.SetName(name)
	return nil
}

func (u *Union) AddContrib(roleID document.ID, val int) {
	db := u.GetLockedDB()
	inc := u.levelcsv.ContribSumMax - db.DayContrib
	if inc > val {
		inc = val
	}
	u.addContrib(inc) // 增加公会贡献度
	u.SetDayContrib(db.DayContrib + inc)

	db.Members[roleID].Contrib += val // 增加玩家实际贡献度
	u.SetMembers(db.Members)
}

func (u *Union) addContrib(n int) {
	db := u.GetLockedDB()
	oldlevel := db.Level
	if n < 0 { // for gm, re-init level
		db.Level = 1
	}
	db.Contrib += n
	cfg := GetConfig()
	for db.Level < cfg.LevelMax && cfg.LevelSumExp[db.Level] <= db.Contrib {
		db.Level++
	}
	if db.Level == cfg.LevelMax && db.Contrib > cfg.LevelSumExp[cfg.LevelMax] {
		db.Contrib = cfg.LevelSumExp[cfg.LevelMax]
	}
	u.SetDirty("contrib", "level")
	u.levelcontrib = db.Contrib - cfg.LevelSumExp[db.Level-1]
	if oldlevel != db.Level {
		u.levelcsv = csv.GetConfig().Union.Union_level[u.Level()]
	}
}

func (u *Union) AddTaskContrib(roleID document.ID, csvID int, val int) {
	db := u.GetLockedDB()
	cfg := csv.GetConfig().Union.Union_task[csvID]
	if cfg.UserType == 1 { // 个人类型增加，公会类型在计数达到时自动增加
		inc := u.levelcsv.TaskExpMax - db.WeekTaskContrib
		if inc > val {
			inc = val
		}
		u.addContrib(inc) // 增加公会贡献度
		u.SetWeekTaskContrib(db.WeekTaskContrib + inc)
	}

	db.Members[roleID].Contrib += val // 增加玩家实际贡献度
	u.SetMembers(db.Members)
}

func (u *Union) AddTaskContribCount(csvID int, val int) error {
	taskcfgs := csv.GetConfig().Union.Union_task
	cfg := taskcfgs[csvID]
	if cfg.UserType != 2 {
		return errors.New("not all union tasks")
	}

	db := u.GetLockedDB()
	r := db.ContribTasks[document.Integer(csvID)]
	old := 0
	if r != nil {
		if r[1] == 1 {
			return nil // mission accomplished
		}
		old = r[0]
	}
	db.ContribTasks[document.Integer(csvID)] = []int{old + val, 0}

	// 自动完成任务
	for id, v := range db.ContribTasks {
		val, flag := v[0], v[1]
		if flag == 1 { // 已完成
			continue
		}
		cfg := taskcfgs[int(id)]
		if val >= cfg.TargetArg {
			db.ContribTasks[id] = []int{val, 1}
			// 增加公会贡献度
			inc := u.levelcsv.TaskExpMax - db.WeekTaskContrib
			if inc > cfg.Contrib {
				inc = cfg.Contrib
			}
			u.addContrib(inc)
			u.SetWeekTaskContrib(db.WeekTaskContrib + inc)
		}
	}

	u.SetContribTasks(db.ContribTasks)
	return nil
}

func (u *Union) resetContribTasks(week bool) {
	ttype := 1
	if week {
		ttype = 2
	}
	db := u.GetLockedDB()
	tasks := make(map[document.Integer][]int, len(db.ContribTasks))
	taskcfgs := csv.GetConfig().Union.Union_task
	for id, v := range db.ContribTasks {
		cfg := taskcfgs[int(id)]
		if cfg != nil && cfg.Type != ttype {
			tasks[id] = v
		}
	}
	u.SetContribTasks(tasks)
}

func (u *Union) autoChooseNewChairman() document.ID {
	ranks := make(memberranks, 0, 8)
	db := u.GetLockedDB()
	now := util.NowTime()
	if len(db.ViceChairmans) > 0 {
		for _, v := range db.ViceChairmans {
			member := db.Members[v]
			if now-member.LastTime < CandidateNoLoginMaxDuration.Seconds() {
				ranks = append(ranks, memberrankitem{member.ID, member.Contrib, member.Level})
			}
		}
	}
	if len(ranks) == 0 {
		for _, member := range db.Members {
			if now-member.LastTime < CandidateNoLoginMaxDuration.Seconds() {
				ranks = append(ranks, memberrankitem{member.ID, member.Contrib, member.Level})
			}
		}
	}
	if len(ranks) > 0 {
		sort.Sort(ranks)
		return ranks[0].id
	} else {
		for _, member := range db.Members {
			return member.ID
		}
	}
	return ""
}

func (u *Union) AddMail(thumb scheme.UnionMailThumb) {
	db := u.GetLockedDB()
	db.Mails = append(db.Mails, thumb)
	u.SetMails(db.Mails)
}

func (u *Union) RecvMail(offset int, time float64) ([]scheme.UnionMailThumb, int) {
	db := u.GetLockedDB()
	count := len(db.Mails)
	if offset >= count {
		return nil, count
	}
	ret := make([]scheme.UnionMailThumb, 0, count-offset)
	for _, thumb := range db.Mails[offset:] {
		if thumb.Time >= time {
			ret = append(ret, thumb)
		}
	}
	return ret, count
}

func (u *Union) DonateFrag(roleID document.ID, toRole document.ID, frag int, singleMaxTimes int) (success, full bool) {
	donate := u.FragDonate()
	v, success := donate[toRole]
	success = success && v.FragID == frag
	success = success && v.Current < v.TotalMax
	if !success {
		if v != nil {
			full = v.Current >= v.TotalMax
		}
		return
	}

	times := 0
	for _, id := range v.History {
		if id == roleID {
			times += 1
		}
	}
	success = times < singleMaxTimes // 给同一条许愿最多次数
	if success {
		v.Current += 1
		v.History = append(v.History, roleID)
		u.SetFragDonate(donate)
	}
	full = v.Current >= v.TotalMax
	return
}

func (u *Union) FragDonateStart(roleID document.ID, frag int, totalmax int) bool {
	donate := u.FragDonate()
	// 新发起直接覆盖旧的，不再判断是否之前存在
	//if _, ok := donate[roleID]; ok {
	//	return false
	//}
	donate[roleID] = &scheme.UnionFragmentDonate{
		FragID:   frag,
		Current:  0,
		TotalMax: totalmax,
		History:  []document.ID{},
	}
	u.SetFragDonate(donate)
	return true
}

func (u *Union) RemoveFragDonate(roleID document.ID) {
	donate := u.FragDonate()
	delete(donate, roleID)
	u.SetFragDonate(donate)
}

func (u *Union) slimModelLocked() *SlimModel {
	_, unlock := u.RLockAndGetDB()
	defer unlock()
	return &SlimModel{
		u.GetID(),
		u.UID(),
		u.Name(),
		u.Logo(),
		u.Level(),
		u.Members()[u.ChairmanDbId()].Name,
		u.JoinLevel(),
		u.JoinType(),
		u.JoinDesc(),
		u.Intro(),
		u.Contrib(),
		u.DayContrib(),
		len(u.Members()),
		u.memberMax(),
	}
}

func (u *Union) Synchron() codec.Raw {
	v := u.GetSynchronAndReset(u.BeWatched())
	if v == nil {
		v = make(map[string]interface{})
	}
	v["fuben_passed"] = u.fuben.Passed
	v["training_count"] = len(u.camp.trainings)
	v["rank"] = u.rank

	data, err := util.MsgPack(v)
	if err != nil {
		log.Warningf("Synchron msgpack error %v", err)
		return nil
	}
	return data
}

type UnionModel struct {
	*scheme.UnionObject

	FubenPassed int
	Rank        int
}

// Selfer
func (o *UnionModel) CodecEncodeSelf(e *codec.Encoder) {
	db, unlock := o.RLockAndGetDB()
	defer unlock()

	if err := e.Encode(struct {
		*scheme.Union
		FubenPassed int `codec:"fuben_passed"`
		Rank        int `codec:"rank"`
	}{db, o.FubenPassed, o.Rank}); err != nil {
		log.Errorf("UnionModel:%v encode self error:%v", o.GetID(), err)
	}
}

func (u *Union) Model() document.IDocument {
	return UnionModel{
		UnionObject: u.UnionObject,
		FubenPassed: u.fuben.Passed,
		Rank:        u.rank,
	}
}

func (u *Union) GameRoleSync(id document.ID) *GameRole {
	db := u.GetLockedDB()
	return &GameRole{
		UnionDBID:        &db.ID,
		UnionPlace:       u.rolePlace(id),
		UnionJoinQue:     []document.ID{},
		UnionJoinTime:    db.Members[id].LastTime, // 只有加入公会后第一次sync的才是加入时间
		RolePacketCanRob: u.redpackets.HasRolePacketCanRob(id),
		SysPacketCanRob:  u.redpackets.HasSysPacketCanRob(id),
	}
}

type SlimModel struct {
	ID           document.ID `codec:"id"`
	UID          int         `codec:"uid"`
	Name         string      `codec:"name"`
	Logo         int         `codec:"logo"`
	Level        int         `codec:"level"`
	ChairmanName string      `codec:"chairman_name"`
	JoinLevel    int         `codec:"join_level"`
	JoinType     int         `codec:"join_type"`
	JoinDesc     string      `codec:"join_desc"`
	Intro        string      `codec:"intro"`
	Contrib      int         `codec:"contrib"`
	DayContrib   int         `codec:"day_contrib"`
	Members      int         `codec:"members"`
	MemberMax    int         `codec:"member_max"`
}

type SyncUnionModel struct {
	Name            string `codec:"name"`
	Logo            int    `codec:"logo"`
	Level           int    `codec:"level"`
	Contrib         int    `codec:"contrib"`
	DayContrib      int    `codec:"day_contrib"`
	WeekTaskContrib int    `codec:"week_task_contrib"`
	Intro           string `codec:"intro"`
	JoinLevel       int    `codec:"join_level"`
	JoinType        int    `codec:"join_type"`
	JoinDesc        string `codec:"join_desc"`

	ContribTasks map[document.Integer][]int `codec:"contrib_tasks"`
}

type Unions struct {
	sync.Map
	total int64

	mu        sync.RWMutex
	slimcache map[document.ID]*SlimModel

	dayContribRanks []document.ID // 日捐献排行
	controbRanks    []document.ID // 总捐献排行
}

func (uns *Unions) init() {
	uns.slimcache = make(map[document.ID]*SlimModel, uns.total)
	uns.reSort()
}

func (uns *Unions) GetUnion(id document.ID) *Union {
	if union, ok := uns.Load(id); ok {
		return union.(*Union)
	}
	return nil
}

func (uns *Unions) GetUnionByUID(uid int) *Union {
	var hit *Union
	uns.Range(func(key, value interface{}) bool {
		union := value.(*Union)
		if union.UID() == uid {
			hit = union
			return false
		}
		return true
	})
	return hit
}

func (uns *Unions) FindByName(name string) []*Union {
	unions := make([]*Union, 0, 1)
	uns.Range(func(key, value interface{}) bool {
		union := value.(*Union)
		if strings.Contains(union.Name(), name) {
			unions = append(unions, union)
		}
		return true
	})
	return unions
}

func (uns *Unions) GetDayContribRankList(offset, size int) []SlimModel {
	uns.mu.RLock()
	defer uns.mu.RUnlock()
	models := make([]SlimModel, 0, size)
	count := len(uns.dayContribRanks)
	if offset >= 0 && offset < count {
		right := offset + size
		if right > count {
			right = count
		}
		for _, id := range uns.dayContribRanks[offset:right] {
			models = append(models, *uns.slimcache[id])
		}
	}
	return models
}

func (uns *Unions) GetContribRankList(offset, size int) []SlimModel {
	uns.mu.RLock()
	defer uns.mu.RUnlock()
	models := make([]SlimModel, 0, size)
	count := len(uns.controbRanks)
	if offset >= 0 && offset < count {
		right := offset + size
		if right > count {
			right = count
		}
		for _, id := range uns.controbRanks[offset:right] {
			models = append(models, *uns.slimcache[id])
		}
	}
	return models
}

func (uns *Unions) FastJoin(role scheme.UnionMemberRole, lastUnionID *document.ID) (id document.ID, err error) {
	uns.Range(func(key, value interface{}) bool {
		unionID := key.(document.ID)
		if lastUnionID != nil && unionID == *lastUnionID {
			return true
		}
		union := value.(*Union)
		union.Lock()
		defer union.Unlock()
		if union.JoinType() == DirectJoin && role.Level >= union.JoinLevel() {
			err = union.DirectJoin(role)
			if err == nil {
				id = unionID
				return false
			}
		}
		return true
	})
	if err != nil || id == "" {
		err = errors.New("no fix union")
	}
	return
}

func (uns *Unions) GetJoinQue(roleID document.ID, joinQue []document.ID) []document.ID {
	applys := make(map[document.ID]bool)
	uns.Range(func(key, value interface{}) bool {
		unionID := key.(document.ID)
		union := value.(*Union)
		if union.isQueForJoin(roleID) {
			applys[unionID] = true
		}
		return true
	})

	que := make([]document.ID, 0, 3) // joinQue 排列在前
	visited := make(map[document.ID]bool)
	for _, id := range joinQue {
		if _, ok := applys[id]; ok {
			que = append(que, id)
			visited[id] = true
		}
	}
	for id := range applys {
		if !visited[id] {
			que = append(que, id)
			visited[id] = true
		}
	}
	return que
}

func (uns *Unions) CancelJoin(roleID document.ID) {
	uns.Range(func(key, value interface{}) bool {
		union := value.(*Union)
		union.Lock()
		defer union.Unlock()
		union.CancelJoin(roleID)
		return true
	})
}

func (uns *Unions) onCreate(union *Union) {
	uns.Store(union.GetID(), union)
	atomic.AddInt64(&uns.total, 1)
}

func (uns *Unions) onDissolve(unionID document.ID) {
	uns.Delete(unionID)
	atomic.AddInt64(&uns.total, -1)
}

func (uns *Unions) refreshSlimModels() {
	uns.mu.Lock()
	defer uns.mu.Unlock()
	uns.Range(func(key, value interface{}) bool {
		id := key.(document.ID)
		union := value.(*Union)
		uns.slimcache[id] = union.slimModelLocked()
		return true
	})
}

// reSort内部获取每个union有加锁
func (uns *Unions) reSort() {
	uns.refreshSlimModels()
	ranks := &ranks{
		items: make([]rankitem, 0, uns.total),
	}
	uns.Range(func(key, value interface{}) bool {
		id := key.(document.ID)
		union := value.(*Union)
		ranks.items = append(ranks.items, rankitem{
			id: id,
			items: map[string]int{
				"fightingpoint": 0,
				"level":         union.Level(),
				"contrib":       union.Contrib(),
				"daycontrib":    union.DayContrib(),
			}})
		return true
	})

	// 日捐献排行
	ranks.keys = []string{"daycontrib", "contrib", "level"}
	sort.Sort(ranks)
	uns.dayContribRanks = make([]document.ID, 0, len(ranks.items))
	for _, item := range ranks.items {
		uns.dayContribRanks = append(uns.dayContribRanks, item.id)
	}

	// 总捐献排行
	ranks.keys = []string{"contrib", "daycontrib", "level"}
	sort.Sort(ranks)
	uns.controbRanks = make([]document.ID, 0, len(ranks.items))
	for i, item := range ranks.items {
		uns.controbRanks = append(uns.controbRanks, item.id)
		if union := uns.GetUnion(item.id); union != nil {
			union.rank = i + 1
		}
	}

	log.Debugf("reSort union, count %d", len(ranks.items))
}

// 0点和5点都会刷新，参见_onNewDay和_onNewDayInClock5
func (uns *Unions) OnRefresh() {
	uns.Range(func(key, value interface{}) bool {
		union := value.(*Union)
		union.Lock()
		defer union.Unlock()
		union.Refresh()
		return true
	})
}

// 这里是每日5点重置，ObjectUnionFuben自己保证数据正确
func (uns *Unions) OnFubenReset() {
	allfubenprogress.reset()
	uns.Range(func(key, value interface{}) bool {
		union := value.(*Union)
		union.Lock()
		defer union.Unlock()
		union.fuben.Refresh()
		return true
	})
}

// 这里是每日23:30重置，ObjectUnionFuben自己保证数据正确
func (uns *Unions) OnFubenAward() {
	uns.Range(func(key, value interface{}) bool {
		union := value.(*Union)
		union.Lock()
		defer union.Unlock()
		union.fuben.onDayAward(false)
		return true
	})
}

func (uns *Unions) GetFubenDamageRank() []damagerankitem {
	ranks := make([]damagerankitem, 0, 64)
	uns.Range(func(key, value interface{}) bool {
		union := value.(*Union)
		union.Lock()
		defer union.Unlock()
		if rs := union.fuben.GetDamageRank(); rs != nil {
			ranks = append(ranks, rs...)
		}
		return true
	})
	return ranks
}

type memberrankitem struct {
	id      document.ID
	contrib int
	level   int
}

type memberranks []memberrankitem

func (r memberranks) Len() int {
	return len(r)
}

func (r memberranks) Less(i, j int) bool {
	if r[i].contrib != r[j].contrib {
		return r[i].contrib > r[j].contrib
	}
	return r[i].level > r[j].level
}

func (r memberranks) Swap(i, j int) {
	r[i], r[j] = r[j], r[i]
}

type rankitem struct {
	id    document.ID
	items map[string]int
}

type ranks struct {
	items []rankitem
	keys  []string
}

func (r *ranks) Len() int {
	return len(r.items)
}

func (r *ranks) Less(i, j int) bool {
	for _, key := range r.keys {
		if r.items[i].items[key] == r.items[j].items[key] {
			continue
		}
		return r.items[i].items[key] > r.items[j].items[key]
	}
	return true
}

func (r *ranks) Swap(i, j int) {
	r.items[i], r.items[j] = r.items[j], r.items[i]
}

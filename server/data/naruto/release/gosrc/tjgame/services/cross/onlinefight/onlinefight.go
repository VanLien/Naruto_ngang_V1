package onlinefight

import (
	"errors"
	"fmt"
	"math"
	"sort"
	"sync"
	"sync/atomic"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/document/schemeutil"
	"tjgame/server_framework/tj"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/cross"
	"tjgame/services/cross/onlinefight/proto"
	"tjgame/services/game"
	"tjgame/ta"

	"tjgame/mgo.v2/bson"
)

const (
	Unlimited = 1
	Limited   = 2

	MaxTopHistory = 10
)

var (
	startTime = util.Time{Hour: 5, Minute: 0} // 一期玩法开始时间

	MockCardIDFormat = "online%d%05d" // 'online{who}{card_id}'

	ErrAlreadyInMatching = errors.New("already in matching")
	ErrAlreadyInBattle   = errors.New("already in battle")
	ErrMatchLocked       = errors.New("match locked")
)

type protect struct {
	ranges []int

	winN  float64
	failN float64
	winT  float64
	failT float64
	winW  []float64
	failW []float64
}

func (p *protect) in(score int) bool {
	return score >= p.ranges[0] && score < p.ranges[1]
}

func (p *protect) repeatMatchFix(win bool, i int) float64 {
	w := p.winW
	if !win {
		w = p.failW
	}
	if i >= len(w) {
		return w[len(w)-1]
	}
	return w[i]
}

type Config struct {
	OpenWeekday     map[time.Weekday]bool
	OpenTimes       [][2]util.Time // [(start, end), ...]
	AwardTime       util.Time      // 周结算，赛季结算时间
	ThemeOpen       map[int]int    // key is day, value is theme id
	WinStreakCount  int            // 连胜状态需要的场次
	FailStreakCount int            // 连败状态需要的场次

	MatchRange      map[int][]*csv.Cross_online_fight_match
	BanPicks        map[int][]proto.BanPick // 公平赛banpick操作序列
	LimitedBanScore int                     // 公平赛开启扳选积分(大于等于)

	// 新手积分保护相关
	UnlimitedNewbieProtects map[int]*protect
	LimitedNewbieProtects   map[int]*protect

	// 精彩战报刷新时间
	TopBattleHistoryPeriods []int
	UnlimitedTopBattleRank  int // 非限制精彩战报最低排名
	LimitedTopBattleRank    int // 公平赛精彩战报最低排名

	// 跨cross匹配
	ExpandUnlimitedOpen      bool // 非限制赛拓展区间开关
	ExpandUnlimitedOpenScore int  // 非限制赛拓展区间积分要求 >=
	ExpandLimitedOpen        bool // 公平赛拓展区间开关
	ExpandLimitedOpenScore   int  // 公平赛拓展区间积分要求 >=
}

func (c *Config) NowInStart() bool {
	now := util.Now()
	if c.OpenWeekday[now.Weekday()] {
		for _, t := range c.OpenTimes {
			if now.After(t[0].Combine(now)) && now.Before(t[1].Combine(now)) {
				return true
			}
		}
	}
	return false
}

func (c *Config) NextStartTime() time.Time {
	now := util.Now()
	t := now
	for i := 0; i < 7; i++ {
		if c.OpenWeekday[t.Weekday()] {
			for _, t1 := range c.OpenTimes {
				if next := t1[0].Combine(t); next.After(now) {
					return next
				}
			}
		}
		t = t.Add(util.OneDay)
	}
	panic("unreachable")
}

func (c *Config) NextOverTime() time.Time {
	now := util.Now()
	t := now
	for i := 0; i < 7; i++ {
		if c.OpenWeekday[t.Weekday()] {
			for _, t1 := range c.OpenTimes {
				if next := t1[1].Combine(t); next.After(now) {
					return next
				}
			}
		}
		t = t.Add(util.OneDay)
	}
	panic("unreachable")
}

// return n, t, w
func (c *Config) GetNewbieProtect(score int, pattern int) *protect {
	if pattern == Unlimited {
		for _, p := range c.UnlimitedNewbieProtects {
			if p.in(score) {
				return p
			}
		}
	} else {
		for _, p := range c.LimitedNewbieProtects {
			if p.in(score) {
				return p
			}
		}
	}
	return nil
}

var config atomic.Value

func GetConfig() *Config {
	return config.Load().(*Config)
}

func LoadConfig() error {
	cfg := csv.GetConfig().Cross.Online_fight.Base[1]
	v := &Config{}

	v.WinStreakCount = cfg.WinStreakCount
	v.FailStreakCount = cfg.FailStreakCount

	// 开放星期
	v.OpenWeekday = make(map[time.Weekday]bool)
	for _, weekday := range cfg.OpenWeekday {
		day := weekday.(int64) % 7
		v.OpenWeekday[time.Weekday(day)] = true
	}
	v.OpenTimes = make([][2]util.Time, 0, len(cfg.OpenTime))
	for i := 0; i < len(cfg.OpenTime); i++ {
		times := cfg.OpenTime.GetSlice(i).ToIntSlice()
		start := times[0]
		end := times[1]
		v.OpenTimes = append(v.OpenTimes, [2]util.Time{
			{Hour: start / 100, Minute: start % 100},
			{Hour: end / 100, Minute: end % 100},
		})
	}

	// 周/赛季结算时间
	v.AwardTime = util.Time{Hour: cfg.AwardTime / 100, Minute: cfg.AwardTime % 100}

	// 精彩战报刷新时间
	v.TopBattleHistoryPeriods = cfg.TopBattleHistoryPeriods.ToIntSlice()
	v.UnlimitedTopBattleRank = cfg.UnlimitedTopBattleRank
	v.LimitedTopBattleRank = cfg.LimitedTopBattleRank

	// 跨cross匹配
	v.ExpandUnlimitedOpen = cfg.ExpandUnlimitedOpen
	v.ExpandUnlimitedOpenScore = cfg.ExpandUnlimitedOpenScore
	v.ExpandLimitedOpen = cfg.ExpandLimitedOpen
	v.ExpandLimitedOpenScore = cfg.ExpandLimitedOpenScore

	// 玩法主题
	v.ThemeOpen = make(map[int]int)
	for _, cfg := range csv.GetConfig().Cross.Online_fight.Theme_open {
		v.ThemeOpen[cfg.Day] = cfg.Theme
	}

	// 匹配区间
	match := csv.GetConfig().Cross.Online_fight.Match
	ids := make([]int, 0, len(match))
	for id := range match {
		ids = append(ids, id)
	}
	sort.Ints(ids)
	v.MatchRange = make(map[int][]*csv.Cross_online_fight_match)
	for _, id := range ids {
		cfg := match[id]
		if _, ok := v.MatchRange[cfg.Type]; !ok {
			v.MatchRange[cfg.Type] = make([]*csv.Cross_online_fight_match, 0, 8)
		}
		v.MatchRange[cfg.Type] = append(v.MatchRange[cfg.Type], cfg)
	}

	// 公平赛扳选模式需要积分
	v.LimitedBanScore = cfg.LimitedBanScore

	// 新手保护积分
	v.UnlimitedNewbieProtects = make(map[int]*protect)
	v.LimitedNewbieProtects = make(map[int]*protect)
	for id, cfg := range csv.GetConfig().Cross.Online_fight.Newbie_protect {
		v.UnlimitedNewbieProtects[id] = &protect{
			ranges: cfg.Range.ToIntSlice(),
			winN:   cfg.UnlimitedNewbieWinN,
			failN:  cfg.UnlimitedNewbieFailN,
			winT:   cfg.UnlimitedNewbieWinT,
			failT:  cfg.UnlimitedNewbieFailT,
			winW:   cfg.UnlimitedRepeatMatchWinFix.ToFloat64Slice(),
			failW:  cfg.UnlimitedRepeatMatchFailFix.ToFloat64Slice(),
		}
		v.LimitedNewbieProtects[id] = &protect{
			ranges: cfg.Range.ToIntSlice(),
			winN:   cfg.LimitedNewbieWinN,
			failN:  cfg.LimitedNewbieFailN,
			winT:   cfg.LimitedNewbieWinT,
			failT:  cfg.LimitedNewbieFailT,
			winW:   cfg.LimitedRepeatMatchWinFix.ToFloat64Slice(),
			failW:  cfg.LimitedRepeatMatchFailFix.ToFloat64Slice(),
		}
	}

	// 扳选卡
	vv := csv.GetConfig().Cross.Online_fight.Banpick
	ids = make([]int, 0, len(vv))
	for id := range vv {
		ids = append(ids, id)
	}
	sort.Ints(ids)
	language := tj.Language()
	v.BanPicks = make(map[int][]proto.BanPick)
	for _, id := range ids {
		cfg := vv[id]
		languages := util.NewSetByStringSlice(cfg.Languages.ToStringSlice())
		if !languages.Contains(language) {
			continue
		}
		if _, ok := v.BanPicks[cfg.Type]; !ok {
			v.BanPicks[cfg.Type] = make([]proto.BanPick, 0, 8)
		}
		v.BanPicks[cfg.Type] = append(v.BanPicks[cfg.Type], proto.BanPick{
			Ban:    cfg.BanCount,
			Pick:   cfg.PickCount,
			Second: cfg.Countdown,
		})
	}

	config.Store(v)
	return nil
}

type counter struct {
	win  int
	fail int
}

type CrossOnlineFightGlobal struct {
	*scheme.CrossOnlineFightGlobalObject
	builder   *Builder
	container service.IContainer
	key       string

	unlimitedLobby  *Lobby // 非限制赛
	limitedLobby    *Lobby // 公平赛选位制
	limitedBanLobby *Lobby // 公平赛扳选制
	battleground    *battleground
	forward         service.IService
	remotelobby     service.IService

	version       int
	theme         int         // 主题
	passiveSkills map[int]int // 主题被动技能
	rarityLimit   map[int]int // 主题稀有度限制

	cards map[int]*scheme.CardBattleModel // 公平赛卡牌

	roleServerKeys sync.Map // {Role.id: service key} cache

	// 玩家开始匹配时间
	roleMatchTimes sync.Map // {document.ID: time.Time}
	// 玩家匹配战斗准备 (可取消)
	roleMatchResult sync.Map // {role.ID: verifyer}
	// 玩家战斗前准备 (不可取消, locked)
	rolePrepare sync.Map
	// 重复匹配记录
	repeated   map[document.ID]map[document.ID]*counter
	repeatedMu sync.Mutex

	unlimitRanks     []document.ID
	unlimitRoleRanks map[document.ID]int
	limitRanks       []document.ID
	limitRoleRanks   map[document.ID]int

	roundTimer  *time.Timer
	weeklyTimer *time.Timer

	// 精彩战报
	unlimitedTopBattleHistory []scheme.CrossOnlineFightTopBattleHistory
	limitedTopBattleHistory   []scheme.CrossOnlineFightTopBattleHistory
	lastTopHistoryRefreshTime int

	unlimitedTrack *ta.BattleCardTrack
	limitedTrack   *ta.BattleCardTrack
}

func (g *CrossOnlineFightGlobal) init(container service.IContainer, builder *Builder) {
	g.container = container
	g.builder = builder
	g.key = g.Key()
	g.cleanCache()

	g.unlimitedLobby = NewLobby(1, Unlimited, GetConfig().MatchRange[1], func(c1 *competitor, c2 *competitor) {
		go g.onUnlimitedMatched(c1, c2)
	}, g.onMatchDiscard) // 非限制赛
	g.limitedLobby = NewLobby(2, Limited, GetConfig().MatchRange[2], func(c1 *competitor, c2 *competitor) {
		go g.onLimitedMatched(c1, c2, 2)
	}, g.onMatchDiscard) // 公平赛选卡制
	g.limitedBanLobby = NewLobby(3, Limited, GetConfig().MatchRange[3], func(c1 *competitor, c2 *competitor) {
		go g.onLimitedMatched(c1, c2, 3)
	}, g.onMatchDiscard) // 公平赛扳选制
	g.battleground = newBattleGround(container)

	g.forward = container.GetService("online_fight_forward")
	ss := container.GetServices("^crosslobby")
	if len(ss) > 0 {
		g.remotelobby = ss[0]
	}
}

func (g *CrossOnlineFightGlobal) reset() {
	g.clean()
	log.Infof("Cross OnlineFight Reset %d %s", g.StartDate(), g.Round())
	g.SetStartDate(0)
	g.SetEndDate(0)
	g.SetServers([]string{})
	g.SetCsvId(0)
	g.SetRoles(map[document.ID]*scheme.CrossOnlineFightRoleInfo{})
	g.SetCardReport(map[document.Integer]map[string]int{})
	g.SetUnlimitedTopBattleHistory([]scheme.CrossOnlineFightTopBattleHistory{})
	g.SetLimitedTopBattleHistory([]scheme.CrossOnlineFightTopBattleHistory{})
}

// 玩法结束就进行clean，等下一次开始才进行reset
func (g *CrossOnlineFightGlobal) clean() {
	log.Infof("Cross OnlineFight Clean %d %s", g.StartDate(), g.Round())
	g.SetRound("closed")
	g.SetServers([]string{})
}

func (g *CrossOnlineFightGlobal) cleanCache() {
	g.roleMatchTimes = sync.Map{}
	g.roleMatchResult = sync.Map{}
	g.unlimitRanks = []document.ID{}
	g.unlimitRoleRanks = map[document.ID]int{}
	g.limitRanks = []document.ID{}
	g.limitRoleRanks = map[document.ID]int{}
	g.resetRepeatedKeys()
}

func (g *CrossOnlineFightGlobal) IsOver() bool {
	return g.isAllOver()
}

func (g *CrossOnlineFightGlobal) OnInit(id int, servers []string) {
	log.Infof("CrossOnlineFight.OnInit")

	cfg := csv.GetConfig().Cross.Service[id]
	round := "over" // 5点开始之后就能进入界面，处于over状态
	util.WithGuard(g, func() {
		g.reset()
		ndt := util.Todaydate2int()
		g.SetStartDate(ndt)
		if cfg == nil || cfg.EndDate == 0 {
			g.SetEndDate(util.Date2int(util.Now().Add(util.OneDay * 60)))
		} else {
			g.SetEndDate(cfg.EndDate)
			g.version = cfg.Version
		}
		g.SetCsvId(id)
		g.SetServers(servers)
		g.SetRound(round)
	})
	g.refreshTopHistory()
	g.startThemeTimer()

	g.eventToGame("init", &EventToGame{Model: g.SyncGameModel()}, true, false)
	g.startRoundTimer(round)
	g.startWeeklyTimer()
}

func (g *CrossOnlineFightGlobal) isAllOver() bool {
	return g.Round() == "closed"
}

func (g *CrossOnlineFightGlobal) ResetToday() {
	cfg := csv.GetConfig().Cross.Service[g.CsvId()]
	if cfg != nil {
		g.version = cfg.Version
	}
	// check round
	if GetConfig().NowInStart() {
		g.SetRound("start")
	} else {
		g.SetRound("over")
	}

	util.WithGuard(g, func() {
		g.refreshRank(Unlimited)
		g.refreshRank(Limited)
	})
	g.refreshTopHistory()

	g.startThemeTimer()

	round := g.Round()
	date := g.StartDate()
	log.Infof("Cross OnlineFight.ResetToday date %d round %s", date, round)
	if round == "start" {
		g.start()
	} else if round == "over" {
		g.over()
	}
	g.startWeeklyTimer()
}

func (g *CrossOnlineFightGlobal) startThemeTimer() {
	g.resetTheme()

	now := util.Now()
	date := util.Date2int(now)
	time5 := util.DateTimeCombine(date, 5, 0, 0)
	duration := time5.Sub(now)
	if duration <= 0 {
		duration = time5.Add(util.OneDay).Sub(now)
	}
	log.Infof("next %v, reset theme", duration)
	time.AfterFunc(duration, g.startThemeTimer)
}

func (g *CrossOnlineFightGlobal) resetTheme() {
	begin := startTime.CombineDateInt(g.StartDate())
	delta := util.Now().Sub(begin).Hours()
	day := int(delta)/24 + 1
	if day <= 0 {
		return
	}
	theme := GetConfig().ThemeOpen[day]
	g.setTheme(theme)
}

func (g *CrossOnlineFightGlobal) setTheme(theme int) {
	g.theme = theme
	g.passiveSkills = make(map[int]int)
	g.rarityLimit = make(map[int]int)
	if g.theme > 0 {
		cfg := csv.GetConfig().Cross.Online_fight.Theme[g.theme]
		g.passiveSkills = cfg.Skills.ToIntMap()
		g.rarityLimit = cfg.RarityLimit.ToIntMap()
	}
	log.Infof("CrossOnlineFightGlobal.resetTheme theme %d, passive skills %v, rarity limit %v", g.theme, g.passiveSkills, g.rarityLimit)

	// 只有公平赛才有主题
	if g.limitedTrack != nil {
		g.limitedTrack.SetTheme(theme)
	}

	g.initLimitedBattleCard()
}

func (g *CrossOnlineFightGlobal) startRoundTimer(round string) {
	var dest time.Time
	var nextRound string
	var f func()
	conf := GetConfig()
	closedTime := conf.AwardTime.CombineDateInt(g.EndDate())

	if round == "closed" {
		dest = conf.NextStartTime()
		nextRound = "start"
		f = g.start
	} else if round == "start" {
		overtime := conf.NextOverTime()
		if overtime.Sub(closedTime) > 0 {
			dest = closedTime
			nextRound = "closed"
			f = g.closed
		} else {
			dest = overtime
			nextRound = "over"
			f = g.over
		}
	} else if round == "over" {
		starttime := conf.NextStartTime()
		if starttime.Sub(closedTime) > 0 {
			dest = closedTime
			nextRound = "closed"
			f = g.closed
		} else {
			dest = starttime
			nextRound = "start"
			f = g.start
		}
	}
	duration := dest.Sub(util.Now())
	log.Infof("cross online fight round %s next %s %s delta %s", round, nextRound, dest, duration)
	g.roundTimer = time.AfterFunc(duration, f)
}

func (g *CrossOnlineFightGlobal) startWeeklyTimer() {
	now := util.Now()
	if util.Date2int(now) == g.EndDate() {
		return
	}
	awardTime := GetConfig().AwardTime
	w := now.Weekday()
	var duration time.Duration
	var nextAwardTime time.Time
	if w == time.Sunday {
		nextAwardTime = awardTime.Combine(now)
		if nextAwardTime.After(now) {
			duration = nextAwardTime.Sub(now)
		}
	}
	if duration <= 0 {
		day := 7 - int(w) // 下一个周日
		t := now.Add(time.Duration(day) * util.OneDay)
		if util.Date2int(t) >= g.EndDate() {
			return
		}
		nextAwardTime = awardTime.Combine(t)
		duration = nextAwardTime.Sub(now)
	}
	log.Infof("cross online fight next weekly award %s delta %s", nextAwardTime, duration)
	g.weeklyTimer = time.AfterFunc(duration, g.weekly)
}

// 当天比赛开始
func (g *CrossOnlineFightGlobal) start() {
	log.Infof("cross online fight start")
	round := "start"
	util.WithGuard(g, func() {
		g.SetRound(round)
	})
	g.resetRepeatedKeys()
	g.eventToGame("start", nil, true, false)
	g.startRoundTimer(round)
}

// 当天比赛结束
func (g *CrossOnlineFightGlobal) over() {
	log.Infof("cross online fight over")
	round := "over"
	g.SetRound(round)
	g.eventToGame("over", nil, true, false)
	g.startRoundTimer(round)
}

// 周结算
func (g *CrossOnlineFightGlobal) weekly() {
	now := util.Todayinclock5date2int()
	if now == g.LastAwardDate() {
		log.Warningf("cross online fight date %d already award", now)
		return
	}
	g.SetLastAwardDate(now)

	// 周积分结算
	g.onWeeklyScoreAward()

	// 排行奖励
	g.onRankTitle()

	db, unlock := g.LockAndGetDB()
	util.WithDefer(func() {
		for _, role := range db.Roles {
			role.WinTimes = 0
			role.BattleTimes = 0
		}
		g.SetRoles(db.Roles)
	}, unlock)

	g.startWeeklyTimer()
}

// 赛季结算
func (g *CrossOnlineFightGlobal) closed() {
	log.Infof("cross online fight closed")
	round := "closed"
	g.SetRound(round)
	g.eventToGame("closed", nil, true, false)

	util.WithGuard(g, func() {
		g.refreshRank(Unlimited)
		g.refreshRank(Limited)
	})

	// 排行奖励
	g.onFinalAwardRanks()

	// 排行奖励
	g.onRankTitle()

	// 缓存排名
	g.notifyToGameCacheFinalRanks()
}

func (g *CrossOnlineFightGlobal) rankTop(pattten int, limit int) []scheme.CrossOnlineFightRankRole {
	var ranks []document.ID
	if pattten == Unlimited {
		ranks = g.unlimitRanks
	} else {
		ranks = g.limitRanks
	}

	db := g.GetLockedDB()
	top100 := make([]scheme.CrossOnlineFightRankRole, 0, 100)
	if len(ranks) > limit {
		ranks = ranks[:limit]
	}
	for _, id := range ranks {
		role := scheme.CrossOnlineFightRankRole{
			CrossOnlineFightRole: db.Roles[id].CrossOnlineFightRole,
		}
		if pattten == Unlimited {
			role.Score = db.Roles[id].UnlimitedScore
		} else {
			role.Score = db.Roles[id].LimitedScore
		}
		top100 = append(top100, role)
	}
	return top100
}

func (g *CrossOnlineFightGlobal) initLimitedBattleCard() {
	cfgs := csv.GetConfig().Cross.Online_fight.Cards
	ids := make([]int, 0, len(cfgs))
	language := tj.Language()
	for id, cfg := range cfgs {
		for _, v := range cfg.Languages.ToStringSlice() {
			if v == language {
				ids = append(ids, id)
				break
			}
		}
	}
	servers := g.Servers()
	key := servers[0]
	d := map[string]interface{}{
		key: &EventToGame{CsvIds: ids},
	}
	now := util.Now()
	response := g.eventToSomeGame("calc_cards", d, false)
	if response == nil {
		panic("may be some error happened")
	}

	cards := make(map[int]*scheme.CardBattleModel)
	for key, resp := range response {
		log.Infof("server %s cards %d", key, len(resp.Cards))
		for _, card := range resp.Cards {
			cards[card.CardId] = card
		}
	}
	for _, card := range cards {
		for id, level := range g.passiveSkills {
			card.Skills[document.Integer(id)] = level
		}
	}
	g.cards = cards
	log.Infof("Cross OnlineFight Make Cards cost %s", util.Now().Sub(now))
}

func (g *CrossOnlineFightGlobal) IsServerOK(key string) bool {
	db, unlock := g.RLockAndGetDB()
	defer unlock()
	if csv.GetMergeConfig().IsMergeKeyInServers(key, db.Servers) {
		return true
	}
	return false
}

func (g *CrossOnlineFightGlobal) SyncGameModel() *SyncGameModel {
	_, unlock := g.RLockAndGetDB()
	defer unlock()
	return g.syncGameModel()
}

func (g *CrossOnlineFightGlobal) syncGameModel() *SyncGameModel {
	db := g.GetLockedDB()
	return &SyncGameModel{
		Round:                     db.Round,
		ThemeID:                   g.theme,
		StartDate:                 db.StartDate,
		EndDate:                   db.EndDate,
		Version:                   g.version,
		Servers:                   db.Servers,
		UnlimitedTopBattleHistory: g.unlimitedTopBattleHistory,
		LimitedTopBattleHistory:   g.limitedTopBattleHistory,
	}
}

func (g *CrossOnlineFightGlobal) syncRoleModel(id document.ID) *SyncRoleModel {
	db := g.GetLockedDB()
	role := db.Roles[id]
	return &SyncRoleModel{
		UnlimitedRank:     g.unlimitRoleRanks[id],
		UnlimitedScore:    role.UnlimitedScore,
		UnlimitedTopScore: role.UnlimitedTopScore,
		LimitedRank:       g.limitRoleRanks[id],
		LimitedScore:      role.LimitedScore,
		LimitedTopScore:   role.LimitedTopScore,
	}
}

func (g *CrossOnlineFightGlobal) RoleJoin(role scheme.CrossOnlineFightRole) error {
	db, unlock := g.LockAndGetDB()
	defer unlock()
	if db.Round == "closed" {
		return ErrRoundClosed
	}

	if _, ok := db.Roles[role.RoleID]; !ok {
		db.Roles[role.RoleID] = &scheme.CrossOnlineFightRoleInfo{
			CrossOnlineFightRole: role,
			UnlimitedRecord:      &scheme.BattleRecord{},
			LimitedRecord:        &scheme.BattleRecord{},
		}
		g.refreshRank(Unlimited)
		g.refreshRank(Limited)
	} else {
		db.Roles[role.RoleID].CrossOnlineFightRole = role
	}
	g.SetRoles(db.Roles)
	return nil
}

func (g *CrossOnlineFightGlobal) SyncModel(id document.ID) *Model {
	db, unlock := g.RLockAndGetDB()
	defer unlock()
	syncModel := g.syncGameModel()

	role := db.Roles[id]
	if role == nil {
		return &Model{
			SyncGameModel: syncModel,
		}
	}
	return &Model{
		SyncRoleModel: g.syncRoleModel(id),
		SyncGameModel: syncModel,
	}
}

func (g *CrossOnlineFightGlobal) RoleGetMatchResult(id document.ID) *MatchResult {
	var matching int64
	v, ok := g.roleMatchTimes.Load(id)
	if ok {
		t := v.(time.Time)
		matching = t.Unix()
	}
	ground, enemy := g.battleground.GetGround(id)
	if matching == 0 && ground == nil {
		return nil
	}
	result := &MatchResult{
		Matching: matching,
	}
	if ground != nil {
		result.Enemy = enemy
		result.Address = ground.address
	}
	return result
}

func (g *CrossOnlineFightGlobal) RoleMatchStart(id document.ID, pattern int, cards []int, fightingPoint int, timeout time.Duration) (int64, error) {
	cfg := GetConfig()
	score := 0
	db, unlock := g.RLockAndGetDB()
	var err error
	var winstreak, failstreak bool
	var competitor proto.Competitor
	util.WithDefer(func() {
		if db.Round != "start" {
			err = ErrRoundNotStart
		}
		role := db.Roles[id]
		if pattern == Unlimited {
			score = role.UnlimitedScore
			winstreak = role.UnlimitedRecord.WinStreak >= cfg.WinStreakCount
			failstreak = role.UnlimitedRecord.FailStreak >= cfg.FailStreakCount
		} else {
			score = role.LimitedScore
			winstreak = role.LimitedRecord.WinStreak >= cfg.WinStreakCount
			failstreak = role.LimitedRecord.FailStreak >= cfg.FailStreakCount
		}
		competitor.CrossOnlineFightRole = role.CrossOnlineFightRole
		competitor.Score = score
		g.roleServerKeys.Store(id, role.GameKey)
	}, unlock)
	if err != nil {
		return 0, err
	}

	// 判断是否在匹配或战斗中
	if _, ok := g.roleMatchResult.Load(id); ok {
		return 0, ErrAlreadyInMatching
	}
	if _, ok := g.roleMatchTimes.Load(id); ok {
		return 0, ErrAlreadyInMatching
	}
	if ground, _ := g.battleground.GetGround(id); ground != nil {
		return 0, ErrAlreadyInBattle
	}

	now := util.Now()
	g.roleMatchTimes.Store(id, now)

	if g.remotelobby != nil {
		flag := false
		if pattern == Unlimited {
			flag = cfg.ExpandUnlimitedOpen && score >= cfg.ExpandUnlimitedOpenScore
		} else {
			flag = cfg.ExpandLimitedOpen && score >= cfg.ExpandLimitedOpenScore
		}
		if flag { // 开启跨cross匹配
			player := &proto.Player{
				ID:            id,
				Competitor:    competitor,
				Winstreak:     winstreak,
				Failstreak:    failstreak,
				FightingPoint: fightingPoint,
				Time:          now.Unix(),
				Timeout:       int(timeout.Seconds()),
				CrossKey:      g.key,
				Cards:         cards,
			}
			model := 1
			if pattern == Limited {
				if score >= cfg.LimitedBanScore {
					model = 3
				} else {
					model = 2
				}
			}
			if _, err := service.Call(g.remotelobby, "CrossLobbyMatchStart", player, model); err != nil {
				log.Warningf("CrossLobbyMatchStart error %v", err)
				return 0, err
			}
			return now.Unix(), nil
		}
	}

	var lobby *Lobby
	// 寻找lobby
	if pattern == Unlimited {
		lobby = g.unlimitedLobby
	} else {
		if score >= cfg.LimitedBanScore {
			lobby = g.limitedBanLobby
		} else {
			lobby = g.limitedLobby
		}
	}
	return now.Unix(), lobby.Match(id, score, now, winstreak, failstreak, cards, fightingPoint, timeout)
}

func (g *CrossOnlineFightGlobal) RoleMatchLocked(id document.ID) bool {
	_, ok := g.rolePrepare.Load(id)
	return ok
}

func (g *CrossOnlineFightGlobal) RoleMatchCancel(id document.ID) error {
	g.unlimitedLobby.MatchCancel(id)
	g.limitedLobby.MatchCancel(id)
	g.limitedBanLobby.MatchCancel(id)
	g.roleMatchTimes.Delete(id)
	g.roleMatchResult.Delete(id)
	return nil
}

func (g *CrossOnlineFightGlobal) getRoleScore(id document.ID, pattern int) int {
	db, unlock := g.RLockAndGetDB()
	defer unlock()
	if role, ok := db.Roles[id]; ok {
		if pattern == Unlimited {
			return role.UnlimitedScore
		} else {
			return role.LimitedScore
		}
	}
	return 0
}

func (g *CrossOnlineFightGlobal) onMatchDiscard(ids []document.ID) {
	roles := make([]scheme.CrossOnlineFightRole, 0, len(ids))
	db, unlock := g.RLockAndGetDB()
	util.WithDefer(func() {
		for _, id := range ids {
			roles = append(roles, db.Roles[id].CrossOnlineFightRole)
		}
	}, unlock)

	d := make(map[string]*EventToGame)
	for _, role := range roles {
		g.roleMatchTimes.Delete(role.RoleID)
		g.roleMatchResult.Delete(role.RoleID)

		if _, ok := d[role.GameKey]; !ok {
			d[role.GameKey] = &EventToGame{
				Discards: make([]document.ID, 0, 8),
			}
		}
		d[role.GameKey].Discards = append(d[role.GameKey].Discards, role.RoleID)
	}

	dd := make(map[string]interface{})
	for k, v := range d {
		dd[k] = v
	}
	g.eventToSomeGame("match_discard", dd, false)
}

func (g *CrossOnlineFightGlobal) onUnlimitedMatched(c1, c2 *competitor) {
	var role1, role2 *proto.Competitor
	db, unlock := g.RLockAndGetDB()
	util.WithDefer(func() {
		role1 = &proto.Competitor{
			CrossOnlineFightRole: db.Roles[c1.id].CrossOnlineFightRole,
			Score:                db.Roles[c1.id].UnlimitedScore,
		}
		role2 = &proto.Competitor{
			CrossOnlineFightRole: db.Roles[c2.id].CrossOnlineFightRole,
			Score:                db.Roles[c2.id].UnlimitedScore,
		}
	}, unlock)

	g.startUnLimitedBattle(role1, role2, false)
}

func (g *CrossOnlineFightGlobal) makeLimitedBattleCards(cards []int, pos int) ([]document.ID, map[document.ID]*scheme.CardBattleModel) {
	ids := make([]document.ID, 0, len(cards))
	attrs := make(map[document.ID]*scheme.CardBattleModel)
	for _, csvId := range cards {
		if g.cards[csvId] == nil {
			log.Warningf("card %d not found", csvId)
			continue
		}
		card := *g.cards[csvId] // copy because modify id
		id := document.ID(fmt.Sprintf(MockCardIDFormat, pos, csvId))
		ids = append(ids, id)
		card.ID = id
		attrs[id] = &card
	}
	return ids, attrs
}

func (g *CrossOnlineFightGlobal) onLimitedMatched(c1, c2 *competitor, typ int) {
	var role1, role2 *proto.Competitor
	db, unlock := g.RLockAndGetDB()
	util.WithDefer(func() {
		role1 = &proto.Competitor{
			CrossOnlineFightRole: db.Roles[c1.id].CrossOnlineFightRole,
			Score:                db.Roles[c1.id].LimitedScore,
		}
		role2 = &proto.Competitor{
			CrossOnlineFightRole: db.Roles[c2.id].CrossOnlineFightRole,
			Score:                db.Roles[c2.id].LimitedScore,
		}
	}, unlock)

	banpicks := GetConfig().BanPicks[typ]

	g.startLimitedBattle(role1, role2, c1.cards, c2.cards, banpicks, false)
}

// 跨cross战斗构建完成
func (g *CrossOnlineFightGlobal) onRemoteLobbyBattleBuildSuccess(player1 *proto.Player, player2 *proto.Player) {

}

func (g *CrossOnlineFightGlobal) startUnLimitedBattle(role1, role2 *proto.Competitor, solo bool) {
	id := document.NewID()
	verifyer := g.newVerifyer(id, role1.RoleID, role2.RoleID)
	roleKey1 := scheme.RoleKey{GameKey: role1.GameKey, ID: role1.RoleID}
	roleKey2 := scheme.RoleKey{GameKey: role2.GameKey, ID: role2.RoleID}

	robot := role2.RecordID == ""
	if role2.RecordID == "" {
		// TODO: for dev
		role2.RecordID = document.ID(bson.ObjectIdHex("5f2ad94380ae884b715c14b8"))
	}
	// 1. get battle cards
	record1 := GetRemoteCrossOnlineFightRecord(g.container.GetService(service.Game2PVPService(role1.GameKey)), role1.RecordID)
	record2 := GetRemoteCrossOnlineFightRecord(g.container.GetService(service.Game2PVPService(role2.GameKey)), role2.RecordID)
	if robot {
		role2.RoleID = record2.RoleDbId
		role2.RecordID = record2.ID
	}

	// 2. send to forward
	model := NewUnlimitedPlayModel(roleKey1, record1, roleKey2, record2)
	info := &proto.BattleInfo{
		ID:         id,
		From:       g.key,
		Time:       util.Now().Unix(),
		Role1:      role1,
		Role2:      role2,
		PlayRecord: model,
	}
	info.Solo = solo
	name, address := g.sendBattleToForward(Unlimited, info)

	// 校验这场战斗是否有效
	discards := g.checkVerifyer(address, verifyer)
	if discards != nil {
		log.Warningf("battle %v matched discard %v", id, discards)
		if len(discards) > 0 {
			g.onMatchDiscard(discards)
		}
		return
	}

	g.battleground.Assign(name, address, Unlimited, info, g.onBattleOver, "")
	g.roleMatchTimes.Delete(role1.RoleID)
	g.roleMatchTimes.Delete(role2.RoleID)
	g.roleMatchResult.Delete(role1.RoleID)
	g.roleMatchResult.Delete(role2.RoleID)

	// 3. push to game, notify role
	if solo {
		g.notifyToGameNewBattle(role1, nil, address, false)
	} else {
		g.notifyToGameNewBattle(role1, role2, address, false)
	}
}

func (g *CrossOnlineFightGlobal) startRemoteLobbyUnLimitedBattle(id document.ID, player1 *proto.Player, player2 *proto.Player) {
	time1, _ := g.roleMatchTimes.Load(player1.ID)
	g.roleMatchResult.Store(player1.ID, &verifyer{
		id:    id,
		role1: player1.ID,
		role2: player2.ID,
		time1: time1,
	})

	roleKey1 := scheme.RoleKey{GameKey: player1.GameKey, ID: player1.RoleID}
	roleKey2 := scheme.RoleKey{GameKey: player2.GameKey, ID: player2.RoleID}

	// 1. get battle cards
	record1 := GetRemoteCrossOnlineFightRecord(g.container.GetService(service.Game2PVPService(player1.GameKey)), player1.RecordID)
	record2 := GetRemoteCrossOnlineFightRecord(g.container.GetService(service.Game2PVPService(player2.GameKey)), player2.RecordID)

	// 2. send to forward
	model := NewUnlimitedPlayModel(roleKey1, record1, roleKey2, record2)
	info := &proto.BattleInfo{
		ID:         id,
		From:       g.key,
		Time:       util.Now().Unix(),
		Role1:      &player1.Competitor,
		Role2:      &player2.Competitor,
		PlayRecord: model,
	}
	name, address := g.sendBattleToForward(Unlimited, info)

	// 校验战斗的有效性
	g.rolePrepare.Store(player1.ID, id) // lock
	value, ok1 := g.roleMatchResult.Load(player1.ID)
	if ok1 {
		v := value.(*verifyer)
		t, _ := g.roleMatchTimes.Load(player1.ID)
		ok1 = v.id == id && v.time1 == t
	}
	resp, _ := service.Call(g.container.GetService(player2.CrossKey), "CrossOnlineFightRemoteBattleNotifyPrepareStart", id, player2.ID)
	ok2 := resp.(bool)
	if !ok1 || !ok2 || name == "" || address == "" { // 战斗无效
		g.rolePrepare.Delete(player1.RoleID) // unlock
		go g.onMatchDiscard([]document.ID{player1.ID})
		service.CallAsync(g.container.GetService(player2.CrossKey), "CrossOnlineFightRemoteBattleNotifyStart", nil, player2, "", "", Unlimited, info.ID) // 通知cross2战斗无效
		return
	}

	// 3. notify player2 cross
	service.Call(g.container.GetService(player2.CrossKey), "CrossOnlineFightRemoteBattleNotifyStart", player1, player2, name, address, Unlimited, info.ID)

	g.battleground.Assign(name, address, Unlimited, info, g.onCrossBattleOver, player2.CrossKey)
	g.roleMatchTimes.Delete(player1.RoleID)
	g.roleMatchResult.Delete(player1.RoleID)
	g.rolePrepare.Delete(player1.RoleID) // unlock

	// 4. push to game, notify role
	g.notifyToGameNewBattle(&player1.Competitor, &player2.Competitor, address, true)
}

func (g *CrossOnlineFightGlobal) makeLimitedCardDeck(cards1 []int, cards2 []int) *proto.CrossOnlineFightLimitedCardDeck {
	ids1, attrs1 := g.makeLimitedBattleCards(cards1, 0)
	ids2, attrs2 := g.makeLimitedBattleCards(cards2, 1)
	attrs := make(map[document.ID]*scheme.CardBattleModel)
	for id, v := range attrs1 {
		attrs[id] = v
	}
	for id, v := range attrs2 {
		attrs[id] = v
	}

	cardCsv := csv.GetConfig().Cards
	unitCsv := csv.GetConfig().Unit
	deck := &proto.CrossOnlineFightLimitedCardDeck{
		RoleCardDeck1: ids1,
		RoleCardDeck2: ids2,
		Cards:         make(map[document.ID]*proto.CrossOnlineFightCard),
		CardAttrs:     attrs,
	}
	for id, m := range attrs {
		rarity := unitCsv[cardCsv[m.CardId].UnitID].Rarity
		card := &proto.CrossOnlineFightCard{
			CrossOnlineFightCard: scheme.CrossOnlineFightCard{
				ID:            m.ID,
				CardId:        m.CardId,
				SkinId:        m.SkinId,
				Level:         m.Level,
				FightingPoint: m.FightingPoint,
				Star:          m.Star,
				Advance:       m.Advance,
			},
			MarkID: cardCsv[m.CardId].CardMarkID,
			Rarity: rarity,
		}
		deck.Cards[id] = card
	}
	return deck
}

func (g *CrossOnlineFightGlobal) startLimitedBattle(role1, role2 *proto.Competitor, cards1, cards2 []int, banpicks []proto.BanPick, solo bool) {
	id := document.NewID()
	verifyer := g.newVerifyer(id, role1.RoleID, role2.RoleID)

	// 1. 构建双方卡牌数据
	deck := g.makeLimitedCardDeck(cards1, cards2)

	// 2. send to forward
	model := NewLimitedPlayModel(&role1.CrossOnlineFightRole, &role2.CrossOnlineFightRole, deck)
	info := &proto.BattleInfo{
		ID:              id,
		From:            g.key,
		Time:            util.Now().Unix(),
		Role1:           role1,
		Role2:           role2,
		PlayRecord:      model,
		BanPicks:        banpicks,
		RarityLimit:     g.rarityLimit,
		LimitedCardDeck: deck,
	}
	info.Solo = solo
	name, address := g.sendBattleToForward(Limited, info)

	// 校验这场战斗是否有效
	discards := g.checkVerifyer(address, verifyer)
	if discards != nil {
		log.Warningf("battle %v matched discard %v", id, discards)
		if len(discards) > 0 {
			g.onMatchDiscard(discards)
		}
		return
	}

	g.battleground.Assign(name, address, Limited, info, g.onBattleOver, "")
	g.roleMatchTimes.Delete(role1.RoleID)
	g.roleMatchTimes.Delete(role2.RoleID)
	g.roleMatchResult.Delete(role1.RoleID)
	g.roleMatchResult.Delete(role2.RoleID)

	// 3. push to game, notify role
	if solo {
		g.notifyToGameNewBattle(role1, nil, address, false)
	} else {
		g.notifyToGameNewBattle(role1, role2, address, false)
	}
}

func (g *CrossOnlineFightGlobal) startRemoteLobbyLimitedBattle(id document.ID, player1 *proto.Player, player2 *proto.Player, banpicks []proto.BanPick) {
	time1, _ := g.roleMatchTimes.Load(player1.ID)
	g.roleMatchResult.Store(player1.ID, &verifyer{
		id:    id,
		role1: player1.ID,
		role2: player2.ID,
		time1: time1,
	})

	// 1. 构建双方卡牌数据
	deck := g.makeLimitedCardDeck(player1.Cards, player2.Cards)

	// 2. send to forward
	model := NewLimitedPlayModel(&player1.CrossOnlineFightRole, &player2.CrossOnlineFightRole, deck)
	info := &proto.BattleInfo{
		ID:              id,
		From:            g.key,
		Time:            util.Now().Unix(),
		Role1:           &player1.Competitor,
		Role2:           &player2.Competitor,
		PlayRecord:      model,
		BanPicks:        banpicks,
		RarityLimit:     g.rarityLimit,
		LimitedCardDeck: deck,
	}
	name, address := g.sendBattleToForward(Limited, info)

	// 校验战斗的有效性
	g.rolePrepare.Store(player1.ID, id) // lock
	value, ok1 := g.roleMatchResult.Load(player1.ID)
	if ok1 {
		v := value.(*verifyer)
		t, _ := g.roleMatchTimes.Load(player1.ID)
		ok1 = v.id == id && v.time1 == t
	}
	resp, _ := service.Call(g.container.GetService(player2.CrossKey), "CrossOnlineFightRemoteBattleNotifyPrepareStart", id, player2.ID)
	ok2 := resp.(bool)
	if !ok1 || !ok2 || name == "" || address == "" { // 战斗无效
		g.rolePrepare.Delete(player1.RoleID) // unlock
		go g.onMatchDiscard([]document.ID{player1.ID})
		service.CallAsync(g.container.GetService(player2.CrossKey), "CrossOnlineFightRemoteBattleNotifyStart", nil, player2, "", "", Limited, info.ID) // 通知cross2战斗无效
		return
	}

	// 3. notify player2 cross
	service.Call(g.container.GetService(player2.CrossKey), "CrossOnlineFightRemoteBattleNotifyStart", player1, player2, name, address, Limited, info.ID)

	g.battleground.Assign(name, address, Limited, info, g.onCrossBattleOver, player2.CrossKey)
	g.roleMatchTimes.Delete(player1.RoleID)
	g.roleMatchResult.Delete(player1.RoleID)
	g.rolePrepare.Delete(player1.RoleID) // unlock

	// 4. push to game, notify role
	g.notifyToGameNewBattle(&player1.Competitor, &player2.Competitor, address, true)
}

func (g *CrossOnlineFightGlobal) sendBattleToForward(pattern int, info *proto.BattleInfo) (string, string) {
	s1 := util.Now()
	resp, err := service.Call(g.forward, "StartOnlineFightBattle", info)
	if err != nil {
		log.Warningf("send battle to forward error %v", err)
		return "", ""
	}
	response := resp.([]string)
	name, address := response[0], response[1]
	log.Infof("battle %s pattern %d, %s %s vs %s %s forward %s %s, cost %v", info.ID, pattern, info.Role1.GameKey, info.Role1.RoleID, info.Role2.GameKey, info.Role2.RoleID, name, address, util.Now().Sub(s1))
	return name, address
}

func (g *CrossOnlineFightGlobal) notifyToGameNewBattle(role1, role2 *proto.Competitor, address string, single bool) {
	d := make(map[string]interface{})
	robot := role2 == nil
	if robot {
		role2 = &proto.Competitor{
			CrossOnlineFightRole: scheme.CrossOnlineFightRole{
				GameKey: "game.dev.2",
				Name:    "robot",
				Logo:    1,
				Frame:   1,
				Level:   50,
			},
			Score: 0,
		}
	}
	battle1 := newBattle{Role: &role1.CrossOnlineFightRole, MatchResult: &MatchResult{Enemy: role2, Address: address}}
	if robot || single {
		d[role1.GameKey] = &EventToGame{
			NewBattles: []newBattle{battle1},
		}
	} else {
		battle2 := newBattle{Role: &role2.CrossOnlineFightRole, MatchResult: &MatchResult{Enemy: role1, Address: address}}
		if role1.GameKey == role2.GameKey {
			d[role1.GameKey] = &EventToGame{
				NewBattles: []newBattle{battle1, battle2},
			}
		} else {
			d[role1.GameKey] = &EventToGame{
				NewBattles: []newBattle{battle1},
			}
			d[role2.GameKey] = &EventToGame{
				NewBattles: []newBattle{battle2},
			}
		}
	}
	g.eventToSomeGame("new_battles", d, false)
}

func (g *CrossOnlineFightGlobal) notifyToGameBattleOver(results ...*battleResult) {
	d := make(map[string]interface{})
	for _, result := range results {
		key := result.roleKey.GameKey
		if _, ok := d[key]; ok {
			e := d[key].(*EventToGame)
			e.BattleResults = append(e.BattleResults, result)
		} else {
			d[key] = &EventToGame{
				BattleResults: []*battleResult{result},
			}
		}
	}
	g.eventToSomeGame("battle_results", d, false)
}

// 排行称号
func (g *CrossOnlineFightGlobal) onRankTitle() {
	var unlimitRanks, limitRanks []scheme.CrossOnlineFightRankRole
	util.WithGuard(g, func() {
		unlimitRanks = g.rankTop(Unlimited, 10)
		limitRanks = g.rankTop(Limited, 10)
	})
	rankTitles := map[int]map[document.ID]int{Unlimited: make(map[document.ID]int), Limited: make(map[document.ID]int)}
	for i, role := range unlimitRanks {
		rankTitles[Unlimited][role.RoleID] = i + 1
	}
	for i, role := range limitRanks {
		rankTitles[Limited][role.RoleID] = i + 1
	}
	event := &EventToGame{
		RankTitles: rankTitles,
	}
	g.eventToGame("rank_titles", event, false, false)
}

// 周结算积分奖励
func (g *CrossOnlineFightGlobal) onWeeklyScoreAward() {
	d := make(map[string]interface{})
	db, unlock := g.RLockAndGetDB()
	util.WithDefer(func() {
		for id, role := range db.Roles {
			score := role.UnlimitedScore
			if score < role.LimitedScore {
				score = role.LimitedScore
			}
			key := role.GameKey
			if _, ok := d[key]; ok {
				e := d[key].(*EventToGame)
				e.WeeklyAwardRanks[id] = [2]int{score, role.BattleTimes}
			} else {
				d[key] = &EventToGame{
					WeeklyAwardRanks: map[document.ID][2]int{id: {score, role.BattleTimes}},
				}
			}
		}
	}, unlock)
	g.eventToSomeGame("weekly_award_ranks", d, false)
}

// 赛季结算排名奖励
func (g *CrossOnlineFightGlobal) onFinalAwardRanks() {
	ranks := make(map[document.ID]int)
	for id, rank := range g.unlimitRoleRanks {
		if v, ok := ranks[id]; !ok || rank < v {
			ranks[id] = rank
		}
	}
	for id, rank := range g.limitRoleRanks {
		if v, ok := ranks[id]; !ok || rank < v {
			ranks[id] = rank
		}
	}
	d := make(map[string]interface{})
	db, unlock := g.RLockAndGetDB()
	util.WithDefer(func() {
		for id, rank := range ranks {
			key := db.Roles[id].GameKey
			if _, ok := d[key]; ok {
				e := d[key].(*EventToGame)
				e.FinalAwardRanks[id] = rank
			} else {
				d[key] = &EventToGame{
					FinalAwardRanks: map[document.ID]int{id: rank},
				}
			}
		}
	}, unlock)
	g.eventToSomeGame("final_award_ranks", d, false)
}

func (g *CrossOnlineFightGlobal) notifyToGameCacheFinalRanks() {
	var unlimitRanks, limitRanks []scheme.CrossOnlineFightRankRole
	util.WithGuard(g, func() {
		unlimitRanks = g.rankTop(Unlimited, 100)
		limitRanks = g.rankTop(Limited, 100)
	})
	g.eventToGame("unlimited_ranks", &EventToGame{UnlimitedRanks: unlimitRanks}, false, false)
	g.eventToGame("limited_ranks", &EventToGame{LimitedRanks: limitRanks}, false, false)
}

func (g *CrossOnlineFightGlobal) addBattleHistoryToRecord(roleKey scheme.RoleKey, pattern int, history *scheme.CrossOnlineFightHistory) {
	var recordID document.ID
	db, unlock := g.RLockAndGetDB()
	util.WithDefer(func() {
		recordID = db.Roles[roleKey.ID].RecordID
	}, unlock)
	service.Call(g.container.GetService(service.Game2PVPService(roleKey.GameKey)), "CrossOnlineFightAddHistory", recordID, pattern, history)
}

func (g *CrossOnlineFightGlobal) addTopHistory(history scheme.CrossOnlineFightTopBattleHistory, pattern int) {
	db := g.GetLockedDB()
	if pattern == Unlimited {
		db.UnlimitedTopBattleHistory = append(db.UnlimitedTopBattleHistory, history)
		if len(db.UnlimitedTopBattleHistory) > 2*MaxTopHistory {
			db.UnlimitedTopBattleHistory = append(db.UnlimitedTopBattleHistory[:MaxTopHistory], db.UnlimitedTopBattleHistory[len(db.UnlimitedTopBattleHistory)-MaxTopHistory:]...)
		}
		g.SetUnlimitedTopBattleHistory(db.UnlimitedTopBattleHistory)
	} else {
		db.LimitedTopBattleHistory = append(db.LimitedTopBattleHistory, history)
		if len(db.LimitedTopBattleHistory) > 2*MaxTopHistory {
			db.LimitedTopBattleHistory = append(db.LimitedTopBattleHistory[:MaxTopHistory], db.LimitedTopBattleHistory[len(db.LimitedTopBattleHistory)-MaxTopHistory:]...)
		}
		g.SetLimitedTopBattleHistory(db.LimitedTopBattleHistory)
	}
}

func (g *CrossOnlineFightGlobal) refreshTopHistory() bool {
	cfg := GetConfig()
	db, unlock := g.LockAndGetDB()
	defer unlock()

	lastTime := util.NowTime2Peroid(cfg.TopBattleHistoryPeriods)
	if g.lastTopHistoryRefreshTime > 0 && g.lastTopHistoryRefreshTime == lastTime {
		return false
	}

	g.lastTopHistoryRefreshTime = lastTime

	if len(db.UnlimitedTopBattleHistory) > MaxTopHistory {
		historys := db.UnlimitedTopBattleHistory[len(db.UnlimitedTopBattleHistory)-MaxTopHistory:]
		g.unlimitedTopBattleHistory = make([]scheme.CrossOnlineFightTopBattleHistory, len(historys))
		copy(g.unlimitedTopBattleHistory, historys)
		g.SetUnlimitedTopBattleHistory(historys)
	} else {
		g.unlimitedTopBattleHistory = make([]scheme.CrossOnlineFightTopBattleHistory, len(db.UnlimitedTopBattleHistory))
		copy(g.unlimitedTopBattleHistory, db.UnlimitedTopBattleHistory)
	}

	if len(db.LimitedTopBattleHistory) > MaxTopHistory {
		historys := db.LimitedTopBattleHistory[len(db.LimitedTopBattleHistory)-MaxTopHistory:]
		g.limitedTopBattleHistory = make([]scheme.CrossOnlineFightTopBattleHistory, len(historys))
		copy(g.limitedTopBattleHistory, historys)
		g.SetLimitedTopBattleHistory(historys)
	} else {
		g.limitedTopBattleHistory = make([]scheme.CrossOnlineFightTopBattleHistory, len(db.LimitedTopBattleHistory))
		copy(g.limitedTopBattleHistory, db.LimitedTopBattleHistory)
	}

	return true
}

func (g *CrossOnlineFightGlobal) notifyToGameTopHistory() {
	g.eventToGame("top_history", nil, true, true)
}

// forward 战斗结束
func (g *CrossOnlineFightGlobal) onForwardBattleOver(result *proto.BattleResult) {
	id := result.ID
	ground := g.battleground.Remove(id)
	if ground == nil {
		log.Warningf("ground %s not found", id)
		return
	}
	ground.SetResult(result)
}

func (g *CrossOnlineFightGlobal) onBattleOver(ground *ground, result *proto.BattleResult) {
	results := result.Results
	roleKey1 := scheme.RoleKey{GameKey: ground.Role1.GameKey, ID: ground.Role1.RoleID}
	roleKey2 := scheme.RoleKey{GameKey: ground.Role2.GameKey, ID: ground.Role2.RoleID}
	log.Infof("ground %v %s vs %s, result %s, %s, attack frames %d", ground.ID, roleKey1, roleKey2, results[0], results[1], len(result.AttackFrames))
	if ground.Solo {
		g.onBattleOverSolo(ground, result)
		return
	}

	if results[0] == "" || results[1] == "" {
		g.notifyToGameBattleOver(&battleResult{
			roleKey: roleKey1,
			RoleID:  roleKey1.ID,
			Pattern: ground.pattern,
		}, &battleResult{
			roleKey: roleKey2,
			RoleID:  roleKey2.ID,
			Pattern: ground.pattern,
		})
		return
	}

	// 处理结果
	now := util.Now().Unix()
	frames := [2]int{len(result.BanPickInputSteps), len(result.AttackFrames)}
	history1 := &scheme.CrossOnlineFightHistory{
		Time:     now,
		Result:   results[0],
		CrossKey: g.key,
		Frames:   frames,
	}
	history2 := &scheme.CrossOnlineFightHistory{
		Time:     now,
		Result:   results[1],
		CrossKey: g.key,
		Frames:   frames,
	}
	result1 := &battleResult{
		roleKey:     roleKey1,
		RoleID:      roleKey1.ID,
		Pattern:     ground.pattern,
		Result:      results[0],
		EnemyResult: results[1],
	}
	result2 := &battleResult{
		roleKey:     roleKey2,
		RoleID:      roleKey2.ID,
		Pattern:     ground.pattern,
		Result:      results[1],
		EnemyResult: results[0],
	}

	db, unlock := g.LockAndGetDB()
	var rank1, rank2 int
	util.WithDefer(func() {
		sign := 1
		if results[1] == "win" {
			sign = 0
		}
		// 记录匹配战斗次数
		c1 := g.recordRepeated(roleKey1.ID, roleKey2.ID, sign == 1)
		c2 := g.recordRepeated(roleKey2.ID, roleKey1.ID, sign == 0)
		// 计算积分
		score1, n1, t1, w1 := g.getRoleScoreAndNTW(roleKey1.ID, ground.pattern, results[0] == "win", c1)
		score2, n2, t2, w2 := g.getRoleScoreAndNTW(roleKey2.ID, ground.pattern, results[1] == "win", c2)
		v1, v2 := scoreELO(score1, score2, 32, sign)
		score1 = int(v1*n1*w1 + t1)
		score2 = int(v2*n2*w2 + t2)
		g.updateRoleScore(roleKey1.ID, score1, sign == 1, ground.pattern)
		g.updateRoleScore(roleKey2.ID, score2, sign == 0, ground.pattern)
		g.recordRoleBattleResult(roleKey1.ID, sign == 1)
		g.recordRoleBattleResult(roleKey2.ID, sign == 0)

		// 更新排行榜
		g.refreshRank(ground.pattern)

		result1.Delta = score1
		result1.SyncRoleModel = g.syncRoleModel(result1.RoleID)
		result2.Delta = score2
		result2.SyncRoleModel = g.syncRoleModel(result2.RoleID)

		history1.Enemy = ground.Role2.CrossOnlineFightRole
		history1.Delta = score1
		history2.Enemy = ground.Role1.CrossOnlineFightRole
		history2.Delta = score2
		if ground.pattern == Unlimited {
			history1.Score = db.Roles[roleKey1.ID].UnlimitedScore
			history2.Score = db.Roles[roleKey2.ID].UnlimitedScore
			rank1 = g.unlimitRoleRanks[roleKey1.ID]
			rank2 = g.unlimitRoleRanks[roleKey2.ID]
		} else {
			history1.Score = db.Roles[roleKey1.ID].LimitedScore
			history2.Score = db.Roles[roleKey2.ID].LimitedScore
			rank1 = g.limitRoleRanks[roleKey1.ID]
			rank2 = g.limitRoleRanks[roleKey2.ID]
		}

	}, unlock)

	// 记录战报
	model := ground.PlayRecord
	combinePlayRecordResult(model, result, [2]int{result1.Delta, result2.Delta})
	play := g.builder.CreateCrossOnlineFightPlayRecord(model)
	log.Infof("ground %v play_id %v", ground.ID, play.GetID())
	history1.PlayRecordID = play.GetID()
	history2.PlayRecordID = play.GetID()

	// add history to remote record
	g.addBattleHistoryToRecord(roleKey1, ground.pattern, history1)
	g.addBattleHistoryToRecord(roleKey2, ground.pattern, history2)

	// notify game battle result
	g.notifyToGameBattleOver(result1, result2)

	if ground.pattern == Limited {
		g.recordLimitedCardResult(result)
	}

	cfg := GetConfig()
	limitRank := cfg.UnlimitedTopBattleRank
	if ground.pattern == Limited {
		limitRank = cfg.LimitedTopBattleRank
	}
	if rank1 <= limitRank || rank2 <= limitRank {
		// 精彩战报
		wonderful := result.Wonderful
		db, unlock := g.LockAndGetDB()
		util.WithDefer(func() {
			if !wonderful {
				if ground.pattern == Limited {
					wonderful = len(db.LimitedTopBattleHistory) < MaxTopHistory
				} else {
					wonderful = len(db.UnlimitedTopBattleHistory) < MaxTopHistory
				}
			}
			if wonderful {
				history := playRecord2TopHistory(g.key, model)
				history.PlayRecordID = play.GetID()
				history.Score = history1.Score
				history.Rank = rank1
				history.DefenceScore = history2.Score
				history.DefenceRank = rank2
				g.addTopHistory(history, ground.pattern)
			}
		}, unlock)
		if g.refreshTopHistory() {
			g.notifyToGameTopHistory()
		}
	}

	if ground.pattern == Unlimited {
		if g.unlimitedTrack != nil && (history1.Score >= 700 || history2.Score >= 700) { // 非限制赛700积分以上
			win := results[0] == "win"
			cards := schemeutil.CalcBattleCards(model.CardAttrs, model.Cards)
			defencecards := schemeutil.CalcBattleCards(model.DefenceCardAttrs, model.DefenceCards)
			g.unlimitedTrack.Track(win, cards)
			g.unlimitedTrack.Track(!win, defencecards)
		}
	} else if ground.pattern == Limited {
		if g.limitedTrack != nil { // 公平赛不限制排名
			win := results[0] == "win"
			cards := make([]int, 0, 12)
			defencecards := make([]int, 0, 12)
			cards = append(cards, schemeutil.CalcBattleCards(model.CardAttrs, model.Cards)...)
			defencecards = append(defencecards, schemeutil.CalcBattleCards(model.DefenceCardAttrs, model.DefenceCards)...)
			g.limitedTrack.Track(win, cards)
			g.limitedTrack.Track(!win, defencecards)
		}
	}
}

func (g *CrossOnlineFightGlobal) onBattleOverSolo(ground *ground, result *proto.BattleResult) {
	results := result.Results
	roleKey1 := scheme.RoleKey{GameKey: ground.Role1.GameKey, ID: ground.Role1.RoleID}
	if results[0] == "" || results[1] == "" {
		g.notifyToGameBattleOver(&battleResult{
			roleKey: roleKey1,
			RoleID:  roleKey1.ID,
			Pattern: ground.pattern,
		})
		return
	}

	now := util.Now().Unix()
	history1 := &scheme.CrossOnlineFightHistory{
		Time:     now,
		Result:   results[0],
		CrossKey: g.key,
		Frames:   [2]int{len(result.BanPickInputSteps), len(result.AttackFrames)},
	}
	result1 := &battleResult{
		roleKey:     roleKey1,
		RoleID:      roleKey1.ID,
		Pattern:     ground.pattern,
		Result:      results[0],
		EnemyResult: results[1],
	}
	db, unlock := g.LockAndGetDB()
	util.WithDefer(func() {
		sign := 1
		if results[1] == "win" {
			sign = 0
		}
		// 记录匹配战斗次数
		c1 := g.recordRepeated(roleKey1.ID, "", sign == 1)
		// 计算积分
		score1, n1, t1, w1 := g.getRoleScoreAndNTW(roleKey1.ID, ground.pattern, results[0] == "win", c1)
		v1, _ := scoreELO(score1, score1, 32, sign)
		score1 = int(v1*n1*w1 + t1)
		g.updateRoleScore(roleKey1.ID, score1, sign == 1, ground.pattern)
		g.recordRoleBattleResult(roleKey1.ID, sign == 1)

		// 更新排行榜
		g.refreshRank(ground.pattern)

		result1.Delta = score1
		result1.SyncRoleModel = g.syncRoleModel(result1.RoleID)
		history1.Enemy = ground.Role2.CrossOnlineFightRole
		history1.Delta = score1
		if ground.pattern == Unlimited {
			history1.Score = db.Roles[roleKey1.ID].UnlimitedScore
		} else {
			history1.Score = db.Roles[roleKey1.ID].LimitedScore
		}
	}, unlock)

	// 记录战报
	model := ground.PlayRecord
	combinePlayRecordResult(model, result, [2]int{result1.Delta, 0})
	play := g.builder.CreateCrossOnlineFightPlayRecord(model)
	log.Infof("ground %v play_id %v", ground.ID, play.GetID())
	history1.PlayRecordID = play.GetID()

	// add history to remote record
	g.addBattleHistoryToRecord(roleKey1, ground.pattern, history1)
	// notify game battle result
	g.notifyToGameBattleOver(result1)
}

func (g *CrossOnlineFightGlobal) onCrossBattleOver(ground *ground, result *proto.BattleResult) {
	competitor1 := ground.Role1
	competitor2 := ground.Role2
	// 处理 player1 结果
	g.onRemoteBattleOver(ground.pattern, ground.ID, competitor1.RoleID, competitor1, competitor2, ground.PlayRecord, result)

	// 通知对方cross，处理player2结果
	service.Call(g.container.GetService(ground.crossKey2), "CrossOnlineFightRemoteBattleNotifyEnd", ground.pattern, ground.ID, competitor2.RoleID, competitor1, competitor2, ground.PlayRecord, result)
}

// player1, player2 战斗结束
func (g *CrossOnlineFightGlobal) onRemoteBattleOver(pattern int, id document.ID, roleID document.ID, competitor1 *proto.Competitor, competitor2 *proto.Competitor, record *scheme.CrossOnlineFightPlayRecord, result *proto.BattleResult) {
	results := result.Results
	roleKey1 := scheme.RoleKey{GameKey: competitor1.GameKey, ID: competitor1.RoleID}
	roleKey2 := scheme.RoleKey{GameKey: competitor2.GameKey, ID: competitor2.RoleID}
	log.Infof("battle %v %s vs %s, result %s, %s, attack frames %d", id, roleKey1, roleKey2, results[0], results[1], len(result.AttackFrames))
	current := roleKey1
	if roleID == competitor2.RoleID {
		current = roleKey2
	}
	if results[0] == "" || results[1] == "" {
		// 战斗没有结果
		g.notifyToGameBattleOver(&battleResult{
			roleKey: current,
			RoleID:  roleID,
			Pattern: pattern,
		})
		return
	}

	sign := 1
	if results[1] == "win" {
		sign = 0
	}
	// 记录匹配战斗次数
	c1 := g.recordRepeated(roleKey1.ID, roleKey2.ID, sign == 1)
	c2 := g.recordRepeated(roleKey2.ID, roleKey1.ID, sign == 0)
	// 计算积分变化
	n1, t1, w1 := calcNTW(pattern, competitor1.Score, results[0] == "win", c1)
	n2, t2, w2 := calcNTW(pattern, competitor2.Score, results[1] == "win", c2)
	v1, v2 := scoreELO(competitor1.Score, competitor2.Score, 32, sign)
	delta1 := int(v1*n1*w1 + t1)
	delta2 := int(v2*n2*w2 + t2)

	// 处理结果
	var syncRoleModel *SyncRoleModel
	var score int // final score
	db, unlock := g.LockAndGetDB()
	util.WithDefer(func() {
		// 更新积分，记录结果，更新排行榜
		win := results[0] == "win"
		delta := delta1
		if roleID == competitor2.RoleID {
			win = results[1] == "win"
			delta = delta2
		}
		g.updateRoleScore(roleID, delta, win, pattern)
		g.recordRoleBattleResult(roleID, win)
		g.refreshRank(pattern)
		syncRoleModel = g.syncRoleModel(roleID)
		if pattern == Unlimited {
			score = db.Roles[roleID].UnlimitedScore
		} else {
			score = db.Roles[roleID].LimitedScore
		}
	}, unlock)

	// notify game battle result
	go func() {
		result := &battleResult{roleKey: current, RoleID: roleID, Pattern: pattern, SyncRoleModel: syncRoleModel}
		if roleID == competitor1.RoleID {
			result.Result = results[0]
			result.EnemyResult = results[1]
			result.Delta = delta1
		} else {
			result.Result = results[1]
			result.EnemyResult = results[0]
			result.Delta = delta2
		}
		g.notifyToGameBattleOver(result)
	}()

	// 记录战报
	combinePlayRecordResult(record, result, [2]int{delta1, delta2})
	play := g.builder.CreateCrossOnlineFightPlayRecord(record)
	log.Infof("ground %v play_id %v", id, play.GetID())

	// add history to remote record
	frames := [2]int{len(result.BanPickInputSteps), len(result.AttackFrames)}
	history := &scheme.CrossOnlineFightHistory{
		Time:         util.Now().Unix(),
		CrossKey:     g.key,
		Frames:       frames,
		PlayRecordID: play.GetID(),
	}
	if roleID == competitor1.RoleID {
		history.Result = results[0]
		history.Delta = delta1
		history.Enemy = competitor2.CrossOnlineFightRole
	} else {
		history.Result = results[1]
		history.Delta = delta2
		history.Enemy = competitor1.CrossOnlineFightRole
	}
	g.addBattleHistoryToRecord(current, pattern, history)

	if current.ID == roleKey1.ID { // 在 roleKey1 这边上报
		if pattern == Unlimited && g.unlimitedTrack != nil {
			win := results[0] == "win"
			cards := schemeutil.CalcBattleCards(record.CardAttrs, record.Cards)
			defencecards := schemeutil.CalcBattleCards(record.DefenceCardAttrs, record.DefenceCards)
			g.unlimitedTrack.Track(win, cards)
			g.unlimitedTrack.Track(!win, defencecards)
		} else if g.limitedTrack != nil {
			win := results[0] == "win"
			cards := schemeutil.CalcBattleCards(record.CardAttrs, record.Cards)
			defencecards := schemeutil.CalcBattleCards(record.DefenceCardAttrs, record.DefenceCards)
			g.limitedTrack.Track(win, cards)
			g.limitedTrack.Track(!win, defencecards)
		}
	}
}

func (g *CrossOnlineFightGlobal) resetRepeatedKeys() {
	g.repeatedMu.Lock()
	defer g.repeatedMu.Unlock()
	g.repeated = make(map[document.ID]map[document.ID]*counter)
}

func (g *CrossOnlineFightGlobal) checkRepeatedKeys(id, other document.ID) {
	if _, ok := g.repeated[id]; !ok {
		g.repeated[id] = make(map[document.ID]*counter)
	}
	if _, ok := g.repeated[id][other]; !ok {
		g.repeated[id][other] = &counter{}
	}
}

func (g *CrossOnlineFightGlobal) recordRepeated(id, other document.ID, win bool) int {
	g.repeatedMu.Lock()
	defer g.repeatedMu.Unlock()

	if win {
		g.checkRepeatedKeys(id, other)
		g.repeated[id][other].win += 1
		return g.repeated[id][other].win
	} else {
		g.checkRepeatedKeys(id, other)
		g.repeated[id][other].fail += 1
		return g.repeated[id][other].fail
	}
}

func (g *CrossOnlineFightGlobal) recordRoleBattleResult(id document.ID, win bool) {
	db := g.GetLockedDB()
	role := db.Roles[id]
	role.BattleTimes += 1
	if win {
		role.WinTimes += 1
	}
	g.SetRoles(db.Roles)
}

func (g *CrossOnlineFightGlobal) updateRoleScore(id document.ID, score int, win bool, pattern int) {
	log.Infof("role %s update pattern %d score %d", id, pattern, score)
	db := g.GetLockedDB()
	role := db.Roles[id]
	if pattern == Unlimited {
		role.UnlimitedScore += score
		if role.UnlimitedScore < 0 {
			role.UnlimitedScore = 0
		}
		if role.UnlimitedScore > role.UnlimitedTopScore {
			role.UnlimitedTopScore = role.UnlimitedScore
		}
		if win {
			role.UnlimitedRecord.Win += 1
			role.UnlimitedRecord.WinStreak += 1
			role.UnlimitedRecord.FailStreak = 0
		} else {
			role.UnlimitedRecord.Fail += 1
			role.UnlimitedRecord.FailStreak += 1
			role.UnlimitedRecord.WinStreak = 0
		}
	} else {
		role.LimitedScore += score
		if role.LimitedScore < 0 {
			role.LimitedScore = 0
		}
		if role.LimitedScore > role.LimitedTopScore {
			role.LimitedTopScore = role.LimitedScore
		}
		if win {
			role.LimitedRecord.Win += 1
			role.LimitedRecord.WinStreak += 1
			role.LimitedRecord.FailStreak = 0
		} else {
			role.LimitedRecord.Fail += 1
			role.LimitedRecord.FailStreak += 1
			role.LimitedRecord.WinStreak = 0
		}
	}
	g.SetRoles(db.Roles)
}

func (g *CrossOnlineFightGlobal) getRoleScoreAndNTW(id document.ID, pattern int, win bool, times int) (int, float64, float64, float64) {
	db := g.GetLockedDB()
	score := 0
	if pattern == Unlimited {
		score = db.Roles[id].UnlimitedScore
	} else {
		score = db.Roles[id].LimitedScore
	}
	p := GetConfig().GetNewbieProtect(score, pattern)
	if win {
		return score, p.winN, p.winT, p.repeatMatchFix(win, times-1)
	}
	return score, p.failN, p.failT, p.repeatMatchFix(win, times-1)
}

func (g *CrossOnlineFightGlobal) refreshRank(pattern int) {
	db := g.GetLockedDB()
	roles := db.Roles
	total := len(roles)
	ranks := &document.SortIDRanks{
		Keys: []string{"score", "win"},
		Ids:  make([]document.WeightID, 0, total),
	}
	unlimited := pattern == Unlimited
	for _, role := range roles {
		if unlimited {
			if role.UnlimitedRecord.Win+role.UnlimitedRecord.Fail == 0 {
				continue
			}
			ranks.Ids = append(ranks.Ids, document.WeightID{
				ID:      role.RoleID,
				Weights: map[string]int{"score": role.UnlimitedScore, "win": role.UnlimitedRecord.Win},
			})
		} else {
			if role.LimitedRecord.Win+role.LimitedRecord.Fail == 0 {
				continue
			}
			ranks.Ids = append(ranks.Ids, document.WeightID{
				ID:      role.RoleID,
				Weights: map[string]int{"score": role.LimitedScore, "win": role.LimitedScore},
			})
		}
	}
	sort.Sort(sort.Reverse(ranks))

	cache := make([]document.ID, 0, total)
	roleRanks := make(map[document.ID]int)
	for rank, v := range ranks.Ids {
		id := v.ID
		cache = append(cache, id)
		roleRanks[id] = rank + 1
	}
	if unlimited {
		g.unlimitRanks = cache
		g.unlimitRoleRanks = roleRanks
	} else {
		g.limitRanks = cache
		g.limitRoleRanks = roleRanks
	}
}

func (g *CrossOnlineFightGlobal) GetRankList(pattern int, offset, size int) []scheme.CrossOnlineFightRankRole {
	db, unlock := g.RLockAndGetDB()
	defer unlock()

	var ranks []document.ID
	if pattern == Unlimited {
		ranks = g.unlimitRanks
	} else {
		ranks = g.limitRanks
	}
	if offset+size > len(ranks) {
		ranks = ranks[offset:]
	} else {
		ranks = ranks[offset : offset+size]
	}

	ret := make([]scheme.CrossOnlineFightRankRole, 0, size)
	for _, id := range ranks {
		role := db.Roles[id]
		score := role.UnlimitedScore
		if pattern == Limited {
			score = role.LimitedScore
		}
		ret = append(ret, scheme.CrossOnlineFightRankRole{CrossOnlineFightRole: role.CrossOnlineFightRole, Score: score})
	}
	return ret
}

func (g *CrossOnlineFightGlobal) eventToGame(event string, data *EventToGame, sync bool, mergeFilter bool) map[string]*game.CrossOnlineFightEventResponse {
	if data == nil {
		data = &EventToGame{}
	}
	servers := g.Servers()
	if mergeFilter {
		servers = csv.GetMergeConfig().FilterMergeServer(servers)
	}

	d := make(map[string]interface{})
	for _, key := range servers {
		d[key] = data
	}
	return g.eventToSomeGame(event, d, sync)
}

func (g *CrossOnlineFightGlobal) eventToSomeGame(event string, d map[string]interface{}, sync bool) map[string]*game.CrossOnlineFightEventResponse {
	var model *SyncGameModel
	if sync {
		model = g.SyncGameModel()
	}
	response := make(map[string]*game.CrossOnlineFightEventResponse)
	err := cross.EventToSomeGame(g.container, "CrossOnlineFightEvent", event, d, model, func(key string, i interface{}) {
		response[key] = i.(*game.CrossOnlineFightEventResponse)
	})
	if err != nil {
		log.Warningf("CrossOnlineFightEvent %s response error %v", event, err)
		return nil
	}
	return response
}

func (g *CrossOnlineFightGlobal) recordLimitedCardResult(result *proto.BattleResult) {
	db, unlock := g.LockAndGetDB()
	defer unlock()
	for _, id := range result.Cards {
		if id != "" {
			cardid := document.Integer(result.CardAttrs[id].CardId)
			if _, ok := db.CardReport[cardid]; !ok {
				db.CardReport[cardid] = make(map[string]int)
			}
			db.CardReport[cardid][result.Results[0]] += 1
		}
	}
	for _, id := range result.DefenceCards {
		if id != "" {
			cardid := document.Integer(result.DefenceCardAttrs[id].CardId)
			if _, ok := db.CardReport[cardid]; !ok {
				db.CardReport[cardid] = make(map[string]int)
			}
			db.CardReport[cardid][result.Results[1]] += 1
		}
	}
	g.SetCardReport(db.CardReport)
}

func (g *CrossOnlineFightGlobal) newVerifyer(id document.ID, role1, role2 document.ID) *verifyer {
	time1, _ := g.roleMatchTimes.Load(role1)
	time2, _ := g.roleMatchTimes.Load(role2)
	v := &verifyer{
		id:    id,
		role1: role1,
		role2: role2,
		time1: time1,
		time2: time2,
	}
	g.roleMatchResult.Store(role1, v)
	g.roleMatchResult.Store(role2, v)
	return v
}

func (g *CrossOnlineFightGlobal) checkVerifyer(address string, verifyer *verifyer) []document.ID {
	valid := address != ""
	v1, ok1 := g.roleMatchResult.Load(verifyer.role1)
	v2, ok2 := g.roleMatchResult.Load(verifyer.role2)
	valid = valid && ok1 && v1 == verifyer
	valid = valid && ok2 && v2 == verifyer
	if !valid {
		discards := make([]document.ID, 0, 2)
		if v, ok := g.roleMatchTimes.Load(verifyer.role1); ok {
			if v == verifyer.time1 {
				discards = append(discards, verifyer.role1)
			}
		}
		if v, ok := g.roleMatchTimes.Load(verifyer.role2); ok {
			if v == verifyer.time2 {
				discards = append(discards, verifyer.role2)
			}
		}
		return discards
	}
	return nil
}

func calcNTW(pattern int, score int, win bool, times int) (float64, float64, float64) {
	p := GetConfig().GetNewbieProtect(score, pattern)
	if win {
		return p.winN, p.winT, p.repeatMatchFix(win, times-1)
	}
	return p.failN, p.failT, p.repeatMatchFix(win, times-1)
}

func scoreELO(rating1, rating2 int, k float64, sign int) (float64, float64) {
	x := float64(rating1-rating2) / 400
	eb := 1.0 / (1 + math.Pow(10, x))
	ea := 1 - eb
	if sign == 1 {
		return k * (1 - ea), k * (0 - eb)
	} else {
		return k * (0 - ea), k * (1 - eb)
	}
}

type verifyer struct {
	id    document.ID
	role1 document.ID
	role2 document.ID
	time1 interface{}
	time2 interface{}
}

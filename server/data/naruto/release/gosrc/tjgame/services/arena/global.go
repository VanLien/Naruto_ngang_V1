package arena

import (
	"errors"
	"math"
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
)

var (
	ErrRankChanged      = errors.New("rankChanged")
	ErrInBattle         = errors.New("rankEnemyBattling")
	ErrNotInBattle      = errors.New("not in battle")
	ErrRankEnemyChanged = errors.New("rankEnemyChanged")
	ErrRankCheat        = errors.New("rankCheat")
)

type viefor struct {
	role        document.ID
	record      document.ID
	enemy       document.ID
	enemyRecord document.ID
	time        int64
}

type battle struct {
	playRecord    document.ID
	enemyRoleID   document.ID
	enemyRecordID document.ID
	battleRank    int

	mu     sync.Mutex
	result result
}

type result struct {
	client    string
	anticheat string
	view      map[string]int
}

// Arena
type Arena struct {
	*scheme.ArenaGlobalObject
	container service.IContainer
	builder   *Builder
	key       string

	vieRankQue map[document.ID]viefor
	battles    sync.Map // map[document.ID]battle

	roleRanks map[document.ID]document.Integer // {roleID: rank}

	cache top50cache

	rank1Robot document.ID // 排名第一若是机器人，则记录id, 方便后面排除
}

func (arena *Arena) init(builder *Builder, key string) {
	arena.builder = builder
	arena.key = key
	arena.vieRankQue = make(map[document.ID]viefor)
	arena.roleRanks = make(map[document.ID]document.Integer, arena.RankMax())
	ranks := arena.Ranks()
	for rank, rr := range ranks {
		arena.roleRanks[rr[0]] = rank
	}
	arena.cache.init()
	for i := 0; i < TopRankMax; i++ {
		rr := ranks[document.Integer(i+1)]
		arena.cache.setTop50(i+1, rr[0], rr[1])
	}
}

func (arena *Arena) lastNextRank() int {
	arena.Lock()
	defer arena.Unlock()
	rank := arena.RankMax() + 1
	arena.SetRankMax(rank)
	return int(rank)
}

func (arena *Arena) setNewestRank(record *Record) {
	arena.Lock()
	defer arena.Unlock()
	roleID := record.RoleDbId()
	rank, ok := arena.roleRanks[roleID]
	if !ok {
		log.Warningf("role %v no rank", roleID)
	}
	record.SetRank(int(rank))
}

func (arena *Arena) join(rank int, roleId document.ID, recordID document.ID) {
	arena.Lock()
	defer arena.Unlock()
	arena.Ranks()[document.Integer(rank)] = [2]document.ID{roleId, recordID}
	arena.SetDirty("ranks")
	arena.roleRanks[roleId] = document.Integer(rank)
	if rank <= TopRankMax {
		arena.cache.setTop50(rank, roleId, recordID)
	}
}

func (arena *Arena) getRoleRecordIDs(ranks []int) []ranktuple {
	ret := make([]ranktuple, 0, len(ranks))
	db, unlock := arena.RLockAndGetDB()
	defer unlock()

	for _, rank := range ranks {
		if rr, ok := db.Ranks[document.Integer(rank)]; ok {
			ret = append(ret, ranktuple{Rank: rank, RoleID: rr[0], RecordID: rr[1]})
		}
	}
	return ret
}

func (arena *Arena) swapRank(oldRank document.Integer, newRank document.Integer) {
	ranks := arena.Ranks()
	oldrole := ranks[oldRank]
	newrole := ranks[newRank]
	// 交换排名
	ranks[oldRank] = newrole
	ranks[newRank] = oldrole
	arena.SetRanks(ranks)
	arena.roleRanks[newrole[0]] = oldRank
	arena.roleRanks[oldrole[0]] = newRank
	// 更新top50
	if oldRank <= TopRankMax {
		arena.cache.setTop50(int(oldRank), newrole[0], newrole[1])
	}
	if newRank <= TopRankMax {
		arena.cache.setTop50(int(newRank), oldrole[0], oldrole[1])
	}
}

func (arena *Arena) storeForRole(rank int, roleID, recordID, enemyRoleID, enemyRecordID document.ID) error {
	db, unlock := arena.LockAndGetDB()
	defer unlock()

	rr := db.Ranks[document.Integer(rank)]
	if rr[0] != enemyRoleID && rr[1] != enemyRecordID {
		return ErrRankEnemyChanged
	}

	if v, ok := arena.vieRankQue[enemyRoleID]; ok {
		if time.Now().Unix()-v.time < 60 {
			return ErrInBattle
		}
	}

	arena.vieRankQue[enemyRoleID] = viefor{roleID, recordID, enemyRoleID, enemyRecordID, time.Now().Unix()}

	return nil
}

func (arena *Arena) resultForRole(roleID document.ID, enemyRoleID document.ID, result string) (int, int, error) {
	// lock for swapRank and arena self
	_, unlock := arena.LockAndGetDB()
	defer unlock()

	v, ok := arena.vieRankQue[enemyRoleID]
	if !ok {
		return 0, 0, ErrNotInBattle
	}
	if v.role != roleID {
		return 0, 0, errors.New("not your battle")
	}
	delete(arena.vieRankQue, enemyRoleID)
	oldRank := arena.roleRanks[roleID]
	newRank := arena.roleRanks[enemyRoleID]
	if result == "win" && oldRank > newRank {
		arena.swapRank(oldRank, newRank)
	}
	return int(oldRank), int(newRank), nil
}

func (arena *Arena) RangeRanks(f func(rank int, roleID document.ID, recordID document.ID) bool, start, end int) {
	db, unlock := arena.RLockAndGetDB()
	defer unlock()

	if start > 0 && end > 0 {
		for start <= end {
			if rr, ok := db.Ranks[document.Integer(start)]; ok {
				if !f(start, rr[0], rr[1]) {
					break
				}
			}
			start++
		}
	} else {
		for rank, rr := range db.Ranks {
			if !f(int(rank), rr[0], rr[1]) {
				break
			}
		}
	}
}

type BattleCard struct {
	// ArenaHuntingRecord.id
	RecordID document.ID `bson:"record_id" codec:"record_id" index:"true"`
	// 玩家id
	RoleDbID document.ID `bson:"role_db_id" codec:"role_db_id"`
	// 区服
	GameKey string `bson:"game_key" codec:"game_key"`
	// 防守战力和
	FightingPoint int `bson:"fighting_point" codec:"fighting_point"`
}

func (arena *Arena) getOpenDays() int {
	gameServer := arena.container.GetService(arena.key)
	if gameServer == nil {
		return 0
	}
	resp, err := service.Call(gameServer, "GetOpenDays", arena.key)
	if err != nil {
		return 0
	}
	return resp.(int)
}

// 生成 远征防守阵容名单
func (arena *Arena) genHuntingBattleCards(crossHuntingKey string) (bool, error) {
	// TODO 数量根据开服时间决定
	days := arena.getOpenDays()
	if days == 0 {
		log.Warningf("genHuntingBattleCards openDays event may be some error happened")
	}
	num := 200
	for _, cfg := range csv.GetConfig().Cross.Hunting.Defence_num {
		if days >= cfg.OpenDays.ToIntSlice()[0] && days < cfg.OpenDays.ToIntSlice()[1] {
			num = cfg.DeployNum
			break
		}
	}
	var battleCards []*BattleCard
	aRecordIDList := make([]document.ID, 0, num)
	util.WithGuard(arena, func() {
		for i := 1; i <= num; i++ {
			if rr, ok := arena.Ranks()[document.Integer(i)]; ok {
				aRecordIDList = append(aRecordIDList, rr[1])
			}
		}
	})
	for _, aRecordID := range aRecordIDList {
		aRecord := arena.builder.GetArenaRecord(aRecordID)
		if aRecord.Robot() {
			continue
		}
		allFP := 0
		for _, cardAttrs := range aRecord.DefenceCardAttrs() {
			// 有修正用修正，没修正用原来
			if cardAttrs.FightingPoint2 == 0 {
				allFP += cardAttrs.FightingPoint
			} else {
				allFP += cardAttrs.FightingPoint2
			}
		}
		arenaHuntingRecord := arena.builder.CreateArenaHuntingRecord(aRecord.RoleDbId())
		battleCards = append(battleCards, &BattleCard{RecordID: arenaHuntingRecord.GetID(), RoleDbID: aRecord.RoleDbId(), GameKey: arena.key, FightingPoint: allFP})
	}
	serviceCross := arena.container.GetService(crossHuntingKey)
	if serviceCross == nil {
		return false, errors.New("arena crossHuntingKey error")
	}
	_, err := service.CallWithTimeout(serviceCross, "GenHuntingBattleCards", time.Second*15, arena.key, battleCards)
	if err != nil {
		return false, err
	}
	return true, nil
}

// ArenaGlobalHistory
type GlobalHistory struct {
	*scheme.ArenaGlobalHistoryObject
}

func (h *GlobalHistory) getAward(roleID document.ID) int {
	db, unlock := h.LockAndGetDB()
	defer unlock()

	if rank, ok := db.OfflineRoleRanks[roleID]; ok {
		delete(db.OfflineRoleRanks, roleID)
		h.SetDirty("offline_role_ranks")
		return rank
	}
	return 0
}

func NewArenaGlobalHistory(arena *Arena, excludes []document.ID) (*scheme.ArenaGlobalHistory, []int, map[document.ID]int) {
	allRanks := make(map[document.ID]int)
	arena.RangeRanks(func(rank int, roleID document.ID, recordID document.ID) bool {
		if rank == 1 && roleID == arena.rank1Robot {
			return true
		}
		allRanks[roleID] = rank
		return true
	}, -1, -1)

	onlines := make(map[document.ID]bool)
	for _, roleID := range excludes {
		onlines[roleID] = true
	}

	offlineRoleRanks := make(map[document.ID]int)
	allRoleRanks := make(map[document.ID]int)
	for roleID, rank := range allRanks {
		allRoleRanks[roleID] = rank
		if _, ok := onlines[roleID]; !ok {
			offlineRoleRanks[roleID] = rank
		}
	}

	onlineRanks := make([]int, len(excludes))
	for i, roleID := range excludes {
		onlineRanks[i] = allRoleRanks[roleID]
	}

	return &scheme.ArenaGlobalHistory{
		Key:              arena.Key(),
		AwardTime:        util.Nowtime2int(),
		OfflineRoleRanks: offlineRoleRanks,
		AllRanks:         allRoleRanks,
	}, onlineRanks, allRanks
}

type historys map[int]*GlobalHistory

func (hs historys) add(history *GlobalHistory) {
	hs[history.AwardTime()] = history
	if len(hs) > GlobalHistoryMax {
		min := history.AwardTime()
		for k := range hs {
			if min > k {
				min = k
			}
		}
		delete(hs, min)
	}
}

func (hs historys) getRoleRankHistory(roleID document.ID) [][2]int {
	if len(hs) == 0 {
		return nil
	}
	ret := make([][2]int, 0, len(hs))
	for _, history := range hs {
		rank := history.getAward(roleID)
		if rank > 0 {
			ret = append(ret, [2]int{history.AwardTime(), rank})
		}
	}
	return ret
}

type top50cache struct {
	changed bool
	top50   [TopRankMax][2]document.ID // idx: rank, value: roleID
	models  [TopRankMax]*SlimModel
	cache   map[document.ID]*SlimModel
}

func (c *top50cache) init() {
	c.cache = make(map[document.ID]*SlimModel)
}

func (c *top50cache) setTop50(rank int, roleID document.ID, recordID document.ID) {
	c.top50[rank-1] = [2]document.ID{roleID, recordID}
	if _, ok := c.cache[roleID]; ok {
		c.cache[roleID].Rank = rank
	}
	c.changed = true
}

func (c *top50cache) setTop50Model(roleID document.ID, record *Record, force bool) {
	model := c.cache[roleID]
	if model == nil {
		if force {
			m := record.slimModelLocked()
			c.cache[roleID] = &m
		}
	} else {
		db, unlock := record.RLockAndGetDB()
		defer unlock()
		model.Name = db.RoleName
		model.Level = db.RoleLevel
		model.Logo = db.RoleLogo
		model.Frame = db.RoleFrame
		model.Rank = db.Rank
		model.FightingPoint = db.FightingPoint
		model.Display = db.Display
	}
}

func (c *top50cache) getTop50ModelMiss() [][2]document.ID {
	miss := make([][2]document.ID, 0, TopRankMax)
	if !c.changed {
		return miss
	}
	for i := 0; i < TopRankMax; i++ {
		if c.top50[i][0] == "" {
			continue
		}
		if _, ok := c.cache[c.top50[i][0]]; !ok {
			miss = append(miss, c.top50[i])
		}
	}
	return miss
}

func (c *top50cache) refresh(arena *Arena) {
	if !c.changed {
		return
	}
	for i, rr := range c.top50 {
		roleID := rr[0]
		model, ok := c.cache[roleID]
		if roleID == "" || !ok {
			c.models[i] = nil
			continue
		}
		c.models[i] = model
	}
	// 清理缓存
	if len(c.cache) > 200 {
		valid := make(map[document.ID]*SlimModel)
		for _, model := range c.models {
			valid[model.RoleDbId] = model
		}
		c.cache = valid
	}
	c.changed = false
}

func (c *top50cache) top(offset int, size int) []SlimModel {
	top := make([]SlimModel, 0, size)
	end := offset + size
	if end >= TopRankMax {
		end = TopRankMax
	}
	for i := offset; i < end; i++ {
		if c.models[i] == nil {
			break
		}
		top = append(top, *c.models[i])
	}
	return top
}

type Range interface {
	start() int
	end() int
	in(rank int) bool
}

type Ranges []Range

func (rs Ranges) GetRange(rank int) Range {
	max := len(rs)
	idx := sort.Search(max, func(i int) bool {
		return rs[i].start() > rank
	})
	idx -= 1
	if idx >= 0 && rs[idx].in(rank) {
		return rs[idx]
	}
	return nil
}

func (rs Ranges) Len() int {
	return len(rs)
}

func (rs Ranges) Less(i, j int) bool {
	return rs[i].start() < rs[j].start()
}

func (rs Ranges) Swap(i, j int) {
	rs[i], rs[j] = rs[j], rs[i]
}

func NewRanges(ranges ...Range) Ranges {
	rs := make(Ranges, 0, len(ranges))
	rs = append(rs, ranges...)
	sort.Sort(rs)
	return rs
}

type CSVRange [2]int

func (r CSVRange) start() int {
	return r[0]
}

func (r CSVRange) end() int {
	return r[1]
}

func (r CSVRange) in(rank int) bool {
	return r.start() <= rank && rank < r.end()
}

type PWRange struct {
	CSVRange
	ranges [][2]float64
}

func (r *PWRange) getEnemys(rank, limit, rankMax int) []int {
	if !r.in(rank) {
		return nil
	}
	enemys := make([]int, 0, limit)
	if rank < limit {
		for i := 1; i < limit+2; i++ {
			if i != rank {
				enemys = append(enemys, i)
			}
		}
		return enemys
	}

	existed := map[int]bool{rank: true}
	existed[rank] = true
	for _, x := range r.ranges {
		choose := 0
		left, right := int(math.Ceil(float64(rank)*x[0])), int(math.Ceil(float64(rank)*x[1]))
		if right > rankMax {
			right = rankMax
		}
		if left < right {
			for i := 0; i < 10; i++ {
				r := rand.Intn(right-left) + left
				if _, ok := existed[r]; !ok {
					choose = r
					break
				}
			}
			if choose != 0 {
				existed[choose] = true
			} else {
				log.Warningf("pw battle.csv range too small %d %d %v", rank, limit, x)
			}
		} else {
			choose = left
		}
		if choose > 0 {
			enemys = append(enemys, choose)
		}
	}
	return enemys
}

func NewPWRange(cfg *csv.Pwbattle) *PWRange {
	r := &PWRange{
		CSVRange: [2]int{int(cfg.Range[0].(int64)), int(cfg.Range[1].(int64))},
	}

	str2num := func(s string) float64 {
		num, _ := strconv.ParseFloat(s[:len(s)-1], 64)
		num /= 100
		return num
	}
	r.ranges = make([][2]float64, 0, 4)
	r.ranges = append(r.ranges, [2]float64{str2num(cfg.EnemyRange1[0].(string)), str2num(cfg.EnemyRange1[1].(string))})
	r.ranges = append(r.ranges, [2]float64{str2num(cfg.EnemyRange2[0].(string)), str2num(cfg.EnemyRange2[1].(string))})
	r.ranges = append(r.ranges, [2]float64{str2num(cfg.EnemyRange3[0].(string)), str2num(cfg.EnemyRange3[1].(string))})
	r.ranges = append(r.ranges, [2]float64{str2num(cfg.EnemyRange4[0].(string)), str2num(cfg.EnemyRange4[1].(string))})
	return r
}

type Config struct {
	PWRanges Ranges
}

var config atomic.Value

func GetConfig() *Config {
	return config.Load().(*Config)
}

func LoadConfig() error {
	ranges := make([]Range, 0, len(csv.GetConfig().Pwbattle))
	for _, cfg := range csv.GetConfig().Pwbattle {
		ranges = append(ranges, NewPWRange(cfg))
	}

	v := &Config{
		PWRanges: NewRanges(ranges...),
	}
	config.Store(v)
	return nil
}

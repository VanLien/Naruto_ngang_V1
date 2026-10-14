package onlinefight

import (
	"errors"
	"sort"
	"sync"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
)

type item struct {
	id            document.ID
	time          time.Time
	fightingPoint int
}

type competitor struct {
	id            document.ID
	score         int
	winstreak     bool // 连胜
	failstreak    bool // 连负
	cards         []int
	fightingPoint int
	bucket        *bucket
	time          time.Time
	timeout       time.Duration
}

type bucket struct {
	idx   int
	scope []int

	priorityHighRange   []int // 连胜优先匹配区间偏移值
	extendHighRange     []int // 连胜扩展区间匹配偏移值
	priorityNormalRange []int // 正常优先匹配区间偏移值
	extendNormalRange   []int // 正常扩展区间匹配偏移值
	priorityLowRange    []int // 连败优先匹配区间偏移值
	extendLowRange      []int // 连败扩展区间匹配偏移值

	ids map[document.ID]*item
}

func (t *bucket) add(id document.ID, item *item) {
	t.ids[id] = item
}

func (t *bucket) discard(id document.ID) {
	delete(t.ids, id)
}

func (t *bucket) inScope(score int) bool {
	return score >= t.scope[0] && score < t.scope[1]
}

// 按时间顺序匹配
func (t *bucket) match(id document.ID, matched map[document.ID]bool) document.ID {
	ranks := make([]*item, 0, len(t.ids))
	for k, v := range t.ids {
		if k == id || matched[k] {
			continue
		}
		ranks = append(ranks, v)
	}
	if len(ranks) == 0 {
		return ""
	}
	sort.SliceStable(ranks, func(i, j int) bool {
		return ranks[i].time.Before(ranks[j].time)
	})
	return ranks[0].id
}

// 尽量匹配战力相近的
func (t *bucket) match2(id document.ID, matched map[document.ID]bool) document.ID {
	ranks := make([]*item, 0, len(t.ids))
	for k, v := range t.ids {
		if k == id || matched[k] {
			continue
		}
		ranks = append(ranks, v)
	}
	if len(ranks) == 0 {
		return ""
	}
	base := t.ids[id].fightingPoint
	sort.SliceStable(ranks, func(i, j int) bool {
		return ranks[i].fightingPoint > ranks[j].fightingPoint
	})
	current := sort.Search(len(ranks), func(i int) bool {
		return ranks[i].fightingPoint <= base
	})
	if current >= len(ranks)-1 {
		return ranks[len(ranks)-1].id
	}
	return ranks[current].id
}

type Lobby struct {
	mu      sync.Mutex
	roles   map[document.ID]*competitor
	waiting []document.ID
	buckets []*bucket

	id        int
	pattern   int
	onMatched func(role1, role2 *competitor)
	onDiscard func(ids []document.ID)
	timer     *time.Timer
}

func (l *Lobby) Match(id document.ID, score int, time time.Time, winstreak, failstreak bool, cards []int, fightingPoint int, timeout time.Duration) error {
	l.mu.Lock()
	defer l.mu.Unlock()

	if _, ok := l.roles[id]; ok {
		return ErrAlreadyInMatching
	}

	// 1. add role to matching
	var bucket *bucket
	for _, t := range l.buckets {
		if t.inScope(score) {
			bucket = t
			break
		}
	}
	if bucket == nil {
		bucket = l.buckets[len(l.buckets)-1]
	}

	log.Debugf("lobby %d role %v score %d, winstreak %v, failstreak %v,  join match, bucket %d, scope %v", l.id, id, score, winstreak, failstreak, bucket.idx, bucket.scope)

	role := &competitor{
		id:            id,
		score:         score,
		winstreak:     winstreak,
		failstreak:    failstreak,
		time:          time,
		timeout:       timeout,
		cards:         cards,
		fightingPoint: fightingPoint,
		bucket:        bucket,
	}
	l.roles[id] = role
	bucket.add(id, &item{id: id, time: time, fightingPoint: fightingPoint})
	l.waiting = append(l.waiting, id)

	// 2. try start match loop
	l.tryLoop()

	return nil
}

func (l *Lobby) MatchCancel(id document.ID) error {
	l.mu.Lock()
	defer l.mu.Unlock()

	if role, ok := l.roles[id]; !ok {
		return errors.New("not in matching")
	} else {
		i := 0
		for idx, ii := range l.waiting {
			if id == ii {
				i = idx
				break
			}
		}
		l.waiting = append(l.waiting[:i], l.waiting[i+1:]...)
		delete(l.roles, id)
		role.bucket.discard(id)
		role.bucket = nil
	}
	return nil
}

func (l *Lobby) tryLoop() {
	if l.timer == nil {
		l.timer = time.NewTimer(time.Second)
		go func() {
			for {
				<-l.timer.C
				resume := true
				util.WithGuard(&l.mu, func() {
					resume = l.loop()
					if resume {
						l.timer.Reset(time.Second)
					} else {
						l.timer.Stop()
						l.timer = nil
					}
				})
				if !resume {
					break
				}
			}
		}()
	}
}

func (l *Lobby) loop() bool {
	now := util.Now()
	matched := make(map[document.ID]bool)
	rolepairs := make([][2]*competitor, 0, 8)

	for _, id := range l.waiting {
		// 1. is matched
		if matched[id] {
			continue
		}

		// 2. select match bucket
		role := l.roles[id]
		if now.Sub(role.time) < 5*time.Second { // 强制等待5秒
			continue
		}
		buckets := make([]*bucket, 0, 3)
		offset := make([]int, 0, 6)
		// 优先区间匹配
		if role.winstreak {
			offset = append(offset, role.bucket.priorityHighRange...)
		} else if role.failstreak {
			offset = append(offset, role.bucket.priorityLowRange...)
		} else {
			offset = append(offset, role.bucket.priorityNormalRange...)
		}
		if now.Sub(role.time) > 20*time.Second {
			// 扩展区间匹配
			if role.winstreak {
				offset = append(offset, role.bucket.extendHighRange...)
			} else if role.failstreak {
				offset = append(offset, role.bucket.extendLowRange...)
			} else {
				offset = append(offset, role.bucket.extendNormalRange...)
			}
		}
		for _, i := range offset {
			i = role.bucket.idx + i
			if i >= 0 && i < len(l.buckets) {
				buckets = append(buckets, l.buckets[i])
			}
		}

		// 3. match
		matchRole := document.ID("")
		for _, bucket := range buckets {
			// 优先相同积分
			for k := range bucket.ids {
				if k == id {
					continue
				}
				if role.score == l.roles[k].score {
					matchRole = k
				}
			}
			if matchRole == "" {
				if l.pattern == 1 { // 非限制赛
					//matchRole = bucket.match2(id, matched)
					matchRole = bucket.match(id, matched) // 先不用战力相关的
				} else {
					matchRole = bucket.match(id, matched)
				}
			}
			if matchRole != "" {
				break
			}
		}
		if matchRole != "" {
			matched[id] = true
			matched[matchRole] = true
			rolepairs = append(rolepairs, [2]*competitor{role, l.roles[matchRole]})
		}
	}

	discards := make([]document.ID, 0, 8)
	waiting := make([]document.ID, 0, len(l.waiting))
	for _, id := range l.waiting {
		role := l.roles[id]
		if matched[id] {
			delete(l.roles, id)
			role.bucket.discard(id)
			role.bucket = nil
			continue
		}
		if now.Sub(l.roles[id].time) > role.timeout {
			delete(l.roles, id)
			role.bucket.discard(id)
			role.bucket = nil
			discards = append(discards, id)
			continue
		}
		waiting = append(waiting, id)
	}
	l.waiting = waiting
	elapsed := util.Now().Sub(now)
	log.Infof("lobby %d match loop end, waiting %d, matched %d, discard %d, elapsed %dms", l.id, len(l.waiting), len(matched), len(discards), elapsed.Milliseconds())

	for _, pair := range rolepairs {
		l.onMatched(pair[0], pair[1])
	}
	go l.onDiscard(discards)

	return len(l.waiting) > 0
}

func NewLobby(id int, pattern int, scopes []*csv.Cross_online_fight_match, onMatched func(*competitor, *competitor), onDiscard func([]document.ID)) *Lobby {
	l := &Lobby{
		roles:     make(map[document.ID]*competitor),
		waiting:   make([]document.ID, 0, 8),
		buckets:   make([]*bucket, 0, 8),
		id:        id,
		pattern:   pattern,
		onMatched: onMatched,
		onDiscard: onDiscard,
	}

	for i, cfg := range scopes {
		t := &bucket{
			idx:                 i,
			scope:               cfg.Range.ToIntSlice(),
			priorityHighRange:   cfg.PriorityHighRange.ToIntSlice(),
			extendHighRange:     make([]int, 0, 8),
			priorityNormalRange: cfg.PriorityNormalRange.ToIntSlice(),
			extendNormalRange:   make([]int, 0, 8),
			priorityLowRange:    cfg.PriorityLowRange.ToIntSlice(),
			extendLowRange:      make([]int, 0, 8),
			ids:                 make(map[document.ID]*item),
		}
		t.extendHighRange = append(t.extendHighRange, cfg.PriorityHighRange.ToIntSlice()...)
		t.extendHighRange = append(t.extendHighRange, cfg.ExtendHighRange.ToIntSlice()...)
		t.extendNormalRange = append(t.extendNormalRange, cfg.PriorityNormalRange.ToIntSlice()...)
		t.extendNormalRange = append(t.extendNormalRange, cfg.ExtendNormalRange.ToIntSlice()...)
		t.extendLowRange = append(t.extendLowRange, cfg.PriorityLowRange.ToIntSlice()...)
		t.extendLowRange = append(t.extendLowRange, cfg.ExtendLowRange.ToIntSlice()...)

		l.buckets = append(l.buckets, t)
	}
	return l
}

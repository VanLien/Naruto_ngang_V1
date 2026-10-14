package arena

import (
	"math"
	"math/rand"
	"sort"
	"strconv"
	"strings"
	"sync/atomic"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/server_framework/tj/log"
)

// Range
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

// Config
type Config struct {
	PWRanges                Ranges
	MinStageID              int
	TopBattleHistoryPeriods []int
	MinStageToRank          map[int]int
}

var config atomic.Value

func GetConfig() *Config {
	return config.Load().(*Config)
}

func LoadConfig() error {
	conf := csv.GetConfig()
	ranges := make([]Range, 0, len(conf.Cross.Arena.Pw_matching))
	for _, cfg := range conf.Cross.Arena.Pw_matching {
		ranges = append(ranges, NewPWRange(cfg))
	}
	cfgBase := conf.Cross.Arena.Base[1]
	minStageToRank := map[int]int{}
	for _, cfg := range conf.Cross.Arena.Stage {
		if cfg.StageID == cfgBase.MinStageID {
			if v, ok := minStageToRank[cfg.Version]; ok {
				if int(cfg.Range[1].(int64)) > v {
					minStageToRank[cfg.Version] = int(cfg.Range[1].(int64))
				}
			} else {
				minStageToRank[cfg.Version] = int(cfg.Range[1].(int64))
			}
		}
	}

	v := &Config{
		PWRanges:       NewRanges(ranges...),
		MinStageID:     cfgBase.MinStageID,
		MinStageToRank: minStageToRank,
	}
	v.TopBattleHistoryPeriods = make([]int, len(cfgBase.TopBattleHistoryPeriods))
	for i, peroid := range cfgBase.TopBattleHistoryPeriods {
		v.TopBattleHistoryPeriods[i] = int(peroid.(int64))
	}
	config.Store(v)
	return nil
}

// CSVRange
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

// PWRange
type PWRange struct {
	CSVRange
	ranges [][2]float64
}

func NewPWRange(cfg *csv.Cross_arena_pw_matching) *PWRange {
	r := &PWRange{
		CSVRange: [2]int{int(cfg.Range[0].(int64)), int(cfg.Range[1].(int64))},
	}

	r.ranges = make([][2]float64, 0, 4)
	r.ranges = append(r.ranges, [2]float64{str2num(cfg.EnemyRange1[0].(string)), str2num(cfg.EnemyRange1[1].(string))})
	r.ranges = append(r.ranges, [2]float64{str2num(cfg.EnemyRange2[0].(string)), str2num(cfg.EnemyRange2[1].(string))})
	r.ranges = append(r.ranges, [2]float64{str2num(cfg.EnemyRange3[0].(string)), str2num(cfg.EnemyRange3[1].(string))})
	r.ranges = append(r.ranges, [2]float64{str2num(cfg.EnemyRange4[0].(string)), str2num(cfg.EnemyRange4[1].(string))})
	return r
}

func (r *PWRange) getEnemys(rank, limit, rankMax int) []int {
	if !r.in(rank) {
		return nil
	}
	enemys := make([]int, 0, limit)

	existed := map[int]bool{rank: true}
	for _, x := range r.ranges {
		choose := 0
		left, right := int(math.Ceil(float64(rank)*x[0])), int(math.Ceil(float64(rank)*x[1]))
		if right > rankMax {
			right = rankMax
		}
		if left > rankMax {
			left = rankMax
		}
		if left < right {
			for i := 0; i < 10; i++ {
				r := rand.Intn(right-left) + left
				if _, ok := existed[r]; !ok {
					choose = r
					break
				}
			}
			if choose == 0 {
				log.Warningf("pw battle.csv range too small %d %d %v", rank, limit, x)
			}
		} else {
			if _, ok := existed[left]; !ok {
				choose = left
			}
		}
		if choose > 0 {
			existed[choose] = true
			enemys = append(enemys, choose)
		}
	}
	return enemys
}

// string => num
func str2num(s string) float64 {
	num, _ := strconv.ParseFloat(s[:len(s)-1], 64)
	num /= 100
	return num
}

// openDays => robotNum
func calcRobotNum(openDays int64) int {
	robotNum := 0
	config := csv.GetConfig()
	for i := 1; i < 999; i++ {
		cfg := config.Cross.Arena.Robot[i]
		if cfg == nil {
			break
		}
		if cfg.DaysRange[0].(int64) <= openDays && openDays < cfg.DaysRange[1].(int64) {
			robotNum = cfg.Num
			break
		}
	}
	return robotNum
}

func isRobot(id document.ID) bool {
	s := string(id)
	return strings.HasPrefix(s, "rbt")
}

func min(a, b int) int {
	min := 0
	if a > b {
		min = b
	} else {
		min = a
	}
	return min
}

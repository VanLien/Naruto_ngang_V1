package hunting

import (
	"encoding/json"
	"io/ioutil"
	"sort"
	"sync/atomic"
	"tjgame/csv"
	"tjgame/server_framework/tj/service"
)

var config atomic.Value

func GetConfig() *Config {
	return config.Load().(*Config)
}

func LoadConfig() error {
	conf := csv.GetConfig()
	ranges := make([]Range, 0, len(conf.Cross.Hunting.Battle_cards))
	for _, cfg := range conf.Cross.Hunting.Battle_cards {
		ranges = append(ranges, NewBCRange(cfg))
	}
	v := &Config{
		BCRanges: NewRanges(ranges...),
	}
	config.Store(v)
	return nil
}

// Range
type Range interface {
	start() int
	end() int
	in(fightingPoint int) bool
}

// CSVRange
type CSVRange [2]int

func (r CSVRange) start() int {
	return r[0]
}

func (r CSVRange) end() int {
	return r[1]
}

func (r CSVRange) in(fightingPoint int) bool {
	return r.start() <= fightingPoint && fightingPoint < r.end()
}

// Ranges
type Ranges []Range

func (rs Ranges) GetRange(fightingPoint int) Range {
	max := len(rs)
	idx := sort.Search(max, func(i int) bool {
		return rs[i].start() > fightingPoint
	})
	idx -= 1
	if idx >= 0 && rs[idx].in(fightingPoint) {
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

// BCRange
type BCRange struct {
	CSVRange
	csvID int
	limit int
}

func NewBCRange(cfg *csv.Cross_hunting_battle_cards) *BCRange {
	r := &BCRange{
		CSVRange: [2]int{cfg.FightingPoint.ToIntSlice()[0], cfg.FightingPoint.ToIntSlice()[1]},
	}
	r.csvID = cfg.ID
	r.limit = cfg.DeployNum
	return r
}

func (r *BCRange) getCsvID(fightingPoint int) (int, int) {
	if !r.in(fightingPoint) {
		return 0, 0
	}
	return r.csvID, r.limit
}

func readAllServers(lang string) []string {
	games := make([]struct {
		Key string `codec:"key"`
	}, 0, 64)
	data, err := ioutil.ReadFile("../../login/conf/game.json")
	if err == nil {
		err = json.Unmarshal(data, &games)
	}
	if err != nil {
		return nil
	}
	servers := make([]string, 0, 64)
	for _, s := range games {
		_, language, _ := service.SplitServiceName(s.Key)
		if language == lang {
			servers = append(servers, s.Key)
		}
	}
	return servers
}

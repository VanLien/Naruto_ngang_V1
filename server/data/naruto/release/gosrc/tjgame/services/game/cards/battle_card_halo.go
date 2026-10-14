package cards

import (
	"sort"
	"strconv"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	// "tjgame/server_framework/tj/log"
)

// 队伍光环
type BattleCardHaloConfig struct {
	ID      int
	Type    int
	Ratios  []int       // type=1
	Natures map[int]int // type=2 {nature=count}

	Group    int
	Priority int // 同组优先级

	AutoPriority int // 自动选择最优光环优先级

	// 加成效果
	Consts   map[string]float64
	Percents map[string]float64
}

type BattleCardHaloConfigSlice []*BattleCardHaloConfig

func (s BattleCardHaloConfigSlice) Len() int           { return len(s) }
func (s BattleCardHaloConfigSlice) Less(i, j int) bool { return s[i].Priority < s[j].Priority }
func (s BattleCardHaloConfigSlice) Swap(i, j int)      { s[i], s[j] = s[j], s[i] }

var BattleCardHaloConfigGroups map[int]BattleCardHaloConfigSlice

// string => (float, percent)
func str2num(s string) (float64, float64) {
	if s[len(s)-1:] == "%" {
		num, _ := strconv.ParseFloat(s[:len(s)-1], 64)
		num /= 100
		return 0, num
	}
	n, _ := strconv.ParseFloat(s, 64)
	return n, 0
}

func InitBattleCardHaloConfig() error {
	haloCsv := csv.GetConfig().Battle_card_halo
	groups := make(map[int]BattleCardHaloConfigSlice)
	for i, cfg := range haloCsv {

		// log.Infof("[chanlong] InitBattleCardHaloConfig: cfg.Group=%s cfg.Type=%s",cfg.Group,cfg.Type)
		if _, ok := groups[cfg.Group]; !ok {
			groups[cfg.Group] = make(BattleCardHaloConfigSlice, 0, 8)
		}

		config := &BattleCardHaloConfig{
			ID:           i,
			Type:         cfg.Type,
			Group:        cfg.Group,
			Priority:     cfg.Priority,
			AutoPriority: cfg.AutoPriority,
		}
		if cfg.Type == 1 {
			config.Ratios = cfg.Args.ToIntSlice()
		} else if cfg.Type == 2 {
			config.Natures = make(map[int]int)
			for i := 0; i < len(cfg.Args); i++ {
				v := cfg.Args.GetSlice(i).ToIntSlice()
				config.Natures[v[0]] = config.Natures[v[0]] + v[1]
			}
		} else {
			panic("unsupport type")
		}
		config.Consts = make(map[string]float64)
		config.Percents = make(map[string]float64)
		csv.FieldRangeValues(cfg, []string{"AttrType%d", "AttrValue%d"}, func(values []interface{}) bool {
			attrType := values[0].(int)
			if attrType == 0 {
				return false
			}
			value := values[1].(string)
			c, f := str2num(value)
			attr := AttrsEnum[attrType]
			config.Consts[attr] = config.Consts[attr] + c
			config.Percents[attr] = config.Percents[attr] + f
			return true
		})

		groups[cfg.Group] = append(groups[cfg.Group], config)
	}

	for _, g := range groups {
		// log.Infof("[chanlong] InitBattleCardHaloConfig Sort | group: %s",g)
		sort.Sort(sort.Reverse(g))
	}
	
	BattleCardHaloConfigGroups = groups
	// log.Infof("[chanlong] InitBattleCardHaloConfig finish end")
	return nil
}

func MakeBattleCardHalo(cards []int, scene int) (map[string]float64, map[string]float64) {
	cardCsv := csv.GetConfig().Cards
	unitCsv := csv.GetConfig().Unit
	natures := make(map[int]int)
	for _, id := range cards {
		nature := unitCsv[cardCsv[id].UnitID].NatureType
		natures[nature] = natures[nature] + 1
	}
	return calcHalo(natures, BattleCardHaloConfigGroups)
}

func FindBattleCardHalo(natureL []int, scene int) (BattleCardHaloConfigSlice, int) {
	natures := make(map[int]int)
	for _, nature := range natureL {
		natures[nature] += 1
	}
	ratios := make([]int, 0, len(natures))
	for _, v := range natures {
		ratios = append(ratios, v)
	}
	sort.Sort(sort.Reverse(sort.IntSlice(ratios)))

	cfgs := make(BattleCardHaloConfigSlice, 0, 2)
	priority := 0
	for _, vv := range BattleCardHaloConfigGroups {
		for _, cfg := range vv {
			matched := true
			if cfg.Type == 1 { // 自然属性比例
				// cfg.Ratios already sorted
				if len(ratios) < len(cfg.Ratios) {
					matched = false
				} else {
					for i, v := range cfg.Ratios {
						matched = matched && ratios[i] >= v
					}
				}
			} else if cfg.Type == 2 { // 指定自然属性数量
				for nature, count := range cfg.Natures {
					matched = matched && natures[nature] == count
				}
			} else {
				matched = false
			}
			if matched {
				cfgs = append(cfgs, cfg)
				if cfg.Type == 1 && priority < cfg.AutoPriority {
					priority = cfg.AutoPriority
				}
				break
			}
		}
	}
	return cfgs, priority
}

type dfsFinder struct {
	chooses     []int
	length      int
	natureTypes [][2]int
	scene       int

	bestpriority int
	best         BattleCardHaloConfigSlice
	bestchooses  []int
}

func (r *dfsFinder) doit(i int) {
	if i >= r.length {
		natureL := make([]int, r.length)
		for idx, choose := range r.chooses {
			natureL[idx] = r.natureTypes[idx][choose]
		}
		cfgs, priority := FindBattleCardHalo(natureL, r.scene)
		if r.best == nil || r.bestpriority < priority {
			r.bestpriority = priority
			r.best = cfgs
			r.bestchooses = make([]int, len(r.chooses))
			copy(r.bestchooses, r.chooses)
		}
	} else {
		r.chooses[i] = 0
		r.doit(i + 1)
		if r.natureTypes[i][1] != 0 {
			r.chooses[i] = 1
			r.doit(i + 1)
		}
	}
}

func MakeBattleCardHaloBest(cards []int, scene int) (map[string]float64, map[string]float64, []int) {
	cardCsv := csv.GetConfig().Cards
	unitCsv := csv.GetConfig().Unit
	natureTypes := make([][2]int, len(cards))
	for idx, id := range cards {
		unit := unitCsv[cardCsv[id].UnitID]
		natureTypes[idx] = [2]int{unit.NatureType, unit.NatureType2}
	}
	finder := &dfsFinder{
		chooses:     make([]int, len(cards)),
		length:      len(cards),
		natureTypes: natureTypes,
		scene:       scene,
	}
	finder.doit(0)

	consts := make(map[string]float64)
	percents := make(map[string]float64)
	for _, cfg := range finder.best {
		for k, v := range cfg.Consts {
			consts[k] = consts[k] + v
		}
		for k, v := range cfg.Percents {
			percents[k] = percents[k] + v
		}
	}
	return consts, percents, finder.bestchooses
}

func calcHalo(natures map[int]int, configs map[int]BattleCardHaloConfigSlice) (map[string]float64, map[string]float64) {
	ratios := make([]int, 0, len(natures))
	for _, v := range natures {
		ratios = append(ratios, v)
	}
	sort.Sort(sort.Reverse(sort.IntSlice(ratios)))

	consts := make(map[string]float64)
	percents := make(map[string]float64)
	for _, cfgs := range configs {
		for _, cfg := range cfgs {
			matched := true
			if cfg.Type == 1 { // 自然属性比例
				// cfg.Ratios already sorted
				if len(ratios) < len(cfg.Ratios) {
					matched = false
				} else {
					for i, v := range cfg.Ratios {
						matched = matched && ratios[i] >= v
					}
				}
			} else if cfg.Type == 2 { // 指定自然属性数量
				for nature, count := range cfg.Natures {
					matched = matched && natures[nature] == count
				}
			} else {
				matched = false
			}
			if matched {
				for k, v := range cfg.Consts {
					consts[k] = consts[k] + v
				}
				for k, v := range cfg.Percents {
					percents[k] = percents[k] + v
				}
				break
			}
		}
	}

	return consts, percents
}

func AppendBattleCardHalo(ids []document.ID, cardAttrs map[document.ID]*scheme.CardBattleModel, scene int) []int {
	cards := make([]int, 0, len(ids))
	total := 0
	for _, id := range ids {
		if id != "" {
			cards = append(cards, cardAttrs[id].CardId)
			total += 1
		}
	}
	if total < 6 { // 不足6个，不可有队伍光环
		return nil
	}

	consts, percents, chooses := MakeBattleCardHaloBest(cards, scene)
	for _, id := range ids {
		card := cardAttrs[id]
		for attr, val := range percents {
			if val > 0 {
				card.Attrs[attr] *= 1 + val
			}
		}
		for attr, val := range consts {
			if val > 0 {
				card.Attrs[attr] += val
			}
		}
	}
	return chooses
}

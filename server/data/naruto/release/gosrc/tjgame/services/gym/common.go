package gym

import (
	"strconv"
	"sync/atomic"
	"time"
	"tjgame/csv"
	tjutil "tjgame/server_framework/tj/util"
)

// Config
type Config struct {
	GateRandom  map[int]map[int][]tjutil.WeightElement
	GymLogLimit int // 道馆本周日志限制
}

var config atomic.Value

func GetConfig() *Config {
	return config.Load().(*Config)
}

func LoadConfig() error {
	v := &Config{}
	csvConfig := csv.GetConfig()

	gateRandom := make(map[int]map[int][]tjutil.WeightElement)
	for i, cfg := range csvConfig.Gym.Gate {
		if !cfg.Npc {
			if rr, ok := gateRandom[cfg.GymID]; ok {
				if r, ok := rr[cfg.HardDegree]; ok {
					rr[cfg.HardDegree] = append(r, tjutil.WeightInts{i, cfg.Weight})
				} else {
					gateWeights := make([]tjutil.WeightElement, 0, len(csvConfig.Gym.Gate))
					rr[cfg.HardDegree] = append(gateWeights, tjutil.WeightInts{i, cfg.Weight})
				}
				gateRandom[cfg.GymID] = rr
			} else {
				gateWeights := make([]tjutil.WeightElement, 0, len(csvConfig.Gym.Gate))
				gateRandom[cfg.GymID] = map[int][]tjutil.WeightElement{cfg.HardDegree: append(gateWeights, tjutil.WeightInts{i, cfg.Weight})}
			}
		}
	}
	v.GateRandom = gateRandom

	for _, cfg := range csvConfig.Common_config {
		if cfg.Name == "gymLogLimit" {
			v.GymLogLimit = int(cfg.Value)
			break
		}
	}

	config.Store(v)
	return nil
}

// 生成副本关卡
func GetGymGates() map[int]map[int]int {
	gymGates := make(map[int]map[int]int)
	// 根据权重 随机获取 副本关卡
	config := csv.GetConfig()
	gateRandom := GetConfig().GateRandom
	for gymID, rr := range gateRandom {
		for r, gateWeights := range rr {
			idx := tjutil.OnceRandom(gateWeights).(tjutil.WeightInts)[0]
			cfg := config.Gym.Gate[idx]
			if gg, ok := gymGates[gymID]; ok {
				gg[r] = cfg.ID
				gymGates[gymID] = gg
			} else {
				gymGates[gymID] = map[int]int{r: cfg.ID}
			}
		}
	}
	return gymGates
}

// string => num
func str2num(s string) float64 {
	num, _ := strconv.ParseFloat(s[:len(s)-1], 64)
	num /= 100
	return num
}

// 本周的周一(0点）
func WeekDate2int() int {
	t := tjutil.Now()
	w := t.Weekday()
	if w != time.Monday {
		day := (int(w) - 1 + 7) % 7
		t = t.Add(-tjutil.OneDay * time.Duration(day))
	}
	return tjutil.Date2int(t)
}

package gym

import (
	"strconv"
	"sync/atomic"
	"tjgame/csv"
	"tjgame/server_framework/tj/service"
	tjutil "tjgame/server_framework/tj/util"
)

// Config
type Config struct {
	GateRandom map[int]map[int][]tjutil.WeightElement
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

	config.Store(v)
	return nil
}

// string => num
func str2num(s string) float64 {
	num, _ := strconv.ParseFloat(s[:len(s)-1], 64)
	num /= 100
	return num
}

func Game2GymService(name string) string {
	return service.TransformName(name, "gym")
}

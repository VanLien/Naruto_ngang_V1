package cross

import (
	"time"
	"tjgame/csv"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
)

type executor interface {
	IsOver() bool
	OnInit(int, []string)
}

type Skeleton struct {
	Coordinator

	key         string
	transaction string

	executor executor
}

func (s *Skeleton) Init(key string, transaction string, executor executor) {
	s.key = key
	s.transaction = transaction
	s.executor = executor
}

func (s *Skeleton) MustContainServices(services []string, servicenames ...string) {
	// 检查 container 里面是否都有对应的services, 动态添加
	if err := s.AddServicesDynamic(services, servicenames...); err != nil {
		panic(err)
	}
}

func (s *Skeleton) AddServicesDynamic(services []string, servicenames ...string) error {
	checkservices := make([]string, 0, len(services)*len(servicenames))
	for _, name := range services {
		checkservices = append(checkservices, name)
		_, language, id := service.SplitServiceName(name)
		for _, servicename := range servicenames {
			checkservices = append(checkservices, service.MakeServiceName(servicename, language, id))
		}
	}
	return s.dynamicAddServices(checkservices)
}

func (s *Skeleton) StartServiceCheck() {
	now := util.Now()
	date := util.Date2int(now)
	time5 := util.DateTimeCombine(date, 5, 0, 0)
	duration := time5.Sub(now)

	duration = 0
	if duration <= 0 {
		s.onNewDayInClock5()
		duration = time5.Add(util.OneDay).Sub(now)
	}
	log.Infof("next %v, %s onServiceCheck", duration, s.key)
	time.AfterFunc(duration, s.StartServiceCheck)
}

func (s *Skeleton) onNewDayInClock5() {
	log.Infof("onNewDayInClock5 %d", util.Todaydate2int())

	if s.executor.IsOver() {
		OnServiceCheck(s.Coordinator, s.key, s.transaction, func(id int, key string, services []string) {
			cfg := csv.GetMergeConfig()
			// 替换为原始key
			origins := make([]string, 0, len(services))
			for _, key := range services {
				origins = append(origins, cfg.GetSrcServKeys(key)...)
			}
			services = origins

			// 检查 container 里面是否都有对应的services, 动态添加
			if err := s.AddServicesDynamic(services, "pvp", "gym"); err != nil {
				log.Errorf("some service not in container, %v", err)
				return
			}
			s.executor.OnInit(id, services)
		})
	}
}

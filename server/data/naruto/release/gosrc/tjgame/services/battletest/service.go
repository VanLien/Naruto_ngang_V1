package battletest

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"tjgame/document"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/services/storage"

	"tjgame/mgo.v2/bson"
)

const (
	Name = "battletest"
)

func IdHex(s string) document.ID {
	return document.ID(bson.ObjectIdHex(s))
}

type Service struct {
	*service.Service

	roles    []*Role
	managers map[string]*Manager
}

func (s *Service) Start() bool {
	container := s.Container()
	initGate()
	// init roles
	roles := make([]*Role, 0, 64)
	if buf, err := ioutil.ReadFile("tester.json"); err == nil {
		err = json.Unmarshal(buf, &roles)
		if err != nil {
			log.Panic(err)
		}
	} else {
		log.Panicf("tester.json loaded error %s", err)
	}
	for _, role := range roles {
		role.ID = IdHex(role.PID)
		if err := role.fetch(container.GetService(role.Key(storage.Name))); err != nil {
			log.Panic(err)
		}
	}
	s.roles = roles
	log.Infof("loaded tester count %d", len(s.roles))

	// init manager
	services := func(name string) map[string]service.IService {
		ret := make(map[string]service.IService)
		ss := container.GetServices(fmt.Sprintf("^%s", name))
		for _, v := range ss {
			ret[v.Name()] = v
		}
		return ret
	}

	agent := container.GetService("anticheat")
	arena := NewBattleManager("arena", agent, "NewArenaBattle")
	arena.maker = &ArenaPlayRecordMaker{services: services("arena")}
	craft := NewBattleManager("craft", agent, "NewCraftBattle")
	craft.maker = &CraftPlayRecordMaker{services: services("craft")}
	unionFight := NewBattleManager("union_fight", agent, "NewUnionFightBattle")
	unionFight.maker = &UnionFightPlayRecordMaker{services: services("union_fight")}
	gate := NewBattleManager("gate", agent, "NewGateBattle")
	gate.maker = &GatePlayRecordMaker{services: services("arena")}
	crosscraft := NewBattleManager("cross_craft", agent, "NewCrossCraftBattle")
	crosscraft.maker = &CrossCraftPlayRecordMaker{services: services("pvp")}
	s.managers = map[string]*Manager{
		arena.name:      arena,
		craft.name:      craft,
		unionFight.name: unionFight,
		gate.name:       gate,
		crosscraft.name: crosscraft,
	}
	return s.Service.Start()
}

func (s *Service) StartBattleTest(names []string) (bool, error) {
	for _, name := range names {
		manager := s.managers[name]
		roles := make([]*Role, 0, len(s.roles))
		for _, role := range s.roles {
			if manager.maker.RoleValid(role) {
				roles = append(roles, role)
			}
		}
		RandomShuffleRoles(roles)
		matchs := make([][2]*Role, 0, len(roles)/2)
		for i := 0; i < len(roles)/2; i++ {
			matchs = append(matchs, [2]*Role{roles[i], roles[i+1]})
		}
		manager.matchs = matchs
		if manager.Start() {
			go manager.Run()
		} else {
			log.Warningf("%s already running", name)
		}
	}
	return true, nil
}

type StatResponse struct {
	Reports     map[string]map[string]int64 `codec:"reports"`
	CardReports map[int]*cardRecordItem     `codec:"cardReports"`
	Finished    map[string]bool             `codec:"finished"`
}

func (s *Service) GetStaticstics() (StatResponse, error) {
	resp := StatResponse{
		Reports:     make(map[string]map[string]int64),
		CardReports: make(map[int]*cardRecordItem),
		Finished:    make(map[string]bool),
	}
	for name, mgr := range s.managers {
		cardReports := mgr.statistics.ReportCardRecord()
		for cardID, info := range cardReports {
			oldInfo, ok := resp.CardReports[cardID]
			if !ok {
				oldInfo = &cardRecordItem{}
				resp.CardReports[cardID] = oldInfo
			}
			oldInfo.Win += info.Win
			oldInfo.Fail += info.Fail
		}

		resp.Reports[name] = mgr.statistics.Report()
		if mgr.finish != nil {
			select {
			case <-mgr.finish.Done():
				resp.Finished[name] = true
			default:
				resp.Finished[name] = false
			}
		} else {
			resp.Finished[name] = true
		}

	}
	return resp, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}

	s.Register(s, "StartBattleTest")
	s.Register(s, "GetStaticstics")

	return s
}

package fishing

import (
	"errors"
	"time"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/service/caller"
	"tjgame/services/storage"

	"tjgame/mgo.v2/bson"
)

const (
	Name = "crossfishing"
)

type Service struct {
	*service.Service
	builder *Builder
	storage service.IService

	manager *Manager
}

func (s *Service) Init() bool {
	if ok := s.Service.Init(); !ok {
		return false
	}
	return true
}

func (s *Service) Start() bool {
	opt := s.Option.Base()
	for _, name := range opt.Dependent {
		ns, _, _ := service.SplitServiceName(name)
		if ns == "crossdb" {
			s.storage = s.Container().GetService(name)
			break
		}
	}
	s.builder = NewBuilder(s.storage)
	s.manager = NewCrossFishingManager()
	s.manager.init(s)

	resp, err := service.Call(s.storage, "DBReadBy", "CrossFishingGlobal", bson.M{"key": s.Name()})
	if err != nil {
		return false
	}
	response := resp.(storage.Response)
	for _, model := range response.Models {
		play := s.builder.NewCrossFishingGlobalByModel(model, response.From)
		play.init(s.Container(), s.manager)

		err := s.addService(play.Servers()...)
		if err != nil {
			panic(err)
		}

		if !play.isOver() {
			play.resetToday()
			s.manager.addGameToPlay(play)
		}

		s.manager.addPlay(play)
	}

	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.builder.Stop()
}

func (s *Service) addService(services ...string) error {
	for _, serviceKey := range services {
		if s.Container().GetService(serviceKey) == nil {
			if err := s.Container().AddRemoteService(serviceKey); err != nil {
				return err
			}
		}
	}
	return nil
}

// 同步 db 给 game
func (s *Service) CrossFishingJoin(key string) (*DBForGame, error) {
	fishing := s.manager.getPlayByGame(key)
	if fishing == nil {
		log.Warningf("CrossFishing CrossFishingJoin key %v error %v", key, ErrGroupPlayNotExist)
		return nil, nil
	}
	_, unlock := fishing.RLockAndGetDB()
	defer unlock()
	if !fishing.isServerOK(key) {
		return nil, nil
	}
	return fishing.dbForGame(), nil
}

// 新的钓鱼大赛
func (s *Service) CrossFishingNewPlays(id int, plays map[document.Integer][]string) (bool, error) {
	s.manager.onGameCheck(plays)
	return true, nil
}

// 更新钓鱼大赛数MainGet据
func (s *Service) CrossFishingUpdate(gameKey string, roles []ReqCrossFishingRole) ([]scheme.CrossFishingRoleItem, error) {
	fishing := s.manager.getPlayByGame(gameKey)
	if fishing == nil {
		return []scheme.CrossFishingRoleItem{}, ErrGroupPlayNotExist
	}
	fishing.updateRoles(roles)
	return fishing.getTop3(), nil
}

// game closed
func (s *Service) CrossFishingGameClosed(gameKey string, roles []ReqCrossFishingRole) (bool, error) {
	fishing := s.manager.getPlayByGame(gameKey)
	if fishing == nil {
		return false, ErrGroupPlayNotExist
	}
	fishing.updateRoles(roles)
	fishing.onGameClosed(gameKey)
	return true, nil
}

// 钓鱼大赛排名信息
func (s *Service) CrossFishingRankInfo(gameKey string, roleID document.ID) (RespCrossFishingRankInfo, error) {
	fishing := s.manager.getPlayByGame(gameKey)
	if fishing == nil {
		return RespCrossFishingRankInfo{}, ErrGroupPlayNotExist
	}
	return fishing.getRankInfo(roleID), nil
}

// 钓鱼大赛服务器检测接口
func (s *Service) CrossMatchServerCheck(crossKey string, t float64) (bool, error) {
	var err error
	err = s.addService(crossKey)
	if err != nil {
		return false, err
	}

	_, err = service.CallWithTimeout(s.Container().GetService(crossKey), "ServiceCheckBack", time.Second*15, s.Name(), []string{}, 0)
	if err != nil {
		return false, err
	}

	return true, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}

	s.Register(s, "CrossFishingJoin")
	s.Register(s, "CrossFishingNewPlays")
	s.Register(s, "CrossFishingUpdate")
	s.Register(s, "CrossFishingRankInfo")
	s.Register(s, "CrossFishingGameClosed")
	s.RegisterCustom(s, caller.Notify, "CrossMatchServerCheck", nil)

	//s.Register(s, "CrossFishingGMAddGames")
	s.Register(s, "CrossFishingCheatEnd")

	return s
}

func (s *Service) CrossFishingCheatEnd(gameKey string) (bool, error) {
	fishing := s.manager.getPlayByGame(gameKey)
	if fishing == nil {
		return false, errors.New("not find play")
	}
	fishing.timer.Reset(0)
	return true, nil
}

//func (s *Service) CrossFishingGMAddGames(group int, games []string) (bool, error) {
//	fishing := s.manager.getPlay(group)
//	if fishing == nil {
//		return false, ErrGroupPlayNotExist
//	}
//	err := fishing.gmAddGames(games)
//	if err != nil {
//		return false, err
//	} else {
//		s.manager.addGameToPlay(fishing)
//		return true, nil
//	}
//}

package unionqa

import (
	"time"
	"tjgame/document"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/service/caller"
	"tjgame/services/storage"

	"tjgame/mgo.v2/bson"
)

const (
	Name = "crossunionqa"
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
	s.manager = NewCrossUnionQAManager()
	s.manager.init(s)

	resp, err := service.Call(s.storage, "DBReadBy", "CrossUnionQAGlobal", bson.M{"key": s.Name()})
	if err != nil {
		return false
	}
	response := resp.(storage.Response)
	for _, model := range response.Models {
		play := s.builder.NewCrossUnionQAGlobalByModel(model, response.From)
		play.init(s.Container(), s.manager)

		err := s.addService(play.Servers()...)
		if err != nil {
			panic(err)
		}

		if !play.isOver() {
			go play.resetToday()
		}

		s.manager.addGameToPlay(play)
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
func (s *Service) CrossUnionQAJoin(key string) (*DBForGame, error) {
	qa := s.manager.getPlayByGame(key)
	if qa == nil {
		log.Warningf("CrossUnionQA CrossUnionQAJoin key %v error %v", key, ErrGroupPlayNotExist)
		return nil, nil
	}
	_, unlock := qa.RLockAndGetDB()
	defer unlock()
	if !qa.isServerOK(key) {
		return nil, nil
	}
	return &DBForGame{Key: qa.Key(), Round: qa.Round()}, nil
}

// 新的公会问答
func (s *Service) CrossUnionQANewPlays(id int, plays map[document.Integer][]string) (bool, error) {
	s.manager.onGameCheck(id, plays)
	return true, nil
}

// 公会问答 主界面
func (s *Service) CrossUnionQAMain(gameKey string, roleID, unionID document.ID) (RespCrossUnionQAMain, error) {
	qa := s.manager.getPlayByGame(gameKey)
	if qa == nil {
		return RespCrossUnionQAMain{}, ErrGroupPlayNotExist
	}
	ret := RespCrossUnionQAMain{
		RespCrossUnionQARankInfo: qa.getTop10(roleID, unionID),
		Servers:                  qa.Servers(),
		Round:                    qa.Round(),
	}
	return ret, nil

}

// 公会问答 分数刷新
func (s *Service) CrossUnionQAUpdate(gameKey string, data ReqCrossUnionQA) (RespCrossUnionQARankInfo, error) {
	qa := s.manager.getPlayByGame(gameKey)
	if qa == nil {
		return RespCrossUnionQARankInfo{}, ErrGroupPlayNotExist
	}
	for _, weekday := range rankNums {
		if weekday == data.WeekDay {
			qa.updateRole(data)
			break
		}
	}
	return qa.getTop10(data.Role.RoleID, data.Union.ID), nil
}

// 公会问答 排名信息
func (s *Service) CrossUnionQARankInfo(gameKey string, roleID, unionID document.ID) (map[int]RespCrossUnionQARankInfo, error) {
	qa := s.manager.getPlayByGame(gameKey)
	if qa == nil {
		return map[int]RespCrossUnionQARankInfo{}, ErrGroupPlayNotExist
	}
	return qa.getRankInfo(roleID, unionID), nil
}

// 公会问答 公会解散
func (s *Service) CrossUnionQAUnionDissolve(gameKey string, unionID document.ID) (bool, error) {
	qa := s.manager.getPlayByGame(gameKey)
	if qa == nil {
		return false, ErrGroupPlayNotExist
	}
	return qa.unionDissolve(unionID), nil
}

// 公会问答 服务器检测接口
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

// 公会问答 start
func (s *Service) CrossUnionQAStart(groupID document.Integer, gameKey string) (string, error) {
	return s.manager.startCrossUnionQA(groupID, gameKey)
}

// 公会问答 closed
func (s *Service) CrossUnionQAClosed(gameKey string) (bool, error) {
	return s.manager.closeCrossUnionQA(gameKey)
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}

	s.Register(s, "CrossUnionQANewPlays")
	s.Register(s, "CrossUnionQAJoin")
	s.Register(s, "CrossUnionQAMain")
	s.Register(s, "CrossUnionQAUpdate")
	s.Register(s, "CrossUnionQARankInfo")
	s.Register(s, "CrossUnionQAUnionDissolve")
	s.Register(s, "CrossUnionQAStart")
	s.Register(s, "CrossUnionQAClosed")
	s.RegisterCustom(s, caller.Notify, "CrossMatchServerCheck", nil)

	return s
}

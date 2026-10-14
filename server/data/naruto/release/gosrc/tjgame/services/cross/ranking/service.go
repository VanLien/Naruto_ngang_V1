package ranking

import (
	"errors"
	"time"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/service/caller"
	"tjgame/services/cross"
	"tjgame/services/storage"

	"tjgame/mgo.v2/bson"
)

const (
	Name                             = "crossranking"
	CrossBraveChallengeRanking       = "bravechallengeranking"
	CrossNormalBraveChallengeRanking = "normalbravechallengeranking"
	CrossHorseRaceRanking            = "horseraceranking"
	CrossVolleyballRanking           = "volleyballranking"
	CrossShavediceRanking            = "shavediceranking"
)

var (
	PlayRankings = map[string]bool{
		CrossBraveChallengeRanking:       true,
		CrossNormalBraveChallengeRanking: true,
		CrossHorseRaceRanking:            true,
		CrossVolleyballRanking:           true,
		CrossShavediceRanking:            true,
	}
)

var (
	ErrGroupPlayNotExist = errors.New("groupPlayNotExist")
	ErrRankClosed        = errors.New("rankClosed")
	//ErrRankNotExist      = errors.New("rankNotExist")
)

type Service struct {
	*service.Service
	cross.Skeleton
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
	s.manager = NewRankingManager()
	s.manager.init(s)

	resp, err := service.Call(s.storage, "DBReadBy", "CrossRankingGlobal", bson.M{"key": s.Name()})
	if err != nil {
		return false
	}
	response := resp.(storage.Response)
	for _, model := range response.Models {
		play := s.builder.NewRankGlobalByModel(model, response.From)
		play.init(s.Container(), s.manager)

		err := cross.ContainerServices(s.Container(), play.Servers()...)
		if err != nil {
			panic(err)
		}

		if !play.isOver() {
			if !play.resetToday() { // 重启刷新定时器, 过期关闭活动
				break
			}
			s.manager.addGameToPlay(play.GamePlay(), play)
		}

		s.manager.addPlay(play.GamePlay(), play)
	}

	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.builder.Stop()
}

// 新的排行榜活动
func (s *Service) RankingNewPlays(gamePlay string, id int, plays map[document.Integer][]string) (bool, error) {
	s.manager.onGameCheck(gamePlay, id, plays)
	return true, nil
}

// 添加排名
func (s *Service) RankingSendInfo(gameKey, gamePlay string, crossRankRoleInfo *scheme.RoleRankInfo) (bool, error) {
	rankObj := s.manager.getPlayByGame(gameKey, gamePlay)
	if rankObj == nil {
		return false, ErrGroupPlayNotExist
	}
	return true, rankObj.sendRankInfo(crossRankRoleInfo)
}

// 获取排名
func (s *Service) RankingGet(gameKey, gamePlay string, roleID document.ID, size int) (*RankingReturn, error) {
	rankObj := s.manager.getPlayByGame(gameKey, gamePlay)
	if rankObj == nil {
		return &RankingReturn{}, ErrGroupPlayNotExist
	}

	ranking, rank := rankObj.getRankInfo(gamePlay, roleID, size)
	return &RankingReturn{rank, ranking}, nil
}

// 清除排名
func (s *Service) RankingClear(gameKey, gamePlay string) ([]scheme.RoleRankInfo, error) {
	rankObj := s.manager.getPlayByGame(gameKey, gamePlay)
	if rankObj == nil {
		return []scheme.RoleRankInfo{}, ErrGroupPlayNotExist
	}
	return rankObj.clearRankInfo(), nil
}

// 服务器检测接口
func (s *Service) CrossMatchServerCheck(crossKey string, t float64) (bool, error) {
	err := cross.ContainerServices(s.Container(), crossKey)
	if err != nil {
		return false, err
	}

	_, err = service.CallWithTimeout(s.Container().GetService(crossKey), "ServiceCheckBack", time.Second*15, s.Name(), []string{}, 0)
	if err != nil {
		return false, err
	}

	return true, nil
}

// 测试用，开活动
func (s *Service) RankingStart(gamePlay string, id int, groupID document.Integer, servers []string) (bool, error) {
	err := cross.ContainerServices(s.Container(), servers...)
	if err != nil {
		panic(err)
	}
	// 开始玩法 cross.server 配表id
	plays := make(map[document.Integer][]string)
	plays[groupID] = servers
	_, err = s.RankingNewPlays(gamePlay, id, plays)
	if err != nil {
		log.Warningf("%s %s error, %v", gamePlay, s.Name(), err)
		return false, err
	}
	return true, nil
}

// 测试用，关活动
func (s *Service) RankingClose(gamePlay string, groupID document.Integer) (bool, error) {
	group := int(groupID)
	play := s.manager.getPlay(gamePlay, group)
	if play == nil {
		return false, ErrGroupPlayNotExist
	}
	play.onClosed()
	return true, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}
	s.SetContainer(container)
	s.Register(s, "RankingNewPlays")
	s.Register(s, "RankingSendInfo")
	s.Register(s, "RankingGet")
	s.Register(s, "RankingClear")
	s.Register(s, "RankingStart")
	s.Register(s, "RankingClose")
	s.RegisterCustom(s, caller.Notify, "CrossMatchServerCheck", nil)

	return s
}

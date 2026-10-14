package skyscraper

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
	Name = "skyscraper"
)

var (
	ErrGroupPlayNotExist  = errors.New("groupPlayNotExist")
	ErrSkyscraperClosed   = errors.New("skyscraperClosed")
	ErrSkyscraperNotExist = errors.New("skyscraperNotExist")
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
	s.manager = NewSkyscraperManager()
	s.manager.init(s)

	resp, err := service.Call(s.storage, "DBReadBy", "SkyscraperGlobal", bson.M{"key": s.Name()})
	if err != nil {
		return false
	}
	response := resp.(storage.Response)
	for _, model := range response.Models {
		play := s.builder.NewSkyscraperGlobalByModel(model, response.From)
		play.init(s.Container(), s.manager)

		err := cross.ContainerServices(s.Container(), play.Servers()...)
		if err != nil {
			panic(err)
		}

		if !play.isOver() {
			if !play.resetToday() { // 重启刷新定时器, 过期关闭活动
				break
			}
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

// 新的叠高楼运营活动
func (s *Service) SkyscraperNewPlays(id int, plays map[document.Integer][]string) (bool, error) {
	s.manager.onGameCheck(id, plays)
	return true, nil
}

// 清除叠高楼
func (s *Service) SkyscraperClear(gameKey string) ([]scheme.SkyscraperInfo, error) {
	skyscraper := s.manager.getPlayByGame(gameKey)
	if skyscraper == nil {
		return []scheme.SkyscraperInfo{}, ErrGroupPlayNotExist
	}
	return skyscraper.clearSkyscraper(), nil
}

// 添加摩天大楼数据
func (s *Service) SendSkyscraperInfo(gameKey string, skyscraperInfo *scheme.SkyscraperInfo) (bool, error) {
	skyscraper := s.manager.getPlayByGame(gameKey)
	if skyscraper == nil {
		return false, ErrGroupPlayNotExist
	}
	return true, skyscraper.sendSkyscraperInfo(skyscraperInfo)
}

// 添加摩天大楼排行榜数据
func (s *Service) GetSkyscraperRanking(gameKey string, roleID document.ID, size int) (*RankingReturn, error) {
	skyscraper := s.manager.getPlayByGame(gameKey)
	if skyscraper == nil {
		return &RankingReturn{}, ErrGroupPlayNotExist
	}

	ranking, rank := skyscraper.getSkyscraperRanking(size, roleID)
	return &RankingReturn{rank, ranking}, nil
}

// 活动Boss服务器检测接口
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
func (s *Service) SkyscraperStart(id int, groupID document.Integer, servers []string) (bool, error) {
	err := cross.ContainerServices(s.Container(), servers...)
	if err != nil {
		panic(err)
	}
	// 开始玩法 配表id
	plays := make(map[document.Integer][]string)
	plays[groupID] = servers
	_, err = s.SkyscraperNewPlays(id, plays)
	if err != nil {
		log.Warningf("SkyscraperNewPlays %s error, %v", s.Name(), err)
		return false, err
	}
	return true, nil
}

// 测试用，关活动
func (s *Service) SkyscraperClose(groupID document.Integer) (bool, error) {
	group := int(groupID)
	play := s.manager.getPlay(group)
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
	s.Register(s, "SkyscraperNewPlays")
	s.Register(s, "SendSkyscraperInfo")
	s.Register(s, "GetSkyscraperRanking")
	s.Register(s, "SkyscraperClear")
	s.Register(s, "SkyscraperStart")
	s.Register(s, "SkyscraperClose")
	s.RegisterCustom(s, caller.Notify, "CrossMatchServerCheck", nil)

	return s
}

type RankingReturn struct {
	Rank    int                      `codec:"rank"`
	Ranking []*scheme.SkyscraperInfo `codec:"ranking"`
}

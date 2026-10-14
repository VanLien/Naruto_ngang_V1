package match

import (
	"tjgame/server_framework/tj/service"
)

const (
	Name = "crossmatch"
)

type Service struct {
	*service.Service
	builder *Builder
	storage service.IService

	match *Match
}

func (s *Service) Init() bool {
	if ok := s.Service.Init(); !ok {
		return false
	}
	_ = LoadConfig()
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

	// 第一个 service 进行区服的匹配
	s.match = s.builder.NewCrossMatch(s.Name())
	s.match.init(s)
	go s.match.startServiceCheck()

	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.builder.Stop()
}

// 钓鱼大赛服务器检测回调
func (s *Service) ServiceCheckBack(serverKey string, srcServKeys []string, openDays int) (bool, error) {
	s.match.onServerCheckBack(serverKey, srcServKeys, openDays)
	return true, nil
}

func (s *Service) StartServiceCheck() (bool, error) {
	s.match.onServerCheckStart()
	return true, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}

	s.Register(s, "StartServiceCheck")
	s.Register(s, "ServiceCheckBack")

	return s
}

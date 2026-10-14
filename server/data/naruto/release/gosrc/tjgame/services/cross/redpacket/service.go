package redpacket

import (
	"errors"
	"time"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/mgo.v2/bson"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/service/caller"
	"tjgame/services/cross"
	"tjgame/services/storage"
)

const (
	Name = "crossredpacket"
)

var (
	ErrGroupPlayNotExist = errors.New("groupPlayNotExist")
	ErrRedPacketNoRemain = errors.New("redPacketNoRemain")
	ErrRedPacketAlreadyRob = errors.New("redPacketAlreadyRob")
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
	s.manager = NewRedPacketManager()
	s.manager.init(s)

	resp, err := service.Call(s.storage, "DBReadBy", "CrossRedPacketGlobal", bson.M{"key": s.Name()})
	if err != nil {
		return false
	}
	response := resp.(storage.Response)
	for _, model := range response.Models {
		play := s.builder.NewCrossRedPacketGlobalByModel(model, response.From)
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

// 新的活动跨服红包 运营活动
func (s *Service) CrossRedPacketNewPlays(id int, plays map[document.Integer][]string) (bool, error) {
	s.manager.onGameCheck(id, plays)
	return true, nil
}

// 获取红包信息
func (s *Service) CrossRedPacketList(gameKey string) ([]*scheme.RedPacketInfo, error) {
	redPacket := s.manager.getPlayByGame(gameKey)
	if redPacket == nil {
		return []*scheme.RedPacketInfo{}, ErrGroupPlayNotExist
	}
	redPacketInfoList := redPacket.getRedPacketList()
	return redPacketInfoList, nil
}

// 发红包
func (s *Service) CrossRedPacketSend(gameKey string, redPacketInfo *scheme.RedPacketInfo) (RedPacketSendResponse, error) {
	redPacket := s.manager.getPlayByGame(gameKey)
	if redPacket == nil {
		return RedPacketSendResponse{0, []*scheme.RedPacketInfo{}}, ErrGroupPlayNotExist
	}
	idx, redPacketInfoList := redPacket.sendRedPacket(redPacketInfo)
	return RedPacketSendResponse{idx, redPacketInfoList}, nil
}

// 抢红包
func (s *Service) CrossRedPacketRob(gameKey string, idx document.Integer, memberInfo scheme.MemberInfo) (RedPacketRobResponse, error) {
	redPacket := s.manager.getPlayByGame(gameKey)
	if redPacket == nil {
		return RedPacketRobResponse{}, ErrGroupPlayNotExist
	}

	info, val, redPacketInfoList, err := redPacket.robRedPacket(idx, memberInfo)
	if err != nil {
		return RedPacketRobResponse{}, err
	}
	return RedPacketRobResponse{info, val, redPacketInfoList}, err
}

// 跨服红包服务器检测接口
func (s *Service) CrossMatchServerCheck(crossKey string, t float64) (bool, error) {
	var err error
	err = cross.ContainerServices(s.Container(), crossKey)
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
func (s *Service) CrossRedPacketStart(id int, groupID document.Integer, servers []string) (bool, error) {
	err := cross.ContainerServices(s.Container(), servers...)
	if err != nil {
		panic(err)
	}
	// 开始玩法 配表id
	plays := make(map[document.Integer][]string)
	plays[groupID] = servers
	_, err = s.CrossRedPacketNewPlays(id, plays)
	if err != nil {
		log.Warningf("CrossRedPacketNewPlays %s error, %v", s.Name(), err)
		return false, err
	}
	return true, nil
}

// 测试用，添加一个game
func (s *Service) CrossRedPacketAddGame(groupID document.Integer, servers []string) (bool, error) {
	s.manager.crossRedPacketGameAdd(groupID, servers)
	// 通知game
	ret, err := s.TransactionCommit(servers, s.Name(), Name)
	if err != nil {
		log.Warningf("transaction_commit %s error, %v", s.Name(), err)
		return false, err
	}
	log.Infof("transaction_commit %s %v", s.Name(), ret)
	return true, nil
}

// 测试用，关活动
func (s *Service) CrossRedPacketAddClose(groupID document.Integer) (bool, error) {
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

	s.Register(s, "CrossRedPacketNewPlays")
	s.Register(s, "CrossRedPacketList")
	s.Register(s, "CrossRedPacketSend")
	s.Register(s, "CrossRedPacketRob")
	s.Register(s, "CrossRedPacketStart")
	s.Register(s, "CrossRedPacketAddGame")
	s.Register(s, "CrossRedPacketAddClose")
	s.RegisterCustom(s, caller.Notify, "CrossMatchServerCheck", nil)

	return s
}

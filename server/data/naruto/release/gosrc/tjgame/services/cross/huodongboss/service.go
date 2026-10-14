package huodongboss

import (
	"errors"
	"time"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/mgo.v2/bson"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/service/caller"
	"tjgame/services/storage"
)

const (
	Name = "huodongboss"
)

var (
	ErrGroupPlayNotExist     = errors.New("groupPlayNotExist")
	ErrHuoDongBossClosed     = errors.New("huoDongBossClosed")
	ErrHuoDongBossExpired    = errors.New("huoDongBossExpired")
	ErrHuoDongBossNotExist   = errors.New("huoDongBossNotExist")
	ErrHuoDongBossChallenged = errors.New("huoDongBossChallenged")
	ErrHuoDongBossNoTimes    = errors.New("huoDongBossNoTimes")
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
	s.manager = NewHuoDongBossManager()
	s.manager.init(s)

	resp, err := service.Call(s.storage, "DBReadBy", "HuoDongBossGlobal", bson.M{"key": s.Name()})
	if err != nil {
		return false
	}
	response := resp.(storage.Response)
	for _, model := range response.Models {
		play := s.builder.NewHuoDongBossGlobalByModel(model, response.From)
		play.init(s.Container(), s.manager)

		err := s.addService(play.Servers()...)
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
func (s *Service) HuoDongBossJoin(key string) (string, error) {
	huodongboss := s.manager.getPlayByGame(key)
	if huodongboss == nil {
		log.Warningf("HuoDongBoss HuoDongBossJoin key %v error %v", key, ErrGroupPlayNotExist)
		return "", nil
	}
	_, unlock := huodongboss.RLockAndGetDB()
	defer unlock()
	if !huodongboss.isServerOK(key) {
		return "", nil
	}
	return huodongboss.Status(), nil
}

// 新的活动boss 运营活动
func (s *Service) HuoDongBossNewPlays(id int, plays map[document.Integer][]string) (bool, error) {
	s.manager.onGameCheck(id, plays)
	return true, nil
}

// 获取活动Boss List
func (s *Service) HuoDongBossList(gameKey string, roleID document.ID, size int) ([]scheme.HuoDongBossInfo, error) {
	huodongboss := s.manager.getPlayByGame(gameKey)
	if huodongboss == nil {
		return []scheme.HuoDongBossInfo{}, ErrGroupPlayNotExist
	}
	return huodongboss.getHuoDongBossList(roleID, size), nil
}

// 清除boss
func (s *Service) HuoDongBossClear(gameKey string) ([]scheme.HuoDongBossInfo, error) {
	huodongboss := s.manager.getPlayByGame(gameKey)
	if huodongboss == nil {
		return []scheme.HuoDongBossInfo{}, ErrGroupPlayNotExist
	}
	return huodongboss.clearHuoDongBoss(), nil
}

// 获取活动Boss Info
func (s *Service) HuoDongBossInfo(gameKey string, idx string, roleID document.ID) (scheme.HuoDongBossInfo, error) {
	huodongboss := s.manager.getPlayByGame(gameKey)
	if huodongboss == nil {
		return scheme.HuoDongBossInfo{}, ErrGroupPlayNotExist
	}
	return huodongboss.getHuoDongBossInfo(idx, roleID)
}

// 添加活动Boss数据
func (s *Service) HuoDongBossAdd(gameKey string, bossInfo scheme.HuoDongBossInfo) (scheme.HuoDongBossInfo, error) {
	huodongboss := s.manager.getPlayByGame(gameKey)
	if huodongboss == nil {
		return scheme.HuoDongBossInfo{}, ErrGroupPlayNotExist
	}
	return huodongboss.addHuoDongBoss(bossInfo)
}

// 更新活动Boss数据
func (s *Service) HuoDongBossUpdate(gameKey string, idx string, roleInfo scheme.HuoDongBossRoleInfo) (document.ID, error) {
	huodongboss := s.manager.getPlayByGame(gameKey)
	if huodongboss == nil {
		return "", ErrGroupPlayNotExist
	}
	return huodongboss.updateHuoDongBossInfo(idx, roleInfo)
}

// 活动Boss服务器检测接口
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

func (s *Service) HuoDongBossStart(groupID document.Integer, gameKey string) (bool, error) {
	return s.manager.startHuoDongBoss(groupID, gameKey)
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}

	s.Register(s, "HuoDongBossNewPlays")
	s.Register(s, "HuoDongBossJoin")
	s.Register(s, "HuoDongBossAdd")
	s.Register(s, "HuoDongBossUpdate")
	s.Register(s, "HuoDongBossList")
	s.Register(s, "HuoDongBossInfo")
	s.Register(s, "HuoDongBossClear")
	s.Register(s, "HuoDongBossStart")
	s.RegisterCustom(s, caller.Notify, "CrossMatchServerCheck", nil)

	return s
}

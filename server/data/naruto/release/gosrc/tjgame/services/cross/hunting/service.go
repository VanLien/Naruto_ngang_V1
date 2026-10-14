package hunting

import (
	"errors"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/services/cross"
)

const Name = "crosshunting"

type Service struct {
	*service.Service
	builder *Builder
	cross.Skeleton

	storage service.IService

	hunting *HuntingGlobal // 远征
}

func (s *Service) Init() bool {
	if ok := s.Service.Init(); !ok {
		return false
	}
	_ = LoadConfig()
	return true
}

func (s *Service) Start() bool {
	var ss service.IService
	opt := s.Option.Base()
	for _, name := range opt.Dependent {
		ns, _, _ := service.SplitServiceName(name)
		if ns == "crossdb" {
			ss = s.Container().GetService(name)
			break
		}
	}
	s.builder = NewBuilder(ss)
	key := opt.Name

	// load hunting global
	s.hunting = s.builder.NewHuntingGlobal(key)
	if s.hunting == nil {
		return false
	}
	s.hunting.container = s.Container()
	s.hunting.init(s.builder)
	log.Infof("load %s hunting global", key)

	go s.hunting.cleanDefenceRecordCount()
	go s.hunting.ResetToday()
	// go s.HuntingCheckAddService([]string{})

	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.builder.Stop()
}

// arena 接收各个arena生成的防守阵容名单
func (s *Service) GenHuntingBattleCards(serverKey string, battleCards []*BattleCard) (bool, error) {
	bcChan := battleCardsChan{
		BattleCards: battleCards,
		genFinish:   make(chan int),
		GameKey:     serverKey,
	}
	s.hunting.pushGenBattleCards(serverKey, &bcChan)
	return true, nil
}

// huntingRecord 随机一个名单
func (s *Service) RandomHuntingBattleCard(fixFP int) (*scheme.BattleCardInfo, error) {
	ret, err := s.hunting.randomBattleCards(fixFP)
	return ret, err
}

// huntingRecord 防守阵容 标志减一
func (s *Service) HuntingBattleCountSub(defenceRecordID document.ID) (bool, error) {
	ret := s.hunting.defenceRecordCountSub(defenceRecordID)
	return ret, nil
}

// test 生成阵容库名单
func (s *Service) TestNotifyGenHuntingCards() (bool, error) {
	TestInQuick = true
	s.hunting.notifyArenaGen()
	return true, nil
}

// test 清除计数标识
func (s *Service) TestCleanDefenceRecordCount() (bool, error) {
	s.hunting.cleanDefenceRecordCount()
	return true, nil
}

// test 获取每个区间阵容数据
func (s *Service) TestGetHuntingBattleCards(csvID int) (map[document.Integer][]*BattleCardRole, error) {
	// csvID = 0 拿全部
	battleCardRoles := map[document.Integer][]*BattleCardRole{}
	if csvID == 0 {
		for cID, battleCard := range s.hunting.BattleCards() {
			battleCardRole, _ := s.hunting.getHuntingBattleCards(s.Container(), int(cID), battleCard)
			battleCardRoles[cID] = battleCardRole
		}
	}

	return battleCardRoles, nil
}

// TODO 检查并添加service 不调
func (s *Service) HuntingCheckAddService(servers []string) (bool, error) {
	if len(servers) == 0 {
		// 获取所有 service
		_, lang, _ := service.SplitServiceName(s.Name())
		servers = readAllServers(lang)
		if servers == nil {
			return false, errors.New("read error")
		}
	}
	// 检查 container 里面是否都有对应的services, 动态添加
	if err := s.AddServicesDynamic(servers, "hunting"); err != nil {
		log.Errorf("some service not in container, %v", err)
		return false, err
	}
	// 检查服务且提交，不中断
	ret, err := s.TransactionCommitNotBreak(servers, s.Name(), Name)
	if err != nil {
		log.Warningf("transaction_commit %s error, %v", s.Name(), err)
		return false, err
	}
	log.Infof("transaction_commit %s %v", s.Name(), ret)
	return true, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}
	s.SetContainer(container)

	s.Register(s, "GenHuntingBattleCards")
	s.Register(s, "RandomHuntingBattleCard")
	s.Register(s, "HuntingBattleCountSub")
	s.Register(s, "HuntingCheckAddService")

	s.Register(s, "TestNotifyGenHuntingCards")
	s.Register(s, "TestCleanDefenceRecordCount")
	s.Register(s, "TestGetHuntingBattleCards")

	return s
}

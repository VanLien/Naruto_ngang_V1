package gym

import (
	"errors"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	tjutil "tjgame/server_framework/tj/util"
	"tjgame/services/cross"
)

const (
	Name = "crossgym"
)

type Service struct {
	*service.Service

	builder *Builder

	gym *CrossGym // CrossGymGlobalObject

	cross.Skeleton

	storage service.IService

	agent service.IService // 反作弊
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

	key := opt.Name
	// load cross gym global
	s.gym = s.builder.NewCrossGymGlobal(key)
	if s.gym == nil {
		return false
	}
	s.gym.container = s.Container()
	s.gym.init(s.builder)
	log.Infof("load %s cross gym round %s", key, s.gym.Round())

	s.Skeleton.Init(s.Name(), Name, s.gym)

	s.gym.SetAgentManager(s.Name(), s.Container().GetService("anticheat"))

	if s.gym.IsOver() {
		// 已结束
		log.Infof("Cross Arena is AllOver True")
		s.gym.clean()
	} else {
		s.MustContainServices(s.gym.Servers(), "gym")
		// 中途重启
		go s.gym.ResetToday()
	}

	go s.StartServiceCheck()

	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.builder.Stop()
}

// 跨服数据同步到 对应game的server
func (s *Service) CrossGymJoin(key string) (*DBForGame, error) {
	_, unlock := s.gym.RLockAndGetDB()
	defer unlock()
	if !s.gym.isServerOK(key) {
		return nil, nil
	}
	return s.gym.dbForGame(), nil
}

// 获取跨服道馆馆员Model
func (s *Service) GetCrossGymModel(roleInfo *scheme.CrossGymRoleInfo) (map[document.Integer]map[document.Integer]*scheme.CrossGymRoleInfo, error) {
	db, unlock := s.gym.LockAndGetDB()
	defer unlock()

	// {gymID: {pos: Object}} 默认第一位是跨服馆主
	crossGymRoles := db.CrossGymRoles

	// 如果自身是跨服道馆馆主/馆员 则更新
	for gymID, roles := range db.CrossGymRoles {
		for pos, role := range roles {
			if role.RoleID == roleInfo.RoleID {
				crossGymRoles[gymID][pos] = roleInfo
			}
		}
	}
	s.gym.SetCrossGymRoles(crossGymRoles)

	return crossGymRoles, nil
}

// 跨服道馆 空直接占坑
func (s *Service) CrossGymBattleOccupy(roleInfo scheme.CrossGymRoleInfo, gymID int, pos int) (bool, error) {
	// 判断round
	isRoundStart := false
	tjutil.WithGuard(s.gym, func() {
		if s.gym.Round() == "start" {
			isRoundStart = true
		}
	})
	if !isRoundStart {
		return false, ErrRoundClosed
	}

	isSelf, err := s.gym.occupyCrossGym(roleInfo, gymID, pos)
	if err != nil {
		return false, err
	}
	if !isSelf {
		// 跨服馆主或馆员 占领日志
		key := CrossGymLeaderOccupy
		if pos != 1 {
			key = CrossGymOccupy
		}
		logInfo := scheme.GymLogInfo{
			Time:  tjutil.NowTime(),
			Type:  key,
			GymID: gymID,
		}

		gameKey := roleInfo.GameKey
		gymService := s.gym.container.GetService(Game2GymService(gameKey))
		_, _ = service.Call(gymService, "AddCrossGymLog", roleInfo.RecordID, logInfo)
	}
	return true, nil
}

// 跨服道馆 开始战斗
func (s *Service) CrossGymBattleStart(roleKey, enemyRoleKey string, recordID, enemyRecordID document.ID, deploy gymDeployment, gymID int, pos int) (*scheme.GymPlayRecordObject, error) {

	// 判断round
	isRoundStart := false
	tjutil.WithGuard(s.gym, func() {
		if s.gym.Round() == "start" {
			isRoundStart = true
		}
	})
	if !isRoundStart {
		return nil, ErrRoundClosed
	}

	ss := s.gym.container.GetService(service.TransformName(roleKey, "gym"))
	ss2 := s.gym.container.GetService(service.TransformName(enemyRoleKey, "gym"))
	record := GetRemoteGymRecord(ss, recordID, 10)
	enemyRecord := GetRemoteGymRecord(ss2, enemyRecordID, 10)
	roleID := record.RoleId
	enemyRoleID := enemyRecord.RoleId

	// 记录战斗
	err := s.gym.storeForRole(gymID, roleID, enemyRoleID, recordID, enemyRecordID, pos)
	if err != nil {
		return &scheme.GymPlayRecordObject{}, err
	}

	playModel := NewPlayModel(record, enemyRecord, roleKey, enemyRoleKey, deploy)
	// create playRecord in storage
	playRecord := s.builder.CreateGymPlayRecord(playModel)

	// 存本场战斗
	playRecordID := playRecord.GetID()
	s.gym.battles.Store(roleID, &battle{
		playRecordID:  playRecordID,
		enemyRoleID:   enemyRoleID,
		enemyRecordID: enemyRecordID,
		gymID:         gymID,
		pos:           pos,
	})

	return playRecord.GymPlayRecordObject, nil
}

// 跨服道馆 结束战斗
func (s *Service) CrossGymBattleEnd(roleID, recordID document.ID, result string, gymID int, pos int) (*ResponseBattleEnd, error) {

	// 判断round
	isRoundStart := false
	tjutil.WithGuard(s.gym, func() {
		if s.gym.Round() == "start" {
			isRoundStart = true
		}
	})
	if !isRoundStart {
		return nil, ErrRoundClosed
	}

	var bb *battle
	if b, ok := s.gym.battles.Load(roleID); ok {
		bb = b.(*battle)
		if bb.gymID != gymID || bb.pos != pos {
			return nil, errors.New("gymID or pos error")
		}
		s.gym.battles.Delete(roleID)
	} else {
		return nil, errors.New("cross battle not found")
	}

	res, err := s.gym.battleEndUpdate(bb, roleID, recordID, result, false, gymID, pos)
	if err != nil {
		return nil, err
	}
	playRecord := s.gym.builder.GetGymPlayRecord(bb.playRecordID)
	gameKey := playRecord.RoleKey()
	defenceGameKey := playRecord.DefenceRoleKey()
	gymService := s.gym.container.GetService(Game2GymService(gameKey))
	defenceGymService := s.gym.container.GetService(Game2GymService(defenceGameKey))
	_, _ = service.Call(gymService, "AddCrossGymLog", playRecord.RecordDbId(), res.LogInfo)
	_, _ = service.Call(defenceGymService, "AddCrossGymLog", playRecord.DefenceRecordId(), res.DefenceLogInfo)

	responseBattleEnd := ResponseBattleEnd{
		Cards:        res.Cards,
		IsSwapDeploy: res.IsSwapDeploy,
	}
	return &responseBattleEnd, err
}

// 获取跨服某道馆馆主/员
func (s *Service) GetCrossGymRole(gymID int, pos int) (*scheme.CrossGymRoleInfo, error) {
	db, unlock := s.gym.LockAndGetDB()
	defer unlock()
	if roles, ok := db.CrossGymRoles[document.Integer(gymID)]; ok {
		if role, ok := roles[document.Integer(pos)]; ok {
			return role, nil
		} else {
			return nil, nil
		}
	} else {
		return nil, nil
	}
}

// 获取跨服道馆 战斗记录
func (s *Service) GetCrossGymPlayRecord(id document.ID) (*scheme.GymPlayRecordObject, error) {
	playRecord := s.builder.GetGymPlayRecord(id)
	if playRecord == nil {
		return nil, nil
	}
	return playRecord.GymPlayRecordObject, nil
}

// 测试 开始道馆
func (s *Service) StartCrossGym(id int, servers []string, quick bool) (bool, error) {
	round := s.gym.Round()
	if round != "closed" {
		return false, errors.New("gym already start")
	}
	// 检查 container 里面是否都有对应的services, 动态添加
	if err := s.AddServicesDynamic(servers, "gym"); err != nil {
		log.Errorf("some service not in container, %v", err)
		return false, err
	}
	ret, err := s.TransactionCommit(servers, s.Name(), Name)
	if err != nil {
		log.Warningf("transaction_commit %s error, %v", s.Name(), err)
		return false, err
	}
	log.Infof("transaction_commit %s %v", s.Name(), ret)
	if ret {
		// 替换为原始key
		cfg := csv.GetMergeConfig()
		origins := make([]string, 0, len(servers))
		for _, key := range servers {
			origins = append(origins, cfg.GetSrcServKeys(key)...)
		}
		servers = origins
		// 检查 container 里面是否都有对应的services, 动态添加
		if err := s.AddServicesDynamic(servers, "gym"); err != nil {
			log.Errorf("some service not in container, %v", err)
			return false, err
		}
		s.gym.OnInit(id, servers)
	}
	return true, nil
}

// 测试 快速结束道馆
func (s *Service) CloseCrossGym() (bool, error) {
	if s.gym.Round() != "start" {
		return false, ErrRoundClosed
	}
	s.gym.onClosed()
	return true, nil
}

// 测试 强制结束道馆（异常情况未结束，且cross重启后round已变closed）
func (s *Service) ForceCloseCrossGym() (bool, error) {
	s.gym.onClosed()
	return true, nil
}

// 测试 发跨服馆主/馆员奖励
func (s *Service) CrossGymAward() (bool, error) {
	s.gym.onCrossGymAward()
	return true, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}
	s.SetContainer(container)

	s.Register(s, "CrossGymJoin")
	s.Register(s, "GetCrossGymModel")
	s.Register(s, "CrossGymBattleOccupy")
	s.Register(s, "CrossGymBattleStart")
	s.Register(s, "CrossGymBattleEnd")
	s.Register(s, "GetCrossGymRole")
	s.Register(s, "GetCrossGymPlayRecord")

	s.Register(s, "StartCrossGym")
	s.Register(s, "CloseCrossGym")
	s.Register(s, "ForceCloseCrossGym")
	s.Register(s, "CrossGymAward")

	return s
}

// 获取道馆 record
func GetRemoteGymRecord(s service.IService, recordID document.ID, timeout time.Duration) *scheme.GymRecord {
	resp, err := service.Call(s, "GetGymRecord", recordID)
	if err != nil {
		panic(err)
	}
	record := resp.(*scheme.GymRecordObject)
	db, unlock := record.RLockAndGetDB()
	defer unlock()
	return db
}

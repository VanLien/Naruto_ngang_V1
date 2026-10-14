package gym

import (
	"errors"
	"strings"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	tjutil "tjgame/server_framework/tj/util"
	"tjgame/services/storage"
)

const (
	Name = "gym"
)

type Service struct {
	*service.Service
	builder *Builder
	gym     *Gym // GymGlobalObject
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
	ss := s.Container().GetService(storage.GetNameFromDependent(opt.Dependent))
	s.builder = NewBuilder(ss)

	key := opt.Name
	// load gym global
	s.gym = s.builder.NewGymGlobal(key)
	if s.gym == nil {
		return false
	}
	s.gym.container = s.Container()
	gameKey := strings.Replace(opt.Name, Name, "game", 1)
	s.gym.init(s.Container().GetService(gameKey), s.builder)
	log.Infof("load %s gym global", key)

	// 启动
	go s.gym.ResetToday()

	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.builder.Stop()
}

// 创建道馆Record
func (s *Service) CreateGymRecord(role gymCompetitor) (document.ID, error) {
	record := document.New("GymRecord", true).(*scheme.GymRecord)

	// 创建只构建 roleInfo
	record.RoleId = role.ID
	record.RoleName = role.Name
	record.RoleLogo = role.Logo
	record.RoleFrame = role.Frame
	record.RoleLevel = role.Level
	record.RoleVip = role.Vip
	record.RoleFigure = role.Figure

	// create GymRecord in storage
	r := s.builder.CreateGymRecord(record)

	return r.GetID(), nil
}

// 获取道馆Record
func (s *Service) GetGymRecord(id document.ID) (*scheme.GymRecordObject, error) {
	record := s.builder.GetGymRecord(id)
	return record.GymRecordObject, nil
}

// 获取道馆馆主信息
func (s *Service) GetGymLeaderRoles(roleInfo *scheme.GymRoleInfo) (map[document.Integer]*scheme.GymRoleInfo, error) {
	db, unlock := s.gym.LockAndGetDB()
	defer unlock()
	if db.Round != "start" {
		return nil, ErrRoundClosed
	}

	leaderRoles := db.LeaderRoles
	// 如果自身是道馆馆主则更新
	for gymID, roles := range db.LeaderRoles {
		if roles.RoleID == roleInfo.RoleID {
			leaderRoles[gymID] = roleInfo
		}
	}
	s.gym.SetLeaderRoles(leaderRoles)

	return leaderRoles, nil
}

// 道馆阵容更新
func (s *Service) GymRefreshRecord(recordID document.ID, role gymCompetitor, deploy gymDeployment) (bool, error) {
	record := s.builder.GetGymRecord(recordID)
	record.deployCards(role, deploy)
	return true, nil
}

// 道馆重置
func (s *Service) GymReset(recordID document.ID) (bool, error) {
	record := s.builder.GetGymRecord(recordID)
	// 阵容重置
	record.resetCards()
	// 清除日志
	record.clearLogs()
	return true, nil
}

// 道馆清除阵容
func (s *Service) GymClearCards(recordID document.ID, keys []string) (bool, error) {
	record := s.builder.GetGymRecord(recordID)
	_, unlock := record.LockAndGetDB()
	defer unlock()
	for _, key := range keys {
		if key == "cards" {
			record.SetCards([]document.ID{})
			record.SetCardAttrs(map[document.ID]*scheme.CardBattleModel{})
			record.SetPassiveSkills(map[document.Integer]int{})
		} else if key == "cross_cards" {
			record.SetCrossCards([]document.ID{})
			record.SetCrossCardAttrs(map[document.ID]*scheme.CardBattleModel{})
			record.SetCrossPassiveSkills(map[document.Integer]int{})
		}
	}
	return true, nil
}

// 获取防守布阵卡牌
func (s *Service) GetGymBattleCards(id document.ID) (map[string][]document.ID, error) {
	record := s.builder.GetGymRecord(id)
	cardsMap := make(map[string][]document.ID)

	cardsMap["cards"] = record.Cards()
	cardsMap["cross_cards"] = record.CrossCards()
	return cardsMap, nil
}

// 荣誉道馆馆主 开始战斗
func (s *Service) GymLeaderBattleStart(recordID, enemyRecordID document.ID, deploy gymDeployment, gymID int) (*scheme.GymPlayRecordObject, error) {

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

	record := s.builder.GetGymRecord(recordID)
	enemyRecord := s.builder.GetGymRecord(enemyRecordID)
	roleID := record.RoleId()
	enemyRoleID := enemyRecord.RoleId()
	// 记录战斗
	err := s.gym.storeForRole(gymID, roleID, enemyRoleID, recordID, enemyRecordID)
	if err != nil {
		return &scheme.GymPlayRecordObject{}, err
	}

	playModel := NewPlayModel(record, enemyRecord, deploy)
	// create playRecord in storage
	playRecord := s.builder.CreateGymPlayRecord(playModel)

	// 存本场战斗
	playRecordID := playRecord.GetID()
	s.gym.battles.Store(roleID, &battle{
		playRecordID:  playRecordID,
		enemyRoleID:   enemyRoleID,
		enemyRecordID: enemyRecordID,
		gymID:         gymID,
	})

	return playRecord.GymPlayRecordObject, nil
}

// 荣誉道馆馆主 结束战斗
func (s *Service) GymLeaderBattleEnd(roleID, recordID document.ID, result string, gymID int) (*ResponseBattleEnd, error) {

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
		if bb.gymID != gymID {
			return nil, errors.New("gymID error")
		}
		s.gym.battles.Delete(roleID)
	} else {
		return nil, errors.New("battle not found")
	}

	return s.gym.battleEndUpdate(bb, roleID, recordID, result, false, gymID)
}

// 荣誉道馆馆主 空直接占坑
func (s *Service) GymLeaderBattleOccupy(roleInfo scheme.GymRoleInfo, gymID int) (bool, error) {

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

	err := s.gym.occupyGymLeader(roleInfo, gymID)
	if err != nil {
		return false, err
	}
	return true, nil
}

// 获取某道馆馆主
func (s *Service) GetGymLeader(gymID int) (*scheme.GymRoleInfo, error) {
	db, unlock := s.gym.LockAndGetDB()
	defer unlock()
	if role, ok := db.LeaderRoles[document.Integer(gymID)]; ok {
		return role, nil
	} else {
		return nil, nil
	}
}

// 获取战斗记录
func (s *Service) GetGymPlayRecord(id document.ID) (*scheme.GymPlayRecordObject, error) {
	playRecord := s.builder.GetGymPlayRecord(id)
	if playRecord == nil {
		return nil, nil
	}
	return playRecord.GymPlayRecordObject, nil
}

// 道馆副本通关
func (s *Service) GymFubenPass(recordID document.ID, gymID int, allPassNum int) (bool, error) {
	db, unlock := s.gym.LockAndGetDB()
	defer unlock()
	// 记录通关数量
	if db.PassNums == nil {
		db.PassNums = make(map[document.ID]int)
	}
	db.PassNums[recordID] = allPassNum
	s.gym.SetPassNums(db.PassNums)

	record := s.builder.GetGymRecord(recordID)
	// 某某副本通关日志
	logInfo1 := scheme.GymLogInfo{
		Time:  tjutil.NowTime(),
		Type:  GymFubenPass,
		GymID: gymID,
	}
	record.addLog(logInfo1)
	// 全通关 日志
	if allPassNum == len(csv.GetConfig().Gym.Gym) {
		logInfo2 := scheme.GymLogInfo{
			Time: tjutil.NowTime(),
			Type: GymAllPass,
		}
		record.addLog(logInfo2)
	}
	return true, nil
}

// 添加 跨服道馆战斗日志
func (s *Service) AddCrossGymLog(recordID document.ID, logInfo scheme.GymLogInfo) (bool, error) {
	record := s.builder.GetGymRecord(recordID)
	record.addLog(logInfo)
	return true, nil
}

// 添加 跨服道馆结束馆主数据
func (s *Service) AddCrossGymID(recordID document.ID, info scheme.GymCloseInfo) (bool, error) {
	record := s.builder.GetGymRecord(recordID)
	record.setCloseLog(info)
	return true, nil
}

// 清除本周日志
func (s *Service) ClearLogs(recordID document.ID) (bool, error) {
	record := s.builder.GetGymRecord(recordID)
	record.clearLogs()
	return true, nil
}

// 清除全部日志
func (s *Service) ClearAllLogs(recordID document.ID) (bool, error) {
	record := s.builder.GetGymRecord(recordID)
	record.clearAllLogs()
	return true, nil
}

// 测试 开始道馆
func (s *Service) StartGym(quick bool) (bool, error) {
	round := s.gym.Round()
	if round != "closed" {
		return false, errors.New("gym already start")
	}
	TestInQuick = quick
	s.gym.onPrepare()
	return true, nil
}

// 测试 结束道馆
func (s *Service) CloseGym() (bool, error) {
	if s.gym.Round() != "start" {
		return false, ErrRoundClosed
	}
	s.gym.onClosed()
	return true, nil
}

// 测试 发荣誉道馆奖励
func (s *Service) GymLeaderAward() (bool, error) {
	s.gym.onLeaderAward()
	return true, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}
	// Gym
	s.Register(s, "CreateGymRecord")
	s.Register(s, "GetGymRecord")
	s.Register(s, "GetGymLeaderRoles")
	s.Register(s, "GymRefreshRecord")
	s.Register(s, "GetGymBattleCards")
	s.Register(s, "GymLeaderBattleStart")
	s.Register(s, "GymLeaderBattleEnd")
	s.Register(s, "GymLeaderBattleOccupy")
	s.Register(s, "GetGymLeader")
	s.Register(s, "GymReset")
	s.Register(s, "GetGymPlayRecord")
	s.Register(s, "GymFubenPass")
	s.Register(s, "AddCrossGymLog")
	s.Register(s, "AddCrossGymID")
	s.Register(s, "ClearLogs")
	s.Register(s, "ClearAllLogs")
	s.Register(s, "GymClearCards")

	s.Register(s, "StartGym")
	s.Register(s, "CloseGym")
	s.Register(s, "GymLeaderAward")

	return s
}

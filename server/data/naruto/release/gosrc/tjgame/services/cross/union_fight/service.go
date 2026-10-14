/*
 * @Date    : 2021/9/9 22:39
 * @File    : service.go
 * @Version : 1.0.0
 * @Author  : hss
 * @Note    :
 *
 */

package union_fight

import (
	"errors"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/services/cross"
)

const (
	Name = "crossunionfight"
)

type Service struct {
	*service.Service

	builder *Builder

	crossunionfight *CrossUnionFightGlobal // CrossUnionFightGlobal

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

	// crossunionfight.dev.1
	key := opt.Name

	// load cross union fight global
	s.crossunionfight = s.builder.NewCrossUnionFightGlobal(key)
	if s.crossunionfight == nil {
		return false
	}
	s.crossunionfight.container = s.Container()
	s.crossunionfight.init(s.builder, s.Name(), s.Container().GetService("anticheat"))
	log.Infof("load %s cross union fight status %s", key, s.crossunionfight.Status())

	// cross OnInit、ResetToday
	s.Skeleton.Init(s.Name(), Name, s.crossunionfight)
	if s.crossunionfight.IsOver() {
		log.Infof("cross union fight is AllOver True")
		s.crossunionfight.clean()
	} else {
		s.MustContainServices(s.crossunionfight.Servers(), "pvp")
		go s.crossunionfight.ResetToday()
	}

	// anticheat
	s.crossunionfight.SetAgentManager(s.Name(), s.Container().GetService("anticheat"))

	go s.StartServiceCheck()

	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.builder.Stop()
}

// 跨服部屋 加入服务 server_key
func (s *Service) CrossUnionFightJoin(key string) (*DBForGame, error) {
	_, unlock := s.crossunionfight.RLockAndGetDB()
	defer unlock()
	if !s.crossunionfight.isServerOK(key) {
		return nil, nil
	}
	return s.crossunionfight.getDBForGame(), nil
}

// 跨服部屋 主界面main
func (s *Service) GetCrossUnionFightModel(roleInfo *ResRoleInfo) (resp RespMainModel, err error) {
	db, unlock := s.crossunionfight.LockAndGetDB()
	defer unlock()

	roles := db.Roles
	// 更新Roles
	if crossUnionFightRoleInfo, ok := roles[roleInfo.RoleDbId]; ok {
		crossUnionFightRoleInfo.RoleDbId = roleInfo.RoleDbId
		crossUnionFightRoleInfo.RecordID = roleInfo.RecordID
		crossUnionFightRoleInfo.ServerKey = roleInfo.ServerKey
		crossUnionFightRoleInfo.RoleName = roleInfo.RoleName
		crossUnionFightRoleInfo.RoleLevel = roleInfo.RoleLevel
		crossUnionFightRoleInfo.RoleFigure = roleInfo.RoleFigure
		crossUnionFightRoleInfo.RoleLogo = roleInfo.RoleLogo
		crossUnionFightRoleInfo.RoleFrame = roleInfo.RoleFrame
	}
	s.crossunionfight.SetRoles(roles)

	unions := db.Unions
	if roleInfo.UnionDbId != "" {
		// 更新Unions 存在且同公会才更新 否则不更新
		if unionInfo, ok := unions[roleInfo.UnionDbId]; ok {
			if unionInfo.UnionDbId == roleInfo.UnionDbId {
				unionInfo.UnionName = roleInfo.UnionName
				unionInfo.UnionLogo = roleInfo.UnionLogo
				// 只有会长才能更新
				if roleInfo.RoleDbId == roleInfo.ChairmanID {
					unionInfo.ChairmanName = roleInfo.ChairmanName
					unionInfo.ChairmanFigure = roleInfo.ChairmanFigure
					unionInfo.ChairmanTitle = roleInfo.ChairmanTitle
				}
			}
		}
		s.crossunionfight.SetUnions(unions)
	}

	// PreBattleGroups
	resp.PreBattleGroups = db.PreBattleGroups
	// TopBattleGroups
	resp.TopBattleGroups = db.TopBattleGroups
	// Roles
	resp.Roles = db.Roles
	// Unions
	resp.Unions = db.Unions

	return
}

// 跨服部屋 比赛中战报 获取
func (s *Service) GetCrossUnionFightBattleResult(group, project, start int, roleID document.ID) ([]*scheme.CrossUnionFightResultInfo, error) {
	resp := s.crossunionfight.getBattleResults(group, project, start)

	return resp, nil
}

// 跨服部屋 选择战场
func (s *Service) CrossUnionFightChooseProject(roleID document.ID, stage, project, fightingPoint int) (bool, error) {
	db, unlock := s.crossunionfight.LockAndGetDB()
	defer unlock()
	if _, ok := db.Roles[roleID]; !ok {
		return false, ErrRoleNotJoin
	}
	if stage <= 0 || stage > 2 {
		return false, ErrStage
	}
	if project <= 0 || project > 3 {
		return false, ErrProject
	}

	roleInfo := db.Roles[roleID]
	roleInfo.Projects[document.Integer(stage)] = project
	if fightingPoint != 0 {
		roleInfo.FightingPoint = fightingPoint
	}
	s.crossunionfight.SetRoles(db.Roles)

	// 战场分布修改
	s.crossunionfight.updateDeployRoles(roleID, roleInfo.UnionDbId, stage, project)

	return true, nil
}

// 跨服部屋 战斗回放
func (s *Service) GetCrossUnionFightPlayRecord(id document.ID) (*scheme.CrossUnionFightPlayRecordObject, error) {
	playRecord := s.builder.GetCrossUnionFightPlayRecord(id)
	if playRecord == nil {
		return nil, nil
	}
	return playRecord.CrossUnionFightPlayRecordObject, nil
}

// 跨服部屋 押注信息
func (s *Service) GetCrossUnionFightBets() (map[document.Integer]map[document.ID]*scheme.CrossUnionFightBet, error) {
	db, unlock := s.crossunionfight.LockAndGetDB()
	defer unlock()
	bets := db.Bets
	return bets, nil
}

// 跨服部屋 押注操作
func (s *Service) CrossUnionFightBetUnion(roleID document.ID, gameKey string, group int, unionID document.ID) (map[document.Integer]map[document.ID]*scheme.CrossUnionFightBet, error) {
	db, unlock := s.crossunionfight.LockAndGetDB()
	defer unlock()
	flag := false
	if group != TopGroup {
		if groupInfos, ok := db.PreBattleGroups[document.Integer(group)]; ok {
			for _, unionInfo := range groupInfos {
				if unionInfo.UnionDbId == unionID {
					flag = true
				}
			}
		}
	} else {
		for _, unionInfo := range db.TopBattleGroups {
			if unionInfo.UnionDbId == unionID {
				flag = true
			}
		}
	}
	if !flag {
		return nil, ErrBet
	}
	bets := db.Bets
	if groupBets, ok := bets[document.Integer(group)]; ok {
		if betInfo, ok := groupBets[unionID]; ok {
			roleKey := scheme.RoleKey{}
			roleKey.GameKey = gameKey
			roleKey.ID = roleID
			betInfo.RoleKeys = append(betInfo.RoleKeys, roleKey)
			groupBets[unionID] = betInfo
		} else {
			roleKey := scheme.RoleKey{}
			roleKey.GameKey = gameKey
			roleKey.ID = roleID
			betInfo := &scheme.CrossUnionFightBet{
				RoleKeys: []scheme.RoleKey{roleKey},
				Success:  false,
			}
			groupBets[unionID] = betInfo
		}
		bets[document.Integer(group)] = groupBets
	} else {
		roleKey := scheme.RoleKey{}
		roleKey.GameKey = gameKey
		roleKey.ID = roleID
		betInfo := &scheme.CrossUnionFightBet{
			RoleKeys: []scheme.RoleKey{roleKey},
			Success:  false,
		}
		groupBets = map[document.ID]*scheme.CrossUnionFightBet{unionID: betInfo}
		bets[document.Integer(group)] = groupBets
	}

	s.crossunionfight.SetBets(db.Bets)
	return bets, nil
}

// 跨服部屋 战场分布
func (s *Service) GetCrossUnionFightDeployRoles(stage int, unionID document.ID) (map[document.Integer][]document.ID, error) {
	db, unlock := s.crossunionfight.LockAndGetDB()
	defer unlock()
	unions := db.Unions
	unionInfo, ok := unions[unionID]
	var deployRoles map[document.Integer][]document.ID
	if !ok {
		return deployRoles, ErrUnionNotJoin
	}
	if stage == PreStage {
		deployRoles = unionInfo.PreDeployRoles
	} else {
		deployRoles = unionInfo.TopDeployRoles
	}

	return deployRoles, nil
}

// 测试 开始准备
func (s *Service) TestPrepareCrossUnionFight(id int, servers []string, quick bool) (bool, error) {
	status := s.crossunionfight.Status()
	if status != "closed" {
		return false, errors.New("cross union fight not closed")
	}
	// 检查 container 里面是否都有对应的services, 动态添加
	if err := s.AddServicesDynamic(servers); err != nil {
		log.Errorf("some service not in container, %v", err)
		return false, err
	}
	ret, err := s.TransactionCommit(servers, s.Name(), Name)
	if err != nil {
		log.Warningf("transaction_commit %s error, %v", s.Name(), err)
		return false, err
	}
	log.Infof("CrossUnionFight transaction_commit %s %v", s.Name(), ret)
	if ret {
		TestInQuick = quick
		// 替换为原始key
		cfg := csv.GetMergeConfig()
		origins := make([]string, 0, len(servers))
		for _, key := range servers {
			origins = append(origins, cfg.GetSrcServKeys(key)...)
		}
		servers = origins
		// 检查 container 里面是否都有对应的services, 动态添加
		if err := s.AddServicesDynamic(servers, "pvp"); err != nil {
			log.Errorf("some service not in container, %v", err)
			return false, err
		}
		s.crossunionfight.OnInit(id, servers)
	}
	return true, nil
}

// 测试 下一个状态
func (s *Service) TestNextStatusCrossUnionFight() (bool, error) {
	if s.crossunionfight.timer == nil {
		return false, errors.New("no timer found")
	}
	if s.crossunionfight.timer.Stop() {
		status := s.crossunionfight.Status()
		s.crossunionfight.timer.Reset(time.Second)
		log.Infof("cross union fight reset timer status %s next", status)
	} else {
		return false, errors.New("timer function already started in its own goroutine")
	}
	return true, nil
}

// 测试 快速结束玩法状态
func (s *Service) TestCloseCrossUnionFight() (bool, error) {
	status := s.crossunionfight.Status()
	switch status {
	case StatusClosed:
		return false, errors.New("cross union fight is closed")
	case StatusPreBattle:
		return false, errors.New("cross union fight is preBattle")
	case StatusTopBattle:
		return false, errors.New("cross union fight is topBattle")
	}
	s.crossunionfight.onClosed()
	return true, nil
}

// 测试 强制结束玩法状态
func (s *Service) TestForceCloseCrossUnionFight() (bool, error) {
	//status := s.crossunionfight.Status()
	//if status == StatusClosed {
	//	return false, errors.New("cross union fight is closed")
	//}
	s.crossunionfight.onClosed()
	return true, nil
}

func (s *Service) TestSetCrossUnionFightQuick(quick bool) (bool, error) {
	TestInQuick = quick
	return true, nil
}

func (s *Service) TestCrossUnionFightCancel() (bool, error) {
	status := s.crossunionfight.Status()
	switch status {
	case StatusClosed:
		return false, errors.New("cross union fight is closed")
	case StatusPreBattle:
		return false, errors.New("cross union fight is preBattle")
	case StatusTopBattle:
		return false, errors.New("cross union fight is topBattle")
	}
	if s.crossunionfight.timer != nil {
		if s.crossunionfight.timer.Stop() {
			log.Infof("Cross Union Fight Cancel")
			s.crossunionfight.onClosed()
			return true, nil
		} else {
			return false, errors.New("timer function already started in its own goroutine")
		}
	}
	return true, nil
}

func (s *Service) TestCrossUnionFightStop() (bool, error) {
	if s.crossunionfight.timer == nil {
		return false, errors.New("no timer found")
	}
	if s.crossunionfight.timer.Stop() {
		status := s.crossunionfight.Status()
		log.Infof("Cross Union Fight Stop Timer status %s", status)
	} else {
		return false, errors.New("timer function already started in its own goroutine")
	}
	return true, nil
}

func (s *Service) TestCrossUnionFightResume() (bool, error) {
	if s.crossunionfight.timer == nil {
		return false, errors.New("no timer found")
	}
	s.crossunionfight.timer.Stop()
	status := s.crossunionfight.Status()
	s.crossunionfight.timer.Reset(time.Second * 5)
	log.Infof("Cross Union Fight Resume Timer Round %s", status)
	return true, nil
}

func (s *Service) ResetAgentManager() (bool, error) {
	s.crossunionfight.mgr.Reset()
	return true, nil
}

func (s *Service) ResetAgentManagerLastAvgRespDur() (bool, error) {
	s.crossunionfight.mgr.ResetLastAvgRespDur()
	return true, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}
	s.SetContainer(container)

	s.Register(s, "CrossUnionFightJoin")
	s.Register(s, "GetCrossUnionFightModel")
	s.Register(s, "GetCrossUnionFightBattleResult")
	s.Register(s, "CrossUnionFightChooseProject")
	s.Register(s, "GetCrossUnionFightPlayRecord")
	s.Register(s, "GetCrossUnionFightBets")
	s.Register(s, "CrossUnionFightBetUnion")
	s.Register(s, "GetCrossUnionFightDeployRoles")

	s.Register(s, "TestPrepareCrossUnionFight")
	s.Register(s, "TestCloseCrossUnionFight")
	s.Register(s, "TestNextStatusCrossUnionFight")
	s.Register(s, "TestForceCloseCrossUnionFight")
	s.Register(s, "TestSetCrossUnionFightQuick")
	s.Register(s, "TestCrossUnionFightCancel")
	s.Register(s, "TestCrossUnionFightStop")
	s.Register(s, "TestCrossUnionFightResume")
	s.Register(s, "ResetAgentManager")
	s.Register(s, "ResetAgentManagerLastAvgRespDur")

	return s
}

// 远程跨服公会战 roleRecord
func GetRemoteCrossUnionFightRoleRecord(s service.IService, recordID document.ID) *scheme.CrossUnionFightRoleRecord {
	resp, err := service.Call(s, "GetCrossUnionFightRoleRecord", recordID)
	if err != nil {
		panic(err)
	}
	record := resp.(*scheme.CrossUnionFightRoleRecordObject)
	db, unlock := record.RLockAndGetDB()
	defer unlock()
	return db
}

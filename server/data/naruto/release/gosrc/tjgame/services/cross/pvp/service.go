package pvp

import (
	"errors"
	"sync"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/document/schemeutil"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/services/storage"
)

const (
	Name = "pvp"
)

type Service struct {
	*service.Service
	builder *Builder
}

func (s *Service) Init() bool {
	if ok := s.Service.Init(); !ok {
		return false
	}

	return true
}

func (s *Service) Start() bool {
	opt := s.Option.Base()
	ss := s.Container().GetService(storage.GetNameFromDependent(opt.Dependent))
	s.builder = NewBuilder(ss)

	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.builder.Stop()
}

func (s *Service) CreateCrossCraftRecord(role competitor, deploy deployment) (document.ID, error) {
	record := document.New("CrossCraftRecord", true).(*scheme.CrossCraftRecord)
	record.RoleDbId = role.ID
	record.RoleName = role.Name
	record.RoleLogo = role.Logo
	record.RoleFrame = role.Frame
	record.RoleLevel = role.Level
	record.RoleFigure = role.Figure
	record.HoldCards = deploy.Cards
	record.HoldCardAttrs = deploy.CardAttrs
	record.HoldCardAttrs2 = deploy.CardAttrs2
	record.HoldPassiveSkills = deploy.PassiveSkills

	r := s.builder.CreateCrossCraftRecord(record)
	return r.GetID(), nil
}

type robot struct {
	competitor
	deployment
}

func (s *Service) CreateRobotCrossCraftRecordBulk(robots []robot) (bool, error) {
	records := make([]*scheme.CrossCraftRecord, 0, len(robots))
	for _, robot := range robots {
		record := document.New("CrossCraftRecord", true).(*scheme.CrossCraftRecord)
		record.RoleDbId = robot.ID
		record.RoleName = robot.Name
		record.RoleLogo = robot.Logo
		record.RoleFrame = robot.Frame
		record.RoleLevel = robot.Level
		record.RoleFigure = robot.Figure
		record.Cards = robot.Cards
		record.CardAttrs = robot.CardAttrs
		record.CardAttrs2 = robot.CardAttrs2

		record.Robot = true
		record.ID = robot.ID // robot craft record id is robot role id

		records = append(records, record)
	}
	job := func(record *scheme.CrossCraftRecord) {
		s.builder.CreateCrossCraftRecord(record)
	}

	var wg sync.WaitGroup
	wg.Add(len(records))
	for _, record := range records {
		go func(r *scheme.CrossCraftRecord) {
			job(r)
			wg.Done()
		}(record)
	}
	wg.Wait()

	return true, nil
}

func (s *Service) CrossCraftRecordPrepare(recordID document.ID, manual bool) (bool, error) {
	record := s.builder.GetCrossCraftRecord(recordID)
	record.prepare(manual) // 清理历史记录，整理阵容、卡牌属性
	broken := record.checkBroken()
	return broken, nil
}

func (s *Service) CrossCraftDeploy(recordID document.ID, role competitor, deploy deployment, round string, lockcard bool) (bool, error) {
	record := s.builder.GetCrossCraftRecord(recordID)
	err := record.deployCards(deploy, round, lockcard)
	record.updateRole(role)
	return err == nil, err
}

func (s *Service) CrossCraftDeployHold(recordID document.ID, role competitor, deploy deployment) (bool, error) {
	record := s.builder.GetCrossCraftRecord(recordID)
	record.deployHoldCard(deploy)
	record.updateRole(role)
	return true, nil
}

func (s *Service) GetCrossCraftRecord(id document.ID) (*scheme.CrossCraftRecordObject, error) {
	record := s.builder.GetCrossCraftRecord(id)
	return record.CrossCraftRecordObject, nil
}

func (s *Service) CrossCraftAddHistory(id document.ID, model *scheme.CrossCraftPlayRecord, key string) (bool, error) {
	record := s.builder.GetCrossCraftRecord(id)
	if model.DefenceRoleKey.ID == "" {
		record.addByeHistory(model)
	} else {
		record.addHistoryFromPlay(model, key)
	}
	return true, nil
}

type RoleCrossCraftView struct {
	Cards     []document.ID                           `codec:"cards"`
	CardAttrs map[document.ID]*scheme.CardBattleModel `codec:"card_attrs"`
	History   []scheme.CrossCraftBattleHistory        `codec:"history"`
}

func (s *Service) GetCrossCraftView(roleID document.ID, recordID document.ID, prepareok bool) (*RoleCrossCraftView, error) {
	record := s.builder.GetCrossCraftRecord(recordID)
	record.RLock()
	view := &RoleCrossCraftView{
		History: record.History(),
	}
	if prepareok {
		view.Cards = schemeutil.CopyCards(record.Cards())
		view.CardAttrs = schemeutil.CopyCardAttrs(record.CardAttrs())
	} else {
		view.Cards = schemeutil.CopyCards(record.HoldCards())
		view.CardAttrs = schemeutil.CopyCardAttrs(record.HoldCardAttrs())
	}
	record.RUnlock()
	return view, nil
}

func (s *Service) GetCrossCraftBattleCards(id document.ID) ([]document.ID, error) {
	record := s.builder.GetCrossCraftRecord(id)
	if record == nil {
        // chưa có record, trả về rỗng
    	log.Infof("CrossCraftRecord not found", "id", id)
        return []document.ID{}, nil
    }
	return record.HoldCards(), nil
}

// 创建跨服竞技场Record
func (s *Service) CreateCrossArenaRecord(role arenaCompetitor, deploy arenaDeployment, robot bool) (document.ID, error) {
	record := document.New("CrossArenaRecord", true).(*scheme.CrossArenaRecord)
	record.RoleDbId = role.ID
	record.RoleName = role.Name
	record.RoleLogo = role.Logo
	record.RoleFrame = role.Frame
	record.RoleLevel = role.Level
	record.RoleVip = role.Vip
	record.RoleFigure = role.Figure

	record.Cards = deploy.Cards
	record.CardAttrs = deploy.CardAttrs
	record.CardAttrs2 = deploy.CardAttrs2
	record.PassiveSkills = deploy.PassiveSkills
	record.DefenceCards = deploy.DefenceCards
	record.DefenceCardAttrs = deploy.DefenceCardAttrs
	record.DefenceCardAttrs2 = deploy.DefenceCardAttrs2
	record.DefencePassiveSkills = deploy.DefencePassiveSkills

	record.Robot = robot

	// create CrossArenaRecord in storage
	r := s.builder.CreateCrossArenaRecord(record)

	return r.GetID(), nil
}

// 跨服竞技场部署
func (s *Service) CrossArenaDeployCards(recordID document.ID, role arenaCompetitor, deploy arenaDeployment) (bool, error) {
	record := s.builder.GetCrossArenaRecord(recordID)
	record.deployCards(role, deploy)
	return true, nil
}

// 获取跨服竞技场Record
func (s *Service) GetCrossArenaRecord(id document.ID) (*scheme.CrossArenaRecordObject, error) {
	record := s.builder.GetCrossArenaRecord(id)
	return record.CrossArenaRecordObject, nil
}

// 跨服竞技场添加战斗历史
func (s *Service) CrossArenaAddHistory(id document.ID, enemyRank, rank, move int, model *scheme.CrossArenaPlayRecord, key string) (bool, error) {
	record := s.builder.GetCrossArenaRecord(id)
	record.addHistory(enemyRank, rank, move, model, key)
	return true, nil
}

// 构建 跨服竞技场机器人Record
func (s *Service) CreateRobotCrossArenaRecordBulk(robots []arenaRecord) (bool, error) {
	records := make([]*scheme.CrossArenaRecord, 0, len(robots))
	for _, robot := range robots {
		record := document.New("CrossArenaRecord", true).(*scheme.CrossArenaRecord)
		record.RoleDbId = robot.ID
		record.RoleName = robot.Name
		record.RoleLogo = robot.Logo
		record.RoleFrame = robot.Frame
		record.RoleLevel = robot.Level
		record.RoleFigure = robot.Figure
		record.RoleVip = robot.Vip

		// 机器人没有全局被动技能
		record.Cards = robot.Cards
		record.CardAttrs = robot.CardAttrs
		record.CardAttrs2 = robot.CardAttrs2
		record.DefenceCards = robot.DefenceCards
		record.DefenceCardAttrs = robot.DefenceCardAttrs
		record.DefenceCardAttrs2 = robot.DefenceCardAttrs2

		record.Robot = true
		record.ID = robot.ID // robot arena record id is robot role id

		records = append(records, record)
	}
	job := func(record *scheme.CrossArenaRecord) {
		s.builder.CreateCrossArenaRecord(record)
	}

	var wg sync.WaitGroup
	wg.Add(len(records))
	for _, record := range records {
		go func(r *scheme.CrossArenaRecord) {
			job(r)
			wg.Done()
		}(record)
	}
	wg.Wait()

	return true, nil
}

// 获取防守布阵卡牌
func (s *Service) GetCrossArenaBattleCards(id document.ID) (map[string][]document.ID, error) {
	record := s.builder.GetCrossArenaRecord(id)
	cardsMap := make(map[string][]document.ID)

	cards := getCardsByMap(record.Cards())
	cardsMap["cards"] = cards

	defenceCards := getCardsByMap(record.DefenceCards())
	cardsMap["defence_cards"] = defenceCards
	return cardsMap, nil
}

// 跨服竞技场删除历史战报
func (s *Service) CleanCrossArenaHistory(id document.ID) (bool, error) {
	record := s.builder.GetCrossArenaRecord(id)
	record.cleanHistory()
	return true, nil
}

// 创建实时对战Record
func (s *Service) CreateCrossOnlineFightRecord(role competitor, deploy deployment) (document.ID, error) {
	record := document.New("CrossOnlineFightRecord", true).(*scheme.CrossOnlineFightRecord)
	record.RoleDbId = role.ID
	record.RoleName = role.Name
	record.RoleLogo = role.Logo
	record.RoleFrame = role.Frame
	record.RoleLevel = role.Level
	record.RoleFigure = role.Figure

	record.Cards = deploy.Cards
	record.CardAttrs = deploy.CardAttrs
	record.CardAttrs2 = deploy.CardAttrs2
	record.PassiveSkills = deploy.PassiveSkills

	r := s.builder.CreateCrossOnlineFightRecord(record)
	return r.GetID(), nil
}

// 获取实时对战Record
func (s *Service) GetCrossOnlineFightRecord(id document.ID) (*scheme.CrossOnlineFightRecordObject, error) {
	record := s.builder.GetCrossOnlineFightRecord(id)
	return record.CrossOnlineFightRecordObject, nil
}

// 实时对战部署
func (s *Service) CrossOnlineFightDeployCards(recordID document.ID, role competitor, deploy deployment) (bool, error) {
	record := s.builder.GetCrossOnlineFightRecord(recordID)
	record.deployCards(deploy)
	record.updateRole(role)
	return true, nil
}

func (s *Service) CrossOnlineFightAddHistory(id document.ID, pattern int, history *scheme.CrossOnlineFightHistory) (bool, error) {
	record := s.builder.GetCrossOnlineFightRecord(id)
	record.addHistory(pattern, history)
	return true, nil
}

// 实时对战无限制赛卡牌
func (s *Service) GetCrossOnlineFightBattleCards(id document.ID) ([]document.ID, error) {
	record := s.builder.GetCrossOnlineFightRecord(id)
	return record.Cards(), nil
}

// 创建跨服资源矿战Record
func (s *Service) CreateCrossMineRecord(role mineCompetitor, deploy mineDeployment) (document.ID, error) {
	record := document.New("CrossMineRecord", true).(*scheme.CrossMineRecord)
	record.RoleDbId = role.ID
	record.RoleName = role.Name
	record.RoleLogo = role.Logo
	record.RoleFrame = role.Frame
	record.RoleLevel = role.Level
	record.RoleFigure = role.Figure

	record.Cards = deploy.Cards
	record.CardAttrs = deploy.CardAttrs
	record.CardAttrs2 = deploy.CardAttrs2
	record.PassiveSkills = deploy.PassiveSkills
	record.DefenceCards = deploy.DefenceCards
	record.DefenceCardAttrs = deploy.DefenceCardAttrs
	record.DefenceCardAttrs2 = deploy.DefenceCardAttrs2
	record.DefencePassiveSkills = deploy.DefencePassiveSkills

	r := s.builder.CreateCrossMineRecord(record)
	return r.GetID(), nil
}

// 获取跨服资源矿战Record
func (s *Service) GetCrossMineRecord(id document.ID) (*scheme.CrossMineRecordObject, error) {
	record := s.builder.GetCrossMineRecord(id)
	return record.CrossMineRecordObject, nil
}

// 跨服资源矿战部署
func (s *Service) CrossMineDeployCards(recordID document.ID, role mineCompetitor, deploy mineDeployment) (bool, error) {
	record := s.builder.GetCrossMineRecord(recordID)
	record.deployCards(role, deploy)
	return true, nil
}

// 跨服资源战获取防守布阵卡牌
func (s *Service) GetCrossMineBattleCards(id document.ID) (map[string][]document.ID, error) {
	record := s.builder.GetCrossMineRecord(id)
	cardsMap := make(map[string][]document.ID)

	cards := getCardsByMap(record.Cards())
	cardsMap["cards"] = cards

	defenceCards := getCardsByMap(record.DefenceCards())
	cardsMap["defence_cards"] = defenceCards
	return cardsMap, nil
}

// 跨服资源战添加战斗历史
func (s *Service) CrossMineAddHistory(id document.ID, enemyRank, rank, move, coin6 int, model *scheme.CrossMinePlayRecord, key, flag string) (bool, error) {
	record := s.builder.GetCrossMineRecord(id)
	record.addHistory(enemyRank, rank, move, coin6, model, key, flag)
	return true, nil
}

// 跨服资源战删除历史战报
func (s *Service) CleanCrossMineHistory(id document.ID) (bool, error) {
	record := s.builder.GetCrossMineRecord(id)
	record.cleanHistory()
	return true, nil
}

// 跨服部屋 创建RoleRecord
func (s *Service) CreateCrossUnionFightRoleRecord(role unionfightCompetitor, deploy unionfightDeployment, project int) (resp RespCreateCrossUnionFight, err error) {
	record := document.New("CrossUnionFightRoleRecord", true).(*scheme.CrossUnionFightRoleRecord)
	record.RoleDbId = role.ID
	record.RoleName = role.Name
	record.RoleLogo = role.Logo
	record.RoleFrame = role.Frame
	record.RoleLevel = role.Level
	record.RoleFigure = role.Figure
	record.RoleTitle = role.Title

	record.Cards = deploy.Cards
	record.CardAttrs = deploy.CardAttrs
	record.CardAttrs2 = deploy.CardAttrs2
	record.PassiveSkills = deploy.PassiveSkills
	record.InitProject = project

	record.TopCardAttrs = deploy.TopCardAttrs
	record.TopCardAttrs2 = deploy.TopCardAttrs2
	record.TopPassiveSkills = deploy.TopPassiveSkills
	record.TopInitProject = project

	// create CrossUnionFightRoleRecord in storage
	r := s.builder.CreateCrossUnionFightRoleRecord(record)

	resp.ID = r.GetID()
	resp.Cards = r.Cards()
	return
}

// 跨服部屋 获取RoleRecord
func (s *Service) GetCrossUnionFightRoleRecord(id document.ID) (*scheme.CrossUnionFightRoleRecordObject, error) {
	record := s.builder.GetCrossUnionFightRoleRecord(id)
	return record.CrossUnionFightRoleRecordObject, nil
}

// 跨服部屋 roleID获取RoleRecord
func (s *Service) GetCrossUnionFightRoleRecordByRoleID(roleID document.ID) (*scheme.CrossUnionFightRoleRecordObject, error) {
	roleRecord := s.builder.GetCrossUnionFightRoleRecordByRoleID(roleID)
	if roleRecord != nil {
		return roleRecord.CrossUnionFightRoleRecordObject, nil
	} else {
		return nil, errors.New("CrossUnionFightRoleRecord no record")
	}
}

// 跨服部屋 部署
func (s *Service) CrossUnionFightDeployCards(recordID document.ID, role unionfightCompetitor, deploy unionfightDeployment, stage, project int) (bool, error) {
	record := s.builder.GetCrossUnionFightRoleRecord(recordID)
	record.deployCards(role, deploy)
	if stage == 1 {
		if project != 0 {
			record.SetInitProject(project)
		}
	}
	if stage == 2 {
		if project != 0 {
			record.SetTopInitProject(project)
		}
	}
	return true, nil
}

// 跨服部屋 部署获取布阵卡牌
func (s *Service) GetCrossUnionFightBattleCards(recordID document.ID) (scheme.CrossUnionFightCards, error) {
	record := s.builder.GetCrossUnionFightRoleRecord(recordID)
	return record.Cards(), nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}

	// Cross Craft
	s.Register(s, "CreateCrossCraftRecord")
	s.Register(s, "CreateRobotCrossCraftRecordBulk")
	s.Register(s, "CrossCraftRecordPrepare")
	s.Register(s, "CrossCraftDeploy")
	s.Register(s, "CrossCraftDeployHold")
	s.Register(s, "GetCrossCraftRecord")
	s.Register(s, "CrossCraftAddHistory")
	s.Register(s, "GetCrossCraftView")
	s.Register(s, "GetCrossCraftBattleCards")

	// Cross Arena
	s.Register(s, "CreateCrossArenaRecord")
	s.Register(s, "CrossArenaDeployCards")
	s.Register(s, "GetCrossArenaRecord")
	s.Register(s, "CrossArenaAddHistory")
	s.Register(s, "CreateRobotCrossArenaRecordBulk")
	s.Register(s, "GetCrossArenaBattleCards")
	s.Register(s, "CleanCrossArenaHistory")

	// CrossOnlineFight
	s.Register(s, "CreateCrossOnlineFightRecord")
	s.Register(s, "GetCrossOnlineFightRecord")
	s.Register(s, "CrossOnlineFightDeployCards")
	s.Register(s, "CrossOnlineFightAddHistory")
	s.Register(s, "GetCrossOnlineFightBattleCards")

	// CrossMine
	s.Register(s, "CreateCrossMineRecord")
	s.Register(s, "GetCrossMineRecord")
	s.Register(s, "CrossMineDeployCards")
	s.Register(s, "GetCrossMineBattleCards")
	s.Register(s, "CrossMineAddHistory")
	s.Register(s, "CleanCrossMineHistory")

	// CrossUnionFight
	s.Register(s, "CreateCrossUnionFightRoleRecord")
	s.Register(s, "GetCrossUnionFightRoleRecord")
	s.Register(s, "GetCrossUnionFightRoleRecordByRoleID")
	s.Register(s, "CrossUnionFightDeployCards")
	s.Register(s, "GetCrossUnionFightBattleCards")

	return s
}

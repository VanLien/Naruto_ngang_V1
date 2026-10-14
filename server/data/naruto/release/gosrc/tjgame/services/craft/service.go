package craft

import (
	"errors"
	"strings"
	"sync"
	"time"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/document/schemeutil"
	"tjgame/services/storage"

	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
)

const (
	Name = "craft"
)

var (
	BattleQueryDuration      = time.Second * 2
	PrepareDuration          = time.Minute * 10
	BattlePreReadyDuration   = time.Minute * 3
	BattleFinalReadyDuration = time.Minute * 4
	BattleDuration           = time.Minute

	TestInQuick         = false
	TestPrePareDuration = time.Second * 40
	TestReadyDuration   = time.Second * 2
	TestBattleDuration  = time.Second * 3
)

type Service struct {
	*service.Service
	builder *Builder

	craft *Craft

	storage service.IService
}

func (s *Service) Init() bool {
	if ok := s.Service.Init(); !ok {
		return false
	}

	// some csv config init
	LoadConfig()

	return true
}

func (s *Service) Start() bool {
	opt := s.Option.Base()
	s.storage = s.Container().GetService(storage.GetNameFromDependent(opt.Dependent))
	s.builder = NewBuilder(s.storage)

	// load craft global
	key := strings.Replace(opt.Name, Name, "game", 1)
	s.craft = s.builder.NewCraft(key)
	if s.craft == nil {
		return false
	}
	s.craft.init(s.Container().GetService(key), s.builder)
	log.Infof("load %s craft round %s", key, s.craft.Round())

	s.craft.SetAgentManager(s.Name(), s.Container().GetService("anticheat"))

	if s.craft.isAllOver() {
		// 今日已结束
		log.Infof("Craft isAllOver True")
	} else {
		// 中途重启
		s.craft.ResetToday()
	}

	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.builder.Stop()
}

func (s *Service) CreateCraftRecord(role competitor, deploy deployment) (document.ID, error) {
	record := document.New("CraftRecord", true).(*scheme.CraftRecord)
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

	r := s.builder.CreateCraftRecord(record)
	return r.GetID(), nil
}

type robot struct {
	competitor
	deployment
}

func (s *Service) CreateRobotCraftRecordBulk(robots []robot) (bool, error) {
	records := make([]*scheme.CraftRecord, 0, len(robots))
	for _, robot := range robots {
		record := document.New("CraftRecord", true).(*scheme.CraftRecord)
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

	job := func(record *scheme.CraftRecord) {
		s.builder.CreateCraftRecord(record)
	}

	var wg sync.WaitGroup
	wg.Add(len(records))
	for _, record := range records {
		go func(r *scheme.CraftRecord) {
			job(r)
			wg.Done()
		}(record)
	}
	wg.Wait()

	return true, nil
}

func (s *Service) Deploy(recordID document.ID, role competitor, deploy deployment) (bool, error) {
	record := s.builder.GetCraftRecord(recordID)
	locknum, lockcardattrs := s.craft.CurrentCardLockState()
	err := record.deployCards(deploy, locknum, lockcardattrs)
	if err != nil {
		log.Warningf("craft role %v deploy cards error %v", role.ID, err)
	}
	record.updateRole(role)
	return err == nil, err
}

func (s *Service) DeployHold(recordID document.ID, role competitor, deploy deployment) (bool, error) {
	record := s.builder.GetCraftRecord(recordID)
	record.deployHoldCard(deploy)
	record.updateRole(role)
	return true, nil
}

func (s *Service) StartCraft(buffs []int, quick bool) (bool, error) {
	if s.craft.Round() != "closed" {
		return false, errors.New("craft already start")
	}
	TestInQuick = quick
	s.craft.SetAgentManager(s.Name(), s.Container().GetService("anticheat"))
	s.craft.onStartPrepare(buffs)
	return true, nil
}

func (s *Service) ResetAgentManager() (bool, error) {
	s.craft.mgr.Reset()
	return true, nil
}

type VSInfo struct {
	*scheme.CraftBattleRole
	Round string `codec:"round"`
}

type RoleCraftView struct {
	Info struct {
		scheme.CraftRoleInfo
		Cards     []document.ID                           `codec:"cards"`
		CardAttrs map[document.ID]*scheme.CardBattleModel `codec:"card_attrs"`
		IsOut     bool                                    `codec:"isout,omitempty"`
	} `codec:"info"`
	VSInfo *VSInfo `codec:"vsinfo"`

	History []scheme.CraftBattleHistory `codec:"history"`
}

func (s *Service) GetCraftView(roleID document.ID, recordID document.ID) (*RoleCraftView, error) {
	record := s.builder.GetCraftRecord(recordID)
	record.RLock()
	view := &RoleCraftView{
		History: record.History(),
	}
	if s.craft.PrepareOK() && len(record.Cards()) > 0 { // round改变了，但 record 可能还没完成 prepare
		// TODO: 优化判断 record prepare 完成
		view.Info.Cards = schemeutil.CopyCards(record.Cards())
		view.Info.CardAttrs = schemeutil.CopyCardAttrs(record.CardAttrs())
	} else {
		view.Info.Cards = schemeutil.CopyCards(record.HoldCards())
		view.Info.CardAttrs = schemeutil.CopyCardAttrs(record.HoldCardAttrs())
	}
	record.RUnlock()
	if role, ok := s.craft.GetCraftRole(roleID); ok {
		view.Info.CraftRoleInfo = role
	}

	out, vsrole, round := s.craft.GetVSRole(roleID)
	view.Info.IsOut = out
	if vsrole == nil { // 可能还没开始战斗匹配
		return view, nil
	}
	vsrecord := s.builder.GetCraftRecord(vsrole.RecordID)
	battlecards, fightingpoint := vsrecord.RoundBattleCards(round)
	view.VSInfo = &VSInfo{
		CraftBattleRole: &scheme.CraftBattleRole{
			CraftRole:     *vsrole,
			FightingPoint: fightingpoint,
			Cards:         battlecards,
		},
		Round: round,
	}

	return view, nil
}

func (s *Service) GetCraftRecord(recordID document.ID) (*scheme.CraftRecordObject, error) {
	record := s.builder.GetCraftRecord(recordID)
	return record.CraftRecordObject, nil
}

func (s *Service) GetCraftPlayRecord(id document.ID) (*scheme.CraftPlayRecordObject, error) {
	playRecord := s.builder.GetCraftPlayRecord(id)
	return playRecord.CraftPlayRecordObject, nil
}

func (s *Service) GetCraftBattleCards(id document.ID) ([]document.ID, error) {
	record := s.builder.GetCraftRecord(id)
	return record.HoldCards(), nil
}

func (s *Service) GameSync() (*SyncModel, error) {
	return s.craft.syncModel(), nil
}

func (s *Service) BetRole(roleID, target document.ID, gold int) (map[document.ID]scheme.CraftBet, error) {
	return s.craft.BetRole(roleID, target, gold)
}

func (s *Service) GetBetInfo() (map[document.ID]scheme.CraftBet, error) {
	return s.craft.GetBetInfo(), nil
}

func (s *Service) ResetCraftPlayRecordRandSeed(id document.ID) (int32, error) {
	r := s.builder.GetCraftPlayRecord(id)
	r.Lock()
	defer r.Unlock()
	seed := r.resetRandSeed()
	return seed, nil
}

func (s *Service) ResendCraftAward(force bool) (bool, error) {
	var round string
	util.WithGuard(s.craft, func() {
		round = s.craft.Round()
	})
	if !force && round != "over" {
		return false, errors.New("round is not over")
	}
	s.craft.onOver()
	return true, nil
}

func (s *Service) SetInQuick(quick bool) (bool, error) {
	TestInQuick = quick
	return true, nil
}

func (s *Service) CraftNext() (bool, error) {
	if s.craft.timer == nil {
		return false, errors.New("no timer found")
	}
	if s.craft.timer.Stop() {
		round := s.craft.Round()
		s.craft.timer.Reset(time.Second)
		log.Infof("Craft Reset Timer Round %s Next", round)
	} else {
		return false, errors.New("timer function already started in its own goroutine")
	}
	return true, nil
}

func (s *Service) CraftCancel() (bool, error) {
	if s.craft.timer != nil {
		if s.craft.timer.Stop() {
			log.Infof("Craft Cancel")
			s.craft.clean()
			return true, nil
		} else {
			return false, errors.New("timer function already started in its own goroutine")
		}
	} else {
		log.Infof("Craft Cancel")
		s.craft.clean()
	}
	return true, nil
}

func (s *Service) CraftStop() (bool, error) {
	if s.craft.timer == nil {
		return false, errors.New("no timer found")
	}
	if s.craft.timer.Stop() {
		round := s.craft.Round()
		log.Infof("Craft Stop Timer Round %s", round)
	} else {
		return false, errors.New("timer function already started in its own goroutine")
	}
	return true, nil
}

func (s *Service) CraftResume() (bool, error) {
	if s.craft.timer == nil {
		return false, errors.New("no timer found")
	}
	s.craft.timer.Stop()
	round := s.craft.Round()
	s.craft.timer.Reset(time.Second * 5)
	log.Infof("Craft Resume Timer Round %s", round)
	return true, nil
}

func (s *Service) GetCraftRecordByRoleID(roleID document.ID) (*scheme.CraftRecordObject, error) {
	record := s.builder.GetCraftRecordByRoleID(roleID)
	if record == nil {
		return nil, errors.New("GetCraftRecordByRoleID no found")
	}
	return record.CraftRecordObject, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}

	s.Register(s, "CreateCraftRecord")
	s.Register(s, "CreateRobotCraftRecordBulk")
	s.Register(s, "Deploy")
	s.Register(s, "DeployHold")
	s.Register(s, "StartCraft")
	s.Register(s, "GetCraftView")
	s.Register(s, "GetCraftRecord")
	s.Register(s, "GetCraftPlayRecord")
	s.Register(s, "GetCraftBattleCards")
	s.Register(s, "GameSync")
	s.Register(s, "BetRole")
	s.Register(s, "GetBetInfo")

	s.Register(s, "ResetCraftPlayRecordRandSeed")
	s.Register(s, "ResendCraftAward")
	s.Register(s, "SetInQuick")
	s.Register(s, "CraftNext")
	s.Register(s, "CraftCancel")
	s.Register(s, "CraftStop")
	s.Register(s, "CraftResume")
	s.Register(s, "GetCraftRecordByRoleID")

	s.Register(s, "ResetAgentManager")
	return s
}

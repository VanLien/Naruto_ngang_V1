package union_fight

import (
	"errors"
	"fmt"
	"math/rand"
	"strings"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/services/storage"
)

const Name = "union_fight"

type Service struct {
	*service.Service
	builder *Builder

	storage service.IService

	unionFight *UnionFight
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
	s.storage = s.Container().GetService(storage.GetNameFromDependent(opt.Dependent))
	s.builder = NewBuilder(s.storage)

	key := strings.Replace(opt.Name, Name, "game", 1)
	s.unionFight = s.builder.NewUnionFight(key)
	if s.unionFight == nil {
		return false
	}
	s.unionFight.init(s.Container().GetService(key), s.Container().GetService("anticheat"), s.builder)
	log.Infof("load %s union fight round %s", key, s.unionFight.Round())

	s.unionFight.SetAgentManager(s.Name(), s.Container().GetService("anticheat"))

	if s.unionFight.isAllOver() {
		// 今日结束
		log.Info("Union Fight isAllOver True")
	} else {
		// 中途重启
		s.unionFight.resetToday()
	}

	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.builder.Stop()
}

func (s *Service) GetUnionFightView(roleID, unionID, recordID document.ID, gameRound, curRound, inputRound string, top8Deploy []document.ID, inClock5Weekday int) (*RoleUnionFightView, error) {
	view := &RoleUnionFightView{}
	view.UnionInfo = s.unionFight.getRespUnionInfo(unionID, curRound, top8Deploy, inClock5Weekday)
	view.Model.RoundResults = s.unionFight.getUnionHistory(unionID, inputRound)
	view.Model.FinalResult = s.unionFight.getUnionsFinalRank()
	view.Model.LastRoleName = s.unionFight.getLastRoleName(curRound)
	view.Model.LastUnionName = s.unionFight.getLastUnionName()
	view.Model.Top8VSInfo = s.unionFight.getTop8VSInfo()
	view.Model.NextRoundBattleTime = s.unionFight.getNextRoundBattleTime()
	view.Model.NextRoundPrepareTime = s.unionFight.getNextRoundPrepareTime()
	view.Model.PrepareEndTime = s.unionFight.getPrepareEndTime()
	view.Model.BattleStars = s.unionFight.BattleStars()
	view.Model.UnionBattleStatus = s.unionFight.getUnionBattleStatus(gameRound, curRound)

	record := s.builder.GetUnionFightRoleRecord(recordID)
	view.RoleInfo.Cards = record.getCards(inClock5Weekday, gameRound)
	return view, nil
}

func (s *Service) CreateUnionFightRoleRecord(role roleCompetitor, deploy deployment) (document.ID, error) {
	record := document.New("UnionFightRoleRecord", true).(*scheme.UnionFightRoleRecord)
	record.RoleDbId = role.ID
	record.RoleName = role.Name
	record.RoleLogo = role.Logo
	record.RoleFrame = role.Frame
	record.RoleLevel = role.Level
	record.RoleFigure = role.Figure
	record.UnionDbId = role.UnionDbId
	record.HoldCards = deploy.Cards
	record.HoldCardAttrs = deploy.CardAttrs
	record.HoldCardAttrs2 = deploy.CardAttrs2
	record.PassiveSkills = deploy.PassiveSkills

	r := s.builder.CreateUnionFightRoleRecord(record)
	return r.GetID(), nil
}

func (s *Service) Deploy(recordID document.ID, role roleCompetitor, deploy deployment) (bool, error) {
	record := s.builder.GetUnionFightRoleRecord(recordID)
	record.deployCards(deploy)
	record.updateRole(role)
	return true, nil
}

func (s *Service) GetBetInfo() (map[document.ID]scheme.UnionFightBet, error) {
	return s.unionFight.GetBetInfo(), nil
}

func (s *Service) StartUnionFightPrepare(signup []scheme.UnionFightSignupItem, weekday int, top8Deploys map[document.ID][]document.ID) (bool, error) {
	if len(signup) == 0 {
		return false, errors.New("signup is null")
	}
	if weekday < 2 || weekday > 6 {
		return false, errors.New(fmt.Sprintf("weekday %d can not battle", weekday))
	}
	s.unionFight.SetAgentManager(s.Name(), s.Container().GetService("anticheat"))
	s.unionFight.onPrepare(signup, weekday, top8Deploys)
	return true, nil
}

func (s *Service) GetUnionFightPlayRecord(playID document.ID) (*scheme.UnionFightPlayRecordObject, error) {
	playRecord := s.builder.GetUnionFightPlayRecord(playID)
	return playRecord.UnionFightPlayRecordObject, nil
}

func (s *Service) Top8Deploy(unionID document.ID, roles []document.ID) (bool, error) {
	err := s.unionFight.top8Deploy(unionID, roles)
	return true, err
}

func (s *Service) GetRankInfo(recordID document.ID) (map[int]RespRankInfo, error) {
	return s.unionFight.getRankInfo(recordID), nil
}

func (s *Service) GetUnionFightBattleCards(recordID document.ID) (scheme.UnioinFightCards, error) {
	record := s.builder.GetUnionFightRoleRecord(recordID)
	return record.HoldCards(), nil
}

func (s *Service) Top8RoundResult(unionID document.ID, roundKey string) (map[interface{}][]scheme.UnionFightResultInfo, error) {
	return s.unionFight.getUnionHistory(unionID, roundKey), nil
}

func (s *Service) BetUnion(roleID, target document.ID, gold int) (map[document.ID]scheme.UnionFightBet, error) {
	return s.unionFight.BetUnion(roleID, target, gold)
}

func (s *Service) SetBattleTop8Star(unionID document.ID, nature int, attr int, effectType int) (bool, error) {
	err := s.unionFight.SetBattleTop8Star(unionID, nature, attr, effectType)
	return true, err
}

func (s *Service) BattleYesterday(unionID document.ID, round int) (YesterdayInfo, error) {
	return s.unionFight.getBattleYesterday(unionID, round), nil
}

func (s *Service) WeekClose() (bool, error) {
	s.unionFight.WeekClose()
	return true, nil
}

func (s *Service) ResetUnionFightPlayRecordRandSeed(id document.ID) (int32, error) {
	seed := rand.Int31n(99999999) + 1
	r := s.builder.GetUnionFightPlayRecord(id)
	r.Lock()
	defer r.Unlock()
	old := r.RandSeed()
	r.SetRandSeed(seed)
	log.Infof("ResetUnionFightPlayRecordRandSeed %v, %d -> %d", id, old, seed)
	return seed, nil
}

func (s *Service) GetUnionFightRoleRecord(recordID document.ID) (*scheme.UnionFightRoleRecordObject, error) {
	record := s.builder.GetUnionFightRoleRecord(recordID)
	return record.UnionFightRoleRecordObject, nil
}

func (s *Service) ResetAgentManager() (bool, error) {
	s.unionFight.mgr.Reset()
	return true, nil
}

func (s *Service) GetUnionFightRoleRecordByRoleID(roleID document.ID) (*scheme.UnionFightRoleRecordObject, error) {
	record := s.builder.GetUnionFightRoleRecordByRoleID(roleID)
	if record == nil {
		return nil, errors.New("GetUnionFightRoleRecordByRoleID no found")
	}
	return record.UnionFightRoleRecordObject, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}

	s.Register(s, "GetUnionFightView")
	s.Register(s, "CreateUnionFightRoleRecord")
	s.Register(s, "Deploy")
	s.Register(s, "GetBetInfo")
	s.Register(s, "StartUnionFightPrepare")
	s.Register(s, "GetUnionFightPlayRecord")
	s.Register(s, "Top8Deploy")
	s.Register(s, "GetRankInfo")
	s.Register(s, "GetUnionFightBattleCards")
	s.Register(s, "Top8RoundResult")
	s.Register(s, "BetUnion")
	s.Register(s, "SetBattleTop8Star")
	s.Register(s, "BattleYesterday")
	s.Register(s, "WeekClose")
	s.Register(s, "ResetUnionFightPlayRecordRandSeed")
	s.Register(s, "GetUnionFightRoleRecord")
	s.Register(s, "GetUnionFightRoleRecordByRoleID")

	s.Register(s, "ResetAgentManager")

	return s
}

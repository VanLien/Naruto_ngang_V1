package game

import (
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/service"
	"tjgame/services/cross"
)

const Name = "game"

type Service struct {
	*service.Service

	*cross.Cohort
}

type LoginResponse struct {
	_struct struct{} `codec:",toarray"`
	Used    int
	Role    scheme.RoleInfo
}

func (s *Service) AccountLogin(inlpwd string, servID int, accountID document.ID, accountName string, channel string, sessionpwd []byte, isNewbie bool, sdkinfo map[string]string, dbRmbReturnMap map[string]int) (resp *LoginResponse, err error) {
	return
}

type CraftEventResponse struct {
	Signup []scheme.CraftRoleSignItem `codec:"signup,omitempty"`
}

func (s *Service) CraftEvent(event string, data interface{}, sync interface{}) (resp *CraftEventResponse, err error) {
	return
}

type UnionFightEventResponse struct {
	Signup      []scheme.UnionFightSignupItem `codec:"signup,omitempty"`
	Top8Deploys map[document.ID][]document.ID `codec:"top8Deploys,omitempty"`
}

func (s *Service) UnionFightEvent(event string, data interface{}, sync interface{}) (resp *UnionFightEventResponse, err error) {
	return
}

type BraveChallengeEventResponse struct {
	YYID              int                             `codec:"yyID,omitempty"`
	BeginDate         int                             `codec:"beginDate,omitempty"`
	BaseCfg           int                             `codec:"baseCfg,omitempty"`
	IsDailyUnlockCard bool                            `codec:"isDailyUnlockCard,omitempty"`
	Cards             map[int]*scheme.CardBattleModel `codec:"cards,omitempty"`
}

func (s *Service) BraveChallengeEvent(event string, data interface{}, sync interface{}) (resp *BraveChallengeEventResponse, err error) {
	return
}

type SummerChallengeEventResponse struct {
	YYID  int                             `codec:"yyID,omitempty"`
	Cards map[int]*scheme.CardBattleModel `codec:"cards,omitempty"`
}

func (s *Service) SummerChallengeEvent(event string, data interface{}, sync interface{}) (resp *SummerChallengeEventResponse, err error) {
	return
}

func (s *Service) CrossGetRoleLastTime(roleID document.ID) (int, error) {
	return 0, nil
}

type CrossCraftEventResponse struct {
	Signup []scheme.CrossCraftRoleSignItem `codec:"signup,omitempty"`
}

func (s *Service) CrossCraftEvent(event string, data interface{}, sync interface{}) (resp *CrossCraftEventResponse, err error) {
	return
}

type CrossArenaEventResponse struct {
	// 开服天数
	OpenServerDays int `codec:"open_server_days,omitempty"`

	Robots map[int]*scheme.CrossArenaRoleInfo `codec:"robots,omitempty"`
}

func (s *Service) CrossArenaEvent(event string, data interface{}, sync interface{}) (resp *CrossArenaEventResponse, err error) {
	return
}

type CrossOnlineFightEventResponse struct {
	Cards map[int]*scheme.CardBattleModel `codec:"cards"`
}

func (s *Service) CrossOnlineFightEvent(event string, data interface{}, sync interface{}) (resp *CrossOnlineFightEventResponse, err error) {
	return
}

type CrossFishingEventResponse struct{}

func (s *Service) CrossFishingEvent(event string, data interface{}, sync interface{}) (resp *CrossFishingEventResponse, err error) {
	return
}

type GymEventResponse struct{}

func (s *Service) GymEvent(event string, data interface{}, sync interface{}) (resp *GymEventResponse, err error) {
	return
}

type HuoDongBossEventResponse struct{}

func (s *Service) HuoDongBossEvent(event string, data interface{}, sync interface{}) (resp *HuoDongBossEventResponse, err error) {
	return
}

type HuoDongCrossRedPacketEventResponse struct{}

func (s *Service) HuoDongCrossRedPacketEvent(event string, data interface{}, sync interface{}) (resp *HuoDongCrossRedPacketEventResponse, err error) {
	return
}

type CrossMineEventResponse struct {
	// 开服天数
	ServerOpenDays int `codec:"serverOpenDays,omitempty"`
}

func (s *Service) CrossMineEvent(event string, data interface{}, sync interface{}) (resp *CrossMineEventResponse, err error) {
	return
}

type CrossUnionQAEventResponse struct{}

func (s *Service) CrossUnionQAEvent(event string, data interface{}, sync interface{}) (resp *CrossUnionQAEventResponse, err error) {
	return
}

type HuoDongCrossSkyscraperEventResponse struct{}

func (s *Service) HuoDongCrossSkyscraperEvent(event string) (resp *HuoDongCrossSkyscraperEventResponse, err error) {
	return
}

type HuoDongCrossRankingEventResponse struct{}

func (s *Service) HuoDongCrossRankingEvent(event string) (resp *HuoDongCrossRankingEventResponse, err error) {
	return
}

func (s *Service) GetOpenDays() (int, error) {
	return 0, nil
}

type CrossUnionFightEventResponse struct {
	// 公会
	UnionsMembers map[document.ID]*UnionInfo `codec:"unions_members,omitempty"`
	// 公会战积分排行
	UnionFightPointRank []*scheme.UnionFightPointRankInfo `codec:"union_fight_point_rank,omitempty"`
}

type UnionInfo struct {
	Members      map[document.ID]*scheme.UnionMember `codec:"members,omitempty"`
	ChairmanDbID document.ID                         `codec:"chairman_db_id,omitempty"`
	GameKey      string                              `codec:"game_key,omitempty"`
}

func (s *Service) CrossUnionFightEvent(event string, data interface{}, sync interface{}) (resp *CrossUnionFightEventResponse, err error) {
	return
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}

	s.Register(s, "AccountLogin")
	s.Register(s, "CraftEvent")
	s.Register(s, "UnionFightEvent")
	s.Register(s, "CrossGetRoleLastTime")
	s.Register(s, "CrossCraftEvent")
	s.Register(s, "CrossArenaEvent")
	s.Register(s, "CrossOnlineFightEvent")
	s.Register(s, "CrossFishingEvent")
	s.Register(s, "GymEvent")
	s.Register(s, "HuoDongBossEvent")
	s.Register(s, "CrossMineEvent")
	s.Register(s, "CrossUnionQAEvent")
	s.Register(s, "HuoDongCrossRedPacketEvent")
	s.Register(s, "HuoDongCrossSkyscraperEvent")
	s.Register(s, "HuoDongCrossRankingEvent")
	s.Register(s, "BraveChallengeEvent")
	s.Register(s, "SummerChallengeEvent")
	s.Register(s, "GetOpenDays")
	s.Register(s, "CrossUnionFightEvent")

	// 二阶段提交
	s.Register(s, "VoteTransaction")
	s.Register(s, "CommitTransaction")
	s.Register(s, "CommittedOver")

	return s
}

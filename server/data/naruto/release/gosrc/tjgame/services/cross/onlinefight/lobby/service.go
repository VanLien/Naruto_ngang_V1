package lobby

import (
	"errors"
	"sort"
	"sync"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/server_framework/tj/service"
	"tjgame/services/cross"
	"tjgame/services/cross/onlinefight/proto"
)

const (
	Name = "crosslobby"

	UnlimitedModel  = 1
	LimitedModel    = 2
	LimitedBanModel = 3
)

var (
	ErrAlreadyInMatching = errors.New("already in matching")
	ErrNoLobbyFound      = errors.New("no lobby found")
)

type Service struct {
	*service.Service

	unlimitedLobby  map[int]*Lobby // 非限制赛
	limitedLobby    map[int]*Lobby // 公平赛选位制
	limitedBanLobby map[int]*Lobby // 公平赛扳选制
	server2id       map[string]int

	destinations sync.Map // {role_id: from}
}

func (s *Service) Init() bool {
	if ok := s.Service.Init(); !ok {
		return false
	}

	// 初始化配表
	match := csv.GetConfig().Cross.Online_fight.Match
	ids := make([]int, 0, len(match))
	for id := range match {
		ids = append(ids, id)
	}
	sort.Ints(ids)
	matchRanges := make(map[int][]*csv.Cross_online_fight_match)
	for _, id := range ids {
		cfg := match[id]
		if _, ok := matchRanges[cfg.Type]; ok {
			matchRanges[cfg.Type] = make([]*csv.Cross_online_fight_match, 0, 8)
		}
		matchRanges[cfg.Type] = append(matchRanges[cfg.Type], cfg)
	}

	s.unlimitedLobby = make(map[int]*Lobby)
	s.limitedLobby = make(map[int]*Lobby)
	s.limitedBanLobby = make(map[int]*Lobby)
	s.server2id = make(map[string]int)

	_, channel, _ := service.SplitServiceName(s.Name())
	idx := 0
	for i, cfg := range csv.GetConfig().Cross.Online_fight.Expand_servers {
		if cfg.Cross == channel {
			idx++
			s.unlimitedLobby[i] = NewLobby(idx, UnlimitedModel, matchRanges[UnlimitedModel], s.onMatched, s.onDiscard)
			s.limitedLobby[i] = NewLobby(idx, LimitedModel, matchRanges[LimitedModel], s.onMatched, s.onDiscard)
			s.limitedBanLobby[i] = NewLobby(idx, LimitedBanModel, matchRanges[LimitedBanModel], s.onMatched, s.onDiscard)
			for _, key := range cfg.Servers.ToStringSlice() {
				for _, k := range csv.GetMergeConfig().GetSrcServKeys(key) {
					s.server2id[k] = i
				}
			}
		}
	}

	return true
}

func (s *Service) dispatch(key string, model int) *Lobby {
	if idx, ok := s.server2id[key]; ok {
		switch model {
		case UnlimitedModel:
			return s.unlimitedLobby[idx]
		case LimitedModel:
			return s.limitedLobby[idx]
		case LimitedBanModel:
			return s.limitedBanLobby[idx]
		default:
			return nil
		}
	}
	return nil
}

func (s *Service) CrossLobbyMatchStart(player *proto.Player, model int) (bool, error) {
	lobby := s.dispatch(player.GameKey, model)
	if lobby == nil {
		return false, ErrNoLobbyFound
	}
	err := lobby.Match(player)
	return err == nil, err
}

func (s *Service) CrossLobbyMatchCancel(key string, id document.ID) (bool, error) {
	idx, ok := s.server2id[key]
	if !ok {
		return false, ErrNoLobbyFound
	}
	s.unlimitedLobby[idx].MatchCancel(id)
	s.limitedLobby[idx].MatchCancel(id)
	s.limitedBanLobby[idx].MatchCancel(id)
	return true, nil
}

func (s *Service) onMatched(typ int, player1 *proto.Player, player2 *proto.Player) {
	// 由player1的cross代理生成战斗
	cross.ContainerServices(s.Container(), player1.CrossKey, player2.CrossKey)
	id := document.NewID()
	if player1.CrossKey != player2.CrossKey {
		service.Call(s.Container().GetService(player2.CrossKey), "CrossOnlineFightRemoteLobbyMatchedNotify", player1, player2, id)
	}
	service.Call(s.Container().GetService(player1.CrossKey), "CrossOnlineFightRemoteLobbyMatched", typ, player1, player2, id)
}

func (s *Service) onDiscard(typ int, players []*proto.Player) {
	m := make(map[string][]document.ID)
	for _, player := range players {
		if _, ok := m[player.CrossKey]; !ok {
			m[player.CrossKey] = make([]document.ID, 0, 8)
		}
		m[player.CrossKey] = append(m[player.CrossKey], player.ID)
	}

	services := make([]string, 0, len(players))
	for key := range m {
		services = append(services, key)
	}
	cross.ContainerServices(s.Container(), services...)

	for key, ids := range m {
		s := s.Container().GetService(key)
		service.CallAsync(s, "CrossOnlineFightRemoteLobbyMatchDiscard", ids)
	}
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}

	s.Register(s, "CrossLobbyMatchStart")
	s.Register(s, "CrossLobbyMatchCancel")

	return s
}

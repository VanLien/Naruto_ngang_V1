package card_fight

import (
	"strings"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/service"
	"tjgame/services/storage"
)

const Name = "card_fight"

type Service struct {
	*service.Service
	builder *Builder

	storage service.IService
	global  *CardFightGlobal
}

func (s *Service) Init() bool {
	if ok := s.Service.Init(); !ok {
		return false
	}

	return true
}

func (s *Service) Start() bool {
	opt := s.Option.Base()
	s.storage = s.Container().GetService(storage.GetNameFromDependent(opt.Dependent))
	s.builder = NewBuilder(s.storage)

	key := strings.Replace(opt.Name, Name, "game", 1)
	s.global = s.builder.newCardScoreGlobal(key)
	s.global.init(s.builder)

	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.builder.Stop()
}

func (s *Service) CardFightRank(role scheme.CardFightRankItemRole, markID document.Integer, offset, size int) (RespCardFightRank, error) {
	return s.global.getRank(role, markID, offset, size), nil
}

func (s *Service) CardFightUpdate(role scheme.CardFightRankItemRole, cards map[document.Integer]scheme.CardFightRankItemCard) (map[document.ID]int, error) {
	s.global.updateCardFight(role, cards)
	return s.global.getInRankCards(role.ID, cards), nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}

	s.Register(s, "CardFightUpdate")
	s.Register(s, "CardFightRank")

	return s
}

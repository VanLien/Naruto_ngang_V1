package card_score

import (
	"errors"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/service"
)

const Name = "card_score"

type Service struct {
	*service.Service
	builder *Builder

	storage service.IService
	global  *CardScoreGlobal
}

func (s *Service) Init() bool {
	if ok := s.Service.Init(); !ok {
		return false
	}

	return true
}

func (s *Service) Start() bool {
	opt := s.Option.Base()
	for _, name := range opt.Dependent {
		ns, _, _ := service.SplitServiceName(name)
		if ns == "commentdb" {
			s.storage = s.Container().GetService(name)
			break
		}
	}
	s.builder = NewBuilder(s.storage)

	s.global = s.builder.newCardScoreGlobal(s.Name())
	s.global.init()

	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.builder.Stop()
}

func (s *Service) CardScoreGet(roleID document.ID, markID int) (RespCardScore, error) {
	score, lastScore, err := s.global.getScoreAndLastScore(markID)
	if err != nil {
		return RespCardScore{}, err
	}
	roleRecord := s.builder.GetCardScoreRole(roleID)
	myScore := 0
	if roleRecord != nil {
		myScore = roleRecord.getScore(markID)
	}
	return RespCardScore{
		Score:     score,
		LastScore: lastScore,
		MyScore:   myScore,
	}, nil
}

// 发表评分
func (s *Service) CardScoreSend(roleID document.ID, gameKey string, markID, new int) (bool, error) {
	if new <= 0 || new > 10 {
		return false, errors.New("score error")
	}

	roleRecord := s.builder.GetCardScoreRole(roleID)
	if roleRecord == nil {
		roleRecord = s.builder.CreateCardScoreRole(roleID, gameKey)
	}
	old := roleRecord.getScore(markID)
	err := s.global.updateScore(markID, old, new)
	if err != nil {
		return false, err
	}
	roleRecord.setScore(markID, new)
	return true, nil
}

// 精灵评分榜
func (s *Service) CardScoreRank(offset, size int) ([]scheme.CardScoreInfo, error) {
	return s.global.getRank(offset, size), nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}

	s.Register(s, "CardScoreGet")
	s.Register(s, "CardScoreSend")
	s.Register(s, "CardScoreRank")

	return s
}

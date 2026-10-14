package yyhuodong

import (
	"errors"
	"fmt"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/cross"
)

const Name = "crosshorse"

type Service struct {
	*service.Service
	builder *Builder
	cross.Skeleton

	storage service.IService

	horseRace *HorseRaceGlobal // 赛马
}

func (s *Service) Init() bool {
	if ok := s.Service.Init(); !ok {
		return false
	}
	_ = LoadConfig()
	return true
}

func (s *Service) Start() bool {
	var ss service.IService
	opt := s.Option.Base()
	for _, name := range opt.Dependent {
		ns, _, _ := service.SplitServiceName(name)
		if ns == "crossdb" {
			ss = s.Container().GetService(name)
			break
		}
	}
	s.builder = NewBuilder(ss)
	key := opt.Name

	// load horseRace global
	s.horseRace = s.builder.NewHorseRaceGlobal(key)
	if s.horseRace == nil {
		return false
	}
	s.horseRace.container = s.Container()
	s.horseRace.init(s.builder)
	log.Infof("load %s horseRace global", key)

	if s.horseRace.isOver() {
		// 已结束
		log.Infof("Cross horseRace is AllOver True")
		s.horseRace.clean()
	} else {
		// 中途重启
		go s.horseRace.ResetToday()
	}

	s.Skeleton.Init(s.Name(), Name, s.horseRace)
	go s.StartServiceCheck()

	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.builder.Stop()
}

func (s *Service) RefreshCSV() (string, error) {
	out, err := csv.Reload()
	if err != nil {
		return "", err
	}

	old := GetConfig()
	st := time.Now()
	// 赛马
	_ = LoadHorseRaceConifg()

	out1 := fmt.Sprintf("Reload Over. %p -> %p\n", old, GetConfig())
	out1 += fmt.Sprintf("Cost %v\n", time.Now().Sub(st))
	log.Info(out1)
	out += out1

	return out, nil
}

// 赛马 主界面
func (s *Service) HorseRaceMain() (*RespHorseRaceMain, error) {
	db, unlock := s.horseRace.LockAndGetDB()
	defer unlock()
	if db.Status != "start" {
		return nil, ErrStatusClosed
	}
	ret := RespHorseRaceMain{
		Date:      db.Date,
		Play:      db.Play,
		History:   db.History,
		Round:     db.Round,
		Status:    db.Status,
		RaceCards: db.RaceCards,
	}
	return &ret, nil
}

// 赛马 押注
func (s *Service) HorseRaceBet(roleID document.ID, date, play, csvID int) (int, error) {
	db, unlock := s.horseRace.LockAndGetDB()
	defer unlock()
	if db.Status != "start" {
		return -1, ErrStatusClosed
	}
	if db.Round != "prepare" {
		return -1, ErrNoInPrepare
	}
	if date != db.Date || play != db.Play {
		return -1, ErrNoThisPlay
	}
	idx := s.horseRace.betRaceCard(csvID)

	return idx, nil
}

// 赛马 回放
func (s *Service) HorseRacePlayback(date, play int) ([]*scheme.HorseRaceHistoryCardInfo, error) {
	db, unlock := s.horseRace.LockAndGetDB()
	defer unlock()
	if db.Status != "start" {
		return nil, ErrStatusClosed
	}
	var ret []*scheme.HorseRaceHistoryCardInfo
	if v, ok := db.History[document.Integer(date)]; ok {
		if vv, ok := v[document.Integer(play)]; ok {
			ret = vv
		} else {
			return nil, ErrNoThisPlay
		}
	} else {
		return nil, ErrNoThisPlay
	}
	return ret, nil
}

// 测试 赛马 快速开一场比赛
func (s *Service) HorseRaceQuickStart(isPrepare bool) (bool, error) {
	isStatus := false
	round := "closed"
	util.WithGuard(s.horseRace, func() {
		if s.horseRace.Status() == "start" {
			isStatus = true
			round = s.horseRace.Round()
		}
	})
	if !isStatus {
		return false, ErrStatusClosed
	}
	if isPrepare {
		if round == "closed" {
			TestInPrepare = true
			s.horseRace.onPrepare()
		} else if round == "start" {
			return false, errors.New("is starting")
		}
		TestInPrepare = false
	} else {
		if round == "prepare" {
			TestInQuick = true
			s.horseRace.onStart()
		} else if round == "closed" {
			TestInQuick = true
			s.horseRace.onPrepare()
		} else if round == "start" {
			return false, errors.New("is starting")
		}
		TestInQuick = false
	}

	return true, nil
}

// 测试 赛马 比赛结果
func (s *Service) TestHorseRaceResult(csvIDs []int) ([]*scheme.RaceCardInfo, error) {
	csvRaceCard := csv.GetConfig().Cross.Horse_race.Horse_race_card
	var raceCards []*scheme.RaceCardInfo
	for _, csvID := range csvIDs {
		if _, ok := csvRaceCard[csvID]; !ok {
			return []*scheme.RaceCardInfo{}, nil
		}
		raceCard := scheme.RaceCardInfo{
			CsvID: csvID,
		}
		raceCards = append(raceCards, &raceCard)
	}
	ret := s.horseRace.testRaceResult(raceCards)
	return ret, nil
}

// 测试 赛马 取消押注
func (s *Service) TestHorseRaceResetBet(roleID document.ID, idx int) (bool, error) {
	db, unlock := s.horseRace.LockAndGetDB()
	defer unlock()
	if db.Status != "start" {
		return false, ErrStatusClosed
	}
	if db.Round != "prepare" {
		return false, ErrNoInPrepare
	}
	flag := s.horseRace.resetBetRaceCard(idx)

	return flag, nil
}

// 赛马 手动开始
func (s *Service) HorseRaceYYStart(csvID int) (bool, error) {
	// 判断status
	isStatus := false
	util.WithGuard(s.horseRace, func() {
		if s.horseRace.Status() == "closed" {
			isStatus = true
		}
	})
	if !isStatus {
		return false, ErrStatusStart
	}

	s.horseRace.OnInit(csvID, nil)

	return true, nil
}

// 赛马 手动结束
func (s *Service) HorseRaceYYClosed() (bool, error) {
	// 判断status
	isStatus := false
	util.WithGuard(s.horseRace, func() {
		if s.horseRace.Status() == "start" {
			isStatus = true
		}
	})
	if !isStatus {
		return false, nil
	}
	s.horseRace.OnClosed()
	return true, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}
	s.SetContainer(container)

	// HorseRace
	s.Register(s, "HorseRaceMain")
	s.Register(s, "HorseRaceBet")
	s.Register(s, "HorseRacePlayback")
	s.Register(s, "HorseRaceYYClosed")
	// test
	s.Register(s, "HorseRaceQuickStart")
	s.Register(s, "TestHorseRaceResult")
	s.Register(s, "TestHorseRaceResetBet")
	s.Register(s, "HorseRaceYYStart")

	s.Register(s, "RefreshCSV")

	return s
}

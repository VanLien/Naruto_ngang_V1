package anti_cheat

import (
	"context"
	"errors"
	"fmt"
	"runtime"
	"sync/atomic"
	"tjgame/document"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/service/caller"

	"github.com/prometheus/client_golang/prometheus"
)

const (
	Name = "anticheat"
)

func SetScriptPath(path string) {
	if path != "" {
		scriptPath = path
	}
}

func SetMaxAgent(n int) {
	if n > runtime.NumCPU() {
		n = runtime.NumCPU()
	}
	maxAgent = n
}

func SetAgentBinary(path string) {
	if path != "" {
		agentBinary = path
	}
}

var (
	scriptPath         = "./game_scripts"
	agentBinary        = "./agent"
	maxAgent           = 4
	errorForceResult   = true // 返回error时强判result
	tracebackReportUrl = "http://192.168.1.98:1104/battle_report"
	luajit             = "luajit"

	ErrWaitQueueFull = errors.New("wait queue full")
)

func init() {
	if runtime.GOOS == "windows" {
		luajit = "../luajit.exe"
	}
}

type Option struct {
	service.Option `json:",inline"`

	ErrorNotForceResult bool   `json:"error_not_force_result,omitempty"`
	TracebackReportUrl  string `json:"trackback_report_url,omitempty"`
}

type Service struct {
	*service.Service

	ctx    context.Context
	cancel context.CancelFunc

	recordCheck       chan int
	records           chan *Record
	unionFightRecords chan *Record

	counter int64

	// metric
	waiting prometheus.Gauge
}

func (s *Service) Init() bool {
	if ok := s.Service.Init(); !ok {
		return false
	}
	opt := s.Option.(*Option)
	errorForceResult = !opt.ErrorNotForceResult
	_, language, _ := service.SplitServiceName(s.Name())
	if opt.TracebackReportUrl != "" || language != "dev" { // 线上如果没配置url，就不发送
		tracebackReportUrl = opt.TracebackReportUrl
	}

	s.recordCheck = make(chan int, 1024)
	s.records = make(chan *Record, 250)
	s.unionFightRecords = make(chan *Record, 250)
	s.ctx, s.cancel = context.WithCancel(context.Background())

	s.waiting = playWaiting.With(prometheus.Labels{"service": s.Name()})
	return true
}

func (s *Service) Start() bool {
	if !s.Service.Start() {
		return false
	}
	for i := 0; i < maxAgent; i++ {
		go func(idx int) {
			//r := NewProxyRunner(idx, prometheus.Labels{"service": s.Name()})
			r := NewLuaRunner(idx, prometheus.Labels{"service": s.Name()})
			if err := r.Start(); err != nil {
				panic(fmt.Sprintf("proxy runner start error %v", err))
			}
			for s.IsRunning() {
				select {
				case <-s.recordCheck:
					select {
					case <-s.ctx.Done():
						break
					case rr := <-s.records:
						s.waiting.Dec()
						r.Run(rr)
					default:
					}
					select {
					case <-s.ctx.Done():
						break
					case rr := <-s.unionFightRecords:
						s.waiting.Dec()
						r.Run(rr)
					default:
					}
				}
			}
			r.Stop()
		}(i + 1)
	}
	return true
}

func (s *Service) Stop() {
	s.cancel()
	s.Service.Stop()
}

func (s *Service) NewArenaBattle(servKey string, playID document.ID, playRecord []byte) (string, error) {
	r, err := s.runPlayRecord(Arena, servKey, playID, playRecord)
	if err != nil {
		return "", err
	}
	r.Wait()
	return r.Result, nil
}

func (s *Service) NewCraftBattle(servKey string, playID document.ID, playRecord []byte) (CraftBattleResult, error) {
	r, err := s.runPlayRecord(Craft, servKey, playID, playRecord)
	if err != nil {
		return CraftBattleResult{}, err
	}
	r.Wait()
	return CraftBattleResult{
		Result: r.Result,
		Point1: r.Point1,
		Point2: r.Point2,
	}, nil
}

func (s *Service) NewUnionFightBattle(servKey string, playID document.ID, playRecord []byte) (UnionFightBattleResult, error) {
	r, err := s.runPlayRecord(UnionFight, servKey, playID, playRecord)
	if err != nil {
		return UnionFightBattleResult{}, err
	}
	r.Wait()
	return UnionFightBattleResult{
		Result: r.Result,
		States: r.States,
	}, nil
}

func (s *Service) NewCrossCraftBattle(servKey string, playID document.ID, playRecord []byte) (CraftBattleResult, error) {
	r, err := s.runPlayRecord(CrossCraft, servKey, playID, playRecord)
	if err != nil {
		return CraftBattleResult{}, err
	}
	r.Wait()
	return CraftBattleResult{
		Result: r.Result,
		Point1: r.Point1,
		Point2: r.Point2,
	}, nil
}

func (s *Service) NewEndlessBattle(servKey string, playID document.ID, playRecord []byte) (string, error) {
	r, err := s.runPlayRecord(Endless, servKey, playID, playRecord)
	if err != nil {
		return "", err
	}
	r.Wait()
	return r.Result, nil
}

func (s *Service) NewGateBattle(servKey string, playID document.ID, playRecord []byte) (string, error) {
	r, err := s.runPlayRecord(Gate, servKey, playID, playRecord)
	if err != nil {
		return "", err
	}
	r.Wait()
	return r.Result, nil
}

func (s *Service) NewCrossMineBossBattle(servKey string, playID document.ID, playRecord []byte) (CrossMineBossResult, error) {
	r, err := s.runPlayRecord(CrossMineBoss, servKey, playID, playRecord)
	if err != nil {
		return CrossMineBossResult{}, err
	}
	r.Wait()
	return CrossMineBossResult{
		Result:  r.Result,
		Damages: r.Damages,
	}, nil
}

func (s *Service) NewBraveChallengeBattle(servKey string, playID document.ID, playRecord []byte) (string, error) {
	r, err := s.runPlayRecord(BraveChallenge, servKey, playID, playRecord)
	if err != nil {
		return "", err
	}
	r.Wait()
	return r.Result, nil
}

func (s *Service) NewHuntingBattle(servKey string, playID document.ID, playRecord []byte) (string, error) {
	r, err := s.runPlayRecord(Hunting, servKey, playID, playRecord)
	if err != nil {
		return "", err
	}
	r.Wait()
	return r.Result, nil
}

func (s *Service) NewSummerChallengeBattle(servKey string, playID document.ID, playRecord []byte) (string, error) {
	r, err := s.runPlayRecord(SummerChallenge, servKey, playID, playRecord)
	if err != nil {
		return "", err
	}
	r.Wait()
	return r.Result, nil
}



func (s *Service) NewCrossMineBattle(servKey string, playID document.ID, playRecord []byte) (string, error) {
	r, err := s.runPlayRecord(CrossMine, servKey, playID, playRecord)
	if err != nil {
		return "", err
	}
	r.Wait()
	return r.Result, nil
}

func (s *Service) NewCrossArenaBattle(servKey string, playID document.ID, playRecord []byte) (string, error) {
	r, err := s.runPlayRecord(CrossArena, servKey, playID, playRecord)
	if err != nil {
		return "", err
	}
	r.Wait()
	return r.Result, nil
}

func (s *Service) NewCrossUnionFightBattle(servKey string, playID document.ID, playRecord []byte) (CrossUnionFightBattleResult, error) {
	r, err := s.runPlayRecord(CrossUnionFight, servKey, playID, playRecord)
	if err != nil {
		return CrossUnionFightBattleResult{}, err
	}
	r.Wait()
	return CrossUnionFightBattleResult{
		Result: r.Result,
		States: r.States,
	}, nil
}

func (s *Service) runPlayRecord(battleType BattleType, servKey string, playID document.ID, playRecord []byte) (*Record, error) {
	id := atomic.AddInt64(&s.counter, 1)
	r := NewRecord(id, battleType, servKey, playID, playRecord)
	var c chan *Record
	if battleType == UnionFight {
		c = s.unionFightRecords
	} else {
		c = s.records
	}
	select {
	case c <- r:
		s.waiting.Inc()
		select {
		case s.recordCheck <- 1:
		default:
			log.Warning("record check size full")
		}
		return r, nil
	default:
		r.Done()
		return nil, ErrWaitQueueFull
	}
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}

	s.RegisterCustom(s, caller.Global, "NewArenaBattle", nil)
	s.RegisterCustom(s, caller.Global, "NewCraftBattle", nil)
	s.RegisterCustom(s, caller.Global, "NewUnionFightBattle", nil)
	s.RegisterCustom(s, caller.Global, "NewCrossCraftBattle", nil)
	s.RegisterCustom(s, caller.Global, "NewEndlessBattle", nil)
	s.RegisterCustom(s, caller.Global, "NewCrossMineBossBattle", nil)
	s.RegisterCustom(s, caller.Global, "NewBraveChallengeBattle", nil)
	s.RegisterCustom(s, caller.Global, "NewHuntingBattle", nil)
	s.RegisterCustom(s, caller.Global, "NewSummerChallengeBattle", nil)
	s.RegisterCustom(s, caller.Global, "NewGateBattle", nil)
	s.RegisterCustom(s, caller.Global, "NewCrossMineBattle", nil)
	s.RegisterCustom(s, caller.Global, "NewCrossArenaBattle", nil)
	s.RegisterCustom(s, caller.Global, "NewCrossUnionFightBattle", nil)

	return s
}

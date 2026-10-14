package forward

import (
	"context"
	"errors"
	"fmt"
	"io/ioutil"
	"net"
	"strconv"
	"strings"
	"sync"
	"sync/atomic"
	"time"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj"
	"tjgame/server_framework/tj/log"
	tjnet "tjgame/server_framework/tj/net"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/service/caller"
	tjutil "tjgame/server_framework/tj/util"
	"tjgame/services/cross"
	"tjgame/services/cross/onlinefight/proto"
	"tjgame/services/game/cards"

	"github.com/fsnotify/fsnotify"
)

const Name = "online_fight_forward"

var (
	ErrBattleExpired = errors.New("battle expired")
	PatchFile        = ""
)

func SetDebug(v bool) {
	debug = v
}

type Service struct {
	*service.Service
	*receptionist
	address string

	runner atomic.Value

	battles  sync.Map
	fighting int64
	backoff  uint32
}

func (s *Service) Init() bool {
	if ok := s.Service.Init(); !ok {
		return false
	}
	cards.InitBattleCardHaloConfig()

	// file watcher
	watcher, err := fsnotify.NewWatcher()
	if err != nil {
		log.Panic(err)
	}
	if err = watcher.Add("./"); err != nil {
		log.Panic(err)
	}
	PatchFile = fmt.Sprintf("%s_patch", tj.Language())
	log.Infof("watch patch file %s", PatchFile)
	go func() {
		for {
			select {
			case ev := <-watcher.Events:
				log.Info("fsnotify event:", ev)
				if strings.HasSuffix(ev.Name, "patch") && (ev.Op == fsnotify.Write || ev.Op == fsnotify.Create) {
					if s.onPatchChanged(PatchFile) {
						s.reloadProxyRunner(currentPatch)
					}
				}
			case err := <-watcher.Errors:
				log.Warning("fsnotify error:", err)
				return
			}
		}
	}()

	s.receptionist.mgr = newSessionManager(context.TODO())
	s.receptionist.ctx, s.receptionist.cancel = context.WithCancel(context.TODO())
	return true
}

func (s *Service) Start() bool {
	s.onPatchChanged(PatchFile)
	if err := s.reloadProxyRunner(currentPatch); err != nil {
		panic(err)
	}
	return s.Service.Start()
}

func (s *Service) Stop() {
	runner := s.runner.Load()
	if runner != nil {
		runner.(*AntiProxyRunner).Stop()
	}
	s.Service.Stop()
}

func (s *Service) SetAddress(address string) {
	s.address = address
}

func (s *Service) OnNewConn(conn net.Conn) {
	tjconn := tjnet.NewNetConn(conn, s)
	tjconn.Start()
}

func (s *Service) updatefighting(n int64) {
	fighting := atomic.AddInt64(&s.fighting, n)
	if fighting%10 == 0 {
		if atomic.CompareAndSwapUint32(&s.backoff, 0, 1) {
			log.Infof("total fighting %d, backoff", fighting)
			s.Container().(*service.Container).Backoff("StartOnlineFightBattle", true)

			time.AfterFunc(time.Second*30, func() {
				if atomic.CompareAndSwapUint32(&s.backoff, 1, 0) {
					s.Container().(*service.Container).Backoff("StartOnlineFightBattle", false)
				}
			})
		}
	}
}

func (s *Service) StartOnlineFightBattle(info *proto.BattleInfo) ([]string, error) {
	if tjutil.Now().Unix()-info.Time > 30 {
		return nil, ErrBattleExpired
	}

	err := cross.ContainerServices(s.Container(), info.From)
	if err != nil {
		return nil, err
	}

	// 1. new battle
	info.PlayRecord.ID = info.ID // proxy agent will use this id
	battle := NewBattle(info)
	s.battles.Store(info.ID, battle)
	s.updatefighting(1)

	// 2. create session
	session1 := s.receptionist.EnsureSession(info.Role1.RoleID)
	session2 := s.receptionist.EnsureSession(info.Role2.RoleID)
	// 3. assign battle session
	session1.battle = battle
	session2.battle = battle
	battle.sessions = [2]*Session{session1, session2}
	// 4. set proxy runner
	if useAntiProxyRunner() {
		runner := s.runner.Load()
		battle.SetProxyRunner(runner.(ProxyRunner))
	} else {
		if proxyRunner == "fake" {
			battle.SetProxyRunner(&FakeProxyRunner{})
		} else {
			battle.SetProxyRunner(NewResumeProxyRunner(battle))
		}
	}

	battle.startWaitConnectTimer()

	go func() {
		<-battle.Done()
		s.battles.Delete(battle.id)
		if info.From != "" {
			service.Call(s.Container().GetService(info.From), "CrossOnlineFightBattleOver", battle.Result())
		}
	}()

	return []string{s.Name(), s.address}, nil
}

func (s *Service) StartOnlineFightBattleAuto(info *proto.BattleInfo) ([]string, error) {
	err := cross.ContainerServices(s.Container(), info.From)
	if err != nil {
		return nil, err
	}

	// 1. new battle
	info.PlayRecord.ID = info.ID // proxy agent will use this id
	battle := NewBattle(info)
	s.battles.Store(info.ID, battle)
	s.updatefighting(1)

	// 2. create session
	//session1 := s.receptionist.EnsureSession(info.Role1.RoleID)
	//session2 := s.receptionist.EnsureSession(info.Role2.RoleID)
	// 3. assign battle session
	//session1.battle = battle
	//session2.battle = battle
	battle.sessions = [2]*Session{}
	// 4. set proxy runner
	runner := s.runner.Load()
	battle.SetProxyRunner(runner.(ProxyRunner))
	battle.ready = [2]int32{1, 1}
	battle.loop = 1
	battle.tryStartAttackLoop()

	go func() {
		<-battle.Done()
		s.battles.Delete(battle.id)
	}()

	return []string{s.Name(), s.address}, nil
}

func (s *Service) StartOnlineFightBattlePlayRecord(record *scheme.CrossOnlineFightPlayRecord) ([2]string, error) {
	info := &proto.BattleInfo{
		ID:         record.ID,
		Role1:      nil,
		Role2:      nil,
		PlayRecord: record,
	}
	battle := NewBattle(info)
	battle.sessions = [2]*Session{}
	runner := s.runner.Load()
	battle.SetProxyRunner(runner.(ProxyRunner))
	battle.loop = 1
	battle.tryStartAttackLoop()

	go func() {
		for _, frames := range record.AttackFrames {
			wrap := inputWrapper{
				AttackInput: &frames.Input,
				err:         make(chan error, 1),
			}
			battle.inputs <- wrap
			<-wrap.err
		}
		log.Infof("add inputs from play record over")
	}()

	<-battle.Done()
	return battle.results, nil
}

func (s *Service) CheckCrossOnlineBattleState(id document.ID, timestamp int64) (int, error) {
	log.Infof("CheckCrossOnlineBattleState, %s %d", id, timestamp)
	v, ok := s.battles.Load(id)
	if !ok {
		return 0, ErrNoBattle
	}
	battle := v.(*Battle)
	return battle.State, nil
}

func (s *Service) SetBackoff(v bool) (bool, error) {
	s.Container().(*service.Container).Backoff("StartOnlineFightBattle", v)
	if v == true {
		atomic.StoreUint32(&s.backoff, 1)
	} else {
		atomic.StoreUint32(&s.backoff, 0)
	}
	return true, nil
}

func (s *Service) onPatchChanged(filename string) bool {
	patch := currentPatch
	data, err := ioutil.ReadFile(filename)
	if err != nil {
		log.Errorf("read patch error %s", err)
		return false
	}
	content := strings.TrimSpace(string(data))
	patch, err = strconv.Atoi(content)
	if err != nil {
		log.Errorf("parse patch error %s, content %s", err, content)
		return false
	}

	if currentPatch == patch {
		log.Warningf("already set patch %d", patch)
		return false
	}
	currentPatch = patch
	log.Infof("current patch set %d", patch)
	return true
}

func (s *Service) reloadProxyRunner(patch int) error {
	runner := NewAntiProxyRunner(patch)
	err := runner.Start()
	if err != nil {
		log.Errorf("start runner error %s, patch %d", err, patch)
		return err
	}
	old := s.runner.Load()
	s.runner.Store(runner)
	log.Infof("start runner %d patch %d success", runner.idx, patch)
	if old != nil {
		old.(*AntiProxyRunner).NoBattleStop()
	}

	go func() {
		<-runner.Done()
		s.reloadProxyRunner(currentPatch)
	}()

	return nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service:      service.NewService(option, container),
		receptionist: &receptionist{},
	}

	s.RegisterCustom(s, caller.Global, "StartOnlineFightBattle", nil)
	s.RegisterCustom(s, caller.Global, "StartOnlineFightBattleAuto", nil)
	s.RegisterCustom(s, caller.Global, "StartOnlineFightBattlePlayRecord", nil)
	s.Register(s, "CheckCrossOnlineBattleState")
	s.Register(s, "SetBackoff")

	return s
}

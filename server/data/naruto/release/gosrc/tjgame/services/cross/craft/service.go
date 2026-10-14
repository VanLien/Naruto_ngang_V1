package craft

import (
	"errors"
	"reflect"
	"sync"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/cross"
)

const (
	Name = "crosscraft"
)

type Service struct {
	*service.Service
	cross.Skeleton
	builder *Builder
	craft   *Craft

	roleLastTime sync.Map // {roleID: (last_time, query_time)
}

func (s *Service) Init() bool {
	if ok := s.Service.Init(); !ok {
		return false
	}
	LoadConfig()
	initFix()
	// language := tj.Language()
	// if language == "en" {
	// 	signupTime = signupTimeEN
	// 	prepareTime = prepareTimeEN
	// }
	return true
}

func (s *Service) Start() bool {
	opt := s.Option.Base()
	var ss service.IService
	for _, name := range opt.Dependent {
		ns, _, _ := service.SplitServiceName(name)
		if ns == "crossdb" {
			ss = s.Container().GetService(name)
			break
		}
	}
	s.builder = NewBuilder(ss)

	key := opt.Name
	s.craft = s.builder.NewCraft(key)
	if s.craft == nil {
		return false
	}
	s.craft.container = s.Container()
	s.craft.init(s.builder)
	log.Infof("load %s cross craft round %s", key, s.craft.Round())

	s.craft.SetAgentManager(s.Name(), s.Container().GetService("anticheat"))

	s.Skeleton.Init(s.Name(), Name, s.craft)

	if s.craft.isAllOver() {	
		// 已结束
		log.Infof("Cross Craft is AllOver True")
		s.craft.clean()
	} else {
		s.MustContainServices(s.craft.Servers(), "pvp")
		// 中途重启
		s.craft.ResetToday()
	}

	go s.StartServiceCheck()

	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.builder.Stop()
}

func (s *Service) CrossCraftJoin(key string) (*DBForGame, error) {
	_, unlock := s.craft.RLockAndGetDB()
	defer unlock()
	if !s.craft.isServerOK(key) {
		return nil, nil
	}
	return s.craft.dbForGame(), nil
}

type RoleCrossCraftView struct {
	Info struct {
		scheme.CrossCraftRoleInfo
		IsOut bool `codec:"isout,omitempty"`
	} `codec:"info"`
	VSInfo *scheme.CrossCraftBattleRole `codec:"vsinfo"`
}

func (s *Service) GetCrossCraftView(roleID document.ID) (*RoleCrossCraftView, error) {
	view := &RoleCrossCraftView{}
	if role, ok := s.craft.GetCrossCraftRole(roleID); ok {
		view.Info.CrossCraftRoleInfo = role
	}
	out, vsrole := s.craft.GetVSRole(roleID)
	view.Info.IsOut = out
	if vsrole == nil {
		return view, nil
	}
	s.craft.RLock()
	round := s.craft.Round()
	s.craft.RUnlock()
	ss := s.Container().GetService(service.Game2PVPService(vsrole.GameKey))
	record := GetRemoteCraftRecord(ss, vsrole.RecordID, 15*time.Second)
	battlecards, fightingpoint := RoundBattleCard(record, round)
	view.VSInfo = &scheme.CrossCraftBattleRole{
		CrossCraftRole: *vsrole,
		FightingPoint:  fightingpoint,
		Cards:          battlecards,
	}
	return view, nil
}

func (s *Service) GetCrossCraftPlayRecord(id document.ID) (*scheme.CrossCraftPlayRecordObject, error) {
	playRecord := s.builder.GetCrossCraftPlayRecord(id)
	if playRecord == nil {
		return nil, nil
	}
	return playRecord.CrossCraftPlayRecordObject, nil
}

type RankResponse struct {
	Ranks  []scheme.CrossCraftRoleInfo `codec:"ranks"`
	MyInfo *scheme.CrossCraftRoleInfo  `codec:"myinfo"`
}

func (s *Service) GetCrossCraftRank(offset, size int, roleID document.ID) (*RankResponse, error) {
	var myinfo *scheme.CrossCraftRoleInfo
	ranks := s.craft.GetRankList(offset, size)
	if roleID != "" {
		if info, ok := s.craft.GetCrossCraftRole(roleID); ok {
			myinfo = &info
		}
	}
	return &RankResponse{Ranks: ranks, MyInfo: myinfo}, nil
}

// 预选下注
func (s *Service) CrossCraftBetPreRole(key string, roleID document.ID, target scheme.CrossCraftRole, coin string, amount int) (*BetInfo, error) {
	return s.craft.BetPreRole(key, roleID, target, coin, amount)
}

// 下注top4
func (s *Service) CrossCraftBetTop4Role(key string, roleID, target document.ID, coin string, amount int) (*BetInfo, error) {
	return s.craft.BetTop4Role(key, roleID, target, coin, amount)
}

// 下注冠军
func (s *Service) CrossCraftBetChampion(key string, roleID, target document.ID, coin string, amount int) (*BetInfo, error) {
	return s.craft.BetChampion(key, roleID, target, coin, amount)
}

// 我的下注
func (s *Service) CrossCraftGetBetInfo(roleID document.ID) (*BetInfo, error) {
	return s.craft.GetBetInfo(roleID), nil
}

// 预选赛单服积分排行榜
func (s *Service) CrossCraftGetPrePointRank(key string, offest, size int) ([]preRankRole, error) {
	return s.craft.GetPrePointRank(key, offest, size), nil
}

func (s *Service) CrossCraftGetRoleLastTime(key string, roleID document.ID) (int, error) {
	now := int(util.Now().Unix())
	lastime := 0
	refresh := false
	v, ok := s.roleLastTime.Load(roleID)
	if ok {
		vv := v.([2]int)
		lastime = vv[0]
		refresh = now-vv[1] > 5*60
	} else {
		refresh = true
	}
	if refresh {
		if s.Container().GetService(key) == nil {
			if err := s.Container().AddRemoteService(key); err != nil {
				log.Warningf("AddRemoteService %s error %v", key, err)
				return 0, nil
			}
		}
		resp, err := service.Call(s.Container().GetService(key), "CrossGetRoleLastTime", roleID)
		if err != nil {
			return 0, err
		}
		lastime = resp.(int)
		s.roleLastTime.Store(roleID, [2]int{lastime, now})
	}
	return lastime, nil
}

func (s *Service) GameSync() (*SyncModel, error) {
	return s.craft.syncModel(), nil
}

func (s *Service) ResetCrossCraftPlayRecordRandSeed(id document.ID) (int32, error) {
	r := s.builder.GetCrossCraftPlayRecord(id)
	r.Lock()
	defer r.Unlock()
	seed := r.resetRandSeed()
	return seed, nil
}

func (s *Service) SetInQuick(quick bool, halftimeQuick bool) (bool, error) {
	TestInQuick = quick
	TestHalftimeQuick = halftimeQuick
	return true, nil
}

func (s *Service) StartCrossCraft(id int, servers []string, quick bool, halftimeQuick bool) (bool, error) {
	round := s.craft.Round()
	if round != "closed" && round != "over" {
		return false, errors.New("cross craft already start")
	}
	if err := s.AddServicesDynamic(servers); err != nil {
		log.Errorf("some service not in container, %v", err)
		return false, err
	}
	ret, err := s.TransactionCommit(servers, s.Name(), Name)
	if err != nil {
		log.Warningf("transaction_commit %s error, %v", s.Name(), err)
		return false, err
	}
	log.Infof("transaction_commit %s %v", s.Name(), ret)
	if ret {
		TestInQuick = quick
		TestHalftimeQuick = halftimeQuick
		// 替换为原始key
		cfg := csv.GetMergeConfig()
		origins := make([]string, 0, len(servers))
		for _, key := range servers {
			origins = append(origins, cfg.GetSrcServKeys(key)...)
		}
		servers = origins
		// 检查 container 里面是否都有对应的services, 动态添加
		if err := s.AddServicesDynamic(servers, "pvp"); err != nil {
			log.Errorf("some service not in container, %v", err)
			return false, err
		}
		s.craft.onInit(id, servers)
	}
	return ret, nil
}

func (s *Service) CrossCraftNext() (bool, error) {
	if s.craft.timer == nil {
		return false, errors.New("no timer found")
	}
	if s.craft.timer.Stop() {
		round := s.craft.Round()
		s.craft.timer.Reset(time.Second)
		log.Infof("Cross Craft Reset Timer Round %s Next", round)
	} else {
		return false, errors.New("timer function already started in its own goroutine")
	}
	return true, nil
}

func (s *Service) CrossCraftCancel() (bool, error) {
	if s.craft.timer != nil {
		if s.craft.timer.Stop() {
			log.Infof("Cross Craft Cancel")
			s.craft.clean()
			return true, nil
		} else {
			return false, errors.New("timer function already started in its own goroutine")
		}
	}
	return true, nil
}

func (s *Service) CrossCraftStop() (bool, error) {
	if s.craft.timer == nil {
		return false, errors.New("no timer found")
	}
	if s.craft.timer.Stop() {
		round := s.craft.Round()
		log.Infof("Cross Craft Stop Timer Round %s", round)
	} else {
		return false, errors.New("timer function already started in its own goroutine")
	}
	return true, nil
}

func (s *Service) CrossCraftResume() (bool, error) {
	if s.craft.timer == nil {
		return false, errors.New("no timer found")
	}
	s.craft.timer.Stop()
	round := s.craft.Round()
	s.craft.timer.Reset(time.Second * 5)
	log.Infof("Cross Craft Resume Timer Round %s", round)
	return true, nil
}

func (s *Service) ResetAgentManager() (bool, error) {
	s.craft.mgr.Reset()
	return true, nil
}

func (s *Service) ResetAgentManagerLastAvgRespDur() (bool, error) {
	s.craft.mgr.ResetLastAvgRespDur()
	return true, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}
	s.SetContainer(container)

	s.Register(s, "CrossCraftJoin")
	s.Register(s, "GetCrossCraftView")
	s.Register(s, "GetCrossCraftPlayRecord")
	s.Register(s, "GetCrossCraftRank")
	s.Register(s, "CrossCraftBetPreRole")
	s.Register(s, "CrossCraftBetTop4Role")
	s.Register(s, "CrossCraftBetChampion")
	s.Register(s, "CrossCraftGetBetInfo")
	s.Register(s, "CrossCraftGetPrePointRank")
	s.Register(s, "CrossCraftGetRoleLastTime")
	s.Register(s, "GameSync")

	s.Register(s, "ResetCrossCraftPlayRecordRandSeed")
	s.Register(s, "SetInQuick")
	s.Register(s, "StartCrossCraft")
	s.Register(s, "CrossCraftNext")
	s.Register(s, "CrossCraftCancel")
	s.Register(s, "CrossCraftStop")
	s.Register(s, "CrossCraftResume")

	s.Register(s, "ResetAgentManager")
	s.Register(s, "ResetAgentManagerLastAvgRespDur")

	return s
}

func GetRemoteCraftRecord(s service.IService, id document.ID, timeout time.Duration) *scheme.CrossCraftRecord {
	if s == nil || reflect.ValueOf(s).IsNil() {
        log.Errorf("[CrossCraft] GetRemoteCraftRecord failed: service is nil. (id=%v)", id)
        return nil
    }

    resp, err := service.Call(s, "GetCrossCraftRecord", id)
    if err != nil {
        log.Errorf("[CrossCraft] GetRemoteCraftRecord call error : %v (id=%v)", err, id)
        return nil
    }

    record, ok := resp.(*scheme.CrossCraftRecordObject)
    if !ok {
        log.Errorf("[CrossCraft] invalid response type : %T (id=%v)", resp, id)
        return nil
    }

    db, unlock := record.RLockAndGetDB()
    defer unlock()
    return db
}

package arena

import (
	"errors"
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
	"sync/atomic"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	tjutil "tjgame/server_framework/tj/util"
	"tjgame/services/cross"
	"tjgame/ta"

	"github.com/fsnotify/fsnotify"
)

const (
	Name = "crossarena"
)

var emptyCrossArenaPlayRecord = scheme.NewCrossArenaPlayRecordObject(&scheme.CrossArenaPlayRecord{})

type Service struct {
	*service.Service

	builder *Builder

	arena *Arena // CrossArenaGlobalObject

	cross.Skeleton

	storage service.IService

	agent service.IService // 反作弊

	leastPatch uint32
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
	for _, name := range opt.Dependent {
		if name == "anticheat" {
			s.agent = s.Container().GetService("anticheat")
		} else {
			ns, _, _ := service.SplitServiceName(name)
			if ns == "crossdb" {
				s.storage = s.Container().GetService(name)
				break
			}
		}
	}
	s.builder = NewBuilder(s.storage)

	key := opt.Name
	// load cross arena global
	s.arena = s.builder.NewCrossArenaGlobal(key)
	if s.arena == nil {
		return false
	}
	s.arena.container = s.Container()
	s.arena.init(s.builder)
	log.Infof("load %s cross arena round %s", key, s.arena.Round())

	s.Skeleton.Init(s.Name(), Name, s.arena)

	s.arena.SetAgentManager(s.Name(), s.Container().GetService("anticheat"))

	if s.arena.IsOver() {
		// 已结束
		log.Infof("Cross Arena is AllOver True")
		s.arena.clean()
	} else {
		s.MustContainServices(s.arena.Servers(), "pvp")
		// 中途重启
		go s.arena.ResetToday()
	}

	go s.StartServiceCheck()

	s.arena.track = ta.NewBattleCardTrack(s.Name(), "cross_arena")
	s.arena.track.Start()

	// file watcher
	watcher, err := fsnotify.NewWatcher()
	if err != nil {
		log.Panic(err)
	}
	patchfile := fmt.Sprintf("../online_fight_forward/%s_patch", tj.Language())
	if err = watcher.Add("../online_fight_forward/"); err != nil {
		log.Panic(err)
	}
	log.Infof("watch patch file %s", patchfile)

	onPatchChanged := func() {
		if data, err := ioutil.ReadFile(patchfile); err == nil {
			content := strings.TrimSpace(string(data))
			if patch, err := strconv.Atoi(content); err == nil {
				atomic.StoreUint32(&s.leastPatch, uint32(patch))
				log.Infof("set least patch %d", uint32(patch))
			} else {
				log.Errorf("parse patch error %s, content %s", err, content)
			}
		} else {
			log.Errorf("read patch error %s", err)
		}
	}
	go func() {
		for {
			select {
			case ev := <-watcher.Events:
				log.Info("fsnotify event:", ev)
				if ev.Name == patchfile && (ev.Op == fsnotify.Write || ev.Op == fsnotify.Create) {
					onPatchChanged()
				}
			case err := <-watcher.Errors:
				log.Warning("fsnotify error:", err)
				return
			}
		}
	}()

	onPatchChanged()

	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.builder.Stop()
	s.arena.track.Stop()
}

// 跨服竞技场加入服务 server_key
func (s *Service) CrossArenaJoin(key string) (*DBForGame, error) {
	_, unlock := s.arena.RLockAndGetDB()
	defer unlock()
	if !s.arena.isServerOK(key) {
		return nil, nil
	}
	return s.arena.dbForGame(), nil
}

// 战斗开始
func (s *Service) CrossArenaBattleStart(rank, battleRank int, roleID, enemyRoleID, recordID, enemyRecordID document.ID, patch uint32) (*scheme.CrossArenaPlayRecordObject, error) {
	
	// log.Infof("[chanlong] CrossArenaBattleStart:  patch=%s leastPatch=%s", patch, atomic.LoadUint32(&s.leastPatch))
	
	// bypass by chanlong
	// if patch > 1 && patch < atomic.LoadUint32(&s.leastPatch) {
	// 	return nil, ErrPatchBehind
	// }

	// 自己排名发生改变
	r, err := s.arena.getRoleRank(roleID)
	if err != nil {
		return emptyCrossArenaPlayRecord, err
	}
	if r != rank {
		return emptyCrossArenaPlayRecord, ErrRankChanged
	}
	// 判断round
	isRoundStart := false
	var gameKey1 string
	var gameKey2 string
	tjutil.WithGuard(s.arena, func() {
		if s.arena.Round() == "start" {
			isRoundStart = true
			gameKey1 = s.arena.ArenaRoles()[roleID].GameKey
			gameKey2 = s.arena.ArenaRoles()[enemyRoleID].GameKey
		}
	})
	if !isRoundStart {
		return emptyCrossArenaPlayRecord, ErrRoundClosed
	}

	ss := s.Container().GetService(service.Game2PVPService(gameKey1))
	log.Infof("[crossArena] roleID=%v enemyRoleID=%v recordID=%v enemyRecordID=%v gameKey1=%s gameKey2=%s",
    	roleID, enemyRoleID, recordID, enemyRecordID, gameKey1, gameKey2)
	if ss == nil {
		return emptyCrossArenaPlayRecord, fmt.Errorf("no service for gameKey %s", gameKey1)
	}
	record := GetRemoteArenaRecord(ss, recordID, 15*time.Second)

	// 记录战斗
	err = s.arena.storeForRole(battleRank, roleID, enemyRoleID, recordID, enemyRecordID)
	if err != nil {
		return emptyCrossArenaPlayRecord, err
	}

	// 生成 playModel 
	enemyRecord := GetRemoteArenaRecord(s.Container().GetService(service.Game2PVPService(gameKey2)), enemyRecordID, 15*time.Second)

	roleKey := scheme.RoleKey{ID: roleID, GameKey: gameKey1}
	enemyRoleKey := scheme.RoleKey{ID: enemyRoleID, GameKey: gameKey2}
	playModel := NewPlayModel(roleKey, enemyRoleKey, record, enemyRecord)

	// create playRecord in storage
	playRecord := s.builder.CreateCrossArenaPlayRecord(playModel)

	// 存本场战斗
	playRecordID := playRecord.GetID()
	s.arena.battles.Store(roleID, &battle{
		playRecordID:  playRecordID,
		enemyRoleID:   enemyRoleID,
		enemyRecordID: enemyRecordID,
		battleRank:    battleRank,
	})

	if s.agent != nil {
		go func() {
			var data []byte
			var err error
			model, unlock := playRecord.RLockAndGetDB()
			tjutil.WithDefer(func() {
				data, err = tjutil.MsgPack(model)
			}, unlock)
			if err != nil {
				return
			}
			future := service.CallAsync(s.agent, "NewCrossArenaBattle", s.Name(), playRecordID, data)
			go func() {
				ret, err := future.Get()
				if err != nil {
					log.Warningf("cross arena role %v play %v result error %v", roleID, playRecordID, err)
					return
				}
				result := ret.(string)
				if result == "win" || result == "fail" {
					if b, ok := s.arena.battles.Load(roleID); ok {
						bb := b.(*battle)
						tjutil.WithGuard(&bb.mu, func() {
							log.Infof("cross arena role %v play %v anti result %v", roleID, playRecordID, result)
							if bb.result.client == "" {
								bb.result.anticheat = result
							} else if bb.result.client != result {
								log.Infof("cross arena role %v play %v anti %v result %v is diff beffer anti", roleID, playRecordID, result, bb.result.client)
							}
						})
					}
				} else {
					log.Warningf("cross arena role %v play %v result %s", roleID, playRecordID, result)
				}
			}()
		}()
	}

	return playRecord.CrossArenaPlayRecordObject, nil
}

// 战斗结束
func (s *Service) CrossArenaBattleEnd(battleRank int, roleID, recordID document.ID, result string, isTopBattle bool) (map[string]int, error) {
	// 判断round
	isRoundStart := false
	tjutil.WithGuard(s.arena, func() {
		if s.arena.Round() == "start" {
			isRoundStart = true
		}
	})
	if !isRoundStart {
		return nil, ErrRoundClosed
	}

	var bb *battle
	if b, ok := s.arena.battles.Load(roleID); ok {
		bb = b.(*battle)
		s.arena.battles.Delete(roleID)
	} else {
		return nil, errors.New("battle not found")
	}

	return s.arena.battleEndUpdate(bb, roleID, recordID, result, false, isTopBattle)
}

// 主界面model
func (s *Service) GetCrossArenaModel(roleID document.ID, roleInfo *scheme.CrossArenaRoleInfo, refresh bool) (resp ModelResponse, err error) {
	db, unlock := s.arena.LockAndGetDB()
	defer unlock()
	if db.Round != "start" {
		err = ErrRoundClosed
		return
	}

	roles := db.ArenaRoles
	// 只有不存在才添加，存在则更新roleInfo
	if _, ok := roles[roleInfo.RoleID]; !ok {
		// RankMax
		rankMax := db.RankMax + 1
		s.arena.SetRankMax(rankMax)

		// ArenaRoles
		roleInfo.Rank = int(rankMax)
		roleInfo.TopRank = int(rankMax)
		roles[roleInfo.RoleID] = roleInfo
		s.arena.SetArenaRoles(roles)
		// Ranks
		db.Ranks[document.Integer(rankMax)] = [2]document.ID{roleInfo.RoleID, roleInfo.RecordID}
		s.arena.SetRanks(db.Ranks)

		// 加入到roleRanks缓存
		s.arena.roleRanks[roleInfo.RoleID] = document.Integer(rankMax)

		resp.Flag = true
	} else {
		roleInfo.Rank = roles[roleInfo.RoleID].Rank
		roleInfo.TopRank = roles[roleInfo.RoleID].TopRank
		roles[roleInfo.RoleID] = roleInfo
		s.arena.SetArenaRoles(roles)
		// flag
		resp.Flag = false
	}

	// enemys
	resp.Enemys = s.arena.getBattleEnemys(roleID, refresh)
	// role
	resp.Role = *roles[roleID]

	return
}

// 战斗记录
func (s *Service) GetCrossArenaPlayRecord(id document.ID) (*scheme.CrossArenaPlayRecordObject, error) {
	playRecord := s.builder.GetCrossArenaPlayRecord(id)
	if playRecord == nil {
		return nil, nil
	}
	return playRecord.CrossArenaPlayRecordObject, nil
}

// 实时排行榜
func (s *Service) GetCrossArenaTopRanks(offset int, size int, roleID document.ID) (*RankResponse, error) {
	db, unlock := s.arena.RLockAndGetDB()
	defer unlock()
	// 实时排行榜只有start时调
	if db.Round != "start" {
		return nil, ErrRoundClosed
	}

	var myInfo scheme.CrossArenaRoleInfo
	ranks := s.arena.topRanks(offset, size)
	if roleID != "" {
		myInfo = *db.ArenaRoles[roleID]
	}
	return &RankResponse{Ranks: ranks, MyInfo: myInfo}, nil

}

// 更新展示的卡牌
func (s *Service) UpdateCrossArenaDisplay(roleID document.ID, display int) (bool, error) {
	db, unlock := s.arena.LockAndGetDB()
	defer unlock()
	if db.Round != "start" {
		return false, ErrRoundClosed
	}
	s.arena.updateDisplay(roleID, display)
	return true, nil
}

// 获取精彩对战战报
func (s *Service) GetCrossArenaTopBattleHistory() ([]scheme.CrossArenaTopBattleHistory, error) {
	db, unlock := s.arena.LockAndGetDB()
	defer unlock()
	if db.Round != "start" {
		return nil, ErrRoundClosed
	}
	topBattleHistories := db.LastTopBattleHistory
	return topBattleHistories, nil
}

// 测试 开始跨服竞技场
func (s *Service) StartCrossArena(id int, servers []string, quick bool) (bool, error) {
	round := s.arena.Round()
	if round != "closed" {
		return false, errors.New("cross arena already start")
	}
	// 检查 container 里面是否都有对应的services, 动态添加
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
		// 替换为原始key
		cfg := csv.GetMergeConfig()
		origins := make([]string, 0, len(servers))
		for _, key := range servers {
			origins = append(origins, cfg.GetSrcServKeys(key)...)
		}
		log.Debug(servers)
		log.Debug(origins)
		servers = origins
		// 检查 container 里面是否都有对应的services, 动态添加
		if err := s.AddServicesDynamic(servers, "pvp"); err != nil {
			log.Errorf("some service not in container, %v", err)
			return false, err
		}
		s.arena.OnInit(id, servers)
	}
	return true, nil
}

// 测试 快速结束跨服竞技场
func (s *Service) CloseCrossArena() (bool, error) {
	if s.arena.Round() != "start" {
		return false, ErrRoundClosed
	}
	s.arena.onClosed()
	return true, nil
}

// 测试 跨服竞技场领取7日奖励
func (s *Service) CrossArenaSevenDaysAward() (bool, error) {
	if s.arena.Round() != "start" {
		return false, ErrRoundClosed
	}
	s.arena.onSevenDaysAward()
	return true, nil
}

// 测试 交换排名
func (s *Service) SwapCrossArena(roleID document.ID, rank int) (bool, error) {
	if s.arena.Round() != "start" {
		return false, ErrRoundClosed
	}
	tjutil.WithGuard(s.arena, func() {
		oldRank := s.arena.roleRanks[roleID]
		s.arena.swapRank(oldRank, document.Integer(rank))
	})
	return true, nil
}

// 测试 强制刷新精彩战报
func (s *Service) RefreshCrossArenaTopBattleHistory() (bool, error) {
	_, unlock := s.arena.LockAndGetDB()
	defer unlock()
	if s.arena.Round() != "start" {
		return false, ErrRoundClosed
	}
	s.arena.refreshTopBattleHistories()
	return true, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}
	s.SetContainer(container)

	s.Register(s, "CrossArenaJoin")
	s.Register(s, "CrossArenaBattleStart")
	s.Register(s, "CrossArenaBattleEnd")
	s.Register(s, "GetCrossArenaModel")
	s.Register(s, "GetCrossArenaPlayRecord")
	s.Register(s, "GetCrossArenaTopRanks")
	s.Register(s, "UpdateCrossArenaDisplay")
	s.Register(s, "GetCrossArenaTopBattleHistory")

	s.Register(s, "StartCrossArena")
	s.Register(s, "CloseCrossArena")
	s.Register(s, "CrossArenaSevenDaysAward")
	s.Register(s, "SwapCrossArena")
	s.Register(s, "RefreshCrossArenaTopBattleHistory")

	return s
}

// 远程跨服竞技场 record
func GetRemoteArenaRecord(s service.IService, arenaRecordID document.ID, timeout time.Duration) *scheme.CrossArenaRecord {
	resp, err := service.Call(s, "GetCrossArenaRecord", arenaRecordID)
	if err != nil {
		panic(err)
	}
	record := resp.(*scheme.CrossArenaRecordObject)
	db, unlock := record.RLockAndGetDB()
	defer unlock()
	return db
}

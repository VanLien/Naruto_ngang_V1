package onlinefight

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
	"tjgame/document/schemeutil"
	"tjgame/server_framework/tj"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/cross"
	"tjgame/services/cross/onlinefight/proto"
	"tjgame/ta"

	"github.com/fsnotify/fsnotify"
)

const (
	Name = "onlinefight"
)

var (
	ErrRoundClosed   = errors.New("round closed")
	ErrRoundNotStart = errors.New("round not start")
	ErrPatchBehind   = errors.New("patch behind")
)

type Service struct {
	*service.Service

	builder *Builder

	onlinebattle *CrossOnlineFightGlobal

	cross.Skeleton

	storage service.IService

	leastPatch uint32
}

func (s *Service) Init() bool {
	if ok := s.Service.Init(); !ok {
		return false
	}
	_ = LoadConfig()

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

	return true
}

func (s *Service) Start() bool {
	opt := s.Option.Base()
	for _, name := range opt.Dependent {
		ns, _, _ := service.SplitServiceName(name)
		if ns == "crossdb" {
			s.storage = s.Container().GetService(name)
			break
		}
	}
	s.builder = NewBuilder(s.storage)

	key := opt.Name
	s.onlinebattle = s.builder.NewCrossOnlineFight(key)
	if s.onlinebattle == nil {
		return false
	}
	s.onlinebattle.init(s.Container(), s.builder)
	s.onlinebattle.unlimitedTrack = ta.NewBattleCardTrack(s.Name(), "cross_onlinefight_unlimited")
	s.onlinebattle.limitedTrack = ta.NewBattleCardTrack(s.Name(), "cross_onlinefight_limited")
	s.onlinebattle.unlimitedTrack.Start()
	s.onlinebattle.limitedTrack.Start()

	s.Skeleton.Init(s.Name(), Name, s.onlinebattle)

	if s.onlinebattle.isAllOver() {
		log.Infof("Cross OnlineBattle is isAllOver True")
		s.onlinebattle.clean()
	} else {
		s.MustContainServices(s.onlinebattle.Servers(), "pvp")
		// 中途重启
		go s.onlinebattle.ResetToday()
	}

	go s.StartServiceCheck()

	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.builder.Stop()
	s.onlinebattle.unlimitedTrack.Stop()
	s.onlinebattle.limitedTrack.Stop()
}

func (s *Service) CrossOnlineFightJoin(key string) (*SyncGameModel, error) {
	if !s.onlinebattle.IsServerOK(key) {
		return nil, nil
	}
	return s.onlinebattle.SyncGameModel(), nil
}

// 主界面请求
func (s *Service) CrossOnlineFightMainGet(role scheme.CrossOnlineFightRole) (*Response, error) {
	err := s.onlinebattle.RoleJoin(role)
	if err != nil {
		return nil, err
	}
	response := &Response{}
	response.Model = s.onlinebattle.SyncModel(role.RoleID)
	response.Model.MatchResult = s.onlinebattle.RoleGetMatchResult(role.RoleID)
	return response, nil
}

// 开始匹配
func (s *Service) CrossOnlineFightMatchStart(id document.ID, pattern int, cards []int, patch uint32, timeout int) (*Response, error) {
	//if patch > 1 && patch < atomic.LoadUint32(&s.leastPatch) {
	//	return nil, ErrPatchBehind
	//}
	fightingPoint := 0
	if pattern == Unlimited { // 非限制赛匹配需要阵容战力值
		db, unlock := s.onlinebattle.RLockAndGetDB()
		role := db.Roles[id]
		unlock()
		if role != nil {
			record := GetRemoteCrossOnlineFightRecord(s.Container().GetService(service.Game2PVPService(role.GameKey)), role.RecordID)
			fightingPoint = schemeutil.CalcCardFightingPoint(record.Cards, record.CardAttrs)
		}
	}
	matching, err := s.onlinebattle.RoleMatchStart(id, pattern, cards, fightingPoint, time.Duration(timeout)*time.Second)
	response := &Response{}
	response.Model = s.onlinebattle.SyncModel(id)
	response.Model.MatchResult = &MatchResult{Matching: matching}
	return response, err
}

// 取消匹配
func (s *Service) CrossOnlineFightMatchCancel(id document.ID) (*Response, error) {
	if s.onlinebattle.RoleMatchLocked(id) {
		return nil, ErrMatchLocked
	}
	if s.onlinebattle.remotelobby != nil { // 跨cross匹配取消
		if key, ok := s.onlinebattle.roleServerKeys.Load(id); ok {
			service.Call(s.onlinebattle.remotelobby, "CrossLobbyMatchCancel", key.(string), id)
		}
	}
	err := s.onlinebattle.RoleMatchCancel(id)
	response := &Response{}
	response.Model = s.onlinebattle.SyncModel(id)
	return response, err
}

// 跨cross匹配超时
func (s *Service) CrossOnlineFightRemoteLobbyMatchDiscard(ids []document.ID) (bool, error) {
	s.onlinebattle.onMatchDiscard(ids)
	return true, nil
}

// 跨cross匹配成功, player1的cross处理，代理生成战斗
func (s *Service) CrossOnlineFightRemoteLobbyMatched(typ int, player1 *proto.Player, player2 *proto.Player, id document.ID) (bool, error) {
	//player1.CrossKey == s.Name() // 必然相等, 由player1的cross代理生成战斗
	if typ == 1 { // 非限制赛
		if player1.CrossKey == player2.CrossKey { // 都是当前cross内
			s.onlinebattle.startUnLimitedBattle(&player1.Competitor, &player2.Competitor, false)
		} else {
			cross.ContainerServices(s.Container(), player2.CrossKey, service.Game2PVPService(player2.GameKey))
			s.onlinebattle.startRemoteLobbyUnLimitedBattle(id, player1, player2)
		}
	} else {
		banpicks := GetConfig().BanPicks[typ]
		if player1.CrossKey == player2.CrossKey {
			s.onlinebattle.startLimitedBattle(&player1.Competitor, &player2.Competitor, player1.Cards, player2.Cards, banpicks, false)
		} else {
			cross.ContainerServices(s.Container(), player2.CrossKey, service.Game2PVPService(player2.GameKey))
			s.onlinebattle.startRemoteLobbyLimitedBattle(id, player1, player2, banpicks)
		}
	}
	return true, nil
}

// 跨cross匹配成功, 通知player2的cross，匹配成功
func (s *Service) CrossOnlineFightRemoteLobbyMatchedNotify(player1 *proto.Player, player2 *proto.Player, id document.ID) (bool, error) {
	time2, _ := s.onlinebattle.roleMatchTimes.Load(player2.ID)
	s.onlinebattle.roleMatchResult.Store(player2.ID, &verifyer{
		id:    id,
		role1: player1.ID,
		role2: player2.ID,
		time2: time2,
	})
	return true, nil
}

func (s *Service) CrossOnlineFightRemoteBattleNotifyPrepareStart(id document.ID, roleID document.ID) (bool, error) {
	s.onlinebattle.rolePrepare.Store(roleID, id) // lock
	value, ok := s.onlinebattle.roleMatchResult.Load(roleID)
	if !ok {
		return false, errors.New("cancel")
	}
	v := value.(*verifyer)
	t, _ := s.onlinebattle.roleMatchTimes.Load(roleID)
	if v.id != id || v.time2 != t {
		return false, errors.New("invalid")
	}
	return true, nil
}

// 跨cross匹配通知战斗开始
func (s *Service) CrossOnlineFightRemoteBattleNotifyStart(player1 *proto.Player, player2 *proto.Player, name string, address string, pattern int, id document.ID) (bool, error) {
	if address == "" { // notify battle invalid
		s.onlinebattle.rolePrepare.Delete(player2.ID) // unlock
		s.onlinebattle.onMatchDiscard([]document.ID{player2.ID})
		return true, nil
	}
	// 这里 player2 指本 cross 的人员

	s.onlinebattle.battleground.PlaceHolder(id, name, address, pattern, player1, player2)
	s.onlinebattle.roleMatchTimes.Delete(player2.RoleID)
	s.onlinebattle.roleMatchResult.Delete(player2.RoleID)
	s.onlinebattle.rolePrepare.Delete(player2.ID) // unlock

	// push to game, notify role
	s.onlinebattle.notifyToGameNewBattle(&player2.Competitor, &player1.Competitor, address, true)
	return true, nil
}

// 跨cross匹配通知战斗结束
func (s *Service) CrossOnlineFightRemoteBattleNotifyEnd(pattern int, id document.ID, roleID document.ID, competitor1 *proto.Competitor, competitor2 *proto.Competitor, record *scheme.CrossOnlineFightPlayRecord, result *proto.BattleResult) (bool, error) {
	s.onlinebattle.battleground.Remove(id)
	// 处理 player2 结果
	s.onlinebattle.onRemoteBattleOver(pattern, id, roleID, competitor1, competitor2, record, result)
	return true, nil
}

// 查看排行榜
func (s *Service) CrossOnlineFightGetRank(id document.ID, pattern int, offset int, size int) (*Response, error) {
	ranks := s.onlinebattle.GetRankList(pattern, offset, size)
	response := &Response{View: &view{Ranks: ranks}}
	response.Model = s.onlinebattle.SyncModel(id)
	return response, nil
}

// 战斗结束
func (s *Service) CrossOnlineFightBattleOver(result *proto.BattleResult) (bool, error) {
	s.onlinebattle.onForwardBattleOver(result)
	return true, nil
}

// 查看战报
func (s *Service) GetCrossOnlineFightPlayRecord(id document.ID) (*scheme.CrossOnlineFightPlayRecordObject, error) {
	playRecord := s.builder.GetCrossOnlineFightPlayRecord(id)
	if playRecord == nil {
		return nil, nil
	}
	return playRecord.CrossOnlineFightPlayRecordObject, nil
}

// 角色积分增加
func (s *Service) CrossOnlineFightRoleScoreIncrease(id document.ID, score int, pattern int) (int, error) {
	db, unlock := s.onlinebattle.LockAndGetDB()
	defer unlock()
	if role, ok := db.Roles[id]; ok {
		if pattern == Unlimited {
			role.UnlimitedScore += score
			if role.UnlimitedScore < 0 {
				role.UnlimitedScore = 0
			}
			if role.UnlimitedScore > role.UnlimitedTopScore {
				role.UnlimitedTopScore = role.UnlimitedScore
			}
			score = role.UnlimitedScore
		} else {
			role.LimitedScore += score
			if role.LimitedScore < 0 {
				role.LimitedScore = 0
			}
			if role.LimitedScore > role.LimitedTopScore {
				role.LimitedTopScore = role.LimitedScore
			}
			score = role.LimitedScore
		}
		s.onlinebattle.SetRoles(db.Roles)
		s.onlinebattle.refreshRank(pattern)
	} else {
		return 0, errors.New("not in cross online fight")
	}
	return score, nil
}

// 周结算
func (s *Service) CrossOnlineFightWeeklyAward() (bool, error) {
	if s.onlinebattle.isAllOver() {
		return false, ErrRoundClosed
	}
	if !s.onlinebattle.weeklyTimer.Stop() {
		return false, errors.New("timer function already started in its own goroutine")
	}
	s.onlinebattle.weekly()
	return true, nil
}

// 内网开发测试-单人战斗
func (s *Service) CrossOnlineFightUnlimitedBattleStart(id document.ID) (string, error) {
	var role scheme.CrossOnlineFightRole
	db, unlock := s.onlinebattle.RLockAndGetDB()
	util.WithDefer(func() {
		role = db.Roles[id].CrossOnlineFightRole
	}, unlock)

	s.onlinebattle.startUnLimitedBattle(&proto.Competitor{
		CrossOnlineFightRole: role,
	}, &proto.Competitor{
		CrossOnlineFightRole: scheme.CrossOnlineFightRole{
			GameKey: role.GameKey,
			Name:    "robot",
			Logo:    1,
			Level:   58,
			Vip:     1,
			Figure:  1,
		},
		Score: 0,
	}, true)
	return "", nil
}

// 内网开发测试-单人战斗
func (s *Service) CrossOnlineFightLimitedBattleStart(id document.ID, cards []int) (string, error) {
	var role scheme.CrossOnlineFightRole
	db, unlock := s.onlinebattle.RLockAndGetDB()
	util.WithDefer(func() {
		role = db.Roles[id].CrossOnlineFightRole
	}, unlock)

	defenceCards := []int{3, 13, 23, 53, 93, 133, 222, 242, 263, 273, 283, 303, 333, 341, 372, 382, 393, 402, 462, 463, 464, 472, 482, 493, 552, 572, 593, 603, 631, 692, 712, 721, 731, 741, 753, 771, 783, 793, 803, 883, 1071, 1082, 1172, 1221, 1231, 1241, 1253, 1293, 1303, 1313, 1393, 1394, 1423, 1443, 1503, 1612, 1802, 1813, 1841, 1852, 1853, 1863, 1893, 1903, 1911, 1921, 1931, 2013, 2073, 2233, 2242, 2272, 2302, 2401, 2473, 2483, 2593, 2612, 2633, 2683, 2723, 2822, 2843, 2873, 2891, 2963, 2993, 3003, 3012, 3021, 3143, 3152, 3283, 3293, 3303, 3342, 3353, 3413, 3432, 3472, 3502, 3511, 3543, 3592, 3663}
	banpicks := GetConfig().BanPicks[3]

	s.onlinebattle.startLimitedBattle(&proto.Competitor{
		CrossOnlineFightRole: role,
	}, &proto.Competitor{
		CrossOnlineFightRole: scheme.CrossOnlineFightRole{
			GameKey: role.GameKey,
			Name:    "robot",
			Logo:    2,
			Level:   23,
			Vip:     1,
			Figure:  1,
		},
		Score: 0,
	}, cards, defenceCards, banpicks, true)
	return "", nil
}

// 内网开发测试-开启实时对战
func (s *Service) StartCrossOnlineFight(id int, servers []string) (bool, error) {
	if !s.onlinebattle.isAllOver() {
		return false, errors.New("cross online fight already start")
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
		s.onlinebattle.OnInit(id, servers)
	}
	return ret, nil
}

func (s *Service) CrossOnlineFightInvoke(method string) (bool, error) {
	switch method {
	case "onRankTitle":
		s.onlinebattle.onRankTitle()
	case "onWeeklyScoreAward":
		s.onlinebattle.onWeeklyScoreAward()
	case "onFinalAwardRanks":
		s.onlinebattle.onFinalAwardRanks()
	case "notifyToGameCacheFinalRanks":
		s.onlinebattle.notifyToGameCacheFinalRanks()
	case "start":
		s.onlinebattle.SetRound("start")
		s.onlinebattle.eventToGame("start", nil, true, false)
	case "closed":
		s.onlinebattle.closed()
	case "clean":
		s.onlinebattle.clean()
	case "reset":
		s.onlinebattle.reset()
	case "cleanUnlimitedTopBattle":
		s.onlinebattle.SetUnlimitedTopBattleHistory([]scheme.CrossOnlineFightTopBattleHistory{})
	case "cleanLimitedTopBattle":
		s.onlinebattle.SetLimitedTopBattleHistory([]scheme.CrossOnlineFightTopBattleHistory{})
	default:
		return false, nil
	}
	return true, nil
}

func (s *Service) CrossOnlineFightSetTheme(theme int) (bool, error) {
	s.onlinebattle.setTheme(theme)
	return true, nil
}

func (s *Service) ClearRemoteLobby() (bool, error) {
	s.onlinebattle.remotelobby = nil
	return true, nil
}

func (s *Service) SetRemoteLobby() (bool, error) {
	ss := s.Container().GetServices("^crosslobby")
	if len(ss) > 0 {
		s.onlinebattle.remotelobby = ss[0]
		return true, nil
	}
	return false, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}
	s.SetContainer(container)

	s.Register(s, "CrossOnlineFightJoin")
	s.Register(s, "CrossOnlineFightMainGet")
	s.Register(s, "CrossOnlineFightMatchStart")
	s.Register(s, "CrossOnlineFightMatchCancel")
	s.Register(s, "CrossOnlineFightGetRank")
	s.Register(s, "CrossOnlineFightBattleOver")
	s.Register(s, "GetCrossOnlineFightPlayRecord")

	s.Register(s, "CrossOnlineFightRoleScoreIncrease")
	s.Register(s, "CrossOnlineFightWeeklyAward")
	s.Register(s, "CrossOnlineFightUnlimitedBattleStart")
	s.Register(s, "CrossOnlineFightLimitedBattleStart")
	s.Register(s, "StartCrossOnlineFight")
	s.Register(s, "CrossOnlineFightInvoke")
	s.Register(s, "CrossOnlineFightSetTheme")

	s.Register(s, "CrossOnlineFightRemoteLobbyMatched")
	s.Register(s, "CrossOnlineFightRemoteLobbyMatchedNotify")
	s.Register(s, "CrossOnlineFightRemoteLobbyMatchDiscard")
	s.Register(s, "CrossOnlineFightRemoteBattleNotifyStart")
	s.Register(s, "CrossOnlineFightRemoteBattleNotifyEnd")
	s.Register(s, "CrossOnlineFightRemoteBattleNotifyPrepareStart")

	s.Register(s, "ClearRemoteLobby")
	s.Register(s, "SetRemoteLobby")

	return s
}

func GetRemoteCrossOnlineFightRecord(s service.IService, id document.ID) *scheme.CrossOnlineFightRecord {
	resp, err := service.Call(s, "GetCrossOnlineFightRecord", id)
	if err != nil {
		panic(err)
	}
	record := resp.(*scheme.CrossOnlineFightRecordObject)
	db, unlock := record.RLockAndGetDB()
	defer unlock()
	return db
}

package mine

import (
	"errors"
	"fmt"
	"github.com/fsnotify/fsnotify"
	"io/ioutil"
	"math"
	"math/rand"
	"sort"
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
	anti_cheat "tjgame/services/anti-cheat"
	"tjgame/services/cross"
	"tjgame/ta"
)

const Name = "crossmine"

type Service struct {
	*service.Service
	cross.Skeleton
	builder    *Builder
	mine       *Mine
	agent      service.IService
	leastPatch uint32
}

func (s *Service) Init() bool {
	if ok := s.Service.Init(); !ok {
		return false
	}
	_ = LoadConfig()
	language := tj.Language()
	if language == "en" {
		startTime = startTimeEN
		overTime = overTimeEN
	}
	return true
}

func (s *Service) Start() bool {
	opt := s.Option.Base()
	var ss service.IService
	for _, name := range opt.Dependent {
		if name == "anticheat" {
			s.agent = s.Container().GetService("anticheat")
		} else {
			ns, _, _ := service.SplitServiceName(name)
			if ns == "crossdb" {
				ss = s.Container().GetService(name)
			}
		}
	}
	s.builder = NewBuilder(ss)

	key := opt.Name
	s.mine = s.builder.NewMine(key)
	if s.mine == nil {
		return false
	}
	s.mine.container = s.Container()
	s.mine.init(s.builder, s.Name(), s.Container().GetService("anticheat"))
	log.Infof("load %s cross mine round %s", key, s.mine.Round())

	s.Skeleton.Init(s.Name(), Name, s.mine)

	if s.mine.isAllOver() {
		// 已结束
		log.Infof("CrossMine is AllOver True")
		s.mine.clean()
	} else {
		s.MustContainServices(s.mine.Servers(), "pvp")
		// 中途重启
		go s.mine.ResetToday()
	}

	go s.StartServiceCheck()

	s.mine.track = ta.NewBattleCardTrack(s.Name(), "cross_mine")
	s.mine.track.Start()

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
	if s.mine.track != nil {
		s.mine.track.Stop()
	}
}

// 跨服竞技场加入服务 server_key
func (s *Service) CrossMineJoin(key string) (*DBForGame, error) {
	_, unlock := s.mine.RLockAndGetDB()
	defer unlock()
	if !s.mine.isServerOK(key) {
		return nil, nil
	}
	return s.mine.dbForGame(), nil
}

// 主界面model
func (s *Service) CrossMineGetModel(roleID document.ID, roleInfo *scheme.CrossMineRoleInfo, refresh bool) (resp RespGetCrossMineModel, err error) {
	db, unlock := s.mine.LockAndGetDB()
	defer unlock()

	if db.Round == "closed" {
		err = ErrRoundClosed
		return
	}

	roles := db.Roles
	// 不存在则添加
	if _, ok := roles[roleInfo.RoleID]; !ok {
		rankMax := db.RankMax + 1
		s.mine.SetRankMax(rankMax)

		roleInfo.Rank = int(rankMax)
		roleInfo.TopRank = int(rankMax)
		roleInfo.Speed = s.mine.calcSpeed(roleInfo.GameKey, roleInfo.Rank)
		roles[roleInfo.RoleID] = roleInfo

		db.Ranks[document.Integer(rankMax)] = [2]document.ID{roleInfo.RoleID, roleInfo.RecordID}
		s.mine.SetRanks(db.Ranks)

		s.mine.roleRanks[roleInfo.RoleID] = document.Integer(rankMax)
		s.mine.SetRoles(roles)
		resp.IsNew = true

	} else {
		roles[roleInfo.RoleID].CrossMineRole = roleInfo.CrossMineRole
		roles[roleInfo.RoleID].FightingPoint = roleInfo.FightingPoint
		s.mine.SetRoles(roles)
		resp.IsNew = false
	}

	resp.Role = *roles[roleID]
	resp.Enemies = s.mine.getBattleEnemies(roleID, refresh)
	resp.Top10 = s.mine.getRanks(0, 10)
	resp.ServerPoints = s.mine.getServerPoints()
	resp.TopBattleHistory = db.LastTopBattleHistory
	resp.Boss = s.mine.getBoss(roleInfo.RoleID)
	resp.KillBoss = s.mine.getKillBoss(roleInfo.GameKey)
	resp.Npc = s.mine.getNpc()
	resp.ServerBuffInfo = *s.mine.getServerBuffInfo(roleInfo.GameKey, false)
	resp.RoleBuffInfo = *s.mine.getRoleBuffInfo(roleID, false)

	return
}

// 跨服资源战战斗开始
func (s *Service) CrossMineBattleStart(flag string, rank, enemyRank int, roleID, enemyRoleID, recordID, enemyRecordID document.ID, patch uint32) (*scheme.CrossMinePlayRecordObject, error) {
	// if patch > 1 && patch < atomic.LoadUint32(&s.leastPatch) {
	// 	return nil, ErrPatchBehind
	// }

	// 判断round
	isRoundStart := false
	var gameKey1, gameKey2 string
	var serverBuffLevel1, serverBuffLevel2, roleBuffLevel1, roleBuffLevel2 int
	var bossBuffAdd1, bossBuffAdd2 float64
	tjutil.WithGuard(s.mine, func() {
		if s.mine.Round() == "start" {
			isRoundStart = true
			gameKey1 = s.mine.Roles()[roleID].GameKey
			gameKey2 = s.mine.Roles()[enemyRoleID].GameKey
			serverBuffLevel1 = s.mine.getServerBuffLevel(gameKey1)
			serverBuffLevel2 = s.mine.getServerBuffLevel(gameKey2)
			roleBuffLevel1 = s.mine.getRoleBuffLevel(roleID)
			roleBuffLevel2 = s.mine.getRoleBuffLevel(enemyRoleID)
			bossBuffAdd1 = s.mine.getBossBuffAdd(gameKey1, BossBuffTypeAttr)
			bossBuffAdd2 = s.mine.getBossBuffAdd(gameKey2, BossBuffTypeAttr)
		}
	})
	if !isRoundStart {
		return nil, ErrRoundClosed
	}

	switch flag {
	case CrossMineBattleFlagRob:
		// 自己排名发生变化
		nowRank, err := s.mine.getRoleRank(roleID)
		if err != nil {
			return nil, err
		}
		if nowRank != rank {
			return nil, ErrRankChanged
		}

		var BeRobedTimes []float64
		tjutil.WithGuard(s.mine, func() {
			beRodedInfo, ok := s.mine.RoleBeRoded()[enemyRoleID]
			if ok {
				BeRobedTimes = beRodedInfo.Time
			}
		})

		if !s.mine.isDisableProtect() && len(BeRobedTimes) > 0 && tjutil.NowTime()-float64(BeRobedTimes[len(BeRobedTimes)-1]) < 60*5 {
			return nil, ErrEnemyInRobProtect
		}

	case CrossMineBattleFlagRevenge:
		var beReveragedNum int
		var beReveragedTimes []float64
		tjutil.WithGuard(s.mine, func() {
			if beReveragedInfos, ok := s.mine.RoleBeRevenged()[enemyRoleID]; ok {
				beReveragedInfo := beReveragedInfos[roleID]
				if beReveragedInfo != nil {
					beReveragedNum = beReveragedInfo.Count
					beReveragedTimes = beReveragedInfo.Time
				}
			}
		})
		//if beReveragedNum >= GetConfig().BeRevengedByCommonRoleLimit {
		//	return nil, ErrBeRevengedLimit
		//}
		if len(beReveragedTimes) > 0 && tjutil.NowTime()-float64(beReveragedTimes[len(beReveragedTimes)-1]) < 60*5 {
			return nil, ErrEnemyInRevengeProtect
		}
	default:
		return nil, ErrParamFlag

	}
	// 记录对战信息
	err := s.mine.storeVsForRole(flag, enemyRank, roleID, enemyRoleID, recordID, enemyRecordID)
	if err != nil {
		return nil, err
	}

	record := GetRemoteMineRecord(s.Container().GetService(service.Game2PVPService(gameKey1)), recordID, GetRemoteMineRecordTimeout)
	enemyRecord := GetRemoteMineRecord(s.Container().GetService(service.Game2PVPService(gameKey2)), enemyRecordID, GetRemoteMineRecordTimeout)

	roleKey := scheme.RoleKey{ID: roleID, GameKey: gameKey1}
	enemyRoleKey := scheme.RoleKey{ID: enemyRoleID, GameKey: gameKey2}
	playModel := NewPlayModel(roleKey, enemyRoleKey, record, enemyRecord)
	playRecord := s.builder.CreateCrossMinePlayRecord(playModel)
	playRecord.cardAttrFix(serverBuffLevel1, roleBuffLevel1, bossBuffAdd1)
	playRecord.defenceCardAttrFix(serverBuffLevel2, roleBuffLevel2, bossBuffAdd2)

	// 存本场战斗
	playRecordID := playRecord.GetID()
	s.mine.battles.Store(roleID, &battle{
		Flag:          flag,
		playRecordID:  playRecordID,
		enemyRoleID:   enemyRoleID,
		enemyRecordID: enemyRecordID,
		enemyRank:     enemyRank,
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
			future := service.CallAsync(s.agent, "NewCrossMineBattle", s.Name(), playRecordID, data)
			go func() {
				ret, err := future.Get()
				if err != nil {
					log.Warningf("cross mine role %v play %v result error %v", roleID, playRecordID, err)
					return
				}
				result := ret.(string)
				if result == "win" || result == "fail" {
					if b, ok := s.mine.battles.Load(roleID); ok {
						bb := b.(*battle)
						tjutil.WithGuard(&bb.mu, func() {
							log.Infof("cross mine role %v play %v anti result %v", roleID, playRecordID, result)
							if bb.result == "" {
								bb.result = result
							} else if bb.result != result {
								log.Infof("cross mine role %v play %v anti %v result %v is diff beffer anti", roleID, playRecordID, result, bb.result)
							}
						})
					}
				} else {
					log.Warningf("cross mine role %v play %v result %s", roleID, playRecordID, result)
				}
			}()
		}()
	}

	return playRecord.CrossMinePlayRecordObject, nil
}

// 跨服资源战战斗结束
func (s *Service) CrossMineBattleEnd(roleID, recordID document.ID, result string, stats map[document.Integer]string, isTopBattle bool) (*RespCrossMineBattleEnd, error) {
	// 判断round
	isRoundStart := false
	tjutil.WithGuard(s.mine, func() {
		if s.mine.Round() == "start" {
			isRoundStart = true
		}
	})
	if !isRoundStart {
		return nil, ErrRoundClosed
	}

	var bb *battle
	if b, ok := s.mine.battles.Load(roleID); ok {
		bb = b.(*battle)
		s.mine.battles.Delete(roleID)
	} else {
		return nil, ErrBattleNotFind
	}

	return s.mine.battleEndUpdate(bb, roleID, recordID, result, stats, isTopBattle)
}

// boss 挑战开始
func (s *Service) CrossMineBossStart(roleID, bossID document.ID, battleCardInfo BossBattleCardInfo) (model CrossMineBossBattleModel, err error) {
	db, unlcok := s.mine.LockAndGetDB()
	defer unlcok()

	bossInfo, ok := db.Boss[bossID]
	if !ok {
		err = ErrBossNotFind
		return
	}
	if s.mine.bossIsDied(bossInfo) {
		err = ErrBossHasKilled
		return
	}

	// 该 Boss 是否开放
	if !inValidTime(bossInfo.OpenTime, csv.GetConfig().Cross.Mine.Boss[bossInfo.CsvID].Duration) {
		err = ErrBossNotOpen
		return
	}

	hp := make(map[document.Integer]int)
	for k, v := range bossInfo.HP {
		hp[k] = v - bossInfo.Damage[k]
	}

	model = CrossMineBossBattleModel{
		ID:            document.NewID(),
		GateID:        csv.GetConfig().Cross.Mine.Boss[bossInfo.CsvID].GateID,
		RandSeed:      rand.Int31n(99999999) + 1,
		Cards:         battleCardInfo.Cards,
		CardAttrs:     battleCardInfo.CardAttrs,
		CardAttrs2:    battleCardInfo.CardAttrs2,
		PassiveSkills: battleCardInfo.PassiveSkills,
		Level:         db.Roles[roleID].Level,
		HP:            hp,
		HPMax:         bossInfo.HP,
	}

	maxDamage := 0
	for _, attr := range battleCardInfo.CardAttrs {
		maxDamage += attr.FightingPoint
	}
	maxDamage *= GetConfig().BossMaxDamageMultiple

	s.mine.bossBattles.Store(roleID, &bossBattle{
		battleID:    model.ID,
		bossID:      bossID,
		MaxDamage:   maxDamage,
		model:       &model,
		startTime:   tjutil.NowTime(),
		agentFinish: make(chan int),
	})

	return
}

// boss 挑战结束
func (s *Service) CrossMineBossEnd(roleID, battleID document.ID, damages map[document.Integer]int, actions map[document.Integer][]scheme.BattleAction) (*RespCrossMineBossBattleeEnd, error) {
	var round string
	tjutil.WithGuard(s.mine, func() {
		round = s.mine.Round()
	})
	if round == "closed" {
		return nil, ErrRoundClosed
	}

	var bb *bossBattle
	if b, ok := s.mine.bossBattles.Load(roleID); ok {
		bb = b.(*bossBattle)
		s.mine.bossBattles.Delete(roleID)
	} else {
		return nil, ErrBossBattleNotFind
	}

	resp, err := s.mine.bossBattleUpdate(bb, roleID, damages, actions)
	if err != nil {
		return nil, err
	}

	if resp.IsKill {
		go s.mine.onBossRankAwardSend(resp.BossID)
	}

	return resp, nil
}

// 跨服资源战战报
func (s *Service) CrossMineGetPlayRecord(id document.ID) (*scheme.CrossMinePlayRecordObject, error) {
	playRecord := s.builder.GetCrossMinePlayRecord(id)
	if playRecord == nil {
		return nil, nil
	}
	return playRecord.CrossMinePlayRecordObject, nil
}

// 跨服资源战buff喂养
func (s *Service) CrossMineBuffFeed(flag string, csvID int, roleID document.ID, gameKey string) (bool, error) {
	err := s.mine.feedBuff(flag, csvID, roleID, gameKey)
	if err != nil {
		return false, err
	}
	return true, nil
}

// 实时排行榜
func (s *Service) CrossMineGetRanks(flag string, offset int, size int, roleID document.ID) (*RespGetCrossMineRanks, error) {
	db, unlock := s.mine.RLockAndGetDB()
	defer unlock()

	if db.Round == "closed" {
		return nil, ErrRoundClosed
	}

	resp := &RespGetCrossMineRanks{}
	switch flag {
	case "role":
		resp.Ranks = s.mine.getRanks(offset, size)
	case "feed":
		resp.Ranks = s.mine.getServerBuffFeedRanks(offset, size)
	default:
		return nil, ErrReqRanksFlag
	}

	if _, ok := db.Roles[roleID]; ok {
		resp.MyInfo = *db.Roles[roleID]
	}
	return resp, nil
}

// 更新基础 coin13
func (s *Service) CrossMineUpdateOriginCoin13(roleID document.ID, coin13 int) (int, error) {
	db, unlock := s.mine.LockAndGetDB()
	defer unlock()
	roleInfo, ok := db.Roles[roleID]
	if !ok {
		return 0, nil
	}
	retCoin13Diff := int(math.Floor(roleInfo.Coin13Diff))
	originCoin13 := roleInfo.Coin13Origin
	roleInfo.Coin13Origin = coin13 + retCoin13Diff
	if roleInfo.Coin13Origin < 0 {
		log.Warningf("role %v originCoin13 old %v diff %v new originCoin13 %v", roleID, originCoin13, retCoin13Diff, coin13)
		roleInfo.Coin13Origin = 0
	}
	roleInfo.Coin13Diff -= float64(retCoin13Diff)
	s.mine.SetRoles(db.Roles)
	return retCoin13Diff, nil
}

// 更新角色信息
func (s *Service) CrossMineUpdateRoleInfo(roleInfo *scheme.CrossMineRole, fp int) (bool, error) {
	db, unlock := s.mine.LockAndGetDB()
	defer unlock()

	if db.Round == "closed" {
		return false, nil
	}

	if role, ok := db.Roles[roleInfo.RoleID]; ok {
		role.CrossMineRole = *roleInfo
		role.FightingPoint = fp
		s.mine.SetRoles(db.Roles)
	}

	return true, nil
}

func (s *Service) CrossMineGetBossRanks(roleID, bossID document.ID, offset, size int) (*RespGetCrossMineBossRanks, error) {
	db, unlock := s.mine.RLockAndGetDB()
	defer unlock()

	if db.Round == "closed" {
		return nil, ErrRoundClosed
	}

	return s.mine.getBossRanksWithMe(roleID, bossID, offset, size)
}

func (s *Service) CrossMineGetEnemyInfo(flag string, roleID, enemyRoleID document.ID) (RespCrossMineGetRoleInfo, error) {
	db, unlock := s.mine.LockAndGetDB()
	defer unlock()
	ret := RespCrossMineGetRoleInfo{}

	role, ok1 := db.Roles[roleID]
	enemy, ok2 := db.Roles[enemyRoleID]
	if !ok1 || !ok2 {
		return ret, ErrRoleNotFind
	}

	buffAdd := s.mine.getBossBuffAdd(enemy.GameKey, BossBuffTypeProduct)
	rankCsvIDs := GetConfig().ProductCfgIDSortMap[csv.GetConfig().Cross.Service[db.CsvId].Version]
	idx := sort.Search(len(rankCsvIDs), func(i int) bool {
		return rankCsvIDs[i][1] >= enemy.Rank
	})

	ret.Rank = enemy.Rank
	ret.Speed = math.Floor(csv.GetConfig().Cross.Mine.Rank[rankCsvIDs[idx][0]].MinuteCoin13 * (1 + buffAdd) * 60)
	ret.Coin13Origin = enemy.Coin13Origin
	ret.Coin13Diff = math.Floor(enemy.Coin13Diff)
	ret.RoleBeRoded = db.RoleBeRoded[enemyRoleID]
	ret.RoleBeRevenged = db.RoleBeRevenged[enemyRoleID]
	ret.CanRobNum = s.mine.calcRobNum(flag, role, enemy)
	ret.KillBoss = s.mine.getKillBoss(enemy.GameKey)

	return ret, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}
	s.SetContainer(container)

	s.Register(s, "CrossMineJoin")
	s.Register(s, "CrossMineGetModel")
	s.Register(s, "CrossMineBattleStart")
	s.Register(s, "CrossMineBattleEnd")
	s.Register(s, "CrossMineBossStart")
	s.Register(s, "CrossMineBossEnd")
	s.Register(s, "CrossMineGetPlayRecord")
	s.Register(s, "CrossMineBuffFeed")
	s.Register(s, "CrossMineGetRanks")
	s.Register(s, "CrossMineUpdateOriginCoin13")
	s.Register(s, "CrossMineUpdateRoleInfo")
	s.Register(s, "CrossMineGetBossRanks")
	s.Register(s, "CrossMineGetEnemyInfo")

	s.Register(s, "CrossMineTestInitEvent")
	s.Register(s, "CrossMineTestAward")
	s.Register(s, "CrossMineTestAddKillBoss")
	s.Register(s, "CrossMineClearBuffInfo")
	s.Register(s, "CrossMineBossRank")
	s.Register(s, "CrossMineTestCoin13Diff")
	s.Register(s, "CrossMineTestStart")
	s.Register(s, "CrossMineTestClose")
	s.Register(s, "CrossMineTestAgent")
	s.Register(s, "CrossMineTestCreateBoss")
	s.Register(s, "CrossMineTestCreateNpc")
	s.Register(s, "CrossMineTestPrepare")

	return s
}

// 获取跨服资源战 record
func GetRemoteMineRecord(s service.IService, mineRecordID document.ID, timeout time.Duration) *scheme.CrossMineRecord {
	resp, err := service.Call(s, "GetCrossMineRecord", mineRecordID)
	if err != nil {
		panic(err)
	}
	record := resp.(*scheme.CrossMineRecordObject)
	db, unlock := record.RLockAndGetDB()
	defer unlock()
	return db
}

func (s *Service) CrossMineTestInitEvent() (bool, error) {
	db, unlock := s.mine.LockAndGetDB()
	defer unlock()
	db.EventRecrod = make(map[document.Integer]bool)
	db.Boss = make(map[document.ID]*scheme.CrossMineBoss)
	db.Npc = make(map[document.ID]*scheme.CrossMineNpc)
	s.mine.initEvent()
	return true, nil
}

func (s *Service) CrossMineTestAward() (bool, error) {
	bossIDs := []document.ID{}
	tjutil.WithGuard(s.mine, func() {
		for k := range s.mine.Boss() {
			//if v.AwardDate != 0 {
			//	continue
			//}
			bossIDs = append(bossIDs, k)
		}
	})
	s.mine.eventToSomeGame("dayRankAward", s.mine.onRoleRankAward(), true)

	for _, bossID := range bossIDs {
		s.mine.onBossRankAwardSend(bossID)
	}

	s.mine.eventToSomeGame("allRankAward", s.mine.onAllRankAward(), false)

	return true, nil
}

func (s *Service) CrossMineTestAddKillBoss(gameKey string) (bool, error) {
	db, unlock := s.mine.LockAndGetDB()
	defer unlock()
	db.ServerKillBoss = make(map[string]map[document.ID]*scheme.CrossMineServerKillBoss)
	gameKey = getMergeServKey(gameKey)

	for k, v := range db.Boss {
		if _, ok := db.ServerKillBoss[gameKey]; !ok {
			db.ServerKillBoss[gameKey] = make(map[document.ID]*scheme.CrossMineServerKillBoss)
		}
		db.ServerKillBoss[gameKey][k] = &scheme.CrossMineServerKillBoss{
			CsvID: v.CsvID,
			Time:  tjutil.NowTime(),
		}
	}
	s.mine.SetServerKillBoss(db.ServerKillBoss)
	return true, nil
}

func (s *Service) CrossMineClearBuffInfo() (bool, error) {
	db, unlock := s.mine.LockAndGetDB()
	defer unlock()
	db.ServerBuffInfo = make(map[string]*scheme.CrossMineServerBuffInfo)
	db.RoleBuffInfo = make(map[document.ID]*scheme.CrossMineRoleBuffInfo)
	s.mine.SetServerBuffInfo(db.ServerBuffInfo)
	s.mine.SetRoleBuffInfo(db.RoleBuffInfo)
	return true, nil
}

func (s *Service) CrossMineBossRank(roleID document.ID) (*RespGetCrossMineBossRanks, error) {
	db, unlock := s.mine.RLockAndGetDB()
	defer unlock()

	resp := &RespGetCrossMineBossRanks{
		Ranks: nil,
		MyInfo: CrossMineBossRankRoleItem{
			CrossMineRole: db.Roles[roleID].CrossMineRole,
			Rank:          1,
			Damage:        100,
		},
	}

	return resp, nil
}

func (s *Service) CrossMineTestCoin13Diff(roleID document.ID, setNum float64) (bool, error) {
	db, unlock := s.mine.LockAndGetDB()
	defer unlock()

	db.Roles[roleID].Coin13Diff = setNum
	s.mine.SetRoles(db.Roles)
	log.Info("CrossMineTestCoin13Diff role coin13 diff", db.Roles[roleID].Coin13Diff)

	return true, nil
}

// 测试 开始
func (s *Service) CrossMineTestStart(id int, servers []string, quick bool) (bool, error) {
	round := s.mine.Round()
	if round != "closed" {
		return false, errors.New("cross mine already start")
	}
	// 检查 container 里面是否都有对应的services, 动态添加
	if err := s.AddServicesDynamic(servers, "pvp"); err != nil {
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
		//TestInQuick = quick
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
		s.mine.OnInit(id, servers)
	}
	return true, nil
}

// 测试 结束
func (s *Service) CrossMineTestClose() (bool, error) {
	s.mine.onClosed()
	return true, nil
}

func (s *Service) CrossMineTestAgent(data []byte) (bool, error) {
	var play CrossMineBossBattleModel
	tjutil.MsgUnpack(data, &play)
	resp, err := service.CallWithTimeout(s.mine.agent, "NewCrossMineBossBattle", BossBattleVerifyTimeout, s.Name(), play.ID, data)
	if err != nil {
		log.Warningf("CrossMine boss battle %v verify call err %v", play.ID, err)
	}
	log.Info("CrossMineTestAgent resp", resp.(anti_cheat.CrossMineBossResult))
	return true, nil
}

func (s *Service) CrossMineTestCreateBoss(csvID int, day int) (bool, error) {
	db, unlock := s.mine.LockAndGetDB()
	defer unlock()

	db.Boss = make(map[document.ID]*scheme.CrossMineBoss)
	bossInfo := s.mine.createBoss(csvID, tjutil.NowTime(), day)
	db.Boss[bossInfo.ID] = bossInfo
	s.mine.SetBoss(db.Boss)
	s.mine.updateBossRanks(bossInfo)

	return true, nil
}

func (s *Service) CrossMineTestCreateNpc(csvID int) (bool, error) {
	db, unlock := s.mine.LockAndGetDB()
	defer unlock()

	db.Npc = make(map[document.ID]*scheme.CrossMineNpc)
	npcInfo := s.mine.createNpc(csvID, tjutil.NowTime())
	db.Npc[npcInfo.ID] = npcInfo
	s.mine.SetNpc(db.Npc)

	return true, nil
}

func (s *Service) CrossMineTestPrepare() (bool, error) {
	resp := s.mine.eventToGame("prepare", EventToGame{}, true, false)
	for gameKey, info := range resp {
		log.Info("CrossMine CrossMineTestPrepare", gameKey, info.ServerOpenDays)
	}
	minServerOpenDays := 0
	for _, info := range resp {
		if minServerOpenDays == 0 || info.ServerOpenDays < minServerOpenDays {
			minServerOpenDays = info.ServerOpenDays
		}
	}
	log.Info("CrossMine CrossMineTestPrepare minServerOpenDays", minServerOpenDays)
	s.mine.SetServerOpenDays(minServerOpenDays)
	return true, nil
}

package yyhuodong

import (
	"errors"
	"fmt"
	"io/ioutil"
	"strings"
	"sync/atomic"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/mgo.v2/bson"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	tjcards "tjgame/services/game/cards"
	"tjgame/services/storage"
)

const Name = "yyhuodong"

type Service struct {
	*service.Service
	builder *Builder
	cache   *util.LRUCache // brave_challenge_record

	worldBoss            *WorldBossGlobal // 世界Boss
	braveChallenge       *BraveChallenge  // 勇者挑战
	normalBraveChallenge *BraveChallenge  // 普通勇者挑战
	summerChallenge      *SummerChallenge // 夏日挑战
}

func (s *Service) Init() bool {
	if ok := s.Service.Init(); !ok {
		return false
	}
	_ = LoadConfig()
	_ = tjcards.InitBattleCardHaloConfig()
	if s.braveChallenge != nil && s.braveChallenge.yyID > 0 {
		_ = LoadBraveChallengeConfig(s.braveChallenge)
	}
	if s.normalBraveChallenge != nil {
		_ = LoadBraveChallengeConfig(s.normalBraveChallenge)
	}

	return true
}

func (s *Service) Start() bool {
	opt := s.Option.Base()
	ss := s.Container().GetService(storage.GetNameFromDependent(opt.Dependent))
	s.cache = util.NewLRUCache(5000, nil)
	s.builder = NewBuilder(ss)
	gameKey := strings.Replace(opt.Name, Name, "game", 1)

	// load worldBoss global
	s.worldBoss = s.builder.NewWorldBossGlobal(gameKey)
	if s.worldBoss == nil {
		return false
	}
	s.worldBoss.init()
	log.Infof("load %s worldBoss global", gameKey)

	s.braveChallenge = &BraveChallenge{game: s.Container().GetService(gameKey), playType: AnniversaryBraveChallenge}
	go s.braveChallenge.init(s, s.Container().GetService("anticheat"))

	s.normalBraveChallenge = &BraveChallenge{game: s.Container().GetService(gameKey), playType: NormalBraveChallenge}
	go s.normalBraveChallenge.init(s, s.Container().GetService("anticheat"))

	// log.Infof("[chanlong] service start | summerChallenge gameKey: %s",gameKey)

	s.summerChallenge = &SummerChallenge{game: s.Container().GetService(gameKey)}

	// testGame := s.Container().GetService(gameKey)

	// if testGame == nil {
	// 	log.Infof("[chanlong] service start | summerChallenge game service is nil/ gameKey: %s",gameKey)
	// }
	
	// testAnti := s.Container().GetService("anticheat")

	// if testAnti == nil {
	// 	log.Infof("[chanlong] service start | summerChallenge anticheat service is nil/ gameKey: %s",gameKey)
	// }

	go s.summerChallenge.init(s, s.Container().GetService("anticheat"))
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
	// 世界boss
	_ = LoadConfig()
	// 周年庆副本
	if s.braveChallenge != nil && s.braveChallenge.yyID > 0 {
		_ = LoadBraveChallengeConfig(s.braveChallenge)
	}
	if s.normalBraveChallenge != nil {
		_ = LoadBraveChallengeConfig(s.normalBraveChallenge)
	}
	out1 := fmt.Sprintf("Reload Over. %p -> %p\n", old, GetConfig())
	out1 += fmt.Sprintf("Cost %v\n", time.Now().Sub(st))
	log.Info(out1)
	out += out1

	return out, nil
}

// 世界 Boss 主入口
func (s *Service) WorldBossMain() (RespWorldBossMain, error) {
	s.worldBoss.RLock()
	defer s.worldBoss.RUnlock()
	return s.worldBoss.main(), nil
}

// 世界 Boss 伤害更新
func (s *Service) WorldBossDamageUpdate(input ReqWorldBoss) (int, error) {
	if input.Role == nil {
		return 0, errors.New("role error")
	}
	if input.Role.BossDamage < 0 {
		return 0, errors.New("damage error")
	}

	_, unlock := s.worldBoss.LockAndGetDB()
	defer unlock()
	damageSum := s.worldBoss.updateRoleDamage(input.Role)
	if input.Union != nil {
		s.worldBoss.updateUnionDamage(input.Union, input.Role.Role.ID, input.Role.BossDamage)
		s.worldBoss.resortUnionRank()
	}
	return damageSum, nil
}

// 世界 Boss 排名信息
func (s *Service) WorldBossRankInfo(roleID, unionID document.ID) (RespWorldBossRankInfo, error) {
	s.worldBoss.RLock()
	defer s.worldBoss.RUnlock()
	return s.worldBoss.getRankInfo(roleID, unionID), nil
}

// 世界 Boss 公会解散
func (s *Service) WorldBossUnionDissolve(unionID document.ID) (bool, error) {
	_, unlock := s.worldBoss.LockAndGetDB()
	defer unlock()
	s.worldBoss.unionDissolve(unionID)
	s.worldBoss.resortUnionRank()
	return true, nil
}

// 世界 Boss 当日结束
func (s *Service) WorldBossDayEnd(yyID, huodongID int) (RespWorldBossDayEnd, error) {
	_, unlock := s.worldBoss.LockAndGetDB()
	defer unlock()
	ret, err := s.worldBoss.rankEnd(huodongID)
	if err != nil {
		return ret, err
	}
	s.worldBoss.updateLevel(ret.FinishGoal)
	s.worldBoss.recordLastEnd(yyID)
	s.worldBoss.clear()
	return ret, nil
}

func (s *Service) getBraveChallenge(yyID int) *BraveChallenge {
	if yyID == 0 {
		return s.normalBraveChallenge
	} else {
		return s.braveChallenge
	}
}

func (s *Service) BraveChallengeYYStart(yyID int) (bool, error) {
	braveChallenge := s.getBraveChallenge(yyID)
	if yyID > 0 && braveChallenge.yyID == yyID {
		return true, nil
	}
	err := braveChallenge.init(s, s.Container().GetService("anticheat"))
	if err != nil {
		return false, nil
	}
	return true, nil
}

// 勇者挑战 刷新数据
func (s *Service) BraveChallengeYYRefresh(yyID int) (bool, error) {
	braveChallenge := s.getBraveChallenge(yyID)
	if braveChallenge != nil {
		_ = LoadBraveChallengeConfig(braveChallenge)
	}
	braveChallenge.reset()
	err := braveChallenge.init(nil, nil)
	if err != nil {
		return false, nil
	}
	braveChallenge = s.getBraveChallenge(0)
	err = braveChallenge.init(nil, nil)
	if err != nil {
		return false, nil
	}
	return true, nil
}

// 勇者挑战 创建Record
func (s *Service) BraveChallengeCreateRecord(roleID document.ID, yyID int) (*scheme.BraveChallengeRecordObject, error) {
	record := document.New("BraveChallengeRecord", true).(*scheme.BraveChallengeRecord)
	record.RoleDbId = roleID
	record.YYId = yyID
	record.Badges = map[document.Integer][]int{GlobalBadgeType: {}, LocalBadgeType: {}}
	record.Game = &scheme.GameInfo{}
	record.Rank = &scheme.RankInfo{}

	// create BraveChallengeRecord in storage
	resp, err := service.Call(s.builder.storage, "DBCreate", record.CollectionName(), record)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	r := s.builder.NewBraveChallengeRecord(&response)
	return r.BraveChallengeRecordObject, nil
}

func (s *Service) getRecord(id document.ID, yyID int, refresh bool, lastOpenDate int) *BraveChallengeRecord {
	record := &BraveChallengeRecord{}
	if v, ok := s.cache.Get(id); ok {
		record = v.(*BraveChallengeRecord)
	} else {
		resp, err := service.Call(s.builder.storage, "DBRead", "BraveChallengeRecord", id, false)
		if err != nil {
			panic(err)
		}
		response := resp.(storage.Response)
		record = s.builder.NewBraveChallengeRecord(&response)
	}
	if yyID == NormalBraveChallenge {
		if lastOpenDate != record.LastOpenDate() {
			record.reset(yyID, lastOpenDate)
		} else if refresh {
			record.refresh()
		}
	} else {
		if yyID != record.YYId() {
			record.reset(yyID, 0)
		} else if refresh {
			record.refresh()
		}
	}
	s.cache.Set(id, record)
	return record
}

// 勇者挑战 获取记录
func (s *Service) BraveChallengeGetRecord(recordID document.ID, roleID document.ID, yyID int, lastOpenDate int) (*scheme.BraveChallengeRecordObject, error) {
	record := s.getRecord(recordID, yyID, true, lastOpenDate)
	if record.RoleDbId() != roleID {
		err := fmt.Errorf("record %v role error, expect %v, got %v", recordID, roleID, record.RoleDbId())
		return nil, err
	}
	return record.BraveChallengeRecordObject, nil
}

// 勇者挑战 开始战斗
func (s *Service) BraveChallengeStartBattle(recordID document.ID, roleID document.ID, yyID, floorID, monsterID int, extraAttrBonus map[int]map[string][2]float64, lastOpenDate int) (BraveChallengeBattleModel, error) {
	braveChallenge := s.getBraveChallenge(yyID)
	for i := 0; atomic.LoadInt32(&braveChallenge.complete) == 0 && i < 10; i++ {
		time.Sleep(time.Second)
	}
	if atomic.LoadInt32(&braveChallenge.complete) == 0 {
		return BraveChallengeBattleModel{}, errors.New("please wait a moment")
	}
	err := braveChallenge.isBanned(roleID)
	if err != nil {
		return BraveChallengeBattleModel{}, err
	}
	record := s.getRecord(recordID, yyID, true, lastOpenDate)
	if record.RoleDbId() != roleID {
		err := fmt.Errorf("record %v role error, expect %v, got %v", recordID, roleID, record.RoleDbId())
		return BraveChallengeBattleModel{}, err
	}
	return record.StartBattle(floorID, monsterID, braveChallenge, extraAttrBonus)
}

// 勇者挑战 结束战斗
func (s *Service) BraveChallengeEndBattle(recordID document.ID, roleID document.ID, yyID int, data ReqBattleEnd, lastOpenDate int) (RespBattleEnd, error) {
	braveChallenge := s.getBraveChallenge(yyID)
	for i := 0; atomic.LoadInt32(&braveChallenge.complete) == 0 && i < 10; i++ {
		time.Sleep(time.Second)
	}
	if atomic.LoadInt32(&braveChallenge.complete) == 0 {
		return RespBattleEnd{}, errors.New("please wait a moment")
	}
	record := s.getRecord(recordID, yyID, false, lastOpenDate) // 延迟刷新, 存在战斗跨天的问题
	if record.RoleDbId() != roleID {
		err := fmt.Errorf("record %v role error, expect %v, got %v", recordID, roleID, record.RoleDbId())
		return RespBattleEnd{}, err
	}
	resp, err := record.EndBattle(data, braveChallenge)
	resp.Record = record
	return resp, err
}

// 勇者挑战 随机徽章
func (s *Service) BraveChallengeRandomBadge(recordID document.ID, roleID document.ID, yyID, weight, floor, lastOpenDate int) (*scheme.BraveChallengeRecordObject, error) {
	braveChallenge := s.getBraveChallenge(yyID)
	record := s.getRecord(recordID, yyID, false, lastOpenDate)
	if record.RoleDbId() != roleID {
		err := fmt.Errorf("record %v role error, expect %v, got %v", recordID, roleID, record.RoleDbId())
		return nil, err
	}
	record.RandomBadge(weight, floor, braveChallenge)
	return record.BraveChallengeRecordObject, nil
}

// 勇者挑战 开始准备
func (s *Service) BraveChallengeStartPrepare(recordID document.ID, roleID document.ID, yyID int, lastOpenDate int) (RespPrepareStart, error) {
	braveChallenge := s.getBraveChallenge(yyID)
	for i := 0; atomic.LoadInt32(&braveChallenge.complete) == 0 && i < 10; i++ {
		time.Sleep(time.Second)
	}
	err := braveChallenge.isBanned(roleID)
	if err != nil {
		return RespPrepareStart{}, err
	}
	record := s.getRecord(recordID, yyID, true, lastOpenDate)
	if record.RoleDbId() != roleID {
		err := fmt.Errorf("record %v role error, expect %v, got %v", recordID, roleID, record.RoleDbId())
		return RespPrepareStart{}, err
	}
	return record.StartPrepare(braveChallenge)
}

// 勇者挑战 结束准备
func (s *Service) BraveChallengeEndPrepare(recordID document.ID, roleID document.ID, yyID int, cards []int, lastOpenDate int) (*scheme.BraveChallengeRecordObject, error) {
	braveChallenge := s.getBraveChallenge(yyID)
	record := s.getRecord(recordID, yyID, true, lastOpenDate)
	if record.RoleDbId() != roleID {
		err := fmt.Errorf("record %v role error, expect %v, got %v", recordID, roleID, record.RoleDbId())
		return nil, err
	}
	err := record.EndPrepare(cards, braveChallenge)
	if err != nil {
		return nil, err
	}
	return record.BraveChallengeRecordObject, nil
}

// 勇者挑战 选择勋章
func (s *Service) BraveChallengeChooseBadge(recordID document.ID, roleID document.ID, yyID int, badgeID int, lastOpenDate int) (*scheme.BraveChallengeRecordObject, error) {
	braveChallenge := s.getBraveChallenge(yyID)
	record := s.getRecord(recordID, yyID, true, lastOpenDate)
	if record.RoleDbId() != roleID {
		err := fmt.Errorf("record %v role error, expect %v, got %v", recordID, roleID, record.RoleDbId())
		return nil, err
	}
	err := record.ChooseBadge(badgeID, braveChallenge)
	return record.BraveChallengeRecordObject, err
}

// 勇者挑战 布阵
func (s *Service) BraveChallengeDeploy(recordID document.ID, roleID document.ID, yyID int, cards [6]int, lastOpenDate int) (*scheme.BraveChallengeRecordObject, error) {
	record := s.getRecord(recordID, yyID, true, lastOpenDate)
	if record.RoleDbId() != roleID {
		err := fmt.Errorf("record %v role error, expect %v, got %v", recordID, roleID, record.RoleDbId())
		return nil, err
	}
	err := record.Deploy(cards)
	return record.BraveChallengeRecordObject, err
}

// 勇者挑战 认输
func (s *Service) BraveChallengeQuit(recordID document.ID, roleID document.ID, yyID, lastOpenDate int) (*scheme.BraveChallengeRecordObject, error) {
	braveChallenge := s.getBraveChallenge(yyID)
	record := s.getRecord(recordID, yyID, true, lastOpenDate)
	if record.RoleDbId() != roleID {
		err := fmt.Errorf("record %v role error, expect %v, got %v", recordID, roleID, record.RoleDbId())
		return nil, err
	}
	err := record.Quit(braveChallenge)
	if err != nil {
		return nil, err
	}
	return record.BraveChallengeRecordObject, nil
}

// 勇者挑战 添加勋章 测试
func (s *Service) BraveChallengeAddBadge(recordID document.ID, roleID document.ID, yyID, badgeID int, lastOpenDate int) (*scheme.BraveChallengeRecordObject, error) {
	record := s.getRecord(recordID, yyID, true, lastOpenDate)
	if record.RoleDbId() != roleID {
		err := fmt.Errorf("record %v role error, expect %v, got %v", recordID, roleID, record.RoleDbId())
		return nil, err
	}
	db, unlock := record.LockAndGetDB()
	defer unlock()

	cfg := csv.GetConfig().Brave_challenge.Badge[badgeID]

	if badges, ok := db.Badges[document.Integer(cfg.ActiveType)]; ok {
		db.Badges[document.Integer(cfg.ActiveType)] = append(badges, badgeID)
	} else {
		db.Badges[document.Integer(cfg.ActiveType)] = []int{badgeID}
	}

	// 招募队友
	braveChallenge := s.getBraveChallenge(yyID)
	if cfg.Type == BadgeCardType {
		// 配置上会避免勋章选择的卡牌csvID与卡池里的相同
		for _, cardID := range cfg.CardIDs.ToIntSlice() {
			if _, ok := db.Game.Cards[document.Integer(cardID)]; !ok {
				db.Game.Cards[document.Integer(cardID)] = initCards([]int{cardID}, braveChallenge)[document.Integer(cardID)]
				braveChallenge := s.getBraveChallenge(yyID)
				record.unlockCards(UnlockCardType, cardID, braveChallenge.playType)
			}
		}
	}

	if num, ok := db.BadgeCounter[document.Integer(badgeID)]; ok {
		db.BadgeCounter[document.Integer(badgeID)] = num + 1
	} else {
		db.BadgeCounter[document.Integer(badgeID)] = 1
	}
	record.SetBadgeCounter(db.BadgeCounter)
	record.SetBadges(db.Badges)
	record.SetGame(db.Game)
	return record.BraveChallengeRecordObject, nil
}

// 勇者挑战 随机
func (s *Service) BraveChallengeRandom(recordID document.ID, roleID document.ID, yyID, typ, floor, weight int, firstPass bool, lastOpenDate int) (interface{}, error) {
	braveChallenge := s.getBraveChallenge(yyID)
	record := s.getRecord(recordID, yyID, true, lastOpenDate)
	if record.RoleDbId() != roleID {
		err := fmt.Errorf("record %v role error, expect %v, got %v", recordID, roleID, record.RoleDbId())
		return nil, err
	}
	if typ == 1 {
		_, unlock := record.LockAndGetDB()
		defer unlock()
		record.SetWeight(weight)
		data := record.getRandomBadge(floor, firstPass, braveChallenge.playType)
		return data, nil
	} else if typ == 2 {
		gateID, floorID := record.getRandomGate(floor, true, braveChallenge)
		data := map[string]int{
			"monsterID": gateID,
			"floorID":   floorID,
		}
		return data, nil
	}
	return record.BraveChallengeRecordObject, nil
}

// 勇者挑战 过关
func (s *Service) BraveChallengePassGate(recordID document.ID, roleID document.ID, yyID, floor int, lastOpenDate int) (interface{}, error) {
	braveChallenge := s.getBraveChallenge(yyID)
	record := s.getRecord(recordID, yyID, true, lastOpenDate)
	if record.RoleDbId() != roleID {
		err := fmt.Errorf("record %v role error, expect %v, got %v", recordID, roleID, record.RoleDbId())
		return nil, err
	}
	db, unlock := record.LockAndGetDB()
	defer unlock()

	gateID, floorID := record.getRandomGate(floor, record.isFirstPass(floor), braveChallenge)
	gateCfg := csv.GetConfig().Brave_challenge.Monster[gateID]
	monsters := gateCfg.Cards.ToIntSlice()

	db.Game.Monsters = initMonsters(monsters, braveChallenge)
	db.Game.Floor = floor
	db.Game.FloorID = floorID
	db.Game.MonsterID = gateID
	record.SetGame(db.Game)
	return record, nil
}

// 勇者挑战 选择关卡
func (s *Service) BraveChallengeChooseGate(recordID document.ID, roleID document.ID, yyID, gateID int, lastOpenDate int) (*scheme.BraveChallengeRecordObject, error) {
	braveChallenge := s.getBraveChallenge(yyID)
	record := s.getRecord(recordID, yyID, true, lastOpenDate)
	if record.RoleDbId() != roleID {
		err := fmt.Errorf("record %v role error, expect %v, got %v", recordID, roleID, record.RoleDbId())
		return nil, err
	}
	db, unlock := record.LockAndGetDB()
	defer unlock()

	gateCfg := csv.GetConfig().Brave_challenge.Monster[gateID]
	monsters := gateCfg.Cards.ToIntSlice()
	db.Game.Monsters = initMonsters(monsters, braveChallenge)
	db.Game.MonsterID = gateID
	var floor int
	if gateCfg.GroupID > 100 {
		floor = gateCfg.GroupID - 110
	} else {
		floor = gateCfg.GroupID - 10
	}
	db.Game.FloorID = floor
	db.Game.Floor = floor
	record.SetGame(db.Game)
	return record.BraveChallengeRecordObject, nil
}

func (s *Service) SummerChallengeYYStart(yyID int) (bool, error) {
	log.Infof("[thapta] SummerChallengeYYStart start %d %d",s.summerChallenge.yyID,yyID)
	if s.summerChallenge.yyID == yyID {
		return true, nil
	}
	err := s.summerChallenge.init(s, s.Container().GetService("anticheat"))
	if err != nil {
		log.Infof("[thapta] SummerChallengeYYStart error %v",err)
		return false, nil
	}
	return true, nil
}

func (s *Service) SummerChallengeYYRefresh() (bool, error) {
	s.summerChallenge.reset()
	err := s.summerChallenge.init(nil, nil)
	if err != nil {
		return false, nil
	}
	return true, nil
}

// 夏日挑战 开始战斗
func (s *Service) SummerChallengeStartBattle(roleID document.ID, yyID int, data BattleData) (SummerChallengeBattleModel, error) {
	//log.Info("SummerChallengeStartBattle start ")
	
	for i := 0; atomic.LoadInt32(&s.summerChallenge.complete) == 0 && i < 10; i++ {
		time.Sleep(time.Second)
	}
	if atomic.LoadInt32(&s.summerChallenge.complete) == 0 {
		//log.Infof("SummerChallengeStartBattle failed  need time to complete %s %d",roleID, yyID)
		return SummerChallengeBattleModel{}, errors.New("please wait a moment")
	}
	//log.Info("SummerChallengeStartBattle complete to start ")
	return s.summerChallenge.StartBattle(roleID, yyID, data)
}

// 夏日挑战 结束战斗
func (s *Service) SummerChallengeEndBattle(roleID document.ID, yyID int, gateID int, result string, actions map[document.Integer][]scheme.BattleAction, choices map[document.Integer]map[document.Integer]int) (bool, error) {
	//log.Info("SummerChallengeEndBattle start ")
	for i := 0; atomic.LoadInt32(&s.summerChallenge.complete) == 0 && i < 10; i++ {
		time.Sleep(time.Second)
	}
	if atomic.LoadInt32(&s.summerChallenge.complete) == 0 {
		//log.Infof("SummerChallengeEndBattle failed  need time to complete %s %d",roleID, yyID)
		return false, errors.New("please wait a moment")
	}
	//log.Info("SummerChallengeEndBattle complete end ")
	ret, err := s.summerChallenge.EndBattle(roleID, gateID, result, actions, choices)
	return ret, err
}

func (s *Service) PlayAntiSwitch(play string, flag, sync bool) (bool, error) {
	if play == "summer_challenge" {
		s.summerChallenge.flag = flag
		s.summerChallenge.sync = sync
	} else if play == "brave_challenge" {
		s.braveChallenge.flag = flag
	} else if play == "normal_brave_challenge" {
		s.normalBraveChallenge.flag = flag
	}

	log.Infof("play anti switch anti play: %s flag: %t sync: %t", play, flag, sync)
	return true, nil
}

func (s *Service) PlayAntiRecord(play string, flag bool) (bool, error) {
	if play == "summer_challenge" {
		s.summerChallenge.saveRecord = flag
	} else if play == "brave_challenge" {
		s.braveChallenge.saveRecord = flag
	} else if play == "normal_brave_challenge" {
		s.normalBraveChallenge.saveRecord = flag
	}
	log.Infof("play anti switch anti record: %s flag: %t", play, flag)
	return true, nil
}

func (s *Service) RemoveFromAntiBan(play string, roleID document.ID) (bool, error) {
	if play == "summer_challenge" {
		if _, ok := s.summerChallenge.banRoles.Load(roleID); ok {
			s.summerChallenge.banRoles.Delete(roleID)
		}
	} else if play == "brave_challenge" {
		if _, ok := s.braveChallenge.banRoles.Load(roleID); ok {
			s.braveChallenge.banRoles.Delete(roleID)
		}
	} else if play == "normal_brave_challenge" {
		if _, ok := s.normalBraveChallenge.banRoles.Load(roleID); ok {
			s.normalBraveChallenge.banRoles.Delete(roleID)
		}
	}
	log.Infof("remove from anti ban: %s", play)
	return true, nil
}

// 勇者挑战 战斗测试
func (s *Service) BraveChallengeBattleTest(recordID document.ID, roleID document.ID, yyID, lastOpenDate int) (bool, error) {
	bc := s.getBraveChallenge(yyID)
	record := s.getRecord(recordID, yyID, true, lastOpenDate)

	cards := [6]int{}
	index := 0
	for cardID, status := range record.Game().Cards {
		if status[0] > 0 && index < 5 {
			cards[index] = int(cardID)
			index += 1
			if index > 5 {
				break
			}
		}
	}
	record.Deploy(cards)
	record.StartBattle(record.Game().FloorID, record.Game().MonsterID, bc, map[int]map[string][2]float64{})

	b, _ := bc.battles.Load(record.RoleDbId())
	bc.battles.Delete(record.RoleDbId())
	battle := b.(*battleInfo)
	data, _ := util.MsgPack(battle.model)
	result, err := service.Call(bc.agent, battleType[bc.name], bc.server.Name(), battle.battleID, data)

	if (result != "win" && result != "fail") || err != nil {
		filename := fmt.Sprintf("%s_%s.play", bc.agent.Name(), bson.ObjectId(battle.battleID).Hex())
		playRecord := []interface{}{bc.agent.Name(), data}
		d, _ := util.MsgPack(playRecord)
		_ = ioutil.WriteFile(filename, d, 0777)
		return false, nil
	}

	return true, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}

	s.Register(s, "RefreshCSV")

	// world boss
	s.Register(s, "WorldBossMain")
	s.Register(s, "WorldBossDayEnd")
	s.Register(s, "WorldBossDamageUpdate")
	s.Register(s, "WorldBossRankInfo")
	s.Register(s, "WorldBossUnionDissolve")

	// brave challenge
	s.Register(s, "BraveChallengeYYStart")
	s.Register(s, "BraveChallengeYYRefresh")
	s.Register(s, "BraveChallengeCreateRecord")
	s.Register(s, "BraveChallengeStartPrepare")
	s.Register(s, "BraveChallengeEndPrepare")
	s.Register(s, "BraveChallengeRandomBadge")
	s.Register(s, "BraveChallengeDeploy")
	s.Register(s, "BraveChallengeStartBattle")
	s.Register(s, "BraveChallengeEndBattle")
	s.Register(s, "BraveChallengeGetRecord")
	s.Register(s, "BraveChallengeChooseBadge")
	s.Register(s, "BraveChallengeQuit")

	// summer challenge
	s.Register(s, "SummerChallengeYYStart")
	s.Register(s, "SummerChallengeYYRefresh")
	s.Register(s, "SummerChallengeStartBattle")
	s.Register(s, "SummerChallengeEndBattle")

	// test
	s.Register(s, "BraveChallengeAddBadge")
	s.Register(s, "BraveChallengeRandom")
	s.Register(s, "BraveChallengePassGate")
	s.Register(s, "BraveChallengeChooseGate")
	s.Register(s, "PlayAntiSwitch")
	s.Register(s, "PlayAntiRecord")
	s.Register(s, "RemoveFromAntiBan")
	s.Register(s, "BraveChallengeBattleTest")
	//[thapta] register functional
	// s.Register(s, "Thapta")

	return s
}

package arena

import (
	"errors"
	"fmt"
	"strings"
	"sync"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/document/schemeutil"
	"tjgame/server_framework/tj/service/caller"
	"tjgame/services/cross"
	"tjgame/services/storage"
	"tjgame/ta"

	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"

	"tjgame/mgo.v2/bson"
)

const (
	Name = "arena"
	// 竞技场结算奖励历史保留长度
	GlobalHistoryMax = 30
	// 竞技场刷新重置时间点
	RefreshTimeHour = 21
	// 竞技场排名总数
	TopRankMax = 50
)

var emptyArenaPlayRecord = scheme.NewArenaPlayRecordObject(&scheme.ArenaPlayRecord{})

type Service struct {
	*service.Service
	builder *Builder
	cache   *util.LRUCache // cache for Record and PlayRecord

	arena           *Arena
	historys        historys
	roleID2RecordID sync.Map

	storage service.IService
	agent   service.IService

	track *ta.BattleCardTrack
}

func (s *Service) Init() bool {
	if ok := s.Service.Init(); !ok {
		return false
	}
	LoadConfig()

	return true
}

func (s *Service) Start() bool {
	opt := s.Option.Base()
	s.storage = s.Container().GetService(storage.GetNameFromDependent(opt.Dependent))
	s.agent = s.Container().GetService("anticheat")

	s.cache = util.NewLRUCache(5000, nil)
	s.builder = &Builder{
		Builder: document.NewBuilder(s.storage),
		storage: s.storage,
		cache:   util.NewLRUCache(1000, nil),
	}

	key := strings.Replace(opt.Name, Name, "game", 1)
	// load arena global
	resp, err := service.Call(s.storage, "DBReadsert", "ArenaGlobal", bson.M{"key": key}, false)
	if err != nil {
		return false
	}
	response := resp.(storage.Response)
	s.arena = s.builder.NewArena(&response)
	s.arena.container = s.Container()
	s.arena.init(s.builder, key)

	for _, rr := range s.arena.Ranks() {
		s.roleID2RecordID.Store(rr[0], rr[1])
	}
	log.Infof("load %s arena, rank max %d", key, s.arena.RankMax())

	// load arena historys
	end := util.Now()
	start := end.Add(-GlobalHistoryMax * util.OneDay)
	max := util.Time2int(end)
	min := util.Time2int(start)
	resp, err = service.Call(s.storage, "DBReadRangeBy", "ArenaGlobalHistory", bson.M{"key": key, "award_time": []int{min, max}}, GlobalHistoryMax)
	if err != nil {
		return false
	}
	response = resp.(storage.Response)
	log.Infof("ArenaGlobalHistory from %d to %d has %d", min, max, len(response.Models))
	s.historys = make(historys, GlobalHistoryMax)
	s.historys = s.builder.newArenaGlobalHistorys(&response)

	if len(s.arena.Ranks()) > 0 {
		v := s.arena.Ranks()[1] // 排名第一若是机器人，则记录id
		if s.getRecord(v[1]).Robot() {
			s.arena.rank1Robot = v[0]
		}
	}

	s.fixCorrupted()

	s.track = ta.NewBattleCardTrack(s.Name(), "arena")
	s.track.Start()
	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.builder.Stop()
	s.track.Stop()
}

func (s *Service) fixCorrupted() {
	// 检查排名是否有中空
	noneList := make([]int, 0, 8)
	for i := 1; i <= int(s.arena.RankMax()); i++ {
		if _, ok := s.arena.Ranks()[document.Integer(i)]; !ok {
			noneList = append(noneList, i)
		}
	}
	if len(noneList) > 0 {
		log.Warningf("rank had %d none place %v", len(noneList), noneList)

		ranks := s.arena.Ranks()
		newRanks := make(map[document.Integer][2]document.ID, len(ranks))

		for rank, rr := range ranks {
			changeNum := 0
			for _, noneRank := range noneList {
				if int(rank) > noneRank {
					changeNum++
				}
			}
			if changeNum > 0 {
				rank -= document.Integer(changeNum)
			}
			newRanks[rank] = rr
		}
		s.arena.SetRanks(newRanks)
		s.arena.SetRankMax(int64(len(newRanks)))
		key := strings.Replace(s.Name(), Name, "game", 1)
		s.arena.init(s.builder, key)

		for top50Rank, rr := range s.arena.cache.top50 {
			record := s.getRecord(rr[1])
			record.SetRank(top50Rank + 1)
		}

		log.Infof("rank had %d none place %v fix finish", len(noneList), noneList)
	}
}

type competitor struct {
	ID     document.ID `codec:"id"`
	Name   string      `codec:"name"`
	Level  int         `codec:"level"`
	Vip    int         `codec:"vip"`
	Logo   int         `codec:"logo"`
	Frame  int         `codec:"frame"`
	Figure int         `codec:"figure"`
}

type deployment struct {
	Cards         []document.ID            `codec:"cards"`
	DefenceCards  []document.ID            `codec:"defence_cards"`
	PassiveSkills map[document.Integer]int `codec:"passive_skills"`

	CardAttrs            map[document.ID]*scheme.CardBattleModel `codec:"card_attrs"`
	CardAttrs2           map[document.ID]*scheme.CardBattleModel `codec:"card_attrs2"`
	DefenceCardAttrs     map[document.ID]*scheme.CardBattleModel `codec:"defence_card_attrs"`
	DefenceCardAttrs2    map[document.ID]*scheme.CardBattleModel `codec:"defence_card_attrs2"`
	DefencePassiveSkills map[document.Integer]int                `codec:"defence_passive_skills"`
}

func (s *Service) CreateArenaRecord(role competitor, deploy deployment, fightingPoint int, display int, robot bool) (document.ID, error) {
	rank := s.arena.lastNextRank()
	record := document.New("ArenaRecord", true).(*scheme.ArenaRecord)
	record.RoleDbId = role.ID
	record.RoleName = role.Name
	record.RoleLogo = role.Logo
	record.RoleFrame = role.Frame
	record.RoleLevel = role.Level
	record.RoleVip = role.Vip
	record.RoleFigure = role.Figure
	record.Rank = rank
	record.Cards = deploy.Cards
	record.CardAttrs = deploy.CardAttrs
	record.PassiveSkills = deploy.PassiveSkills
	record.DefenceCards = deploy.DefenceCards
	record.DefenceCardAttrs = deploy.DefenceCardAttrs
	record.DefencePassiveSkills = deploy.DefencePassiveSkills
	record.FightingPoint = fightingPoint
	record.Display = display
	record.Robot = robot

	// create ArenaRecord in storage
	resp, err := service.Call(s.storage, "DBCreate", record.CollectionName(), record)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	r := s.builder.NewArenaRecord(&response)
	s.arena.join(rank, r.RoleDbId(), r.GetID())
	s.roleID2RecordID.Store(r.RoleDbId(), r.GetID())
	return r.GetID(), nil
}

func (s *Service) GetArenaTop50(offset int, size int) ([]SlimModel, error) {
	// refresh top50 model
	miss := s.arena.cache.getTop50ModelMiss()
	for _, rr := range miss {
		record := s.getRecord(rr[1])
		s.arena.cache.setTop50Model(record.RoleDbId(), record, true)
	}
	s.arena.cache.refresh(s.arena)
	return s.arena.cache.top(offset, size), nil
}

type ModelResponse struct {
	Record scheme.ArenaRecord `codec:"record"`

	Enemys []SlimModel `codec:"enemys"`
	Top10  []SlimModel `codec:"top10"`
}

func (s *Service) GetAreaModel(roleID document.ID, recordID document.ID, refresh bool) (resp ModelResponse, err error) {
	record := s.getRecord(recordID)
	if record.RoleDbId() != roleID {
		err = fmt.Errorf("record %v role error, expect %v, got %v", recordID, roleID, record.RoleDbId)
		return
	}

	db, unlock := record.LockAndGetDB()
	util.WithDefer(func() {
		record.checkAndRefresh(s.arena, refresh)
		if record.Rank() == 0 { // 异常情况，rank为0，直接插入到排名末尾
			rank := s.arena.lastNextRank()
			s.arena.join(rank, roleID, recordID)
			record.checkAndRefresh(s.arena, true)
			log.Infof("role %v insert rank %d", roleID, record.Rank())
		}
		resp.Record = *db
	}, unlock)

	// enemys
	enemyRR := s.arena.getRoleRecordIDs(record.EnemyRanks())
	resp.Enemys = make([]SlimModel, 0, len(enemyRR))
	for _, rr := range enemyRR {
		r := s.getRecord(rr.RecordID)
		m := r.slimModelLocked()
		m.Rank = rr.Rank
		resp.Enemys = append(resp.Enemys, m)
	}

	// refresh top50 model
	miss := s.arena.cache.getTop50ModelMiss()
	for _, rr := range miss {
		record := s.getRecord(rr[1])
		s.arena.cache.setTop50Model(record.RoleDbId(), record, true)
	}
	s.arena.cache.refresh(s.arena)

	// top10
	resp.Top10 = s.arena.cache.top(0, 10)
	for i := range resp.Top10 {
		resp.Top10[i].Rank = i + 1
	}
	return
}

func (s *Service) Deploy(recordID document.ID, role competitor, deply deployment) (bool, error) {
	record := s.getRecord(recordID)
	// TODO: deploy and setTop50Model are not atomic
	record.deploy(role, deply)
	s.arena.cache.setTop50Model(role.ID, record, false)
	return true, nil
}

func (s *Service) BattleStart(roleRank int, battleRank int, roleID document.ID, recordID document.ID, enemyRoleID document.ID, enemyRecordID document.ID) (*scheme.ArenaPlayRecordObject, error) {
	record := s.getRecord(recordID)
	if record.Rank() != roleRank {
		return emptyArenaPlayRecord, ErrRankChanged
	}

	err := s.arena.storeForRole(battleRank, roleID, recordID, enemyRoleID, enemyRecordID)
	if err != nil {
		return emptyArenaPlayRecord, err
	}

	enemyRecord := s.getRecord(enemyRecordID)
	playModel := NewPlayModel(record, enemyRecord)

	// create playrecord in storage
	resp, err := service.Call(s.storage, "DBCreate", playModel.CollectionName(), playModel)
	if err != nil {
		return emptyArenaPlayRecord, err
	}
	response := resp.(storage.Response)
	playRecord := s.builder.NewArenaPlayRecord(&response)
	id := playRecord.GetID()
	s.arena.battles.Store(roleID, &battle{
		playRecord:    id,
		enemyRoleID:   enemyRoleID,
		enemyRecordID: enemyRecordID,
		battleRank:    battleRank,
	})

	if s.agent != nil {
		go func() {
			var data []byte
			var err error
			model, unlock := playRecord.RLockAndGetDB()
			util.WithDefer(func() {
				data, err = util.MsgPack(model)
			}, unlock)
			if err != nil {
				return
			}
			future := service.CallAsync(s.agent, "NewArenaBattle", s.Name(), id, data)
			go func() {
				ret, err := future.Get()
				if err != nil {
					log.Warningf("area play %v result error %v", id, err)
					return
				}
				result := ret.(string)
				if result == "win" || result == "fail" {
					if b, ok := s.arena.battles.Load(roleID); ok {
						s.battleEndUpdateRank(b.(*battle), roleID, recordID, result, true)
					}
				} else {
					log.Warningf("area play %v result %s", id, result)
				}
			}()
		}()
	}

	return playRecord.ArenaPlayRecordObject, nil
}

func (s *Service) BattleEnd(battleRank int, roleID document.ID, recordID document.ID, result string) (map[string]int, error) {
	var bb *battle
	if b, ok := s.arena.battles.Load(roleID); ok {
		bb = b.(*battle)
		s.arena.battles.Delete(roleID)
	} else {
		return nil, errors.New("battle not found")
	}

	return s.battleEndUpdateRank(bb, roleID, recordID, result, false)
}

func (s *Service) battleEndUpdateRank(bb *battle, roleID, recordID document.ID, result string, fromAnti bool) (map[string]int, error) {
	playRecord := s.getPlayRecord(bb.playRecord)
	record := s.getRecord(recordID)
	enemyRecord := s.getRecord(bb.enemyRecordID)
	bb.mu.Lock()
	defer bb.mu.Unlock()

	if fromAnti {
		bb.result.anticheat = result
		log.Infof(" role %v play %v anti result %s", roleID, bb.playRecord, result)
	} else {
		bb.result.client = result
	}
	if bb.result.anticheat != "" && bb.result.client != "" && bb.result.anticheat != bb.result.client {
		log.Warningf("role %v play %v cheat, client %s anti %s", roleID, bb.playRecord, bb.result.client, bb.result.anticheat)
		if !fromAnti {
			return nil, ErrRankCheat
		}
	}

	if bb.result.view != nil {
		return bb.result.view, nil
	}

	oldRank, newRank, err := s.arena.resultForRole(roleID, bb.enemyRoleID, result)
	if err != nil {
		return nil, err
	}
	playRecord.SetResult(result)

	move := 0
	topMove := 0
	if result == "win" {
		if newRank < oldRank {
			old := record.RankTop()
			record.SetRank(newRank)
			enemyRecord.SetRank(oldRank)
			move = oldRank - newRank
			topMove = old - record.RankTop()
		}
	}
	view := map[string]int{
		"rank":      record.Rank(),
		"rank_move": move,
		"top_move":  topMove,
	}

	// add history
	record.addHistory(result, move, playRecord.GetID(), enemyRecord.RoleName(), enemyRecord.RoleDbId(), enemyRecord.GetID(), enemyRecord.RoleLogo(), enemyRecord.RoleFrame(), enemyRecord.RoleLevel(), enemyRecord.FightingPoint())
	result2 := "unknown"
	switch result {
	case "win":
		result2 = "fail"
	case "fail":
		result2 = "win"
	}
	enemyRecord.addHistory(result2, -move, playRecord.GetID(), record.RoleName(), record.RoleDbId(), record.GetID(), record.RoleLogo(), record.RoleFrame(), record.RoleLevel(), record.FightingPoint())
	bb.result.view = view
	if s.track != nil && !enemyRecord.Robot() && (newRank <= 150 || oldRank <= 150) { // 竞技场本服前150名
		cards := schemeutil.CalcBattleCards(playRecord.CardAttrs(), playRecord.Cards())
		defencecards := schemeutil.CalcBattleCards(playRecord.DefenceCardAttrs(), playRecord.DefenceCards())
		win := result == "win"
		s.track.Track(win, cards)
		s.track.Track(!win, defencecards)
	}
	return view, nil
}

func (s *Service) GetOfflineRankPeriodAward(roleID document.ID) ([][2]int, error) {
	return s.historys.getRoleRankHistory(roleID), nil
}

type RankResp struct {
	_struct     struct{} `codec:",toarray"`
	OnlineRanks []int
	AllRanks    map[document.ID]int
}

func (s *Service) OnRankPeriodAward(onlineRoleIDs []document.ID) (RankResp, error) {
	model, onlineRanks, allRanks := NewArenaGlobalHistory(s.arena, onlineRoleIDs)
	resp, err := service.Call(s.storage, "DBCreate", model.CollectionName(), model)
	if err != nil {
		return RankResp{}, err
	}
	response := resp.(storage.Response)
	history := s.builder.NewArenaGlobalHistory(&response)
	s.historys.add(history)
	return RankResp{OnlineRanks: onlineRanks, AllRanks: allRanks}, nil
}

func (s *Service) GetArenaPlayRecord(id document.ID) (*scheme.ArenaPlayRecordObject, error) {
	playRecord := s.getPlayRecord(id)
	return playRecord.ArenaPlayRecordObject, nil
}

func (s *Service) GetArenaRoleInfo(id document.ID) (*scheme.ArenaRecordObject, error) {
	record := s.getRecord(id)
	return record.ArenaRecordObject, nil
}

func (s *Service) GetArenaBattleCards(id document.ID) (map[string][]document.ID, error) {
	record := s.getRecord(id)
	ret := map[string][]document.ID{
		"cards":         record.Cards(),
		"defence_cards": record.DefenceCards(),
	}
	return ret, nil
}

func (s *Service) UpdateDisplay(recordID document.ID, display int) (bool, error) {
	record := s.getRecord(recordID)
	record.SetDisplay(display)
	s.arena.cache.setTop50Model(record.RoleDbId(), record, false)
	return true, nil
}

func (s *Service) Flush() (bool, error) {
	//s.manager.WaitForceFlush()
	return true, nil
}

type ranktuple struct {
	_struct  struct{} `codec:",toarray"`
	Rank     int
	RoleID   document.ID
	RecordID document.ID
}

func (s *Service) GetRankRange(start, end int) (map[string]interface{}, error) {
	result := map[string]interface{}{
		"rank_max": s.arena.RankMax(),
	}
	ranks := make([]ranktuple, 0, end-start+1)
	s.arena.RangeRanks(func(rank int, roleID document.ID, recordID document.ID) bool {
		ranks = append(ranks, ranktuple{Rank: rank, RoleID: roleID, RecordID: recordID})
		return true
	}, start, end)
	result["ranks"] = ranks
	return result, nil
}

func (s *Service) Fight(roleID document.ID, recordID document.ID, enemyRoleID document.ID, enemyRecordID document.ID) (*scheme.ArenaPlayRecord, error) {
	if recordID == "" {
		if v, ok := s.roleID2RecordID.Load(roleID); ok {
			recordID = v.(document.ID)
		}
	}
	if enemyRecordID == "" {
		if v, ok := s.roleID2RecordID.Load(enemyRoleID); ok {
			enemyRecordID = v.(document.ID)
		}
	}
	if recordID == "" {
		return nil, errors.New("you not in arena")
	}
	if enemyRecordID == "" {
		return nil, errors.New("enemy not in arena")
	}

	record := s.getRecord(recordID)
	enemyRecord := s.getRecord(enemyRecordID)
	playModel := NewPlayModel(record, enemyRecord)
	return playModel, nil
}

func (s *Service) FriendFight(role competitor, deploy deployment, enemyRoleID document.ID, enemyRecordID document.ID) (*scheme.ArenaPlayRecord, error) {
	if enemyRecordID == "" {
		if v, ok := s.roleID2RecordID.Load(enemyRoleID); ok {
			enemyRecordID = v.(document.ID)
		}
	}
	enemyRecord := s.getRecord(enemyRecordID)
	playModel := NewFriendPlayModel(role, deploy, enemyRecord)
	return playModel, nil
}

func (s *Service) getRecord(id document.ID) *Record {
	if v, ok := s.cache.Get(id); ok {
		return v.(*Record)
	}
	resp, err := service.Call(s.storage, "DBRead", "ArenaRecord", id, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	record := s.builder.NewArenaRecord(&response)
	s.cache.Set(id, record)
	if len(record.DefenceCardAttrs()) == 0 { // temp fix
		record.SetDefenceCards(record.Cards())
		record.SetDefenceCardAttrs(record.CardAttrs())
	}
	return record
}

func (s *Service) getPlayRecord(id document.ID) *PlayRecord {
	if v, ok := s.cache.Get(id); ok {
		return v.(*PlayRecord)
	}
	resp, err := service.Call(s.storage, "DBRead", "ArenaPlayRecord", id, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	playRecord := s.builder.NewArenaPlayRecord(&response)
	s.cache.Set(id, playRecord)
	return playRecord
}

func (s *Service) NotifyGenHuntingCards(crossKey string) (bool, error) {
	err := cross.ContainerServices(s.Container(), crossKey)
	if err != nil {
		return false, err
	}

	flag, err := s.arena.genHuntingBattleCards(crossKey)
	if err != nil {
		return flag, err
	}
	return flag, nil
}

func (s *Service) GetArenaHuntingRoleInfo(arenaHuntingRecordID document.ID, roleID document.ID, gameKey string, isUpdate bool) (*scheme.HuntingDefenceRoleInfo, error) {
	arenaHuntingRecord := s.builder.GetArenaHuntingRecord(arenaHuntingRecordID)
	db, unlock := arenaHuntingRecord.LockAndGetDB()
	defer unlock()
	var recordID document.ID
	if v, ok := s.roleID2RecordID.Load(roleID); ok {
		recordID = v.(document.ID)
	} else {
		return nil, errors.New("roleID error")
	}
	record := s.getRecord(recordID)
	if len(arenaHuntingRecord.DefenceCards()) == 0 || isUpdate {
		arenaHuntingRecord.SetDefenceCards(record.DefenceCards())
		arenaHuntingRecord.SetDefenceCardAttrs(record.DefenceCardAttrs())
		arenaHuntingRecord.SetDefenceCardAttrs2(record.DefenceCardAttrs2())
		arenaHuntingRecord.SetDefencePassiveSkills(record.DefencePassiveSkills())
	}
	resp := &scheme.HuntingDefenceRoleInfo{
		ArenaHuntingRecord: db,
		GameKey:            gameKey,
		Name:               record.RoleName(),
		Logo:               record.RoleLogo(),
		Frame:              record.RoleFrame(),
		Level:              record.RoleLevel(),
		Figure:             record.RoleFigure(),
		Vip:                record.RoleVip(),
	}
	return resp, nil
}

func (s *Service) SwapArenaRank(roleID document.ID, newRank int) (bool, error) {
	oldRank := s.arena.roleRanks[roleID]
	s.arena.swapRank(oldRank, document.Integer(newRank))
	return true, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}

	s.Register(s, "CreateArenaRecord")
	s.Register(s, "GetArenaTop50")
	s.Register(s, "GetAreaModel")
	s.Register(s, "Deploy")
	s.Register(s, "BattleStart")
	s.Register(s, "BattleEnd")
	s.Register(s, "GetOfflineRankPeriodAward")
	s.Register(s, "OnRankPeriodAward")
	s.Register(s, "GetArenaPlayRecord")
	s.Register(s, "GetArenaRoleInfo")
	s.Register(s, "GetArenaBattleCards")
	s.Register(s, "UpdateDisplay")
	s.Register(s, "GetRankRange")
	s.Register(s, "Flush")

	s.Register(s, "Fight")
	s.Register(s, "FriendFight")
	s.Register(s, "SwapArenaRank")

	s.RegisterCustom(s, caller.Notify, "NotifyGenHuntingCards", nil)
	s.Register(s, "GetArenaHuntingRoleInfo")

	return s
}

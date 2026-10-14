/*
 * @Time     : 2019/10/15 14:46
 * @Author   : cancan
 * @File     : service.go
 * @Function :
 */

package clone

import (
	"strings"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/storage"

	"tjgame/mgo.v2/bson"
)

const (
	Name = "clone"
)

type Service struct {
	*service.Service
	builder *document.Builder
	storage service.IService

	defaultDBRespFrom string

	global *CloneGlobal
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
	s.builder = document.NewBuilder(s.storage)

	key := strings.Replace(opt.Name, Name, "game", 1)
	resp, err := service.Call(s.storage, "DBReadsert", "CloneGlobal", bson.M{"key": key}, false)
	if err != nil {
		return false
	}

	response := resp.(storage.Response)
	s.global = NewCloneGlobal(response.Model.(*scheme.CloneGlobal))
	s.builder.Indicate(s.global, response.From)
	s.global.init()

	resp, err = service.Call(s.storage, "DBReadBy", "CloneRoom", bson.M{"discard": true})
	if err != nil {
		return false
	}
	response = resp.(storage.Response)
	ids := make([]document.ID, 0, len(response.Models))
	for _, model := range response.Models {
		ids = append(ids, model.GetID())
	}
	s.defaultDBRespFrom = response.From

	resp, err = service.Call(s.storage, "DBReadBy", "CloneRoom", bson.M{"discard": false})
	if err != nil {
		return false
	}
	response = resp.(storage.Response)
	usedNum := 0
	dateCheck := util.Perioddate2int(CloneRefreshTime, util.Now())
	natureCheck := make(map[int]bool)
	for _, n := range s.global.CloneNatures() {
		natureCheck[n.Nature] = true
	}
	for _, model := range response.Models {
		v := model.(*scheme.CloneRoom)
		room := NewCloneRoom(v)
		s.builder.Indicate(room, response.From)
		_, natureOk := natureCheck[room.NatureID()]
		if room.space() >= CloneRoomMemberMax || room.Date() < dateCheck || !natureOk {
			log.Warningf("CloneRoom not discard id %v space %v date %v nature %v natureCheck %v", room.GetID(), room.space(), room.Date(), room.NatureID(), natureCheck)
			ids = append(ids, room.GetID())
			room.SetDiscard(true)
			continue
		}
		s.global.AddRoomToIndex(room)
		usedNum++
	}

	s.global.InitFree(ids)
	log.Infof("CloneRoom Used: %d, Free: %d", usedNum, len(ids))

	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.builder.Stop()
}

func (s *Service) CloneGet(roleID document.ID) (RespNatureList, error) {
	resp := RespNatureList{Nature: s.global.CloneNatures()}
	room := s.global.getRoomByRoleID(roleID)
	if room != nil && room.InRoom(roleID) {
		resp.Room = room.CloneRoomObject
	}
	return resp, nil
}

func (s *Service) CreateRoom(natureID int, role ReqRoleJoin) (*scheme.CloneRoomObject, error) {
	room := s.global.getRoomByRoleID(role.ID)
	if room != nil && room.InRoom(role.ID) {
		return nil, ErrAlreadyInRoom
	}

	now := util.Perioddate2int(CloneRefreshTime, util.Now())
	monsters, err := s.global.CheckRoleCards(natureID, role.MarkIDs)
	if err != nil {
		return nil, err
	}

	id := s.global.GetFreeRoomID()
	room, err = CreateCloneRoom(s.storage, id, s.builder, s.defaultDBRespFrom)
	if err != nil {
		return nil, err
	}
	room.SetCreateTime(int(util.NowTime()))
	room.SetNatureID(natureID)
	room.SetDate(now)
	room.SetMonsters(monsters)
	room.SetLeader(role.ID)
	room.SetFast(true)
	room.SetDiscard(false)
	room.SetFinishNum(0)
	room.SetPlaces(make(map[document.Integer]*scheme.CloneRoomPlace))
	room.SetVoteRound("")
	room.SetHistory([]scheme.CloneHistory{})
	room.addHistory(HistoryCreateRoom, "")
	_, _ = room.join(role)
	s.global.AddRoomToIndex(room)

	return room.CloneRoomObject, nil
}

func (s *Service) QuitRoom(roleID document.ID) (*scheme.CloneRoomObject, error) {
	room := s.global.getRoomByRoleID(roleID)
	if room == nil {
		return nil, nil
	}

	room.Lock()
	defer room.Unlock()
	isLeader := room.Leader() == roleID
	err := s.quitRoomByRoleID(room, roleID, false)
	if isLeader && room.VoteRound() != "" {
		room.resetVote()
	}
	return room.CloneRoomObject, err
}

func (s *Service) quitRoomByRoleID(room *CloneRoom, roleID document.ID, isKicked bool) error {
	space, err := room.quit(roleID, isKicked)
	if err == nil {
		s.global.DeleteRoleRoom(roleID)
		s.global.UpdateRoomIndex(room, space-1)
	} else if err != ErrCanNotQuitRoom {
		err = nil
	}
	return err
}

// 房主踢人
func (s *Service) KickRoom(roleID, kickRoleID document.ID) (*scheme.CloneRoomObject, error) {
	room := s.global.getRoomByRoleID(roleID)
	if room == nil {
		return nil, ErrRoomOutDate
	}

	room.Lock()
	defer room.Unlock()

	if !room.canKick(roleID, kickRoleID, false) {
		return nil, ErrCloneCanNotKick
	}
	err := s.quitRoomByRoleID(room, kickRoleID, true)
	return room.CloneRoomObject, err
}

// 投票踢房主
func (s *Service) VoteRoom(roleID document.ID, vote int) (RespVoteRoom, error) {
	ret := RespVoteRoom{}

	if vote != -1 && vote != 1 {
		return ret, ErrCloneParamError
	}
	room := s.global.getRoomByRoleID(roleID)
	if room == nil {
		return ret, ErrRoomOutDate
	}

	room.Lock()
	defer room.Unlock()

	oldVoteRound := room.VoteRound()
	if oldVoteRound == "win" || oldVoteRound == "fail" {
		return ret, ErrCloneHasVoteResult
	}

	leader := room.Leader()
	if !room.canKick(roleID, leader, true) {
		return ret, ErrCloneCanNotKick
	}

	room.setKickLeader(roleID, vote)
	newVoteRound := room.VoteRound()

	if oldVoteRound == "" && newVoteRound != "" {
		ret.First = true
		room.addHistory(HistoryVoteStart, room.getPlaceRoleName(leader))
	}

	switch newVoteRound {
	case "win":
		err := s.quitRoomByRoleID(room, leader, true)
		if err != nil {
			return ret, err
		}
		ret.OldLeader = leader
		ret.Result = "win"
		room.resetVote()
	case "fail":
		room.addHistory(HistoryVoteFailByResult, room.getPlaceRoleName(leader))
		ret.Result = "fail"
		room.resetVote()
	}

	ret.Room = room.CloneRoomObject
	return ret, nil
}

func (s *Service) JoinRoom(roomID document.ID, role ReqRoleJoin) (*scheme.CloneRoomObject, error) {
	room := s.global.getRoomByRoleID(role.ID)
	if room != nil && room.InRoom(role.ID) {
		return nil, ErrAlreadyInRoom
	}
	room = s.global.GetRoom(roomID)
	if room == nil {
		return nil, ErrRoomOutDate
	}

	room.Lock()
	defer room.Unlock()
	if _, err := s.global.CheckRoleCards(room.NatureID(), role.MarkIDs); err != nil {
		return nil, ErrCanNotJoinRoom
	}
	space, err := room.join(role)
	if err != nil {
		return nil, err
	}
	s.global.UpdateRoomIndex(room, space+1)
	s.global.storeRoleRoom(role.ID, room)
	return room.CloneRoomObject, nil
}

func (s *Service) FastRoom(natureID int, role ReqRoleJoin) (*scheme.CloneRoomObject, error) {
	room := s.global.getRoomByRoleID(role.ID)
	if room != nil && room.InRoom(role.ID) {
		return nil, ErrAlreadyInRoom
	}

	if _, err := s.global.CheckRoleCards(natureID, role.MarkIDs); err != nil {
		return nil, err
	}

	room = s.global.FindFastRoom(natureID)
	if room == nil {
		return s.CreateRoom(natureID, role)
	}

	room.Lock()
	defer room.Unlock()
	space, err := room.join(role)
	if err != nil {
		return nil, err
	}
	s.global.UpdateRoomIndex(room, space+1)
	s.global.storeRoleRoom(role.ID, room)
	return room.CloneRoomObject, nil
}

func (s *Service) FastEnable(roleID document.ID, enable bool) (*scheme.CloneRoomObject, error) {
	room := s.global.getRoomByRoleID(roleID)
	if room == nil {
		return nil, ErrRoomOutDate
	}

	room.Lock()
	defer room.Unlock()
	if room.isPast() {
		return nil, ErrRoomOutDate
	}

	if !room.isLeader(roleID) {
		return nil, ErrNeedLeader
	}

	oldFast := room.Fast()
	if oldFast != enable {
		room.SetFast(enable)
		s.global.UpdateRoomIndex(room, 0)
	}
	return room.CloneRoomObject, nil
}

func (s *Service) RobotEnable(roleID document.ID, enable bool) (*scheme.CloneRoomObject, error) {
	room := s.global.getRoomByRoleID(roleID)
	if room == nil {
		return nil, ErrRoomOutDate
	}

	room.Lock()
	defer room.Unlock()
	if room.isPast() {
		return nil, ErrRoomOutDate
	}

	if !room.inRoom(roleID) {
		return nil, ErrNotInRoom
	}

	room.setNeedRobot(roleID, enable)
	return room.CloneRoomObject, nil
}

func (s *Service) DeployCard(roleID document.ID, card *scheme.CardBattleModel, card2 *scheme.CardBattleModel) (*scheme.CloneRoomObject, error) {
	room := s.global.getRoomByRoleID(roleID)
	if room == nil {
		return nil, ErrRoomOutDate
	}

	room.Lock()
	defer room.Unlock()
	if room.isPast() {
		return nil, ErrRoomOutDate
	}

	if !room.inRoom(roleID) {
		return nil, ErrNotInRoom
	}

	room.deployCard(roleID, card, card2)
	return room.CloneRoomObject, nil
}

func (s *Service) EnterDeploy(roleID document.ID) (map[document.ID]*scheme.CardBattleModel, error) {
	room := s.global.getRoomByRoleID(roleID)
	if room == nil {
		return nil, ErrRoomOutDate
	}

	room.Lock()
	defer room.Unlock()
	if room.isPast() {
		return nil, ErrRoomOutDate
	}

	if !room.inRoom(roleID) {
		return nil, ErrNotInRoom
	}

	return room.createRobot(roleID), nil
}

func (s *Service) BattleStart(role ReqRoleBattle, csvID int, cardIDs []document.ID) (*RespBattleStart, error) {
	room := s.global.getRoomByRoleID(role.ID)
	if room == nil {
		return nil, ErrRoomOutDate
	}

	room.Lock()
	defer room.Unlock()

	if room.isPast() {
		return nil, ErrRoomOutDate
	}

	if !room.checkTargetMonster(csvID) {
		return nil, ErrMonsterNotExists
	}

	rolePlace := room.getPlaceByRoleID(role.ID)
	if rolePlace == nil {
		return nil, ErrNotInRoom
	}

	if rolePlace.Monster != CloneNotSelectMonster && rolePlace.Monster != csvID {
		return nil, ErrTargetMonster
	}

	if rolePlace.Play >= ClonePlayMaxTimes {
		return nil, ErrRoomBattleFinished
	}

	if !room.checkBattleCards(rolePlace, cardIDs) {
		return nil, ErrRoomCardRefresh
	}

	rolePlace.BattleDeploy = cardIDs
	record := room.battleStart(csvID, rolePlace, cardIDs, role, GetConfig().BattleFixSlice[rolePlace.Play])
	s.global.RecordRoleBattle(role.ID)

	if rolePlace.Monster == CloneNotSelectMonster {
		rolePlace.Monster = csvID
		rolePlace.CanQuit = false
		room.updateRolePace(rolePlace)
	}

	return &RespBattleStart{Record: record, Room: room.CloneRoomObject}, nil
}

func (s *Service) BattleEnd(roleID document.ID, result string) (*RespBattleEnd, error) {
	room := s.global.getRoomByRoleID(roleID)
	if room == nil {
		return nil, ErrCloneRoomNotExists
	}

	room.Lock()
	defer room.Unlock()

	if room.isPast() {
		return nil, ErrRoomOutDate
	}

	battle := room.getBattleByRoleID(roleID)
	if battle == nil {
		return nil, ErrBattleNotExists
	}

	if battle.Result != "" {
		return nil, ErrBattleHasEnd
	}

	csvID := room.getRoleMonster(roleID)
	if csvID == -1 {
		return nil, ErrHasNotBattle
	}

	if result != "win" {
		return nil, nil
	}

	battle.Result = result

	rolePlace := room.getPlaceByRoleID(roleID)
	rolePlace.Play++
	room.updateRolePace(rolePlace)

	mails := []BattleFinishMail{}
	if rolePlace.Play >= ClonePlayMaxTimes {
		mails = room.calcFinishMailAward(roleID)
	}
	award := BoxDraw(csvID)

	// 看下房主是否在投票中
	if rolePlace.ID == room.Leader() && room.VoteRound() == "start" {
		room.resetVote()
		room.addHistory(HistoryVoteFailByLeaderPlay, rolePlace.Name)
	}

	switch rolePlace.Play {
	case 1:
		room.addHistory(HistoryJoinRoom, rolePlace.Name)
	case 3:
		room.addHistory(HistoryFinish, rolePlace.Name)
	}

	return &RespBattleEnd{
		Box:   award,
		Mails: mails,
		Room:  room.CloneRoomObject,
	}, nil
}

func (s *Service) BoxDraw(roleID document.ID) (*BattleAward, error) {
	room := s.global.getRoomByRoleID(roleID)
	if room == nil {
		return nil, ErrCloneRoomNotExists
	}

	room.RLock()
	defer room.RUnlock()

	if room.isPast() {
		return nil, ErrRoomOutDate
	}

	csvID := room.getRoleMonster(roleID)
	if csvID == -1 {
		return nil, ErrHasNotBattle
	}
	battle := room.getBattleByRoleID(roleID)
	if battle == nil {
		return nil, ErrBattleNotExists
	}
	if battle.Result != "win" {
		return nil, ErrBattleNotEnd
	}

	award := BoxDraw(csvID)
	return award, nil
}

func (s *Service) HasBattleFriends(onlineFriends []document.ID) ([]document.ID, error) {
	return s.global.HasBattleFriends(onlineFriends), nil
}

func (s *Service) OnRefresh(serverOpenDays int) (bool, error) {
	s.global.RefreshNature(serverOpenDays)
	return true, nil
}

func (s *Service) YYActive(yyObj *scheme.CloneYYNature) (bool, error) {
	s.global.YYActive(yyObj)
	return true, nil
}

func (s *Service) YYClose() (bool, error) {
	s.global.YYClose()
	return true, nil
}

func (s *Service) ClearCloneCDRecord() (bool, error) {
	_, unlock := s.global.LockAndGetDB()
	defer unlock()
	s.global.SetCloneCDRecord(scheme.CloneCDRecord{})
	return true, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}

	s.Register(s, "CloneGet")
	s.Register(s, "CreateRoom")
	s.Register(s, "QuitRoom")
	s.Register(s, "KickRoom")
	s.Register(s, "VoteRoom")
	s.Register(s, "JoinRoom")
	s.Register(s, "FastRoom")
	s.Register(s, "FastEnable")
	s.Register(s, "RobotEnable")
	s.Register(s, "DeployCard")
	s.Register(s, "EnterDeploy")
	s.Register(s, "BattleStart")
	s.Register(s, "BattleEnd")
	s.Register(s, "BoxDraw")
	s.Register(s, "HasBattleFriends")
	s.Register(s, "OnRefresh")
	s.Register(s, "YYActive")
	s.Register(s, "YYClose")
	s.Register(s, "ClearCloneCDRecord")

	s.Register(s, "CheatClear")
	s.Register(s, "CheatClearTime")
	s.Register(s, "CheatClearPlay")
	s.Register(s, "CheatClearVote")
	s.Register(s, "CheatPlaceTime")
	s.Register(s, "CheatResetVote")

	return s
}

func CreateCloneRoom(s service.IService, id document.ID, builder *document.Builder, defaultDBRespFrom string) (*CloneRoom, error) {
	var room *CloneRoom
	model := document.New("CloneRoom", true).(*scheme.CloneRoom)
	if id != "" {
		// 复用过期的id
		model.ID = id
		room = NewCloneRoom(model)
		room.ReuseID()
		builder.Indicate(room, defaultDBRespFrom)
	} else {
		resp, err := service.Call(s, "DBCreate", model.CollectionName(), model)
		if err != nil {
			return nil, err
		}
		response := resp.(storage.Response)
		room = NewCloneRoom(response.Model.(*scheme.CloneRoom))
		builder.Indicate(room, response.From)
	}
	return room, nil
}

func (s *Service) CheatClear() (bool, error) {
	natures := []int{}
	for _, v := range s.global.CloneNatures() {
		natures = append(natures, v.Nature)
	}
	s.global.Refresh(natures)
	return true, nil
}

func (s *Service) CheatClearTime(roleID document.ID) (bool, error) {
	room := s.global.getRoomByRoleID(roleID)
	if room == nil {
		return false, ErrCloneRoomNotExists
	}

	room.Lock()
	defer room.Unlock()
	places := room.Places()
	for _, place := range places {
		place.Time = 0
	}
	room.SetPlaces(places)

	return true, nil
}

func (s *Service) CheatClearPlay(roleID document.ID, play int) (bool, error) {
	room := s.global.getRoomByRoleID(roleID)
	if room == nil {
		return false, ErrCloneRoomNotExists
	}

	room.Lock()
	defer room.Unlock()

	places := room.Places()
	for _, place := range places {
		if place.ID == roleID {
			if place.Monster == -1 {
				place.Monster = room.Monsters()[0]
			}
			place.Play = play
			break
		}
	}
	room.SetPlaces(places)

	return true, nil
}

func (s *Service) CheatClearVote(roleID document.ID) (bool, error) {
	room := s.global.getRoomByRoleID(roleID)
	if room == nil {
		return false, ErrCloneRoomNotExists
	}

	room.Lock()
	defer room.Unlock()

	places := room.Places()
	for _, place := range places {
		if place.ID == roleID {
			place.KickLeader = 0
			break
		}
	}
	room.SetPlaces(places)

	return true, nil
}

func (s *Service) CheatPlaceTime(roleID document.ID) (bool, error) {
	room := s.global.getRoomByRoleID(roleID)
	if room == nil {
		return false, ErrCloneRoomNotExists
	}

	room.Lock()
	defer room.Unlock()

	places := room.Places()
	for _, place := range places {
		place.Time = int(util.NowTime()) - GetConfig().CLoneCanKickTime*60
	}
	room.SetPlaces(places)
	return true, nil
}

func (s *Service) CheatResetVote(roleID document.ID) (bool, error) {
	room := s.global.getRoomByRoleID(roleID)
	if room == nil {
		return false, ErrCloneRoomNotExists
	}

	room.Lock()
	defer room.Unlock()
	room.resetVote()

	return true, nil
}

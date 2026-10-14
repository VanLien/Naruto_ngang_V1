// @Time     : 2019/5/14 14:50
// @Author   : cancan
// @File     : service.go
// @Function : 社交服务

package society

import (
	"context"
	"errors"
	"math"
	"sync"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/storage"

	"tjgame/mgo.v2/bson"
)

const Name = "society"

// TODO 大部分方法先写一个单文件后续优化拆分
type Service struct {
	*service.Service

	ctx    context.Context
	cancel context.CancelFunc

	manager *document.Manager
	cache   sync.Map

	storage service.IService

	roleCache *util.LRUCache
	uidCache  map[int]*RoleInfo
}

func (s *Service) Init() bool {
	if ok := s.Service.Init(); !ok {
		return false
	}

	s.ctx, s.cancel = context.WithCancel(context.Background())

	s.roleCache = util.NewLRUCache(SocietyRoleCacheCapacity, nil)
	s.uidCache = make(map[int]*RoleInfo)

	return true
}

func (s *Service) Start() bool {
	opt := s.Option.Base()
	s.storage = s.Container().GetService(storage.GetNameFromDependent(opt.Dependent))

	//f := func(id document.ID) {
	//	s.cache.Delete(id)
	//}

	s.initSociety()

	s.manager = document.NewManager(s.storage, 1000)

	go s.manager.Start()
	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.cancel()
	s.manager.Stop()
}

func (s *Service) initSociety() {
	now := util.Now()
	max := float64(now.Add(util.OneDay * 30).Unix())
	min := float64(now.Add(-util.OneDay * 30).Unix())

	// TODO 处理异常情况
	resp, _ := service.Call(s.storage, "DBReadRangeBy", "Role",
		bson.M{"last_time": []float64{min, max}}, 100,
	)

	response := resp.(storage.Response)
	log.Infof("Role from %d to %d has %d", min, max, len(response.Models))

	for _, v := range response.Models {
		// TODO 判断是否是机器人
		role := NewRole(v.(*scheme.Role))
		s.addRoleCache(role)
	}
}

func (s *Service) OnRoleInfo(roleID document.ID) (bool, error) {
	role := s.getRoleByID(roleID)
	log.Infof("onRoleInfo..........................")
	s.addRoleCache(role)
	return true, nil
}

func (s *Service) RandomFriendList(roleID document.ID) ([]RoleInfo, error) {
	log.Infof("friendList..........................")

	role := s.getRoleByID(roleID)
	society := s.getSocietyByID(role.SocietyDbId())

	log.Infof("roleCache len %d data", s.roleCache.Size())

	roleIDs := make(map[document.ID]bool)
	roleIDs[roleID] = false

	for _, id := range society.Friends() {
		roleIDs[id] = false
	}

	s.roleCache.Range(func(key, value interface{}) bool {
		id := key.(document.ID)
		if _, ok := roleIDs[id]; !ok {
			roleIDs[id] = true
		}
		return true
	}, false)

	ret := []RoleInfo{}
	flag := 0

	// TODO 优化随机性和，目前使用 map 自身 key 不有序的特性来实现
	for id, isShow := range roleIDs {
		if !isShow {
			continue
		}
		roleInfo, _ := s.roleCache.Get(id)
		ret = append(ret, *roleInfo.(*RoleInfo))
		flag++
		if flag >= FriendListMax {
			break
		}
	}

	return ret, nil
}

func (s *Service) FriendSearch(selfRoleID, roleID document.ID, roleName string, roleIDs []document.ID, uid int) ([]RoleInfo, error) {
	log.Infof("friendSearch..........................")
	log.Infof("%s %s %s %v %d", selfRoleID, roleID, roleName, roleIDs, uid)

	if selfRoleID == NilID &&
		roleID == NilID &&
		(roleName == "" || roleName == "None") &&
		roleIDs == nil &&
		uid == 0 {
		return nil, errors.New("param is miss")
	}

	roleSociety := s.getSocietyByRoleID(selfRoleID)
	roleFriendMap := make(map[document.ID]bool)

	for _, v := range roleSociety.Friends() {
		roleFriendMap[v] = true
	}

	ret := []RoleInfo{}

	if roleIDs != nil {
		for _, id := range roleIDs {
			if id == selfRoleID {
				continue
			}

			roleInfo := s.getRoleInfoByID(id)

			if roleInfo != nil {
				ret = append(ret, *roleInfo)
			}
		}

	} else {
		selfRole := s.getRoleByID(selfRoleID)

		if uid != 0 {
			if uid == selfRole.UID() {
				return nil, ErrFriendSearchMyself
			} else {
				roleInfo := s.getRoleInfoByUID(uid)
				if roleInfo != nil {
					if _, ok := roleFriendMap[roleInfo.Id]; !ok {
						ret = append(ret, *roleInfo)
					}
				}
			}
		}

		if roleID != NilID && len(ret) == 0 {
			if roleID == selfRoleID {
				return nil, ErrFriendSearchMyself
			} else {
				roleInfo := s.getRoleInfoByID(roleID)
				if roleInfo != nil {
					if _, ok := roleFriendMap[roleID]; !ok {
						ret = append(ret, *roleInfo)
					}
				}
			}
		}

		if roleName != "" && len(ret) == 0 {
			if roleName == selfRole.Name() {
				return nil, ErrFriendSearchMyself
			} else {
				roleInfos := s.getRoleInfoByName(roleName)
				if roleInfos != nil {
					for _, roleInfo := range roleInfos {
						if roleInfo.Id == selfRoleID {
							continue
						}
						if _, ok := roleFriendMap[roleInfo.Id]; ok {
							continue
						}
						ret = append(ret, *roleInfo)
					}
				}
			}
		}
	}

	if len(ret) == 0 {
		return ret, ErrFriendSearchNoSuchRole
	} else {
		return ret, nil
	}
}

func (s *Service) FriendAskFor(selfRoleID document.ID, roleIDs []document.ID) (map[document.ID][]document.ID, error) {
	log.Infof("FriendAskFor..........................")
	if roleIDs == nil {
		return nil, errors.New("roleIDs is miss")
	}

	role := s.getRoleByID(selfRoleID)
	roleSociety := s.getSocietyByID(role.SocietyDbId())

	roleSocietyMap := make(map[document.ID]bool)

	for _, v := range roleSociety.Friends() {
		roleSocietyMap[v] = true
	}

	ret := make(map[document.ID][]document.ID)

	for _, roleID := range roleIDs {
		if _, ok := roleSocietyMap[roleID]; ok {
			return nil, ErrFriendAlready
		}

		friendSociety := s.getSocietyByRoleID(roleID)

		if len(roleSociety.Friends()) >= FriendsMax {
			return nil, ErrFriendMax
		}

		frs := friendSociety.FriendReqs()

		if len(frs) >= FriendListMax {
			return nil, ErrFriendFriendReqMax
		}

		if s.isInIDSlice(frs, selfRoleID) {
			continue
		}

		frs = append(frs, selfRoleID)
		friendSociety.SetFriendReqs(frs)
		ret[roleID] = friendSociety.FriendReqs()
	}

	return ret, nil
}

func (s *Service) FriendReject(selfRoleID, roleID document.ID, auto bool) ([]document.ID, error) {
	log.Infof("FriendReject..........................")

	if selfRoleID == NilID {
		return nil, errors.New("param is miss")
	}

	roleSociety := s.getSocietyByRoleID(selfRoleID)

	if roleID != NilID {

		if s.isFriend(roleSociety, roleID) {
			return nil, ErrFriendAlready
		}

		s.removeFriendReqs(roleSociety, []document.ID{roleID})
		return roleSociety.FriendReqs(), nil

	} else if auto {

		frs := []document.ID{}
		roleSociety.SetFriendReqs(frs)
		return frs, nil

	} else {
		return nil, errors.New("param is miss")
	}
}

func (s *Service) FriendAccept(selfRoleID, roleID document.ID, auto bool) (map[document.ID]AcceptResp, error) {
	log.Infof("FriendAccept..........................")

	if selfRoleID == NilID {
		return nil, errors.New("param is miss")
	}

	roleSociety := s.getSocietyByRoleID(selfRoleID)

	if roleID != NilID {

		if s.isFriend(roleSociety, roleID) {
			return nil, ErrFriendAlready
		}

		friendSociety := s.getSocietyByRoleID(roleID)

		if len(roleSociety.Friends()) >= FriendListMax {
			return nil, ErrFriendMax
		}

		if len(friendSociety.Friends()) >= FriendListMax {
			return nil, ErrFriendFriendMax
		}

		s.removeFriendReqs(friendSociety, []document.ID{selfRoleID})
		s.removeFriendReqs(roleSociety, []document.ID{roleID})

		s.addFriend(friendSociety, []document.ID{selfRoleID})
		s.addFriend(roleSociety, []document.ID{roleID})

		ret := make(map[document.ID]AcceptResp)

		ret[selfRoleID] = AcceptResp{
			Friends:    roleSociety.Friends(),
			FriendReqs: roleSociety.FriendReqs(),
		}

		ret[roleID] = AcceptResp{
			Friends:    friendSociety.Friends(),
			FriendReqs: friendSociety.FriendReqs(),
		}

		return ret, nil

	} else if auto {

		ret := make(map[document.ID]AcceptResp)

		roleIDs := s.acceptFriendAutoBegin(roleSociety)

		for _, roleID = range roleIDs {
			friendSociety := s.getSocietyByRoleID(roleID)
			s.removeFriendReqs(friendSociety, []document.ID{selfRoleID})
			s.addFriend(friendSociety, []document.ID{selfRoleID})

			ret[roleID] = AcceptResp{
				Friends:    friendSociety.Friends(),
				FriendReqs: friendSociety.FriendReqs(),
			}
		}

		s.removeFriendReqs(roleSociety, roleIDs)
		s.addFriend(roleSociety, roleIDs)
		ret[selfRoleID] = AcceptResp{
			Friends:    roleSociety.Friends(),
			FriendReqs: roleSociety.FriendReqs(),
		}

		return ret, nil

	} else {
		return nil, errors.New("param is miss")
	}
}

func (s *Service) FriendDelete(selfRoleID, roleID document.ID) (map[document.ID][]document.ID, error) {
	log.Infof("FriendDelete..........................")
	if selfRoleID == NilID || roleID == NilID {
		return nil, errors.New("roleID is miss")
	}

	roleSociety := s.getSocietyByRoleID(selfRoleID)

	flag := false
	for _, v := range roleSociety.Friends() {
		if v == roleID {
			flag = true
		}
	}

	if !flag {
		return nil, ErrFriendNone
	}

	friendSociety := s.getSocietyByRoleID(roleID)

	s.removeFriends(roleSociety, []document.ID{roleID})
	s.removeFriends(friendSociety, []document.ID{selfRoleID})

	ret := make(map[document.ID][]document.ID)

	ret[selfRoleID] = roleSociety.Friends()
	ret[roleID] = friendSociety.Friends()

	return ret, nil
}

func (s *Service) BlacklistAdd(selfRoleID, roleID document.ID) ([]document.ID, error) {
	log.Infof("BlacklistAdd..........................")
	if selfRoleID == NilID || roleID == NilID {
		return nil, errors.New("roleID is miss")
	}

	if selfRoleID == roleID {
		return nil, errors.New("cant add self")
	}

	roleSociety := s.getSocietyByRoleID(selfRoleID)
	blacklist := roleSociety.BlackList()

	for _, v := range blacklist {
		if v == roleID {
			return nil, ErrSocietyBlackListHasAdd
		}
	}

	blacklist = append(blacklist, roleID)
	roleSociety.SetBlackList(blacklist)

	return roleSociety.BlackList(), nil
}

func (s *Service) BlacklistRemove(selfRoleID, roleID document.ID) ([]document.ID, error) {
	log.Infof("BlacklistRemove..........................")
	if selfRoleID == NilID || roleID == NilID {
		return nil, errors.New("roleID is miss")
	}

	if selfRoleID == roleID {
		return nil, errors.New("cant add self")
	}

	roleSociety := s.getSocietyByRoleID(selfRoleID)
	blacklist := roleSociety.BlackList()

	for i, v := range blacklist {
		if v == roleID {
			blacklist = append(blacklist[:i], blacklist[i+1:]...)
			roleSociety.SetBlackList(blacklist)
			return roleSociety.BlackList(), nil
		}
	}

	return nil, ErrSocietyBlackListNoThis
}

func (s *Service) FriendStaminaSend(selfRoleID, roleID document.ID, auto bool, DailySend []document.ID) (StaminaSendResp, error) {
	log.Infof("FriendStaminaSend..........................")
	ret := StaminaSendResp{}

	if selfRoleID == NilID {
		return ret, errors.New("param is miss")
	}

	roleSociety := s.getSocietyByRoleID(selfRoleID)
	ret.FriendStaminaRecv = make(map[document.ID][]document.ID)

	if roleID != NilID {
		if !s.isFriend(roleSociety, roleID) {
			return ret, ErrFriendNone
		}
		friendSociety := s.getSocietyByRoleID(roleID)

		if len(DailySend) >= FriendSendStaminaTimesMax {
			return ret, ErrFriendStaminaSendMax
		}

		if !s.isInIDSlice(DailySend, roleID) {
			DailySend = append(DailySend, roleID)
			ret.DailySend = DailySend
			ret.Send = FriendSendStamina
		}

		fsr := friendSociety.StaminaRecv()
		if !s.isInIDSlice(fsr, selfRoleID) {
			fsr = append(fsr, selfRoleID)
			friendSociety.SetStaminaRecv(fsr)
			ret.FriendStaminaRecv[roleID] = friendSociety.StaminaRecv()
		}

		return ret, nil

	} else if auto {
		size := FriendSendStaminaTimesMax - len(DailySend)

		sendMap := make(map[document.ID]bool)
		for _, v := range DailySend {
			sendMap[v] = true
		}

		sendCount := 0

		for _, roleID = range roleSociety.Friends() {
			if size == 0 {
				break
			}
			if _, ok := sendMap[roleID]; ok {
				continue
			}

			friendSociety := s.getSocietyByRoleID(roleID)
			fsr := friendSociety.StaminaRecv()
			fsr = append(fsr, selfRoleID)
			friendSociety.SetStaminaRecv(fsr)
			ret.FriendStaminaRecv[roleID] = friendSociety.StaminaRecv()

			DailySend = append(DailySend, roleID)

			sendCount++
			size--
		}

		ret.DailySend = DailySend
		ret.Send = sendCount * FriendSendStamina

		return ret, nil

	} else {
		return ret, errors.New("param is miss'")
	}

}

func (s *Service) FriendStaminaRecv(selfRoleID, roleID document.ID, auto bool, DailyGain int) (StaminaRecvResp, error) {
	log.Infof("FriendStaminaRecv..........................")
	ret := StaminaRecvResp{}

	if selfRoleID == NilID {
		return ret, errors.New("param is miss")
	}

	role := s.getRoleByID(selfRoleID)
	roleSociety := s.getSocietyByID(role.SocietyDbId())

	if role.Stamina() >= StaminaLimitMax {
		return ret, ErrStaminaCanNotGive
	}

	if roleID != NilID {
		if !s.isFriend(roleSociety, roleID) {
			return ret, ErrFriendNone
		}

		if DailyGain >= FriendRecvStaminaTimesMax {
			return ret, ErrFriendStaminaRecvMax
		}

		if !s.isInIDSlice(roleSociety.StaminaRecv(), roleID) {
			return ret, ErrFriendStaminaNone
		}

		role.SetStamina(role.Stamina() + FriendSendStamina)
		DailyGain++

		sr := roleSociety.StaminaRecv()
		for i, v := range sr {
			if v == roleID {
				sr = append(sr[:i], sr[i+1:]...)
				roleSociety.SetStaminaRecv(sr)
				break
			}
		}

		ret.StaminaRecv = roleSociety.StaminaRecv()
		ret.DailyGain = DailyGain
		ret.Recv = FriendSendStamina

		return ret, nil

	} else if auto {
		size := FriendRecvStaminaTimesMax - DailyGain
		sr := roleSociety.StaminaRecv()
		srLen := len(sr)
		if size > srLen {
			size = srLen
		}

		limitCount := int(math.Ceil((float64(StaminaLimitMax-role.Stamina()) / FriendSendStamina)))

		if size > limitCount {
			size = limitCount
		}

		ret.Recv = FriendSendStamina * size

		role.SetStamina(role.Stamina() + ret.Recv)
		DailyGain = DailyGain + size
		sr = sr[:srLen-size]
		roleSociety.SetStaminaRecv(sr)

		ret.DailyGain = DailyGain
		ret.StaminaRecv = sr

		return ret, nil

	} else {
		return ret, errors.New("param is miss")
	}
}

func (s *Service) addRoleCache(role *Role) *RoleInfo {

	if role == nil {
		return nil
	}

	model := &RoleInfo{
		Id:                  role.GetID(),
		Uid:                 role.UID(),
		Name:                role.Name(),
		LastTime:            role.LastTime(),
		Logo:                role.Logo(),
		Frame:               role.Frame(),
		Level:               role.Level(),
		VipLevel:            role.VipLevel(),
		PvpRecordDbId:       role.PvpRecordDbId(),
		SocietyDbId:         role.SocietyDbId(),
		BattleFightingPoint: role.BattleFightingPoint(),
		TalentTrees:         role.TalentTrees(),
		PersonalSign:        role.PersonalSign(),
	}

	// TODO 处理机器人，不加入 roleCache

	s.roleCache.Set(role.GetID(), model)
	s.uidCache[role.UID()] = model

	return model
}

func (s *Service) getRoleByID(id document.ID) *Role {
	if v, ok := s.cache.Load(id); ok {
		return v.(*Role)
	}
	resp, err := service.Call(s.storage, "DBRead", "Role", id, false)
	if err != nil {
		panic(err)
	}

	response := resp.(storage.Response)
	if !response.Ret || response.Model == nil {
		return nil
	}

	role := NewRole(response.Model.(*scheme.Role))
	role.SetDirty()
	s.cache.Store(id, role)
	return role
}

func (s *Service) getSocietyByRoleID(id document.ID) *Society {
	return s.getSocietyByID(s.getRoleByID(id).SocietyDbId())
}

func (s *Service) getSocietyByID(id document.ID) *Society {
	if v, ok := s.cache.Load(id); ok {
		return v.(*Society)
	}
	resp, err := service.Call(s.storage, "DBRead", "Society", id, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	if !response.Ret || response.Model == nil {
		return nil
	}

	society := NewSociety(response.Model.(*scheme.Society))
	society.SetDirty()
	s.cache.Store(id, society)
	return society
}

func (s *Service) getFriendByUID(uid int) *RoleInfo {
	return s.uidCache[uid]
}

func (s *Service) getRoleInfoByUID(uid int) *RoleInfo {
	if uid == 0 {
		return nil
	}

	roleInfo := s.getFriendByUID(uid)
	if roleInfo != nil {
		return roleInfo
	}

	resp, err := service.Call(s.storage, "DBReadBy", "Role", bson.M{"uid": uid})
	if err != nil {
		panic(err)
	}

	response := resp.(storage.Response)
	if !response.Ret || len(response.Models) == 0 {
		return nil
	}

	role := NewRole(response.Models[0].(*scheme.Role))
	role.SetDirty()

	return s.addRoleCache(role)
}

func (s *Service) getRoleInfoByID(roleID document.ID) *RoleInfo {
	if roleID == NilID {
		return nil
	}

	v, ok := s.roleCache.Get(roleID)
	if ok {
		return v.(*RoleInfo)
	}

	resp, err := service.Call(s.storage, "DBRead", "Role", roleID, true)
	if err != nil {
		panic(err)
	}

	response := resp.(storage.Response)
	if !response.Ret || response.Model == nil {
		return nil
	}

	role := NewRole(response.Model.(*scheme.Role))
	role.SetDirty()

	return s.addRoleCache(role)
}

func (s *Service) getRoleInfoByName(roleName string) []*RoleInfo {
	if roleName == "" {
		return nil
	}

	// TODO 添加内存查找
	resp, err := service.Call(s.storage, "DBReadByPattern", "Role",
		bson.M{"name": bson.RegEx{roleName, "i"}}, FriendListMax)

	if err != nil {
		panic(err)
	}

	response := resp.(storage.Response)
	if !response.Ret || len(response.Models) == 0 {
		return nil
	}

	ret := []*RoleInfo{}

	for _, v := range response.Models {
		role := NewRole(v.(*scheme.Role))
		role.SetDirty()
		ret = append(ret, s.addRoleCache(role))
	}

	return ret
}

func (s *Service) isFriend(society *Society, id document.ID) bool {
	return s.isInIDSlice(society.Friends(), id)
}

func (s *Service) removeFriendReqs(society *Society, ids []document.ID) {
	frs := society.FriendReqs()

	checkIds := make(map[document.ID]bool)

	for _, v := range ids {
		checkIds[v] = true
	}

	oldLen := len(frs)
	l := oldLen
	i := 0

	for i < l {
		if checkIds[frs[i]] {
			frs = append(frs[:i], frs[i+1:]...)
			l--
		} else {
			i++
		}

	}

	if len(frs) != oldLen {
		society.SetFriendReqs(frs)
	}
}

func (s *Service) removeFriends(society *Society, ids []document.ID) {
	fs := society.Friends()

	checkIds := make(map[document.ID]bool)

	for _, v := range ids {
		checkIds[v] = true
	}

	oldLen := len(fs)
	l := oldLen
	i := 0

	for i < l {
		if checkIds[fs[i]] {
			fs = append(fs[:i], fs[i+1:]...)
			l--
		} else {
			i++
		}

	}

	if len(fs) != oldLen {
		society.SetFriends(fs)
	}
}

func (s *Service) addFriend(society *Society, ids []document.ID) {
	fs := society.Friends()

	checkIds := make(map[document.ID]bool)

	for _, v := range ids {
		checkIds[v] = true
	}

	oldLen := len(fs)

	for _, v := range fs {
		if _, ok := checkIds[v]; !ok {
			checkIds[v] = false
		}
	}

	for k, v := range checkIds {
		if v {
			fs = append(fs, k)
		}
	}

	if len(fs) != oldLen {
		society.SetFriends(fs)
	}
}

func (s *Service) acceptFriendAutoBegin(society *Society) []document.ID {
	ret := []document.ID{}

	if len(society.Friends()) >= FriendListMax {
		return ret
	}

	friendMap := make(map[document.ID]bool)

	for _, v := range society.Friends() {
		friendMap[v] = true
	}

	for _, roleID := range society.FriendReqs() {
		if _, ok := friendMap[roleID]; !ok {
			ret = append(ret, roleID)
		}
	}

	return ret
}

func (s *Service) isInIDSlice(ids []document.ID, id document.ID) bool {
	for _, v := range ids {
		if v == id {
			return true
		}
	}
	return false
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}

	s.Register(s, "OnRoleInfo")
	s.Register(s, "RandomFriendList")
	s.Register(s, "FriendSearch")
	s.Register(s, "FriendAskFor")
	s.Register(s, "FriendReject")
	s.Register(s, "FriendAccept")
	s.Register(s, "FriendDelete")
	s.Register(s, "BlacklistAdd")
	s.Register(s, "BlacklistRemove")
	s.Register(s, "FriendStaminaSend")
	s.Register(s, "FriendStaminaRecv")

	// TODO 测试用
	s.Register(s, "FriendInit")

	return s
}

func (s *Service) FriendInit(roleID document.ID) (map[document.ID][]document.ID, error) {
	log.Info("FriendInit..........................")

	roleSociety := s.getSocietyByRoleID(roleID)
	roleSociety.SetFriendReqs([]document.ID{})
	roleSociety.SetBlackList([]document.ID{})

	ret := make(map[document.ID][]document.ID)

	fs := roleSociety.Friends()

	for _, v := range fs {
		friendSociety := s.getSocietyByRoleID(v)
		s.removeFriends(friendSociety, []document.ID{roleID})
		ret[friendSociety.RoleDbId()] = friendSociety.Friends()
	}

	roleSociety.SetFriends([]document.ID{})
	roleSociety.SetStaminaRecv([]document.ID{})

	return ret, nil
}

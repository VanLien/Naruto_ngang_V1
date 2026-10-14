package union

import (
	"errors"
	"strings"
	"sync"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/services/storage"
	"tjgame/ugorji_go/codec"

	"tjgame/mgo.v2/bson"

	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
)

const (
	Name = "union"

	// 公会中地位定义
	NonePlace         = 0 //  非成员
	MemberPlace       = 1 // 成员
	ViceChairmanPlace = 2 // 副主席
	ChairmanPlace     = 3 //主席

	// 加入公会审批方式
	ApproveJoin = 0 // 审批加入
	DirectJoin  = 1 // 直接加入
	RefuseJoin  = 2 // 拒绝加入

	// 公会功能
	TrainingCenter = "training"  // 训练中心
	UnionFuben     = "fuben"     // 公会副本
	UnionRedPacket = "redpacket" // 公会红包

	// 公会历史
	HistoryDirect  = 1 // name1加入公会
	HistoryQuit    = 2 // name1退出公会
	HistoryKick    = 3 // name1被name2踢出公会
	HistoryPromote = 4 // name1晋级为副会长
	HistoryDemote  = 5 // name1降级为会员
	HistorySwap    = 6 // name2转让会长给name1
	HistoryChoose  = 7 // name1被选拔为新任会长
	HistoryAccept  = 8 // name2批准nname1加入公会

	JoinedStatus  = "joined"
	PendingStatus = "pending"

	// 公会红包类型 type
	RedPacketGold  = 0
	RedPacketRMB   = 1
	RedPacketCoin3 = 2

	// 公会红包标记 flag
	RedPacketFlagRole = 0 // 玩家红包
	RedPacketFlagSys  = 1 // 系统红包

	// 公会历史最大条数
	HistoryMax = 100
	// 公会申请记录最长保留时间
	JoinDiscardDuration = 12 * time.Hour
	// 公会会长最长连续不上线时间
	ChairmanNoLoginMaxDuration = 5 * util.OneDay
	// 公会会长候选者最长连续不上线时间
	CandidateNoLoginMaxDuration = 3 * util.OneDay
	// 公会创建后多久可以转让会长
	ChairmanSwapMaxDuration = util.OneDay
	// 公会训练所加速与被加速上限
	TrainingSpeedUpMax = 6
	// 公会训练所加速经验倍率
	TrainingSpeedUpExpFix = 480
	// 公会系统红包刷新时间点
	RedPacketRefreshHour = 19
	// 公会玩家红包维持时间
	RoleRedPacketDuration = util.OneDay
	// 公会列表排序内存刷新间隔
	ListResortDuration = 5 * time.Minute
)

var (
	ErrUnionNameDuplicated     = errors.New("unionNameDuplicated")
	ErrUnionNotExisted         = errors.New("unionNotExisted")
	ErrUnionRefuseJoin         = errors.New("unionRefuseJoin")
	ErrUnionAlreadyIn          = errors.New("unionAlreadyIn(exist)")
	ErrUnionAlreadyInOther     = errors.New("unionRoleAlreadyInOther")
	ErrUnionNotMember          = errors.New("not member")
	ErrUnionMemberMax          = errors.New("unionMemberMax")
	ErrUnionNoPermission       = errors.New("unionNoPrivilege")
	ErrUnionOnlyChairman       = errors.New("unionOnlyChairman")
	ErrUnionLevelLess          = errors.New("union level not enough")
	ErrUnionChairmanCanNotQuit = errors.New("unionChairmanCanNotQuit")
	ErrUnionRoleJoinCancel     = errors.New("unionRoleJoinCancel")
	ErrUnionViceChairmanMax    = errors.New("unionViceChairmanMax")
	ErrUnionNotInMembers       = errors.New("unionCanNotHandleNonMember")
	ErrUnionRoleLevelNotEnough = errors.New("unionLevelNotEnough")
	ErrUnionDestroyed          = errors.New("union destroyed")
	ErrUnionNotInTime          = errors.New("unionNotInTime")

	ErrUnionFubenNoOpened = errors.New("unionFubenNoOpened")
	ErrUnionFubenPassed   = errors.New("unionFubenPassed")

	ErrUnionTrainingNotInTime       = errors.New("unionTrainNotInTime")
	ErrUnionTrainingSlotNotOpen     = errors.New("unionTrainSlotNotOpen")
	ErrUnionTrainingCardYetInTraing = errors.New("unionTrainCardYetInTrain")
	ErrUnionTrainingSlotBeTrain     = errors.New("unionTrainSlotBeTrain")
	ErrUnionTrainingCardNotExisted  = errors.New("unionTrainCardNotExisted")
	ErrUnionTrainingBeSpeedUpMax    = errors.New("unionTrainSpeedUpMax")

	ErrUnionRedPacketNoRemain   = errors.New("redPacketNoRemain")
	ErrUnionRedPacketNotExist   = errors.New("redPacketNotExist")
	ErrUnionRedPacketAlreadyRob = errors.New("redPacketAlreadyRob")
	ErrUnionRedPacketRobLimit   = errors.New("redPacketRoleRobLimit")

	ErrUnionChairmanSwapTimeLimit = errors.New("union chairman swap time limit")

	// 公会副本奖励时间点 hour, minute
	FubenAwardTime = []int{23, 30}
	// 公会副本重置时间点
	FubenResetHour = 5
	// 公会副本周期重置WeekDay
	FubenResetWeakDay = []int{1, 3, 5}
	// 公会副本周期奖励WeekDay
	FubenAwardWeakDay = []int{2, 4, 6}
)

type Service struct {
	*service.Service
	builder *builder

	unions Unions

	roleUnion sync.Map // {Role.id: Union.id}

	acceptLock sync.Mutex // for create, accept, fastjoin, join(maybe directjoin)

	// dependent service
	storage service.IService

	// union resort timer
	resortTimer *time.Timer
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
	s.builder = &builder{Builder: document.NewBuilder(s.storage)}

	st := time.Now()

	// load all unions
	resp, err := service.Call(s.storage, "DBReadAll", "Union")
	if err != nil {
		return false
	}
	response := resp.(storage.Response)
	discards := make([]document.ID, 0, 8)
	valid := 0
	_, _, area := service.SplitServiceName(s.Name())
	for _, m := range response.Models {
		model := m.(*scheme.Union)
		if len(model.Members) == 0 {
			discards = append(discards, model.ID)
			log.Infof("union %v uid %d no members, will be delete", model.ID, model.UID)
			continue
		}
		valid++
		response.Model = m
		union := s.builder.NewUnion(&response, true)
		if union.Area() == 0 {
			union.SetArea(area)
		}
		s.unions.onCreate(union)
		for _, member := range union.Members() {
			if actual, loaded := s.roleUnion.LoadOrStore(member.ID, union.GetID()); loaded {
				log.Warningf("role %v already exist union %s, %s", member.ID, actual.(document.ID), union.GetID())
			}
		}
	}
	s.unions.init()
	log.Infof("load unions done, count %d", valid)

	for _, id := range discards {
		service.Call(s.storage, "DBDelete", "Union", id, false)
	}

	// load union trainings
	s.loadUnionTraining()

	// load union fuben
	s.unions.Range(func(key, value interface{}) bool {
		union := value.(*Union)
		if fuben, err := s.builder.CreateUnionFuben(s.storage, union); err == nil {
			union.fuben = fuben
		} else {
			log.Errorf("load union %v fuben error: %v", union.GetID(), err)
		}
		return true
	})

	// load all union redpacket
	if !s.loadUnionRedPacket() {
		return false
	}

	elapse := time.Now().Sub(st)
	log.Infof("loading unions cost %dms", elapse/time.Millisecond)

	s.resortTimer = time.AfterFunc(ListResortDuration, service.FuncWithRecover(s, func() {
		s.unions.reSort()
		s.resortTimer.Reset(ListResortDuration)
	}))

	return s.Service.Start()
}

func (s *Service) Stop() {
	if s.resortTimer != nil {
		s.resortTimer.Stop()
	}

	s.Service.Stop()
	s.builder.Stop()
	service.Call(s.storage, "DBCommit", true, true)
}

func (s *Service) loadUnionTraining() {
	members := make([]document.ID, 0, 1024)
	s.unions.Range(func(key, value interface{}) bool {
		union := value.(*Union)
		for _, member := range union.Members() {
			members = append(members, member.ID)
		}
		return true
	})
	resp, err := service.Call(s.storage, "DBReadIn", "UnionTraining", "role_db_id", members)
	if err != nil {
		log.Errorf("DBReadIn UnionTraining error %v", err)
		return
	}
	response := resp.(storage.Response)
	trainings := make(map[document.ID]*Training)
	for _, model := range response.Models {
		response.Model = model
		training := s.builder.NewUnionTraining(&response)
		trainings[training.RoleDbId()] = training
	}
	s.unions.Range(func(key, value interface{}) bool {
		union := value.(*Union)
		for _, member := range union.Members() {
			if training, ok := trainings[member.ID]; ok {
				union.camp.add(member.ID, training)
			}
		}
		return true
	})
	log.Infof("load union training count %d", len(trainings))
}

func (s *Service) loadUnionRedPacket() bool {
	// load all union redpacket
	resp, err := service.Call(s.storage, "DBReadAll", "UnionRedPacket")
	if err != nil {
		log.Errorf("load all UnionRedPacket error %v", err)
		return false
	}
	isCanDiscard := func(m *scheme.UnionRedPacket, time float64) bool {
		if m.DiscardFlag {
			return true
		}
		if m.PacketFlag == RedPacketFlagRole && time-m.CreatedTime >= RoleRedPacketDuration.Seconds() {
			return true
		}
		if s.unions.GetUnion(m.UnionDbId) == nil {
			return true
		}
		return false
	}
	response := resp.(storage.Response)
	now := util.NowTime()
	used := 0
	freeIDs := make([]document.ID, 0, 8)
	for _, m := range response.Models {
		model := m.(*scheme.UnionRedPacket)
		if isCanDiscard(model, now) {
			freeIDs = append(freeIDs, model.ID)
		} else {
			response.Model = m
			packet := s.builder.NewRedPacket(&response)
			union := s.unions.GetUnion(packet.UnionDbId())
			union.redpackets.addPacket(packet)
			used++
		}
	}
	FreePacketList.Init(freeIDs)
	log.Infof("RedPacket Used: %d, Free: %d", used, len(freeIDs))

	// check union system redpacket
	s.unions.Range(func(key, value interface{}) bool {
		union := value.(*Union)
		if !union.redpackets.hasSysPacket() {
			log.Warningf("Union %v has no sysRedPacket", union.GetID())
			if err := union.redpackets.createSysPackets(s.builder, s.storage, union.GetID()); err != nil {
				log.Warningf("create union %v sysRedPacket error %v", union.GetID(), err)
			}
		}
		return true
	})
	return true
}

func (s *Service) getLockedUnion(unionID document.ID) (*Union, error, *scheme.Union, func()) {
	union := s.unions.GetUnion(unionID)
	if union == nil {
		return nil, ErrUnionNotExisted, nil, nil
	}
	db, unlock := union.LockAndGetDB()
	return union, nil, db, unlock
}

type UnionResponse struct {
	Model map[string]document.IDocument `codec:"model,omitempty"`
	Sync  struct {
		Union codec.Raw `codec:"union,omitempty"`
		Role  *GameRole `codec:"role,omitempty"`
		// 训练所累计经验
		CardExp map[document.ID]int `codec:"card_exp,omitempty"`
	} `codec:"sync,omitempty"`
	View interface{} `codec:"view,omitempty"`

	Time int64 `codec:"time"`
}

func NewUnionResponse() *UnionResponse {
	return &UnionResponse{Time: util.Now().Unix()}
}

type GameRole struct {
	UnionDBID     *document.ID  `codec:"union_db_id"`
	UnionPlace    int           `codec:"union_place"`
	UnionJoinQue  []document.ID `codec:"union_join_que"`
	UnionJoinTime float64       `codec:"union_join_time"`

	RolePacketCanRob bool `codec:"union_role_packet_can_rob"`
	SysPacketCanRob  bool `codec:"union_sys_packet_can_rob"`
}

func (s *Service) GetCacheModel() ([]*scheme.UnionObject, error) {
	resp := make([]*scheme.UnionObject, 0, s.unions.total)
	s.unions.Range(func(key, value interface{}) bool {
		union := value.(*Union)
		resp = append(resp, union.UnionObject)
		return true
	})
	return resp, nil
}

func (s *Service) GetUnionModel(id document.ID) (*scheme.UnionObject, error) {
	union, err, _, unlock := s.getLockedUnion(id)
	if err != nil {
		return nil, err
	}
	defer unlock()
	return union.UnionObject, nil
}

// 玩家登录
func (s *Service) OnLogin(roleID document.ID, role scheme.UnionMemberRole, joinQue []document.ID) (resp UnionResponse, err error) {
	var unionID document.ID

	if id, ok := s.roleUnion.Load(roleID); ok {
		unionID = id.(document.ID)
	}
	if unionID == "" {
		role := &GameRole{
			UnionDBID:     nil,
			UnionPlace:    NonePlace,
			UnionJoinQue:  s.unions.GetJoinQue(roleID, joinQue),
			UnionJoinTime: 0,
		}
		resp.Sync.Role = role
	} else {
		union := s.unions.GetUnion(unionID)
		if union == nil {
			return resp, ErrUnionNotExisted
		}
		_, unlock := union.LockAndGetDB()
		defer unlock()

		union.UpdateMember(role, util.NowTime())
		union.SynchronReset()

		resp.Model = map[string]document.IDocument{"union": union.Model()}
		resp.Sync.Role = union.GameRoleSync(role.ID)
		training := union.camp.GetTraining(role.ID)
		if training != nil {
			training.RefreshToOffline(TrainingExpPerMinute(role.Level, union.Level()))
			resp.Sync.CardExp = training.SyncExp()
			resp.View = training.GetCards()
		}
	}
	resp.Time = util.Now().Unix()
	return
}

// 更新公会成员数据以及加入列表的数据
func (s *Service) RefreshUnionMember(role scheme.UnionMemberRole, unionID *document.ID, joinQue []document.ID, lastTime float64) (bool, error) {
	if unionID != nil {
		union := s.unions.GetUnion(*unionID)
		if union != nil {
			_, unlock := union.LockAndGetDB()
			defer unlock()
			union.UpdateMember(role, lastTime)
		}
	} else {
		for _, unionID := range joinQue {
			union := s.unions.GetUnion(unionID)
			if union != nil {
				_, unlock := union.LockAndGetDB()
				util.WithDefer(func() {
					union.UpdateJoinNotes(role)
				}, unlock)
			}
		}
	}
	return true, nil
}

// 进入公会界面
func (s *Service) MainGet(unionID document.ID, roleID document.ID, role scheme.UnionMemberRole) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	place := union.rolePlace(roleID)
	if place == NonePlace {
		return nil, ErrUnionNotMember
	}

	union.UpdateMember(role, util.NowTime())

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	resp.Sync.Role = union.GameRoleSync(role.ID)
	training := union.camp.GetTraining(role.ID)
	if training != nil {
		training.RefreshToOffline(TrainingExpPerMinute(role.Level, union.Level()))
		resp.Sync.CardExp = training.SyncExp()
	}
	return resp, nil
}

// 创建公会
func (s *Service) Create(model *scheme.Union, role scheme.UnionMemberRole) (*UnionResponse, error) {
	resp, err := service.Call(s.storage, "DBCreate", model.CollectionName(), model)
	if err != nil {
		if strings.Index(err.Error(), "duplicate key error") >= 0 {
			err = ErrUnionNameDuplicated
		}
		return nil, err
	}
	response := resp.(storage.Response)
	s.acceptLock.Lock()
	defer s.acceptLock.Unlock()

	union := s.builder.NewUnion(&response, false)
	_, unlock := union.LockAndGetDB()

	//union.SetIntro(fmt.Sprintf("欢迎来到 %s，让我们一起建设新家园～", model.Name))
	_ = union.DirectJoin(role)
	union.Refresh()

	s.roleUnion.Store(role.ID, union.GetID())

	if fuben, err := s.builder.CreateUnionFuben(s.storage, union); err == nil {
		union.fuben = fuben
	} else {
		log.Errorf("create union %v fuben error", union.GetID(), err)
	}

	unlock()
	// reSort内部获取每个union有加锁
	s.unions.CancelJoin(role.ID)
	s.unions.onCreate(union)
	s.unions.reSort()
	_, unlock = union.LockAndGetDB()
	defer unlock()

	// 创建固定的公会系统红包
	err = union.redpackets.createSysPackets(s.builder, s.storage, union.GetID())
	if err != nil {
		log.Errorf("create union %v sysRedPacket error %v", union.GetID(), err)
	}
	union.SynchronReset()

	ret := NewUnionResponse()
	ret.Model = map[string]document.IDocument{"union": union.Model()}
	ret.Sync.Role = union.GameRoleSync(role.ID)
	training := union.camp.GetTraining(role.ID)
	if training != nil {
		training.RefreshToOffline(TrainingExpPerMinute(role.Level, union.Level()))
		ret.Sync.CardExp = training.SyncExp()
	}
	return ret, nil
}

// 公会解散
func (s *Service) Dissolve(unionID document.ID, roleID document.ID) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}

	name := union.CollectionName()
	fubenID := union.fuben.GetID()
	fubenName := union.fuben.CollectionName()
	util.WithDefer(func() {
		if roleID != union.ChairmanDbId() {
			err = ErrUnionOnlyChairman
			return
		}
		if len(union.Members()) > 1 {
			err = errors.New("not alone can not destory")
			return
		}
		union.Dissolve()
	}, unlock)
	if err != nil {
		return nil, err
	}

	// reSort内部获取每个union有加锁
	s.unions.onDissolve(unionID)
	s.unions.reSort()

	s.roleUnion.Delete(roleID)

	_, err = service.Call(s.storage, "DBDelete", name, unionID, false)
	if err != nil {
		log.Warningf("DBDelete %s:%v error %s", name, unionID, err)
	}
	_, err = service.Call(s.storage, "DBDelete", fubenName, fubenID, false)
	if err != nil {
		log.Warningf("DBDelete %s:%v error %s", fubenName, fubenID, err)
	}

	return nil, nil
}

// 公会列表(以日捐献排行)
func (s *Service) List(offset, size int) ([]SlimModel, error) {
	models := s.unions.GetDayContribRankList(offset, size)
	return models, nil
}

// 公会排行(以总捐献排行)
func (s *Service) GetRankList(offset, size int) ([]SlimModel, error) {
	models := s.unions.GetContribRankList(offset, size)
	return models, nil
}

// 公会检索
type unionQuery struct {
	ID   document.ID `codec:"id,omitempty"`
	Name string      `codec:"name,omitempty"`
	UID  int         `codec:"uid,omitempty"`
}

func (s *Service) Find(query unionQuery) ([]SlimModel, error) {
	models := make([]SlimModel, 0, 1)
	if query.ID != "" {
		union := s.unions.GetUnion(query.ID)
		if union != nil {
			models = append(models, *union.slimModelLocked())
		}
	}
	if query.UID > 0 {
		union := s.unions.GetUnionByUID(query.UID)
		if union != nil {
			models = append(models, *union.slimModelLocked())
		}
	}
	if query.Name != "" {
		unions := s.unions.FindByName(query.Name)
		for _, u := range unions {
			models = append(models, *u.slimModelLocked())
		}
	}
	return models, nil
}

// 申请加入公会
func (s *Service) Join(unionID document.ID, role scheme.UnionMemberRole, cancelUnionID *document.ID) (*UnionResponse, error) {
	s.acceptLock.Lock()
	defer s.acceptLock.Unlock()
	if _, ok := s.roleUnion.Load(role.ID); ok {
		return nil, ErrUnionAlreadyIn
	}

	if cancelUnionID != nil {
		if union := s.unions.GetUnion(*cancelUnionID); union != nil {
			_, unlock := union.LockAndGetDB()
			util.WithDefer(func() {
				union.CancelJoin(role.ID)
			}, unlock)
		}
	}

	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	if union.JoinType() == RefuseJoin {
		return nil, ErrUnionRefuseJoin
	}
	if union.JoinLevel() > role.Level {
		return nil, ErrUnionRoleLevelNotEnough
	}
	status, err := union.InsertJoin(role)
	if err != nil {
		return nil, err
	}

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	if status == JoinedStatus {
		s.roleUnion.Store(role.ID, union.GetID())

		resp.Sync.Role = union.GameRoleSync(role.ID)
		resp.View = "joined"
		return resp, err
	}
	resp.View = "pending"
	return resp, nil
}

// 取消加入公会
func (s *Service) JoinCancel(unionID document.ID, roleID document.ID) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	union.CancelJoin(roleID)

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	return resp, nil
}

// 会长或副会长批准入会
func (s *Service) JoinAccept(unionID, roleID, who document.ID) (*UnionResponse, error) {
	s.acceptLock.Lock()
	defer s.acceptLock.Unlock()

	actual, existed := s.roleUnion.Load(who)
	if existed {
		s.unions.CancelJoin(who)
		if actual.(document.ID) != unionID {
			return nil, ErrUnionAlreadyInOther
		} else {
			return nil, ErrUnionAlreadyIn
		}
	}

	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	err = union.AccpetJoin(who, roleID)
	if err != nil {
		return nil, err
	}
	s.roleUnion.Store(who, unionID)

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	return resp, nil
}

// 会长或副会长拒绝入会
func (s *Service) JoinRefuse(unionID, roleID, who document.ID) (*UnionResponse, error) {
	if actual, ok := s.roleUnion.Load(who); ok {
		if actual.(document.ID) == unionID {
			return nil, ErrUnionAlreadyIn
		}
	}

	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	union.RefuseJoin(who)

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	return resp, nil
}

// 会长或副会长拒绝入会
func (s *Service) JoinRefuseAll(unionID, handler document.ID) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	union.RefuseJoinAll()

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	return resp, nil
}

// 玩家退会
func (s *Service) Quit(unionID, roleID document.ID) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	err = union.QuitMember(roleID)
	if err != nil {
		return nil, err
	}

	s.roleUnion.Delete(roleID)

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	return resp, nil
}

// 会长或副会长踢人
func (s *Service) Kick(unionID, roleID, who document.ID) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	err = union.KickMember(who, roleID)
	if err != nil {
		return nil, err
	}
	s.roleUnion.Delete(who)

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	return resp, nil
}

// 会长提拔会员为副会长
func (s *Service) ChairmanPromote(unionID, roleID, who document.ID) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	err = union.PromoteMember(who, roleID)
	if err != nil {
		return nil, err
	}

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	return resp, nil
}

// 会长将副会长降级为成员
func (s *Service) ChairmanDemote(unionID, roleID, who document.ID) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	err = union.DemoteMember(who, roleID)
	if err != nil {
		return nil, err
	}

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	return resp, nil
}

// 会长转让
func (s *Service) ChairmanSwap(unionID, roleID, who document.ID, sync bool) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	resp := NewUnionResponse()
	util.WithDefer(func() {
		resp.View, err = union.SwapChairman(roleID, who)
		if err != nil {
			return
		}
		if sync {
			resp.Sync.Union = union.Synchron()
		}
	}, unlock)

	s.unions.refreshSlimModels()
	return resp, nil
}

// 公会修改公告
func (s *Service) ModifyIntro(unionID, roleID document.ID, intro string, sync bool) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	resp := NewUnionResponse()
	util.WithDefer(func() {
		err = union.ModifyIntro(intro, roleID)
		if err != nil {
			return
		}
		if sync {
			resp.Sync.Union = union.Synchron()
		}
	}, unlock)

	s.unions.refreshSlimModels()
	return resp, nil
}

// 公会修改加入等级条件
func (s *Service) ModifyJoinType(unionID, roleID document.ID, typ int, level int, desc string) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}

	resp := NewUnionResponse()
	util.WithDefer(func() {
		err = union.ModifyJoin(typ, level, desc, roleID)
		if err != nil {
			return
		}
		resp.Sync.Union = union.Synchron()
	}, unlock)
	if err != nil {
		return nil, err
	}

	s.unions.reSort()
	return resp, nil
}

// 公会改logo
func (s *Service) ModifyLogo(unionID, roleID document.ID, logo int) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	err = union.ModifyLogo(logo, roleID)
	if err != nil {
		return nil, err
	}

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	return resp, nil
}

// 公会改名
func (s *Service) Rename(unionID, roleID document.ID, name string) (*UnionResponse, error) {
	union := s.unions.GetUnion(unionID)
	if union == nil {
		return nil, ErrUnionNotExisted
	}

	resp, err := service.Call(s.storage, "DBReadBy", "Union", bson.M{"name": name})
	if err != nil {
		return nil, err
	}
	response := resp.(storage.Response)
	if !response.Ret || len(response.Models) > 0 {
		return nil, ErrUnionNameDuplicated
	}
	_, unlock := union.LockAndGetDB()
	defer unlock()

	err = union.Rename(name, roleID)
	if err != nil {
		return nil, err
	}

	ret := NewUnionResponse()
	ret.Sync.Union = union.Synchron()
	return ret, nil
}

// 快速加入公会
func (s *Service) FastJoin(role scheme.UnionMemberRole, lastUnionID *document.ID) (*UnionResponse, error) {
	s.acceptLock.Lock()
	defer s.acceptLock.Unlock()
	if _, ok := s.roleUnion.Load(role.ID); ok {
		return nil, ErrUnionAlreadyIn
	}
	unionID, err := s.unions.FastJoin(role, lastUnionID)
	if err != nil {
		return nil, err
	}
	s.roleUnion.Store(role.ID, unionID)
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	resp.Sync.Role = union.GameRoleSync(role.ID)
	training := union.camp.GetTraining(role.ID)
	if training != nil {
		training.RefreshToOffline(TrainingExpPerMinute(role.Level, union.Level()))
		resp.Sync.CardExp = training.SyncExp()
	}
	return resp, err
}

// 公会捐献
func (s *Service) AddContrib(unionID, roleID document.ID, val int) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	if !union.isMember(roleID) {
		return nil, ErrUnionNotMember
	}
	union.AddContrib(roleID, val)

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	return resp, nil
}

// 公会任务捐献完成
func (s *Service) AddTaskContrib(unionID, roleID document.ID, csvID int, val int) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	if !union.isMember(roleID) {
		return nil, ErrUnionNotMember
	}

	union.AddTaskContrib(roleID, csvID, val)

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	return resp, nil
}

// 公会类型捐献任务计数增加
func (s *Service) AddContribTaskCount(unionID, roleID document.ID, csvID int, val int) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	err = union.AddTaskContribCount(csvID, val)
	if err != nil {
		return nil, err
	}

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	return resp, nil
}

// 公会训练所开启
func (s *Service) TrainingOpen(unionID, roleID document.ID, idx int) (*UnionResponse, error) {
	union, err, db, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	if !union.isFeatureOpen(TrainingCenter) {
		return nil, ErrUnionLevelLess
	}
	if !union.isMember(roleID) {
		return nil, ErrUnionNotMember
	}

	training := union.camp.GetTraining(roleID)
	if training == nil { // 加载公会训练营
		if t, err := s.builder.CreateUnionTraining(s.storage, roleID); err != nil {
			return nil, errors.New("create union training error")
		} else {
			training = t
			union.camp.add(roleID, training)
			training.onJoinUnion()
		}
	}
	if idx == 0 {
		role := db.Members[roleID]
		training.AutoOpen(role.Level, role.Vip)
	} else {
		training.Open(idx)
	}

	resp := NewUnionResponse()
	resp.Sync.CardExp = training.SyncExp()
	resp.View = training.UnionTrainingObject
	return resp, nil
}

// 公会训练所训练放置
func (s *Service) TrainingStart(unionID, roleID document.ID, idx int, card scheme.UnionTrainingCard) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	if !union.isFeatureOpen(TrainingCenter) {
		return nil, ErrUnionLevelLess
	}
	if !union.isMember(roleID) {
		return nil, ErrUnionNotMember
	}

	training := union.camp.GetTraining(roleID)
	if training == nil {
		return nil, errors.New("no training")
	}
	err = training.StartTraining(idx, card)
	if err != nil {
		return nil, err
	}

	resp := NewUnionResponse()
	resp.Sync.CardExp = training.SyncExp()
	resp.View = training.UnionTrainingObject
	return resp, nil
}

// 公会训练所训练替换
func (s *Service) TrainingReplace(unionID, roleID document.ID, idx int, card scheme.UnionTrainingCard) (*UnionResponse, error) {
	union, err, db, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	training := union.camp.GetTraining(roleID)
	if training == nil {
		return nil, errors.New("no training")
	}
	if !union.isMember(roleID) {
		return nil, ErrUnionNotMember
	}
	member := db.Members[roleID]
	training.RefreshToOffline(TrainingExpPerMinute(member.Level, union.Level()))
	err = training.ReplaceTraining(idx, card)
	if err != nil {
		return nil, err
	}

	resp := NewUnionResponse()
	resp.Sync.CardExp = training.SyncExp()
	resp.View = training.UnionTrainingObject
	return resp, nil
}

// 公会训练所加速
func (s *Service) TrainingSpeedup(unionID, roleID, chooseRoleID document.ID, idx int, times int) (*UnionResponse, error) {
	union, err, db, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	type role struct {
		id  document.ID
		idx int
	}

	beSpeedUpRoles := make([]role, 0, times)
	isrand := false
	if chooseRoleID == "" && idx == 0 {
		isrand = true
		for i := 0; i < times; i++ {
			chooseRoleID, idx = union.camp.RandomSpeedup(roleID, chooseRoleID)
			beSpeedUpRoles = append(beSpeedUpRoles, role{chooseRoleID, idx})
		}
	} else if chooseRoleID == "" || idx == 0 {
		isrand = true
		chooseRoleID, idx = union.camp.RandomSpeedup(roleID, chooseRoleID)
		beSpeedUpRoles = append(beSpeedUpRoles, role{chooseRoleID, idx})
	} else {
		beSpeedUpRoles = append(beSpeedUpRoles, role{chooseRoleID, idx})
	}

	if len(beSpeedUpRoles) == 0 { // 随机不到人
		log.Warningf("training speed up random no one")
		return nil, nil
	}

	member := db.Members[roleID]
	exp := TrainingExpPerMinute(member.Level, union.Level()) * TrainingSpeedUpExpFix
	name := db.Members[roleID].Name
	var training *Training
	for _, r := range beSpeedUpRoles {
		training = union.camp.GetTraining(r.id)
		training.BeSpeedUp(r.idx, name, exp)
	}

	if isrand {
		return nil, nil
	}
	resp := NewUnionResponse()
	resp.View = training.seemodel()
	return resp, nil
}

// 公会训练所社团营地列表
func (s *Service) TrainingList(unionID, roleID document.ID) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	resp := NewUnionResponse()
	resp.View = union.camp.List()
	return resp, nil
}

// 公会训练所查看他人营地
func (s *Service) TrainingSee(unionID, roleID document.ID) (Trainingsee, error) {
	union := s.unions.GetUnion(unionID)
	if union == nil {
		return Trainingsee{}, ErrUnionNotExisted
	}
	_, unlock := union.LockAndGetDB()
	defer unlock()

	if !union.isMember(roleID) {
		return Trainingsee{}, ErrUnionNotMember
	}
	training := union.camp.GetTraining(roleID)
	if training == nil {
		return Trainingsee{}, errors.New("no training")
	}
	return training.seemodel(), nil
}

// 公会训练所刷新卡牌数据
func (s *Service) TrainingRefreshCards(unionID, roleID document.ID, cards []scheme.UnionTrainingCard) (*scheme.UnionTrainingObject, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, nil
	}
	defer unlock()

	training := union.camp.GetTraining(roleID)
	if training == nil {
		return nil, nil
	}
	for _, card := range cards {
		training.UpdateCardModel(card)
	}
	return training.UnionTrainingObject, nil
}

// 获取红包信息
func (s *Service) RedPacketInfo(unionID document.ID) (map[document.ID]RedPacketViewInfo, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	union.redpackets.refreshSysPackets(union.Level())
	return union.redpackets.getPacketsInfo(), nil
}

// 公会红包个别信息
func (s *Service) RedPacketDetail(unionID, redpacketID document.ID) (map[document.ID]scheme.UnionRedPacketMember, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	packet := union.redpackets.getPacket(redpacketID)
	if packet == nil {
		return nil, ErrUnionRedPacketNotExist
	}
	return packet.Detail(), nil
}

type RobResponse struct {
	Type int    `codec:"type"`
	Flag int    `codec:"flag"`
	Name string `codec:"name"`
	Val  int    `codec:"val"`

	Infos map[document.ID]RedPacketViewInfo `codec:"infos"`
}

// 公会抢红包
func (s *Service) RedPacketRob(unionID, roleID, redpacketID document.ID, limit bool, quitTime float64) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	if !union.isFeatureOpen(UnionRedPacket) {
		return nil, ErrUnionLevelLess
	}
	union.redpackets.refreshSysPackets(union.Level())
	packet := union.redpackets.getPacket(redpacketID)
	if packet == nil {
		return nil, ErrUnionRedPacketNotExist
	}
	if quitTime > 0 && packet.PacketFlag() == RedPacketFlagSys { // 系统红包限制
		date := util.InclockNdate2int(util.Unix(int64(quitTime)), RedPacketRefreshHour)
		if date == util.Perioddate2int(RedPacketRefreshHour, util.Now()) {
			return nil, ErrUnionNotInTime
		}
	}
	if limit && packet.PacketFlag() == RedPacketFlagRole {
		return nil, ErrUnionRedPacketRobLimit
	}
	if !union.isMember(roleID) {
		return nil, ErrUnionNotMember
	}
	member := union.Members()[roleID]
	val, err := packet.Rob(member.UnionMemberRole)
	if err != nil {
		return nil, err
	}

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	resp.View = RobResponse{
		packet.PacketType(),
		packet.PacketFlag(),
		packet.RoleName(),
		val,
		union.redpackets.getPacketsInfo(),
	}

	return resp, nil
}

// 公会玩家发红包
func (s *Service) RedPacketSend(unionID, roleID document.ID, csvID int) (map[document.ID]RedPacketViewInfo, error) {
	union, err, db, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	if !union.isFeatureOpen(UnionRedPacket) {
		return nil, ErrUnionLevelLess
	}
	if !union.isMember(roleID) {
		return nil, ErrUnionNotMember
	}

	config := GetConfig().CSVRoleRedPackets[csvID]
	typ, val, count := config[0], config[1], config[2]
	packet, err := s.builder.CreateUnionRedPacket(s.storage, unionID, typ)
	if err != nil {
		return nil, err
	}
	member := db.Members[roleID]
	union.redpackets.createRolePacket(packet, member.ID, member.Name, csvID, val, count)

	return union.redpackets.getPacketsInfo(), nil
}

// 公会副本获取
func (s *Service) FubenGet(unionID, roleID document.ID) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	resp.View = union.fuben.UnionFubenObject
	return resp, nil
}

type PassedResp struct {
	_struct struct{} `codec:",toarray"`

	Month  int
	Passed []int
}

// 公会副本通关情况
func (s *Service) FubenUnionPassed(unionID document.ID) (*PassedResp, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	resp := &PassedResp{
		Month: union.fuben.Month(),
	}
	states := union.fuben.States()
	resp.Passed = make([]int, 0, len(states))
	for id, v := range states {
		if v.FirstTime > 0 {
			resp.Passed = append(resp.Passed, int(id))
		}
	}
	return resp, nil
}

// 公会副本进度
func (s *Service) FubenUnionProgress(idx int) (map[document.ID]fubenprogress, error) {
	return allfubenprogress.GetUnionProgress(idx), nil
}

// 公会副本开始战斗
func (s *Service) FubenStart(unionID, roleID document.ID, csvID int) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	if !union.isMember(roleID) {
		return nil, ErrUnionNotMember
	}
	buff, err := union.fuben.StartBattle(csvID)
	if err != nil {
		return nil, err
	}
	resp := NewUnionResponse()
	resp.View = buff
	return resp, nil
}

// 公会副本结束战斗
func (s *Service) FubenEnd(unionID, roleID document.ID, csvID int, damage int, hpmax int, times int) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	if !union.isMember(roleID) {
		return nil, ErrUnionNotMember
	}
	deadly, err := union.fuben.RecordBattle(csvID, roleID, damage, hpmax)
	if err == nil {
		union.setMemberFubenTime(roleID, times)
	}
	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	resp.View = []interface{}{deadly, union.fuben.UnionFubenObject}
	return resp, err
}

func (s *Service) SendMail(unionID, roleID document.ID) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	place := union.rolePlace(roleID)
	if place != ChairmanPlace && place != ViceChairmanPlace {
		return nil, ErrUnionOnlyChairman
	}

	if union.SendMailTimes() >= 2 {
		return nil, errors.New("send mail time up")
	}
	union.SetSendMailTimes(union.SendMailTimes() + 1)

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	return resp, nil
}

func (s *Service) SendJoinupInvite(unionID, roleID document.ID) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	place := union.rolePlace(roleID)
	if place != ChairmanPlace && place != ViceChairmanPlace {
		return nil, ErrUnionOnlyChairman
	}

	if union.JoinupInviteTimes() >= 2 {
		return nil, errors.New("joinup invite time up")
	}
	union.SetJoinupInviteTimes(union.JoinupInviteTimes() + 1)

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	return resp, nil
}

func (s *Service) AddMail(unionID document.ID, thumb scheme.UnionMailThumb) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	union.AddMail(thumb)

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	return resp, nil
}

// 发起碎片赠予
func (s *Service) FragDonateStart(unionID document.ID, roleID document.ID, frag int, maxnum int) (*UnionResponse, error) {
	union := s.unions.GetUnion(unionID)
	if union == nil {
		return nil, ErrUnionNotExisted
	}
	union.Lock()
	defer union.Unlock()

	success := union.FragDonateStart(roleID, frag, maxnum)

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	resp.View = success
	return resp, nil
}

// 碎片赠予
func (s *Service) FragDonate(unionID document.ID, roleID document.ID, toRole document.ID, frag int, singleMaxTimes int) (*UnionResponse, error) {
	union := s.unions.GetUnion(unionID)
	if union == nil {
		return nil, ErrUnionNotExisted
	}
	union.Lock()
	defer union.Unlock()

	success, full := union.DonateFrag(roleID, toRole, frag, singleMaxTimes)
	if full {
		union.RemoveFragDonate(toRole)
	}

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	resp.View = success
	return resp, nil
}

func (s *Service) OnRefresh() (bool, error) {
	s.unions.OnRefresh()
	return true, nil
}

func (s *Service) OnFubenReset() ([]damagerankitem, error) {
	s.unions.OnFubenReset()
	ranks := s.unions.GetFubenDamageRank()
	return ranks, nil
}

func (s *Service) OnFubenAward() ([]damagerankitem, error) {
	s.unions.OnFubenAward()
	ranks := s.unions.GetFubenDamageRank()
	return ranks, nil
}

func (s *Service) GameRoleSync(unionID, roleID document.ID) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	resp := NewUnionResponse()
	resp.Sync.Union = union.Synchron()
	if roleID != "" {
		if union.isMember(roleID) {
			resp.Sync.Role = union.GameRoleSync(roleID)
		}
	}
	return resp, nil
}

func (s *Service) FixUnionWeekTaskContrib() (bool, error) {
	cfg := csv.GetConfig()
	s.unions.Range(func(key, value interface{}) bool {
		union := value.(*Union)
		db, unlock := union.LockAndGetDB()
		defer unlock()

		old := db.WeekTaskContrib
		contrib := 0
		for id, v := range db.ContribTasks {
			if _, flag := v[0], v[1]; flag == 1 {
				contrib += cfg.Union.Union_task[int(id)].Contrib
			}
		}
		union.SetWeekTaskContrib(contrib)
		log.Infof("fix union %v week task contrib, old %d, now %d", union.GetID(), old, db.WeekTaskContrib)
		return true
	})
	return true, nil
}

func (s *Service) AddContribByCheat(unionID document.ID, val int) (*UnionResponse, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return nil, err
	}
	defer unlock()

	union.addContrib(val)
	log.Infof("union %v level %v contrib %d, cheat add contrib %d", unionID, union.Level(), union.Contrib(), val)
	return nil, nil
}

func (s *Service) RemoveUnionFubenManaual(unionID document.ID, id document.Integer, ids []document.Integer) (bool, error) {
	union, err, _, unlock := s.getLockedUnion(unionID)
	if err != nil {
		return false, err
	}
	defer unlock()
	fb := union.fuben
	db, fbunlock := fb.LockAndGetDB()
	defer fbunlock()

	util.WithGuard(&allfubenprogress, func() {
		delete(allfubenprogress.unionprogress, unionID)

		if id > 0 {
			delete(db.States, id)
			if _, ok := allfubenprogress.fubenprogress[int(id)]; ok {
				delete(allfubenprogress.fubenprogress[int(id)], unionID)
			}
		}
		if ids != nil {
			for _, id := range ids {
				delete(db.States, id)
				if _, ok := allfubenprogress.fubenprogress[int(id)]; ok {
					delete(allfubenprogress.fubenprogress[int(id)], unionID)
				}
			}
		}
	})
	fb.SetStates(db.States)

	// 更新 fb.Passed
	fb.Passed = 0
	for idx, state := range db.States {
		allfubenprogress.onRefresh(int(idx), state.Damage, state.FirstTime, fb.union)
		if state.FirstTime > 0 && int(idx) > fb.Passed {
			fb.Passed = int(idx)
		}
	}
	fb.autoOpen()

	return true, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}

	r := &Resolver{s}

	s.Register(s, "GetCacheModel")
	s.Register(s, "GetUnionModel")

	s.Register(s, "OnLogin")
	s.Register(s, "RefreshUnionMember")
	s.Register(s, "MainGet")
	s.Register(r, "Create")
	s.Register(s, "Dissolve")
	s.Register(s, "List")
	s.Register(s, "Find")
	s.Register(s, "Join")
	s.Register(s, "JoinCancel")
	s.Register(s, "JoinAccept")
	s.Register(s, "JoinRefuse")
	s.Register(s, "JoinRefuseAll")
	s.Register(s, "Quit")
	s.Register(s, "Kick")
	s.Register(s, "ChairmanPromote")
	s.Register(s, "ChairmanDemote")
	s.Register(s, "ChairmanSwap")
	s.Register(s, "ModifyIntro")
	s.Register(s, "ModifyJoinType")
	s.Register(s, "ModifyLogo")
	s.Register(s, "Rename")
	s.Register(s, "FastJoin")
	s.Register(s, "AddContrib")
	s.Register(s, "AddTaskContrib")
	s.Register(s, "AddContribTaskCount")
	s.Register(s, "GetRankList")

	s.Register(s, "TrainingOpen")
	s.Register(s, "TrainingStart")
	s.Register(s, "TrainingReplace")
	s.Register(s, "TrainingSpeedup")
	s.Register(s, "TrainingList")
	s.Register(s, "TrainingSee")
	s.Register(s, "TrainingRefreshCards")

	s.Register(s, "RedPacketInfo")
	s.Register(s, "RedPacketDetail")
	s.Register(s, "RedPacketRob")
	s.Register(s, "RedPacketSend")

	s.Register(s, "FubenGet")
	s.Register(s, "FubenStart")
	s.Register(s, "FubenEnd")
	s.Register(s, "FubenUnionProgress")
	s.Register(s, "FubenUnionPassed")

	s.Register(s, "SendMail")
	s.Register(s, "SendJoinupInvite")
	s.Register(s, "AddMail")

	s.Register(s, "FragDonateStart")
	s.Register(s, "FragDonate")

	s.Register(s, "OnRefresh")
	s.Register(s, "OnFubenReset")
	s.Register(s, "OnFubenAward")

	s.Register(s, "GameRoleSync")

	s.Register(s, "FixUnionWeekTaskContrib")
	s.Register(s, "AddContribByCheat")
	s.Register(s, "RemoveUnionFubenManaual")

	return s
}

type Resolver struct {
	s *Service
}

func (r *Resolver) Name() string {
	return r.s.Name()
}

func (r *Resolver) Create(raw codec.Raw, role scheme.UnionMemberRole) (resp *UnionResponse, err error) {
	internal := document.New("Union", true)
	if err = util.MsgUnpack(raw, internal); err != nil {
		return
	}
	return r.s.Create(internal.(*scheme.Union), role)
}

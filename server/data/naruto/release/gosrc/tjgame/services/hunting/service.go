package hunting

import (
	"errors"
	"strings"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/cross"
	"tjgame/services/storage"
)

const Name = "hunting"

type Service struct {
	*service.Service
	builder *Builder

	hunting  *Hunting // 远征
	crossKey string
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
	ss := s.Container().GetService(storage.GetNameFromDependent(opt.Dependent))
	s.builder = NewBuilder(ss)
	gameKey := strings.Replace(opt.Name, Name, "game", 1)

	_, lang, _ := service.SplitServiceName(s.Name())
	l := strings.Split(lang, "_")[0]
	s.crossKey = service.MakeServiceName("crosshunting", l, 1)

	s.hunting = &Hunting{}
	go s.hunting.init(s, s.Container().GetService("anticheat"), gameKey)
	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.builder.Stop()
}

// 创建HuntingRecord
func (s *Service) CreateHuntingRecord(roleID document.ID, specialOpen bool) (*scheme.HuntingRecordObject, error) {
	record := document.New("HuntingRecord", true).(*scheme.HuntingRecord)

	record.RoleDbID = roleID
	record.GameKey = s.hunting.key
	// 普通
	record.BattleTimes = 1
	record.HuntingRoute[1] = &scheme.HuntingRouteInfo{
		Status:   "closed",
		LastDate: util.Todayinclock5date2int(),
	}
	// 进阶
	specialLastDate := 0
	if specialOpen {
		record.SpecialBattleTimes = 1
		specialLastDate = util.Todayinclock5date2int()
	}
	record.HuntingRoute[2] = &scheme.HuntingRouteInfo{
		Status:   "closed",
		LastDate: specialLastDate,
	}

	// create HuntingRecord in storage
	r := s.builder.CreateHuntingRecord(record)

	return r.HuntingRecordObject, nil
}

// 开启进阶线路
func (s *Service) OpenSpecialRoute(recordID document.ID) (bool, error) {
	record := s.builder.GetHuntingRecord(recordID)
	db, unlock := record.LockAndGetDB()
	defer unlock()
	routeInfo := db.HuntingRoute[document.Integer(2)]
	if routeInfo.LastDate != 0 {
		return false, nil
	}
	record.SetSpecialBattleTimes(1)
	routeInfo = &scheme.HuntingRouteInfo{
		Status:   "closed",
		LastDate: util.Todayinclock5date2int(),
	}
	db.HuntingRoute[document.Integer(2)] = routeInfo
	record.SetHuntingRoute(db.HuntingRoute)
	return true, nil
}

// 获取HuntingRecord
func (s *Service) GetHuntingRecord(recordID document.ID, specialOpen bool) (*scheme.HuntingRecordObject, error) {
	record := s.builder.GetHuntingRecord(recordID)
	db, unlock := record.LockAndGetDB()
	defer unlock()
	// fix 处理1-5测试服LastDate
	if !specialOpen {
		routeInfo := db.HuntingRoute[document.Integer(2)]
		routeInfo.LastDate = 0
		db.HuntingRoute[document.Integer(2)] = routeInfo
		record.SetHuntingRoute(db.HuntingRoute)
	}
	// 是否重置
	record.isResetRoute()
	return record.HuntingRecordObject, nil
}

// 选择线路开始
func (s *Service) HuntingRouteBegin(recordID document.ID, route int, cards []document.ID) (*scheme.HuntingRecordObject, error) {
	record := s.builder.GetHuntingRecord(recordID)
	db, unlock := record.LockAndGetDB()
	defer unlock()
	routeInfo := db.HuntingRoute[document.Integer(route)]
	// 状态
	if routeInfo.Status != "closed" {
		return nil, ErrStatus
	}
	// 次数
	times := 0
	if route == 1 {
		times = db.BattleTimes
	} else if route == 2 {
		times = db.SpecialBattleTimes
	} else {
		return nil, ErrRoute
	}
	if times < 1 {
		return nil, ErrBattleTimes
	}
	// 扣次数
	if route == 1 {
		record.SetBattleTimes(db.BattleTimes - 1)
	} else if route == 2 {
		record.SetSpecialBattleTimes(db.SpecialBattleTimes - 1)
	}
	record.resetRoute(route)
	// 存阵容
	routeInfo.Cards = cards
	// 初始化新卡的states
	for _, cardID := range routeInfo.Cards {
		if cardID != "" {
			if _, ok := routeInfo.CardStates[cardID]; !ok {
				routeInfo.CardStates[cardID] = [2]float64{1.0, 0.0}
			}
		}
	}
	// 线路开启确定版本，正进行的沿用之前版本
	routeInfo.Version = csv.GetConfig().Cross.Hunting.Base[route].Version
	routeInfo.Node = GetConfig().HuntingRouteMin[routeInfo.Version][route]
	routeInfo.Status = "starting"
	record.SetHuntingRoute(db.HuntingRoute)

	return record.HuntingRecordObject, nil
}

// 线路手动结束
func (s *Service) HuntingRouteEnd(recordID document.ID, route int) (*scheme.HuntingRecordObject, error) {
	record := s.builder.GetHuntingRecord(recordID)
	db, unlock := record.LockAndGetDB()
	defer unlock()
	routeInfo := db.HuntingRoute[document.Integer(route)]
	// 状态
	if routeInfo.Status != "starting" {
		return nil, ErrStatusClosed
	}
	record.resetRoute(route)
	routeInfo.Status = "closed"
	record.SetHuntingRoute(db.HuntingRoute)

	return record.HuntingRecordObject, nil
}

// 宝箱关 打开宝箱
func (s *Service) HuntingOpenBox(recordID document.ID, route, node int) (*RespRecord, error) {
	record := s.builder.GetHuntingRecord(recordID)
	db, unlock := record.LockAndGetDB()
	defer unlock()
	routeInfo := db.HuntingRoute[document.Integer(route)]
	// 状态
	if routeInfo.Status != "starting" {
		return nil, ErrStatusClosed
	}
	if routeInfo.Node != node {
		return nil, ErrNode
	}
	if !s.hunting.isRightNodeType(BoxType, node, routeInfo) {
		return nil, ErrNodeType
	}
	cfg := csv.GetConfig().Cross.Hunting.Base[route]
	if routeInfo.BoxOpenCount >= cfg.BoxOpenLimit {
		return nil, ErrBoxLimit
	}
	routeInfo.BoxOpenCount += 1
	record.SetHuntingRoute(db.HuntingRoute)

	isPass := false
	if routeInfo.BoxOpenCount == cfg.BoxOpenLimit {
		// 下一个节点
		isPass = record.nextNode(route)
	}
	ret := &RespRecord{
		Record: record.HuntingRecordObject,
		IsPass: isPass,
	}
	return ret, nil
}

// 宝箱关 跳到下一个节点
func (s *Service) HuntingNextNode(recordID document.ID, route int) (*RespRecord, error) {
	record := s.builder.GetHuntingRecord(recordID)
	db, unlock := record.LockAndGetDB()
	defer unlock()
	routeInfo := db.HuntingRoute[document.Integer(route)]
	// 状态
	if routeInfo.Status != "starting" {
		return nil, ErrStatusClosed
	}
	if routeInfo.Node == GetConfig().HuntingRouteMax[routeInfo.Version][route] {
		return nil, ErrNode
	}
	// 下一个节点
	isPass := record.nextNode(route)
	ret := &RespRecord{
		Record: record.HuntingRecordObject,
		IsPass: isPass,
	}
	return ret, nil
}

// 组合关 选择
func (s *Service) HuntingBoardChoose(recordID document.ID, route, node, boardID int) (*scheme.HuntingRecordObject, error) {
	record := s.builder.GetHuntingRecord(recordID)
	db, unlock := record.LockAndGetDB()
	defer unlock()
	routeInfo := db.HuntingRoute[document.Integer(route)]
	// 状态
	if routeInfo.Status != "starting" {
		return nil, ErrStatusClosed
	}
	if routeInfo.Node != node {
		return nil, ErrNode
	}
	if !s.hunting.isRightNodeType(MultiType, node, routeInfo) {
		return nil, ErrNodeType
	}

	routeInfo.BoardID = boardID
	record.SetHuntingRoute(db.HuntingRoute)
	return record.HuntingRecordObject, nil
}

// 救援关 补给
func (s *Service) HuntingSupply(recordID document.ID, route, node, csvID int, cardID document.ID) (*RespRecord, error) {
	record := s.builder.GetHuntingRecord(recordID)
	db, unlock := record.LockAndGetDB()
	defer unlock()
	routeInfo := db.HuntingRoute[document.Integer(route)]
	// 状态
	if routeInfo.Status != "starting" {
		return nil, ErrStatusClosed
	}
	if routeInfo.Node != node {
		return nil, ErrNode
	}
	if !s.hunting.isRightNodeType(SupplyType, node, routeInfo) {
		return nil, ErrNodeType
	}
	cfg := csv.GetConfig().Cross.Hunting.Route[node]
	if csv.GetConfig().Cross.Hunting.Supply[csvID].Group != cfg.SupplyGroup {
		return nil, errors.New("csvID error")
	}
	if record.isSupply(route, csvID) {
		flag := record.supply(route, csvID, cardID)
		if !flag {
			return nil, ErrSupplyCard
		}
	}
	// 下一个节点
	isPass := record.nextNode(route)
	ret := &RespRecord{
		Record: record.HuntingRecordObject,
		IsPass: isPass,
	}
	return ret, nil
}

// 战斗关 详情
func (s *Service) GetHuntingBattleInfo(recordID document.ID, route, node, gateID, fixFP int) (*RespBattleInfo, error) {
	record := s.builder.GetHuntingRecord(recordID)
	err := cross.ContainerServices(s.Container(), s.crossKey)
	if err != nil {
		return nil, err
	}
	db, unlock := record.LockAndGetDB()
	defer unlock()
	routeInfo := db.HuntingRoute[document.Integer(route)]
	// 状态
	if routeInfo.Status != "starting" {
		return nil, ErrStatusClosed
	}
	if routeInfo.Node != node {
		return nil, ErrNode
	}
	if routeInfo.BoardID != 0 && routeInfo.BoardID != gateID {
		return nil, ErrGateID
	}
	if !s.hunting.isRightNodeType(BattleType, node, routeInfo) {
		return nil, ErrNodeType
	}

	// 确认阵容
	ret, err := record.getBattleInfo(s.Container(), s.crossKey, route, fixFP)
	if err != nil {
		return nil, err
	}
	resp := &RespBattleInfo{
		DefenceRoleInfo: ret,
		Record:          record.HuntingRecordObject,
	}
	return resp, nil
}

// 战斗关 开始
func (s *Service) HuntingBattleStart(recordID document.ID, route, node int, battleModel *BattleModel) (*RespBattleStart, error) {
	record := s.builder.GetHuntingRecord(recordID)
	db, unlock := record.LockAndGetDB()
	defer unlock()
	routeInfo := db.HuntingRoute[document.Integer(route)]
	// 状态
	if routeInfo.Status != "starting" {
		return nil, ErrStatusClosed
	}
	if routeInfo.Node != node {
		return nil, ErrNode
	}
	if !s.hunting.isRightNodeType(BattleType, node, routeInfo) {
		return nil, ErrNodeType
	}
	if len(routeInfo.BoardBuffs) != 0 {
		return nil, errors.New("can not start again")
	}
	if routeInfo.BoardID != 0 && routeInfo.BoardID != battleModel.GateID {
		return nil, ErrGateID
	}
	cfg := csv.GetConfig().Cross.Hunting.Route[routeInfo.Node]
	gateIDSet := util.NewSet()
	for _, gID := range cfg.GateIDs.ToIntSlice() {
		gateIDSet.Add(gID)
	}
	if !gateIDSet.Contains(battleModel.GateID) {
		return nil, errors.New("gateID error")
	}

	// 开始战斗
	ret, err := record.startBattle(s.Container(), route, battleModel, s.hunting)
	if err != nil {
		return nil, err
	}
	resp := &RespBattleStart{
		BattleModel: ret,
		Record:      record.HuntingRecordObject,
	}
	return resp, nil
}

// 战斗关 结束
func (s *Service) HuntingBattleEnd(req ReqHuntingBattleEnd) (*RespRecord, error) {
	record := s.builder.GetHuntingRecord(req.RecordID)
	err := cross.ContainerServices(s.Container(), s.crossKey)
	if err != nil {
		return nil, err
	}
	req.CrossKey = s.crossKey

	db, unlock := record.LockAndGetDB()
	defer unlock()
	routeInfo := db.HuntingRoute[document.Integer(req.Route)]
	// 状态
	if routeInfo.Status != "starting" {
		return nil, ErrStatusClosed
	}
	// 结束战斗
	err = record.endBattle(s.Container(), req, s.hunting)
	if err != nil {
		return nil, err
	}

	isPass := false
	cfgGate := csv.GetConfig().Cross.Hunting.Gate[req.GateID]
	if (cfgGate.IsBuff != 1 || len(routeInfo.BoardBuffs) == 0) && req.Result == "win" {
		// 下一个节点
		isPass = record.nextNode(req.Route)
	}
	ret := &RespRecord{
		Record: record.HuntingRecordObject,
		IsPass: isPass,
	}
	return ret, nil
}

// 战斗关 碾压
func (s *Service) HuntingBattlePass(recordID document.ID, route, node, gateID int, top10Cards []document.ID) (*RespRecord, error) {
	record := s.builder.GetHuntingRecord(recordID)
	err := cross.ContainerServices(s.Container(), s.crossKey)
	if err != nil {
		return nil, err
	}
	db, unlock := record.LockAndGetDB()
	defer unlock()
	routeInfo := db.HuntingRoute[document.Integer(route)]
	// 状态
	if routeInfo.Status != "starting" {
		return nil, ErrStatusClosed
	}
	if routeInfo.Node != node {
		return nil, ErrNode
	}
	if !s.hunting.isRightNodeType(BattleType, node, routeInfo) {
		return nil, ErrNodeType
	}
	if len(routeInfo.BoardBuffs) != 0 {
		return nil, errors.New("can not start again")
	}
	if routeInfo.BoardID != 0 && routeInfo.BoardID != gateID {
		return nil, ErrGateID
	}

	// 是否可碾压
	csvRoute := csv.GetConfig().Cross.Hunting.Route
	maxPassNode := 0
	lastCanPass := 0
	historyCanPass := 0
	if csvRoute[routeInfo.LastMaxNode] != nil {
		lastCanPass = csvRoute[routeInfo.LastMaxNode].LastCanPass
	}
	if csvRoute[routeInfo.HistoryMaxNode] != nil {
		historyCanPass = csvRoute[routeInfo.HistoryMaxNode].HistoryCanPass
	}
	if lastCanPass > historyCanPass {
		maxPassNode = lastCanPass
	} else {
		maxPassNode = historyCanPass
	}
	if (node % 100) > maxPassNode {
		return nil, errors.New("can not pass")
	}

	// 碾压
	record.passBattle(s.Container(), route, node, gateID, s.crossKey, top10Cards)

	isPass := false
	cfgGate := csv.GetConfig().Cross.Hunting.Gate[gateID]
	if cfgGate.IsBuff != 1 || len(routeInfo.BoardBuffs) == 0 {
		// 下一个节点
		isPass = record.nextNode(route)
	}
	ret := &RespRecord{
		Record: record.HuntingRecordObject,
		IsPass: isPass,
	}
	return ret, nil
}

// 战斗关 buff面板选择
func (s *Service) HuntingBattleChoose(recordID document.ID, route, node, boardID int) (*RespRecord, error) {
	record := s.builder.GetHuntingRecord(recordID)
	db, unlock := record.LockAndGetDB()
	defer unlock()
	routeInfo := db.HuntingRoute[document.Integer(route)]
	// 状态
	if routeInfo.Status != "starting" {
		return nil, ErrStatusClosed
	}
	if routeInfo.Node != node {
		return nil, ErrNode
	}
	if len(routeInfo.BoardBuffs) == 0 {
		return nil, ErrBoardBuffsEmpty
	}
	if !s.hunting.isRightNodeType(BattleType, node, routeInfo) {
		return nil, ErrNodeType
	}

	isPass := false
	if boardID <= len(routeInfo.BoardBuffs) {
		buffID := routeInfo.BoardBuffs[boardID-1]
		buffs := util.NewSet()
		for _, buff := range routeInfo.Buffs {
			buffs.Add(buff)
		}
		if !buffs.Contains(buffID) {
			routeInfo.Buffs = append(routeInfo.Buffs, buffID)
		}
		routeInfo.BoardBuffs = []int{}
		record.SetHuntingRoute(db.HuntingRoute)
		// 下一个节点
		isPass = record.nextNode(route)
	} else {
		return nil, ErrBoardID
	}

	ret := &RespRecord{
		Record: record.HuntingRecordObject,
		IsPass: isPass,
	}
	return ret, nil
}

// 卡牌分解下阵
func (s *Service) RefreshHuntingCards(recordID document.ID, delCards []document.ID) (bool, error) {
	record := s.builder.GetHuntingRecord(recordID)
	_, unlock := record.LockAndGetDB()
	defer unlock()

	record.refreshCards(delCards)
	return true, nil
}

// 保存阵容
func (s *Service) DeployHuntingCards(recordID document.ID, route int, cards []document.ID) (*scheme.HuntingRecordObject, error) {
	record := s.builder.GetHuntingRecord(recordID)
	db, unlock := record.LockAndGetDB()
	defer unlock()
	routeInfo := db.HuntingRoute[document.Integer(route)]
	// 状态
	if routeInfo.Status != "starting" {
		return nil, ErrStatusClosed
	}
	// 更新Cards
	newCards := []document.ID{}
	for _, cardID := range cards {
		if cardID != "" {
			if state, ok := routeInfo.CardStates[cardID]; ok {
				if state[0] <= 0 {
					newCards = append(newCards, "")
				} else {
					newCards = append(newCards, cardID)
				}
			} else {
				newCards = append(newCards, cardID)
				routeInfo.CardStates[cardID] = [2]float64{1.0, 0.0}
			}
		} else {
			newCards = append(newCards, "")
		}
	}
	routeInfo.Cards = newCards
	db.HuntingRoute[document.Integer(route)] = routeInfo
	record.SetHuntingRoute(db.HuntingRoute)
	return record.HuntingRecordObject, nil
}

// 测试 加挑战次数
func (s *Service) TestHuntingCountAdd(recordID document.ID, route int, count int) (bool, error) {
	record := s.builder.GetHuntingRecord(recordID)
	db, unlock := record.LockAndGetDB()
	defer unlock()
	cfg := csv.GetConfig().Cross.Hunting.Base[int(route)]
	// 增加次数
	if route == 1 {
		if db.BattleTimes+count <= cfg.BattleLimit {
			record.SetBattleTimes(db.BattleTimes + count)
		} else {
			record.SetBattleTimes(cfg.BattleLimit)
		}
	} else if route == 2 {
		if db.SpecialBattleTimes+count <= cfg.BattleLimit {
			record.SetSpecialBattleTimes(db.SpecialBattleTimes + count)
		} else {
			record.SetSpecialBattleTimes(cfg.BattleLimit)
		}
	} else {
		return false, ErrRoute
	}
	return true, nil
}

// 测试 清空buff
func (s *Service) TestHuntingBuffClear(recordID document.ID, route int) (bool, error) {
	record := s.builder.GetHuntingRecord(recordID)
	db, unlock := record.LockAndGetDB()
	defer unlock()
	// 清空buff
	routeInfo := db.HuntingRoute[document.Integer(route)]
	routeInfo.Buffs = []int{}
	record.SetHuntingRoute(db.HuntingRoute)

	return true, nil
}

// 测试 添加buff
func (s *Service) TestHuntingBuffAdd(recordID document.ID, route int, buffID int) (bool, error) {
	record := s.builder.GetHuntingRecord(recordID)
	db, unlock := record.LockAndGetDB()
	defer unlock()
	if _, ok := csv.GetConfig().Cross.Hunting.Buffs[buffID]; !ok {
		return false, nil
	}
	// 添加buff
	routeInfo := db.HuntingRoute[document.Integer(route)]
	buffs := util.NewSet()
	for _, buff := range routeInfo.Buffs {
		buffs.Add(buff)
	}
	if !buffs.Contains(buffID) {
		routeInfo.Buffs = append(routeInfo.Buffs, buffID)
		record.SetHuntingRoute(db.HuntingRoute)
	}
	return true, nil
}

// 测试 修改版本
func (s *Service) TestHuntingVersion(recordID document.ID, route int, version int) (*scheme.HuntingRecordObject, error) {
	record := s.builder.GetHuntingRecord(recordID)
	db, unlock := record.LockAndGetDB()
	defer unlock()
	routeInfo := db.HuntingRoute[document.Integer(route)]
	if routeInfo.Status == "closed" {
		return nil, ErrStatus
	}
	// 清空所有节点相关数据
	routeInfo.EnemyStates = map[document.ID][2]float64{}
	routeInfo.BoxOpenCount = 0
	routeInfo.BoardID = 0
	routeInfo.BattleRoleKey = nil
	routeInfo.BoardBuffs = []int{}
	// 修改版本
	routeInfo.Version = version
	// 修改节点
	pos := routeInfo.Node % 100
	node := GetConfig().HuntingRouteMin[routeInfo.Version][route] + pos - 1
	if node <= GetConfig().HuntingRouteMax[routeInfo.Version][route] {
		routeInfo.Node = node
	} else {
		routeInfo.Node = GetConfig().HuntingRouteMax[routeInfo.Version][route]
	}
	record.SetHuntingRoute(db.HuntingRoute)

	return record.HuntingRecordObject, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}

	s.Register(s, "CreateHuntingRecord")
	s.Register(s, "GetHuntingRecord")
	s.Register(s, "HuntingRouteBegin")
	s.Register(s, "HuntingRouteEnd")
	s.Register(s, "HuntingBattleChoose")
	s.Register(s, "HuntingOpenBox")
	s.Register(s, "HuntingNextNode")
	s.Register(s, "HuntingBoardChoose")
	s.Register(s, "HuntingSupply")
	s.Register(s, "GetHuntingBattleInfo")
	s.Register(s, "HuntingBattleStart")
	s.Register(s, "HuntingBattleEnd")
	s.Register(s, "RefreshHuntingCards")
	s.Register(s, "DeployHuntingCards")
	s.Register(s, "OpenSpecialRoute")
	s.Register(s, "HuntingBattlePass")

	s.Register(s, "TestHuntingCountAdd")
	s.Register(s, "TestHuntingBuffClear")
	s.Register(s, "TestHuntingBuffAdd")
	s.Register(s, "TestHuntingVersion")

	return s
}

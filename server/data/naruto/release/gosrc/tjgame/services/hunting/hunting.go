package hunting

import (
	"errors"
	"fmt"
	"math/rand"
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

// HuntingRecord
type HuntingRecord struct {
	*scheme.HuntingRecordObject
}

// 重置线路
func (r *HuntingRecord) resetRoute(route int) {
	db := r.GetLockedDB()
	routeInfo := db.HuntingRoute[document.Integer(route)]
	log.Infof("HuntingRecord.resetRoute route %d node %d", route, routeInfo.Node)

	if routeInfo.Node > 0 {
		routeInfo.LastMaxNode = routeInfo.Node - 1
	}
	if routeInfo.Node-1 > routeInfo.HistoryMaxNode {
		routeInfo.HistoryMaxNode = routeInfo.Node - 1
	}
	routeInfo.Status = "closed"
	routeInfo.Node = 0
	routeInfo.Buffs = []int{}
	routeInfo.CardStates = map[document.ID][2]float64{}
	routeInfo.Cards = []document.ID{}

	routeInfo.EnemyStates = map[document.ID][2]float64{}
	routeInfo.BoxOpenCount = 0
	routeInfo.BoardID = 0
	routeInfo.BattleRoleKey = nil
	routeInfo.BoardBuffs = []int{}

	r.SetHuntingRoute(db.HuntingRoute)
}

// 是否重置线路
func (r *HuntingRecord) isResetRoute() {
	db := r.GetLockedDB()
	now := util.Now()
	csvBase := csv.GetConfig().Cross.Hunting.Base
	for route, routeInfo := range db.HuntingRoute {
		// 为0 表示线路还没开
		if routeInfo.LastDate != 0 {
			cfg := csvBase[int(route)]
			count := 0
			lastDate := routeInfo.LastDate
			for i := 1; i < 999; i++ {
				d := resetTime.CombineDateInt(routeInfo.LastDate).AddDate(0, 0, cfg.RefreshDay*i).Sub(now)
				if d > 0 {
					break
				}
				count++
				lastDate = util.Date2int(resetTime.CombineDateInt(routeInfo.LastDate).AddDate(0, 0, cfg.RefreshDay*i))
			}
			if count > 0 {
				// 增加次数
				if int(route) == 1 {
					if db.BattleTimes+count <= cfg.BattleLimit {
						r.SetBattleTimes(db.BattleTimes + count)
					} else {
						r.SetBattleTimes(cfg.BattleLimit)
					}
				} else {
					if db.SpecialBattleTimes+count <= cfg.BattleLimit {
						r.SetSpecialBattleTimes(db.SpecialBattleTimes + 1)
					} else {
						r.SetSpecialBattleTimes(cfg.BattleLimit)
					}
				}
				// 重置线路
				r.resetRoute(int(route))
				routeInfo.LastDate = lastDate
				log.Infof("HuntingRecord reset route %d lastDate %d", route, routeInfo.LastDate)
			}
		}
	}
	r.SetHuntingRoute(db.HuntingRoute)
}

// 跳下一个节点
func (r *HuntingRecord) nextNode(route int) bool {
	db := r.GetLockedDB()

	routeInfo := db.HuntingRoute[document.Integer(route)]
	if routeInfo.Node > GetConfig().HuntingRouteMax[routeInfo.Version][route] {
		return false
	}
	routeInfo.EnemyStates = map[document.ID][2]float64{}
	routeInfo.BoxOpenCount = 0
	routeInfo.BoardID = 0
	routeInfo.BattleRoleKey = nil
	routeInfo.BoardBuffs = []int{}
	routeInfo.Node = routeInfo.Node + 1
	r.SetHuntingRoute(db.HuntingRoute)

	// 通关
	if routeInfo.Node > GetConfig().HuntingRouteMax[routeInfo.Version][route] {
		return true
	}
	return false
}

// 是否满足救援条件
func (r *HuntingRecord) isSupply(route int, csvID int) bool {
	db := r.GetLockedDB()

	routeInfo := db.HuntingRoute[document.Integer(route)]
	cardStates := routeInfo.CardStates
	cfg := csv.GetConfig().Cross.Hunting.Supply[csvID]

	switch cfg.Type {
	case SupplyHp:
		for _, state := range cardStates {
			if 0 < state[0] && state[0] < 1 {
				return true
			}
		}
	case SupplyHpAll:
		return true
	case SupplyRevive:
		for _, state := range cardStates {
			if state[0] <= 0 {
				return true
			}
		}
	}
	return false
}

// 救援
func (r *HuntingRecord) supply(route int, csvID int, cardID document.ID) bool {
	db := r.GetLockedDB()

	routeInfo := db.HuntingRoute[document.Integer(route)]
	cardStates := routeInfo.CardStates
	cfg := csv.GetConfig().Cross.Hunting.Supply[csvID]

	switch cfg.Type {
	case SupplyHp:
		if state, ok := cardStates[cardID]; ok {
			if state[0] <= 0 || state[0] == 1 {
				return false
			}
			state[0] = Min(state[0]+float64(cfg.Effect)/100, 1.0)
			cardStates[cardID] = state
		} else {
			return false
		}
	case SupplyHpAll:
		for cID, state := range cardStates {
			if state[0] > 0 {
				state[0] = Min(state[0]+float64(cfg.Effect)/100, 1.0)
				cardStates[cID] = state
			}
		}
	case SupplyRevive:
		if state, ok := cardStates[cardID]; ok {
			if state[0] > 0 {
				return false
			}
			state[0] = 1.0
			cardStates[cardID] = state
		} else {
			return false
		}
	default:
		panic(fmt.Sprintf("csv type %v error", cfg.Type))
	}
	routeInfo.CardStates = cardStates
	r.SetHuntingRoute(db.HuntingRoute)
	return true
}

// 战斗关详情
func (r *HuntingRecord) getBattleInfo(container service.IContainer, crossKey string, route int, fixFP int) (*DefenceRoleInfo, error) {
	db := r.GetLockedDB()
	routeInfo := db.HuntingRoute[document.Integer(route)]
	battleRole := routeInfo.BattleRoleKey
	serviceKey := ""
	isUpdate := false
	// 判断是否已确定
	if battleRole != nil {
		serviceKey = Game2ArenaService(battleRole.GameKey)
	} else {
		// 随机 一个名单, 且挑战标识加一
		serviceCross := container.GetService(crossKey)
		if serviceCross == nil {
			return nil, errors.New("cross key error")
		}
		bcInfo, err := service.CallWithTimeout(serviceCross, "RandomHuntingBattleCard", time.Second*15, fixFP)
		if err != nil {
			return nil, err
		}
		battleRole = bcInfo.(*scheme.BattleCardInfo)
		serviceKey = Game2ArenaService(battleRole.GameKey)
		isUpdate = true
	}
	routeInfo.BattleRoleKey = battleRole
	r.SetHuntingRoute(db.HuntingRoute)
	recordID := battleRole.RecordID
	roleID := battleRole.RoleDbID
	err := cross.ContainerServices(container, serviceKey)
	serviceArena := container.GetService(serviceKey)
	if serviceArena == nil {
		return nil, errors.New("game key error")
	}
	ret, err := service.CallWithTimeout(serviceArena, "GetArenaHuntingRoleInfo", time.Second*15, recordID, roleID, battleRole.GameKey, isUpdate)
	if err != nil {
		return nil, err
	}
	roleInfo := ret.(*scheme.HuntingDefenceRoleInfo)
	defenceCardAttrs := map[document.ID]*CardModel{}
	for cardDBID, attrs := range roleInfo.DefenceCardAttrs {
		cardModel := &CardModel{
			CardId:         attrs.CardId,
			Level:          attrs.Level,
			FightingPoint:  attrs.FightingPoint,
			Star:           attrs.Star,
			Advance:        attrs.Advance,
			FightingPoint2: attrs.FightingPoint2,
		}
		defenceCardAttrs[cardDBID] = cardModel
	}
	defenceRoleInfo := &DefenceRoleInfo{
		RoleDbID:         roleInfo.RoleDbID,
		DefenceCards:     roleInfo.DefenceCards,
		DefenceCardAttrs: defenceCardAttrs,
		GameKey:          csv.GetMergeConfig().GetSrcServKeys(roleInfo.GameKey)[0],
		Name:             roleInfo.Name,
		Logo:             roleInfo.Logo,
		Frame:            roleInfo.Frame,
		Level:            roleInfo.Level,
		Figure:           roleInfo.Figure,
		Vip:              roleInfo.Vip,
	}
	return defenceRoleInfo, nil
}

// 开始战斗
func (r *HuntingRecord) startBattle(container service.IContainer, route int, battleModel *BattleModel, h *Hunting) (*BattleModel, error) {
	db := r.GetLockedDB()
	routeInfo := db.HuntingRoute[document.Integer(route)]
	battleRole := routeInfo.BattleRoleKey
	// 判断是否已确定
	if battleRole == nil {
		return nil, errors.New("no battleRole error")
	}
	// 是否有死卡
	for _, cardID := range battleModel.Cards {
		if cardID != "" {
			if state, ok := routeInfo.CardStates[cardID]; ok {
				if state[0] <= 0 {
					return nil, errors.New("has 0 hp card")
				}
			}
		}
	}
	battleModel.ID = document.NewID()
	battleModel.RandSeed = rand.Intn(99999999) + 1

	// 处理对手
	recordID := battleRole.RecordID
	roleID := battleRole.RoleDbID
	serviceKey := Game2ArenaService(battleRole.GameKey)
	err := cross.ContainerServices(container, serviceKey)
	serviceArena := container.GetService(serviceKey)
	if serviceArena == nil {
		return nil, errors.New("game key error")
	}
	ret, err := service.CallWithTimeout(serviceArena, "GetArenaHuntingRoleInfo", time.Second*15, recordID, roleID, battleRole.GameKey, false)
	if err != nil {
		return nil, err
	}
	// 首次初始化对手states
	if len(routeInfo.EnemyStates) == 0 {
		routeInfo.EnemyStates = map[document.ID][2]float64{}
		for _, cardID := range ret.(*scheme.HuntingDefenceRoleInfo).DefenceCards {
			if cardID != "" {
				routeInfo.EnemyStates[cardID] = [2]float64{1.0, 0.0}
			}
		}
	}
	// 下阵对手已死卡
	defenceCards := []document.ID{}
	for _, cardID := range ret.(*scheme.HuntingDefenceRoleInfo).DefenceCards {
		if state, ok := routeInfo.EnemyStates[cardID]; ok {
			if state[0] <= 0 {
				defenceCards = append(defenceCards, "")
			} else {
				defenceCards = append(defenceCards, cardID)
			}
		} else {
			defenceCards = append(defenceCards, "")
		}
	}
	battleModel.DefenceCards = defenceCards
	battleModel.DefenceCardAttrs = ret.(*scheme.HuntingDefenceRoleInfo).DefenceCardAttrs
	battleModel.DefenceCardAttrs2 = ret.(*scheme.HuntingDefenceRoleInfo).DefenceCardAttrs2
	battleModel.DefencePassiveSkills = ret.(*scheme.HuntingDefenceRoleInfo).DefencePassiveSkills

	// 处理自身
	// 存阵容
	routeInfo.Cards = battleModel.Cards
	// 初始化新卡的states
	for _, cardID := range battleModel.Cards {
		if cardID != "" {
			if _, ok := routeInfo.CardStates[cardID]; !ok {
				routeInfo.CardStates[cardID] = [2]float64{1.0, 0.0}
			}
		}
	}

	db.HuntingRoute[document.Integer(route)] = routeInfo
	r.SetHuntingRoute(db.HuntingRoute)

	// TODO 反作弊用 先注释
	//h.battles.Store(r.RoleDbID(), &battleInfo{
	//	roleID:      r.RoleDbID(),
	//	recordID:    r.GetID(),
	//	battleID:    battleModel.ID,
	//	model:       battleModel,
	//	agentFinish: make(chan int),
	//})

	return battleModel, nil
}

// 结束战斗
func (r *HuntingRecord) endBattle(container service.IContainer, req ReqHuntingBattleEnd, h *Hunting) error {
	db := r.GetLockedDB()
	routeInfo := db.HuntingRoute[document.Integer(req.Route)]

	// 更新CardStates
	for cardID, states := range req.CardStates {
		if cardID != "" {
			hp, mp := states[0], states[1]
			hp = Min(1.0, Max(0, hp))
			mp = Min(1.0, Max(0, mp))
			if _, ok := routeInfo.CardStates[cardID]; ok {
				routeInfo.CardStates[cardID] = [2]float64{hp, mp}
			}
		}
	}
	// 更新Cards
	newCards := []document.ID{}
	for _, cardID := range req.CardIDs {
		if state, ok := routeInfo.CardStates[cardID]; ok {
			if state[0] <= 0 {
				newCards = append(newCards, "")
			} else {
				newCards = append(newCards, cardID)
			}
		} else {
			newCards = append(newCards, "")
		}
	}
	routeInfo.Cards = newCards

	// win的处理
	if req.Result == "win" {
		// TODO 反作弊校验 先注释
		//var battle *battleInfo
		//if b, ok := h.battles.Load(db.RoleDbID); ok {
		//	battle = b.(*battleInfo)
		//	h.battles.Delete(db.RoleDbID)
		//} else {
		//	return ErrHuntingBattleNotFound
		//}
		//err := r.checkBattle(battle, req, h)
		//if err != nil {
		//	return err
		//}

		// 清空EnemyStates
		routeInfo.EnemyStates = map[document.ID][2]float64{}
		// 生成三选一 buffs
		r.randomBuffs(req.Route, req.GateID)

		// 防守阵容标志 减一
		serviceCross := container.GetService(req.CrossKey)
		if serviceCross == nil {
			return nil
		}
		_, _ = service.Call(serviceCross, "HuntingBattleCountSub", routeInfo.BattleRoleKey.RecordID)
	} else {
		// 更新EnemyStates
		for cardID, states := range req.EnemyStates {
			if cardID != "" {
				hp, mp := states[0], states[1]
				hp = Min(1.0, Max(0, hp))
				mp = Min(1.0, Max(0, mp))
				if _, ok := routeInfo.EnemyStates[cardID]; ok {
					routeInfo.EnemyStates[cardID] = [2]float64{hp, mp}
				}
			}
		}
	}
	r.SetHuntingRoute(db.HuntingRoute)

	return nil
}

// 随机 三选一buff
func (r *HuntingRecord) randomBuffs(route, gateID int) {
	db := r.GetLockedDB()
	routeInfo := db.HuntingRoute[document.Integer(route)]
	cfgGate := csv.GetConfig().Cross.Hunting.Gate[gateID]

	// 生成三选一 buffs
	if cfgGate.IsBuff == 1 && len(cfgGate.BuffType) != 0 {
		if len(routeInfo.BoardBuffs) == 0 {
			buffs := util.NewSet()
			buffGroupsSet := util.NewSet()
			for _, buff := range routeInfo.Buffs {
				cfg := csv.GetConfig().Cross.Hunting.Buffs[buff]
				buffs.Add(buff)
				buffGroupsSet.Add(cfg.Group)
			}
			var buffWeights []util.WeightElement
			buffGroupWeights := GetConfig().HuntingBuffRandom
			for _, ty := range cfgGate.BuffType.ToIntSlice() {
				for _, buffWeightElement := range buffGroupWeights[ty] {
					buff := buffWeightElement.(util.WeightInts)[0]
					if !buffs.Contains(buff) {
						cfg := csv.GetConfig().Cross.Hunting.Buffs[buff]
						if buffGroupsSet.Contains(cfg.Group) {
							// 已存在该group则权重增加
							weight := buffWeightElement.(util.WeightInts)[1]
							buffWeightElement = util.WeightInts{buff, weight + cfg.GroupWeight}
						}
						buffWeights = append(buffWeights, buffWeightElement)
					}
				}
			}
			var addBuffs []util.WeightElement
			if len(buffWeights) == 1 {
				for j := 1; j <= 3; j++ {
					addBuffs = append(addBuffs, buffWeights[0])
				}
			} else if len(buffWeights) == 2 {
				addBuffs = buffWeights
				addBuffs = append(addBuffs, buffWeights[0])
			} else if len(buffWeights) >= 3 {
				addBuffs = util.OnceSimpleRandom(buffWeights, 3)
			}
			for _, v := range addBuffs {
				buff := v.(util.WeightInts)[0]
				routeInfo.BoardBuffs = append(routeInfo.BoardBuffs, buff)
			}
		}
	}

	r.SetHuntingRoute(db.HuntingRoute)
}

// 碾压
func (r *HuntingRecord) passBattle(container service.IContainer, route, node, gateID int, crossKey string, top10Cards []document.ID) {
	db := r.GetLockedDB()

	routeInfo := db.HuntingRoute[document.Integer(route)]
	// 加怒气
	cfgGate := csv.GetConfig().Cross.Hunting.Gate[gateID]
	for _, cardID := range top10Cards {
		if state, ok := routeInfo.CardStates[cardID]; ok {
			if state[0] > 0 {
				state[1] = Min(state[1]+float64(cfgGate.RecoverMp)/1000, 1.0)
				routeInfo.CardStates[cardID] = state
			}
		} else {
			mp := Min(float64(cfgGate.RecoverMp)/1000, 1.0)
			routeInfo.CardStates[cardID] = [2]float64{1.0, mp}
		}
	}

	// 清空EnemyStates
	routeInfo.EnemyStates = map[document.ID][2]float64{}
	// 随机 三选一Buff
	r.randomBuffs(route, gateID)

	// 防守阵容标志 减一
	serviceCross := container.GetService(crossKey)
	if serviceCross == nil {
		return
	}
	_, _ = service.Call(serviceCross, "HuntingBattleCountSub", routeInfo.BattleRoleKey.RecordID)

	r.SetHuntingRoute(db.HuntingRoute)
}

// 阵容被分解 下阵
func (r *HuntingRecord) refreshCards(delCards []document.ID) {
	db := r.GetLockedDB()
	delCardSet := util.NewSet()
	for _, cardID := range delCards {
		delCardSet.Add(cardID)
	}
	for route, routeInfo := range db.HuntingRoute {
		newCards := []document.ID{}
		for _, card := range routeInfo.Cards {
			if !delCardSet.Contains(card) {
				newCards = append(newCards, card)
			} else {
				newCards = append(newCards, "")
			}
		}
		routeInfo.Cards = newCards
		db.HuntingRoute[route] = routeInfo
	}
	r.SetHuntingRoute(db.HuntingRoute)
}

// 反作弊检查
func (r *HuntingRecord) checkBattle(battle *battleInfo, data ReqHuntingBattleEnd, h *Hunting) error {
	battle.mu.Lock()
	battle.model.Actions = data.Actions
	battle.mu.Unlock()

	go h.pushBattleToVerifyQueue(battle)

	if battle.agentResult == "fail" {
		return ErrHuntingCheat
	} else {
		if data.Damage > data.MaxDamage {
			return ErrHuntingCheat
		}
	}

	return nil
}

// Hunting
type Hunting struct {
	lock sync.RWMutex
	key  string

	battles           sync.Map
	agent             service.IService // 反作弊
	battleVerifyQueue chan *battleInfo // 反作弊校验队列
	server            *Service
}

func (h *Hunting) init(s *Service, agent service.IService, key string) {
	h.key = key
	if h.agent == nil {
		h.agent = agent
		h.battleVerifyQueue = make(chan *battleInfo, BattleVerifyQueueSize)
		h.server = s
		// go h.runBattleAgentVerify()
	}
}

func (h *Hunting) isRightNodeType(target int, node int, routeInfo *scheme.HuntingRouteInfo) bool {
	nodeType := csv.GetConfig().Cross.Hunting.Route[node].Type

	switch target {
	case BattleType:
		if nodeType != BattleType {
			if nodeType == MultiType {
				if routeInfo.BoardID < 3 {
					return false
				}
			} else {
				return false
			}
		}
	case BoxType:
		if nodeType != BoxType {
			if nodeType == MultiType {
				if routeInfo.BoardID != 1 {
					return false
				}
			} else {
				return false
			}
		}
	case SupplyType:
		if nodeType != SupplyType {
			if nodeType == MultiType {
				if routeInfo.BoardID != 2 {
					return false
				}
			} else {
				return false
			}
		}
	case MultiType:
		if nodeType != MultiType {
			return false
		}
	default:
		return false
	}
	return true
}

func (h *Hunting) pushBattleToVerifyQueue(battle *battleInfo) {
	util.SimpleTry(func() {
		t := time.NewTicker(BattleWaitVerifyTimeout)
		select {
		case h.battleVerifyQueue <- battle:
			select {
			case <-battle.agentFinish:
			case <-t.C:
				log.Warningf("Hunting battle %v wait verify timeout", battle.battleID)
			}
		case <-t.C:
			log.Warningf("Hunting battle %v push verify timeout", battle.battleID)
		}
	}, nil)
}

func (h *Hunting) runBattleAgentVerify() {
	log.Info("Hunting start runBattleAgentVerify")
	util.SimpleTry(func() {
		for {
			select {
			case b := <-h.battleVerifyQueue:

				data, err := util.MsgPack(b.model)
				if err != nil {
					log.Warningf("Hunting battle %v verify msgpack err %v", b.battleID, err)
					b.onAgentFinish()
					continue
				}

				result, err := service.CallWithTimeout(h.agent, "NewHuntingBattle", BattleVerifyTimeout, h.server.Name(), b.battleID, data)
				if err != nil {
					log.Warningf("Hunting battle %v verify call err %v", b.battleID, err)
					b.onAgentFinish()
					continue
				}

				b.mu.Lock()
				b.agentResult = result.(string)
				b.mu.Unlock()

				if b.agentResult != "win" {
					log.Warningf("Hunting battle %v verify result err %v", b.battleID, result)
					b.onAgentFinish()
					continue
				}
				b.onAgentFinish()
			}
		}
	}, nil)
}

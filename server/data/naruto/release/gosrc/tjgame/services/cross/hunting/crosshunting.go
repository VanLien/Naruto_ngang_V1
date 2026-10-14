package hunting

import (
	"errors"
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

// 远征全局
type HuntingGlobal struct {
	*scheme.HuntingGlobalObject
	container service.IContainer

	builder *Builder
	key     string

	defenceRecordCount sync.Map // {ArenaHuntingRecord.ID: count}
	lock               sync.RWMutex

	// 新的阵容库 用于缓存新生成的
	newBattleCards      map[document.Integer][]*scheme.BattleCardInfo
	genBattleCardStatus int // 1 进行中，0 结束
	// 刷新名单 定时器
	timer *time.Timer

	genQueue  chan *battleCardsChan // 用于接受arena回来的阵容
	closeChan chan bool             // 生成阵容库结束
}

func (h *HuntingGlobal) init(builder *Builder) {
	h.builder = builder
	h.key = h.Key()
	h.defenceRecordCount = sync.Map{}
	h.newBattleCards = map[document.Integer][]*scheme.BattleCardInfo{}
	h.genQueue = make(chan *battleCardsChan, 1024)
	h.closeChan = make(chan bool)
}

func (h *HuntingGlobal) clean() {
	h.SetBattleCards(map[document.Integer][]*scheme.BattleCardInfo{})
}

// 服务启动
func (h *HuntingGlobal) ResetToday() {
	if len(h.BattleCards()) == 0 {
		h.notifyArenaGen()
	} else {
		if h.LastDate() == util.Todaydate2int() {
			duration := genTime.CombineDateInt(h.LastDate()).AddDate(0, 0, 1).Sub(util.Now())
			log.Infof("CrossHunting ResetToday next gen battleCards delta %s", duration)
			h.timer = time.AfterFunc(duration, h.notifyArenaGen)
		} else {
			h.notifyArenaGen()
		}
	}
}

// 通知arena生成阵容库
func (h *HuntingGlobal) notifyArenaGen() {
	h.genBattleCardStatus = 1
	err := service.Notify("NotifyGenHuntingCards", h.key)
	if err != nil {
		log.Warningf("CrossHunting NotifyGenHuntingCards err %v", err)
	}
	h.closeChan = make(chan bool)
	h.genQueue = make(chan *battleCardsChan, 1024)
	go h.runGenBattleCards()

	h.SetLastDate(util.Todaydate2int())
	duration := time.Minute * 5
	if TestInQuick {
		duration = time.Second * 30
	}
	// 过5分钟后 刷新阵容库
	time.AfterFunc(duration, h.refreshBattleCards)
	log.Infof("CrossHunting refresh battleCards delta %s", duration)
}

func (h *HuntingGlobal) pushGenBattleCards(serverKey string, bcChan *battleCardsChan) {
	// log.Infof("CrossHunting.pushGenBattleCards serverKey %s size %d", serverKey, len(bcChan.BattleCards))
	if h.genBattleCardStatus == 0 {
		log.Infof("CrossHunting.pushGenBattleCards serverKey %v timeout", serverKey)
		return
	}
	util.SimpleTry(func() {
		t := time.NewTicker(time.Second * 3)
		select {
		case <-h.closeChan:
			return
		case h.genQueue <- bcChan:
			select {
			case <-bcChan.genFinish:
			case <-t.C:
				log.Warningf("CrossHunting run battleCards serverKey %v timeout", serverKey)
			}
		}
	}, nil)
}

func (h *HuntingGlobal) runGenBattleCards() {
	log.Info("CrossHunting start runAcceptBattleCards")
	util.SimpleTry(func() {
		for {
			select {
			case <-h.closeChan:
				return
			case b := <-h.genQueue:
				if b == nil {
					return
				}
				h.onGenBattleCards(b.GameKey, b.BattleCards)
				b.onGenFinish()
			}
		}
	}, nil)
}

// 生成 新阵容库
func (h *HuntingGlobal) onGenBattleCards(serverKey string, battleCards []*BattleCard) {
	num := 0
	// 根据 战力区间生成名单
	for _, battleCard := range battleCards {
		fightingPoint := battleCard.FightingPoint // 防守战力和
		ranges := GetConfig().BCRanges
		if rr := ranges.GetRange(fightingPoint); rr != nil {
			bcRange := rr.(*BCRange)
			csvID, limit := bcRange.getCsvID(fightingPoint)
			if battleCardInfos, ok := h.newBattleCards[document.Integer(csvID)]; ok {
				if len(battleCardInfos) >= limit {
					continue
				} else {
					battleCardInfo := scheme.BattleCardInfo{
						RecordID: battleCard.RecordID,
						RoleDbID: battleCard.RoleDbID,
						GameKey:  battleCard.GameKey,
					}
					battleCardInfos = append(battleCardInfos, &battleCardInfo)
					h.newBattleCards[document.Integer(csvID)] = battleCardInfos
					num++
				}
			} else {
				battleCardInfo := scheme.BattleCardInfo{
					RecordID: battleCard.RecordID,
					RoleDbID: battleCard.RoleDbID,
					GameKey:  battleCard.GameKey,
				}
				h.newBattleCards[document.Integer(csvID)] = []*scheme.BattleCardInfo{&battleCardInfo}
				num++
			}
		}
		//else {
		//	log.Warningf("fightingPoint %d can not get range", fightingPoint)
		//}
	}
	log.Infof("CrossHunting.onGenBattleCards serverKey %s size %d", serverKey, num)

}

// 刷新 阵容库（新覆盖旧）
func (h *HuntingGlobal) refreshBattleCards() {
	h.genBattleCardStatus = 0
	close(h.closeChan)
	close(h.genQueue)

	if len(h.newBattleCards) == 0 {
		h.notifyArenaGen()
		return
	}
	newSize := 0
	for _, bcCards := range h.newBattleCards {
		newSize += len(bcCards)
	}
	log.Infof("CrossHunting.refreshBattleCards newBattleCards stage %d size %d", len(h.newBattleCards), newSize)
	battleCards := h.BattleCards()
	retainBattleCards := map[document.Integer][]*scheme.BattleCardInfo{}

	// 每个区间开一个线程去跑
	var lock sync.Mutex
	var wg sync.WaitGroup
	wg.Add(len(battleCards))
	for csvID, battleCard := range battleCards {
		go func() {
			rBattleCard := []*scheme.BattleCardInfo{}
			for _, battleCardInfo := range battleCard {
				if count, ok := h.defenceRecordCount.Load(battleCardInfo.RecordID); ok {
					if count.(int) > 0 {
						rBattleCard = append(rBattleCard, battleCardInfo)
					}
				}
			}
			lock.Lock()
			defer lock.Unlock()
			if len(rBattleCard) > 0 {
				retainBattleCards[csvID] = rBattleCard
			}
			wg.Done()
		}()
	}
	wg.Wait()

	retainSize := 0
	for _, bcCards := range retainBattleCards {
		retainSize += len(bcCards)
	}
	log.Infof("CrossHunting.refreshBattleCards retainSize stage %d size %d", len(retainBattleCards), retainSize)

	util.WithGuard(h, func() {
		for csvID, battleCard := range retainBattleCards {
			if bCard, ok := h.newBattleCards[csvID]; ok {
				h.newBattleCards[csvID] = append(bCard, battleCard...)
			} else {
				h.newBattleCards[csvID] = battleCard
			}
		}
		h.SetBattleCards(h.newBattleCards)
		h.newBattleCards = map[document.Integer][]*scheme.BattleCardInfo{}
	})

	if TestInQuick {
		TestInQuick = false
		return
	}

	duration := genTime.CombineDateInt(util.Todaydate2int()).AddDate(0, 0, 1).Sub(util.Now())
	log.Infof("CrossHunting next gen battleCards delta %s", duration)
	h.timer = time.AfterFunc(duration, h.notifyArenaGen)
}

// 随机一个 阵容名单
func (h *HuntingGlobal) randomBattleCards(fixFP int) (*scheme.BattleCardInfo, error) {
	db, unlock := h.RLockAndGetDB()
	defer unlock()
	// 根据TOP6战力 修正后匹配一个对手名单
	csvID := 0
	ranges := GetConfig().BCRanges
	if rr := ranges.GetRange(fixFP); rr != nil {
		bcRange := rr.(*BCRange)
		csvID, _ = bcRange.getCsvID(fixFP)
	} else {
		log.Warningf("fightingPoint %d can not get range", fixFP)
	}
	bCards := []*scheme.BattleCardInfo{}
	if bCs, ok := db.BattleCards[document.Integer(csvID)]; !ok {
		// 找不到就往高查10个区间
		for i := 1; i <= 10; i++ {
			if cardInfos, ok := db.BattleCards[document.Integer(csvID+i)]; ok {
				bCards = cardInfos
				break
			}
		}
		if len(bCards) == 0 {
			// 再找不到就往低查10个区间，再找不到就砸服务器
			for i := 1; i <= 10; i++ {
				idx := csvID - i
				if idx < 1 {
					break
				}
				if cardInfos, ok := db.BattleCards[document.Integer(idx)]; ok {
					bCards = cardInfos
					break
				}
			}
		}
	} else {
		bCards = bCs
	}
	if len(bCards) == 0 {
		return nil, errors.New("can not random BattleRole")
	}
	bc := bCards[rand.Intn(len(bCards))]
	// 标识加一
	h.defenceRecordCountAdd(bc.RecordID)
	return bc, nil
}

// 防守阵容 挑战标识加一
func (h *HuntingGlobal) defenceRecordCountAdd(recordID document.ID) {
	if c, ok := h.defenceRecordCount.Load(recordID); ok {
		count := c.(int)
		h.defenceRecordCount.Store(recordID, count+1)
	} else {
		h.defenceRecordCount.Store(recordID, 1)
	}
}

// 防守阵容 挑战标识减一
func (h *HuntingGlobal) defenceRecordCountSub(recordID document.ID) bool {
	if c, ok := h.defenceRecordCount.Load(recordID); ok {
		count := c.(int)
		if count <= 0 {
			return false
		}
		h.defenceRecordCount.Store(recordID, count-1)
	} else {
		return false
	}
	return true
}

// 5点定时 隔三天清除标识
func (h *HuntingGlobal) cleanDefenceRecordCount() {
	log.Infof("CrossHunting.cleanDefenceRecordCount")
	now := util.Now()
	// 清除标识
	util.WithGuard(h, func() {
		h.defenceRecordCount = sync.Map{}
	})
	// 下次定时
	duration := util.DateTimeCombine(util.Todaydate2int(), 5, 0, 0).Add(util.OneDay * 3).Sub(now)
	log.Infof("CrossHunting next cleanDefenceRecordCount delta %v", duration)
	time.AfterFunc(duration, h.cleanDefenceRecordCount)
}

// 获取区间的阵容信息
func (h *HuntingGlobal) getHuntingBattleCards(container service.IContainer, csvID int, battleCard []*scheme.BattleCardInfo) ([]*BattleCardRole, error) {
	battleCardRoles := []*BattleCardRole{}
	for _, bCard := range battleCard {
		name := csv.GetMergeConfig().GetSrcServKeys(bCard.GameKey)[0]
		serviceKey := service.TransformName(name, "arena")
		err := cross.ContainerServices(container, serviceKey)
		serviceArena := container.GetService(serviceKey)
		ret, err := service.CallWithTimeout(serviceArena, "GetArenaHuntingRoleInfo", time.Second*15, bCard.RecordID, bCard.RoleDbID, bCard.GameKey, false)
		if err != nil {
			return nil, err
		}
		r := ret.(*scheme.HuntingDefenceRoleInfo)
		beforeFP := 0
		allFP := 0
		defenceCardID := []int{}
		for _, cardAttrs := range r.DefenceCardAttrs {
			// 有修正用修正，没修正用原来
			if cardAttrs.FightingPoint2 == 0 {
				allFP += cardAttrs.FightingPoint
			} else {
				allFP += cardAttrs.FightingPoint2
			}
			beforeFP += cardAttrs.FightingPoint
			defenceCardID = append(defenceCardID, cardAttrs.CardId)
		}
		battleCardRole := &BattleCardRole{
			CsvID:               csvID,
			Name:                r.Name,
			GameKey:             r.GameKey,
			FightingPoint:       allFP,
			BeforeFightingPoint: beforeFP,
			DefenceCards:        defenceCardID,
		}
		battleCardRoles = append(battleCardRoles, battleCardRole)
	}
	return battleCardRoles, nil
}

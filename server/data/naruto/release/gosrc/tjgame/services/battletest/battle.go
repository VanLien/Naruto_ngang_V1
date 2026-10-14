package battletest

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"math/rand"
	"os"
	"sync"
	"sync/atomic"
	"time"
	"tjgame/services/union_fight"

	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	anti_cheat "tjgame/services/anti-cheat"
	"tjgame/services/arena"
	"tjgame/services/craft"
	crosscraft "tjgame/services/cross/craft"

	"tjgame/mgo.v2/bson"
)

const agentTimeout = 10 * time.Second

var (
	ErrTimeout = errors.New("timeout")
)

func NewDocumentID() document.ID {
	return document.ID(bson.NewObjectId())
}

type PlayRecordMaker interface {
	RoleValid(role *Role) bool
	MakePlayRecords(role1 *Role, role2 *Role) []document.IDocument
}

type BattleFuture struct {
	*service.Future

	id        document.ID
	model     []byte
	timestamp time.Time

	Error  error
	Result interface{}
}

func (f *BattleFuture) send(s service.IService, method string, name string) {
	f.Future = service.CallAsync(s, method, name, f.id, f.model)
	f.timestamp = time.Now()
}

type Manager struct {
	name   string
	method string
	agent  service.IService

	futures sync.Map
	matchs  [][2]*Role
	maker   PlayRecordMaker

	running    int32
	unfinished int
	finish     context.Context
	cancel     context.CancelFunc

	*statistics
}

func (m *Manager) isRunning() bool {
	return atomic.LoadInt32(&m.running) == 1
}

func (m *Manager) Start() bool {
	if atomic.CompareAndSwapInt32(&m.running, 0, 1) {
		m.cardRecords = make(map[int]*cardRecordItem)
		return true
	}
	return false
}

func (m *Manager) loop() {
	timer := time.NewTimer(2 * time.Second)
	for atomic.LoadInt32(&m.running) == 1 {
		<-timer.C
		now := time.Now()
		m.futures.Range(func(key, value interface{}) bool {
			future := value.(*BattleFuture)
			if future.Future == nil {
				return true
			}
			select {
			case <-future.Wait():
				m.onResponse(future)
			default:
				if now.Sub(future.timestamp) > agentTimeout {
					m.onTimeout(future)
				}
			}
			return true
		})
		log.Debugf("unfinished %d", m.unfinished)
		if m.unfinished > 0 {
			timer.Reset(2 * time.Second)
		} else {
			break
		}
	}
	timer.Stop()
	m.cancel()
	atomic.StoreInt32(&m.running, 0)
}

func (m *Manager) Run() {
	concurrency := 4
	start := time.Now()
	var unfinished int64
	var wg sync.WaitGroup
	wg.Add(len(m.matchs))
	plays := make(chan document.IDocument, concurrency)
	m.statistics.reset()

	for _, roles := range m.matchs {
		go func(r1, r2 *Role) {
			models := m.maker.MakePlayRecords(r1, r2)
			atomic.AddInt64(&unfinished, int64(len(models)))
			for _, model := range models {
				plays <- model
			}
			wg.Done()
		}(roles[0], roles[1])
	}

	for i := 0; i < concurrency; i++ {
		go func() {
			for model := range plays {
				id := model.GetID()
				if data, err := util.MsgPack(model); err == nil {
					future := &BattleFuture{
						id:    id,
						model: data,
					}
					future.send(m.agent, m.method, m.name) // 发送给反作弊计算
					m.futures.Store(id, future)
				} else {
					log.Warningf("build error")
				}
			}
		}()
	}

	wg.Wait()
	close(plays)

	m.unfinished = int(unfinished)
	total := len(m.matchs)
	m.finish, m.cancel = context.WithCancel(context.Background())
	go m.loop()

	log.Infof("MakePlayAndRun match %d, make %d play cost %v", total, unfinished, time.Now().Sub(start))
	<-m.finish.Done()
	log.Infof("%s %s", m.name, m.statistics)
}

func (m *Manager) Cancel() {
	if m.cancel != nil {
		m.cancel()
	}
}

func (m *Manager) onTimeout(future *BattleFuture) {
	//log.Warningf("play %v %s result error %v", future.id, m.name, ErrTimeout)
	//future.Error = ErrTimeout
	//m.futures.Delete(future.id)
	//m.futures.Store(future.id, future)
}

func (m *Manager) onResponse(future *BattleFuture) {
	resp, err := future.Get()
	future.Future = nil
	if err != nil {
		if err.Error() == anti_cheat.ErrWaitQueueFull.Error() {
			// resend
			duration := time.Duration(rand.Int31n(10) + 10)
			time.AfterFunc(duration*time.Second, func() {
				future.send(m.agent, m.method, m.name)
				log.Warningf("play %v %s %v, waiting resend", future.id, m.name, err)
			})
			return
		}
		future.Error = err
		log.Warningf("play %v %s result error %v", future.id, m.name, err)
	} else {
		future.Result = resp
	}
	log.Infof("play %v %s result %v", future.id, m.name, resp)
	m.futures.Delete(future.id)
	var result string
	switch v := resp.(type) {
	case string:
		m.recordResult(v, future.model)
		result = v
	case anti_cheat.CraftBattleResult:
		m.recordResult(v.Result, future.model)
		result = v.Result
	case anti_cheat.UnionFightBattleResult:
		m.recordResult(v.Result, future.model)
		result = v.Result
	default:
		log.Panicf("unknown result type %T", resp)
	}
	if result == "error" {
		os.Mkdir("plays", 077)
		// write to file
		if data, err := util.MsgPack([]interface{}{m.name, future.model}); err == nil {
			err = ioutil.WriteFile(fmt.Sprintf("plays/%s_%x.play", m.name, string(future.id)), data, 0777)
			if err != nil {
				log.Warning(err)
			}
		} else {
			log.Warning(err)
		}
	}
	m.unfinished--
}

func NewBattleManager(name string, agent service.IService, method string) *Manager {
	test := &Manager{
		name:   name,
		method: method,
		agent:  agent,
	}
	test.statistics = &statistics{}
	return test
}

// Arena
type ArenaPlayRecordMaker struct {
	services map[string]service.IService
}

func (m *ArenaPlayRecordMaker) RoleValid(role *Role) bool {
	return role.PvpRecordDbId != ""
}

func (m *ArenaPlayRecordMaker) MakePlayRecords(role1 *Role, role2 *Role) []document.IDocument {
	resp, err := service.Call(m.services[role1.Key("arena")], "GetArenaRoleInfo", role1.PvpRecordDbId)
	if err != nil {
		panic(err)
	}
	r1 := resp.(*scheme.ArenaRecordObject)
	record1, unlock := r1.RLockAndGetDB()
	unlock()

	resp, err = service.Call(m.services[role2.Key("arena")], "GetArenaRoleInfo", role2.PvpRecordDbId)
	if err != nil {
		panic(err)
	}
	r2 := resp.(*scheme.ArenaRecordObject)
	record2, unlock := r2.RLockAndGetDB()
	unlock()

	models := make([]document.IDocument, 0, 20)
	for i := 0; i < 5; i++ {
		model := arena.NewPlayModel(arena.NewRecord(record1), arena.NewRecord(record2))
		model.ID = NewDocumentID()
		models = append(models, model)
	}
	for i := 0; i < 5; i++ {
		model := arena.NewPlayModel(arena.NewRecord(record2), arena.NewRecord(record1))
		model.ID = NewDocumentID()
		models = append(models, model)
	}
	for i := 0; i < 5; i++ {
		model := arena.NewPlayModel(arena.NewRecord(record1), arena.NewRecord(record1))
		model.ID = NewDocumentID()
		models = append(models, model)
	}
	for i := 0; i < 5; i++ {
		model := arena.NewPlayModel(arena.NewRecord(record2), arena.NewRecord(record2))
		model.ID = NewDocumentID()
		models = append(models, model)
	}
	return models
}

// Gate 普通，精英，噩梦关卡
type GatePlayRecordMaker struct {
	services map[string]service.IService
}

type Gates struct {
	Gates          []int `json:"gates"`
	HeroGates      []int `json:"hero_gates"`
	NightmareGates []int `json:"nightmare_gates"`
	EndlessGates   []int `json:"endless_gates"`
}

var (
	allGates = make([]int, 0, 1024)
	gatescfg Gates
)

func initGate() {
	content, err := ioutil.ReadFile("gates.json")
	if err != nil {
		panic(err)
	}
	err = json.Unmarshal(content, &gatescfg)
	if err != nil {
		panic(err)
	}

	allGates = append(allGates, gatescfg.Gates...)
	allGates = append(allGates, gatescfg.HeroGates...)
	allGates = append(allGates, gatescfg.NightmareGates...)
	allGates = append(allGates, gatescfg.EndlessGates...)
}

type GatePlayRecord struct {
	document.DocumentID
	// 主动进攻方角色等级
	Level int `codec:"level"`
	// 关卡ID
	GateID int `codec:"gate_id"`
	// 战斗随机种子
	RandSeed int32 ` codec:"rand_seed"`
	// 主动进攻部署卡牌列表
	Cards []document.ID `bson:"cards" codec:"cards"`
	// 主动进攻卡牌离线属性
	CardAttrs map[document.ID]*scheme.CardBattleModel `bson:"card_attrs" codec:"card_attrs"`
	// 主动进攻全局被动技能
	PassiveSkills map[document.Integer]int `bson:"passive_skills" codec:"passive_skills"`
}

func (*GatePlayRecord) CollectionName() string {
	return "GatePlayRecord"
}

func (m *GatePlayRecordMaker) RoleValid(role *Role) bool {
	return true
}

func (m *GatePlayRecordMaker) MakePlayRecords(role1 *Role, role2 *Role) []document.IDocument {
	resp, err := service.Call(m.services[role1.Key("arena")], "GetArenaRoleInfo", role1.PvpRecordDbId)
	if err != nil {
		panic(err)
	}
	record1, unlock := resp.(*scheme.ArenaRecordObject).RLockAndGetDB()
	unlock()

	resp, err = service.Call(m.services[role2.Key("arena")], "GetArenaRoleInfo", role2.PvpRecordDbId)
	if err != nil {
		panic(err)
	}
	record2, unlock := resp.(*scheme.ArenaRecordObject).RLockAndGetDB()
	unlock()

	models := make([]document.IDocument, 0, 64)

	for _, gateid := range allGates {
		for _, r := range []scheme.ArenaRecord{*record1, *record2} {
			// 在这里关卡战斗用竞技场的防守阵容去打
			model := &GatePlayRecord{
				Level:         r.RoleLevel,
				GateID:        gateid,
				RandSeed:      rand.Int31n(99999999) + 1,
				Cards:         r.DefenceCards,
				CardAttrs:     r.DefenceCardAttrs,
				PassiveSkills: r.DefencePassiveSkills,
			}
			model.ID = NewDocumentID()
			models = append(models, model)
		}
	}
	return models
}

// Craft
type CraftPlayRecordMaker struct {
	services map[string]service.IService
}

// craft.NewRecord 会进行set操作，这里替换
func NewCraftRecord(record *scheme.CraftRecord) *craft.Record {
	r := &craft.Record{
		CraftRecordObject: scheme.NewCraftRecordObject(record),
	}
	return r
}

func (m *CraftPlayRecordMaker) RoleValid(role *Role) bool {
	return role.CraftRecordDbId != ""
}

func (m *CraftPlayRecordMaker) MakePlayRecords(role1 *Role, role2 *Role) []document.IDocument {
	resp, err := service.Call(m.services[role1.Key("craft")], "GetCraftRecord", role1.CraftRecordDbId)
	if err != nil {
		panic(err)
	}
	rr1 := resp.(*scheme.CraftRecordObject)
	record1, unlock := rr1.RLockAndGetDB()
	unlock()

	resp, err = service.Call(m.services[role2.Key("craft")], "GetCraftRecord", role2.CraftRecordDbId)
	if err != nil {
		panic(err)
	}
	rr2 := resp.(*scheme.CraftRecordObject)
	record2, unlock := rr2.RLockAndGetDB()
	unlock()

	r1, r2 := NewCraftRecord(record1), NewCraftRecord(record2)

	models := make([]document.IDocument, 0, 13*5)
	for _, round := range []string{"pre1", "pre2", "pre3", "pre4", "pre5", "pre6", "pre7", "pre8", "pre9", "pre10", "final1", "final2", "final3"} {
		for i := 0; i < 5; i++ {
			model := craft.NewPlayModel(round, r1, r2, []int{})
			model.ID = NewDocumentID()
			models = append(models, model)
		}
	}
	return models
}

// Union Fight
type UnionFightPlayRecordMaker struct {
	services map[string]service.IService
}

// craft.NewRecord 会进行set操作，这里替换
func NewUnionFightRoleRecord(record *scheme.UnionFightRoleRecord) *union_fight.RoleRecord {
	r := &union_fight.RoleRecord{
		UnionFightRoleRecordObject: scheme.NewUnionFightRoleRecordObject(record),
	}
	return r
}

func getUnionFightPlayCards(record *union_fight.RoleRecord, weekday, troop int) ([]document.ID, map[document.ID]*scheme.CardBattleModel, map[document.ID][2]float64, int) {
	cardsRecord := record.HoldCards()
	cardDRecord := record.HoldCardAttrs()
	cards := make([]document.ID, 6)                        // 卡牌站位
	cardD := make(map[document.ID]*scheme.CardBattleModel) // 卡牌属性
	cardS := make(map[document.ID][2]float64)              // 卡牌状态

	cardsInfo := cardsRecord[document.Integer(weekday)][document.Integer(troop)]
	for idx, cardID := range cardsInfo {
		if cardID == "" {
			continue
		}
		if attr, ok1 := cardDRecord[cardID]; !ok1 || attr == nil {
			log.Info("UnionFight role %s card attr not exists", record.RoleDbId())
			continue
		}

		cardS[cardID] = [2]float64{1, 1}
		cardD[cardID] = cardDRecord[cardID]
		cards[idx] = cardID
	}
	return cards, cardD, cardS, troop
}

func (m *UnionFightPlayRecordMaker) RoleValid(role *Role) bool {
	return role.UnionFightRecordDbId != ""
}

func (m *UnionFightPlayRecordMaker) MakePlayRecords(role1 *Role, role2 *Role) []document.IDocument {
	resp, err := service.Call(m.services[role1.Key("union_fight")], "GetUnionFightRoleRecord", role1.UnionFightRecordDbId)
	if err != nil {
		panic(err)
	}
	rr1 := resp.(*scheme.UnionFightRoleRecordObject)
	record1, unlock := rr1.RLockAndGetDB()
	unlock()

	resp, err = service.Call(m.services[role2.Key("union_fight")], "GetUnionFightRoleRecord", role2.UnionFightRecordDbId)
	if err != nil {
		panic(err)
	}
	rr2 := resp.(*scheme.UnionFightRoleRecordObject)
	record2, unlock := rr2.RLockAndGetDB()
	unlock()

	r1, r2 := NewUnionFightRoleRecord(record1), NewUnionFightRoleRecord(record2)

	weekdayTroopMap := map[int]int{2: 2, 3: 2, 4: 2, 5: 2, 6: 3}

	models := make([]document.IDocument, 0, 10*5)
	for weekday, troops := range weekdayTroopMap {
		for troopIdx := 1; troopIdx <= troops; troopIdx++ {
			for i := 0; i < 5; i++ {
				model := union_fight.NewPlayModel("1", r1, r2)
				model.ID = NewDocumentID()
				if weekday == 6 {
					model.Top83V3Round = 1
				}
				model.Cards, model.CardAttrs, model.CardStates, model.Troops = getUnionFightPlayCards(r1, weekday, troopIdx)
				model.DefenceCards, model.DefenceCardAttrs, model.DefenceCardStates, model.DefenceTroops = getUnionFightPlayCards(r2, weekday, troopIdx)
				models = append(models, model)
			}
		}
	}
	return models
}

// Cross Craft
type CrossCraftPlayRecordMaker struct {
	services map[string]service.IService
}

func (m *CrossCraftPlayRecordMaker) RoleValid(role *Role) bool {
	return role.CrossCraftRecordDbId != ""
}

func (m *CrossCraftPlayRecordMaker) MakePlayRecords(role1 *Role, role2 *Role) []document.IDocument {
	resp, err := service.Call(m.services[role1.Key("pvp")], "GetCrossCraftRecord", role1.CrossCraftRecordDbId)
	if err != nil {
		panic(err)
	}
	rr1 := resp.(*scheme.CrossCraftRecordObject)
	record1, unlock := rr1.RLockAndGetDB()
	unlock()

	resp, err = service.Call(m.services[role2.Key("pvp")], "GetCrossCraftRecord", role2.CrossCraftRecordDbId)
	if err != nil {
		panic(err)
	}
	rr2 := resp.(*scheme.CrossCraftRecordObject)
	record2, unlock := rr2.RLockAndGetDB()
	unlock()

	models := make([]document.IDocument, 0, 10*5)
	for _, round := range []string{
		"pre11", "pre12", "pre13", "pre14",
		"top64", "top32", "top16",
		"final1", "final2", "final3",
	} {
		for i := 0; i < 5; i++ {
			model := crosscraft.NewPlayModel(round, scheme.RoleKey{GameKey: role1.GameKey, ID: role1.ID}, record1, scheme.RoleKey{GameKey: role2.GameKey, ID: role2.ID}, record2, []int{})
			model.ID = NewDocumentID()
			models = append(models, model)
		}
	}
	return models
}

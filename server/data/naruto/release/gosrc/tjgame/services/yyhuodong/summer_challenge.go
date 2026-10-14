package yyhuodong

import (
	"errors"
	"fmt"
	"math/rand"
	"sync"
	"sync/atomic"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/document/schemeutil"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/services/game"
	tjcards "tjgame/services/game/cards"
)

var (
	ErrSummerChallengeBattleNotFound = errors.New("summerChallengeBattleError")
	ErrSummereChallengeGateID        = errors.New("summerChallengeGateIDError")
	ErrSummerChallengeCheat          = errors.New("cheatError")
)

type SummerChallenge struct {
	yyID int
	//卡池 {csvID: {cardID: {}}}
	cards map[int]*scheme.CardBattleModel
	// 同步是否完成
	complete int32

	game service.IService
	lock sync.RWMutex

	*AntiAgent
	// banRoles          sync.Map // 封禁角色
}


func (sc *SummerChallenge) init(s *Service, agent service.IService) error {
	log.Infof("[chanlong] SummerChallenge init: yyID=%s",sc.yyID)
	if sc.yyID != 0 {
		return nil
	}
	response := sc.eventToGame("yy_info", EventToGame{}, false)
	
	if response == nil {
		return errors.New("yy_info error")
	}

	//log.Infof("[chanlong] SummerChallenge init: response.YYID=%s",response.YYID)
	if response.YYID == 0 {
		return nil
	}
	cards := make([]int, 0)
	for _, cfg := range csv.GetConfig().Summer_challenge.Cards {
		cards = append(cards, cfg.ID)
	}

	if len(cards) <= 100 {
		sc.startCardSync(cards)
		atomic.StoreInt32(&sc.complete, 1)
	} else {
		for len(cards) > 100 {
			sc.startCardSync(cards[:100])
			cards = cards[100:]
		}
		sc.startCardSync(cards)
		atomic.StoreInt32(&sc.complete, 1)
	}

	// log.Infof("[chanlong] SummerChallenge init: complete=%s",atomic.LoadInt32(&sc.complete))

	if sc.AntiAgent == nil {
		sc.AntiAgent = &AntiAgent{
			agent:             agent,
			battleVerifyQueue: make(chan *battleInfo, BattleVerifyQueueSize),
			server:            s,
			name:              "summer_challenge",
			sync:              false,
			flag:              false,
			saveRecord:        false,
		}
		go runBattleAgentVerify(sc.AntiAgent)
	}
	return nil
}

func (sc *SummerChallenge) reset() {
	sc.lock.Lock()
	defer sc.lock.Unlock()
	sc.yyID = 0
	sc.cards = make(map[int]*scheme.CardBattleModel)
	atomic.CompareAndSwapInt32(&sc.complete, 1, 0)
}

func (sc *SummerChallenge) eventToGame(event string, data EventToGame, sync bool) *game.SummerChallengeEventResponse {
	if sc.game == nil {
		return nil
	}
	resp, err := service.Call(sc.game, "SummerChallengeEvent", event, data, nil)
	if err != nil {
	}
	return resp.(*game.SummerChallengeEventResponse)
}

func (sc *SummerChallenge) startCardSync(cards []int) {
	d := EventToGame{CsvIDs: cards}
	response := sc.eventToGame("calc_cards", d, false)
	if response == nil {
		log.Errorf("calc cards error %+v", cards)
		return
	}
	sc.syncCardAttrs(response.YYID, response.Cards)
}

// 同步卡牌属性数据
func (sc *SummerChallenge) syncCardAttrs(yyID int, cardAttrs map[int]*scheme.CardBattleModel) {
	sc.lock.Lock()
	defer sc.lock.Unlock()

	if sc.yyID != yyID {
		sc.cards = map[int]*scheme.CardBattleModel{}
		sc.yyID = yyID
	}

	for csvID, attrs := range cardAttrs {
		sc.cards[csvID] = attrs
	}
}

// 获取卡牌属性
func (sc *SummerChallenge) getCardAttrs(csvID int) scheme.CardBattleModel {
	cardAttrs := *sc.cards[csvID]
	cardAttrs.Attrs = schemeutil.CopyAttrs(sc.cards[csvID].Attrs)
	cardAttrs.PassiveSkills = schemeutil.CopySkills(sc.cards[csvID].PassiveSkills)
	return cardAttrs
}

type BattleData struct {
	GateID int                `codec:"gateID"`
	Cards  []int              `codec:"cards"`
	Buffs  []document.Integer `codec:"buffs"`
}

type SummerChallengeBattleModel struct {
	ID               document.ID                                   `codec:"id"`
	Level            int                                           `codec:"level"`
	RandSeed         int                                           `codec:"rand_seed"`
	Cards            map[int][]int                                 `codec:"cards"`
	CardAttrs        map[int]*scheme.CardBattleModel               `codec:"card_attrs"`
	DefenceCards     map[int][]document.ID                         `codec:"defence_cards"`
	DefenceCardAttrs map[document.ID]*scheme.CardBattleModel       `codec:"defence_card_attrs"`
	GateID           int                                           `codec:"gateID"`
	YYID             int                                           `codec:"yyID"`
	MonsterIDs       []int                                         `codec:"monsterIDs"`
	Actions          map[document.Integer][]scheme.BattleAction    `codec:"actions,omitempty"`
	Choices          map[document.Integer]map[document.Integer]int `codec:"choices,omitempty"`
}

func (sc *SummerChallenge) StartBattle(roleID document.ID, yyID int, data BattleData) (SummerChallengeBattleModel, error) {
	gateCfg := csv.GetConfig().Summer_challenge.Gates[data.GateID]
	log.Infof("[chanlong] StartBattle: %v",gateCfg)
	battleModel := SummerChallengeBattleModel{
		ID:               document.NewID(),
		RandSeed:         rand.Intn(99999999) + 1,
		Cards:            make(map[int][]int, 0),
		CardAttrs:        make(map[int]*scheme.CardBattleModel),
		DefenceCards:     make(map[int][]document.ID, 0),
		DefenceCardAttrs: make(map[document.ID]*scheme.CardBattleModel),
		GateID:           data.GateID, // summer_challenge.gates
		YYID:             yyID,
		MonsterIDs:       gateCfg.MonsterIDs.ToIntSlice(),
	}

	// 卡牌属性
	for _, csvID := range data.Cards {
		if _, ok := battleModel.Cards[1]; !ok {
			battleModel.Cards[1] = []int{}
		}
		battleModel.Cards[1] = append(battleModel.Cards[1], csvID)
		if csvID != 0 {
			card := sc.getCardAttrs(csvID)
			for _, skillID := range data.Buffs {
				card.PassiveSkills[skillID] = 1
			}
			battleModel.CardAttrs[csvID] = &card
		}
	}

	// 卡牌光环加成
	cardIDs := make([]int, 0, len(battleModel.Cards[1]))
	for _, csvID := range battleModel.Cards[1] {
		if csvID != 0 {
			cardIDs = append(cardIDs, csv.GetConfig().Summer_challenge.Cards[csvID].CardID)
		}
	}
	if len(battleModel.CardAttrs) == 6 {
		chooses := makeBattleCardHalo(battleModel.Cards[1], battleModel.CardAttrs, cardIDs, 0)
		if chooses != nil {
			for idx, id := range battleModel.Cards[1] {
				battleModel.CardAttrs[id].NatureChoose = chooses[idx] + 1
			}
		}
	}

	// 怪物属性 可能存在多编队
	for index, monsterID := range gateCfg.MonsterIDs.ToIntSlice() {
		monsterCfg := csv.GetConfig().Summer_challenge.Monsters[monsterID]
		if _, ok := battleModel.DefenceCards[index+1]; !ok {
			battleModel.DefenceCards[index+1] = []document.ID{}
		}

		for idx, csvID := range monsterCfg.Cards.ToIntSlice() {
			if csvID != 0 {
				cardID := document.ID(fmt.Sprintf("summerchallenge%d%05d", idx, csvID))
				battleModel.DefenceCards[index+1] = append(battleModel.DefenceCards[index+1], cardID)

				monster := sc.getCardAttrs(csvID)
				// 关卡怪物按位置属性修正
				monster.Attrs["hp"] *= monsterCfg.HpFix.ToFloat64Slice()[idx]
				monster.Attrs["damage"] *= monsterCfg.DamageFix.ToFloat64Slice()[idx]
				monster.Attrs["specialDamage"] *= monsterCfg.DamageFix.ToFloat64Slice()[idx]
				monster.Attrs["defence"] *= monsterCfg.DefenceFix.ToFloat64Slice()[idx]
				monster.Attrs["specialDefence"] *= monsterCfg.DefenceFix.ToFloat64Slice()[idx]
				monster.Attrs["speed"] *= monsterCfg.SpeedFix.ToFloat64Slice()[idx]
				battleModel.DefenceCardAttrs[cardID] = &monster
			} else {
				battleModel.DefenceCards[index+1] = append(battleModel.DefenceCards[index+1], "")
			}
		}

		// 怪物光环加成
		chooses := tjcards.AppendBattleCardHalo(battleModel.DefenceCards[index+1], battleModel.DefenceCardAttrs, 0)
		if chooses != nil {
			for idx, id := range battleModel.DefenceCards[index+1] {
				battleModel.DefenceCardAttrs[id].NatureChoose = chooses[idx] + 1
			}
		}
	}

	sc.battles.Store(roleID, &battleInfo{
		RoleID:      roleID,
		YYID:        yyID,
		battleID:    battleModel.ID,
		model:       &battleModel,
		agentFinish: make(chan int),
	})

	return battleModel, nil
}

func (sc *SummerChallenge) EndBattle(roleID document.ID, gateID int, result string, actions map[document.Integer][]scheme.BattleAction, choices map[document.Integer]map[document.Integer]int) (bool, error) {

	var battle *battleInfo
	if b, ok := sc.battles.Load(roleID); ok {
		battle = b.(*battleInfo)
	} else {
		return false, ErrSummerChallengeBattleNotFound
	}

	model := battle.model.(*SummerChallengeBattleModel)
	if model.GateID != gateID {
		return false, ErrSummereChallengeGateID
	}

	sc.battles.Delete(roleID)
	if result == "win" {
		battle.mu.Lock()
		model.Actions = actions
		model.Choices = choices
		battle.model = model
		battle.mu.Unlock()

		if sc.sync {
			log.Info("anti sync")
			pushBattleToVerifyQueue(sc.AntiAgent, battle)
		} else {
			log.Info("anti async")
			go pushBattleToVerifyQueue(sc.AntiAgent, battle)
		}

		if battle.agentResult == "fail" {
			return false, ErrSummerChallengeCheat
		}
	}
	return true, nil
}

package yyhuodong

import (
	"errors"
	"fmt"
	"math/rand"
	"sync"
	"sync/atomic"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/document/schemeutil"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/game"
	tjcards "tjgame/services/game/cards"
)

var (
	// play type
	AnniversaryBraveChallenge = 1 // 周年庆勇者
	NormalBraveChallenge      = 0 // 普通勇者

	// defs
	LocalBadgeType  document.Integer = 1
	GlobalBadgeType document.Integer = 2
	NormalBadge                      = 1
	RareBadge                        = 2

	UnlockNoType      = 0 // 无解锁条件
	UnlockCardType    = 1 // 获得指定卡牌解锁
	UnlockFailType    = 2 // 失败x次解锁
	UnlockBadgeType   = 3 // 获得指定徽章解锁
	UnlockMonsterType = 4 // 通过指定关卡解锁
	UnlockDailyType   = 5 // 按开放时间解锁

	BadgeAttrType  = 1 // 属性加成
	BadgeSkillType = 2 // 获得被动技能
	BadgeCardType  = 3 // 招募卡牌

	InFront = 1 // 前排加成
	InBack  = 2 // 后排加成
	AddAll  = 3 // 全体加成

	// error
	ErrBraveChallengeNoCard         = errors.New("braveChallengeNoCard")
	ErrBraveChallengeFloorID        = errors.New("braveChallengeFloorIDError")
	ErrBraveChallengeBadgeID        = errors.New("braveChallengeBadgeIDError")
	ErrBraveChallengeStatus         = errors.New("braveChallengeStatusError")
	ErrBraveChallengeCardLock       = errors.New("braveChallengeCardLockError")
	ErrBraveChallengeDuplicateCard  = errors.New("braveChallengeDuplicateCardError")
	ErrBraveChallengeBattleNotFound = errors.New("braveChallengeBattleError")
	ErrBraveChallengeCheat          = errors.New("cheatError")
	CheatBraveChallengeBanned       = errors.New("braveChallengeBanned")
)

type RespPrepareStart struct {
	Add []int `codec:"add"`
}

type ReqPrepareData struct {
	Cards       []int `codec:"cards"`
	UnlockCards []int `codec:"unlock_cards"`
}

type ReqBattleEnd struct {
	FloorID       int                                        `codec:"floorID"`
	Result        string                                     `codec:"result"`
	CardStates    map[document.Integer][2]float64            `codec:"card_states"`
	MonsterStates map[document.Integer][2]float64            `codec:"monster_states"`
	BattleRound   int                                        `codec:"battle_round"`
	Damage        float64                                    `codec:"damage"`
	Actions       map[document.Integer][]scheme.BattleAction `codec:"actions"`
}

type RespBattleEnd struct {
	AllPass   bool                  `codec:"all_pass" default:"false"`
	Refresh   bool                  `codec:"refresh" default:"false"`
	Kill      int                   `codec:"kill"`
	Die       int                   `codec:"die"`
	FirstPass bool                  `codec:"first_pass" default:"false"`
	RankData  []int                 `codec:"rank_data,omitempty"`
	RankInfo  scheme.RankInfo       `codec:"rank_info,omitempty"`
	Record    *BraveChallengeRecord `codec:"record,omitempty"`
}

type BraveChallengeBattleModel struct {
	ID               document.ID                                `codec:"id"`
	Level            int                                        `codec:"level"`
	RandSeed         int                                        `codec:"rand_seed"`
	Cards            []int                                      `codec:"cards"`
	CardAttrs        map[int]*scheme.CardBattleModel            `codec:"card_attrs"`
	CardStatus       map[document.Integer][2]float64            `bson:"cards_status" codec:"cards_status"`       // 可用卡牌 {cardID: (hp, mp)}
	MonstersStatus   map[document.ID][2]float64                 `bson:"monsters_status" codec:"monsters_status"` // 怪物卡牌 {cardID: (hp, mp)}
	DefenceCards     []document.ID                              `codec:"defence_cards"`
	DefenceCardAttrs map[document.ID]*scheme.CardBattleModel    `codec:"defence_card_attrs"`
	FloorID          int                                        `codec:"floorID"`
	YYID             int                                        `codec:"yyID"`
	MonsterID        int                                        `codec:"monsterID"`
	Actions          map[document.Integer][]scheme.BattleAction `codec:"actions,omitempty"`
}

type BraveChallengeRecord struct {
	*scheme.BraveChallengeRecordObject
}

func (record *BraveChallengeRecord) isFirstPass(floor int) bool {
	if _, ok := record.Floors()[document.Integer(floor)]; ok {
		return false
	} else {
		return true
	}
}

// 开始准备
func (record *BraveChallengeRecord) StartPrepare(bc *BraveChallenge) (RespPrepareStart, error) {
	db, unlock := record.LockAndGetDB()
	defer unlock()

	if db.Status == "start" {
		return RespPrepareStart{}, ErrBraveChallengeStatus
	}

	// 每日解锁卡牌
	if bc.isDailyUnlockCard {
		// 活动开启的第x天
		day := util.TodayInClock5ElapseDays(util.DateTimeCombine(bc.beginDate, util.DailyRefreshHour(), 0, 0)) + 1
		record.unlockCards(UnlockDailyType, day, bc.playType)
	}

	ret := RespPrepareStart{
		Add: db.Add,
	}
	record.SetAdd([]int{}) // 新增解锁仅第一次进入准备页面时提示
	record.SetStatus("preparing")
	return ret, nil
}

// 结束准备
func (record *BraveChallengeRecord) EndPrepare(cards []int, bc *BraveChallenge) error {
	db, unlock := record.LockAndGetDB()
	defer unlock()

	if db.Status != "preparing" {
		return ErrBraveChallengeStatus
	}

	// 判断卡牌是否可选
	cardPool := util.NewSet()
	for _, cardID := range db.UnlockCards {
		cardPool.Add(cardID)
	}
	cfg := GetBraveChallengeConfig(bc.playType)
	for _, cardID := range cfg.CardList {
		cardPool.Add(cardID)
	}
	for _, card := range cards {
		if !cardPool.Contains(card) {
			return ErrBraveChallengeCardLock
		}
	}

	deploy := [6]int{}
	markIDs := util.NewSet()
	for i := 0; i < 3; i++ {
		// 初始选择的三张卡自动上阵
		cfg := csv.GetConfig().Brave_challenge.Cards[cards[i]]
		cardCfg := csv.GetConfig().Cards[cfg.CardID]
		if !markIDs.Contains(cardCfg.CardMarkID) {
			deploy[i] = cards[i]
			markIDs.Add(cardCfg.CardMarkID)
		}
		record.onCardCounter(document.Integer(cards[i]), bc.playType)
	}

	// 生成关卡
	gateID, floorID := record.getRandomGate(1, record.isFirstPass(1), bc)
	gateCfg := csv.GetConfig().Brave_challenge.Monster[gateID]
	monsters := gateCfg.Cards.ToIntSlice()

	// 多次相同开局 额外勋章奖励
	flag := len(record.LastChoose()) == len(cards)

	if flag {
		for idx, csvID := range cards {
			// cards已在game那边排序
			if record.LastChoose()[idx] != csvID {
				flag = false
				break
			}
		}
	}
	var newBadges [][]int
	if flag {
		db.TotalTimes += 1
		baseCfg := bc.getBraveChallengeBaseCfg()
		if db.TotalTimes >= baseCfg.SameTimes {
			newBadges = record.getRandomBadge(0, false, bc.playType) // 0层没有首次随机库
			db.TotalTimes = 0                                        // 触发后重置次数
		}
	} else {
		db.TotalTimes = 1
		db.LastChoose = cards
	}

	db.Game = &scheme.GameInfo{
		OriginCards: cards,
		Cards:       initCards(cards, bc),
		Monsters:    initMonsters(monsters, bc),
		Floor:       1,
		FloorID:     floorID,
		MonsterID:   gateID,
		Deployments: deploy,
		NewBadges:   newBadges,
	}
	record.SetStatus("start")
	keys := []string{"last_choose", "total_times", "game", "card_counter"}
	record.SetDirty(keys...)
	return nil
}

func (record *BraveChallengeRecord) onCardCounter(cardID document.Integer, playType int) {
	db := record.GetLockedDB()
	var num int
	if count, ok := db.CardCounter[cardID]; ok {
		num = count + 1
		db.CardCounter[cardID] = num
	} else {
		db.CardCounter[cardID] = 1
	}

	record.unlockCards(UnlockCardType, int(cardID), playType)
	record.SetCardCounter(db.CardCounter)
}

// 解锁卡池
func (record *BraveChallengeRecord) unlockCards(targetType, targetID int, playType int) {
	db := record.GetLockedDB()
	cfg := GetBraveChallengeConfig(playType)
	unlockCards := make([]int, 0)
	if cards, ok := cfg.CardUnlockMap[targetType]; ok {
		for _, card := range cards {
			// 解锁条件为天数时，>=目标天数
			if card[0] == targetID || (targetType == UnlockDailyType && targetID >= card[0]) {
				unlock := false
				// 检查是否已解锁过
				for _, unlockCardID := range db.UnlockCards {
					if card[1] == unlockCardID {
						unlock = true
						break
					}
				}
				if unlock {
					break
				}
				unlockCards = append(unlockCards, card[1])
			}
		}
	}
	if len(unlockCards) > 0 {
		db.UnlockCards = append(db.UnlockCards, unlockCards...)
		db.Add = append(db.Add, unlockCards...)
		record.SetUnlockCards(db.UnlockCards)
		record.SetAdd(db.Add)
	}
}

func (record *BraveChallengeRecord) hasDeadOrNoCard(cards [6]int) bool {
	num := 0
	for _, csvID := range cards {
		if csvID == 0 {
			num += 1
			continue
		}
		if state, ok := record.Game().Cards[document.Integer(csvID)]; ok {
			if state[0] <= 0 {
				return true
			}
		} else {
			return true
		}
	}
	// 布阵不能为空
	if num == len(cards) {
		return true
	}
	return false
}

// 选择勋章
func (record *BraveChallengeRecord) ChooseBadge(badgeID int, bc *BraveChallenge) error {
	db, unlock := record.LockAndGetDB()
	defer unlock()

	keys := make([]string, 0)
	valid := false
	for _, badge := range db.Game.NewBadges {
		if badge[0] == badgeID {
			valid = true
			if badge[1] == 2 && db.Weight > 0 {
				// 选择库2的勋章后重置权重和次数
				db.Weight = 0
				db.WeightFail = 0
				keys = append(keys, "weight", "weight_fail")
			}
			break
		}
	}
	if !valid {
		return ErrBraveChallengeBadgeID
	}

	db.Game.NewBadges = [][]int{}
	cfg := csv.GetConfig().Brave_challenge.Badge[badgeID]
	if cfg.ActiveType == int(GlobalBadgeType) {
		db.Badges[GlobalBadgeType] = append(db.Badges[GlobalBadgeType], badgeID)
	} else if cfg.ActiveType == int(LocalBadgeType) {
		db.Badges[LocalBadgeType] = append(db.Badges[LocalBadgeType], badgeID)
	}

	// 招募队友
	if cfg.Type == BadgeCardType {
		// 配置上会避免勋章选择的卡牌csvID与卡池里的相同
		for _, cardID := range cfg.CardIDs.ToIntSlice() {
			if _, ok := db.Game.Cards[document.Integer(cardID)]; !ok {
				db.Game.Cards[document.Integer(cardID)] = initCards([]int{cardID}, bc)[document.Integer(cardID)]
				record.unlockCards(UnlockCardType, cardID, bc.playType)
			}
		}
	}
	if num, ok := db.BadgeCounter[document.Integer(badgeID)]; ok {
		db.BadgeCounter[document.Integer(badgeID)] = num + 1
	} else {
		db.BadgeCounter[document.Integer(badgeID)] = 1
	}

	keys = append(keys, "badges", "game", "badge_counter")
	record.unlockCards(UnlockBadgeType, badgeID, bc.playType)
	record.SetDirty(keys...)
	return nil
}

// 布阵
func (record *BraveChallengeRecord) Deploy(cards [6]int) error {
	db, unlock := record.LockAndGetDB()
	defer unlock()

	if hasDuplicateMarkID(cards) {
		return ErrBraveChallengeDuplicateCard
	}
	if record.hasDeadOrNoCard(cards) {
		return ErrBraveChallengeNoCard
	}
	db.Game.Deployments = cards
	record.SetGame(db.Game)
	return nil
}

// 开始战斗
func (record *BraveChallengeRecord) StartBattle(floorID, monsterID int, bc *BraveChallenge, extraAttrBonus map[int]map[string][2]float64) (BraveChallengeBattleModel, error) {
	_, unlock := record.RLockAndGetDB()
	defer unlock()

	if record.Status() != "start" || record.Game().Pass {
		return BraveChallengeBattleModel{}, ErrBraveChallengeStatus
	}

	if record.Game().FloorID != floorID || record.Game().MonsterID != monsterID {
		return BraveChallengeBattleModel{}, ErrBraveChallengeFloorID
	}

	battleModel := BraveChallengeBattleModel{
		ID:               document.NewID(),
		RandSeed:         rand.Intn(99999999) + 1,
		Cards:            make([]int, 0), // TODO：统一成document.id
		CardAttrs:        make(map[int]*scheme.CardBattleModel),
		CardStatus:       make(map[document.Integer][2]float64),
		MonstersStatus:   make(map[document.ID][2]float64),
		DefenceCards:     make([]document.ID, 0),
		DefenceCardAttrs: make(map[document.ID]*scheme.CardBattleModel),
		FloorID:          record.Game().FloorID,
		YYID:             record.YYId(),
		MonsterID:        record.Game().MonsterID,
	}

	// 卡牌属性
	badges := record.Badges()[GlobalBadgeType]
	badges = append(badges, record.Badges()[LocalBadgeType]...)
	for idx, csvID := range record.Game().Deployments {
		battleModel.Cards = append(battleModel.Cards, csvID)
		battleModel.CardStatus[document.Integer(csvID)] = record.Game().Cards[document.Integer(csvID)]
		if csvID != 0 {
			infront := idx <= 2
			card := bc.getCardAttrs(csvID)
			// 卡牌勋章加成
			card = getBadgeEffect(card, badges, infront)
			battleModel.CardAttrs[csvID] = &card
		}
	}

	// 卡牌光环加成
	cardIDs := make([]int, 0, len(battleModel.Cards))
	for _, csvID := range battleModel.Cards {
		if csvID != 0 {
			cardIDs = append(cardIDs, csv.GetConfig().Brave_challenge.Cards[csvID].CardID)
		}
	}
	if len(battleModel.CardAttrs) == 6 {
		chooses := makeBattleCardHalo(battleModel.Cards, battleModel.CardAttrs, cardIDs, 0)
		if chooses != nil {
			for idx, id := range battleModel.Cards {
				battleModel.CardAttrs[id].NatureChoose = chooses[idx] + 1
			}
		}
	}
	// 星级属性加成
	for csvID, addAttr := range extraAttrBonus {
		for attrType, attrVal := range addAttr {
			if attrVal[0] == 0 {
				battleModel.CardAttrs[csvID].Attrs[attrType] += attrVal[1]
			} else {
				battleModel.CardAttrs[csvID].Attrs[attrType] *= attrVal[1]
			}
		}
	}

	// 怪物属性
	monsterCfg := csv.GetConfig().Brave_challenge.Monster[record.Game().MonsterID]
	monsters := monsterCfg.Cards.ToIntSlice()
	floorCfg := csv.GetConfig().Brave_challenge.Floor[record.Game().FloorID]
	monsterBadges := monsterCfg.Badges.ToIntSlice()
	for idx, csvID := range monsters {
		if csvID != 0 && record.Game().Monsters[idx][0] > 0 {
			cardID := document.ID(fmt.Sprintf("bravechallenge%d%05d", idx, csvID))
			battleModel.DefenceCards = append(battleModel.DefenceCards, cardID)
			battleModel.MonstersStatus[cardID] = record.Game().Monsters[idx]

			monster := bc.getCardAttrs(csvID)
			// 怪物勋章加成 只有对应位置的勋章生效
			if len(monsterBadges) == 6 && monsterBadges[idx] != 0 {
				infront := idx <= 2
				monster = getBadgeEffect(monster, []int{monsterBadges[idx]}, infront)
			}

			// 属性修正
			monster.Attrs["hp"] *= float64(floorCfg.HpFix)
			monster.Attrs["damage"] *= float64(floorCfg.DamageFix)
			monster.Attrs["specialDamage"] *= float64(floorCfg.DamageFix)
			monster.Attrs["defence"] *= float64(floorCfg.DefenceFix)
			monster.Attrs["specialDefence"] *= float64(floorCfg.DefenceFix)
			monster.Attrs["speed"] *= float64(floorCfg.SpeedFix)
			battleModel.DefenceCardAttrs[cardID] = &monster
		} else {
			battleModel.DefenceCards = append(battleModel.DefenceCards, "")
		}
	}

	// 怪物光环加成
	chooses := tjcards.AppendBattleCardHalo(battleModel.DefenceCards, battleModel.DefenceCardAttrs, 0)
	if chooses != nil {
		for idx, id := range battleModel.DefenceCards {
			battleModel.DefenceCardAttrs[id].NatureChoose = chooses[idx] + 1
		}
	}

	bc.battles.Store(record.RoleDbId(), &battleInfo{
		RoleID:      record.RoleDbId(),
		RecordID:    record.GetID(),
		YYID:        record.YYId(),
		battleID:    battleModel.ID,
		monsterID:   record.Game().MonsterID,
		model:       &battleModel,
		agentFinish: make(chan int),
	})
	return battleModel, nil
}

func getBadgeEffect(card scheme.CardBattleModel, badges []int, infront bool) scheme.CardBattleModel {
	addAttrs := make(map[string]float64)
	for _, badgeID := range badges {
		cfg := csv.GetConfig().Brave_challenge.Badge[badgeID]
		if (cfg.AddType == InFront && !infront) || (cfg.AddType == InBack && infront) {
			continue
		}
		if cfg.Type == BadgeAttrType {
			for attrType, attrNum := range cfg.AddAttrs.ToAttributeMap() {
				attr := game.CardAttrDefs[attrType]
				if attrNum.Percent {
					addNum := card.Attrs[attr] * attrNum.Value
					if num, ok := addAttrs[attr]; ok {
						addAttrs[attr] = addNum + num
					} else {
						addAttrs[attr] = addNum
					}
				} else {
					if num, ok := addAttrs[attr]; ok {
						addAttrs[attr] = attrNum.Value + num
					} else {
						addAttrs[attr] = attrNum.Value
					}
				}
			}
		} else if cfg.Type == BadgeSkillType {
			card.PassiveSkills = schemeutil.CopySkills(card.PassiveSkills)
			for _, skillID := range cfg.SkillIDs.ToIntSlice() {
				card.PassiveSkills[document.Integer(skillID)] = 1
			}
		}
	}
	card.Attrs = schemeutil.CopyAttrs(card.Attrs)
	for attr, addNum := range addAttrs {
		card.Attrs[attr] += addNum
	}
	return card
}

// 结束战斗
func (record *BraveChallengeRecord) EndBattle(data ReqBattleEnd, bc *BraveChallenge) (RespBattleEnd, error) {
	db, unlock := record.LockAndGetDB()
	defer unlock()

	if db.Game.FloorID != data.FloorID {
		return RespBattleEnd{}, ErrBraveChallengeFloorID
	}

	if data.Result == "win" {
		// 反作弊校验
		var battle *battleInfo
		if b, ok := bc.battles.Load(db.RoleDbId); ok {
			battle = b.(*battleInfo)
			bc.battles.Delete(db.RoleDbId)
		} else {
			return RespBattleEnd{}, ErrBraveChallengeBattleNotFound
		}

		err := record.checkBattle(battle, data, bc)
		if err != nil {
			return RespBattleEnd{}, err
		}
	}

	keys := make([]string, 0)
	resp := RespBattleEnd{Kill: 0, Die: 0}
	round := data.BattleRound + db.Game.Round

	// 击杀计数
	for _, state := range data.MonsterStates {
		if state[0] <= 0 {
			resp.Kill += 1
		}
	}
	// 阵亡计数
	for _, state := range data.CardStates {
		if state[0] <= 0 {
			resp.Die += 1
		}
	}

	allPass := true
	firstPass := false
	if data.Result == "fail" {
		// 失败保留怪物状态{position: [hp, mp]}
		for idx, states := range data.MonsterStates {
			db.Game.Monsters[idx-1] = states
		}
	} else {
		// 解锁卡池
		groupID := csv.GetConfig().Brave_challenge.Monster[db.Game.MonsterID].GroupID
		record.unlockCards(UnlockMonsterType, groupID, bc.playType)

		// 胜利生成下一关数据
		firstPass = record.isFirstPass(db.Game.Floor)

		if firstPass {
			// 记录首通
			db.Floors[document.Integer(db.Game.Floor)] = 1
			keys = append(keys, "floors")
			resp.FirstPass = firstPass
		}

		floor := db.Game.Floor + 1
		gateID, floorID := record.getRandomGate(floor, record.isFirstPass(floor), bc)

		allPass = gateID == 0 || floorID == 0 // 是否通关
		if allPass {
			db.Game.Pass = true
			resp.AllPass = allPass
			// 首次通关 或者 消耗回合数小于历史记录
			if db.PassTimes == 0 || (round < db.Rank.Round && db.PassTimes > 0) {
				resp.Refresh = true
				resp.RankData = []int{round}
				// 勋章
				var badgeNum, rareBadgeNum int
				for _, csvIDs := range db.Badges {
					for _, csvID := range csvIDs {
						cfg := csv.GetConfig().Brave_challenge.Badge[csvID]
						if cfg.Rarity == NormalBadge {
							badgeNum += 1
						} else if cfg.Rarity == RareBadge {
							rareBadgeNum += 1
						}
					}
				}
				resp.RankInfo = scheme.RankInfo{
					Round:        round,
					BadgeNum:     badgeNum,
					RareBadgeNum: rareBadgeNum,
					Deployments:  db.Game.Deployments,
				}
				db.Rank = &resp.RankInfo
				keys = append(keys, "rank")
			}

			// 通关不改状态, 等客户端发quit再更改
			db.PassTimes += 1
			keys = append(keys, "badges", "pass_times")
			record.SetDirty(keys...)
			return resp, nil
		} else {
			gateCfg := csv.GetConfig().Brave_challenge.Monster[gateID]
			monsters := gateCfg.Cards.ToIntSlice()

			db.Game.Monsters = initMonsters(monsters, bc)
			db.Game.FloorID = floorID
			db.Game.MonsterID = gateID
		}
		db.Game.Floor = floor
	}
	db.Game.Round = round
	keys = append(keys, "game")
	record.setCards(data.CardStates, bc)
	record.SetDirty(keys...)
	if !allPass {
		// 生成勋章
		newBadges := record.getRandomBadge(db.Game.Floor-1, firstPass, bc.playType)
		db.Game.NewBadges = newBadges
		record.SetDirty([]string{"game"}...)
	}
	return resp, nil
}

// 随机徽章
func (record *BraveChallengeRecord) RandomBadge(weight, floor int, bc *BraveChallenge) {
	db, unlock := record.LockAndGetDB()
	defer unlock()

	keys := make([]string, 0)
	if weight > 0 {
		db.Weight += weight
		keys = append(keys, "weight")
	}

	newBadges := record.getRandomBadge(floor, false, bc.playType)
	db.Game.NewBadges = newBadges
	keys = append(keys, "game")
	record.SetDirty(keys...)
}

func (record *BraveChallengeRecord) checkBattle(battle *battleInfo, data ReqBattleEnd, bc *BraveChallenge) error {
	battle.mu.Lock()
	model := battle.model.(*BraveChallengeBattleModel)
	model.Actions = data.Actions
	battle.model = model
	battle.mu.Unlock()

	go pushBattleToVerifyQueue(bc.AntiAgent, battle)

	db := record.GetLockedDB()
	var fp float64
	for _, csvID := range db.Game.Deployments {
		if csvID != 0 {
			card := bc.getCardAttrs(csvID)
			fp += float64(card.FightingPoint)
		}
	}
	cfg := csv.GetConfig().Brave_challenge.Floor[db.Game.FloorID]
	if data.Damage > float64(cfg.DamageMax)*fp {
		return ErrBraveChallengeCheat
	}

	if battle.agentResult == "fail" {
		return ErrBraveChallengeCheat
	}
	return nil
}

func (record *BraveChallengeRecord) setCards(cardStates map[document.Integer][2]float64, bc *BraveChallenge) {
	db := record.GetLockedDB()
	baseCfg := bc.getBraveChallengeBaseCfg()

	delpoyments := [6]int{}
	for idx, csvID := range db.Game.Deployments {
		hold := true
		for _, idx := range db.Game.OriginCards {
			if idx == csvID {
				hold = false
			}
		}
		if state, ok := cardStates[document.Integer(csvID)]; ok {
			// 非初始卡不保留怒气
			if hold {
				db.Game.Cards[document.Integer(csvID)] = [2]float64{state[0], float64(baseCfg.Mp)}
			} else {
				db.Game.Cards[document.Integer(csvID)] = state
			}
			// 死亡卡牌自动下阵
			if state[0] > 0 {
				delpoyments[idx] = csvID
			}
		}
	}
	db.Game.Deployments = delpoyments
	record.SetGame(db.Game)
}

func (record *BraveChallengeRecord) Quit(bc *BraveChallenge) error {
	db, unlock := record.LockAndGetDB()
	defer unlock()

	if db.Status != "start" {
		return ErrBraveChallengeStatus
	}

	if !db.Game.Pass {
		db.FailTimes += 1
		record.unlockCards(UnlockFailType, db.FailTimes, bc.playType)
	}

	if db.Weight == 0 {
		baseCfg := bc.getBraveChallengeBaseCfg()
		for floor, count := range baseCfg.FloorFail.ToIntMap() {
			if db.Game.Floor >= floor {
				db.WeightFail += 1
			}
			if db.WeightFail >= count {
				record.SetWeight(baseCfg.WeightUp)
				db.WeightFail = 0
			}
			record.SetWeightFail(db.WeightFail)
		}
	}

	// 删除非全局勋章
	db.Badges[LocalBadgeType] = []int{}
	record.SetBadges(db.Badges)
	record.SetStatus("end")
	record.SetFailTimes(db.FailTimes)
	record.SetGame(&scheme.GameInfo{})
	return nil
}

// 日刷新
func (record *BraveChallengeRecord) refresh() {
	db, unlock := record.LockAndGetDB()
	defer unlock()
	nowDate := util.Todayinclock5date2int()
	if nowDate == record.LastDate() {
		return
	}
	db.LastDate = nowDate
	record.SetLastDate(nowDate)

	// db.Badges[LocalBadgeType] = []int{}

	// if db.Status == "start" && !db.Game.Pass {
	// db.FailTimes += 1
	// playType := 0
	// if record.YYId() > 0 {
	// playType = 1
	// }
	// record.unlockCards(UnlockFailType, db.FailTimes, playType)
	// }

	// record.SetStatus("end")
	// record.SetGame(&scheme.GameInfo{})
	// record.SetBadges(db.Badges)
}

// 重置
func (record *BraveChallengeRecord) reset(yyID, lastOpenDate int) {
	_, unlock := record.LockAndGetDB()
	defer unlock()
	record.SetYYId(yyID)
	record.SetLastOpenDate(lastOpenDate)
	record.SetLastDate(util.Todayinclock5date2int())
	record.SetUnlockCards([]int{})
	record.SetAdd([]int{})
	record.SetBadges(map[document.Integer][]int{GlobalBadgeType: {}, LocalBadgeType: {}})
	record.SetBadgeCounter(map[document.Integer]int{})
	record.SetStatus("")
	record.SetPassTimes(0)
	record.SetFailTimes(0)
	record.SetTotalTimes(0)
	record.SetRank(&scheme.RankInfo{})
	record.SetFloors(make(map[document.Integer]int))
	record.SetGame(&scheme.GameInfo{})
	record.SetLastChoose([]int{})
}

// 随机勋章
func (record *BraveChallengeRecord) getRandomBadge(floor int, firstPass bool, playType int) (badges [][]int) {
	cfg := GetBraveChallengeConfig(playType)
	// 勋章生成库
	gens := cfg.BadgeLibWeights[floor]
	for i := 1; i <= 3; i++ {
		group := make(map[int]int)
		genCfg := csv.GetConfig().Brave_challenge.Badge_gen[cfg.BadgeGenMap[floor][i]]
		libKey := 0
		// 首次随机库
		if firstPass {
			group = genCfg.FirstRandomLibs.ToIntMap()
		} else {
			// 先随库
			libWeights := gens[i]
			// 随机库2权重
			if record.Weight() > 0 {
				newWeight := record.Weight() + libWeights[1].Weight()
				libWeights[1] = util.WeightInts{2, +newWeight}
			}
			libKey = util.OnceRandom(libWeights).(util.WeightInts)[0] // 1 或 2

			if libKey == 1 {
				group = genCfg.RepeatRandomLibs1.ToIntMap()
			} else {
				group = genCfg.RepeatRandomLibs2.ToIntMap()
			}
		}
		groupWeights := make([]util.WeightElement, 0)
		badgeWeightsMap := make(map[int][]util.WeightElement, 0)
		for groupID, weight := range group {
			// 检查组里勋章池是否为空
			badgeWeights := record.checkBadge(cfg.BadgeWeights[groupID], badges, playType)
			if len(badgeWeights) > 0 {
				groupWeights = append(groupWeights, util.WeightInts{groupID, weight})
				badgeWeightsMap[groupID] = badgeWeights
			}
		}

		// 再随组
		var groupID int
		if len(badgeWeightsMap) == 0 {
			log.Warningf("floor: %d, lib: %d, pos: %d", floor, libKey, i)
			groupID = cfg.BadgeLib
			badgeWeights := record.checkBadge(cfg.BadgeWeights[groupID], badges, playType)
			badgeWeightsMap[groupID] = badgeWeights
			libKey = 0
		} else {
			groupID = util.OnceRandom(groupWeights).(util.WeightInts)[0]
		}

		// 最后随勋章
		badgeID := util.OnceRandom(badgeWeightsMap[groupID]).(util.WeightInts)[0]
		badges = append(badges, []int{badgeID, libKey})
	}
	return badges
}

func (record *BraveChallengeRecord) checkBadge(raws []util.WeightElement, badges [][]int, playType int) []util.WeightElement {
	badgeWeights := make([]util.WeightElement, 0)

	cfg := GetBraveChallengeConfig(playType)
	for _, badgeWeight := range raws {
		badgeID := badgeWeight.(util.WeightInts)[0]
		if badgeCfg, ok := cfg.BadgeUnlockMap[badgeID]; ok {
			activeType, unlockType, target, targetCount, limit := badgeCfg[0], badgeCfg[1], badgeCfg[2], badgeCfg[3], badgeCfg[4]
			// 检查触发限制 limit为0 代表无限制
			if num, ok := record.BadgeCounter()[document.Integer(badgeID)]; ok && limit > 0 && num >= limit {
				continue
			}

			// 检查是否已获得
			gain := false
			if badges, ok := record.Badges()[document.Integer(activeType)]; ok {
				for _, badge := range badges {
					if badge == badgeID {
						gain = true
						break
					}
				}
			}
			// 检查是否已随到
			for _, badge := range badges {
				if badge[0] == badgeID {
					gain = true
					break
				}
			}
			if gain {
				continue
			}
			// 检查是否解锁
			if unlockType == UnlockNoType {
				badgeWeights = append(badgeWeights, badgeWeight)
			} else if unlockType == UnlockCardType {
				// 当前是否招募卡牌
				if _, ok := record.Game().Cards[document.Integer(target)]; !ok {
					continue
				}
				if count, ok := record.CardCounter()[document.Integer(target)]; ok && count >= targetCount {
					badgeWeights = append(badgeWeights, badgeWeight)
				}
			} else if unlockType == UnlockFailType {
				if targetCount <= record.FailTimes() {
					badgeWeights = append(badgeWeights, badgeWeight)
				}
			}
		}
	}
	return badgeWeights
}

// 随机关卡
func (record *BraveChallengeRecord) getRandomGate(floor int, first bool, bc *BraveChallenge) (gateID, floorID int) {
	cfg := GetBraveChallengeConfig(bc.playType)
	baseCfg := bc.getBraveChallengeBaseCfg()
	// 已通关则不生成关卡
	if floor > len(baseCfg.GateSeq) {
		return 0, 0
	}
	floorID = baseCfg.GateSeq.ToIntSlice()[floor-1] // 楼层csvID
	floorCfg := csv.GetConfig().Brave_challenge.Floor[floorID]
	var randInt, groupID int
	rand.Seed(time.Now().Unix())
	if first {
		randInt = rand.Intn(len(floorCfg.FirstMonters))
		groupID = floorCfg.FirstMonters.ToIntSlice()[randInt]
	} else {
		randInt = rand.Intn(len(floorCfg.RepeatMonters))
		groupID = floorCfg.RepeatMonters.ToIntSlice()[randInt]
	}

	gateWeights := cfg.MonsterWeights[groupID]
	gateID = util.OnceRandom(gateWeights).(util.WeightInts)[0]
	return gateID, floorID
}

func hasDuplicateMarkID(csvIDs [6]int) bool {
	markIDs := util.NewSet()
	for _, csvID := range csvIDs {
		if csvID != 0 {
			cfg := csv.GetConfig().Brave_challenge.Cards[csvID]
			cardCfg := csv.GetConfig().Cards[cfg.CardID]
			if markIDs.Contains(cardCfg.CardMarkID) {
				return true
			} else {
				markIDs.Add(cardCfg.CardMarkID)
			}
		}
	}
	return false
}

func initCards(cards []int, bc *BraveChallenge) map[document.Integer][2]float64 {
	baseCfg := bc.getBraveChallengeBaseCfg()
	cardStates := map[document.Integer][2]float64{}
	for _, csvID := range cards {
		cardStates[document.Integer(csvID)] = [2]float64{1, float64(baseCfg.Mp)} // hp, mp
	}
	return cardStates
}

func initMonsters(monsters []int, bc *BraveChallenge) [][2]float64 {
	baseCfg := bc.getBraveChallengeBaseCfg()
	var monsterStates [][2]float64
	for _, csvID := range monsters {
		if csvID != 0 {
			monsterStates = append(monsterStates, [2]float64{1, float64(baseCfg.Mp)}) // hp, mp
		} else {
			monsterStates = append(monsterStates, [2]float64{0, 0}) // hp, mp
		}
	}
	return monsterStates
}

func getRandomString(n int) string {
	randBytes := make([]byte, n/2)
	rand.Read(randBytes)
	return fmt.Sprintf("%x", randBytes)
}

type BraveChallenge struct {
	yyID int
	//卡池 {csvID: {cardID: {}}}
	cards map[int]*scheme.CardBattleModel
	// 同步是否完成
	complete          int32
	playType          int  // 玩法类型  0: 普通勇者  1: 周年庆勇者
	beginDate         int  // 活动开启日期
	baseCfg           int  // 主题 1: 周年庆 >1:普通
	isDailyUnlockCard bool // 是否开启每日解锁卡牌

	game service.IService
	lock sync.RWMutex

	// battles           sync.Map
	// agent             service.IService // 反作弊
	// battleVerifyQueue chan *battleInfo // 反作弊校验队列
	// server            *Service

	*AntiAgent
}

type EventToGame struct {
	PlayType int   `codec:"playType"`
	CsvIDs   []int `codec:"csvIDs,omitempty"`
}

func (bc *BraveChallenge) init(s *Service, agent service.IService) error {
	if bc.yyID != 0 {
		return nil
	}
	response := bc.eventToGame("yy_info", EventToGame{}, false)
	if response == nil {
		return errors.New("yy_info error")
	}
	if response.YYID == 0 && response.BeginDate <= 0 {
		return nil
	}
	bc.isDailyUnlockCard = response.IsDailyUnlockCard
	bc.baseCfg = response.BaseCfg
	bc.beginDate = response.BeginDate

	_ = LoadBraveChallengeConfig(bc)

	_ = tjcards.InitBattleCardHaloConfig()
	cfg := GetBraveChallengeConfig(bc.playType)
	cards := make([]int, 0)
	for _, csvIDs := range cfg.CardGroupMap {
		cards = append(cards, csvIDs...)
	}

	if len(cards) <= 100 {
		bc.startCardSync(cards)
		atomic.StoreInt32(&bc.complete, 1)
	} else {
		for len(cards) > 100 {
			bc.startCardSync(cards[:100])
			cards = cards[100:]
		}
		bc.startCardSync(cards)
		atomic.StoreInt32(&bc.complete, 1)
	}
	if bc.AntiAgent == nil {
		bc.AntiAgent = &AntiAgent{
			agent:             agent,
			battleVerifyQueue: make(chan *battleInfo, BattleVerifyQueueSize),
			server:            s,
			name:              "brave_challenge",
			flag:              false,
			saveRecord:        false,
		}
		go runBattleAgentVerify(bc.AntiAgent)
	}
	return nil
}

func (bc *BraveChallenge) getBraveChallengeBaseCfg() *csv.Brave_challenge_base {
	return csv.GetConfig().Brave_challenge.Base[bc.baseCfg]
}

func (bc *BraveChallenge) reset() {
	bc.lock.Lock()
	defer bc.lock.Unlock()
	bc.yyID = 0
	bc.cards = make(map[int]*scheme.CardBattleModel)
	atomic.CompareAndSwapInt32(&bc.complete, 1, 0)
}

func (bc *BraveChallenge) startCardSync(cards []int) {
	d := EventToGame{CsvIDs: cards}
	response := bc.eventToGame("calc_cards", d, false)
	if response == nil {
		log.Errorf("calc cards error %+v", cards)
		return
	}
	bc.syncCardAttrs(response.YYID, response.Cards)
}

func (bc *BraveChallenge) eventToGame(event string, data EventToGame, sync bool) *game.BraveChallengeEventResponse {
	if bc.game == nil {
		return nil
	}
	data.PlayType = bc.playType
	resp, err := service.Call(bc.game, "BraveChallengeEvent", event, data, nil)
	if err != nil {
	}
	return resp.(*game.BraveChallengeEventResponse)
}

// 同步卡牌属性数据
func (bc *BraveChallenge) syncCardAttrs(yyID int, cardAttrs map[int]*scheme.CardBattleModel) {
	bc.lock.Lock()
	defer bc.lock.Unlock()

	if bc.cards == nil {
		bc.cards = map[int]*scheme.CardBattleModel{}
	}
	if bc.yyID != yyID {
		bc.cards = map[int]*scheme.CardBattleModel{}
		bc.yyID = yyID
	}

	for csvID, attrs := range cardAttrs {
		bc.cards[csvID] = attrs
	}
}

// 获取卡牌属性
func (bc *BraveChallenge) getCardAttrs(csvID int) scheme.CardBattleModel {
	cardAttrs := *bc.cards[csvID]
	cardAttrs.Attrs = schemeutil.CopyAttrs(bc.cards[csvID].Attrs)
	cardAttrs.PassiveSkills = schemeutil.CopySkills(bc.cards[csvID].PassiveSkills)
	return cardAttrs
}

func (bc *BraveChallenge) pushBattleToVerifyQueue(battle *battleInfo) {
	util.SimpleTry(func() {
		t := time.NewTicker(BattleWaitVerifyTimeout)
		select {
		case bc.battleVerifyQueue <- battle:
			select {
			case <-battle.agentFinish:
			case <-t.C:
				log.Warningf("BraveChallenge battle %v wait verify timeout", battle.battleID)
			}
		case <-t.C:
			log.Warningf("BraveChallenge battle %v push verify timeout", battle.battleID)
		}
	}, nil)
}

// 勇者挑战 配表数据
var braveChallengeConfig atomic.Value

// 普通勇者挑战 配表数据
var normalBraveChallengeConfig atomic.Value

func GetBraveChallengeConfig(playType int) *BraveChallengeConfig {
	if playType == NormalBraveChallenge {
		return normalBraveChallengeConfig.Load().(*BraveChallengeConfig)
	} else {
		return braveChallengeConfig.Load().(*BraveChallengeConfig)
	}
}

func LoadBraveChallengeConfig(bc *BraveChallenge) error {
	cfg := csv.GetConfig()
	baseCfg := bc.getBraveChallengeBaseCfg()
	v := &BraveChallengeConfig{
		CardList:        make([]int, 0),
		CardUnlockMap:   make(map[int][][]int),
		CardGroupMap:    make(map[int][]int),
		MonsterWeights:  make(map[int][]util.WeightElement),
		BadgeUnlockMap:  make(map[int][]int),
		BadgeWeights:    make(map[int][]util.WeightElement),
		BadgeLibWeights: make(map[int]map[int][]util.WeightElement),
		BadgeGenMap:     make(map[int]map[int]int),
		BadgeLib:        baseCfg.BadgeLibID,
	}

	cards := baseCfg.Cards.ToIntSlice()
	cards = append(cards, baseCfg.MonsterCards.ToIntSlice()...)
	cards = append(cards, baseCfg.BadgeCards.ToIntSlice()...)
	for idx, c := range cfg.Brave_challenge.Cards {
		f := false
		for _, groupID := range cards {
			if groupID == c.GroupID {
				f = true
				break
			}
		}
		if !f {
			continue
		}
		if c.UnlockType == UnlockNoType {
			for _, groupID := range baseCfg.Cards.ToIntSlice() {
				if groupID == c.GroupID {
					v.CardList = append(v.CardList, idx)
				}
			}
		} else {
			if group, ok := v.CardUnlockMap[c.UnlockType]; ok {
				v.CardUnlockMap[c.UnlockType] = append(group, []int{c.UnlockTarget, idx})
			} else {
				v.CardUnlockMap[c.UnlockType] = [][]int{{c.UnlockTarget, idx}}
			}
		}

		if group, ok := v.CardGroupMap[c.GroupID]; ok {
			v.CardGroupMap[c.GroupID] = append(group, idx)
		} else {
			v.CardGroupMap[c.GroupID] = []int{idx}
		}
	}

	for idx, c := range cfg.Brave_challenge.Monster {
		if weights, ok := v.MonsterWeights[c.GroupID]; ok {
			weights = append(weights, util.WeightInts{idx, c.Weight})
			v.MonsterWeights[c.GroupID] = weights
		} else {
			v.MonsterWeights[c.GroupID] = []util.WeightElement{util.WeightInts{idx, c.Weight}}
		}
	}

	for idx, c := range cfg.Brave_challenge.Badge {
		if c.Weight <= 0 {
			continue
		}
		if weights, ok := v.BadgeWeights[c.GroupID]; ok {
			weights = append(weights, util.WeightInts{idx, c.Weight})
			v.BadgeWeights[c.GroupID] = weights
		} else {
			v.BadgeWeights[c.GroupID] = []util.WeightElement{util.WeightInts{idx, c.Weight}}
		}

		v.BadgeUnlockMap[idx] = []int{c.ActiveType, c.UnlockType, c.UnlockTarget, c.UnlockCount, c.TimesLimit}
	}

	for idx, c := range cfg.Brave_challenge.Badge_gen {
		if c.GroupID != baseCfg.GenSeqID {
			continue
		}
		if group, ok1 := v.BadgeLibWeights[c.Floor]; ok1 {
			// 一层一个位置一条配置
			if _, ok2 := group[c.Position]; !ok2 {
				// 先固定两个权重库
				group[c.Position] = []util.WeightElement{util.WeightInts{1, c.Weight1}, util.WeightInts{2, c.Weight2}}
			}
			v.BadgeLibWeights[c.Floor] = group
		} else {
			group = make(map[int][]util.WeightElement)
			group[c.Position] = []util.WeightElement{util.WeightInts{1, c.Weight1}, util.WeightInts{2, c.Weight2}}
			v.BadgeLibWeights[c.Floor] = group
		}

		if group, ok := v.BadgeGenMap[c.Floor]; ok {
			group[c.Position] = idx
			v.BadgeGenMap[c.Floor] = group
		} else {
			v.BadgeGenMap[c.Floor] = map[int]int{c.Position: idx}
		}
	}
	if bc.playType == NormalBraveChallenge {
		normalBraveChallengeConfig.Store(v)
	} else {
		braveChallengeConfig.Store(v)
	}
	return nil
}

type BraveChallengeConfig struct {
	// cards
	CardList        []int                                // [csvID,...]
	CardUnlockMap   map[int][][]int                      // unlockType: [[target, csvID],...]
	CardGroupMap    map[int][]int                        // groupID: [csvID,...]
	MonsterWeights  map[int][]util.WeightElement         // groupID: [(csvID, weight),...]
	BadgeUnlockMap  map[int][]int                        // csvID: [activeType, unlockType, target, num, limit]
	BadgeWeights    map[int][]util.WeightElement         //groupID: [(csvID, weight),...]
	BadgeLibWeights map[int]map[int][]util.WeightElement // floor: {position: [(csvID, weight),...]
	BadgeGenMap     map[int]map[int]int                  // floor: {position: csvID}
	BadgeLib        int
}

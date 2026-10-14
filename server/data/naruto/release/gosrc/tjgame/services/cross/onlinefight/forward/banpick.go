package forward

import (
	"context"
	"errors"
	"math/rand"
	"sync/atomic"
	"time"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
	"tjgame/services/cross/onlinefight/proto"
)

const (
	// card status
	cardUnused = 1
	cardPick   = 2
	cardBan    = 3

	BanOp    = 1
	PickOp   = 2
	DeployOp = 3
)

var (
	ErrCardAlreadyUsed   = errors.New("card already used")
	ErrCardNotMatched    = errors.New("card not matched")
	ErrCardRarityLimited = errors.New("card rarity limited")
	ErrCardMarkIDLimited = errors.New("card markid limited")
	ErrRoleAlreadyPick   = errors.New("role already pick")
	ErrRoleAlradyBan     = errors.New("role alrady ban")
	ErrRoleCardError     = errors.New("role card error")
	ErrRoleStepError     = errors.New("role step error")
)

type pusher interface {
	push(model *BroadcastModel) error
}

type carddeck struct {
	cards  map[document.ID]int
	deploy []document.ID
	// 自然属性选择（光环）
	natureChoose map[document.ID]int
	// pick 稀有度数量
	raritys map[int]int
	// pick markID数量
	markids map[int]int
}

func (k *carddeck) random(count int, choosed []document.ID) []document.ID {
	count = count - len(choosed)
	if count <= 0 {
		return choosed
	}

	set := make(map[document.ID]bool)
	for _, id := range choosed {
		set[id] = true
	}

	cards := make([]document.ID, 0, len(k.cards))
	for card, status := range k.cards {
		if status == cardUnused && !set[card] {
			cards = append(cards, card)
		}
	}
	rand.Shuffle(len(cards), func(i, j int) {
		cards[i], cards[j] = cards[j], cards[i]
	})
	return append(choosed, cards[:count]...)
}

func (k *carddeck) randomPick(count int, choosed []document.ID, cards map[document.ID]*proto.CrossOnlineFightCard, limited map[int]int) []document.ID {
	total := count
	count = count - len(choosed)
	if count <= 0 {
		return choosed
	}

	raritys := copyIntMap(k.raritys)
	set := make(map[document.ID]bool)
	for _, id := range choosed {
		set[id] = true
	}
	ids := make([]document.ID, 0, len(k.cards))
	for id, status := range k.cards {
		if status == cardUnused && !set[id] {
			ids = append(ids, id)
		}
	}
	for _, id := range ids {
		if k.markids[cards[id].MarkID] > 0 {
			continue
		}
		rarity := cards[id].Rarity
		if limit, ok := limited[rarity]; ok {
			if raritys[rarity] >= limit {
				continue
			}
		}
		choosed = append(choosed, id)
		raritys[rarity] += 1
		count -= 1
		if count <= 0 {
			break
		}
	}
	if total != len(choosed) {
		log.Warningf("!!!!! total %d, choosed %d", total, len(choosed))
	}
	return choosed
}

func (k *carddeck) checkInput(cards []document.ID, status int) error {
	set := make(map[document.ID]bool)
	for _, card := range cards {
		if set[card] {
			return ErrRoleCardError
		}
		if k.cards[card] != status {
			return ErrCardAlreadyUsed
		}
		set[card] = true
	}
	return nil
}

func (k *carddeck) checkDeployInput(cards []document.ID) error {
	set := make(map[document.ID]bool)
	for _, id := range cards {
		set[id] = true
	}
	num := 0
	for id, status := range k.cards {
		if status == cardPick {
			num += 1
			if !set[id] {
				return errors.New("have picked card not deploy")
			}
		}
	}
	if num != len(cards) {
		return errors.New("have not picked card in input")
	}
	return nil
}

func (k *carddeck) checkRarityAndMarkID(ids []document.ID, cards map[document.ID]*proto.CrossOnlineFightCard, limited map[int]int) error {
	raritys := copyIntMap(k.raritys)
	for _, id := range ids {
		if k.markids[cards[id].MarkID] > 0 {
			return ErrCardMarkIDLimited
		}
		rarity := cards[id].Rarity
		if limit, ok := limited[rarity]; ok {
			if raritys[rarity] >= limit {
				return ErrCardRarityLimited
			}
		}
		raritys[rarity] += 1
	}
	return nil
}

func (k *carddeck) updateRarityAndMarkID(cards map[document.ID]*proto.CrossOnlineFightCard) {
	rairtys := make(map[int]int)
	markids := make(map[int]int)
	for id, status := range k.cards {
		if status == cardPick {
			rairtys[cards[id].Rarity] += 1
			markids[cards[id].MarkID] += 1
		}
	}
	k.raritys = rairtys
	k.markids = markids
}

type BanPickInput struct {
	// 玩家扳卡/选卡/布阵
	*scheme.BanPickInput
	// 布阵确认
	Done bool `codec:"done,omitempty"`
	// 卡牌自然属性选择，队伍光环使用
	NatureChoose map[document.ID]int `codec:"nature_choose,omitempty"`

	id  document.ID
	err chan error
}

type BanPick struct {
	// 操作数据记录
	banpickLocals

	cursor int

	// 当前step操作
	currentInputStep scheme.BanPickInputStep

	sequence  []proto.BanPick
	decks     map[document.ID]*carddeck // key is role.id
	vs        map[document.ID]document.ID
	roleforce map[document.ID]int // value is 0 or 1
	cards     map[document.ID]*proto.CrossOnlineFightCard

	finalStep int // if step > finalStep mean operation is all finished

	inputs      chan *BanPickInput
	timer       *time.Timer
	refuseInput int32

	pusher pusher

	model *banpickModel
}

func (m *BanPick) insertToSteps(id document.ID, input *scheme.BanPickInput) {
	idx := m.roleforce[id]
	m.currentInputStep[idx] = input
}

func (m *BanPick) AddInput(id document.ID, input *BanPickInput) (<-chan error, error) {
	if atomic.LoadInt32(&m.refuseInput) == 0 {
		input.id = id
		input.err = make(chan error, 1)
		m.inputs <- input
		return input.err, nil
	}
	return nil, ErrInputRefuse
}

func (m *BanPick) loop(ctx context.Context) {
	atomic.StoreInt32(&m.refuseInput, 0)
	duration := time.Second * time.Duration(m.sequence[m.Step].Second)
	m.broadcast(duration)
	m.timer = time.NewTimer(duration)
	drain := false // drain the inputTimer channel
L:
	for m.Step <= m.finalStep {
		select {
		case <-ctx.Done():
			if !m.timer.Stop() {
				if !drain {
					<-m.timer.C
				}
			}
			break L

		case input := <-m.inputs:
			var err error
			if input.Step != m.Step {
				err = ErrRoleStepError
			} else {
				if m.Step == m.finalStep {
					if input.Action == DeployOp {
						err = m.deploy(input.id, input.Cards, input.NatureChoose, input.Done)
					} else {
						err = errors.New("unknown action")
					}
				} else {
					if input.Action == BanOp {
						err = m.ban(input.id, input.Cards, input.Done)
					} else if input.Action == PickOp {
						err = m.pick(input.id, input.Cards, input.Done)
					} else {
						err = errors.New("unknown action")
					}
				}
			}
			input.err <- err
			close(input.err)

			if err == nil {
				m.insertToSteps(input.id, input.BanPickInput)
			}

		case <-m.timer.C:
			drain = true
			atomic.StoreInt32(&m.refuseInput, 1)
			// 超时，服务器接管
			m.Done[0] = true
			m.Done[1] = true
		}

		if m.Done[0] && m.Done[1] {
			if !m.timer.Stop() {
				if !drain {
					<-m.timer.C
				}
			}
			// 检查当前回合输入, 自动选择
			if m.Step == m.finalStep {
				m.checkDeploy()
			} else {
				if m.sequence[m.Step].Ban > 0 {
					m.checkBan()
				} else if m.sequence[m.Step].Pick > 0 {
					m.checkPick()
					for _, deck := range m.decks {
						deck.updateRarityAndMarkID(m.cards)
					}
				}
			}
			m.InputSteps = append(m.InputSteps, m.currentInputStep)

			log.Infof("step %d done, next step %d", m.Step, m.Step+1)
			m.nextStep()
			var duration time.Duration
			if m.Step == m.finalStep {
				duration = WaitDeployDuration // 布阵时间
			} else if m.Step < m.finalStep {
				duration = time.Second * time.Duration(m.sequence[m.Step].Second)
			}
			m.broadcast(duration)
			if m.Step > m.finalStep {
				log.Debugf("ban pick deploy finished")
				break
			}
			drain = false
			m.timer.Reset(duration)
			atomic.StoreInt32(&m.refuseInput, 0)
		} else {
			m.broadcast(0)
		}
	}
}

// 扳对方卡牌
func (m *BanPick) ban(id document.ID, cards []document.ID, done bool) error {
	if m.Done[m.roleforce[id]] {
		return ErrRoleAlradyBan
	}
	expect := m.sequence[m.Step].Ban
	if expect <= 0 || len(cards) > expect {
		return ErrRoleCardError
	}

	vs := m.vs[id]
	if err := m.decks[vs].checkInput(cards, cardUnused); err != nil {
		return err
	}
	if done {
		m.Done[m.roleforce[id]] = true
	}
	return nil
}

// 选择自己卡牌
func (m *BanPick) pick(id document.ID, cards []document.ID, done bool) error {
	if m.Done[m.roleforce[id]] {
		return ErrRoleAlreadyPick
	}
	expect := m.sequence[m.Step].Pick
	if expect <= 0 || len(cards) > expect {
		return ErrRoleCardError
	}

	if err := m.decks[id].checkInput(cards, cardUnused); err != nil {
		return err
	}
	if err := m.decks[id].checkRarityAndMarkID(cards, m.cards, m.model.RarityLimit); err != nil {
		return err
	}

	if done {
		m.Done[m.roleforce[id]] = true
	}
	return nil
}

func (m *BanPick) nextStep() {
	m.Step++
	m.Done = [2]bool{}
	m.currentInputStep = scheme.BanPickInputStep{}
}

func (m *BanPick) deploy(id document.ID, cards []document.ID, natureChoose map[document.ID]int, done bool) error {
	deck := m.decks[id]
	if err := deck.checkDeployInput(cards); err != nil {
		return err
	}
	deck.deploy = cards
	deck.natureChoose = natureChoose
	if done {
		m.Done[m.roleforce[id]] = true
	}
	return nil
}

func (m *BanPick) checkDeploy() {
	for id, deck := range m.decks {
		if deck.deploy == nil { // 未布阵时自动布阵
			cards := make([]document.ID, 0, len(deck.cards))
			for card, status := range deck.cards {
				if status == cardPick {
					cards = append(cards, card)
				}
			}
			deck.deploy = cards
			m.insertToSteps(id, &scheme.BanPickInput{Step: m.Step, Action: DeployOp, Cards: cards})
		} else {
			if m.currentInputStep[m.roleforce[id]] == nil {
				log.Errorf("can not be nil")
			}
		}
	}
}

func (m *BanPick) checkBan() {
	expect := m.sequence[m.Step].Ban
	for id, idx := range m.roleforce {
		current := m.currentInputStep[idx]
		if current == nil {
			current = &scheme.BanPickInput{Step: m.Step, Action: BanOp}
			m.currentInputStep[idx] = current
		}
		vs := m.vs[id]
		current.Cards = m.decks[vs].random(expect, current.Cards)
		for _, card := range current.Cards {
			m.decks[vs].cards[card] = cardBan
		}
	}
}

func (m *BanPick) checkPick() {
	expect := m.sequence[m.Step].Pick
	for id, idx := range m.roleforce {
		current := m.currentInputStep[idx]
		if current == nil {
			current = &scheme.BanPickInput{Step: m.Step, Action: PickOp}
			m.currentInputStep[idx] = current
		}
		current.Cards = m.decks[id].randomPick(expect, current.Cards, m.cards, m.model.RarityLimit)
		for _, card := range current.Cards {
			m.decks[id].cards[card] = cardPick
		}
	}
}

func (m *BanPick) broadcast(duration time.Duration) {
	delta := m.delta(m.cursor)
	if duration > 0 {
		delta.CountDownTimestamp = util.Now().Unix()
		delta.CountDown = int(duration.Seconds())
	}
	err := m.pusher.push(&BroadcastModel{
		Ret:     true,
		BanPick: delta,
	})
	if err == nil {
		m.cursor = len(m.InputSteps)
	}
}

func newBanpickModel(info *proto.BattleInfo) *banpickModel {
	model := &banpickModel{
		Role1:       info.Role1.CrossOnlineFightRole,
		Role2:       info.Role2.CrossOnlineFightRole,
		BanPicks:    info.BanPicks,
		RarityLimit: info.RarityLimit,

		CrossOnlineFightLimitedCardDeck: info.PlayRecord.LimitedCardDeck,
	}
	return model
}

func NewBanPick(cards map[document.ID]*proto.CrossOnlineFightCard, model *banpickModel, pusher pusher) *BanPick {
	m := &BanPick{
		sequence:  model.BanPicks,
		decks:     make(map[document.ID]*carddeck),
		finalStep: len(model.BanPicks), // csv step , deploy step
		cards:     cards,
		pusher:    pusher,
		model:     model,
	}
	deckcards1 := make(map[document.ID]int)
	for _, card := range model.RoleCardDeck1 {
		deckcards1[card] = cardUnused
	}
	deckcards2 := make(map[document.ID]int)
	for _, card := range model.RoleCardDeck2 {
		deckcards2[card] = cardUnused
	}
	role1 := model.Role1.RoleID
	role2 := model.Role2.RoleID
	m.decks[role1] = &carddeck{cards: deckcards1, raritys: make(map[int]int), markids: map[int]int{}}
	m.decks[role2] = &carddeck{cards: deckcards2, raritys: make(map[int]int), markids: map[int]int{}}
	m.vs = map[document.ID]document.ID{role1: role2, role2: role1}
	m.roleforce = map[document.ID]int{role1: 0, role2: 1}
	m.inputs = make(chan *BanPickInput, 2)
	m.InputSteps = make([]scheme.BanPickInputStep, 0, 8)
	return m
}

func copyIntMap(m map[int]int) map[int]int {
	ret := make(map[int]int, len(m))
	for k, v := range m {
		ret[k] = v
	}
	return ret
}

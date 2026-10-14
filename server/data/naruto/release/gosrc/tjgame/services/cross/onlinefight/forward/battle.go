package forward

import (
	"context"
	"errors"
	"fmt"
	"sync"
	"sync/atomic"
	"time"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/net"
	"tjgame/server_framework/tj/util"
	"tjgame/services/cross/onlinefight/proto"
	gamecards "tjgame/services/game/cards"
)

const (
	UnKnown     = 0
	Start       = 1
	BothBanPick = 2 // 双方选择
	Deploy      = 3 // 双方布阵
	WaitLoading = 4 // 等待双方加载
	Attack      = 5 // 开始战斗
	WaitResult  = 6 // 等待结果
	BattleOver  = 7 // 战斗结束
)

const (
	// battle result
	ResultWin     = "win"     // 胜
	ResultFail    = "fail"    // 负
	ResultFlee    = "flee"    // 逃跑 (无奖励, 不计入周目标次数)
	ResultGiveUp  = "giveup"  // 认输 (不计入周目标次数)
	ResultOffline = "offline" // 离线
	ResultUnknown = ""
)

var (
	MaxOfflineDuration  = 120 * time.Second // 最大离线时间
	WaitDeployDuration  = 30 * time.Second  // 等待布阵时间
	WaitConnectDuration = 15 * time.Second  // 等待连接时间
	WaitReadyDuration   = 30 * time.Second  // 等待加载时间

	WaitAttackDurationSequences = []time.Duration{
		15 * time.Second,
		15 * time.Second,
		7 * time.Second,
		5 * time.Second,
	} // 等待攻击时间

	debug          = false
	proxyRunner    = "agent" // agent, fake, resume
	syncHeroStatus = true

	ErrBattleAlreadyOver = errors.New("battle already over")
	ErrInputInvalid      = errors.New("input invalid")
	ErrInputRefuse       = errors.New("input refuse")
	ErrAttackError       = errors.New("attack error")

	ErrNoSession = errors.New("no session")
	ErrNoBattle  = errors.New("no battle")

	UnknownResults = [2]string{}
)

func useAntiProxyRunner() bool {
	return !debug || proxyRunner == "agent"
}

func decreaseWaitAttackDuration(decrease int) time.Duration {
	total := len(WaitAttackDurationSequences)
	if decrease >= total {
		return WaitAttackDurationSequences[total-1]
	}
	return WaitAttackDurationSequences[decrease]
}

// TODO: 临时判断，需要修改为runner返回的force
func getForceByWho(who int) int {
	if who > 6 {
		return 1
	}
	return 0
}

type card struct {
	_struct struct{} `codec:",toarray"`

	HP    float64
	MP    float64
	State int
}

type locals struct {
	State              int                  `codec:"state"`               // 阶段
	FrameID            int                  `codec:"frame_id"`            // 当前帧
	Who                int                  `codec:"who"`                 // 当前出手者
	CountDown          int                  `codec:"countdown"`           // 本次操作倒计时
	CountDownTimestamp int64                `codec:"countdown_timestamp"` // 本次操作开始倒计时时间戳
	Offline            [2]bool              `codec:"offline"`             // 当前是否离线
	Frames             []scheme.AttackFrame `codec:"frames"`              // 操作集 (增量同步)

	HeroStatus []*card `codec:"hero_status,omitempty"` // 状态同步数据
}

func (l *locals) nextframe() {
	l.FrameID += 1
}

func (l *locals) reset() {
	l.State = UnKnown
	l.FrameID = 0
	l.Who = 0
	l.CountDown = 0
	l.CountDownTimestamp = 0
	l.Offline = [2]bool{false, false}
	l.Frames = make([]scheme.AttackFrame, 0, 64)
	l.HeroStatus = nil
}

type inputWrapper struct {
	*scheme.BanPickInput
	*scheme.AttackInput

	err chan error
}

type Handler func(event string) int

type Battle struct {
	id       document.ID
	sessions [2]*Session
	ready    [2]int32 // element mean 1-connected, 2-loading ok

	frameCursor int // 当前需要发送的frame
	// 数据记录
	locals

	// agent proxy runner
	runner ProxyRunner

	banpick *BanPick

	// result
	loop      int32 // 1- battle start, 2 - the attack loop is start
	over      int32 // 1 - the battle is over
	results   [2]string
	wonderful bool // 精彩战报
	done      chan struct{}
	error     error

	inputs      chan inputWrapper // 待处理input
	inputTimer  *time.Timer       // 操作定时器(如果定时器到达，由服务器接管客户端操作，不接受当前客户端操作输入)
	refuseInput int32
	decrease    [2]int // 攻击倒计时递减

	solo bool // 人机对抗

	logPrefix string

	info *proto.BattleInfo

	ctx    context.Context
	cancel context.CancelFunc

	// 客户端认输或逃跑临时记录结果
	temp        uint32
	tempResults [2]string
}

func (battle *Battle) init() {
	battle.locals.reset()
	battle.frameCursor = 0
	battle.results = [2]string{}
	battle.inputs = make(chan inputWrapper)
	if battle.inputTimer != nil {
		battle.inputTimer.Stop()
		battle.inputTimer = nil
	}
	atomic.StoreInt32(&battle.refuseInput, 0)
	battle.done = make(chan struct{})
	battle.logPrefix = fmt.Sprintf("battle %s", battle.id)

	ctx, cancel := context.WithCancel(context.Background())
	battle.ctx = ctx
	battle.cancel = cancel
}

func (battle *Battle) SetProxyRunner(runner ProxyRunner) {
	battle.runner = runner
	if r, ok := runner.(*AntiProxyRunner); ok {
		log.Infof("%s use anti proxy runner %d", battle.logPrefix, r.idx)
	}
}

func (battle *Battle) Done() <-chan struct{} {
	return battle.done
}

func (battle *Battle) Result() *proto.BattleResult {
	result := &proto.BattleResult{
		ID:           battle.id,
		Results:      battle.results,
		AttackFrames: battle.Frames,
		Wonderful:    battle.wonderful,
	}
	if battle.banpick != nil {
		result.BanPickInputSteps = battle.banpick.InputSteps
		result.Cards = battle.info.PlayRecord.Cards
		result.CardAttrs = battle.info.PlayRecord.CardAttrs
		result.DefenceCards = battle.info.PlayRecord.DefenceCards
		result.DefenceCardAttrs = battle.info.PlayRecord.DefenceCardAttrs
	}
	return result
}

func (battle *Battle) startWaitConnectTimer() {
	battle.State = Start
	if battle.inputTimer != nil {
		battle.inputTimer.Stop()
		battle.inputTimer = nil
	}
	battle.inputTimer = time.AfterFunc(WaitConnectDuration, battle.start)
}

// client session connect
func (battle *Battle) connect(session *Session) {
	if battle.isOver() {
		return
	}
	if battle.State != Start {
		return
	}
	log.Infof("%s client %s connect", battle.logPrefix, session.id)

	if battle.sessions[0] == session {
		atomic.StoreInt32(&battle.ready[0], 1)
	} else if battle.sessions[1] == session {
		atomic.StoreInt32(&battle.ready[1], 1)
	}

	// 这里需要等待双方连接
	if battle.solo || (atomic.LoadInt32(&battle.ready[0]) == 1 && atomic.LoadInt32(&battle.ready[1]) == 1) {
		battle.start()
	}
}

func (battle *Battle) start() {
	if atomic.CompareAndSwapInt32(&battle.loop, 0, 1) {
		if atomic.LoadInt32(&battle.ready[0]) == 0 && atomic.LoadInt32(&battle.ready[1]) == 0 {
			// 双方都未连接
			battle.onBattleOver(UnknownResults)
			battle.broadcast(0)
			battle.clean()
			return
		}
		// 只要有一方连接，就可以开始
		if battle.inputTimer != nil {
			battle.inputTimer.Stop()
		}
		if battle.banpick != nil {
			battle.State = BothBanPick
			go battle.startBanPickLoop()
		} else {
			battle.startWaitloading()
		}
	}
}

func (battle *Battle) startBanPickLoop() {
	if battle.State != BothBanPick {
		log.Warningf("startBanPickLoop status error %d", battle.State)
	}
	log.Infof("%s startBanPickLoop", battle.logPrefix)
	battle.broadcast(0)

	battle.banpick.loop(battle.ctx)

	if battle.tryHandleClientResult() {
		return
	}

	// TODO: 后面需要加上，目前客户端处理上还有问题
	//if battle.tryForceOverBattle() {
	//	return
	//}

	// 获取最终参战阵容, 开始 waitloading
	cards := battle.banpick.decks[battle.info.Role1.RoleID].deploy
	defenceCards := battle.banpick.decks[battle.info.Role2.RoleID].deploy
	play := battle.info.PlayRecord
	play.Cards = cards
	play.DefenceCards = defenceCards
	play.CardAttrs = make(map[document.ID]*scheme.CardBattleModel)
	play.DefenceCardAttrs = make(map[document.ID]*scheme.CardBattleModel)
	for _, id := range cards {
		play.CardAttrs[id] = battle.info.LimitedCardDeck.CardAttrs[id]
	}
	for _, id := range defenceCards {
		play.DefenceCardAttrs[id] = battle.info.LimitedCardDeck.CardAttrs[id]
	}
	// 队伍光环
	chooses := gamecards.AppendBattleCardHalo(play.Cards, play.CardAttrs, 0)
	if chooses != nil {
		for idx, id := range play.Cards {
			play.CardAttrs[id].NatureChoose = chooses[idx] + 1
		}
	}
	chooses = gamecards.AppendBattleCardHalo(play.DefenceCards, play.DefenceCardAttrs, 0)
	if chooses != nil {
		for idx, id := range play.DefenceCards {
			play.DefenceCardAttrs[id].NatureChoose = chooses[idx] + 1
		}
	}

	battle.push(&BroadcastModel{Ret: true, CrossOnlineFightBattle: play})

	battle.startWaitloading()
}

func (battle *Battle) startWaitloading() {
	battle.State = WaitLoading
	log.Infof("%s startWaitloading, next %s tryStartAttackLoop", battle.logPrefix, WaitReadyDuration)
	battle.broadcast(WaitReadyDuration)
	battle.inputTimer = time.AfterFunc(WaitReadyDuration, battle.tryStartAttackLoop)
}

func (battle *Battle) startAttackLoop() {
	battle.State = Attack
	log.Infof("%s startAttackLoop", battle.logPrefix)
	atomic.StoreInt32(&battle.refuseInput, 0)
	if battle.inputTimer != nil {
		battle.inputTimer.Stop()
	}
	battle.broadcast(decreaseWaitAttackDuration(0))
	battle.inputTimer = time.NewTimer(decreaseWaitAttackDuration(0))
	drain := false // drain the inputTimer channel

	for atomic.LoadInt32(&battle.over) == 0 {
		log.Infof("%s attack loop frame %d, who %d", battle.logPrefix, battle.FrameID, battle.Who)

		var response *ProxyRunnerResponse
		var err error
		select {
		case <-battle.ctx.Done():
			// 客户端有逃跑或放弃
			battle.handleClientResult(battle.tempResults)

		case input := <-battle.inputs:
			force := getForceByWho(battle.Who)
			response, err = battle.handleAttackInput(*input.AttackInput)
			input.err <- err
			close(input.err)
			if err == nil {
				battle.decrease[force] = 0
			}

		case <-battle.inputTimer.C:
			drain = true
			// 等待客户端操作超时，服务器接管操作
			atomic.StoreInt32(&battle.refuseInput, 1)
			log.Debugf("%s server take over %d input", battle.logPrefix, battle.Who)
			force := getForceByWho(battle.Who)
			battle.decrease[force] += 1 // 操作时间递减
			response, err = battle.handleAttackInput(scheme.AttackInput{
				FrameID: battle.FrameID,
				Current: battle.Who,
			})
		}

		if response != nil {
			resume := battle.handleRunnerResponse(response)
			log.Debugf("%s handleRunnerResponse, resume %v, timer drain %v", battle.logPrefix, resume, drain)
			if resume {
				// 检查双方的链接是否还存活, 决定是否直接结束战斗
				resume = !battle.tryForceOverBattle()
			}
			if !battle.inputTimer.Stop() {
				if !drain {
					<-battle.inputTimer.C
				}
			}
			atomic.StoreInt32(&battle.refuseInput, 0)
			if resume {
				drain = false
				force := getForceByWho(battle.Who)
				duration := decreaseWaitAttackDuration(battle.decrease[force])
				battle.broadcast(duration)
				battle.inputTimer.Reset(duration)
				log.Debugf("%s resume timer %v", battle.logPrefix, duration)
			} else {
				battle.broadcast(0)
			}
		}
	}

	if !battle.inputTimer.Stop() {
		select {
		case <-battle.inputTimer.C:
		default:
		}
	}
	battle.clean()
}

// client loading finish
func (battle *Battle) doReady(session *Session) {
	if battle.sessions[0] == session {
		atomic.StoreInt32(&battle.ready[0], 2)
	} else if battle.sessions[1] == session {
		atomic.StoreInt32(&battle.ready[1], 2)
	}
	if battle.isAttackLoopStart() {
		return
	}

	if battle.solo || (atomic.LoadInt32(&battle.ready[0]) == 2 && atomic.LoadInt32(&battle.ready[1]) == 2) {
		if battle.inputTimer != nil {
			battle.inputTimer.Stop() // stop wait ready timer
		}
		battle.tryStartAttackLoop()
	}
}

func (battle *Battle) isAttackLoopStart() bool {
	return atomic.LoadInt32(&battle.loop) == 2
}

func (battle *Battle) isOver() bool {
	return atomic.LoadInt32(&battle.over) == 1
}

func (battle *Battle) tryStartAttackLoop() {
	if atomic.CompareAndSwapInt32(&battle.loop, 1, 2) {
		if battle.tryHandleClientResult() {
			return
		}

		battle.startRunner()
		if battle.error != nil {
			// 处理runner初始化出错情况
			log.Errorf("%s startRunner error %v", battle.logPrefix, battle.error)
			battle.clean()
			return
		}
		// 启动 attack loop
		go battle.startAttackLoop()
	}
}

func (battle *Battle) startRunner() {
	response, err := battle.runner.StartBattle(battle.info.PlayRecord)
	if err != nil {
		battle.error = err
		battle.onBattleOver(UnknownResults)
		battle.broadcast(0)
		return
	}
	battle.handleRunnerResponse(response)
}

func (battle *Battle) inputValid(input scheme.AttackInput) bool {
	if battle.FrameID != input.FrameID {
		log.Warningf("input %v invalid, expect frame %d, got %d", input, battle.FrameID, input.FrameID)
		return false
	}
	if battle.Who != input.Current {
		log.Warningf("input %v invalid, expect who %d, got %d", input, battle.Who, input.Current)
		return false
	}
	return true
}

func (battle *Battle) AddAttackInput(session *Session, input *scheme.AttackInput) (<-chan error, error) {
	if atomic.LoadInt32(&battle.refuseInput) == 0 {
		wrap := inputWrapper{
			AttackInput: input,
			err:         make(chan error, 1),
		}
		battle.inputs <- wrap
		return wrap.err, nil
	}
	return nil, ErrInputRefuse
}

func (battle *Battle) handleAttackInput(input scheme.AttackInput) (*ProxyRunnerResponse, error) {
	if battle.isOver() {
		return nil, ErrBattleAlreadyOver
	}

	if !battle.inputValid(input) {
		return nil, ErrInputInvalid
	}
	log.Infof("%s handler input current %d, target %d, skill %d", battle.logPrefix, input.Current, input.Target, input.Skill)
	response, err := battle.runner.Attack(battle.id, input.Current, input.Target, input.Skill)
	if err != nil {
		log.Warningf(" %v handle input %v, error %s", battle.logPrefix, input, err)
		return &ProxyRunnerResponse{
			ID:     battle.id,
			Result: "error",
		}, ErrAttackError
	}
	battle.Frames = append(battle.Frames, scheme.AttackFrame{Input: input})
	return response, nil
}

func (battle *Battle) handleRunnerResponse(response *ProxyRunnerResponse) bool {
	log.Infof("%s runner response next %d, rand_cnt %d, result %s, wonderful %v", battle.logPrefix, response.Next, response.RandCnt, response.Result, response.Wonderful)
	if response.Result != "" {
		results := [2]string{}
		if response.Result == ResultWin {
			results = [2]string{ResultWin, ResultFail}
		} else if response.Result == ResultFail {
			results = [2]string{ResultFail, ResultWin}
		}
		battle.wonderful = response.Wonderful
		battle.onBattleOver(results)
		return false
	}
	if syncHeroStatus && len(response.Status) > 0 {
		status := make([]*card, 12)
		err := util.MsgUnpack(response.Status, status)
		if err == nil {
			battle.HeroStatus = status
		} else {
			log.Warningf("battle %v handleRunnerResponse error %v", battle.id, err)
		}
	}
	battle.nextframe()
	battle.Who = response.Next
	return true
}

func (battle *Battle) onBattleOver(results [2]string) {
	if atomic.CompareAndSwapInt32(&battle.over, 0, 1) {
		battle.State = BattleOver
		battle.results = results
		log.Infof("%s onBattleOver results %s", battle.logPrefix, results)
		close(battle.done)
	}
}

func (battle *Battle) tryForceOverBattle() bool {
	now := util.Now()
	force := false
	for _, session := range battle.sessions {
		if session == nil {
			continue
		}
		// 长时间离线判断
		if session.stale && now.Sub(session.staleTime) > MaxOfflineDuration {
			force = true
			break
		}
	}
	if force {
		results := [2]string{}
		if battle.sessions[0] == nil {
			results = [2]string{ResultOffline, ResultWin}
		} else if battle.sessions[1] == nil {
			results = [2]string{ResultWin, ResultOffline}
		}

		if battle.sessions[0].stale && battle.sessions[1].stale {
			// 双方离线
			if battle.sessions[0].staleTime.After(battle.sessions[1].staleTime) {
				results = [2]string{ResultWin, ResultOffline}
			} else {
				results = [2]string{ResultOffline, ResultWin}
			}
		} else if battle.sessions[0].stale && !battle.sessions[1].stale {
			// 左边离线, 右边在线
			results = [2]string{ResultOffline, ResultWin}
		} else {
			// 左边在线，右边离线
			results = [2]string{ResultWin, ResultOffline}
		}

		log.Infof("%s force over", battle.logPrefix)
		battle.onBattleOver(results)
		battle.broadcast(0)
	}
	return force
}

func (battle *Battle) SetTempResult(results [2]string) error {
	if atomic.CompareAndSwapUint32(&battle.temp, 0, 1) {
		battle.tempResults = results
		battle.cancel()
		return nil
	}
	return errors.New("you slow")
}

func (battle *Battle) handleClientResult(results [2]string) {
	log.Infof("%s cancel by %s", battle.logPrefix, results)
	battle.onBattleOver(results)
	battle.broadcast(0)
}

// 客户端有发送逃跑和放弃
func (battle *Battle) tryHandleClientResult() bool {
	select {
	case <-battle.ctx.Done():
		battle.handleClientResult(battle.tempResults)
		battle.clean()
		return true
	default:
	}
	return false
}

func (battle *Battle) clean() {
	log.Infof("%s clean", battle.logPrefix)
	for _, session := range battle.sessions {
		if session != nil {
			session.onDiscard(false)
		}
	}
	battle.runner.CloseBattle(battle.id)
}

func (battle *Battle) deltaLocals(cursor int) *locals {
	locals := &locals{
		State:   battle.State,
		FrameID: battle.FrameID,
		Who:     battle.Who,
		Offline: [2]bool{},
	}
	locals.Frames = battle.Frames[cursor:]
	// TODO: 优化hero status 同步策略
	locals.HeroStatus = battle.HeroStatus
	return locals
}

func (battle *Battle) broadcast(countdown time.Duration) {
	locals := battle.deltaLocals(battle.frameCursor)
	locals.Frames = battle.Frames[battle.frameCursor:]
	if countdown > 0 {
		locals.CountDown = int(countdown.Seconds())
		locals.CountDownTimestamp = util.Now().Unix()
	}

	err := battle.push(&BroadcastModel{
		Ret:     true,
		Remotes: locals,
	})
	if err == nil {
		battle.frameCursor = len(battle.Frames)
	}
}

func (battle *Battle) push(v *BroadcastModel) error {
	if v.Remotes != nil {
		for i, session := range battle.sessions {
			if session != nil {
				v.Remotes.Offline[i] = session.stale
			}
		}
	}
	if v.BanPick != nil {
		for i, session := range battle.sessions {
			if session != nil {
				v.BanPick.Offline[i] = session.stale
			}
		}
	}

	response := net.NewPacket(net.WithUrl("/onlinefight/push"))
	data, err := util.MsgPack(v)
	if err != nil {
		response.SetFlag(true, net.ErrACKBit)
	} else {
		response.SetBody(data)
	}
	log.Infof("battle %s forward %s %dB", battle.id, response.Url(), len(data))
	for _, session := range battle.sessions {
		if session == nil {
			continue
		}
		session.WritePacket(response)
	}
	return err
}

func NewBattle(info *proto.BattleInfo) *Battle {
	battle := &Battle{
		id:   info.ID,
		solo: info.Solo,
		info: info,
	}
	if info.BanPicks != nil {
		model := newBanpickModel(info)
		banpick := NewBanPick(info.LimitedCardDeck.Cards, model, battle)
		battle.banpick = banpick
	}
	battle.init()

	return battle
}

// 客户端随机数次数记录
type randCountRecord struct {
	mu      sync.Mutex
	records map[int][]int
}

func (r *randCountRecord) record(frameid int, index int, count int) {
	r.mu.Lock()
	defer r.mu.Unlock()
	if _, ok := r.records[frameid]; !ok {
		r.records[frameid] = make([]int, 3)
	}
	r.records[frameid][index] = count
}

func (r *randCountRecord) get(frameid int) []int {
	r.mu.Lock()
	defer r.mu.Unlock()
	if v, ok := r.records[frameid]; ok {
		//if v[0] == 0 || v[1] == 0 {
		//	return nil
		//}
		return v
	}
	return nil
}

func newRandCountRecord() *randCountRecord {
	return &randCountRecord{
		records: make(map[int][]int),
	}
}

package forward

import (
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	tjnet "tjgame/server_framework/tj/net"
	"tjgame/server_framework/tj/util"
)

type Context struct {
	mgr     *SessionManager
	conn    *tjnet.Conn
	session *Session
	battle  *Battle
}

type Task interface {
	Url() string
	Run(ctx Context) Response
}

type Response interface {
	Result() []byte
	Over() bool
	Error() string
}

type prepare interface {
	prepare(ctx Context)
}

type finish interface {
	finish(ctx Context)
}

func GetTaskByURL(url string) Task {
	switch url {
	case "/onlinefight/login":
		return &LoginTask{}
	case "/onlinefight/input":
		return &InputTask{}
	case "/onlinefight/attack":
		return &AttackTask{}
	case "/onlinefight/net/test":
		return &NetTestTask{}
	case "/onlinefight/control":
		return &ControlTask{}
	}
	return nil
}

type clientResponse struct {
	Ret bool   `codec:"ret"`
	Err string `codec:"err,omitempty"`

	// 扳选卡相关
	BanPickLocals *banpickLocals `codec:"banpick,omitempty"`
	BanPickModel  *banpickModel  `codec:"cross_online_fight_banpick"`

	// 战斗相关
	Remotes                *locals                            `codec:"remotes,omitempty"`
	CrossOnlineFightBattle *scheme.CrossOnlineFightPlayRecord `codec:"cross_online_fight_battle"`

	closed bool
}

func (r *clientResponse) Result() []byte {
	data, err := util.MsgPack(r)
	if err != nil {
		log.Errorf("client response %v msgpack error %v", r, err)
	}
	return data
}

func (r *clientResponse) Over() bool {
	return r.closed
}

func (r *clientResponse) Error() string {
	return r.Err
}

type LoginTask struct {
	RoleID  document.ID `codec:"role_id"`
	ServKey string      `codec:"serv_key"`
	FrameID int         `codec:"frame_id,omitempty"`
}

func (t *LoginTask) Url() string {
	return "/onlinefight/login"
}

func (t *LoginTask) prepare(ctx Context) {
	conn := ctx.conn
	session := ctx.mgr.GetSession(t.RoleID)
	if session != nil && session.battle != nil {
		ctx.mgr.SetSessionConn(session, conn)
	}
}

func (t *LoginTask) Run(ctx Context) Response {
	conn := ctx.conn
	log.Infof("conn %s, %v login", conn.RemoteAddr(), t.RoleID)

	response := &clientResponse{Ret: true}
	battle := ctx.battle
	response.CrossOnlineFightBattle = battle.info.PlayRecord
	response.Remotes = battle.deltaLocals(t.FrameID)
	if battle.banpick != nil {
		response.BanPickModel = battle.banpick.model
		response.BanPickLocals = battle.banpick.delta(0)
	}
	return response
}

func (t *LoginTask) finish(ctx Context) {
	session := ctx.mgr.GetSession(t.RoleID)
	if session != nil && session.battle != nil {
		session.battle.connect(session)
	}
}

type InputTask struct {
	// 加载进度条完成 waitloading
	Ready bool `codec:"ready,omitempty"`

	// 玩家逃跑(无奖励)
	Flee bool `codec:"flee,omitempty"`

	// 玩家认输
	GiveUp bool `codec:"giveup,omitempty"`

	// 玩家扳卡/选卡/布阵
	Input *BanPickInput `codec:"input,omitempty"`

	// 同步扳选卡，战斗,  banpick, battle
	Sync   string `codec:"sync,omitempty"`
	Cursor int    `codec:"cursor,omitempty"`

	RandCount int `codec:"rand_count,omitempty"`
}

func (t *InputTask) Url() string {
	return "/onlinefight/input"
}

func (t *InputTask) Run(ctx Context) Response {
	response := &clientResponse{Ret: true}
	session := ctx.session
	battle := ctx.battle

	if t.Ready {
		if _, ok := battle.runner.(*ResumeProxyRunner); ok {
			go battle.doReady(session)
		} else {
			battle.doReady(session)
		}
	}

	if t.GiveUp || t.Flee {
		results := [2]string{}
		for i, s := range battle.sessions {
			if s == session {
				if t.GiveUp {
					results[i] = ResultGiveUp
				} else {
					results[i] = ResultFlee
				}
			} else {
				results[i] = ResultWin
			}
		}
		err := battle.SetTempResult(results)
		if err != nil {
			response.Ret = false
			response.Err = err.Error()
			return response
		}
	}

	if t.Input != nil {
		if t.Input.NatureChoose != nil {
			// 校验自然属性是否正确
			for _, id := range t.Input.Cards {
				choose := t.Input.NatureChoose[id]
				if choose != 1 && choose != 2 {
					response.Ret = false
					response.Err = ErrCardNotMatched.Error()
					return response
				}
			}
		}

		// 玩家扳卡/选卡/布阵
		errch, err := ctx.battle.banpick.AddInput(ctx.session.id, t.Input)
		if err == nil {
			err = <-errch
		}
		if err != nil {
			response.Ret = false
			response.Err = err.Error()
		}
	}

	if t.Sync != "" {
		response := &SyncResponse{}
		response.Ret = true
		if t.Sync == "banpick" {
			if battle.banpick == nil {
				response.Err = "not banpick battle"
				return response
			}
			response.BanPickModel = battle.banpick.model
			response.BanPickLocals = battle.banpick.delta(t.Cursor)
		} else if t.Sync == "battle" {
			response.CrossOnlineFightBattle = battle.info.PlayRecord
			response.Remotes = battle.deltaLocals(t.Cursor)
		}
		return response
	}

	return response
}

type clientLocals struct {
	FrameID int `codec:"frame_id,omitempty"`
	Who     int `codec:"who,omitempty"`
}

// 玩家攻击操作
type AttackTask struct {
	Inputs       []scheme.AttackInput `codec:"inputs"`
	ClientLocals clientLocals         `codec:"locals,omitempty"`
	RandCount    int                  `codec:"rand_count,omitempty"`
}

func (t *AttackTask) Url() string {
	return "/onlinefight/attack"
}

func (t *AttackTask) Run(ctx Context) Response {
	response := &clientResponse{Ret: true}
	errch, err := ctx.battle.AddAttackInput(ctx.session, &t.Inputs[0]) // TODO: 处理多个的情况
	if err == nil {
		err = <-errch
	}
	if err != nil {
		response.Ret = false
		response.Err = err.Error()
	}
	return response
}

type NetTestTask struct {
	ClientTime float64 `codec:"client_time"`
}

func (t *NetTestTask) Url() string {
	return "/onlinefight/net/test"
}

func (t *NetTestTask) Run(ctx Context) Response {
	response := &netTestResponse{Ret: true}
	response.ClientTime = t.ClientTime
	response.ServerTime = float64(util.Now().UnixNano() / 1e6)
	return response
}

type netTestResponse struct {
	Ret        bool    `codec:"ret"`
	ClientTime float64 `codec:"client_time"`
	ServerTime float64 `codec:"server_time"`
	Err        string  `codec:"err,omitempty"`
}

func (r *netTestResponse) Result() []byte {
	data, err := util.MsgPack(r)
	if err != nil {
		log.Errorf("client response %v msgpack error %v", r, err)
	}
	return data
}

func (r *netTestResponse) Over() bool {
	return false
}

func (r *netTestResponse) Error() string {
	return r.Err
}

// 控制操作（开发使用）
type ControlTask struct {
	Next   int    `codec:"next,omitempty"`
	Runner string `codec:"runner,omitempty"`
}

func (t *ControlTask) Url() string {
	return "/onlinefight/control"
}

func (t *ControlTask) Run(ctx Context) Response {
	battle := ctx.battle
	if !debug {
		return &clientResponse{
			Ret: false,
			Err: "not in debug model",
		}
	}
	response := &clientResponse{Ret: true}
	if debug {
		if t.Runner != "" {
			log.Infof("%s client set runner %s", battle.logPrefix, t.Runner)
			if t.Runner == "fake" {
				battle.runner = &FakeProxyRunner{}
			} else if t.Runner == "resume" {
				battle.runner = NewResumeProxyRunner(battle)
			}
		}

		//完全信任客户端的who
		if t.Next != 0 {
			log.Infof("%s client set next who %d", battle.logPrefix, t.Next)
			runner := battle.runner.(*ResumeProxyRunner)
			runner.Resume(t.Next)
		}
	}

	return response
}

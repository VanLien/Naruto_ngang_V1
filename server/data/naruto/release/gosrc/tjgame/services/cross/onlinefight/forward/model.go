package forward

import (
	"tjgame/document/scheme"
	"tjgame/services/cross/onlinefight/proto"
)

// 扳选卡/战斗广播
type BroadcastModel struct {
	Ret bool   `codec:"ret"`
	Err string `codec:"err,omitempty"`

	// 扳选卡增量广播
	BanPick *banpickLocals `codec:"banpick,omitempty"`

	// 战斗input增量广播
	Remotes *locals `codec:"remotes,omitempty"`

	// 战斗战报
	CrossOnlineFightBattle *scheme.CrossOnlineFightPlayRecord `codec:"cross_online_fight_battle,omitempty"`

	// 双方随机数次数
	RandCounts []int `codec:"rand_counts,omitempty"`
}

type SyncResponse struct {
	clientResponse

	// 扳选卡相关
	BanPickLocals *banpickLocals `codec:"banpick,omitempty"`
	BanPickModel  *banpickModel  `codec:"cross_online_fight_banpick"`

	// 战斗相关
	Remotes                *locals                            `codec:"remotes,omitempty"`
	CrossOnlineFightBattle *scheme.CrossOnlineFightPlayRecord `codec:"cross_online_fight_battle"`
}

type banpickModel struct {
	Role1 scheme.CrossOnlineFightRole `codec:"role1"`
	Role2 scheme.CrossOnlineFightRole `codec:"role2"`
	// 公平赛选卡规则
	BanPicks []proto.BanPick `codec:"banpicks"`
	// 公平赛主题稀有度限制
	RarityLimit map[int]int `codec:"rarityLimit"`
	// 公平赛卡组信息
	*scheme.CrossOnlineFightLimitedCardDeck
}

type banpickLocals struct {
	CountDown          int     `codec:"countdown,omitempty"`           // 本次操作倒计时
	CountDownTimestamp int64   `codec:"countdown_timestamp,omitempty"` // 本次操作开始倒计时时间戳
	Done               [2]bool `codec:"done"`                          // 当前操作是否完成
	Offline            [2]bool `codec:"offline"`                       // 当前是否离线

	Step       int                       `codec:"step"`
	InputSteps []scheme.BanPickInputStep `codec:"inputsteps"`
}

func (l *banpickLocals) delta(cursor int) *banpickLocals {
	locals := &banpickLocals{
		Done:       l.Done,
		Step:       l.Step,
		InputSteps: l.InputSteps[cursor:],
	}
	return locals
}

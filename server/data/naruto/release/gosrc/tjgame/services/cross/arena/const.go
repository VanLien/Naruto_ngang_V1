package arena

import (
	"errors"
	"time"
	"tjgame/server_framework/tj/util"
)

const (
	// 跨服竞技场排名总数
	TopRankMax = 50
)

var (
	ErrRankChanged      = errors.New("rankChanged")
	ErrInBattle         = errors.New("rankEnemyBattling")
	ErrNotInBattle      = errors.New("not in battle")
	ErrRankEnemyChanged = errors.New("rankEnemyChanged")
	ErrRankCheat        = errors.New("rankCheat")
	ErrRoundClosed      = errors.New("cross_arena round is closed")
	ErrPatchBehind      = errors.New("patchBehind")
)

var (
	startTime = util.Time{Hour: 10, Minute: 0} // 开始
	closeTime = util.Time{Hour: 22, Minute: 0} // 结束

	TestInQuick       = false
	TestRobotDuration = time.Second * 5
)

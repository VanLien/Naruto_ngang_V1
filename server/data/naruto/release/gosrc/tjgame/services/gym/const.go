package gym

import (
	"errors"
	"time"
	"tjgame/server_framework/tj/util"
)

var (
	ErrInBattle              = errors.New("gymEnemyBattling")
	ErrNotInBattle           = errors.New("not in battle")
	ErrGymLeaderEnemyChanged = errors.New("gymEnemyChanged")
	ErrCheat                 = errors.New("cheat")
	ErrRoundClosed           = errors.New("gym round is closed")
	ErrGymLeaderNotEmpty     = errors.New("gymLeaderNotEmpty")
)

var (
	prepareTime = util.Time{Hour: 5, Minute: 0}   // 准备
	startTime   = util.Time{Hour: 10, Minute: 0}  // 开始
	closeTime   = util.Time{Hour: 21, Minute: 45} // 结束

	TestInQuick  = false
	TestDuration = time.Second * 5
)

const (
	GymReset     = 1 // 道馆重置
	GymFubenPass = 2 // 通关xx道馆副本
	GymAllPass   = 3 // 道馆全通关

	GymOccupy     = 4 // 占领本服xx道馆
	GymLeaderWin  = 5 // 挑战并成功本服xx馆主
	GymLeaderFail = 6 // 挑战且失败本服xx馆主

	CrossGymLeaderOccupy = 7  // 占领跨服xx馆主
	CrossGymOccupy       = 8  // 占领跨服xx道馆馆员
	CrossGymLeaderWin    = 9  // 挑战并成功跨服xx馆主
	CrossGymWin          = 10 // 挑战并成功跨服xx馆员
	CrossGymLeaderFail   = 11 // 挑战且失败跨服xx馆主
	CrossGymFail         = 12 // 挑战且失败跨服xx馆员

	GymLeaderDefenceWin  = 13 // 本服xx道馆被挑战且防守成功
	GymLeaderDefenceFail = 14 // 本服xx道馆被挑战但防守失败

	CrossGymLeaderDefenceWin  = 15 // 跨服xx道馆馆主被挑战且防守成功
	CrossGymLeaderDefenceFail = 16 // 跨服xx道馆馆主被挑战但防守失败
	CrossGymDefenceWin        = 17 // 跨服xx道馆馆员被挑战且防守成功
	CrossGymDefenceFail       = 18 // 跨服xx道馆馆员被挑战但防守失败

	GymClosed = 19 // 道馆关闭结算
)

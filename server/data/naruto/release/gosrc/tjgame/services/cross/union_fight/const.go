/*
 * @Date    : 2021/9/9 22:37
 * @File    : const.go
 * @Version : 1.0.0
 * @Author  : hss
 * @Note    :
 *
 */

package union_fight

import (
	"errors"
	"time"
	"tjgame/server_framework/tj/util"
)

var (
	ErrStatus        = errors.New("status error")
	ErrUnionNotJoin  = errors.New("union not join error")
	ErrRoleNotJoin   = errors.New("role not join error")
	ErrBet           = errors.New("bet error")
	ErrNotInGroup    = errors.New("role not in group error")
	ErrProject       = errors.New("project error")
	ErrStage         = errors.New("stage error")
	ErrFightingPoint = errors.New("fightingPoint <= 0 error")
)

var EPSILON float64 = 1e-30

var (
	prePrepareTime = util.Time{Hour: 8, Minute: 50}  // 初赛准备
	preStartTime   = util.Time{Hour: 20, Minute: 50} // 初赛开始
	preBattleTime  = util.Time{Hour: 21, Minute: 0}  // 初赛进行
	preAwardTime   = util.Time{Hour: 21, Minute: 30} // 初赛结束

	topPrepareTime = util.Time{Hour: 9, Minute: 0}   // 决赛准备
	topStartTime   = util.Time{Hour: 20, Minute: 50} // 决赛开始
	topBattleTime  = util.Time{Hour: 21, Minute: 0}  // 决赛进行
	closeTime      = util.Time{Hour: 21, Minute: 30} // 结束

	TestInQuick = false
)

const (
	BattleAgentTimerDuration    = time.Second * 1 // 战斗反作弊 轮询时间
	BattleResultReceiveDuration = time.Second * 1 // 全部战斗结果 检测接收 Receive建议小于等于Check
	BattleResultCheckDuration   = time.Second * 1 // 每轮战斗结果 检测时间
)

const (
	// 战斗阶段
	PreStage = 1 // 初赛
	TopStage = 2 // 决赛

	TopGroup = 5 // 决赛特殊分组为5

	// 战场类型
	BattleSix  = 1 // 常规6v6
	BattleFour = 2 // 车轮4v4
	BattleOne  = 3 // 单挑1v1

	StatusStart      = "start"      // 周四 5:00 - 周五8:50
	StatusPrePrepare = "prePrepare" // 周五 8:50 - 20:50
	StatusPreStart   = "preStart"   // 周五 20:50 - 21:00
	StatusPreBattle  = "preBattle"  // 周五 21:00 - 战斗结束
	StatusPreOver    = "preOver"    // 周五 战斗结束 - 21:30
	StatusPreAward   = "preAward"   // 周五 21:30 - 周日 9:00

	StatusTopPrepare = "topPrepare" // 周日 9:00 - 20:50
	StatusTopStart   = "topStart"   // 周日 20:50 - 21:00
	StatusTopBattle  = "topBattle"  // 周日 21:00 - 战斗结束
	StatusTopOver    = "topOver"    // 周日 战斗结束 - 21:30
	StatusClosed     = "closed"     // 周日 21:30 - 下期
)

var StatusList = []string{
	StatusStart,
	StatusPrePrepare,
	StatusPreStart,
	StatusPreBattle,
	StatusPreOver,
	StatusPreAward,
	StatusTopPrepare,
	StatusTopStart,
	StatusTopBattle,
	StatusTopOver,
	StatusClosed,
	StatusStart,
}

var NextStatusPosMap = map[string]int{
	StatusStart:      1,
	StatusPrePrepare: 2,
	StatusPreStart:   3,
	StatusPreBattle:  4,
	StatusPreOver:    5,
	StatusPreAward:   6,

	StatusTopPrepare: 7,
	StatusTopStart:   8,
	StatusTopBattle:  9,
	StatusTopOver:    10,
	StatusClosed:     11,
}

var TroopNum = map[int]int{
	1: 2,
	2: 3,
	3: 3,
}

var BattleTypeTroopCardsNum = map[int]int{
	1: 6,
	2: 4,
	3: 3,
}

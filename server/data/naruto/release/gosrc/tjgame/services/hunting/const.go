package hunting

import (
	"errors"
	"time"
	"tjgame/server_framework/tj/util"
)

var (
	ErrRoute                 = errors.New("route error")
	ErrBattleTimes           = errors.New("battle times no enough")
	ErrStatus                = errors.New("status error")
	ErrNode                  = errors.New("node error")
	ErrBoardID               = errors.New("boardID error")
	ErrGateID                = errors.New("gateID error")
	ErrBoardBuffsEmpty       = errors.New("buffs is empty")
	ErrBoxLimit              = errors.New("box open is limit")
	ErrSupplyCard            = errors.New("supply card error")
	ErrNodeType              = errors.New("node type error")
	ErrStatusClosed          = errors.New("huntingClosed")
	ErrHuntingBattleNotFound = errors.New("HuntingBattleError")
	ErrHuntingCheat          = errors.New("cheatError")
)

var (
	resetTime = util.Time{Hour: 5, Minute: 0} // 重置

	TestInQuick = false
)

const (
	SupplyHp     = 1 // 治疗单体
	SupplyHpAll  = 2 // 治疗全体
	SupplyRevive = 3 // 复活单体

	BattleType = 1 // 战斗类型
	BoxType    = 2 // 宝箱类型
	SupplyType = 3 // 救援类型
	MultiType  = 4 // 组合类型

	BattleVerifyQueueSize   = 1024             // 战斗校验队列
	BattleVerifyTimeout     = time.Second * 5  // 战斗校验超时时间
	BattleWaitVerifyTimeout = time.Second * 3  // 等待战斗校验超时时间
	BanHours                = time.Minute * 30 // 作弊禁止时间

)

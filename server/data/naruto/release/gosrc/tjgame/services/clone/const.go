/*
 * @Time     : 2019/10/16 17:13
 * @Author   : cancan
 * @File     : const.go
 * @Function :
 */

package clone

import (
	"errors"
	"tjgame/server_framework/tj/util"
	"tjgame/services/game"
)

const (
	CloneRoomMemberMax    = 5
	ClonePlayMaxTimes     = 3
	CloneNotSelectMonster = -1
	CloneFinishLimit      = 3
	CloneRefreshTime      = 12
	CloneRobotPrfeix      = "clone_robot"
)

const (
	HistoryCreateRoom           = iota + 1 // 当房间被生成之后记录
	HistoryJoinRoom                        // 此处指玩家进行过挑战之后，无法自行退出房间时记录
	HistoryFinish                          // 当玩家完成3次挑战之后记录
	HistoryBeKicked                        // 当玩家被请出房间后记录（此处不论玩家是房客还是房主）
	HistoryVoteStart                       // 当房客发起投票时记录
	HistoryVoteFailByResult                // 因投票结果，房主不被踢出
	HistoryVoteFailByLeaderPlay            // 因房主完成一次战斗，房主不被踢出
)

// 以下变量会在 CsvInit 时重置
type Config struct {
	CloneRobotTime        int // 元素挑战机器人出现的时间限制(分钟)
	CloneRobotRefreshTime int // 元素挑战距离结束还有多久可以马上出现机器人(分钟)
	BattleFixSlice        []BattleFix
	AwardRandom           *util.WeightRandom
	RarityRandom          *util.WeightRandom
	NatureRobotMap        map[int]NatureRobot
	CLoneCanKickTime      int // 元素挑战可以被踢的时间
	CloneCanKickFinishNum int // 元素挑战房间完成多少个玩家才可以踢人
	CardMarkDevelopMap    map[[3]int]int
}

var (
	ErrNatureNotExists    = errors.New("ErrNatureNotExists")
	ErrCloneRoomNotExists = errors.New("cloneRoomOutDate")
	ErrCanNotQuit         = errors.New("ErrCanNotQuit")
	ErrRoomFull           = errors.New("cloenRoomFull")
	ErrHasNotBattle       = errors.New("ErrHasNotBattle")
	ErrAlreadyInRoom      = errors.New("cloneAlreadyInRoom")
	ErrNotInRoom          = errors.New("cloneNotInRoom")
	ErrTargetMonster      = errors.New("ErrTargetMonster")
	ErrRoomCardRefresh    = errors.New("cloneRoomCardRefresh")
	ErrRoomBattleFinished = errors.New("cloneRoomBattleFinished")
	ErrMonsterNotExists   = errors.New("ErrMonsterNotExists")
	ErrBattleNotExists    = errors.New("ErrBattleNotExists")
	ErrBattleHasEnd       = errors.New("ErrBattleHasEnd")
	ErrBattleNotWin       = errors.New("ErrBattleNotWin")
	ErrBoxBrawHaxMax      = errors.New("ErrBoxBrawHaxMax")
	ErrBattleNotEnd       = errors.New("ErrBattleNotEnd")
	ErrCanNotQuitRoom     = errors.New("cloneCanNotQuitRoom")
	ErrNeedLeader         = errors.New("cloneNeedLeader")
	ErrRoomOutDate        = errors.New("cloneRoomOutDate")
	ErrCanNotJoinRoom     = errors.New("cloneCanNotEnterRoom")
	ErrCloneCanNotKick    = errors.New("cloneCanNotKick")
	ErrCloneParamError    = errors.New("cloneParamError")
	ErrCloneHasVoteResult = errors.New("cloneHasVoteResult")
)

// 机器人固定修正六个基础属性
var RobotFixAttr = [...]string{
	game.CardAttrDefs[1],  // 生命
	game.CardAttrDefs[7],  // 物攻
	game.CardAttrDefs[8],  // 特攻
	game.CardAttrDefs[13], // 速度
	game.CardAttrDefs[9],  // 物防
	game.CardAttrDefs[10], // 特防
}

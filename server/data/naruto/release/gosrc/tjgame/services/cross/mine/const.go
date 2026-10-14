// @Time     : 2020/12/9 16:34
// @Author   : cancan
// @File     : const.go
// @Function :

package mine

import (
	"errors"
	"time"
	"tjgame/server_framework/tj/util"
)

// 玩法相关设定值
const (
	CrossMineDayDuration        = 3                // 跨服资源战持续几天
	TopBattleHistoryMax         = 10               // 精彩战报保存数量
	ProductionMineInterval      = time.Minute * 1  // 资源生产时间间隔
	RobTimeProtectLimit         = 60 * 60          // 抢夺时间间隔限制，一小时内五次有效
	ServerBuffLevelInit         = 0                // 全服 buff 初始等级
	RoleBuffLevelInit           = 0                // 角色 buff 初始等级
	RandomEnemiesSize           = 10               // 随机对手个数
	InBattleTime                = 60               // 对手战斗中时间（秒）
	BossBattleVerifyQueueSize   = 1024             // boss 战斗 chan 校验队列
	BossBattleVerifyTimeout     = time.Second * 5  // boss 战斗校验超时时间
	BossBattleWaitVerifyTimeout = time.Second * 3  // 等待 boss 战斗校验超时时间
	GetRemoteMineRecordTimeout  = time.Second * 15 // 获取角色 record 超时时间
	CrossMineBattleFlagRob      = "rob"            // 抢夺战斗 flag
	CrossMineBattleFlagRevenge  = "revenge"        // 复仇战斗 flag
)

// boss buff 类型
const (
	BossBuffTypeAttr    = iota + 1 // 击杀后基础属性加成
	BossBuffTypeProduct            // 击杀后生产加成
	BossBuffTypeRob                // 击杀后抢夺加成
)

// 事件类型
const (
	EventTypeBoss = iota + 1 // boss 事件类型
	EventTypeNpc             // npc 事件类型
)

// 玩法相关时间点
var (
	startTime   = util.Time{Hour: 10, Minute: 0} // 开始
	overTime    = util.Time{Hour: 22, Minute: 0} // 每天发奖时间
	startTimeEN = util.Time{Hour: 12, Minute: 0} // en开始时间
	overTimeEN  = util.Time{Hour: 23, Minute: 0} // en每天发奖时间
)

// Error
var (
	ErrParamFlag             = errors.New("cross mine param flag error")
	ErrRoundClosed           = errors.New("crossMineOver")
	ErrRoleNotFind           = errors.New("crossMineRoleNotFind")
	ErrBattleNotFind         = errors.New("crossMineBattleNotFind")
	ErrVsInfoNotFind         = errors.New("cross mine vs info not find")
	ErrVsInfoError           = errors.New("cross mine vs info error")
	ErrRankChanged           = errors.New("rankChanged")
	ErrRankEnemyChanged      = errors.New("rankEnemyChanged")
	ErrInBattle              = errors.New("rankEnemyBattling")
	ErrBossNotFind           = errors.New("crossMineBossNotFind")
	ErrBossHasKilled         = errors.New("crossMineBossHasKilled")
	ErrBossNotOpen           = errors.New("crossMineBossNotOpen")
	ErrCheat                 = errors.New("cheatError")
	ErrBossBattleMaxTime     = errors.New("crossMineBossBattleMaxTimeLimit")
	ErrBossBattleNotFind     = errors.New("crossMineBossBattleNotFind")
	ErrBeRevengedLimit       = errors.New("cross mine be reverged limit")
	ErrReqRanksFlag          = errors.New("cross mine req ranks flag error")
	ErrEnemyInRobProtect     = errors.New("crossMineRobBeProtect")
	ErrEnemyInRevengeProtect = errors.New("crossMineRevengeBeProtect")
	ErrPatchBehind           = errors.New("patchBehind")
)

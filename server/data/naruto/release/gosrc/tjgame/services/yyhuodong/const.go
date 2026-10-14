package yyhuodong

import "time"

const (
	WorldBossInitLevel = 100 // 设计 Boss 初始等级（第一次开活动）
	WorldBossRankSize  = 20  // 世界 Boss 排名显示个数

	BattleVerifyQueueSize   = 1024             // 勇者挑战战斗校验队列
	BattleVerifyTimeout     = time.Second * 5  // 战斗校验超时时间
	BattleWaitVerifyTimeout = time.Second * 3  // 等待战斗校验超时时间
	BanHours                = time.Minute * 30 // 作弊禁止时间
)

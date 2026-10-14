package yyhuodong

import (
	"tjgame/document"
	"tjgame/document/scheme"
)

type Config struct {
	WorldBossHP       map[int]int     // {huodongID: baseHP}
	WorldBossHPFix    map[int]float64 // {level: fix}
	WorldBossMinLevel int
	WorldBossMaxLevel int
}

// 赛马比赛过程信息
type HorseRaceInfo struct {
	Speed           int     // 初始速度
	Stamina         float64 // 初始体力
	StaminaCost     float64 // 每秒消耗体力
	StaminaRecovery float64 // 每秒恢复体力
	SprintRandom    int     // 冲刺概率
	SprintInterval  int     // 冲刺每0.1秒随机一次
	SprintMultiple  float64 // 冲刺影响的速度倍数
	SprintTime      int     // 冲刺维持的时长

	Distance          float64 // 已跑路程
	SprintSurplusTime int     // 冲刺剩余时长
	RealStamina       float64 // 实际体力
	RealSpeed         float64 // 实际速度
}

// 赛马main
type RespHorseRaceMain struct {
	// yyID
	YYID int `codec:"yyID"`
	// 当天比赛日期
	Date int `codec:"date"`
	// 当天比赛第几场
	Play int `codec:"play"`
	// 比赛选手 (只存当前场)
	RaceCards []*scheme.RaceCardInfo `codec:"race_cards"`
	// 历史记录 {date: {play: [HorseRaceHistoryCardInfo]}
	History map[document.Integer]map[document.Integer][]*scheme.HorseRaceHistoryCardInfo `codec:"history"`
	// 比赛状态 演算结束后为closed
	Round string `codec:"round"`
	// yy status
	Status string `codec:"status"`
}

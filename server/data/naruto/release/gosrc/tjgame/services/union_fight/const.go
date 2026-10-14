package union_fight

import (
	"time"
	"tjgame/services/game"
)

const (
	RankAllWeekdayNum             = 8                      // 排行榜总榜 weekday 常量
	PrepareDuration2345           = time.Second * 60 * 10  // 预选赛报名阶段的准备时间
	PrepareDuration6              = time.Second * 60       // 决赛报名阶段的准备时间
	BattleStartDuration2345       = time.Second * 60       // 预选赛战斗播放间隔
	Top8BattleStartDuration       = time.Second * 60 * 5   // 决赛中预备时间
	Top8BattleSEndDuration        = time.Second * 60 * 15  // 决赛中预备时间加战斗时间
	Battle2345AgentTimerDuration  = time.Second * 1        // 预选赛战斗反作弊检测时间
	Battle2345ResultCheckDuration = time.Second * 2        // 预选赛战斗结果检测时间
	Battle6AgentTimerDuration     = time.Millisecond * 500 // 决赛战斗反作弊检测时间
	Battle6ResultCheckDuration    = time.Second * 1        // 决赛战斗结果检测时间
	// test config
	//PrepareDuration2345           = time.Second * 10
	//PrepareDuration6              = time.Second * 30
	//BattleStartDuration2345       = time.Second * 60
	//Top8BattleStartDuration       = time.Second * 60 * 1
	//Top8BattleSEndDuration        = time.Second * 60 * 2
)

var EPSILON float64 = 1e-30

var RoundNextMap6 = map[string]roundItem{
	"signup":  {"prepare"},
	"prepare": {"8->4"},
	"8->4":    {"4->2"},
	"4->2":    {"2->1"},
	"2->1":    {"over"},
	"over":    {"closed"},
}

var Top8RoundKeyMap = map[string][][2]int{
	"8->4": {{1, 8}, {2, 7}, {3, 6}, {4, 5}},
	"4->2": {{27, 36}, {18, 45}},
	"2->1": {{1845, 2736}},
	//"2->1": {{1845, 2736}, {-1845, -2736}},
}

var Top8PlayEnemyMap = map[int]int{
	1:     8,
	8:     1,
	2:     7,
	7:     2,
	3:     6,
	6:     3,
	4:     5,
	5:     4,
	18:    45,
	45:    18,
	27:    36,
	36:    27,
	1845:  2736,
	2736:  1845,
	-1845: -2736,
	-2736: -1845,
}

var Top8PlayKeyMap = map[[2]int]string{
	{1, 8}: "group-a1", // group stage
	{2, 7}: "group-b1", // group stage
	{3, 6}: "group-b2", // group stage
	{4, 5}: "group-a2", // group stage

	{18, 45}: "group-a3", // semifinal
	{27, 36}: "group-b3", // semifinal

	//{-1845, -2736}: "third",    // 季军赛
	{1845, 2736}: "champion", // 冠军赛
}

var Top8PlayRoundMap = map[string][2]int{
	"group-a1": {1, 8}, // group stage
	"group-b1": {2, 7}, // group stage
	"group-b2": {3, 6}, // group stage
	"group-a2": {4, 5}, // group stage

	"group-a3": {18, 45}, // semifinal
	"group-b3": {27, 36}, // semifinal

	//"third":    {-1845, -2736}, // 季军赛
	"champion": {1845, 2736}, // 冠军赛
}

var WeeekTroopCardNum = map[int]int{
	2: 3,
	3: 3,
	4: 3,
	5: 3,
	6: 4,
}

// 战斗之星效果值
const BattleStarEffectNum = 10

// 战斗之星可生效属性
var BattleStarAttr = map[int]string{
	1:  game.CardAttrDefs[1],  // 生命
	7:  game.CardAttrDefs[7],  // 物攻
	8:  game.CardAttrDefs[8],  // 特攻
	9:  game.CardAttrDefs[9],  // 物防
	10: game.CardAttrDefs[10], // 特防
	13: game.CardAttrDefs[13], // 速度
}

var BattleStarAttrStrToInt = map[string]int{
	game.CardAttrDefs[1]:  1,  // 生命
	game.CardAttrDefs[7]:  7,  // 物攻
	game.CardAttrDefs[8]:  8,  // 特攻
	game.CardAttrDefs[9]:  9,  // 物防
	game.CardAttrDefs[10]: 10, // 特防
	game.CardAttrDefs[13]: 13, // 速度
}

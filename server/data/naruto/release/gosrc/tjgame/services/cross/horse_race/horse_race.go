package yyhuodong

import (
	"math/rand"
	"sort"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	tjutil "tjgame/server_framework/tj/util"
)

// 赛马
type HorseRaceGlobal struct {
	*scheme.HorseRaceGlobalObject
	container service.IContainer

	builder *Builder
	key     string

	// 状态定时器
	timer *time.Timer
}

func (h *HorseRaceGlobal) init(builder *Builder) {
	h.builder = builder
	h.key = h.Key()
}

func (h *HorseRaceGlobal) isOver() bool {
	if h.Status() == "closed" {
		return true
	}
	if h.CsvId() == 0 {
		return true
	}
	return false
}

func (h *HorseRaceGlobal) IsOver() bool {
	return h.isOver()
}

// 赛马活动 初始化
func (h *HorseRaceGlobal) OnInit(id int, servers []string) {
	log.Infof("CrossHorseRace.OnInit")

	tjutil.WithGuard(h, func() {
		ndt := tjutil.Todaydate2int()
		h.SetCsvId(id)
		h.SetCrossDate(ndt)
		h.SetDate(ndt)
		h.SetPlay(1)
		h.SetRaceCards([]*scheme.RaceCardInfo{})
		h.SetHistory(make(map[document.Integer]map[document.Integer][]*scheme.HorseRaceHistoryCardInfo))
		h.SetRound("closed")
		h.SetStatus("start")
	})
	// 初始化到缓存
	LoadHorseRaceConifg()

	// 比赛 立即准备
	h.onPrepare()

}

// 赛马活动 关闭
func (h *HorseRaceGlobal) OnClosed() {
	log.Infof("CrossHorseRace.OnClosed")

	tjutil.WithGuard(h, func() {
		ndt := tjutil.Todaydate2int()
		h.SetDate(ndt)
		h.SetPlay(1)
		h.SetRaceCards([]*scheme.RaceCardInfo{})
		h.SetHistory(make(map[document.Integer]map[document.Integer][]*scheme.HorseRaceHistoryCardInfo))
		h.SetRound("closed")
		h.SetCsvId(0)
		h.SetCrossDate(0)
		h.SetStatus("closed")
	})
}

// 赛马活动 清数据
func (h *HorseRaceGlobal) clean() {
	h.SetRaceCards([]*scheme.RaceCardInfo{})
	h.SetHistory(make(map[document.Integer]map[document.Integer][]*scheme.HorseRaceHistoryCardInfo))
	h.SetRound("closed")
	h.SetStatus("closed")
}

// 比赛准备 prepare
func (h *HorseRaceGlobal) onPrepare() {
	if h.isOver() {
		return
	}
	// 时间是否已经结束
	config := csv.GetConfig()
	cfg := config.Cross.Service[h.CsvId()]
	duration := closeTime.CombineDateInt(cfg.EndDate).Sub(tjutil.Now())
	if duration <= 0 {
		h.OnClosed()
		return
	}

	log.Infof("CrossHorseRace.onPrepare")

	tjutil.WithGuard(h, func() {
		if h.Round() == "closed" {
			// 随机比赛选手
			raceCards := h.randomRaceCards()
			h.SetRaceCards(raceCards)
			h.SetDate(tjutil.Todaydate2int())
			h.SetRound("prepare")
		}
	})

	h.nextStart()
}

// 赛马 下一场开始倒计时
func (h *HorseRaceGlobal) nextStart() {
	if h.isOver() {
		return
	}
	now := tjutil.Now()
	gameTime := csv.GetConfig().Cross.Horse_race.Base[1].Time.ToIntSlice()

	nowHour := tjutil.Now().Hour()
	play := 1
	duration := tjutil.Time{Hour: gameTime[1] - 1, Minute: 59, Second: 59}.Combine(now).Sub(now)
	if nowHour < gameTime[0] {
		play = 2
		duration = tjutil.Time{Hour: gameTime[3] - 1, Minute: 59, Second: 59}.Combine(now).AddDate(0, 0, -1).Sub(now)
	} else if gameTime[0] <= nowHour && nowHour < gameTime[2] {
		play = 1
		duration = tjutil.Time{Hour: gameTime[1] - 1, Minute: 59, Second: 59}.Combine(now).Sub(now)
	} else {
		play = 2
		duration = tjutil.Time{Hour: gameTime[3] - 1, Minute: 59, Second: 59}.Combine(now).Sub(now)
	}
	tjutil.WithGuard(h, func() {
		h.SetPlay(play)
	})

	if TestInQuick {
		duration = time.Second * 2
	}
	if TestInPrepare {
		return
	}

	log.Infof("CrossHorseRace.nextStart date %d play %d round %s next %s time delta %s", h.Date(), h.Play(), h.Round(), "start", duration)
	h.timer = time.AfterFunc(duration, h.onStart)
}

// 比赛开始 start
func (h *HorseRaceGlobal) onStart() {
	if h.isOver() {
		return
	}
	log.Infof("CrossHorseRace.onStart")

	tjutil.WithGuard(h, func() {
		if h.Round() == "prepare" {
			h.SetRound("start")
			// 计算比赛结果
			raceCards := h.doRaceResult(h.RaceCards())
			h.SetRaceCards(raceCards)
			h.addHistory()
			h.SetRound("closed")
		}
	})

	if !TestInQuick {
		h.nextPrepare()
	}
}

// 赛马 下一场准备倒计时
func (h *HorseRaceGlobal) nextPrepare() {
	if h.isOver() {
		return
	}
	now := tjutil.Now()
	gameTime := csv.GetConfig().Cross.Horse_race.Base[1].Time.ToIntSlice()

	nowHour := tjutil.Now().Hour()
	duration := tjutil.Time{Hour: gameTime[2], Minute: 0}.Combine(now).Sub(now)
	if nowHour < gameTime[0] {
		duration = tjutil.Time{Hour: gameTime[0], Minute: 0}.Combine(now).Sub(now)
	} else if gameTime[0] <= nowHour && nowHour < gameTime[2] {
		duration = tjutil.Time{Hour: gameTime[2], Minute: 0}.Combine(now).Sub(now)
	} else {
		duration = tjutil.Time{Hour: gameTime[0], Minute: 0}.Combine(now).AddDate(0, 0, 1).Sub(now)
	}

	log.Infof("CrossHorseRace.nextPrepare date %d play %d round %s next %s time delta %s", h.Date(), h.Play(), h.Round(), "prepare", duration)
	h.timer = time.AfterFunc(duration, h.onPrepare)
}

// 赛马服务重启
func (h *HorseRaceGlobal) ResetToday() {
	if h.isOver() {
		return
	}
	log.Infof("CrossHorseRace.ResetToday date %d play %d round %s", h.Date(), h.Play(), h.Round())
	LoadHorseRaceConifg()
	round := h.Round()
	if round == "prepare" {
		h.nextStart()
	} else if round == "start" {
		h.onStart()
	} else if round == "closed" {
		h.nextPrepare()
	}
}

// 随机比赛精灵
func (h *HorseRaceGlobal) randomRaceCards() []*scheme.RaceCardInfo {
	log.Infof("CrossHorseRace.randomRaceCards date %d play %d round %s", h.Date(), h.Play(), h.Round())
	raceCards := make([]*scheme.RaceCardInfo, 0)
	// 先随组
	cfg := GetHorseRaceConfig()
	group := cfg.HorseRaceCardGroup[rand.Intn(len(cfg.HorseRaceCardGroup))]
	// 根据权重 随4个选手
	cardGroupWeights := cfg.HorseRaceCardRandom
	cardWeights := cardGroupWeights[group]
	randCards := tjutil.OnceSimpleRandom(cardWeights, 4)
	for _, v := range randCards {
		raceCard := scheme.RaceCardInfo{
			CsvID: v.(tjutil.WeightInts)[0],
		}
		raceCards = append(raceCards, &raceCard)
	}

	return raceCards
}

// 计算比赛结果
func (h *HorseRaceGlobal) doRaceResult(raceCards []*scheme.RaceCardInfo) []*scheme.RaceCardInfo {
	log.Infof("CrossHorseRace.doRaceResult date %d play %d round %s", h.Date(), h.Play(), h.Round())

	distance := csv.GetConfig().Cross.Horse_race.Base[1].Distance
	cfgCards := csv.GetConfig().Cross.Horse_race.Horse_race_card
	sMultiple1 := csv.GetConfig().Cross.Horse_race.Base[1].SMultiple1
	sMultiple2 := csv.GetConfig().Cross.Horse_race.Base[1].SMultiple2

	cardsInfo := make(map[int]*HorseRaceInfo)
	// 初始化
	for i, cardObj := range raceCards {
		cardsInfo[i] = &HorseRaceInfo{
			Speed:           cfgCards[cardObj.CsvID].Speed,           // 速度
			Stamina:         cfgCards[cardObj.CsvID].Stamina,         // 体力
			StaminaCost:     cfgCards[cardObj.CsvID].StaminaCost,     // 每秒消耗体力
			StaminaRecovery: cfgCards[cardObj.CsvID].StaminaRecovery, // 每秒恢复体力
			SprintRandom:    cfgCards[cardObj.CsvID].SprintRandom,    // 冲刺概率
			SprintInterval:  cfgCards[cardObj.CsvID].SprintInterval,  // 冲刺每几秒随机一次
			SprintMultiple:  cfgCards[cardObj.CsvID].SprintMultiple,  // 冲刺影响的速度倍数
			SprintTime:      cfgCards[cardObj.CsvID].SprintTime,      // 冲刺维持的时长

			Distance:          0.0,                             // 已跑路程
			SprintSurplusTime: 0,                               // 冲刺剩余时长
			RealStamina:       cfgCards[cardObj.CsvID].Stamina, // 实际体力
		}
	}

	var finishTimes []float64
	// 随机种子 时间戳
	rand.Seed(time.Now().UnixNano())

	for i, cardInfo := range cardsInfo {
		isRecovery := false
		sprints := make([]bool, 50)
		for i := 0; i < cardInfo.SprintRandom/2 && i < len(sprints); i++ {
			sprints[i] = true
		}
		rand.Shuffle(len(sprints), func(i, j int) {
			sprints[i], sprints[j] = sprints[j], sprints[i]
		})

		// 单位0.1s
		sprintIndex := 0
		for s := 1; s <= 600; s++ {
			cardObj := raceCards[i]
			// 体力倍率
			staminaMultiple := 0.0
			if cardInfo.RealStamina == 0 {
				staminaMultiple = sMultiple1
			} else if cardInfo.RealStamina*2 < cardInfo.Stamina {
				staminaMultiple = sMultiple2
			}
			// 体力恢复（为0或恢复期间 恢复）
			if cardInfo.RealStamina == 0 || isRecovery {
				stamina := cardInfo.RealStamina + cardInfo.StaminaRecovery
				if stamina < cardInfo.Stamina {
					cardInfo.RealStamina = stamina
					isRecovery = true
				} else {
					cardInfo.RealStamina = cardInfo.Stamina
					isRecovery = false
				}
			}
			// 冲刺倍率
			//if true || cardInfo.SprintSurplusTime <= 0 {
			if s%cardInfo.SprintInterval == 0 {
				if sprints[sprintIndex%len(sprints)] {
					cardInfo.SprintSurplusTime = cardInfo.SprintTime
				}
				sprintIndex++
				if sprintIndex%len(sprints) == 0 {
					rand.Shuffle(len(sprints), func(i, j int) {
						sprints[i], sprints[j] = sprints[j], sprints[i]
					})
				}
				//log.Debugf("idx %d, SprintSurplusTime %d, %d", i, cardInfo.SprintSurplusTime, s)
			}
			//}
			rSprintMultiple := 0.0
			if cardInfo.SprintSurplusTime > 0 {
				rSprintMultiple = cardInfo.SprintMultiple
				cardInfo.SprintSurplusTime = cardInfo.SprintSurplusTime - 1
				cardObj.SprintTimeSlots = append(cardObj.SprintTimeSlots, s)
			}
			// 真实速度
			rSpeed := float64(cardInfo.Speed) / 10 * (1.0 + rSprintMultiple - staminaMultiple)

			if cardInfo.Distance+rSpeed >= distance {
				cardObj.Time = float64(s-1) + (distance-cardInfo.Distance)/rSpeed
				cardInfo.Distance = distance
				finishTimes = append(finishTimes, cardObj.Time)
				break
			}
			// 已跑路程
			cardInfo.Distance = cardInfo.Distance + rSpeed
			// 体力消耗（恢复期间不消耗）
			if !isRecovery {
				cardInfo.RealStamina = Max(cardInfo.RealStamina-cardInfo.StaminaCost, 0)
			}

			// 60s 没跑完
			if s == 600 {
				cardObj.Time = 600 + (distance-cardInfo.Distance)/1000.0
				finishTimes = append(finishTimes, cardObj.Time)
			}
		}

	}
	sort.Float64s(finishTimes)
	for i, t := range finishTimes {
		for j, cardObj := range raceCards {
			if cardObj.Result != 0 {
				continue
			}
			if t == cardObj.Time {
				raceCards[j].Result = i + 1
				break
			}
		}
	}

	return raceCards
}

// 添加到历史
func (h *HorseRaceGlobal) addHistory() {
	db := h.GetLockedDB()

	if len(db.RaceCards) > 0 {
		// 押注的玩家就不落history，放在Role下的ret_award。
		cardInfos := make([]*scheme.HorseRaceHistoryCardInfo, 0, 4)
		for _, cardObj := range db.RaceCards {
			cardInfo := scheme.HorseRaceHistoryCardInfo{
				CsvID:           cardObj.CsvID,
				Result:          cardObj.Result,
				SprintTimeSlots: cardObj.SprintTimeSlots,
				Time:            cardObj.Time,
			}
			cardInfos = append(cardInfos, &cardInfo)
		}
		if v, ok := db.History[document.Integer(db.Date)]; ok {
			v[document.Integer(db.Play)] = cardInfos
			db.History[document.Integer(db.Date)] = v
		} else {
			vv := map[document.Integer][]*scheme.HorseRaceHistoryCardInfo{document.Integer(db.Play): cardInfos}
			db.History[document.Integer(db.Date)] = vv
		}
		h.SetHistory(db.History)
	}
}

// 赛马比赛 押注
func (h *HorseRaceGlobal) betRaceCard(csvID int) int {
	db := h.GetLockedDB()

	result := -1
	for i, cardInfo := range db.RaceCards {
		if cardInfo.CsvID == csvID {
			result = i
		}
	}
	if result != -1 {
		db.RaceCards[result].BetCount = db.RaceCards[result].BetCount + 1
		h.SetRaceCards(db.RaceCards)
	}
	return result
}

// 赛马比赛 取消押注
func (h *HorseRaceGlobal) resetBetRaceCard(idx int) bool {
	db := h.GetLockedDB()
	if db.RaceCards[idx].BetCount <= 0 {
		return false
	}
	db.RaceCards[idx].BetCount = db.RaceCards[idx].BetCount - 1
	h.SetRaceCards(db.RaceCards)

	return true
}

// 测试 比赛结果
func (h *HorseRaceGlobal) testRaceResult(raceCards []*scheme.RaceCardInfo) []*scheme.RaceCardInfo {
	distance := csv.GetConfig().Cross.Horse_race.Base[1].Distance
	cfgCards := csv.GetConfig().Cross.Horse_race.Horse_race_card

	cardsInfo := make(map[int]*HorseRaceInfo)
	// 初始化
	for i, cardObj := range raceCards {
		cardsInfo[i] = &HorseRaceInfo{
			Speed:           cfgCards[cardObj.CsvID].Speed,           // 速度
			Stamina:         cfgCards[cardObj.CsvID].Stamina,         // 体力
			StaminaCost:     cfgCards[cardObj.CsvID].StaminaCost,     // 每秒消耗体力
			StaminaRecovery: cfgCards[cardObj.CsvID].StaminaRecovery, // 每秒恢复体力
			SprintRandom:    cfgCards[cardObj.CsvID].SprintRandom,    // 冲刺概率
			SprintInterval:  cfgCards[cardObj.CsvID].SprintInterval,  // 冲刺每几秒随机一次
			SprintMultiple:  cfgCards[cardObj.CsvID].SprintMultiple,  // 冲刺影响的速度倍数
			SprintTime:      cfgCards[cardObj.CsvID].SprintTime,      // 冲刺维持的时长

			Distance:          0.0,                             // 已跑路程
			SprintSurplusTime: 0,                               // 冲刺剩余时长
			RealStamina:       cfgCards[cardObj.CsvID].Stamina, // 实际体力
		}
	}

	var finishTimes []float64
	// 随机种子 时间戳
	rand.Seed(time.Now().UnixNano())

	for i, cardInfo := range cardsInfo {
		isRecovery := false
		for s := 1; s <= 60; s++ {
			cardObj := raceCards[i]
			// 体力倍率
			staminaMultiple := 0.0
			if cardInfo.RealStamina == 0 {
				staminaMultiple = 0.5
			} else if cardInfo.RealStamina*2 < cardInfo.Stamina {
				staminaMultiple = 0.25
			}
			// 体力恢复（为0或恢复期间 恢复）
			if cardInfo.RealStamina == 0 || isRecovery {
				stamina := cardInfo.RealStamina + cardInfo.StaminaRecovery
				if stamina < cardInfo.Stamina {
					cardInfo.RealStamina = stamina
					isRecovery = true
				} else {
					cardInfo.RealStamina = cardInfo.Stamina
					isRecovery = false
				}
			}
			// 冲刺倍率
			if s%cardInfo.SprintInterval == 0 {
				ret := rand.Intn(100-1) + 1 // [1,100]
				if cardInfo.SprintRandom >= ret {
					cardInfo.SprintSurplusTime = cardInfo.SprintTime
				}
			}
			rSprintMultiple := 0.0
			if cardInfo.SprintSurplusTime > 0 {
				rSprintMultiple = cardInfo.SprintMultiple
				cardInfo.SprintSurplusTime = cardInfo.SprintSurplusTime - 1
				cardObj.SprintTimeSlots = append(cardObj.SprintTimeSlots, s)
			}
			// 真实速度
			rSpeed := float64(cardInfo.Speed) * (1.0 + rSprintMultiple - staminaMultiple)

			if cardInfo.Distance+rSpeed >= distance {
				cardObj.Time = float64(s-1) + (distance-cardInfo.Distance)/rSpeed
				cardInfo.Distance = distance
				finishTimes = append(finishTimes, cardObj.Time)
				break
			}
			// 已跑路程
			cardInfo.Distance = cardInfo.Distance + rSpeed
			// 体力消耗（恢复期间不消耗）
			if !isRecovery {
				cardInfo.RealStamina = Max(cardInfo.RealStamina-cardInfo.StaminaCost, 0)
			}

			// 60s 没跑完
			if s == 60 {
				cardObj.Time = 60 + (distance-cardInfo.Distance)/100.0
				finishTimes = append(finishTimes, cardObj.Time)
			}
		}

	}
	sort.Float64s(finishTimes)
	for i, t := range finishTimes {
		for j, cardObj := range raceCards {
			if cardObj.Result != 0 {
				continue
			}
			if t == cardObj.Time {
				raceCards[j].Result = i + 1
				break
			}
		}
	}

	return raceCards
}

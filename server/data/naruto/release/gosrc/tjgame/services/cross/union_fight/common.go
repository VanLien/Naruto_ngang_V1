/*
 * @Date    : 2021/9/9 22:38
 * @File    : common.go
 * @Version : 1.0.0
 * @Author  : hss
 * @Note    :
 *
 */

package union_fight

import (
	"sort"
	"strings"
	"sync/atomic"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
)

var config atomic.Value

func GetConfig() *Config {
	return config.Load().(*Config)
}

func LoadConfig() error {
	cfg := csv.GetConfig()
	v := &Config{
		WinPointMap:   map[int]int{},
		FailPointMap:  map[int]int{},
		ExtraPointMap: map[int]int{},
	}

	for id, item := range cfg.Cross.Union_fight.Play_point {
		v.WinPointMap[id] = item.WinPoint
		v.FailPointMap[id] = item.FailPoint
		v.ExtraPointMap[id] = item.ExtraPoint
	}

	config.Store(v)
	return nil
}

// 是否存在于数组中
func InArrayInt(target int, array []int) bool {
	for _, element := range array {
		if target == element {
			return true
		}
	}
	return false
}

func InArrayDbID(target document.ID, array []document.ID) bool {
	for _, element := range array {
		if target == element {
			return true
		}
	}
	return false
}

func isInOver(status string) bool {
	return strings.HasSuffix(status, "Over")
}

func isInBattle(status string) bool {
	return strings.HasSuffix(status, "Battle")
}

func isInPre(status string) bool {
	return strings.HasPrefix(status, "pre")
}

func isInTop(status string) bool {
	return strings.HasPrefix(status, "top")
}

func isTroopOut(troopCardState map[document.ID][2]float64) bool {
	if len(troopCardState) == 0 {
		return false
	}
	outCardNum := 0
	for _, state := range troopCardState {
		hp := state[0]
		if hp <= 0 {
			outCardNum += 1
		}
	}
	return outCardNum == len(troopCardState)
}

func float64IsEqual(a, b float64) bool {
	return (a-b) < EPSILON && (b-a) < EPSILON
}

func calcHpPercent(data map[document.ID][2]float64) (float64, float64) {
	num := 0
	sum := 0.0
	for _, item := range data {
		num++
		sum += item[0]
	}

	return sum, sum / float64(num)
}

func makeInitCardState(cardIDs []document.ID) map[document.ID][2]float64 {
	cardState := make(map[document.ID][2]float64)
	for _, cardID := range cardIDs {
		if cardID != "" {
			cardState[cardID] = [2]float64{1.0, 0}
		}
	}
	return cardState
}

func makeDieCardState(cardIDs []document.ID) map[document.ID][2]float64 {
	cardState := make(map[document.ID][2]float64)
	for _, cardID := range cardIDs {
		if cardID != "" {
			cardState[cardID] = [2]float64{0, 0}
		}
	}
	return cardState
}

func makeCardState(playRecord *CrossUnionFightPlayRecord) map[document.ID][2]float64 {
	cardIDs := playRecord.Cards()
	defenceCardIDs := playRecord.DefenceCards()
	cardStates1 := playRecord.CardStates()

	cardState := make(map[document.ID][2]float64)
	for _, cardID := range cardIDs {
		if cardID != "" {
			if states, ok := cardStates1[cardID]; ok {
				cardState[cardID] = states
			} else {
				cardState[cardID] = [2]float64{1.0, 0}
			}
		}
	}
	for _, dCardID := range defenceCardIDs {
		if dCardID != "" {
			cardState[dCardID] = [2]float64{0, 0}
		}
	}
	return cardState
}

func makePlayRecordCards(allCardIDs []document.ID, battleType, troop int, cardStates map[document.ID][2]float64) []document.ID {
	cardIDs := []document.ID{}
	if battleType == BattleSix {
		// 常规
		newAllCardIDs := fixCards(allCardIDs, 12)
		if troop == 1 {
			cardIDs = newAllCardIDs[:6]
		} else {
			cardIDs = newAllCardIDs[6:12]
		}
	} else if battleType == BattleFour {
		// 车轮
		newAllCardIDs := fixCards(allCardIDs, 18)
		if troop == 1 {
			cardIDs = newAllCardIDs[:6]
		} else if troop == 2 {
			cardIDs = newAllCardIDs[6:12]
		} else {
			cardIDs = newAllCardIDs[12:18]
		}
	} else {
		// 单挑
		newAllCardIDs := fixCards(allCardIDs, 9)
		if troop == 1 {
			cardIDs = newAllCardIDs[:3]
		} else if troop == 2 {
			cardIDs = newAllCardIDs[3:6]
		} else {
			cardIDs = newAllCardIDs[6:9]
		}
	}
	// 死亡卡牌下掉
	newCardIDs := []document.ID{}
	for _, cardID := range cardIDs {
		if cardID != "" {
			if states, ok := cardStates[cardID]; ok {
				if !float64IsEqual(states[0], 0) {
					newCardIDs = append(newCardIDs, cardID)
				}
			} else {
				newCardIDs = append(newCardIDs, cardID)
			}
		}
	}
	return newCardIDs
}

func fixCards(allCardIDs []document.ID, num int) []document.ID {
	cardIDs := make([]document.ID, 0, num)
	if len(allCardIDs) < num {
		cardIDs = append(cardIDs, allCardIDs...)
		for i := 0; i < num-len(allCardIDs); i++ {
			cardIDs = append(cardIDs, "")
		}
	} else {
		cardIDs = allCardIDs[:num]
	}
	return cardIDs
}

func makeRoleFightingPoint(cardIDs []document.ID, cardAttrs map[document.ID]*scheme.CardBattleModel) int {
	allFp := 0
	for _, cardID := range cardIDs {
		if cardID != "" {
			if attr, ok := cardAttrs[cardID]; ok {
				allFp += attr.FightingPoint
			}
		}
	}
	return allFp
}

func getDisplayCard(cardAttrs map[document.ID]*scheme.CardBattleModel) int {
	maxCardID := 1 // 默认值给1
	maxFp := 0
	for _, attr := range cardAttrs {
		if attr.FightingPoint > maxFp {
			maxFp = attr.FightingPoint
			maxCardID = attr.CardId
		}
	}
	return maxCardID
}

func getBattleCardState(cards []document.ID, cardState, resultStates map[document.ID][2]float64, battleType int) map[document.ID][2]float64 {
	cardStateTmp := make(map[document.ID][2]float64)

	if len(cards) > BattleTypeTroopCardsNum[battleType] { // 异常情况
		resultCards := []document.ID{}
		for cardID := range resultStates {
			resultCards = append(resultCards, cardID)
		}
		cards = resultCards
	}
	for _, cardID := range cards {
		if cardID != "" {
			if state, ok := resultStates[cardID]; ok { // 上场的覆盖  结果返回
				cardStateTmp[cardID] = state
			} else {
				if state, ok := cardState[cardID]; ok { // 没上场的继承 战报记录
					cardStateTmp[cardID] = state
				} else {
					cardStateTmp[cardID] = [2]float64{1.0, 0}
				}
			}
		}
	}
	return cardStateTmp
}

func MaxInt(a, b int) int {
	if a > b {
		return a
	}
	return b
}

// 根据积分排名
func makeJoinRanks(rankInfos []*scheme.UnionFightPointRankInfo) []*scheme.UnionFightPointRankInfo {
	if len(rankInfos) == 0 {
		return rankInfos
	}

	sort.Slice(rankInfos, func(i, j int) bool {
		return rankInfos[i].Point > rankInfos[j].Point
	})
	return rankInfos
}

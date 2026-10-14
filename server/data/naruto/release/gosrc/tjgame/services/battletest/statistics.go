package battletest

import (
	"fmt"
	"sync/atomic"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
)

type statistics struct {
	win   int64
	fail  int64
	error int64

	cardRecords map[int]*cardRecordItem
}

type cardRecordItem struct {
	Win  int `codec:"win"`
	Fail int `codec:"fail"`
}

type ModelCardInfo struct {
	// 主动进攻部署卡牌列表
	Cards []document.ID `bson:"cards" codec:"cards"`
	// 主动进攻卡牌离线属性
	CardAttrs map[document.ID]*scheme.CardBattleModel `bson:"card_attrs" codec:"card_attrs"`
	// 被动防御部署卡牌列表
	DefenceCards []document.ID `bson:"defence_cards" codec:"defence_cards"`
	// 被动防御卡牌离线属性
	DefenceCardAttrs map[document.ID]*scheme.CardBattleModel `bson:"defence_card_attrs" codec:"defence_card_attrs"`
}

func (s *statistics) reset() {
	atomic.StoreInt64(&s.win, 0)
	atomic.StoreInt64(&s.fail, 0)
	atomic.StoreInt64(&s.error, 0)
}

func (s *statistics) recordResult(result string, model []byte) {
	switch result {
	case "win":
		atomic.AddInt64(&s.win, 1)
	case "fail":
		atomic.AddInt64(&s.fail, 1)
	case "error":
		atomic.AddInt64(&s.error, 1)
	default:
		log.Warningf("unsupport result %s", result)
	}

	var data ModelCardInfo
	err := util.MsgUnpack(model, &data)
	if err != nil {
		panic(err)
	}

	for _, cardDBID := range data.Cards {
		if cardDBID == "" {
			continue
		}
		s.recordCardResult(data.CardAttrs[cardDBID].CardId, result, false)
	}

	for _, cardDBID := range data.DefenceCards {
		if cardDBID == "" {
			continue
		}
		s.recordCardResult(data.DefenceCardAttrs[cardDBID].CardId, result, true)
	}
}

func (s *statistics) recordCardResult(cardID int, result string, isDefence bool) {
	info, ok := s.cardRecords[cardID]
	if !ok {
		info = &cardRecordItem{}
		s.cardRecords[cardID] = info
	}
	switch result {
	case "win":
		if !isDefence {
			info.Win++
		} else {
			info.Fail++
		}
	case "fail":
		if !isDefence {
			info.Fail++
		} else {
			info.Win++
		}
	}
}

func (s *statistics) String() string {
	win := atomic.LoadInt64(&s.win)
	fail := atomic.LoadInt64(&s.fail)
	err := atomic.LoadInt64(&s.error)
	return fmt.Sprintf("statistics win %d fail %d error %d", win, fail, err)
}

func (s *statistics) Report() map[string]int64 {
	win := atomic.LoadInt64(&s.win)
	fail := atomic.LoadInt64(&s.fail)
	err := atomic.LoadInt64(&s.error)
	return map[string]int64{
		"win":   win,
		"fail":  fail,
		"error": err,
	}
}

func (s *statistics) ReportCardRecord() map[int]cardRecordItem {
	ret := make(map[int]cardRecordItem)
	for cardID, info := range s.cardRecords {
		ret[cardID] = *info
	}

	return ret
}

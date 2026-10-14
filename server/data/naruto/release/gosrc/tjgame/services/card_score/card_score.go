package card_score

import (
	"errors"
	"sort"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
)

type CardScoreGlobal struct {
	*scheme.CardScoreGlobalObject

	ranks []scheme.CardScoreInfo
}

const (
	InitScore   = 10.0 // 初始积分
	updScoreNum = 10   // 多少评分后更新初始评分
)

var (
	ErrCardNotFind = errors.New("cardID not find")
)

func (g *CardScoreGlobal) init() {
	db, unlock := g.LockAndGetDB()
	defer unlock()

	cfg := csv.GetConfig()

	// 新增的 markID 设置 last_rank 和 last_score
	updLastByFirst := make(map[document.Integer]bool)

	// 可能配表变动，关闭了部分卡，初始化时检测一遍
	openMarkIDs := map[int]bool{}
	for idx := range cfg.Pokedex {
		if !tj.IsLanguageOpen(cfg.Pokedex[idx].Languages.ToStringSlice()) {
			continue
		}

		if !cfg.Pokedex[idx].IsOpen {
			continue
		}
		cardCfg := cfg.Cards[idx]
		markID := cardCfg.CardMarkID
		openMarkIDs[markID] = true
	}
	delMarkIDs := []int{}
	for markID := range db.Cards {
		if _, ok := openMarkIDs[int(markID)]; !ok {
			delMarkIDs = append(delMarkIDs, int(markID))
		}
	}
	for _, markID := range delMarkIDs {
		delete(db.Cards, document.Integer(markID))
	}

	// 初始化数据
	for idx := range cfg.Pokedex {
		if !tj.IsLanguageOpen(cfg.Pokedex[idx].Languages.ToStringSlice()) {
			continue
		}

		if !cfg.Pokedex[idx].IsOpen {
			continue
		}
		cardCfg := cfg.Cards[idx]
		markID := cardCfg.CardMarkID
		if _, ok := db.Cards[document.Integer(markID)]; ok {
			continue
		}
		rarity := cfg.Unit[cardCfg.UnitID].Rarity
		db.Cards[document.Integer(markID)] = &scheme.CardScoreInfo{
			MarkID:    markID,
			Rarity:    rarity,
			Rank:      0,         // 排序后初始化
			Score:     InitScore, // 初始积分 10 分
			ScoreSum:  0,         // 初始积分总和 10 分
			ScoreNum:  0,         // 防止第一次计算时出错
			LastRank:  0,         // 排序后初始化
			LastScore: 0,         // 和初始化一致，显示上排名无排名无变化
		}
		updLastByFirst[document.Integer(markID)] = true
	}
	g.SetCards(db.Cards)

	g.resortRank()

	for markID := range updLastByFirst {
		db.Cards[markID].LastScore = db.Cards[markID].Score
		db.Cards[markID].LastRank = db.Cards[markID].Rank
	}
}

func (g *CardScoreGlobal) resortRank() {
	db := g.GetLockedDB()

	ranks := &ranks{
		items: make([]rankItem, 0, len(db.Cards)),
	}
	for k, v := range db.Cards {
		ranks.items = append(ranks.items, rankItem{
			id: k,
			items: map[string]int{
				"score":  int(v.Score * 10), // 确认区小数点几位
				"markID": v.MarkID,
				"rarity": v.Rarity,
			},
		})
	}

	ranks.keys = [][]string{{"score", "desc"}, {"rarity", "desc"}, {"markID", "asc"}}
	sort.Sort(ranks)
	newRanks := make([]scheme.CardScoreInfo, 0, len(db.Cards))
	nowDate := util.Todaydate2int()
	updateLastRank := db.LastDate == 0 || db.LastDate != nowDate
	if updateLastRank {
		log.Infof("CardScoreGlobal updateLastRank nowDate %v", nowDate)
	}

	for idx, item := range ranks.items {
		rank := idx + 1
		if updateLastRank {
			db.Cards[item.id].LastScore = db.Cards[item.id].Score
			db.Cards[item.id].LastRank = db.Cards[item.id].Rank
		}
		db.Cards[item.id].Rank = rank

		newRanks = append(newRanks, *db.Cards[item.id])
	}

	g.SetCards(db.Cards)
	g.SetLastDate(nowDate)

	g.ranks = newRanks
}

func (g *CardScoreGlobal) updateScore(markID, old, new int) error {
	db, unlock := g.LockAndGetDB()
	defer unlock()

	key := document.Integer(markID)
	if _, ok := db.Cards[key]; !ok {
		return ErrCardNotFind
	}

	db.Cards[key].ScoreSum = db.Cards[key].ScoreSum - old + new
	if old == 0 {
		db.Cards[key].ScoreNum++
	}
	if db.Cards[key].ScoreNum >= updScoreNum {
		db.Cards[key].Score = float64(db.Cards[key].ScoreSum) / float64(db.Cards[key].ScoreNum)
	}

	g.SetCards(db.Cards)

	g.resortRank()

	return nil
}

func (g *CardScoreGlobal) getScoreAndLastScore(markID int) (float64, float64, error) {
	db, unlock := g.RLockAndGetDB()
	defer unlock()

	key := document.Integer(markID)
	if _, ok := db.Cards[key]; !ok {
		return 0, 0, ErrCardNotFind
	}

	return db.Cards[key].Score, db.Cards[key].LastScore, nil
}

func (g *CardScoreGlobal) getRank(offset, size int) []scheme.CardScoreInfo {
	g.RLock()
	defer g.RUnlock()

	ret := make([]scheme.CardScoreInfo, 0, size)
	end := offset + size
	rankMax := len(g.ranks)
	if end >= rankMax {
		end = rankMax
	}
	for i := offset; i < end; i++ {
		ret = append(ret, g.ranks[i])
	}

	return ret
}

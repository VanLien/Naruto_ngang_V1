package card_fight

import (
	"sort"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj"
	"tjgame/server_framework/tj/log"
)

const (
	CardFightRankMax      = 100              // 最大排名
	CardFightRankMaxGuard = CardFightRankMax // 前一百卡牌消耗踢出排名时的补位保护数据
	CardFightRankSaveMax  = CardFightRankMax + CardFightRankMaxGuard

	robotCardCreateTime = 1575421700.0 + 10 // 机器人创建时间 datetime.datetime(2019, 12, 4, 9, 8, 21)，外加 10s 的浮点判断误差
)

type CardFightGlobal struct {
	*scheme.CardFightGlobalObject
	builder *Builder

	ranks map[document.Integer][]scheme.CardFightRankItem
}

func (g *CardFightGlobal) init(b *Builder) {
	g.builder = b
	if !g.HasInitData() {
		g.initData()
	}

	db, unlock := g.LockAndGetDB()
	defer unlock()

	g.ranks = make(map[document.Integer][]scheme.CardFightRankItem)

	markIDs := make([]document.Integer, 0, len(db.Cards))
	for markID := range db.Cards {
		markIDs = append(markIDs, markID)
	}

	for _, markID := range markIDs {
		g.resortRank(markID)
	}

	g.SetCards(db.Cards)
}

func (g *CardFightGlobal) initData() {
	log.Info("CardFightGlobal initData start")
	cfg := csv.GetConfig()
	markIDCardIDs := make(map[int][]int)
	for idx := range cfg.Pokedex {
		if !tj.IsLanguageOpen(cfg.Pokedex[idx].Languages.ToStringSlice()) {
			continue
		}

		if !cfg.Pokedex[idx].IsOpen {
			continue
		}
		markID := cfg.Cards[idx].CardMarkID
		markIDCardIDs[markID] = append(markIDCardIDs[markID], idx)
	}

	initData := make(map[document.Integer]map[document.ID]*scheme.CardFightRankItem)
	for markID, cardIDs := range markIDCardIDs {
		cardDBs := g.builder.getCardFightTop200Cards(cardIDs)
		roleCard := make(map[document.ID]*scheme.CardFightRankItem)
		roleIDs := []document.ID{}
		for _, item := range cardDBs {
			// 过滤机器人
			if item.CreatedTime <= robotCardCreateTime {
				continue
			}
			// 已经记录最大战力卡
			if _, ok := roleCard[item.RoleID]; ok {
				continue
			}

			roleCard[item.RoleID] = &scheme.CardFightRankItem{
				Card: scheme.CardFightRankItemCard{
					ID:            item.ID,
					CardID:        item.CardId,
					Level:         item.Level,
					Star:          item.Star,
					Advance:       item.Advance,
					FightingPoint: item.FightingPoint,
					SkinId:        item.SkinId,
				},
			}
			roleIDs = append(roleIDs, item.RoleID)
		}
		roleDBs := g.builder.getCardFightTop200Roles(roleIDs)
		for _, item := range roleDBs {
			vip := item.VipLevel
			if item.VipHide {
				vip = 0
			}
			roleCard[item.ID].Role = scheme.CardFightRankItemRole{
				ID:     item.ID,
				Name:   item.Name,
				Logo:   item.Logo,
				Frame:  item.Frame,
				Title:  item.Title,
				Level:  item.Level,
				Figure: item.Figure,
				Vip:    vip,
			}
		}

		initData[document.Integer(markID)] = roleCard
	}

	g.Lock()
	g.SetCards(initData)
	g.SetHasInitData(true)
	g.Unlock()
	log.Info("CardFightGlobal initData end")
}

func (g *CardFightGlobal) resortRank(markID document.Integer) {
	db := g.GetLockedDB()

	if _, ok := db.Cards[markID]; !ok {
		return
	}

	ranks := &ranks{
		items: make([]rankItem, 0, len(db.Cards[markID])),
	}
	for roleID, item := range db.Cards[markID] {
		ranks.items = append(ranks.items, rankItem{
			id: roleID,
			items: map[string]int{
				"fp": item.Card.FightingPoint,
			},
		})
	}

	ranks.keys = [][]string{{"fp", "desc"}}
	sort.Sort(ranks)
	newRanks := make([]scheme.CardFightRankItem, 0, len(db.Cards[markID]))

	for idx, item := range ranks.items {
		rank := idx + 1
		db.Cards[markID][item.id].Rank = rank
		newRanks = append(newRanks, *db.Cards[markID][item.id])
	}

	// 清楚多余排名数据
	if len(newRanks) > CardFightRankSaveMax {
		for _, item := range newRanks[CardFightRankSaveMax:] {
			delete(db.Cards[markID], item.Role.ID)
		}
	}

	if len(newRanks) > CardFightRankMax {
		newRanks = newRanks[:CardFightRankMax]
	}

	g.SetCards(db.Cards)
	g.ranks[markID] = newRanks
}

func (g *CardFightGlobal) getRank(role scheme.CardFightRankItemRole, markID document.Integer, offset, size int) RespCardFightRank {
	db, unlock := g.LockAndGetDB()
	defer unlock()

	ret := RespCardFightRank{
		Ranks: make([]scheme.CardFightRankItem, 0, size),
	}

	if _, ok := g.ranks[markID]; !ok {
		return ret
	}

	end := offset + size
	rankMax := len(g.ranks[markID])
	if end >= rankMax {
		end = rankMax
	}
	for i := offset; i < end; i++ {
		item := g.ranks[markID][i]
		if item.Role.ID == role.ID {
			item.Role = role
		}
		ret.Ranks = append(ret.Ranks, item)
	}

	if _, ok := db.Cards[markID]; !ok {
		return ret
	}

	if roleInfo, ok := db.Cards[markID][role.ID]; ok {
		db.Cards[markID][role.ID].Role = role
		g.SetCards(db.Cards)

		// 大于最大排名不显示
		if roleInfo.Rank <= CardFightRankMax {
			ret.Rank = roleInfo.Rank
		}
	}

	return ret
}

func (g *CardFightGlobal) updateCardFight(role scheme.CardFightRankItemRole, cards map[document.Integer]scheme.CardFightRankItemCard) {
	db, unlock := g.LockAndGetDB()
	defer unlock()

	for markID, card := range cards {
		if _, ok := db.Cards[markID]; !ok {
			db.Cards[markID] = make(map[document.ID]*scheme.CardFightRankItem)
		}

		// 对应的 MarkID 卡牌消耗完了需要清楚排名
		if card.ID == "" {
			delete(db.Cards[markID], role.ID)
		} else {
			if _, ok := db.Cards[markID][role.ID]; !ok {
				db.Cards[markID][role.ID] = &scheme.CardFightRankItem{}
			}
			db.Cards[markID][role.ID].Role = role
			db.Cards[markID][role.ID].Card = card
		}
		g.SetCards(db.Cards)
		g.resortRank(markID)
	}

}

func (g *CardFightGlobal) getInRankCards(roleID document.ID, cards map[document.Integer]scheme.CardFightRankItemCard) map[document.ID]int {
	db, unlock := g.LockAndGetDB()
	defer unlock()

	ret := make(map[document.ID]int)

	for markID, card := range cards {
		if _, ok := db.Cards[markID]; !ok {
			continue
		}
		if _, ok := db.Cards[markID][roleID]; !ok {
			continue
		}
		if db.Cards[markID][roleID].Rank <= CardFightRankMax {
			ret[card.ID] = db.Cards[markID][roleID].Rank
		}
	}

	return ret
}

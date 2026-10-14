package schemeutil

import (
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
)

func CalcCardFightingPoint(cards []document.ID, cardattrs map[document.ID]*scheme.CardBattleModel) int {
	fightingPoint := 0
	for _, id := range cards {
		if id != "" {
			if model, ok := cardattrs[id]; ok {
				fightingPoint += model.FightingPoint
			} else {
				log.Warningf("card %s not find card attr", id)
			}
		}
	}
	return fightingPoint
}

func UpdateCardAttrs(old map[document.ID]*scheme.CardBattleModel, new map[document.ID]*scheme.CardBattleModel, cards ...[]document.ID) map[document.ID]*scheme.CardBattleModel {
	valid := make(map[document.ID]bool, len(old))
	for _, v := range cards {
		for _, id := range v {
			if id != "" {
				valid[id] = true
			}
		}
	}
	if len(valid) == 0 {
		panic("no valid cards")
	}

	cardattrs := make(map[document.ID]*scheme.CardBattleModel, len(old))
	for id, attrs := range old {
		if valid[id] {
			cardattrs[id] = attrs
		}
	}
	for id, attrs := range new {
		if valid[id] {
			cardattrs[id] = attrs
		}
	}

	return cardattrs
}

func CompareCardsSetEqual(cards1 []document.ID, cards2 []document.ID) bool {
	existed := make(map[document.ID]bool, len(cards1))
	for _, card := range cards1 {
		if card != "" {
			existed[card] = true
		} else {
			existed[""] = true
		}
	}
	for _, card := range cards2 {
		if card != "" {
			if !existed[card] {
				return false
			}
		} else {
			if !existed[""] {
				return false
			}
		}
	}
	return true
}

func CopyCardAttrs(cardattrs map[document.ID]*scheme.CardBattleModel) map[document.ID]*scheme.CardBattleModel {
	ret := make(map[document.ID]*scheme.CardBattleModel)
	for k, v := range cardattrs {
		attrs := *v
		attrs.Skills = CopySkills(v.Skills)
		attrs.PassiveSkills = CopySkills(v.PassiveSkills)
		attrs.Attrs = CopyAttrs(v.Attrs)
		attrs.Attrs2 = CopyAttrs(v.Attrs2)
		ret[k] = &attrs
	}
	return ret
}

func CopySkills(skills map[document.Integer]int) map[document.Integer]int {
	ret := make(map[document.Integer]int, len(skills))
	for k, v := range skills {
		ret[k] = v
	}
	return ret
}

func CopyAttrs(attrs map[string]float64) map[string]float64 {
	ret := make(map[string]float64, len(attrs))
	for k, v := range attrs {
		ret[k] = v
	}
	return ret
}

func CopyCards(cards []document.ID) []document.ID {
	ret := make([]document.ID, len(cards))
	copy(ret, cards)
	return ret
}

func FilterEmptyCards(cards []document.ID, cardAttrs map[document.ID]*scheme.CardBattleModel) ([]scheme.CardTuple, int) {
	v := make([]scheme.CardTuple, 0, len(cards))
	fightingPoint := 0
	for _, cardID := range cards {
		if cardID != "" {
			attrs := cardAttrs[cardID]
			if attrs == nil {
				continue
			}
			v = append(v, scheme.CardTuple{
				ID:     cardID,
				CardID: attrs.CardId,
				SkinID: attrs.SkinId,
			})
			fightingPoint += attrs.FightingPoint
		}
	}
	return v, fightingPoint
}

func CalcBattleCards(cardAttrs map[document.ID]*scheme.CardBattleModel, cards []document.ID) []int {
	v := make([]int, 0, len(cards))
	for _, id := range cards {
		if id != "" {
			if card, ok := cardAttrs[id]; ok {
				v = append(v, card.CardId)
			}
		}
	}
	return v
}

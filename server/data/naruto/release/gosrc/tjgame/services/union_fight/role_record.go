package union_fight

import (
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
)

// UnionFightRecord
type RoleRecord struct {
	*scheme.UnionFightRoleRecordObject
}

func (r *RoleRecord) updateRole(role roleCompetitor) {
	db, unlock := r.LockAndGetDB()
	defer unlock()

	db.RoleName = role.Name
	db.RoleLogo = role.Logo
	db.RoleFrame = role.Frame
	db.RoleLevel = role.Level
	db.RoleFigure = role.Figure
	r.SetDirty("role_name", "role_logo", "role_frame", "role_level", "role_figure")
}

func (r *RoleRecord) deployCards(deploy deployment) {
	r.Lock()
	defer r.Unlock()
	oldCards := r.HoldCards()
	oldCardAttrs := r.HoldCardAttrs()

	for week, troops := range deploy.Cards {
		for troopIdx, cs := range troops {
			oldCards[week][troopIdx] = cs
		}
	}

	for cardID, attr := range deploy.CardAttrs {
		oldCardAttrs[cardID] = attr
	}
	oldCardAttrs2 := r.HoldCardAttrs2()
	for cardID, attr := range deploy.CardAttrs2 {
		oldCardAttrs2[cardID] = attr
	}

	r.SetHoldCards(oldCards)
	r.SetHoldCardAttrs(oldCardAttrs)
	r.SetHoldCardAttrs2(oldCardAttrs2)
	r.SetPassiveSkills(deploy.PassiveSkills)
}

func (r *RoleRecord) getCards(nowWeekday int, round string) DeployCards {
	r.RLock()
	defer r.RUnlock()

	ret := make(DeployCards)

	cardAttrs := r.CardAttrs()
	cards := r.Cards()
	holdCards := r.HoldCards()
	holdCardAttrs := r.HoldCardAttrs()
	for weekday, troops := range holdCards {
		//for weekday, troops := range cards {
		ret[weekday] = make(map[document.Integer][6]*DeployCardInfo)
		attrs := holdCardAttrs
		if int(weekday) < nowWeekday || (int(weekday) == nowWeekday && round != "signup") {
			if _, ok := cards[weekday]; !ok {
				for troopIdx := range troops {
					ret[weekday][troopIdx] = [6]*DeployCardInfo{}
				}
				continue
			}
			troops = cards[weekday]
			attrs = cardAttrs
		}
		for troopsIdx, cardIDs := range troops {
			tmp := [6]*DeployCardInfo{}
			for cardIdx, cardID := range cardIDs {
				if cardID == "" {
					continue
				}
				if _, ok := attrs[cardID]; !ok {
					log.Info("role %s cardID %s has not attr", r.RoleDbId(), cardID)
					continue
				}
				cardAttr := attrs[cardID]
				tmp[cardIdx] = &DeployCardInfo{
					ID:      cardID,
					CardID:  cardAttr.CardId,
					SkinID:  cardAttr.SkinId,
					Fp:      cardAttr.FightingPoint,
					Level:   cardAttr.Level,
					Star:    cardAttr.Star,
					Advance: cardAttr.Advance,
				}
			}
			ret[weekday][troopsIdx] = tmp
		}
	}

	return ret
}

func (r *RoleRecord) checkCardsEnough(weekday int) bool {
	r.RLock()
	defer r.RUnlock()

	cards := r.HoldCards()
	cardAttrs := r.HoldCardAttrs()
	troops, ok := cards[document.Integer(weekday)]
	if !ok {
		log.Warningf("role %s cards weekday %d error", r.RoleDbId(), weekday)
		return false
	}

	li := WeeekTroopCardNum[int(weekday)]

	for _, cardIDs := range troops {
		n := 0
		attrErr := false
		for _, cardID := range cardIDs {
			if cardID != "" {
				n++
				if attr, ok := cardAttrs[cardID]; !ok || attr == nil {
					attrErr = true
				}
			}
		}

		if attrErr {
			log.Warningf("role %s cards attr weekday %d num %d error", r.RoleDbId(), weekday, n)
			return false
		}

		if n == 0 || n > li {
			log.Warningf("role %s cards weekday %d num %d error", r.RoleDbId(), weekday, n)
			return false
		}
	}

	return true
}

func (r *RoleRecord) updateBattleCards(weekday int) {
	r.Lock()
	defer r.Unlock()

	holdCards := r.HoldCards()
	holdCardAttrs := r.HoldCardAttrs()
	holdCardAttrs2 := r.HoldCardAttrs2()
	cards := r.Cards()
	cardAttrs := r.CardAttrs()
	cardAttrs2 := r.CardAttrs2()

	if _, ok := cards[document.Integer(weekday)]; !ok {
		cards[document.Integer(weekday)] = make(map[document.Integer][]document.ID)
	}

	for troopIdx := range holdCards[document.Integer(weekday)] {
		cards[document.Integer(weekday)][document.Integer(troopIdx)] = holdCards[document.Integer(weekday)][troopIdx]
		for _, cardID := range holdCards[document.Integer(weekday)][troopIdx] {
			if cardID == "" {
				continue
			}
			if _, ok := holdCardAttrs[cardID]; ok {
				attr := *holdCardAttrs[cardID]
				cardAttrs[cardID] = &attr
			}
			if _, ok := holdCardAttrs2[cardID]; ok {
				attr := *holdCardAttrs2[cardID]
				cardAttrs2[cardID] = &attr
			}
		}
	}

	r.SetCards(cards)
	r.SetCardAttrs(cardAttrs)
	r.SetCardAttrs2(cardAttrs2)
}

func (r *RoleRecord) getWeekday6HoldCardAndAttr() (map[document.Integer][]document.ID, map[document.ID]*scheme.CardBattleModel) {
	r.RLock()
	defer r.RUnlock()

	retCards := make(map[document.Integer][]document.ID)
	retCardAttr := make(map[document.ID]*scheme.CardBattleModel)

	holdCards := r.HoldCards()
	holdCardAttrs := r.HoldCardAttrs()

	if _, ok := holdCards[document.Integer(6)]; !ok {
		return retCards, retCardAttr
	}

	for troopNum, troop := range holdCards[document.Integer(6)] {
		retCards[troopNum] = troop
	}

	for cardID := range holdCardAttrs {
		attr := *holdCardAttrs[cardID]
		retCardAttr[cardID] = &attr
	}

	return retCards, retCardAttr
}

func (r *RoleRecord) getWeekday6CardAndAttr() (map[document.Integer][]document.ID, map[document.ID]*scheme.CardBattleModel) {
	r.RLock()
	defer r.RUnlock()

	retCards := make(map[document.Integer][]document.ID)
	retCardAttr := make(map[document.ID]*scheme.CardBattleModel)

	cards := r.Cards()
	cardAttrs := r.CardAttrs()

	if _, ok := cards[document.Integer(6)]; !ok {
		return retCards, retCardAttr
	}

	for troopNum, troop := range cards[document.Integer(6)] {
		retCards[troopNum] = troop
	}

	for cardID := range cardAttrs {
		attr := *cardAttrs[cardID]
		retCardAttr[cardID] = &attr
	}

	return retCards, retCardAttr
}

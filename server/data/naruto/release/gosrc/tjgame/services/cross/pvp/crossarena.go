package pvp

import (
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/document/schemeutil"
	"tjgame/server_framework/tj/util"
)

type arenaRecord struct {
	arenaCompetitor
	arenaDeployment
}

type arenaCompetitor struct {
	ID     document.ID `codec:"id"`
	Name   string      `codec:"name"`
	Level  int         `codec:"level"`
	Logo   int         `codec:"logo"`
	Frame  int         `codec:"frame"`
	Figure int         `codec:"figure"`
	Vip    int         `codec:"vip"`
}

type arenaDeployment struct {
	Cards         map[document.Integer][]document.ID      `codec:"cards"`
	CardAttrs     map[document.ID]*scheme.CardBattleModel `codec:"card_attrs"`
	CardAttrs2    map[document.ID]*scheme.CardBattleModel `codec:"card_attrs2"`
	PassiveSkills map[document.Integer]int                `codec:"passive_skills"`

	DefenceCards         map[document.Integer][]document.ID      `codec:"defence_cards"`
	DefenceCardAttrs     map[document.ID]*scheme.CardBattleModel `codec:"defence_card_attrs"`
	DefenceCardAttrs2    map[document.ID]*scheme.CardBattleModel `codec:"defence_card_attrs2"`
	DefencePassiveSkills map[document.Integer]int                `codec:"defence_passive_skills"`
}

// CrossArenaRecord
type CrossArenaRecord struct {
	*scheme.CrossArenaRecordObject
}

// 布阵
func (r *CrossArenaRecord) deployCards(role arenaCompetitor, deploy arenaDeployment) {
	db, unlock := r.LockAndGetDB()
	defer unlock()
	db.RoleName = role.Name
	db.RoleLogo = role.Logo
	db.RoleFrame = role.Frame
	db.RoleLevel = role.Level
	db.RoleVip = role.Vip
	db.RoleFigure = role.Figure
	keys := []string{"role_name", "role_logo", "role_frame", "role_level", "role_vip", "role_figure"}

	// cards
	if len(deploy.Cards) > 0 {
		db.Cards = deploy.Cards
		keys = append(keys, "cards")
	}
	if len(deploy.DefenceCards) > 0 {
		db.DefenceCards = deploy.DefenceCards
		keys = append(keys, "defence_cards")
	}

	// CardAttrs
	if len(deploy.CardAttrs) > 0 {
		db.CardAttrs = schemeutil.UpdateCardAttrs(db.CardAttrs, deploy.CardAttrs, getCardsByMap(db.Cards))
		keys = append(keys, "card_attrs")
	}
	if len(deploy.CardAttrs2) > 0 {
		db.CardAttrs2 = schemeutil.UpdateCardAttrs(db.CardAttrs2, deploy.CardAttrs2, getCardsByMap(db.Cards))
		keys = append(keys, "card_attrs2")
	}
	if len(deploy.DefenceCardAttrs) > 0 {
		db.DefenceCardAttrs = schemeutil.UpdateCardAttrs(db.DefenceCardAttrs, deploy.DefenceCardAttrs, getCardsByMap(db.DefenceCards))
		keys = append(keys, "defence_card_attrs")
	}
	if len(deploy.DefenceCardAttrs2) > 0 {
		db.DefenceCardAttrs2 = schemeutil.UpdateCardAttrs(db.DefenceCardAttrs2, deploy.DefenceCardAttrs2, getCardsByMap(db.DefenceCards))
		keys = append(keys, "defence_card_attrs2")
	}

	r.SetDirty(keys...)
	// PassiveSkills
	r.SetPassiveSkills(deploy.PassiveSkills)
	r.SetDefencePassiveSkills(deploy.DefencePassiveSkills)
}

// 添加历史战斗
func (r *CrossArenaRecord) addHistory(enemyRank, rank, move int, model *scheme.CrossArenaPlayRecord, crossKey string) {
	r.Lock()
	defer r.Unlock()

	h := scheme.CrossArenaBattleHistory{}

	// 进攻方 1
	if r.GetID() == model.RecordDbId {
		cards := getCardsByMap(model.DefenceCards)
		_, fightingpoint := schemeutil.FilterEmptyCards(cards, model.DefenceCardAttrs)
		battleMode := 1
		h = scheme.CrossArenaBattleHistory{
			Time:   util.NowTime(),
			Result: model.Result,

			PlayRecordID:  model.ID,
			EnemyName:     model.DefenceName,
			EnemyRoleID:   model.DefenceRoleKey.ID,
			EnemyRecordID: model.DefenceRecordId,
			EnemyLogo:     model.DefenceLogo,
			EnemyFrame:    model.DefenceFrame,
			EnemyLevel:    model.DefenceLevel,
			EnemyVip:      model.DefenceVip,
			EnemyFight:    fightingpoint,
			EnemyRank:     enemyRank,

			Key:        model.DefenceRoleKey.GameKey,
			BattleMode: battleMode,
			Rank:       rank,
			Move:       move,
			CrossKey:   crossKey,
		}
	} else if r.GetID() == model.DefenceRecordId {
		cards2 := getCardsByMap(model.Cards)
		_, fightingpoint2 := schemeutil.FilterEmptyCards(cards2, model.CardAttrs)
		battleMode := 2
		result := "win"
		if model.Result == "win" {
			result = "fail"
		}
		h = scheme.CrossArenaBattleHistory{
			Time:   util.NowTime(),
			Result: result,

			PlayRecordID:  model.ID,
			EnemyName:     model.Name,
			EnemyRoleID:   model.RoleKey.ID,
			EnemyRecordID: model.RecordDbId,
			EnemyLogo:     model.Logo,
			EnemyFrame:    model.Frame,
			EnemyLevel:    model.Level,
			EnemyVip:      model.Vip,
			EnemyFight:    fightingpoint2,
			EnemyRank:     enemyRank,

			Key:        model.RoleKey.GameKey,
			BattleMode: battleMode,
			Rank:       rank,
			Move:       move,
			CrossKey:   crossKey,
		}
	}
	historys := r.History()
	historys = append(historys, h)
	// 只存10场
	if len(historys) > 10 {
		historys = historys[len(historys)-10:]
	}
	r.SetHistory(historys)
}

// 删除历史战报
func (r *CrossArenaRecord) cleanHistory() {
	_, unlock := r.LockAndGetDB()
	defer unlock()
	r.SetHistory([]scheme.CrossArenaBattleHistory{})
}

// cardMap => cardList
func getCardsByMap(cardsMap map[document.Integer][]document.ID) []document.ID {
	cards := make([]document.ID, 0)
	for i := 1; i < 10; i++ {
		if tempCards, ok := cardsMap[document.Integer(i)]; !ok {
			break
		} else {
			for _, card := range tempCards {
				cards = append(cards, card)
			}
		}
	}
	return cards
}

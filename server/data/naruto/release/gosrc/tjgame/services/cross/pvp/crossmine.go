package pvp

import (
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/document/schemeutil"
	"tjgame/server_framework/tj/util"
)

type mineCompetitor struct {
	ID     document.ID `codec:"id"`
	Name   string      `codec:"name"`
	Level  int         `codec:"level"`
	Logo   int         `codec:"logo"`
	Frame  int         `codec:"frame"`
	Figure int         `codec:"figure"`
	Vip    int         `codec:"vip"`
}

type mineDeployment struct {
	Cards         map[document.Integer][]document.ID      `codec:"cards"`
	CardAttrs     map[document.ID]*scheme.CardBattleModel `codec:"card_attrs"`
	CardAttrs2    map[document.ID]*scheme.CardBattleModel `codec:"card_attrs2"`
	PassiveSkills map[document.Integer]int                `codec:"passive_skills"`

	DefenceCards         map[document.Integer][]document.ID      `codec:"defence_cards"`
	DefenceCardAttrs     map[document.ID]*scheme.CardBattleModel `codec:"defence_card_attrs"`
	DefenceCardAttrs2    map[document.ID]*scheme.CardBattleModel `codec:"defence_card_attrs2"`
	DefencePassiveSkills map[document.Integer]int                `codec:"defence_passive_skills"`
}

type CrossMineRecord struct {
	*scheme.CrossMineRecordObject
}

// 布阵
func (r *CrossMineRecord) deployCards(role mineCompetitor, deploy mineDeployment) {
	db, unlock := r.LockAndGetDB()
	defer unlock()
	db.RoleName = role.Name
	db.RoleLogo = role.Logo
	db.RoleFrame = role.Frame
	db.RoleLevel = role.Level
	db.RoleFigure = role.Figure
	db.RoleVip = role.Vip
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
func (r *CrossMineRecord) addHistory(enemyRank, rank, move, coin13 int, model *scheme.CrossMinePlayRecord, crossKey, flag string) {
	r.Lock()
	defer r.Unlock()

	h := scheme.CrossMineBattleHistory{}

	// 进攻方 1
	if r.GetID() == model.RecordDbId {
		cards := getCardsByMap(model.DefenceCards)
		_, fightingPoint := schemeutil.FilterEmptyCards(cards, model.DefenceCardAttrs)
		battleMode := 1
		h = scheme.CrossMineBattleHistory{
			Time:   util.NowTime(),
			Result: model.Result,

			PlayRecordID:  model.ID,
			EnemyRoleID:   model.DefenceRoleKey.ID,
			EnemyRecordID: model.DefenceRecordId,
			EnemyGameKey:  model.DefenceRoleKey.GameKey,
			EnemyName:     model.DefenceName,
			EnemyLogo:     model.DefenceLogo,
			EnemyFrame:    model.DefenceFrame,
			EnemyLevel:    model.DefenceLevel,
			EnemyVip:      model.DefenceVip,
			EnemyFight:    fightingPoint,
			EnemyRank:     enemyRank,

			BattleMode: battleMode,
			Rank:       rank,
			Move:       move,
			Coin13:     coin13,
			CrossKey:   crossKey,
			Flag:       flag,
		}
	} else if r.GetID() == model.DefenceRecordId {
		cards2 := getCardsByMap(model.Cards)
		_, fightingPoint := schemeutil.FilterEmptyCards(cards2, model.CardAttrs)
		battleMode := 2
		result := "win"
		if model.Result == "win" {
			result = "fail"
		}
		h = scheme.CrossMineBattleHistory{
			Time:   util.NowTime(),
			Result: result,

			PlayRecordID:  model.ID,
			EnemyRoleID:   model.RoleKey.ID,
			EnemyRecordID: model.RecordDbId,
			EnemyGameKey:  model.RoleKey.GameKey,
			EnemyName:     model.Name,
			EnemyLogo:     model.Logo,
			EnemyFrame:    model.Frame,
			EnemyLevel:    model.Level,
			EnemyVip:      model.Vip,
			EnemyFight:    fightingPoint,
			EnemyRank:     enemyRank,

			BattleMode: battleMode,
			Rank:       rank,
			Move:       move,
			Coin13:     coin13,
			CrossKey:   crossKey,
			Flag:       flag,
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
func (r *CrossMineRecord) cleanHistory() {
	_, unlock := r.LockAndGetDB()
	defer unlock()
	r.SetHistory([]scheme.CrossMineBattleHistory{})
}

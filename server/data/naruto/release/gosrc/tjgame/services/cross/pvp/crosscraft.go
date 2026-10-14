package pvp

import (
	"errors"
	"strconv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/document/schemeutil"
	"tjgame/server_framework/tj/log"
	tjutil "tjgame/server_framework/tj/util"
)

type competitor struct {
	ID     document.ID `codec:"id"`
	Name   string      `codec:"name"`
	Level  int         `codec:"level"`
	Logo   int         `codec:"logo"`
	Frame  int         `codec:"frame"`
	Figure int         `codec:"figure"`
}

type deployment struct {
	Cards         []document.ID                           `codec:"cards"`
	CardAttrs     map[document.ID]*scheme.CardBattleModel `codec:"card_attrs"`
	CardAttrs2    map[document.ID]*scheme.CardBattleModel `codec:"card_attrs2"`
	PassiveSkills map[document.Integer]int                `codec:"passive_skills"`
}

var roundNext = map[string]string{
	"pre11": "pre12",
	"pre12": "pre13",
	"pre13": "pre14",

	"pre21": "pre22",
	"pre22": "pre23",
	"pre23": "pre24",

	"pre31": "pre32",
	"pre32": "pre33",
	"pre33": "pre34",

	"top64": "top32",
	"top32": "top16",

	"final1": "final2",
	"final2": "final3",
}

var roundLockNum = map[string]int{
	"top64": 1,
	"top32": 2,
	"top16": 3,

	"final1": 1,
	"final2": 2,
	"final3": 3,
}

var (
	ErrCraftLockDeploy = errors.New("craftLockDeploy")
)

// CrossCraftRecord
type CrossCraftRecord struct {
	*scheme.CrossCraftRecordObject
}

func (r *CrossCraftRecord) updateRole(role competitor) {
	db, unlock := r.LockAndGetDB()
	defer unlock()
	db.RoleName = role.Name
	db.RoleLogo = role.Logo
	db.RoleFrame = role.Frame
	db.RoleLevel = role.Level
	db.RoleFigure = role.Figure
	r.SetDirty("role_name", "role_logo", "role_frame", "role_level", "role_figure")
}

func (r *CrossCraftRecord) deployCards(deploy deployment, round string, lockcard bool) (err error) {
	db, unlock := r.LockAndGetDB()
	defer unlock()

	lockcardnum := 0
	lockcardattrs := round != "signup" && round != "closed"

	if len(deploy.Cards) > 0 {
		if lockcardattrs { // lock card attrs means round not in signup or closed
			if lockcard {
				if v, ok := roundNext[round]; ok {
					// locaked 为 true, 且不为当前轮次最后一场, round进行下一个
					round = v
				} else {
					return ErrCraftLockDeploy
				}
			}
			// 更换阵容
			if !schemeutil.CompareCardsSetEqual(db.Cards, deploy.Cards) {
				err = errors.New("craft cards not matched")
				return
			}
			roundNum := 1
			if round == "prepare" || round == "halftime" || round == "prepare2" {
				roundNum = 1
			} else if round[:3] == "pre" {
				roundNum, _ = strconv.Atoi(string(round[len(round)-1]))
			} else if round[:3] == "top" || round[:5] == "final" {
				roundNum = roundLockNum[round]
			}
			lockcardnum = (roundNum - 1) * 3
			for i, card := range deploy.Cards {
				// 开始战斗，只能更换之后的
				if i < lockcardnum && db.Cards[i] != card {
					err = ErrCraftLockDeploy
					return
				}
			}
			r.SetCards(deploy.Cards)
		} else {
			r.SetHoldCards(deploy.Cards)
		}
	}

	// 属性变动
	if len(deploy.CardAttrs) > 0 {
		db.HoldCardAttrs = schemeutil.UpdateCardAttrs(db.HoldCardAttrs, deploy.CardAttrs, db.Cards, db.HoldCards)
		r.SetHoldCardAttrs(db.HoldCardAttrs)
	}
	if len(deploy.CardAttrs2) > 0 {
		db.HoldCardAttrs2 = schemeutil.UpdateCardAttrs(db.HoldCardAttrs2, deploy.CardAttrs2, db.Cards, db.HoldCards)
		r.SetHoldCardAttrs2(db.HoldCardAttrs2)
	}
	r.SetHoldPassiveSkills(deploy.PassiveSkills)
	return
}

func (r *CrossCraftRecord) deployHoldCard(deploy deployment) {
	db, unlock := r.LockAndGetDB()
	defer unlock()
	if len(deploy.Cards) > 0 {
		r.SetHoldCards(deploy.Cards)
	}
	if len(deploy.CardAttrs) > 0 {
		db.HoldCardAttrs = schemeutil.UpdateCardAttrs(db.HoldCardAttrs, deploy.CardAttrs, db.Cards, db.HoldCards)
		r.SetHoldCardAttrs(db.HoldCardAttrs)
	}
	if len(deploy.CardAttrs2) > 0 {
		db.HoldCardAttrs2 = schemeutil.UpdateCardAttrs(db.HoldCardAttrs2, deploy.CardAttrs2, db.Cards, db.HoldCards)
		r.SetHoldCardAttrs2(db.HoldCardAttrs2)
	}
	r.SetHoldPassiveSkills(deploy.PassiveSkills)
}

func (r *CrossCraftRecord) checkBroken() bool {
	db, unlock := r.RLockAndGetDB()
	defer unlock()
	broken := false
	cardattrs := db.CardAttrs
	cards := db.Cards
	if len(cards) < 12 {
		log.Warningf("role %v %s record %v not enough cards, expect %d got %d", r.RoleDbId(), r.RoleName(), r.GetID(), 12, len(cards))
		return true
	}
	for _, id := range cards {
		if id == "" {
			broken = true
			log.Warningf("role %v %s record %v not enough cards", r.RoleDbId(), r.RoleName(), r.GetID())
			break
		} else {
			if _, ok := cardattrs[id]; !ok {
				broken = true
				log.Warningf("role %v %s record %v card not find card attr", r.RoleDbId(), r.RoleName(), r.GetID())
				break
			}
		}
	}
	return broken
}

func (r *CrossCraftRecord) prepare(manual bool) {
	db, unlock := r.LockAndGetDB()
	defer unlock()
	r.SetHistory([]scheme.CrossCraftBattleHistory{}) // 清空历史
	if r.Robot() {
		return
	}
	// 更新战斗数据
	if len(db.HoldCards) > 0 { // 旧数据 HoldCards 可能没有
		r.SetCards(db.HoldCards)
	}
	r.SetCardAttrs(schemeutil.CopyCardAttrs(db.HoldCardAttrs))
	r.SetCardAttrs2(schemeutil.CopyCardAttrs(db.HoldCardAttrs2))
	r.SetPassiveSkills(schemeutil.CopySkills(db.HoldPassiveSkills))
}

func (r *CrossCraftRecord) addByeHistory(model *scheme.CrossCraftPlayRecord) {
	cards, fightingpoint := schemeutil.FilterEmptyCards(model.Cards, model.CardAttrs)
	h := scheme.CrossCraftBattleHistory{
		Time:          tjutil.NowTime(),
		Round:         model.Round,
		Result:        "win",
		Point:         model.Point,
		FightingPoint: fightingpoint,
		Cards:         cards,
	}
	db, unlock := r.LockAndGetDB()
	defer unlock()
	history := db.History
	history = append(history, h)
	r.SetHistory(history)
}

func (r *CrossCraftRecord) addHistoryFromPlay(model *scheme.CrossCraftPlayRecord, key string) {
	cards, fightingpoint := schemeutil.FilterEmptyCards(model.Cards, model.CardAttrs)
	cards2, fightingpoint2 := schemeutil.FilterEmptyCards(model.DefenceCards, model.DefenceCardAttrs)
	h := scheme.CrossCraftBattleHistory{
		Time:         tjutil.NowTime(),
		Round:        model.Round,
		PlayRecordID: &model.ID,
		CrossKey:     key,
	}
	db, unlock := r.LockAndGetDB()
	defer unlock()
	if r.RoleDbId() == model.RoleKey.ID {
		h.Result = model.Result
		h.Point = model.Point
		h.FightingPoint = fightingpoint
		h.Cards = cards
		h.Enemy = &scheme.CrossCraftBattleRole{
			CrossCraftRole: scheme.CrossCraftRole{
				RoleID:   model.DefenceRoleKey.ID,
				RecordID: model.DefenceRecordId,
				GameKey:  model.DefenceRoleKey.GameKey,
				Name:     model.DefenceName,
				Logo:     model.DefenceLogo,
				Frame:    model.DefenceFrame,
				Level:    model.DefenceLevel,
				Figure:   model.DefenceFigure,
			},
			FightingPoint: fightingpoint2,
			Cards:         cards2,
		}
	} else {
		result := "win"
		if model.Result == "win" {
			result = "fail"
		}
		h.Result = result
		h.Point = model.DefencePoint
		h.FightingPoint = fightingpoint2
		h.Cards = cards2
		h.Enemy = &scheme.CrossCraftBattleRole{
			CrossCraftRole: scheme.CrossCraftRole{
				RoleID:   model.RoleKey.ID,
				RecordID: model.RecordDbId,
				GameKey:  model.RoleKey.GameKey,
				Name:     model.Name,
				Logo:     model.Logo,
				Frame:    model.Frame,
				Level:    model.Level,
				Figure:   model.Figure,
			},
			FightingPoint: fightingpoint,
			Cards:         cards,
		}
	}
	history := db.History
	history = append(history, h)
	r.SetHistory(history)
}

/*
 * @Date    : 2021/9/9 22:45
 * @File    : crossunionfight.go
 * @Version : 1.0.0
 * @Author  : hss
 * @Note    :
 *
 */

package pvp

import (
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/document/schemeutil"
	"tjgame/server_framework/tj/util"
)

type unionfightCompetitor struct {
	ID     document.ID `codec:"id"`
	Name   string      `codec:"name"`
	Level  int         `codec:"level"`
	Logo   int         `codec:"logo"`
	Frame  int         `codec:"frame"`
	Figure int         `codec:"figure"`
	Title  int         `codec:"title"`
}

type unionfightDeployment struct {
	Cards         scheme.CrossUnionFightCards             `codec:"cards"`
	CardAttrs     map[document.ID]*scheme.CardBattleModel `codec:"card_attrs"`
	CardAttrs2    map[document.ID]*scheme.CardBattleModel `codec:"card_attrs2"`
	PassiveSkills map[document.Integer]int                `codec:"passive_skills"`

	TopCardAttrs     map[document.ID]*scheme.CardBattleModel `codec:"top_card_attrs"`
	TopCardAttrs2    map[document.ID]*scheme.CardBattleModel `codec:"top_card_attrs2"`
	TopPassiveSkills map[document.Integer]int                `codec:"top_passive_skills"`
}

// CreateCrossUnionFightRoleRecord 的响应
type RespCreateCrossUnionFight struct {
	ID    document.ID                 `codec:"id"`
	Cards scheme.CrossUnionFightCards `codec:"cards"`
}

// RemoteRecord
type RemoteRecord struct {
	RoleDbId      document.ID                             `codec:"role_db_id"`
	RecordID      document.ID                             `codec:"record_id"`
	RoleName      string                                  `codec:"role_name"`
	RoleLogo      int                                     `codec:"role_logo"`
	RoleFrame     int                                     `codec:"role_frame"`
	RoleLevel     int                                     `codec:"role_level"`
	RoleFigure    int                                     `codec:"role_figure"`
	Cards         []document.ID                           `codec:"cards"`
	CardAttrs     map[document.ID]*scheme.CardBattleModel `codec:"card_attrs"`
	CardAttrs2    map[document.ID]*scheme.CardBattleModel `codec:"card_attrs2"`
	PassiveSkills map[document.Integer]int                `codec:"passive_skills"`
}

// deployRoles 战场分布响应
type RespDeployRoles struct {
	PreDeployRoles map[document.Integer][]document.ID `codec:"pre_deploy_roles"`
	TopDeployRoles map[document.Integer][]document.ID `codec:"top_deploy_roles"`
}

// CrossUnionFightRoleRecord
type CrossUnionFightRoleRecord struct {
	*scheme.CrossUnionFightRoleRecordObject
}

// 布阵
func (r *CrossUnionFightRoleRecord) deployCards(role unionfightCompetitor, deploy unionfightDeployment) {
	db, unlock := r.LockAndGetDB()
	defer unlock()
	db.RoleName = role.Name
	db.RoleLogo = role.Logo
	db.RoleFrame = role.Frame
	db.RoleLevel = role.Level
	db.RoleFigure = role.Figure
	db.RoleTitle = role.Title
	keys := []string{"role_name", "role_logo", "role_frame", "role_level", "role_figure", "role_title"}
	r.SetDirty(keys...)

	// cards
	oldCards := db.Cards
	if len(deploy.Cards) > 0 {
		for stage, battleCards := range deploy.Cards {
			oldCards[stage] = battleCards
		}
	}
	r.SetCards(oldCards)

	// 初赛
	// CardAttrs
	if len(deploy.CardAttrs) > 0 {
		db.CardAttrs = schemeutil.UpdateCardAttrs(db.CardAttrs, deploy.CardAttrs, GetCrossUnionFightCardsByMap(db.Cards, 1))
		r.SetCardAttrs(db.CardAttrs)
	}
	// CardAttrs2
	if len(deploy.CardAttrs2) > 0 {
		db.CardAttrs2 = schemeutil.UpdateCardAttrs(db.CardAttrs2, deploy.CardAttrs2, GetCrossUnionFightCardsByMap(db.Cards, 1))
		r.SetCardAttrs2(db.CardAttrs2)
	}
	// PassiveSkills
	r.SetPassiveSkills(deploy.PassiveSkills)

	// 决赛
	// TopCardAttrs
	if len(deploy.TopCardAttrs) > 0 {
		db.TopCardAttrs = schemeutil.UpdateCardAttrs(db.TopCardAttrs, deploy.TopCardAttrs, GetCrossUnionFightCardsByMap(db.Cards, 2))
		r.SetTopCardAttrs(db.TopCardAttrs)
	}
	// TopCardAttrs2
	if len(deploy.TopCardAttrs2) > 0 {
		db.TopCardAttrs2 = schemeutil.UpdateCardAttrs(db.TopCardAttrs2, deploy.TopCardAttrs2, GetCrossUnionFightCardsByMap(db.Cards, 2))
		r.SetTopCardAttrs2(db.TopCardAttrs2)
	}
	// PassiveSkills
	r.SetTopPassiveSkills(deploy.TopPassiveSkills)
}

func GetCrossUnionFightCardsByMap(cardsMap scheme.CrossUnionFightCards, stage int) []document.ID {
	cardSet := util.NewSet()
	var cardList []document.ID
	if battleCards, ok := cardsMap[document.Integer(stage)]; ok {
		for _, gCards := range battleCards {
			for _, cardID := range gCards {
				if !cardSet.Contains(cardID) {
					cardList = append(cardList, cardID)
				}
				cardSet.Add(cardID)
			}
		}
	}
	return cardList
}

// cards list 转为 cross_union_fight cards
func CardsConvert(cards []document.ID, project int) scheme.CrossUnionFightCards {
	crossUnionFightCards := scheme.CrossUnionFightCards{}
	for _, card := range cards {
		for ty := 1; ty <= 2; ty++ {
			if tyCards, ok := crossUnionFightCards[document.Integer(ty)]; ok {
				if project == 1 {
					// 常规
					if oneCards, ok := tyCards[1]; ok {
						oneCards = append(oneCards, card)
						tyCards[1] = oneCards
					}
				} else if project == 2 {
					// 车轮
					if twoCards, ok := tyCards[2]; ok {
						idx := (len(twoCards) + 1) % 6
						if idx == 5 {
							twoCards = append(twoCards, "")
							twoCards = append(twoCards, "")
							twoCards = append(twoCards, card)
						} else {
							twoCards = append(twoCards, card)
						}
						tyCards[2] = twoCards
					}
				} else {
					// 单挑
					if threeCards, ok := tyCards[3]; ok {
						if len(threeCards) <= 9 {
							threeCards = append(threeCards, card)
							tyCards[3] = threeCards
						}
					}
				}
				crossUnionFightCards[document.Integer(ty)] = tyCards
			} else {
				tyCards = map[document.Integer][]document.ID{
					document.Integer(project): {card},
				}
				crossUnionFightCards[document.Integer(ty)] = tyCards
			}
		}
	}
	return crossUnionFightCards
}

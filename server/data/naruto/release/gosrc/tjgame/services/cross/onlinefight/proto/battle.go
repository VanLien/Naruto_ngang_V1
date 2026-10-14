package proto

import (
	"tjgame/document"
	"tjgame/document/scheme"
)

type Competitor struct {
	scheme.CrossOnlineFightRole
	Score int `codec:"score"`
}

type BattleInfo struct {
	ID   document.ID `codec:"id"`
	From string      `codec:"from"`
	Time int64       `codec:"time"`
	Solo bool        `codec:"solo,omitempty"`

	Role1 *Competitor `codec:"role1"`
	Role2 *Competitor `codec:"role2"`
	// 战报
	PlayRecord *scheme.CrossOnlineFightPlayRecord `codec:"play_record"`

	// 公平赛选卡规则
	BanPicks []BanPick `codec:"banpicks"`
	// 公平赛主题稀有度限制
	RarityLimit map[int]int `codec:"rarityLimit"`
	// 公平赛卡组信息
	LimitedCardDeck *CrossOnlineFightLimitedCardDeck `codec:"limited_card_deck"`
}

type CrossOnlineFightCard struct {
	scheme.CrossOnlineFightCard

	MarkID int `codec:"mark_id"`
	Rarity int `codec:"rarity"`
}

type CrossOnlineFightLimitedCardDeck struct {
	// 公平赛使用卡牌列表
	RoleCardDeck1 []document.ID `codec:"card_deck1"`
	RoleCardDeck2 []document.ID `codec:"card_deck2"`
	// 公平赛使用的卡牌
	Cards map[document.ID]*CrossOnlineFightCard `codec:"cards"`
	// 公平赛使用的卡牌属性
	CardAttrs map[document.ID]*scheme.CardBattleModel `codec:"card_attrs"`
}

type BanPick struct {
	Ban    int `codec:"ban,omitempty"`
	Pick   int `codec:"pick,omitempty"`
	Second int `codec:"second"`
}

type BattleResult struct {
	ID                document.ID               `codec:"id"`
	Results           [2]string                 `codec:"results"`
	BanPickInputSteps []scheme.BanPickInputStep `codec:"banpick_input_steps"`
	AttackFrames      []scheme.AttackFrame      `codec:"attack_frames"`
	// 是否是精彩战报
	Wonderful bool `codec:"wonderful"`

	// 主动进攻部署卡牌列表
	Cards []document.ID `codec:"cards"`
	// 主动进攻卡牌离线属性
	CardAttrs map[document.ID]*scheme.CardBattleModel `codec:"card_attrs"`
	// 被动防御部署卡牌列表
	DefenceCards []document.ID `codec:"defence_cards"`
	// 被动防御卡牌离线属性
	DefenceCardAttrs map[document.ID]*scheme.CardBattleModel `codec:"defence_card_attrs"`
}

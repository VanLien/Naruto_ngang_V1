package yyhuodong

import (
	"tjgame/document"
	"tjgame/document/scheme"
)

type Config struct {
	WorldBossHP       map[int]int     // {huodongID: baseHP}
	WorldBossHPFix    map[int]float64 // {level: fix}
	WorldBossMinLevel int
	WorldBossMaxLevel int
}

type ReqWorldBoss struct {
	Role  *scheme.WorldBossRole      `codec:"role"`
	Union *scheme.WorldBossUnionInfo `codec:"union"`
}

type RespWorldBossDayEnd struct {
	FinishGoal bool          `codec:"finishGoal"`
	RankRoles  []document.ID `codec:"rankRoles"`
	RankUnions []document.ID `codec:"rankUnions"`
}

type RespWorldBossMain struct {
	BossLevel int `codec:"bossLevel"`
	DamageSum int `codec:"damageSum"`
}

type RespWorldBossUnionRank struct {
	Ranks      []worldBossUnionRankItem `codec:"ranks"`
	SelfRank   int                      `codec:"selfRank"`
	SelfDamage int                      `codec:"selfDamage"`
}

type RespWorldBossRoleRank struct {
	Ranks      []scheme.WorldBossRole `codec:"ranks"`
	SelfRank   int                    `codec:"selfRank"`
	SelfDamage int                    `codec:"selfDamage"`
}

type RespWorldBossRankInfo struct {
	RoleRank  RespWorldBossRoleRank  `codec:"roleRank"`
	UnionRank RespWorldBossUnionRank `codec:"unionRank"`
}

type worldBossUnionRankItem struct {
	scheme.WorldBossUnionInfo
	Damage int `codec:"damage"`
}

type rankItem struct {
	id    document.ID
	items map[string]int
}

type ranks struct {
	items []rankItem
	keys  []string
}

func (r *ranks) Len() int {
	return len(r.items)
}

func (r *ranks) Less(i, j int) bool {
	for _, key := range r.keys {
		if r.items[i].items[key] == r.items[j].items[key] {
			continue
		}
		return r.items[i].items[key] > r.items[j].items[key]
	}
	return true
}

func (r *ranks) Swap(i, j int) {
	r.items[i], r.items[j] = r.items[j], r.items[i]
}

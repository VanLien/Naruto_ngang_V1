package scheme

import (
	"tjgame/document"
)

type WorldBossGlobal struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key" unique:"true"`
	// 世界 Boss 参与公会
	Unions map[document.ID]*WorldBossUnion `bson:"unions" codec:"unions"`
	// 世界 boss 参与角色
	Roles map[document.ID]*WorldBossRole `bson:"roles" codec:"roles"`
	// 最后一次 boss level
	LastLevel int `bson:"last_level" codec:"last_level"`
	// 最后一次发奖励 yyID
	LastYYID int `bson:"last_yyID" codec:"last_yyID"`
	// 最后一次发奖励日期
	LastDate int `bson:"last_date" codec:"last_date"`
	// 世界 Boss 参与公会备份
	LastUnions map[document.ID]*WorldBossUnion `bson:"last_unions" codec:"last_unions"`
	// 世界 boss 参与角色备份
	LastRoles map[document.ID]*WorldBossRole `bson:"last_roles" codec:"last_roles"`
}

type WorldBossUnionInfo struct {
	ID    document.ID `bson:"id" codec:"id"`
	Level int         `bson:"level" codec:"level"`
	Logo  int         `bson:"logo" codec:"logo"`
	Name  string      `bson:"name" codec:"name"`
}

type WorldBossUnion struct {
	WorldBossUnionInfo `bson:",inline"`
	DamageSum          int                 `bson:"damage_sum" codec:"damage_sum"`
	DamageRoles        map[document.ID]int `bson:"damage_roles" codec:"damage_roles"`
	Rank               int                 `bson:"rank" codec:"rank"`
}

type WorldBossRoleInfo struct {
	ID       document.ID `bson:"id" codec:"id"`
	Logo     int         `bson:"logo" codec:"logo"`
	Frame    int         `bson:"frame" codec:"frame"`
	Title    int         `bson:"title" codec:"title"`
	Name     string      `bson:"name" codec:"name"`
	Level    int         `bson:"level" codec:"level"`
	VipLevel int         `bson:"vip_level" codec:"vip_level"`
}

type WorldBossBattleCard struct {
	ID      document.ID `bson:"id" codec:"id"`
	CardID  int         `bson:"card_id" codec:"card_id"`
	SkinID  int         `bson:"skin_id" codec:"skin_id"`
	Level   int         `bson:"level" codec:"level"`
	Star    int         `bson:"star" codec:"star"`
	Advance int         `bson:"advance" codec:"advance"`
}

type WorldBossRole struct {
	Role            WorldBossRoleInfo      `bson:"role" codec:"role"`
	BossDamage      int                    `bson:"boss_damage" codec:"boss_damage"`
	BossBattleCards []*WorldBossBattleCard `bson:"boss_battle_cards" codec:"boss_battle_cards"`
	Rank            int                    `bson:"rank" codec:"rank"`
}

func (*WorldBossGlobal) CollectionName() string {
	return "WorldBossGlobal"
}

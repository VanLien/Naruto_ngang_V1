package scheme

import "tjgame/document"

// 无尽之塔全局
type EndlessTowerGlobal struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key"`

	// 最近通关战报
	LatestPlays map[document.Integer][]SimplePlay `bson:"latest_plays" codec:"latest_plays"`
	// 最低战力通关战报
	LowerFightingPlays map[document.Integer]SimplePlay `bson:"lower_fighting_plays" codec:"lower_fighting_plays"`
}

func (*EndlessTowerGlobal) CollectionName() string {
	return "EndlessTowerGlobal"
}

// 战报缩略信息
type SimplePlay struct {
	// 战报ID
	PlayID document.ID `bson:"play_id" codec:"play_id"`
	// 头像ID
	Logo int `bson:"logo" codec:"logo"`
	// 名称
	Name string `bson:"name" codec:"name"`
	// 头像框ID
	Frame int `bson:"frame" codec:"frame"`
	// 等级
	Level int `bson:"level" codec:"level"`
	// VIP
	Vip int `bson:"vip" codec:"vip"`
	// 战力
	FightingPoint int `bson:"fighting_point" codec:"fighting_point"`
	// 回合数
	Round int `bson:"round" codec:"round"`
}

// PVE 战斗战报
type PVEBattlePlayRecord struct {
	document.DocumentID `bson:",inline"`

	// 战斗日期
	Date int `bson:"date" codec:"date" default:"todaydate2int"`
	// 战斗时间
	Time float64 `bson:"time" codec:"time" default:"nowtime_t"`
	// 战斗随机种子
	RandSeed int32 `bson:"rand_seed" codec:"rand_seed"`

	//  Role.id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id"`
	// 角色名字
	Name string `bson:"name" codec:"name"`
	// 角色头像ID
	Logo int `bson:"logo" codec:"logo"`
	// 角色头像框ID
	Frame int `bson:"frame" codec:"frame"`
	// 角色等级
	Level int `bson:"level" codec:"level"`

	// 部署卡牌列表
	Cards []document.ID `bson:"cards" codec:"cards"`
	// 卡牌离线属性
	CardAttrs map[document.ID]*CardBattleModel `bson:"card_attrs" codec:"card_attrs"`
	// 卡牌离线属性
	CardAttrs2 map[document.ID]*CardBattleModel `bson:"card_attrs2,omitempty" codec:"card_attrs2,omitempty"`
	// 卡牌被动技能
	PassiveSkills map[document.Integer]int `bson:"passive_skills" codec:"passive_skills"`
	// 战斗结果
	Result string `bson:"result" codec:"result" default:"unknown"`

	// 关卡ID
	GateID int `bson:"gate_id" codec:"gate_id"`
	// 战斗操作序列
	Actions map[document.Integer][]BattleAction `bson:"actions" codec:"actions"`
}

func (*PVEBattlePlayRecord) CollectionName() string {
	return "PVEBattlePlayRecord"
}

type BattleAction struct {
	_struct struct{} `codec:",toarray"`

	Current int `bson:"current"`
	Target  int `bson:"target"`
	Action  int `bson:"action"`
}

package scheme

import "tjgame/document"

type HuoDongBossPalyKey struct {
	CrossKey string `bson:"cross_key" codec:"cross_key"`
	Group    int    `bson:"group" codec:"group"`
}

// 活动Boss
type HuoDongBossGlobal struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key" index:"true"`
	// 组
	Group int `bson:"group" codec:"group"`
	// 参与的server [node key list]
	Servers []string `bson:"servers" codec:"servers"`
	// 日期
	EndDate int `bson:"end_date" codec:"end_date"`
	// yyID
	YYID int `bson:"yyID" codec:"yyID"`
	// 活动Boss
	Boss map[string]HuoDongBossInfo `bson:"boss" codec:"boss"`
	// status
	Status string `bson:"status" codec:"status" default:"closed"`
}

func (*HuoDongBossGlobal) CollectionName() string {
	return "HuoDongBossGlobal"
}

type HuoDongBossRoleInfo struct {
	RoleID     document.ID `bson:"role_id" codec:"role_id"`
	GameKey    string      `bson:"game_key" codec:"game_key"`
	Name       string      `bson:"name" codec:"name"`
	Logo       int         `bson:"logo" codec:"logo"`
	Frame      int         `bson:"frame" codec:"frame"`
	Level      int         `bson:"level" codec:"level"`
	FightPoint int         `bson:"fight_point" codec:"fight_point"`
}

type HuoDongBossInfo struct {
	Uid       string                `bson:"uid" codec:"uid"`
	Owner     HuoDongBossRoleInfo   `bson:"owner" codec:"owner"`
	StartTime float64               `bson:"start_time" codec:"start_time"`
	GateID    int                   `bson:"gate_id" codec:"gate_id"` // huodongboss.csv
	WinRoles  []HuoDongBossRoleInfo `bson:"win_roles" codec:"win_roles"`
	OwnerWin  bool                  `bson:"owner_win" codec:"owner_win" default:"False"`
}

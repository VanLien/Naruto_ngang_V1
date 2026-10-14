package scheme

import "tjgame/document"

// 摩天高楼
type SkyscraperGlobal struct {
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
	// 摩天高楼
	Skyscraper map[document.ID]*SkyscraperInfo `bson:"skyscraper" codec:"skyscraper"`
	// status
	Status string `bson:"status" codec:"status" default:"closed"`
}

func (*SkyscraperGlobal) CollectionName() string {
	return "SkyscraperGlobal"
}

type SkyscraperInfo struct {
	RoleID   document.ID `bson:"role_id" codec:"role_id"`
	Logo     int         `bson:"logo" codec:"logo"`
	Frame    int         `bson:"frame" codec:"frame"`
	Name     string      `bson:"name" codec:"name"`
	Level    int         `bson:"level" codec:"level"`
	GameKey  string      `bson:"game_key" codec:"game_key"` // 区服
	MedalLvl int         `bson:"medallvl" codec:"medallvl"` // 勋章等级

	HighScore int `bson:"high_score" codec:"high_score"` // 最高积分
	HighFloor int `bson:"high_floor" codec:"high_floor"` // 最高层
}

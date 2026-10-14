package scheme

import "tjgame/document"

type TinyRank struct {
	document.DocumentID `bson:",inline"`

	Name  string     `bson:"name" codec:"name" unique:"true"`
	Ranks []rankRole `bson:"ranks" codec:"ranks"`
}

func (*TinyRank) CollectionName() string {
	return "TinyRank"
}

type rankRole struct {
	ID       document.ID `bson:"id" codec:"id"`
	Logo     int         `bson:"logo" codec:"logo"`
	Frame    int         `bson:"frame" codec:"frame"`
	Title    int         `bson:"title" codec:"title"`
	Name     string      `bson:"name" codec:"name"`
	Level    int         `bson:"level" codec:"level"`
	VipLevel int         `bson:"vip_level" codec:"vip_level"`

	Score    int `bson:"score" codec:"score"`
	LastTime int `bson:"lasttime" codec:"lasttime"`
}

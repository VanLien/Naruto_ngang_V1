package scheme

import (
	"tjgame/document"
)

// 钻石返还
type RmbReturn struct {
	document.DocumentID `bson:",inline"`

	// 用户绑定的注册名，渠道账号ID
	Name string `bson:"name" codec:"name" index:"true" unique:"true"`
	// 用户来源渠道
	Channel string `bson:"channel" codec:"channel" default:"none"`
	// 用户来源语言
	Language string `bson:"language" codec:"language" default:"cn"`
	// 返还rmb
	Rmb int `bson:"rmb" codec:"rmb"`
	// VIP
	Vip int `bson:"vip" codec:"vip"`
	// 首次创建选择区服
	Area string `bson:"area" codec:"area"`
}

func (*RmbReturn) CollectionName() string {
	return "RmbReturn"
}
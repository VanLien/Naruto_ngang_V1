package scheme

import (
	"tjgame/document"
)


// 玩家信息
type Account struct {
	document.DocumentID `bson:",inline"`

	// 用户绑定的注册名，渠道账号ID
	Name string `bson:"name" codec:"name" index:"true" unique:"true"`
	//
	Money int64 `bson:"money" codec:"money" `

	PayID int `bson:"pay_id,omitempty" codec:"pay_id" unique:"true"`

	//
	Email string `bson:"email" codec:"email"`
	//
	Phone string `bson:"phone" codec:"phone" `
	// 用户来源渠道
	Channel string `bson:"channel" codec:"channel" default:"none"`
	// 用户来源语言
	Language string `bson:"language" codec:"language" default:"cn"`
	// 用户密码
	PassMd5 string `bson:"pass_md5" codec:"pass_md5"`
	// 注册时间
	CreateTime float64 `bson:"create_time" codec:"create_time" default:"nowtime_t"`
	// 上次操作时间
	LastTime float64 `bson:"last_time" codec:"last_time" default:"nowtime_t"`
	// 用户来源Tag
	Tag string `bson:"tag,omitempty" codec:"tag"`
	// 角色信息
	RoleInfos map[string]RoleInfo `bson:"role_infos" codec:"role_infos"`
	// GM封号
	DisableFlag bool `bson:"disable_flag" codec:"disable_flag"`
	// 实名注册的年纪
	Age int `bson:"age" codec:"age"`
}

func (*Account) CollectionName() string {
	return "Account"
}

type RoleInfo struct {
	ID    document.ID `bson:"id" codec:"id"`
	Name  string      `bson:"name" codec:"name"`
	Level int         `bson:"level" codec:"level"`
	Logo  int         `bson:"logo" codec:"logo"`
	Vip   int         `bson:"vip" codec:"vip"`
	Frame int         `bson:"frame" codec:"frame"`
}

// GM信息
type GMAccount struct {
	document.DocumentID `bson:",inline"`

	// GM 注册名
	Name string `bson:"name" codec:"name" index:"true" unique:"true"`
	// 密码
	PassMd5 string `bson:"pass_md5" codec:"pass_md5"`
	// 注册时间
	CreateTime float64 `bson:"create_time" codec:"create_time" default:"nowtime_t"`
	// 上次操作时间
	LastTime float64 `bson:"last_time" codec:"last_time" default:"nowtime_t"`
	// 权限级别
	PermissionLevel int `bson:"permission_level" codec:"permission_level"`
	// 操作记录
	OperatedHistory []GMOpHistory `bson:"operated_history" codec:"operated_history"`
}

func (*GMAccount) CollectionName() string {
	return "GMAccount"
}

type GMOpHistory struct {
	_struct struct{} `codec:",toarray"`

	Rpc   string  `bson:"rpc"`
	Param string  `bson:"param"`
	Time  float64 `bson:"time"`
}

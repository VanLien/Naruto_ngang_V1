package scheme

import "tjgame/document"

// 礼包
type PaymentLog struct {
	document.DocumentID `bson:",inline"`

	// account
	Account string `bson:"account" codec:"account"`
	// provider
	Provider string `bson:"provider" codec:"provider" `
	// type
	Type int `bson:"type" codec:"type" `
	// money
	Money int64 `bson:"money" codec:"money" `
	// serial or refno
	Serial string `bson:"serial" codec:"serial" `
	// pin or refno
	Pin string `bson:"pin" codec:"pin" `
	// taskID
	TaskID int `bson:"taskID" codec:"taskID" default:"0"`
	// 用户来源渠道
	Status int `bson:"channel" codec:"channel" default:"0"`
	// 用户来源语言
	Created_At string `bson:"language" codec:"language"`
	// 用户密码
	
}

func (*PaymentLog) CollectionName() string {
	return "PaymentLog"
}

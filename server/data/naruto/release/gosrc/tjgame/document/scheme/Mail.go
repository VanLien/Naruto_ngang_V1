package scheme

import (
	"tjgame/document"
)

// 邮件
type Mail struct {
	document.DocumentID `bson:",inline"`

	// Role.id, nil的话是全局邮件
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// 发送时间
	Time float64 `bson:"time" codec:"time" default:"nowtime_t"`
	// 邮件类型CSV ID
	Type int `bson:"type" codec:"type" default:"1"`
	// 发件人
	Sender string `bson:"sender" codec:"sender"`
	// 邮件标题
	Subject string `bson:"subject" codec:"subject"`
	// 邮件内容
	Content string `bson:"content" codec:"content"`
	// 附件{CSV_ID:count}
	Attachs *document.GoodsMap `bson:"attachs" codec:"attachs"`
	// 是否已删除，全局邮件不能设为Ture
	DeletedFlag bool `bson:"deleted_flag" codec:"deleted_flag"`
	// 新建玩家的邮件，Account.name
	NewbieName string `bson:"newbie_name" codec:"newbie_name"`
}

func (*Mail) CollectionName() string {
	return "Mail"
}

type MailThumb struct {
	DBID      document.ID `bson:"db_id" codec:"db_id"`
	Subject   string      `bson:"subject" codec:"subject"`
	Time      float64     `bson:"time" codec:"time"`
	Type      int         `bson:"type" codec:"type"`
	Sender    string      `bson:"sender" codec:"sender"`
	Global    bool        `bson:"global" codec:"global"`
	HasAttach bool        `bson:"hasattach" codec:"hasattach"`
}

// 邮箱
type MailBox struct {
	document.DocumentID `bson:",inline"`

	// Role.id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// 未读邮件
	Index []MailThumb `bson:"index" codec:"index"`
	// 已读邮件
	Readed []MailThumb `bson:"readed" codec:"readed"`
	// 全局邮件游标
	GlobalIdx int `bson:"global_idx" codec:"global_idx"`
}

func (*MailBox) CollectionName() string {
	return "MailBox"
}

package scheme

import "tjgame/document"

type GlobalMailThumb struct {
	MailThumb          `bson:",inline"`
	GlobalMailThumbExt `bson:",inline"`
}

type GlobalMailThumbExt struct {
	Mtype    int `bson:"mtype" codec:"mtype"`
	BeginVip int `bson:"beginVip" codec:"beginVip"`
	EndVip   int `bson:"endVip" codec:"endVip"`
}

// 全局全服邮件
type MailGlobal struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key"`
	// 全局邮件邮件缩略数据 [{db_id:Mail.id, subject:Mail.subject, time:Mail.time, type=Mail.type, mtype=邮件类型, sender:Mail.sender}, ...]
	Mails []GlobalMailThumb `bson:"mails" codec:"mails"`
}

func (*MailGlobal) CollectionName() string {
	return "MailGlobal"
}

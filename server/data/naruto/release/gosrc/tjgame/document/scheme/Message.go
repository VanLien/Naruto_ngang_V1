package scheme

import "tjgame/document"

type ChatRole struct {
	ID    document.ID `bson:"id" codec:"id"`
	Name  string      `bson:"name" codec:"name"`
	Logo  int         `bson:"logo" codec:"logo"`
	Frame int         `bson:"frame" codec:"frame"`
	Title int         `bson:"title" codec:"title"`
	Level int         `bson:"level" codec:"level"`
	Vip   int         `bson:"vip" codec:"vip"`
}

// 聊天消息
type Message struct {
	_struct struct{} `codec:",toarray"`

	ID   uint64          `bson:"id" codec:"id"`
	Time float64         `bson:"time" codec:"time"`
	Msg  string          `bson:"msg" codec:"msg"`
	Type int             `bson:"type" codec:"type"`
	Role *ChatRole       `bson:"role" codec:"role"`
	Args document.RawMap `bson:"args" codec:"args"`
}

type MessageQueue struct {
	Name     string      `bson:"name" codec:"name"`
	ID       document.ID `bson:"id" codec:"id"`
	Messages []Message   `bson:"messages" codec:"messages"`
}

// 消息中心
type MessageGlobal struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key    string         `bson:"key" codec:"key"`
	Queues []MessageQueue `bson:"queues" codec:"queues"`
}

func (*MessageGlobal) CollectionName() string {
	return "MessageGlobal"
}

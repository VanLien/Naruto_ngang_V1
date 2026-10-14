package codec

import "errors"

var (
	NoSuchMsgType = errors.New("codec: no such msg type")
	TooLargeMsg   = errors.New("codec: too large msg")
	InvalidHead   = errors.New("codec: invalid header")
)

type Codec interface {
	Recv() (int32, interface{}, error)
	Send(msg interface{}) error
	Close() error
}

//type Protocol interface {
//	command.MsgRegisterGetter
//
//	NewCodec(rwc io.ReadWriteCloser) (Codec, error)
//}

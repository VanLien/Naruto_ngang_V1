package util

import (
	"bytes"

	"tjgame/ugorji_go/codec"
)

var handle = &codec.MsgpackHandle{RawToString: true}

func MsgPack(v interface{}) ([]byte, error) {
	buf := bytes.NewBuffer(make([]byte, 0, 64))
	err := codec.NewEncoder(buf, handle).Encode(v)
	return buf.Bytes(), err
}

func MsgUnpack(data []byte, v interface{}) error {
	return codec.NewDecoderBytes(data, handle).Decode(v)
}

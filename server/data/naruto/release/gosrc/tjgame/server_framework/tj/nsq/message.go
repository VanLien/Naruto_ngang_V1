package nsq

import (
	"bytes"
	"encoding/hex"
	"io/ioutil"
	"math/rand"
	"tjgame/server_framework/tj/log"
	"tjgame/ugorji_go/codec"
)

// like https://github.com/msgpack-rpc/msgpack-rpc/blob/master/spec.md
//Request Message
//[type, msgid, method, params]
//
//Response Message
//[type, msgid, error, result]
//
//Notification Message
//[type, method, params]

const (
	REQUEST  = 0
	RESPONSE = 1
	NOTIFY   = 2
)

type RPCMessageREQ struct {
	*rpcMessage
}

func (m *RPCMessageREQ) Method() string {
	return m.Arg1
}

func (m *RPCMessageREQ) Params() []byte {
	return m.Arg2
}

func (m *RPCMessageREQ) ContainerID() string {
	return m.Arg3
}

type RPCMessageRESP struct {
	*rpcMessage
}

func (m *RPCMessageRESP) Error() string {
	return m.Arg1
}

func (m *RPCMessageRESP) Result() []byte {
	return m.Arg2
}

type RPCMessageNTF struct {
	*rpcMessage
}

func (m *RPCMessageNTF) Params() []byte {
	return m.Arg2
}

func NewMessageReq(msgID uint32, containerID, method string, params []interface{}) *RPCMessageREQ {
	return &RPCMessageREQ{
		rpcMessage: &rpcMessage{
			MsgType: REQUEST,
			MsgID:   msgID,
			Arg1:    method,
			Arg2:    Pack(params),
			Arg3:    containerID,
		},
	}
}

func PackMessageReq(msgID uint32, containerID, method string, params []interface{}) []byte {
	msg := &rpcMessage{
		MsgType: REQUEST,
		MsgID:   msgID,
		Arg1:    method,
		Arg2:    Pack(params),
		Arg3:    containerID,
	}
	return packHint(msg, len(msg.Arg2)+32)
}

func PackMessageResp(msgID uint32, error string, result []byte) []byte {
	return Pack(&rpcMessage{
		MsgType: RESPONSE,
		MsgID:   msgID,
		Arg1:    error,
		Arg2:    result,
	})
}

// NOTE: could not use it in msgpack-rpc style
func PackMessageNotify(method string, params []interface{}) []byte {
	msg := &rpcMessage{
		MsgType: NOTIFY,
		Arg1:    method,
		Arg2:    Pack(params),
	}
	return packHint(msg, len(msg.Arg2)+32)
}

type rpcMessage struct {
	_struct struct{} `codec:",toarray"`

	MsgType uint8
	MsgID   uint32
	Arg1    string
	Arg2    []byte // need twice unpack
	Arg3    string
}

var handle = &codec.MsgpackHandle{RawToString: true}

func init() {
	handle.Raw = true
}

// ref http://ugorji.net/blog/go-codec-primer
func packHint(msg interface{}, cap int) []byte {
	buf := bytes.NewBuffer(make([]byte, 0, cap))
	enc := codec.NewEncoder(buf, handle)
	if err := enc.Encode(msg); err != nil {
		log.Warning("nsq message pack err:", err)
		return nil
	}
	return buf.Bytes()
}

func Pack(msg interface{}) []byte {
	return packHint(msg, 64)
}

func UnpackMessage(buf []byte) interface{} {
	//log.Debug(buf)
	v := &rpcMessage{}
	dec := codec.NewDecoderBytes(buf, handle)
	if err := dec.Decode(v); err != nil {
		log.Warning("nsq message unpack err:", err)
		dump(buf)
		return nil
	}
	//log.Debugf("%#v\n", v)

	switch v.MsgType {
	case REQUEST:
		return &RPCMessageREQ{v}
	case RESPONSE:
		return &RPCMessageRESP{v}
	case NOTIFY:
		return &RPCMessageNTF{v}
	}
	return v
}

func UnpackParams(buf []byte, body interface{}) error {
	dec := codec.NewDecoderBytes(buf, handle)
	if err := dec.Decode(body); err != nil {
		return err
	}
	return nil
}

func dump(data []byte) {
	p := make([]byte, 8)
	if _, err := rand.Read(p); err != nil {
		return
	}
	filename := "dump_" + hex.EncodeToString(p)
	ioutil.WriteFile(filename, data, 0770)
	log.Infof("dump file %s", filename)
}

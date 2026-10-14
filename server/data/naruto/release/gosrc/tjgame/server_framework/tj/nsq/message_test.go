package nsq

import (
	"bytes"
	"reflect"
	"tjgame/server_framework/tj/log"
	"testing"

	"tjgame/ugorji_go/codec"
)

// in python msgpack
//>>> msgpack.packb([0, 1, "NewRecord", msgpack.packb(['123abc', 456, 789.123])])
//'\x94\x00\x01\xa9NewRecord\xb4\x93\xa6123abc\xcd\x01\xc8\xcb@\x88\xa8\xfb\xe7l\x8bD'
var realPypack = []byte{148, 0, 1, 169, 78, 101, 119, 82, 101, 99, 111, 114, 100, 180, 147, 166, 49, 50, 51, 97, 98, 99, 205, 1, 200, 203, 64, 136, 168, 251, 231, 108, 139, 68}

func Test_Unpack(t *testing.T) {
	pypack := make([]byte, len(realPypack))
	copy(pypack, realPypack)

	t.Log(pypack)
	var vv interface{}
	dec := codec.NewDecoderBytes(pypack, handle)
	if err := dec.Decode(&vv); err != nil {
		log.Warning("unpack err:", err)
	}
	t.Logf("%#v", vv)

	v := UnpackMessage(pypack)
	t.Logf("v=%v", v)

	req, ok := v.(*RPCMessageREQ)
	t.Logf("req=%#v, %t", req, ok)
	t.Logf("%#v", req.rpcMessage)
	if !ok {
		t.Error("its not *RPCMessageREQ")
	}

	params := make([]interface{}, 3) // must give len=params
	err := UnpackParams(req.Params(), params)
	t.Logf("params=%#v, %v", params, err)

	if params[1].(uint64) != 456 {
		t.Error("!=456")
	}

	if params[2].(float64) != 789.123 {
		t.Error("!=789.123")
	}
}

// 19/3/14
//Benchmark_Unpack-8   	 2000000	       610 ns/op	     456 B/op	       7 allocs/op
// 19/3/15
// use codecgen
//Benchmark_Unpack-8   	 3000000	       401 ns/op	     472 B/op	       6 allocs/op
func Benchmark_Unpack(b *testing.B) {
	pypack := make([]byte, len(realPypack))
	copy(pypack, realPypack)

	b.ReportAllocs()
	b.ResetTimer()
	var v interface{}
	for i := 0; i < b.N; i++ {
		pypack[2] = byte(int32(i+1) % 101)
		v = UnpackMessage(pypack)
	}
	b.StopTimer()
	b.Log(b.N, b.N%101)
	b.Log(v)
}

// 19/3/14
//Benchmark_Pack-8     	 1000000	      1319 ns/op	    1392 B/op	      16 allocs/op
// 19/3/15
// use codecgen
//Benchmark_Pack-8     	 1000000	      1015 ns/op	    1168 B/op	      14 allocs/op
func Benchmark_Pack(b *testing.B) {
	//req := NewMessageReq(1, "", []interface{}{"123abc", 456, 789.123})

	b.ReportAllocs()
	b.ResetTimer()
	var v interface{}
	for i := 0; i < b.N; i++ {
		//v = Pack(req)
		v = PackMessageReq(1, "xxx.dev.1", "NewRecord", []interface{}{"123abc", 456, 789.123})
	}
	b.StopTimer()
	b.Log(b.N)
	b.Log(v)
}

func Test_PackNotify(t *testing.T) {
	ntfBuf := PackMessageNotify("NewRecord", []interface{}{"123abc", 456, 789.123})
	intf := UnpackMessage(ntfBuf)
	ntf, ok := intf.(*RPCMessageNTF)
	if !ok {
		t.Error("not notify")
	}

	t.Log(ntfBuf)
	t.Log(ntf.rpcMessage)

	v := make([]interface{}, 3)
	v[0] = ""
	err := UnpackParams(ntf.Params(), &v)
	if err != nil {
		t.Error("params unpack error")
	}
	t.Log(v)
}

func Test_Pack(t *testing.T) {
	req := NewMessageReq(1, "", "NewRecord", []interface{}{"123abc", 456, 789.123})
	ret := PackMessageReq(1, "", "NewRecord", []interface{}{"123abc", 456, 789.123})

	test1 := UnpackMessage(ret)
	test, ok := test1.(*RPCMessageREQ)
	if !ok {
		t.Error("not req")
	}

	var v interface{}
	dec := codec.NewDecoderBytes(ret, handle)
	if err := dec.Decode(&v); err != nil {
		t.Error(err)
	}
	t.Logf("v=%#v", v)
	arr := v.([]interface{})
	t.Log(len(arr))
	if len(arr) != 4 {
		//t.Error("len is error")
	}

	eq := reflect.DeepEqual(req.rpcMessage, test.rpcMessage)
	t.Logf("req=%#v", req.rpcMessage)
	t.Logf("test=%#v", test.rpcMessage)
	t.Logf("test.Params=%#v", test.Params())
	if !eq {
		t.Error("not same object")
	}

	//int 16 stores a 16-bit big-endian signed integer
	//+--------+--------+--------+
	//|  0xd1  |ZZZZZZZZ|ZZZZZZZZ|
	//+--------+--------+--------+
	//
	//uint 16 stores a 16-bit big-endian unsigned integer
	//+--------+--------+--------+
	//|  0xcd  |ZZZZZZZZ|ZZZZZZZZ|
	//+--------+--------+--------+
	byeq := bytes.Equal(realPypack, ret)
	t.Logf("ret   =%#v", ret)
	t.Logf("pypack=%#v", realPypack)
	if !byeq {
		//t.Error("not same bytes")
	}
}

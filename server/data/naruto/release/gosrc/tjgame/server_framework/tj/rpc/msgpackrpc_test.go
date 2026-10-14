package rpc

import (
	"fmt"
	"testing"
)

type Resolver struct {
}

func (*Resolver) NewRecord(playID int, play []byte, result *string) error {
	fmt.Println("rpc: play len", playID, len(play), play)
	*result = "hello,world"
	return nil
}

func Test_PingPong(t *testing.T) {
	serv := NewMsgpackRPCServer()
	serv.Register(&Resolver{})
	serv.Init(":4321")
	go serv.Start()
	defer serv.Stop()

	client := NewMsgpackRPCClient(":4321")
	defer client.Close()

	s := ""
	var ss interface{} = &s
	ret, err := client.Call("NewRecord", &s, 1, []byte{2, 3, 4, 5})
	t.Log(s, ret, ss)
	t.Log(err)
	if s != "hello,world" || err != nil {
		t.Error("result error")
	}

	s = ""
	ss = &s
	ret, err = client.Call("NewRecord", &s, 1)
	t.Log(s, ret, ss)
	t.Log(err)
	if s != "" || err == nil {
		t.Error("no error be catched")
	}

	resp := <-client.CallAsync("NewRecord", &s, 2, "abc")
	t.Log(resp.Result, *resp.Result.(*string))
	t.Log(resp.Error)
}

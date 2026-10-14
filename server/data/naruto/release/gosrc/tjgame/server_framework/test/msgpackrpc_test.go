package test

import (
	"fmt"
	"reflect"
	"runtime"
	"tjgame/server_framework/tj/log"
	"sync"
	"testing"

	"tjgame/server_framework/tj/rpc"
)

var TestInBench = false

type test_resolver struct {
}

func (*test_resolver) NewRecord(playID int, play []byte, result *map[string]string) error {
	if !TestInBench {
		fmt.Println("rpc: play len", playID, len(play), play)
	}
	(*result)["Result"] = "hello,world"
	(*result)["server_key"] = "key1," + fmt.Sprintf("%d", playID)
	return nil
}

type record_result struct {
	Result string
	XX     string `codec:"server_key"`
}

func setupMsgpackService() (*rpc.MsgpackRPCServer, *rpc.MsgpackRPCClient) {
	serv := rpc.NewMsgpackRPCServer()
	serv.Register(&test_resolver{})
	serv.Init(":4321")
	go serv.Start()

	client := rpc.NewMsgpackRPCClient(":4321")

	return serv, client

}

func Test_PingPong(t *testing.T) {
	serv, client := setupMsgpackService()
	defer serv.Stop()
	defer client.Close()

	ret := &record_result{}
	t.Log(client.Call("NewRecord", ret, 10, "0000"))

	result := <-client.CallAsync("NewRecord", ret, 11, "1111")
	resp, err := result.Result, result.Error
	t.Logf("ret=%#v\n", ret)
	t.Logf("resp=%#v\n", resp)
	if v, ok := resp.(*map[string]string); ok {
		t.Log(v)
	}
	t.Log("err=", err)

	vv, ok := resp.(*record_result)
	if !ok {
		t.Errorf("not record_result type")
	}

	cmp := &record_result{
		"hello,world",
		"key1",
	}
	if !reflect.DeepEqual(vv, cmp) {
		t.Errorf("record_result value mismatch")
	}
}

func Benchmark_PingPong(b *testing.B) {
	serv, client := setupMsgpackService()
	defer serv.Stop()
	defer client.Close()

	TestInBench = true
	log.Init("bench_msgpackrpc", log.WARNING)
	wg := &sync.WaitGroup{}
	wg.Add(b.N)
	data := RandBytes(512)
	ret := &record_result{}

	b.ReportAllocs()
	b.StartTimer()
	var result interface{}
	var err error
	for i := 0; i < b.N; i++ {
		fu := client.CallAsync("NewRecord", ret, 11, data)
		go func() {
			resp := <-fu
			result, err = resp.Result, resp.Error
			wg.Done()
		}()
	}
	wg.Wait()
	runtime.GC()
	b.StopTimer()

	b.Log(result)
	b.Log(err)
}

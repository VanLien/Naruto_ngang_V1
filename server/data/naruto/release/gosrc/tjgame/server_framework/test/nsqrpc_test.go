package test

import (
	"fmt"
	"math/rand"
	"reflect"
	"runtime"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/nsq"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/service/caller"
	"sync"
	"testing"
)

type Test_service struct {
	*service.Service
}

func (*Test_service) NewRecord(playID int, play []byte) (map[string]string, error) {
	resp := make(map[string]string)
	resp["Result"] = "hello,world,service"
	resp["server_key"] = "key_1"
	return resp, nil
}

type remoteService struct {
	service.IService
	caller service.ICaller
}

func (s *remoteService) Caller() service.ICaller {
	return s.caller
}

func (s *remoteService) Init() bool {
	for _, info := range s.Base().Stub() {
		s.caller.Register(*info)
	}
	return s.Base().Init()
}

func (s *remoteService) Start() bool {
	return s.Base().Start()
}

var letterRunes = []byte("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

func RandBytes(n int) []byte {
	b := make([]byte, n)
	for i := range b {
		b[i] = letterRunes[rand.Intn(len(letterRunes))]
	}
	return b
}

var idx = 0

func setupNSQServer() (*nsq.NSQRPCServer, *nsq.NSQRPCClient) {
	serv := nsq.NewNSQRPCServer("test_pingpong")
	serv.Register(&test_resolver{})
	serv.RegisterName("test", &test_resolver{})
	serv.Init("192.168.1.125:4150", "http://192.168.1.125:4161/")
	go serv.Start()

	idx += 1
	client := nsq.NewNSQRPCClient(fmt.Sprintf("test_pingpong_client%d", idx))
	client.Connect("192.168.1.125:4150")

	return serv, client
}

func setupNSQService() service.IService {
	svc := &Test_service{
		Service: service.NewService(&service.Option{
			Name: "test_pingpong_service",
		}, nil),
	}
	svc.Register(svc, "NewRecord")

	serv := nsq.NewNSQRPCServer("test_pingpong_server")
	serv.RegisterServiceStub(svc, svc.Stub())
	serv.Init("192.168.1.125:4150", "http://192.168.1.125:4161/")
	go serv.Start()

	idx += 1
	client := nsq.NewNSQRPCClient(fmt.Sprintf("test_pingpong_client%d", idx))
	client.Connect("192.168.1.125:4150")

	cl := &caller.RPCCaller{
		Client: client,
	}

	rsvc := &remoteService{
		svc,
		cl,
	}
	rsvc.Init()
	rsvc.Start()
	return rsvc
}

func Test_NSQPingPong(t *testing.T) {
	svc, client := setupNSQServer()
	defer svc.Stop()
	defer client.Close()

	NewRecord := caller.NewFuncServiceInfo(caller.RPC, "test_pingpong", &test_resolver{}, "NewRecord", nil)

	ret := &record_result{}
	t.Log("NewRecord=")
	t.Log(client.ServiceCall(NewRecord, ret, 10, "0000"))

	resp, err := client.ServiceCall(NewRecord, ret, 11, "1111")
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
		"key1,11",
	}
	if !reflect.DeepEqual(vv, cmp) {
		t.Errorf("record_result value mismatch")
	}
}

func Test_NSQPingPongService(t *testing.T) {
	svc := setupNSQService()
	defer svc.Stop()

	t.Log("NewRecord=")
	t.Log(service.Call(svc, "NewRecord", 10, "0000"))
	resp, err := service.Call(svc, "NewRecord", 10, "0000")
	resp, err = service.Call(svc, "NewRecord", 10, "0000")
	if err != nil {
		t.Error(err)
	}

	cmp := map[string]string{
		"Result":     "hello,world,service",
		"server_key": "key_1",
	}
	if !reflect.DeepEqual(resp, cmp) {
		t.Errorf("record_result value mismatch")
	}
}

func xxBenchmark_NSQPingPong(b *testing.B) {
	svc, client := setupNSQServer()
	defer func() {
		log.Warning("bench finished")
		client.Close()
		svc.Stop()
	}()

	// TODO: 50000 had error: msg 49991 request err: not connected
	//b.N = 1000
	TestInBench = true
	//log.Init("bench_nsqrpc", log.DEBUG)
	log.Init("bench_nsqrpc", log.WARNING)
	wg := &sync.WaitGroup{}
	wg.Add(b.N)
	data := RandBytes(512)
	ret := &record_result{}
	NewRecord := caller.NewFuncServiceInfo(caller.RPC, "test_pingpong", &test_resolver{}, "NewRecord", nil)

	b.ReportAllocs()
	b.StartTimer()
	var result interface{}
	var err error
	for i := 0; i < b.N; i++ {
		go func() {
			result, err = client.ServiceCall(NewRecord, ret, 11, data)
			wg.Done()
		}()
	}
	wg.Wait()
	runtime.GC()
	b.StopTimer()

	b.Log(result)
	b.Log(err)
}

func Benchmark_NSQPingPongService(b *testing.B) {
	svc := setupNSQService()
	defer svc.Stop()

	// TODO: 50000 had error: msg 49991 request err: not connected
	//b.N = 1000
	TestInBench = true
	//log.Init("bench_nsqrpc", log.DEBUG)
	log.Init("bench_nsqrpc_service", log.WARNING)
	wg := &sync.WaitGroup{}
	wg.Add(b.N)
	data := RandBytes(512)

	b.ReportAllocs()
	b.StartTimer()
	var result interface{}
	var err error
	for i := 0; i < b.N; i++ {
		go func() {
			result, err = service.Call(svc, "NewRecord", 10, data)
			wg.Done()
		}()
	}
	wg.Wait()
	runtime.GC()
	b.StopTimer()

	b.Log(result)
	b.Log(err)
}

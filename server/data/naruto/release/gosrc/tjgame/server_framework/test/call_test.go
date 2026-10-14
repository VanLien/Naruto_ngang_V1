package test

import (
	"errors"
	"fmt"
	"runtime"
	"strconv"
	"sync"
	"testing"
	"time"

	"tjgame/server_framework/tj/service"
)

type test_service struct {
	*service.Service
}

func (s *test_service) Init() bool {
	//s.RegisterWithNew("static_test", static_test, nil)
	//s.RegisterWithNew("static_wait_test", static_wait_test, nil)
	s.Register(s, "Method_test")
	s.Register(s, "Method_wait_test")

	if s.Service.Init() {
		return true
	}
	return false
}

func (s *test_service) Method_test(a int, b string) (int, error) {
	fmt.Println("in Method_test", a, b)
	n, _ := strconv.Atoi(b)
	return a + int(n), errors.New("no err")
}

func (s *test_service) Method_wait_test(a int, b string) (interface{}, error) {
	//fmt.Println("in static_wait_test", a, b)
	<-time.After(2 * time.Second)
	//fmt.Println("in static_wait_test timer ok", a, b)

	n, _ := strconv.Atoi(b)
	return a + int(n), nil
}

func static_test(a int, b string) (interface{}, error) {
	if a == 11 {
		fmt.Println("in static_test", a, b)
	}
	n, _ := strconv.Atoi(b)
	return a + int(n), nil
}

func static_wait_test(a int, b string) (interface{}, error) {
	//fmt.Println("in static_wait_test", a, b)
	<-time.After(2 * time.Second)
	//fmt.Println("in static_wait_test timer ok", a, b)

	n, _ := strconv.Atoi(b)
	return a + int(n), nil
}

func setupService() service.IService {
	svc := &test_service{service.NewService(&service.Option{Name: "test"}, nil)}
	svc.Init()
	svc.Start()
	return svc
}

func Test_CallAsync(t *testing.T) {
	svc := setupService()

	//fu := service.CallAsync(svc, "static_test", 11, "22")
	//result, err := fu.Get()
	//t.Log(result)
	//t.Log(err)
	//if result.(int) != 33 || err != nil {
	//	t.Error("result error")
	//}

	fu := service.CallAsync(svc, "Method_test", 11, "22")
	result, err := fu.Get()
	t.Log(result)
	t.Log(err)
	if result.(int) != 33 || err.Error() != "no err" {
		t.Error("result error")
	}
}

func Test_Call(t *testing.T) {
	svc := setupService()

	//result, err := service.Call(svc, "static_test", 11, "22")
	//t.Log(result)
	//t.Log(err)
	//if result.(int) != 33 || err != nil {
	//	t.Error("result error")
	//}

	result, err := service.Call(svc, "Method_test", 11, "22")
	t.Log(result)
	t.Log(err)
	if result.(int) != 33 || err.Error() != "no err" {
		t.Error("result error")
	}
}

func Test_TypeCheck(t *testing.T) {
	svc := setupService()

	//result, err := service.Call(svc, "static_test", int32(11), "22")
	//t.Log(result)
	//t.Log(err)
	//if result != nil || err.Error() != "reflect: Call using int32 as type int" {
	//	t.Error("result error")
	//}

	result, err := service.Call(svc, "Method_test", 11, 22)
	t.Log(result)
	t.Log(err)
	if result != nil || err.Error() != "reflect: Call using int as type string" {
		t.Error("result error")
	}
}

func Test_CallWithTimeout(t *testing.T) {
	svc := setupService()

	start := time.Now()
	result, err := service.Call(svc, "Method_wait_test", 11, "22")
	t.Log(time.Now().Sub(start), result)
	t.Log(time.Now().Sub(start), err)
	if result.(int) != 33 || err != nil {
		t.Error("result error")
	}

	start = time.Now()
	result, err = service.CallWithTimeout(svc, "Method_wait_test", time.Second, 11, "22")
	t.Log(time.Now().Sub(start), result)
	t.Log(time.Now().Sub(start), err)
	if result != nil || err != service.ErrTimeout {
		t.Error("result error")
	}

	start = time.Now()
	result, err = service.CallWithTimeout(svc, "Method_wait_test", 3*time.Second, 11, "22")
	t.Log(time.Now().Sub(start), result)
	t.Log(time.Now().Sub(start), err)
	if result.(int) != 33 || err != nil {
		t.Error("result error")
	}

	start = time.Now()
	result, err = service.CallWithTimeout(svc, "Method_wait_test", 2*time.Second, 11, "22")
	t.Log("who first?", time.Now().Sub(start), result)
	t.Log("who first?", time.Now().Sub(start), err)
}

func Benchmark_NativeCall(b *testing.B) {
	b.ReportAllocs()

	b.StartTimer()
	for i := 0; i < b.N; i++ {
		static_test(22, "33")
	}
	runtime.GC()
	b.StopTimer()
}

func Benchmark_NativeCallInGo(b *testing.B) {
	b.ReportAllocs()
	wg := &sync.WaitGroup{}
	b.N = 100000

	b.StartTimer()
	wg.Add(b.N)
	for i := 0; i < b.N; i++ {
		go func() {
			static_test(22, "33")
			wg.Done()
		}()
	}
	wg.Wait()
	runtime.GC()
	b.StopTimer()
}

func Benchmark_Call(b *testing.B) {
	b.ReportAllocs()

	svc := setupService()
	b.StartTimer()
	for i := 0; i < b.N; i++ {
		service.Call(svc, "static_test", 22, "33")
	}
	runtime.GC()
	b.StopTimer()
}

func Benchmark_CallInGo(b *testing.B) {
	b.ReportAllocs()
	wg := &sync.WaitGroup{}
	b.N = 100000

	svc := setupService()

	b.StartTimer()
	wg.Add(b.N)
	for i := 0; i < b.N; i++ {
		fu := service.CallAsync(svc, "static_test", 22, "33")
		go func() {
			fu.Get()
			wg.Done()
		}()
	}
	wg.Wait()
	runtime.GC()
	b.StopTimer()
}

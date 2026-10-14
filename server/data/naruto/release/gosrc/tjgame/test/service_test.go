package main

import (
	"fmt"
	"io/ioutil"
	"tjgame/mgo.v2/bson"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services"
	storage2 "tjgame/services/storage"
	"sync"
	"testing"
)

var (
	container *service.Container
	once      sync.Once
)

func startContainer() {
	once.Do(func() {
		container = service.NewContainer(service.ContainerOption{
			Name:       "container.test.1",
			Debug:      true,
			NSQLookupd: "http://192.168.1.125:4161/",
			Mainnsqd:   "192.168.1.125:4150",
			Services: []service.IOption{
				&service.Option{Name: "login.test.1", Dependent: []string{"game.dev.2", "storage.dev.2"}},
			},
		}, services.Factory)

		container.Init()
		container.Start()
	})
}

func Test_GameLogin(t *testing.T) {
	startContainer()
	defer container.Stop()
	//time.Sleep(time.Second * 10)

	storage := container.GetService("storage.dev.2")
	accountID := bson.ObjectIdHex("5c526f2980ae8814b681e8cd")
	query := bson.M{
		"account_id": accountID,
		"area":       2,
	}
	resp, err := service.Call(storage, "RoleGet", query)
	if err != nil {
		panic(err)
	}
	response := resp.(storage2.Response)
	role := response.Model
	data, err := util.MsgPack(role)
	t.Logf("length: %d\n", len(data))
	if err == nil {
		ioutil.WriteFile("role.data", data, 0644)
	}
}

//Benchmark_GameLogin/RoleGet-4         	   20000	     74099 ns/op
//Benchmark_GameLogin/DBRead-4          	   20000	     71700 ns/op
//Benchmark_GameLogin/Hello-4           	    3000	    338751 ns/op
func Benchmark_GameLogin(b *testing.B) {
	startContainer()
	//defer container.Stop()

	storage := container.GetService("storage.dev.2")
	game := container.GetService("game.dev.2")
	accountID := bson.ObjectIdHex("5c526f2980ae8814b681e8cd")
	roleID := bson.ObjectIdHex("5c526f2a80ae8814b681e8ce")
	query := bson.M{
		"account_id": accountID,
		"area":       2,
	}

	b.ResetTimer()

	b.Run("RoleGet", func(b *testing.B) {
		wg := &sync.WaitGroup{}
		wg.Add(b.N)
		b.ResetTimer()
		for i := 0; i < b.N; i++ {
			fu := service.CallAsync(storage, "RoleGet", query)
			go func() {
				_, err := fu.Get()
				if err != nil {
					b.Log(err)
				}
				wg.Done()
			}()
		}
		wg.Wait()
	})

	b.Run("DBRead", func(b *testing.B) {
		wg := &sync.WaitGroup{}
		wg.Add(b.N)
		b.ResetTimer()
		for i := 0; i < b.N; i++ {
			fu := service.CallAsync(storage, "DBRead", "Role", roleID, false)
			go func() {
				_, err := fu.Get()
				if err != nil {
					b.Log(err)
				}
				wg.Done()
			}()
		}
		wg.Wait()
	})

	b.Run("Hello", func(b *testing.B) {
		wg := &sync.WaitGroup{}
		wg.Add(b.N)
		b.ResetTimer()
		for i := 0; i < b.N; i++ {
			fu := service.CallAsync(game, "Hello", "test")
			go func() {
				_, err := fu.Get()
				if err != nil {
					b.Log(err)
				}
				wg.Done()
			}()
		}
		wg.Wait()
	})

	b.StopTimer()
}

//Benchmark_GameLogin_Call/RoleGet-4         	       5	 249580220 ns/op
//Benchmark_GameLogin_Call/DBRead-4          	       5	 249950200 ns/op
//Benchmark_GameLogin_Call/Hello-4           	       5	 250020120 ns/op

//Benchmark_GameLogin_Call/RoleGet-4         	      50	  24975844 ns/op
//Benchmark_GameLogin_Call/DBRead-4          	     100	  24999916 ns/op
//Benchmark_GameLogin_Call/Hello-4           	      50	  25001602 ns/op
func Benchmark_GameLogin_Call(b *testing.B) {
	startContainer()
	//defer container.Stop()

	storage := container.GetService("storage.dev.2")
	game := container.GetService("game.dev.2")
	accountID := bson.ObjectIdHex("5c526f2980ae8814b681e8cd")
	roleID := bson.ObjectIdHex("5c526f2a80ae8814b681e8ce")
	query := bson.M{
		"account_id": accountID,
		"area":       2,
	}

	//f, err := os.Create("GameLogin_Call.profile")
	//if err != nil {
	//	panic(err)
	//}
	//pprof.StartCPUProfile(f)

	b.ResetTimer()

	b.Run("RoleGet", func(b *testing.B) {
		for i := 0; i < b.N; i++ {
			_, err := service.Call(storage, "RoleGet", query)
			if err != nil {
				b.Log(err)
			}
		}
	})

	b.Run("DBRead", func(b *testing.B) {
		for i := 0; i < b.N; i++ {
			_, err := service.Call(storage, "DBRead", "Role", roleID, false)
			if err != nil {
				b.Log(err)
			}
		}
	})

	b.Run("Hello", func(b *testing.B) {
		for i := 0; i < b.N; i++ {
			_, err := service.Call(game, "Hello", "test")
			if err != nil {
				fmt.Println(err)
			}
		}
	})

	b.StopTimer()

	//pprof.StopCPUProfile()

}

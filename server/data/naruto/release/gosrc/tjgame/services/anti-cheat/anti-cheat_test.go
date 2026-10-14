package anti_cheat

import (
	"fmt"
	"io/ioutil"
	"os"
	"sync"
	"sync/atomic"
	"testing"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/game"

	mgo "tjgame/mgo.v2"
	"tjgame/mgo.v2/bson"
)

func loadTestPlayRecord(name string) (bson.ObjectId, []byte) {
	data, err := ioutil.ReadFile(name)
	if err != nil {
		panic(err)
	}
	r := struct {
		_struct struct{} `codec:",toarray"`
		Name    string
		Data    []byte
	}{}
	err = util.MsgUnpack(data, &r)
	if err != nil {
		panic(err)
	}
	return "", r.Data
}

func TestRunner(t *testing.T) {
	if err := os.Chdir("../../../../../release/anti_cheat"); err != nil {
		panic(err)
	}

	limit := 2
	records := make(chan *Record, 10)
	for i := 0; i < limit; i++ {
		go func(idx int) {
			//l := NewLuaState(scriptPath)
			//r := NewRunner(i+1, l)
			//for record := range records {
			//	r.Run(record)
			//}
			//r.Close()

			r := NewProxyRunner(idx, nil)
			if err := r.Start(); err != nil {
				t.Fatal(err)
			}
			for record := range records {
				r.Run(record)
			}
			r.Stop()
		}(i + 1)
	}

	// -------------------
	session, err := mgo.Dial("192.168.1.96:27018")
	if err != nil {
		panic(err)
	}
	defer session.Close()

	plays := make([]scheme.CraftPlayRecord, 0, 1024)
	err = session.DB("game_dev2").C("CraftPlayRecord").Find(nil).All(&plays)
	if err != nil {
		panic(err)
	}
	fmt.Printf("total plays %d\n", len(plays))
	count := 1
	var wg sync.WaitGroup
	wg.Add(len(plays) * count)
	var failed int32
	for i := 0; i < count; i++ {
		for j, play := range plays {
			go func(idx int, p scheme.CraftPlayRecord) {
				data, err := util.MsgPack(p)
				if err == nil {
					r := NewRecord(int64(idx), Craft, "game.dev.2", p.ID, data)
					go func() {
						r.Wait()
						wg.Done()
					}()
					records <- r
				} else {
					atomic.AddInt32(&failed, 1)
				}
			}(j, play)
		}
	}
	wg.Wait()
	close(records)
	t.Log("total", len(plays)*count, "faild", failed)
}

func TestProxyRunner_Run(t *testing.T) {
	names := []string{
		"craft_5da87e6a80ae886b3bfed668.play",
		"craft_5dade1b880ae8874698805e6.play",
	}
	datas := make([][]byte, 0, 10)
	for _, name := range names {
		_, data := loadTestPlayRecord(name)
		datas = append(datas, data)
	}

	if err := os.Chdir("../../../../../release/anti_cheat"); err != nil {
		panic(err)
	}

	records := make(chan *Record, 10)
	runner := NewProxyRunner(1, nil)
	if err := runner.Start(); err != nil {
		t.Fatal(err)
	}

	go func() {
		for r := range records {
			runner.Run(r)
		}
	}()

	var wg sync.WaitGroup
	wg.Add(len(datas))
	for i, data := range datas {
		r := NewRecord(int64(i), Craft, "game.dev.2", "xx", data)
		go func() {
			r.Wait()
			wg.Done()
		}()
		records <- r
	}

	wg.Wait()
	close(records)
	runner.Stop()
}

var (
	container *service.Container
	once      sync.Once
)

type factory struct{}

func (f factory) NewService(option service.IOption, container service.IContainer) service.IService {
	if option.Base().Name == "anticheat" {
		return NewService(option, container)
	}
	return game.NewService(option, container)
}

func startContainer() {
	once.Do(func() {
		container = service.NewContainer(service.ContainerOption{
			Name:       "container.test.1",
			Debug:      true,
			NSQLookupd: "http://192.168.1.125:4161/",
			NSQTcpAddresses: []string{
				"192.168.1.125:4150",
				"192.168.1.125:4140",
			},
			Services: []service.IOption{
				&service.Option{Name: "game.test.1", Dependent: []string{"anticheat"}},
			},
		}, factory{})

		container.Init()
		container.Start()
	})
}

func TestNewRunner(t *testing.T) {
	startContainer()
	session, err := mgo.Dial("192.168.1.96:27018")
	if err != nil {
		panic(err)
	}
	defer session.Close()

	plays := make([]scheme.CraftPlayRecord, 0, 1024)
	err = session.DB("game_dev2").C("CraftPlayRecord").Find(nil).All(&plays)
	if err != nil {
		panic(err)
	}
	//plays = plays[:200]
	t.Log(len(plays))

	count := 1
	s := container.GetService("anticheat")
	var wg sync.WaitGroup
	wg.Add(len(plays) * count)
	var failed int32
	for i := 0; i < count; i++ {
		for _, play := range plays {
			go func(p scheme.CraftPlayRecord) {
				data, err := util.MsgPack(p)
				if err == nil {
					service.Call(s, "NewCraftBattle", "test", p.ID, data)
				} else {
					atomic.AddInt32(&failed, 1)
				}
				wg.Done()
			}(play)
		}
	}
	wg.Wait()
	t.Log("total", len(plays)*count, "faild", failed)
}

func TestSimpleUnionFightForceResultHandler_ForceResult(t *testing.T) {
	startContainer()
	session, err := mgo.Dial("192.168.1.96:27018")
	if err != nil {
		panic(err)
	}
	defer session.Close()

	plays := make([]scheme.UnionFightPlayRecord, 0, 1024)
	err = session.DB("swq_test").C("UnionFightPlayRecord").Find(nil).All(&plays)
	if err != nil {
		panic(err)
	}
	//plays = plays[:1000]
	total := len(plays)
	t.Log(len(plays))

	s := container.GetService("anticheat")
	var wg sync.WaitGroup
	wg.Add(len(plays))
	var failed int32
	// 反作弊计算
	playsch := make(chan scheme.UnionFightPlayRecord, 10)
	var antiResult sync.Map
	go func() {
		for _, play := range plays {
			playsch <- play
		}
	}()
	for i := 0; i < 10; i++ {
		go func() {
			for play := range playsch {
				id := play.ID
				data, err := util.MsgPack(play)
				if err == nil {
					resp, err := service.Call(s, "NewUnionFightBattle", "test", id, data)
					if err == nil {
						result := resp.(UnionFightBattleResult)
						//fmt.Printf("play %s result %s\n", id, result.Result)
						_, loaded := antiResult.LoadOrStore(id, result.Result)
						if loaded {
							fmt.Printf("%s already has result", id)
						}
					} else {
						atomic.AddInt32(&failed, 1)
					}
				} else {
					atomic.AddInt32(&failed, 1)
					t.Fatalf("%s", err)
				}
				wg.Done()
			}
		}()
	}
	if failed > 0 {
		t.Fatalf("not all success, failed %d", failed)
	}
	wg.Wait()
	close(playsch)

	// 强判
	forceResult := make(map[document.ID]string)
	for _, play := range plays {
		var data []byte
		var err error
		data, err = util.MsgPack(play)
		if err == nil {
			r := NewRecord(1, UnionFight, "test", play.ID, data)
			err = r.ForceResult()
			if err == nil {
				forceResult[play.ID] = r.Result
			}
		} else {
			t.Fatalf("%s", err)
		}
	}

	// 对比结果
	unmatch := 0
	for _, play := range plays {
		id := play.ID
		result, ok := antiResult.Load(id)
		if !ok {
			t.Logf("play %s no anti result", id)
			unmatch += 1
		} else {
			if forceResult[id] != result.(string) {
				unmatch += 1
				t.Logf("play %s result unmatch", id)
			}
		}
	}

	rate := float64(total-unmatch) / float64(total) * 100.0
	t.Logf("total %d, unmatch %d, %.4f%%", total, unmatch, rate)
}

func TestCrossUnionFight(t *testing.T) {
	startContainer()
	session, err := mgo.Dial("192.168.1.96:27018")
	if err != nil {
		panic(err)
	}
	defer session.Close()

	plays := make([]scheme.CrossUnionFightPlayRecord, 0, 1024)
	playIDs := []document.ID{}
	playIDs = append(playIDs, document.ID(bson.ObjectIdHex("6167d1db6e95524b7d00af94")))

	for _, playID := range playIDs {
		play := scheme.CrossUnionFightPlayRecord{}
		err = session.DB("cross_dev2").C("CrossUnionFightPlayRecord").FindId(playID).One(&play)
		if err != nil {
			panic(err)
		}
		plays = append(plays, play)
	}
	t.Log(len(plays))

	count := 1
	s := container.GetService("anticheat")
	var wg sync.WaitGroup
	wg.Add(len(plays) * count)
	var failed int32
	for i := 0; i < count; i++ {
		for _, play := range plays {
			go func(p scheme.CrossUnionFightPlayRecord) {
				data, err := util.MsgPack(p)
				if err == nil {
					result, _ := service.Call(s, "NewCrossUnionFightBattle", p.RoleKey.GameKey, p.ID, data)
					t.Logf("result %v", result)
				} else {
					atomic.AddInt32(&failed, 1)
				}
				wg.Done()
			}(play)
		}
	}
	wg.Wait()
	t.Log("total", len(plays)*count, "faild", failed)
}

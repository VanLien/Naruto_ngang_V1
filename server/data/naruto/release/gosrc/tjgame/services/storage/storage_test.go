package storage

import (
	"fmt"
	"os"
	"runtime/pprof"
	"sync"
	"testing"
	"time"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/nsq"
	"tjgame/server_framework/tj/service"

	mgo "tjgame/mgo.v2"

	"tjgame/mgo.v2/bson"
)

var (
	c    *service.Container
	once sync.Once

	storage     *Storage
	onceStorage sync.Once
)

type factory struct {
	servs   map[string]func(service.IOption, service.IContainer) service.IService
	options map[string]func() interface{}
}

func (f *factory) NewOption(name string) interface{} {
	if f, ok := f.options[name]; ok {
		return f()
	}
	return new(service.Option)
}

// IFactory
func (f *factory) NewService(option service.IOption, container service.IContainer) service.IService {
	name := option.Base().Name
	serviceName, _, _ := service.SplitServiceName(name)
	newf, ok := f.servs[serviceName]
	if ok {
		return newf(option, container)
	}
	panic(fmt.Sprintf("unknown service %s", name))
}

func storageService() *Service {
	return c.GetService("storage.test.1").(*Service)
}

func startService() {
	fac := &factory{
		servs:   make(map[string]func(service.IOption, service.IContainer) service.IService),
		options: make(map[string]func() interface{}),
	}
	fac.servs[Name] = NewService

	// default is service.Option
	fac.options[Name] = func() interface{} { return new(Option) }

	c = service.NewContainer(service.ContainerOption{
		Name:       "test",
		NSQLookupd: "http://192.168.1.125:4161/",
		Mainnsqd:   "192.168.1.125:4150",

		Services: []service.IOption{&Option{
			Option: service.Option{
				Name: "storage.test.1",
			},
			MongoDB: "192.168.1.96:27018",
			DBName:  "game",
		}},
	}, fac)

	c.Init()
	c.Start()
}

func startStorage() {
	storage = NewStorage("192.168.1.96:27018", "game")
}

func TestStorage(t *testing.T) {
	onceStorage.Do(startStorage)

	t.Log("Range")
	elements, err := RankRangeQuery(storage, "Rank_fight", 1, 20, "")
	if err != nil {
		panic(err)
	}
	for i, element := range elements.([]bson.M) {
		t.Logf("rank %d name %s score %d %v", i, "Rank_fight", element["fighting_point"], element["top6_cards"])
	}

	t.Log("RangeByScore")
	elements, err = RankRangeByScoreQuery(storage, "Rank_fight", 10000, 1000)
	if err != nil {
		panic(err)
	}
	for i, element := range elements.([]bson.M) {
		t.Logf("rank %d name %s score %d %v", i, "Rank_fight", element["fighting_point"], element["top6_cards"])
	}

	t.Run("QueryNotExist", func(t *testing.T) {
		elements, err := RankRangeQuery(storage, "Rank_card1fight", 1, 20, "")
		if err != nil {
			t.Error(err)
		}
		for i, elem := range elements.([]bson.M) {
			t.Logf("rank %d score %d", i+1, elem["fighting_point"])
		}
	})
}

func TestService_AccountLogin(t *testing.T) {
	once.Do(startService)

	resp, err := service.Call(storageService(), "AccountLogin", "swq")
	if err != nil {
		t.Fatal(err)
	}
	t.Logf("%#v\n", resp)

	account := resp.(*Response).Model
	t.Logf("%v\n", account)
}

func TestServiceRPC(t *testing.T) {
	once.Do(startService)

	client := nsq.NewNSQRPCClient("storage.test.1_client")
	client.Connect("192.168.1.125:4150")
	defer client.Close()

	var err error

	var resp = &struct {
		Ret     bool          `codec:"ret"`
		Model   scheme.Role   `codec:"model"`
		Models  []scheme.Role `codec:"models"`
		Err     string        `codec:"err"`
		ErrType string        `codec:"err_type"`
	}{}
	_, err = client.Call("DBReadRangeBy", &resp, "Role", bson.M{"last_time": []float64{0, 1541993739.51}}, 0)

	if err != nil {
		panic(err)
	}
	t.Log(err)
	t.Log(len(resp.Models))
}

func TestSession_Get(t *testing.T) {
	once.Do(startService)

	session := storageService().session
	roleID := document.ID(bson.ObjectIdHex("5bdbc39d80ae8829b81ddf12"))
	var doc *Document
	var err error

	doc, err = session.Get("Role", roleID)
	if err != nil {
		panic(err)
	}
	t.Logf("address : %p", doc)

	doc, err = session.Get("Role", roleID)
	if err != nil {
		panic(err)
	}
	t.Logf("address : %p", doc)
}

func BenchmarkSession_Get(b *testing.B) {
	once.Do(startService)

	session := storageService().session
	roleID := document.ID(bson.ObjectIdHex("5c526f2a80ae8814b681e8ce"))
	var err error

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_, err = session.Get("Role", roleID)
		if err != nil {
			panic(err)
		}

		doc := NewDefaultDocument("Role")
		doc.SetID(roleID)
		err = doc.Load(storageService().storage, nil)
		if err != nil {
			panic(err)
		}
	}
}

func BenchmarkService_RoleGet(b *testing.B) {
	once.Do(startService)

	svc := storageService()
	accountID := document.ID(bson.ObjectIdHex("5c526f2980ae8814b681e8cd"))
	query := roleQuery{
		AccountID: accountID,
		Area:      2,
	}

	f, _ := os.Create("RoleGet.profile")
	pprof.StartCPUProfile(f)

	wg := &sync.WaitGroup{}
	wg.Add(b.N)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		fu := service.CallAsync(svc, "RoleGet", query)
		go func() {
			_, err := fu.Get()
			if err != nil {
				b.Log(err)
			}
			wg.Done()
		}()
	}
	wg.Wait()

	b.StopTimer()
	pprof.StopCPUProfile()
}

func TestService_MultipGetSlims(t *testing.T) {
	once.Do(startService)
	svc := storageService()

	t.Run("MultipGetSlimRoles", func(t *testing.T) {
		ids := []ID{document.ID(bson.ObjectIdHex("5cab197380ae8803e690cbae")), document.ID(bson.ObjectIdHex("5cb0240280ae8803e690d98d"))}
		roles, err := svc.MultipGetSlimRoles(ids)
		if err != nil {
			t.Fatal(err)
		}
		t.Logf("roles: %d\n", len(roles))
		for _, role := range roles {
			t.Logf("%#v\n", role)
		}
	})

	t.Run("MultipGetSlimCards", func(t *testing.T) {
		ids := []ID{document.ID(bson.ObjectIdHex("5cab28a280ae8803e690cbcc")), document.ID(bson.ObjectIdHex("5cab28a180ae8803e690cbc9"))}
		cards, err := svc.MultipGetSlimCards(ids)
		if err != nil {
			t.Fatal(err)
		}
		t.Logf("cards: %d\n", len(cards))
		for _, card := range cards {
			t.Logf("%#v\n", card)
		}
	})

	t.Run("GetSlimRole", func(t *testing.T) {
		id := document.ID(bson.ObjectIdHex("5cab197380ae8803e690cbae"))
		role, err := svc.GetSlimRole(id)
		if err != nil {
			t.Fatal(err)
		}
		t.Logf("%#v\n", role)
	})

	t.Run("GetSlimCard", func(t *testing.T) {
		id := document.ID(bson.ObjectIdHex("5cab28a280ae8803e690cbcc"))
		card, err := svc.GetSlimCard(id)
		if err != nil {
			t.Fatal(err)
		}
		t.Logf("%#v\n", card)
	})
}

func test(s *Storage, total int) {
	var wg sync.WaitGroup
	wg.Add(total)
	for j := 0; j < total; j++ {
		go func() {
			//time.Sleep(time.Second * time.Duration(rand.Intn(10)))
			s.exec("Test", func(collection *mgo.Collection) error {
				//return collection.Insert(bson.M{"test": 1})
				_, err := collection.Find(bson.M{"test": 1}).Count()
				if err != nil {
					log.Warningf("error %v", err)
				}
				return err
			})
			wg.Done()
		}()
	}
	wg.Wait()
}

func TestNewStorage(t *testing.T) {
	//url := "mongodb://192.168.1.62:27017,192.168.1.62:27018,192.168.1.62:27019/test_db?minPoolSize=1&&maxIdleTimeMS=3000"
	url := "mongodb://192.168.1.62:27017,192.168.1.62:27018,192.168.1.62:27019/test_db"
	storage := NewStorage(url, "test_db")
	storage.session.SetPoolLimit(10)
	storage.session.SetSafe(&mgo.Safe{WMode: "majority"})

	mgo.SetDebug(false)
	mgo.SetLogger(&logger{Logger: log.GetLogger()})

	defer storage.Close()

	total := 100
	for i := 0; i < total; i++ {
		test(storage, 100)
		t.Logf("%d.ok", i)
		time.Sleep(time.Second * 5)
	}

	time.Sleep(time.Second * 30)
}

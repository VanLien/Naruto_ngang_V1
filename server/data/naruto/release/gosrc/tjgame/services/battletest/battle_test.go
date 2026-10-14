package battletest

import (
	"net/http"
	"sync"
	"testing"

	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services"

	_ "net/http/pprof"
)

var (
	c    *service.Container
	once sync.Once
)

func startContainer() {
	c = service.NewContainer(service.ContainerOption{
		Name:       "test",
		Debug:      true,
		NSQLookupd: "http://192.168.1.125:4161/",
		Mainnsqd:   "192.168.1.125:4150",
		Services: []service.IOption{
			&service.Option{
				Name: "login.fake.1",
				Dependent: []string{
					"anticheat",
					"arena.dev.2",
					"craft.dev.2",
					"storage.dev.2",
				},
			},
		},
	}, services.Factory)

	c.Init()
	c.Start()
}

func TestNewBattleTest(t *testing.T) {
	once.Do(startContainer)

	go func() {
		_ = http.ListenAndServe("localhost:6060", nil)
	}()

	util.ReseedRandom()

	roles := make([]*Role, 0, 64)
	roles = append(roles, &Role{
		ID:      IdHex("5e0b3a6580ae8828b3235974"),
		GameKey: "game.dev.2",
	})
	roles = append(roles, &Role{
		ID:      IdHex("5e0b81ce80ae8828b32364ba"),
		GameKey: "game.dev.2",
	})
	roles = append(roles, &Role{
		ID:      IdHex("5e119c7880ae8828b325019d"), // LS0013
		GameKey: "game.dev.2",
	})
	roles = append(roles, &Role{
		ID:      IdHex("5e0b3bbd80ae8828b32359cf"),
		GameKey: "game.dev.2",
	})
	roles = append(roles, &Role{
		ID:      IdHex("5e17d74680ae8850c410a461"),
		GameKey: "game.dev.2",
	})
	roles = append(roles, &Role{
		ID:      IdHex("5e0b28ac80ae8828b32357a5"),
		GameKey: "game.dev.2",
	})
	roles = append(roles, &Role{
		ID:      IdHex("5e0b672080ae8828b3236290"), // LS003
		GameKey: "game.dev.2",
	})
	roles = append(roles, &Role{
		ID:      IdHex("5e0b25c380ae8828b323576c"), // swq
		GameKey: "game.dev.2",
	})

	for i := range roles {
		if err := roles[i].fetch(c.GetService(roles[i].Key("storage"))); err != nil {
			t.Log(err)
		}
	}
	RandomShuffleRoles(roles)
	matchs := make([][2]*Role, 0, len(roles)/2)
	for i := 0; i < len(roles)/2; i++ {
		matchs = append(matchs, [2]*Role{roles[i], roles[i+1]})
	}

	anticheat := c.GetService("anticheat")

	crafttest := NewBattleManager("craft", anticheat, "NewCraftBattle")
	crafttest.matchs = matchs
	crafttest.maker = &CraftPlayRecordMaker{services: map[string]service.IService{
		"craft.dev.2": c.GetService("craft.dev.2"),
	}}
	crafttest.Run()

	arenatest := NewBattleManager("arena", anticheat, "NewArenaBattle")
	arenatest.matchs = matchs
	arenatest.maker = &ArenaPlayRecordMaker{services: map[string]service.IService{
		"arena.dev.2": c.GetService("arena.dev.2"),
	}}
	arenatest.Run()

	gatetest := NewBattleManager("gate", anticheat, "NewGateBattle")
	gatetest.matchs = matchs
	gatetest.maker = &GatePlayRecordMaker{services: map[string]service.IService{
		"arena.dev.2": c.GetService("arena.dev.2"),
	}}
	gatetest.Run()

	t.Logf("%s: %s", crafttest.name, crafttest.statistics)
	t.Logf("%s: %s", arenatest.name, arenatest.statistics)
	t.Logf("%s: %s", gatetest.name, gatetest.statistics)
}

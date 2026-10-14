package onlinefight

import (
	"sync"
	"sync/atomic"
	"time"
	"tjgame/document"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/cross"
	"tjgame/services/cross/onlinefight/proto"
)

var discardBattleResult = &proto.BattleResult{}

type ground struct {
	pattern int
	name    string
	address string
	time    time.Time
	future  *service.Future

	*proto.BattleInfo

	callback func(*ground, *proto.BattleResult)

	placeholder bool   // 若True，表示是跨cross战斗，player2一方
	crossKey2   string // 只有跨cross匹配战斗才需要赋值
	timeouts    int    // 检查超时次数
}

func (g *ground) SetResult(result *proto.BattleResult) {
	if g.callback != nil {
		g.callback(g, result)
	}
}

type battleground struct {
	container service.IContainer
	checking  int32

	grounds     map[document.ID]*ground
	rolegrounds map[document.ID]*ground
	mu          sync.Mutex
}

func (g *battleground) Assign(name string, address string, pattern int, info *proto.BattleInfo, callback func(*ground, *proto.BattleResult), crossKey2 string) {
	ground := &ground{
		pattern:    pattern,
		name:       name,
		address:    address,
		time:       util.Now(),
		BattleInfo: info,
		callback:   callback,
		crossKey2:  crossKey2,
	}

	g.mu.Lock()
	defer g.mu.Unlock()
	g.grounds[ground.ID] = ground
	g.rolegrounds[ground.Role1.RoleID] = ground
	g.rolegrounds[ground.Role2.RoleID] = ground

	g.tryStartCheckingLoop()
}

func (g *battleground) PlaceHolder(id document.ID, name string, address string, pattern int, player1 *proto.Player, player2 *proto.Player) {
	ground := &ground{
		pattern: pattern,
		name:    name,
		address: address,
		time:    util.Now(),
		BattleInfo: &proto.BattleInfo{
			ID:    id,
			Role1: &player1.Competitor,
			Role2: &player2.Competitor,
		},
		placeholder: true,
	}

	g.mu.Lock()
	defer g.mu.Unlock()
	g.grounds[ground.ID] = ground
	g.rolegrounds[ground.Role1.RoleID] = ground
	g.rolegrounds[ground.Role2.RoleID] = ground

	g.tryStartCheckingLoop()
}

func (g *battleground) Remove(id document.ID) *ground {
	g.mu.Lock()
	defer g.mu.Unlock()
	return g.remove(id)
}

func (g *battleground) remove(id document.ID) *ground {
	ground := g.grounds[id]
	if ground != nil {
		delete(g.grounds, id)
		delete(g.rolegrounds, ground.Role1.RoleID)
		delete(g.rolegrounds, ground.Role2.RoleID)
	}
	return ground
}

func (g *battleground) GetGround(id document.ID) (*ground, *proto.Competitor) {
	g.mu.Lock()
	defer g.mu.Unlock()
	ground := g.rolegrounds[id]
	if ground == nil {
		return nil, nil
	}
	enemy := ground.Role1
	if enemy.RoleID == id {
		enemy = ground.Role2
	}
	return ground, enemy
}

func (g *battleground) tryStartCheckingLoop() {
	if atomic.CompareAndSwapInt32(&g.checking, 0, 1) {
		go g.startCheckingLoop()
	}
}

func (g *battleground) startCheckingLoop() {
	duration := 60 * time.Second
	t := time.NewTimer(duration)
	defer t.Stop()
	for {
		<-t.C
		if g.cleanZombie() {
			t.Reset(duration)
		} else {
			atomic.StoreInt32(&g.checking, 0)
			break
		}
	}
}

func (g *battleground) cleanZombie() bool {
	g.mu.Lock()
	defer g.mu.Unlock()

	timestamp := util.Now().Unix()
	discards := make([]document.ID, 0, 8)
	holder := 0
	for id, ground := range g.grounds {
		if ground.placeholder {
			holder += 1
		}
		if err := cross.ContainerServices(g.container, ground.name); err != nil {
			log.Warningf("ContainerServices %s error %v", ground.name, err)
			continue
		}

		discard := false
		if ground.future != nil {
			if !ground.future.Done() {
				discard = true
			} else {
				if _, err := ground.future.Get(); err != nil {
					log.Debugf("cleanZombie id %s discard, error %s", id, err)
					discard = true
				}
			}
		}
		if discard {
			ground.timeouts += 1
			if ground.placeholder && ground.timeouts < 2 { // placeholder 多一次检查
				discard = false
			}
		}

		if discard {
			discards = append(discards, id)
		} else {
			s := g.container.GetService(ground.name)
			ground.future = service.CallAsync(s, "CheckCrossOnlineBattleState", id, timestamp)
		}
	}

	for _, id := range discards {
		g := g.remove(id)
		go g.SetResult(discardBattleResult)
	}
	log.Infof("clean zombie, battles %d, discard %d, placeholder %d", len(g.grounds), len(discards), holder)
	return len(g.grounds) > 0
}

func newBattleGround(container service.IContainer) *battleground {
	return &battleground{
		container:   container,
		grounds:     make(map[document.ID]*ground),
		rolegrounds: make(map[document.ID]*ground),
	}
}

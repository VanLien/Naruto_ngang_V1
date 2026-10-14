/*
 * @Time     : 2020/6/18 14:39
 * @Author   : cancan
 * @File     : agentmgr_test.go
 * @Function :
 */

package manager

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"sync"
	"sync/atomic"
	"testing"
	"time"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/conf"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	anti_cheat "tjgame/services/anti-cheat"
)

type Define struct {
	service.ContainerOption `json:",inline"`
}

// ICustomJsonDefine
func (d *Define) GetExtend(opt interface{}, raw json.RawMessage) interface{} {
	name := opt.(*service.Option).Name
	serv, _, _ := service.SplitServiceName(name)
	var optEx interface{}
	if serv == anti_cheat.Name {
		optEx = new(anti_cheat.Option)
	}
	if optEx != nil {
		err := json.Unmarshal(raw, optEx)
		if err != nil {
			panic(err)
		}
		log.Debugf("GetExtend service %s %#v", name, optEx)
		return optEx
	}
	log.Debugf("GetExtend service %s %#v", name, opt)
	return opt
}

type factory struct{}

func (f *factory) NewService(option service.IOption, container service.IContainer) service.IService {
	name := option.Base().Name
	serviceName, _, _ := service.SplitServiceName(name)
	//if serviceName != anti_cheat.Name {
	//	panic(fmt.Sprintf("must be anti cheat service, expect %s, got %s", anti_cheat.Name, serviceName))
	//}
	//return anti_cheat.NewService(option, container)
	if serviceName == anti_cheat.Name {
		return anti_cheat.NewService(option, container)
	}
	if serviceName == "agent_test" {
		return NewTestService(option, container)
	}
	panic("no service")
}

func getPlay() (document.ID, interface{}) {
	data, err := ioutil.ReadFile("union_fight.record")
	if err != nil {
		return "", err
	}

	var model scheme.UnionFightPlayRecord

	err = util.MsgUnpack(data, &model)
	if err != nil {
		log.Info(err)
	}

	return model.ID, model
}

type TestService struct {
	*service.Service
}

func (t *TestService) Test() (bool, error) {
	return true, nil
}

func NewTestService(option service.IOption, container service.IContainer) service.IService {
	s := &TestService{
		Service: service.NewService(option, container),
	}
	s.Register(s, "Test")
	return s
}

var initRun sync.Once
var mgr *AgentManager
var Tester int
var TestNum int32
var FinishNum int32
var lock sync.Mutex

func BenchmarkAgentManager_SendPlay(b *testing.B) {
	initRun.Do(func() {
		name := "agent_test.dev.1"
		c := conf.LoadDefine(name, &Define{})
		define := c.(*Define)
		if define.Debug {
			log.Init(name, log.DEBUG)
		} else {
			log.Init(name, log.INFO)
		}
		log.Infof("%#v", define)
		container := service.NewContainer(define.ContainerOption, &factory{})
		container.Init()
		container.Start()
		agent := container.GetService("anticheat")
		mgr = NewAgentManager("agent_test.dev.1", "NewUnionFightBattle", agent)
		mgr.SetTimerDuration(time.Second)
		mgr.Start()
		_, model := getPlay()
		go func() {
			ticker := time.NewTicker(time.Second)
			for {
				<-ticker.C
				result := mgr.GetPlayResults()
				for k, v := range result {
					if v.Error != nil {
						mgr.SendPlay(v.ID, model)
					} else {
						atomic.AddInt32(&FinishNum, 1)
						fmt.Println(k, v)
					}
				}
				for atomic.LoadInt32(&FinishNum) == atomic.LoadInt32(&TestNum) {
					break
				}
			}
			ticker.Stop()
			mgr.Stop()
		}()
	})

	_, model := getPlay()
	lock.Lock()
	Tester++
	tNum := Tester
	lock.Unlock()
	for i := 0; i < b.N; i++ {
		playID := document.ID(fmt.Sprintf("%06d%06d", tNum, i))
		mgr.SendPlay(playID, model)
	}
	atomic.StoreInt32(&TestNum, int32(b.N))

	for atomic.LoadInt32(&FinishNum) == atomic.LoadInt32(&TestNum) {
		time.Sleep(time.Second)
	}

}

func Test_getPlay(t *testing.T) {
	playID, model := getPlay()
	fmt.Println(playID, model)
}

func runTest(name string, testNum int, tester int) {
	//name := "agent_test.dev.1"
	c := conf.LoadDefine(name, &Define{})
	define := c.(*Define)
	if define.Debug {
		log.Init(name, log.DEBUG)
	} else {
		log.Init(name, log.INFO)
	}
	log.Infof("%#v", define)
	container := service.NewContainer(define.ContainerOption, &factory{})
	container.Init()
	container.Start()
	agent := container.GetService("anticheat")
	mgr := NewAgentManager(name, "NewUnionFightBattle", agent)
	mgr.SetTimerDuration(time.Second)
	//testNum := 2000

	wg := &sync.WaitGroup{}
	wg.Add(testNum)
	runOver := false
	finNum := 0

	_, model := getPlay()
	timeoutError := 0
	fullError := 0
	waitError := 0
	go func() {
		mgr.Start()
		ticker := time.NewTicker(time.Second)
		checkNum := 0
		for !runOver {
			<-ticker.C
			log.Info("----------------------", checkNum, finNum)
			checkNum++
			result := mgr.GetPlayResults()
			for _, v := range result {
				if v.Error != nil {
					if v.Error.Error() == ErrTimeout.Error() {
						timeoutError++
					} else if v.Error.Error() == ErrAgentWaiting.Error() {
						waitError++
					} else if v.Error.Error() == "wait queue full" {
						fullError++
					}

					mgr.SendPlay(v.ID, model)
				} else {
					wg.Done()
					finNum++
				}
			}
		}
		ticker.Stop()
		mgr.Stop()
	}()
	startTime := time.Now()
	for i := 0; i < testNum; i++ {
		playID := document.ID(fmt.Sprintf("%d%011d", tester, i))
		m := model.(scheme.UnionFightPlayRecord)
		m.ID = playID
		mgr.SendPlay(playID, m)
	}

	wg.Wait()
	runOver = true

	endTime := time.Now()
	log.Infof("------------------------- test %d cost %v timeout %d full %d wait %d",
		testNum, endTime.Sub(startTime), timeoutError, fullError, waitError)
	//mgr.printResult()
}

func TestAgentManager_SendPlay(t *testing.T) {
	wg := sync.WaitGroup{}
	wg.Add(2)
	testNum := 2
	go func() {
		runTest("agent_test.dev.1", testNum, 1)
		wg.Done()
	}()
	go func() {
		runTest("agent_test.dev.2", testNum, 2)
		wg.Done()
	}()
	wg.Wait()
}

/*
单个线程
test 1000 cost 1m14.270248s timeout 55 full 1337 wait 25753
test 2000 cost 2m26.565383s timeout 104 full 7435 wait 121151


两个线程 1000
test 500 cost 1m14.3642534s timeout 58 full 958 wait 12866
test 500 cost 1m17.364425s timeout 55 full 1053 wait 14683

test 500 cost 54.321107s timeout 46 full 781 wait 9896
test 500 cost 1m15.4303144s timeout 48 full 1139 wait 16238

test 500 cost 1m16.2093589s timeout 44 full 1142 wait 16116
test 500 cost 54.2031003s timeout 47 full 630 wait 10107

两个线程 2000
test 1000 cost 2m19.4409756s timeout 49 full 4491 wait 70319
test 1000 cost 2m24.3522565s timeout 57 full 2503 wait 49560

test 1000 cost 2m6.6152419s timeout 56 full 3928 wait 60869
test 1000 cost 2m24.572269s timeout 49 full 3724 wait 58718

test 1000 cost 2m0.4648902s timeout 58 full 3299 wait 52049
test 1000 cost 2m26.4673775s timeout 59 full 4376 wait 65718
*/

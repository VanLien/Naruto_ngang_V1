package manager

import (
	"errors"
	"sort"
	"sync"
	"sync/atomic"
	"time"
	"tjgame/document"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	anti_cheat "tjgame/services/anti-cheat"
	"unsafe"
)

const (
	agentTimeout = 5 * time.Second
	sendMax      = 1000000
)

var (
	ErrTimeout      = errors.New("timeout")
	ErrAgentWaiting = errors.New("agent waiting")
)

type Result struct {
	ID     document.ID
	Error  error
	Result interface{}
}

func newAgentWaitingResult(id document.ID) Result {
	return Result{
		ID:    id,
		Error: ErrAgentWaiting,
	}
}

type AgentFuture struct {
	*service.Future

	id             document.ID // play.id
	model          []byte
	timestamp      time.Time
	firstTimestamp time.Time
	result         *Result
	sendTimes      int
	waitResend     bool
}

type AgentManager struct {
	name   string
	method string
	agent  service.IService

	futures sync.Map
	results sync.Map

	running   int32
	sendLimit int32

	timerDuration  time.Duration
	lastAvgRespDur time.Duration
	lastSendTime   time.Time

	lock sync.Mutex
	//fus []*AgentFuture
}

func (m *AgentManager) SetTimerDuration(d time.Duration) {
	if atomic.LoadInt32(&m.running) == 1 {
		log.Warningf("agent is running can not set timer")
		return
	}
	// 最小不能小于 50 毫秒
	if d < time.Millisecond*50 {
		log.Warningf("set agent timer too short")
		return
	}
	m.timerDuration = d
}

func (m *AgentManager) Start() bool {
	if atomic.CompareAndSwapInt32(&m.running, 0, 1) {
		go func() {
			timer := time.NewTimer(time.Second)
			timeoutFus := make([]*AgentFuture, 16)
			nResp := 0
			nOK := 0
			nResend := 0
			nFullResend := 0

			for atomic.LoadInt32(&m.running) == 1 {
				<-timer.C
				now := time.Now()
				noRespWait := true
				total, full, success := 0, 0, 0
				avgRespTime := time.Second

				// check
				m.futures.Range(func(key, value interface{}) bool {
					total++
					future := value.(*AgentFuture)
					if future.waitResend {
						full++
						return true
					}

					select {
					case <-future.Wait():
						nResp++
						if m.onResponse(future) {
							// ErrWaitQueueFull
							full++
						} else {
							nOK++
							success++
							avgRespTime += now.Sub(future.firstTimestamp)
						}
					default:
						noRespWait = false
					}
					return true
				})

				if success > 0 {
					// timeout reduce slowly
					avgRespTime = (avgRespTime/time.Duration(success) + m.lastAvgRespDur) / 2
					m.lastAvgRespDur = avgRespTime

					// add success count back to sendLimit for more send
					atomic.AddInt32(&m.sendLimit, int32(success)+1)
				} else {
					avgRespTime = m.lastAvgRespDur
				}

				// futures map was empty except full waitResend
				if noRespWait {
					atomic.StoreInt32(&m.sendLimit, sendMax)
					m.lastAvgRespDur = agentTimeout
				}

				if atomic.LoadInt32(&m.sendLimit) > 0 {
					timeoutFus = timeoutFus[:0]
					m.futures.Range(func(key, value interface{}) bool {
						future := value.(*AgentFuture)
						if now.Sub(future.timestamp) > avgRespTime {
							timeoutFus = append(timeoutFus, future)
						}
						return true
					})

					if len(timeoutFus) > 0 {
						// no matter it slow
						sort.Slice(timeoutFus, func(i, j int) bool {
							fu1, fu2 := timeoutFus[i], timeoutFus[j]
							if fu1.sendTimes != fu2.sendTimes {
								return fu1.sendTimes < fu2.sendTimes
							}
							return fu1.timestamp.Sub(fu2.timestamp) < 0
						})

						resend := 0
						minDur, maxDur := time.Hour, time.Nanosecond
						minTimes, maxTimes := sendMax, 0
						for _, future := range timeoutFus {
							if future.waitResend || !future.Done() {
								if !m.resendPlay(future) {
									break
								} else {
									delta := now.Sub(future.timestamp)
									if minDur > delta {
										minDur = delta
									}
									if maxDur < delta {
										maxDur = delta
									}
									if minTimes > future.sendTimes {
										minTimes = future.sendTimes
									}
									if maxTimes < future.sendTimes {
										maxTimes = future.sendTimes
									}

									nResend++
									resend++
									if future.waitResend {
										nFullResend++
									}
								}
							}
						}

						if success == 0 {
							// avgRespTime was lastAvgRespDur, not accurate
							// resend wait timeout >= maxDur * 2
							m.lastAvgRespDur = maxDur * 2
							if m.lastAvgRespDur > 10*time.Minute {
								m.lastAvgRespDur = 10 * time.Minute
							}
						}
						log.Info(unsafe.Pointer(m), "timeoutFus", resend, "/", len(timeoutFus), minDur, maxDur, minTimes, maxTimes)
					}
				} else {
					// when sendLimit <= 0, check like heartbeat in period
					// this for break play lost when full received
					if now.Sub(m.lastSendTime) > agentTimeout {
						atomic.AddInt32(&m.sendLimit, 1)
					}
				}

				if total > 0 {
					log.Info(unsafe.Pointer(m), "range once", success, "+", full, "/", total, ",", nOK, "/", nResp, ",", nFullResend, "/", nResend, avgRespTime, m.lastAvgRespDur, m.sendLimit)
				}
				timer.Reset(time.Second)
			}
			timer.Stop()
		}()
		return true
	}
	return false
}

func (m *AgentManager) Stop() {
	atomic.StoreInt32(&m.running, 0)
}

func (m *AgentManager) Reset() {
	m.futures.Range(func(key, value interface{}) bool {
		m.futures.Delete(key)
		return true
	})
	m.sendLimit = sendMax
	m.lastAvgRespDur = agentTimeout
}

func (m *AgentManager) ResetLastAvgRespDur() {
	m.sendLimit = sendMax
	m.lastAvgRespDur = agentTimeout
}

func (m *AgentManager) SendPlay(playID document.ID, model interface{}) bool {
	if _, ok := m.results.Load(playID); ok {
		return false
	}

	// avoid msgpack when limit <= 0
	if atomic.LoadInt32(&m.sendLimit) <= 0 {
		m.results.Store(playID, newAgentWaitingResult(playID))
		return false
	}

	data, err := util.MsgPack(model)
	if err != nil {
		m.results.Store(playID, newAgentWaitingResult(playID))
		return false
	}

	if atomic.AddInt32(&m.sendLimit, -1) >= 0 {
		fu := service.CallAsync(m.agent, m.method, m.name, playID, data)
		now := time.Now()
		future := &AgentFuture{
			Future:         fu,
			id:             playID,
			model:          data,
			timestamp:      now,
			firstTimestamp: now,
			sendTimes:      1,
		}
		m.futures.Store(playID, future)
		m.lastSendTime = now
		return true
	}

	m.results.Store(playID, newAgentWaitingResult(playID))
	return false
}

func (m *AgentManager) resendPlay(future *AgentFuture) bool {
	if _, ok := m.results.Load(future.id); ok {
		return false
	}

	if atomic.AddInt32(&m.sendLimit, -1) >= 0 {
		//log.Infof("resend play %v %s try %d waiting %v", future.id, m.name, future.sendTimes, time.Now().Sub(future.timestamp))

		fu := service.CallAsync(m.agent, m.method, m.name, future.id, future.model)
		now := time.Now()
		newFuture := &AgentFuture{
			Future:         fu,
			id:             future.id,
			model:          future.model,
			timestamp:      now,
			firstTimestamp: future.firstTimestamp,
			sendTimes:      future.sendTimes + 1,
		}

		m.futures.Store(future.id, newFuture)
		m.lastSendTime = now
		return true
	}
	return false
}

func (m *AgentManager) onTimeout(future *AgentFuture) {
	log.Warningf("play %v %s result error %v %v", future.id, m.name, ErrTimeout, time.Now().Sub(future.timestamp))
}

func (m *AgentManager) onResponse(future *AgentFuture) bool {
	resp, err := future.Get()
	result := Result{ID: future.id}
	if err != nil {
		if err.Error() == anti_cheat.ErrWaitQueueFull.Error() {
			if atomic.LoadInt32(&m.sendLimit) > 0 {
				log.Warning("anti_cheat was full")
			}

			future.sendTimes--
			future.waitResend = true

			// stop send when any anti_cheat was full
			atomic.StoreInt32(&m.sendLimit, 0)
			return true
		}
		result.Error = err
		log.Warningf("play %v %s result error %v", future.id, m.name, err)
	} else {
		log.Infof("play %v %s result %v", future.id, m.name, resp)
		result.Result = resp
	}
	m.futures.Delete(future.id)
	m.results.Store(future.id, result)
	return false
}

func (m *AgentManager) GetPlayResults() map[document.ID]Result {
	results := make(map[document.ID]Result)
	m.results.Range(func(key, value interface{}) bool {
		m.results.Delete(key)
		result := value.(Result)
		results[result.ID] = result
		return true
	})
	return results
}

func NewAgentManager(name string, method string, agent service.IService) *AgentManager {
	instance := &AgentManager{
		name:           name,
		method:         method,
		agent:          agent,
		timerDuration:  time.Second,
		lastAvgRespDur: agentTimeout,
		sendLimit:      sendMax,
	}
	return instance
}

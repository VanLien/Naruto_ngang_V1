package cross

import (
	"errors"
	"fmt"
	"sync"
	"time"

	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
)

var (
	ErrSomeNotResponsedInVote   = errors.New("some service not responsed in vote")
	ErrSomeNotResponsedInCommit = errors.New("some service not responsed in commit")
	CommitTimeout               = int64(20)
)

type vote struct {
	key  string
	time int64
}

type Cohort struct {
	sync.Mutex

	// transactions
	tscVotes   map[string]vote
	tscCommits map[string]string

	onTransactionCommit func(key string, transaction string) bool
}

func (c *Cohort) VoteTransaction(key string, transaction string) (string, error) {
	c.Lock()
	defer c.Unlock()

	if value, ok := c.tscCommits[transaction]; ok {
		return value, nil
	}
	now := time.Now().Unix()
	if v, ok := c.tscVotes[transaction]; !ok {
		c.tscVotes[transaction] = vote{key, now}
	} else {
		if now-v.time > CommitTimeout { // 防止组织者挂了，参与者一直阻塞死等
			c.tscVotes[transaction] = vote{key, now}
		}
	}
	return c.tscVotes[transaction].key, nil
}

func (c *Cohort) CommitTransaction(key string, transaction string) (string, error) {
	c.Lock()
	defer c.Unlock()

	if value, ok := c.tscCommits[transaction]; ok {
		return value, nil
	}
	if _, ok := c.tscVotes[transaction]; !ok {
		return "", errors.New("not vote")
	}
	if key == c.tscVotes[transaction].key {
		delete(c.tscVotes, transaction)
		c.tscCommits[transaction] = key
		// commited状态需要上层应用手动清理
		if c.onTransactionCommit != nil {
			if !c.onTransactionCommit(key, transaction) {
				return "refuse", nil
			}
		}
		return key, nil
	} else {
		return c.tscVotes[transaction].key, nil
	}
}

func (c *Cohort) CommittedOver(key string, transaction string) (bool, error) {
	c.Lock()
	defer c.Unlock()

	if c.tscCommits[transaction] == key {
		delete(c.tscCommits, transaction)
	}
	return true, nil
}

func NewCohort(f func(key string, transaction string) bool) *Cohort {
	return &Cohort{
		tscVotes:            make(map[string]vote),
		tscCommits:          make(map[string]string),
		onTransactionCommit: f,
	}
}


type Coordinator struct {
	container service.IContainer
}

func (s *Coordinator) SetContainer(container service.IContainer) {
	s.container = container
}

func (s *Coordinator) dynamicAddServices(names []string) error {
	for _, name := range names {
		if s.container.GetService(name) == nil {
			if err := s.container.AddRemoteService(name); err != nil {
				return err
			}
		}
	}
	return nil
}

func (s *Coordinator) broadcast(services []string, method string, args ...interface{}) *service.Future {
	futures := make([]*service.Future, 0, len(services))
	for _, key := range services {
		ss := s.container.GetService(key)
		future := service.CallAsync(ss, method, args...)
		futures = append(futures, future)
	}
	future := service.MultiFuture(futures, false)
	return future
}

func (s *Coordinator) overPhase(services []string, key string, transaction string) {
	callback := func(future *service.Future) (success bool) {
		response := make([]interface{}, 0, len(services))
		if result, err := future.Get(); err == nil {
			response = result.([]interface{})
		}
		if len(services) == len(response) {
			log.Infof("transaction %s key %s over %v", transaction, key, response)
			success = true
		}
		return
	}

	count := 5
	for count > 0 {
		fu := s.broadcast(services, "CommittedOver", key, transaction)
		if callback(fu) {
			break
		}
		count--
	}
	if count <= 0 {
		log.Warningf("CommittedOver Failed")
	}
}

func (s *Coordinator) TransactionCommit(services []string, key string, transaction string) (bool, error) {
	// vote_phase
	future := s.broadcast(services, "VoteTransaction", key, transaction)
	result, err := future.Get()
	if err != nil {
		return false, err
	}
	resp := result.([]interface{})
	log.Infof("transaction %s key %s vote %v", transaction, key, resp)
	// 一定需要所有server都确认，才能开启该玩法
	if len(services) == len(resp) {
		for i, v := range resp {
			if accpet, ok := v.(string); ok {
				if accpet != key { // 被占用，放弃
					return false, nil
				}
			} else {
				// 如果返回不是str，那一般都是 Error
				return false, errors.New(fmt.Sprintf("%s service vote error %v", services[i], v))
			}
		}
	} else {
		return false, ErrSomeNotResponsedInVote
	}
	// 获取全部资源vote成功

	// commit_phase
	future = s.broadcast(services, "CommitTransaction", key, transaction)
	result, err = future.Get()
	if err != nil {
		return false, err
	}
	resp = result.([]interface{})
	log.Infof("transaction %s key %s commit %v", transaction, key, resp)
	if len(services) == len(resp) {
		for i, v := range resp {
			if accpet, ok := v.(string); ok {
				if accpet != key { // 被占用，放弃
					return false, nil
				}
			} else {
				// 如果返回不是str，那一般都是 Error
				return false, errors.New(fmt.Sprintf("%s service commit error %v", services[i], v))
			}
		}
	} else {
		return false, ErrSomeNotResponsedInCommit
	}

	// commit资源使用完毕，持续性事务由逻辑上层来判断

	// over_phase
	go s.overPhase(services, key, transaction)

	return true, nil
}

func (s *Coordinator) TransactionCommitNotBreak(services []string, key string, transaction string) (bool, error) {
	flag := true

	// vote_phase
	future := s.broadcast(services, "VoteTransaction", key, transaction)
	result, err := future.Get()
	if err != nil {
		flag = false
	}
	resp := result.([]interface{})
	log.Infof("transaction %s key %s vote %v", transaction, key, resp)
	if len(services) == len(resp) {
		for i, v := range resp {
			if accpet, ok := v.(string); ok {
				if accpet != key { // 被占用，放弃
					flag = false
				}
			} else {
				// 如果返回不是str，那一般都是 Error
				flag = false
				err = errors.New(fmt.Sprintf("%s service vote error %v", services[i], v))
			}
		}
	} else {
		flag = false
		err = ErrSomeNotResponsedInVote
	}

	// commit_phase
	future = s.broadcast(services, "CommitTransaction", key, transaction)
	result, err = future.Get()
	if err != nil {
		flag = false
	}
	resp = result.([]interface{})
	log.Infof("transaction %s key %s commit %v", transaction, key, resp)
	if len(services) == len(resp) {
		for i, v := range resp {
			if accpet, ok := v.(string); ok {
				if accpet != key { // 被占用，放弃
					flag = false
				}
			} else {
				// 如果返回不是str，那一般都是 Error
				flag = false
				err = errors.New(fmt.Sprintf("%s service commit error %v", services[i], v))
			}
		}
	} else {
		flag = false
		err = ErrSomeNotResponsedInCommit
	}

	// over_phase
	go s.overPhase(services, key, transaction)

	return flag, err
}

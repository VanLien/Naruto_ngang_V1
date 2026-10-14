package service

import (
	"errors"
	"fmt"
	"sync"
	"sync/atomic"
	"time"
)

// ref https://github.com/fanliao/go-promise

var (
	ErrTimeout = errors.New("timeout")
	ErrCancel  = errors.New("cancel")
)

var chanCache = &sync.Pool{
	New: func() interface{} {
		return make(chan struct{})
	},
}

// closedchan is a reusable closed channel.
var closedchan = make(chan struct{})

func init() {
	close(closedchan)
}

type Future struct {
	wait   chan struct{}
	done   int32
	result interface{}
	err    error
	//lastGet string = util.GetStack(0)
}

func (f *Future) Done() bool {
	return atomic.LoadInt32(&f.done) == 1
}

func (f *Future) Cancel() {
	if atomic.CompareAndSwapInt32(&f.done, 0, 1) {
		f.err = ErrCancel
		close(f.wait)
	}
}

func (f *Future) Set(result interface{}, err error) {
	if atomic.CompareAndSwapInt32(&f.done, 0, 1) {
		f.result = result
		f.err = err
		close(f.wait)
		//m.wait <- struct{}{}
	}
}

func (f *Future) Wait() <-chan struct{} {
	if f.wait == nil {
		return closedchan
	}
	return f.wait
}

func (f *Future) Get() (resp interface{}, err error) {
	<-f.wait
	//chanCache.Put(m.wait)
	f.wait = nil
	return f.result, f.err
}

func (f *Future) GetWithTimeout(duration time.Duration) (resp interface{}, err error) {
	select {
	case <-f.wait:
		//chanCache.Put(m.wait)
		f.wait = nil
		return f.result, f.err
	case <-time.After(duration):
		return nil, ErrTimeout
	}
}

func NewFuture() *Future {
	return &Future{
		wait: make(chan struct{}),
		//wait:   chanCache.Get().(chan struct{}),
		done:   0,
		result: nil,
		err:    nil,
	}
}

func MultiFuture(fus []*Future, errIsResp bool) *Future {
	ret := NewFuture()
	go func() {
		// [resp1, resp2, ...]
		results := make([]interface{}, len(fus))
		for i := 0; i < len(fus); i++ {
			resp, err := fus[i].Get()
			results[i] = resp
			if err != nil {
				if errIsResp {
					results[i] = err
				} else {
					j := i
					for i++; i < len(fus); i++ {
						fus[i].Cancel()
					}
					err = errors.New(fmt.Sprintf("future[%d] %s", j, err.Error()))
					ret.Set(nil, err)
					return
				}
			}
		}
		ret.Set(results, nil)
	}()
	return ret
}

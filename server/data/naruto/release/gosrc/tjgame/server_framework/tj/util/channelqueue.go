package util

import (
	"container/list"
	"sync"
	"sync/atomic"
)

// ChannelQueue
// as buffered channel
// read like channel, write like queue
//
type ChannelQueue struct {
	list     *list.List
	mutex    sync.Mutex
	ch       chan interface{}
	capacity int
	close    int32
	sig      chan struct{}

	C <-chan interface{}
}

func (q *ChannelQueue) init() {
	q.ch = make(chan interface{}, 10) // 10 about the num of concurrency
	q.C = q.ch
	q.sig = make(chan struct{}, 2)

	go func() {
		for atomic.LoadInt32(&q.close) == 0 {
			q.mutex.Lock()
			elem := q.list.Front()
			q.mutex.Unlock()

			if elem == nil {
				<-q.sig
				continue
			}

			// unblock write
			select {
			case q.ch <- elem.Value:
				q.mutex.Lock()
				q.list.Remove(elem)
				q.mutex.Unlock()
			case <-q.sig:

			}
		}

		// drain when closing
		q.mutex.Lock()
		defer q.mutex.Unlock()
		for q.list.Len() > 0 {
			elem := q.list.Front()
			q.list.Remove(elem)
			q.ch <- elem.Value
		}

		close(q.ch)
	}()
}

func (q *ChannelQueue) signal() {
	select {
	case q.sig <- struct{}{}:
	default:
	}
}

func (q *ChannelQueue) PushBack(v interface{}) bool {
	if atomic.LoadInt32(&q.close) == 1 {
		panic("channel queue was closed")
	}

	q.mutex.Lock()
	if q.capacity > 0 && q.list.Len() >= q.capacity {
		q.mutex.Unlock()
		return false
	}
	q.list.PushBack(v)
	q.mutex.Unlock()

	q.signal()
	return true
}

func (q *ChannelQueue) Len() int {
	q.mutex.Lock()
	defer q.mutex.Unlock()

	return q.list.Len() + len(q.ch)
}

func (q *ChannelQueue) Close() {
	if atomic.LoadInt32(&q.close) == 1 {
		panic("channel queue was closed")
	}

	atomic.StoreInt32(&q.close, 1)
	q.signal()
}

func NewChannelQueue() *ChannelQueue {
	ret := &ChannelQueue{
		list:     list.New(),
		capacity: 0,
		close:    0,
	}
	ret.init()
	return ret
}

func NewChannelQueueWithCapacity(cap int) *ChannelQueue {
	ret := &ChannelQueue{
		list:     list.New(),
		capacity: cap,
		close:    0,
	}
	ret.init()
	return ret
}

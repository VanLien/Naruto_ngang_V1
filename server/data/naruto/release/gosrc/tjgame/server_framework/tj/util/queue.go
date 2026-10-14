package util

import (
	"container/list"
	"sync"
)

type Queue struct {
	list  *list.List
	mutex sync.Mutex
}

func (q *Queue) PushBack(elem interface{}) {
	q.mutex.Lock()
	defer q.mutex.Unlock()

	q.list.PushBack(elem)
}

func (q *Queue) PopFront() interface{} {
	q.mutex.Lock()
	defer q.mutex.Unlock()
	elem := q.list.Front()
	if elem == nil {
		return nil
	}
	q.list.Remove(elem)
	return elem.Value
}

func (q *Queue) Len() int {
	q.mutex.Lock()
	defer q.mutex.Unlock()
	return q.list.Len()
}

func NewQueue() *Queue {
	return &Queue{
		list: list.New(),
	}
}

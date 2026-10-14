package util

import (
	"container/list"
	"sync"
)

type EvictCallback func(key, value interface{})

// a thread safe LRU cache,
// if capacity is negative mean the cache is unlimited
type LRUCache struct {
	capacity  int
	evictList *list.List
	items     map[interface{}]*list.Element
	mutex     sync.Mutex

	onEvict EvictCallback
}

// entry is hold on evictList
type entry struct {
	key   interface{}
	value interface{}
}

func NewLRUCache(capacity int, f EvictCallback) *LRUCache {
	cache := &LRUCache{
		capacity:  capacity,
		evictList: list.New(),
		items:     make(map[interface{}]*list.Element),
		onEvict:   f,
	}
	return cache
}

// Get look up a key value with updating
func (m *LRUCache) Get(key interface{}) (value interface{}, ok bool) {
	m.mutex.Lock()
	defer m.mutex.Unlock()

	if elem, ok := m.items[key]; ok {
		m.evictList.MoveToFront(elem)
		return elem.Value.(*entry).value, ok
	}
	return
}

// MultipGet look up multip key with updating, it return hit values and miss keys
func (m *LRUCache) MultipleGet(keys []interface{}) (values []interface{}, miss []interface{}) {
	m.mutex.Lock()
	defer m.mutex.Unlock()

	values = make([]interface{}, 0, len(keys))
	miss = make([]interface{}, 0, len(keys))
	for _, key := range keys {
		if elem, ok := m.items[key]; ok {
			m.evictList.MoveToFront(elem)
			values = append(values, elem.Value.(*entry).value)
		} else {
			miss = append(miss, key)
		}
	}
	return
}

// Peek return the key value without updating
func (m *LRUCache) Peek(key interface{}) interface{} {
	m.mutex.Lock()
	defer m.mutex.Unlock()

	if elem, ok := m.items[key]; ok {
		return elem.Value.(*entry).value
	}
	return nil
}

func (m *LRUCache) Range(f func(key, value interface{}) bool, reverse bool) {
	m.mutex.Lock()
	defer m.mutex.Unlock()

	var cursor *list.Element
	if reverse {
		cursor = m.evictList.Back()
	} else {
		cursor = m.evictList.Front()
	}
	for cursor != nil {
		ent := cursor.Value.(*entry)
		if !f(ent.key, ent.value) {
			break
		}
		if reverse {
			cursor = cursor.Prev()
		} else {
			cursor = cursor.Next()
		}
	}
}

func (m *LRUCache) Contains(key interface{}) (ok bool) {
	m.mutex.Lock()
	defer m.mutex.Unlock()

	_, ok = m.items[key]
	return
}

func (m *LRUCache) Set(key, value interface{}) {
	m.mutex.Lock()
	defer m.mutex.Unlock()

	if ent, ok := m.items[key]; ok {
		m.evictList.MoveToFront(ent)
		ent.Value.(*entry).value = value
		return
	}

	ent := &entry{key, value}
	m.items[key] = m.evictList.PushFront(ent)

	if m.capacity < 0 {
		return
	}
	if m.evictList.Len() > m.capacity {
		// remove oldest
		m.removeElement(m.evictList.Back())
	}
	return
}

func (m *LRUCache) Remove(key interface{}) bool {
	m.mutex.Lock()
	defer m.mutex.Unlock()

	if elem, ok := m.items[key]; ok {
		m.removeElement(elem)
		return true
	}
	return false
}

func (m *LRUCache) removeElement(element *list.Element) {
	m.evictList.Remove(element)
	ent := element.Value.(*entry)
	delete(m.items, ent.key)

	if m.onEvict != nil {
		m.onEvict(ent.key, ent.value)
	}
}

func (m *LRUCache) ReCapacity(capacity int) {
	if capacity < 0 {
		m.capacity = -1
		return
	}
	if capacity > m.capacity && m.capacity >= 0 {
		m.capacity = capacity
		return
	}

	m.mutex.Lock()
	defer m.mutex.Unlock()

	m.capacity = capacity
	step := m.evictList.Len() - capacity
	for i := 0; i < step; i++ {
		// remove oldest
		m.removeElement(m.evictList.Back())
	}
}

func (m *LRUCache) Size() int {
	m.mutex.Lock()
	defer m.mutex.Unlock()

	return m.evictList.Len()
}

func (m *LRUCache) Capacity() int {
	return m.capacity
}

func (m *LRUCache) FlushAll() {
	m.mutex.Lock()
	defer m.mutex.Unlock()

	for k, v := range m.items {
		if m.onEvict != nil {
			m.onEvict(k, v.Value.(*entry).value)
		}
		delete(m.items, k)
	}
	m.evictList.Init()
}

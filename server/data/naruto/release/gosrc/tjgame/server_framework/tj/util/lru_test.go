package util

import (
	"sync/atomic"
	"testing"
)

func TestLRUCache_Capacity(t *testing.T) {
	pop := make([]interface{}, 0)
	lru := NewLRUCache(10, func(key, value interface{}) {
		pop = append(pop, key)
		t.Log("lru pop", key)
	})

	for i := 0; i < 10; i++ {
		lru.Set(i, i)
	}
	for i := 0; i < 10; i++ {
		lru.Set(9-i, 9-i)
	}

	for i := 0; i < 10; i++ {
		t.Log("lru set", i+10)
		lru.Set(10+i, 10+i)
	}

	if len(pop) != 10 {
		t.Error("lru pop size error")
	}
	for i, k := range pop {
		if 9-i != k.(int) {
			t.Error("lru pop content error")
		}
	}
}

func TestLRUCache_ReCapacity(t *testing.T) {
	pop := make([]interface{}, 0)
	lru := NewLRUCache(10, func(key, value interface{}) {
		pop = append(pop, key)
		t.Log("lru pop", key)
	})

	for i := 0; i < 10; i++ {
		lru.Set(9-i, 9-i)
	}

	lru.ReCapacity(100)
	if len(pop) != 0 {
		t.Error("enlarge lru, no pop")
	}

	lru.ReCapacity(5)
	if len(pop) != 5 {
		t.Error("shrink lru, pop size error")
	}

	for i, k := range pop {
		if 9-i != k.(int) {
			t.Error("lru pop content error")
		}
	}
}

func BenchmarkLRUCache_Set(b *testing.B) {
	var pop int32 = 0
	lru := NewLRUCache(10, func(key, value interface{}) {
		atomic.AddInt32(&pop, 1)
	})

	b.ReportAllocs()
	for i := 0; i < b.N; i++ {
		lru.Set(i, i)
	}

	b.Log("pop", pop)
}

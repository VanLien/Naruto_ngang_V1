package util

import (
	"fmt"
	"sync"
	"testing"
)

func TestChannelQueue(t *testing.T) {
	cq := NewChannelQueue()
	N := 100
	wg := &sync.WaitGroup{}
	wg.Add(N)
	cnt := 0
	go func() {
		for v := range cq.C {
			fmt.Println(v, cnt)
			cnt++
			wg.Done()
		}
		t.Log("read over")
	}()
	i := 0
	for ; i < 20; i++ {
		cq.PushBack(i)
	}
	t.Log("write 1 over")
	go func() {
		for ; i < N; i++ {
			cq.PushBack(i)
			//time.Sleep(time.Microsecond)
		}
		fmt.Println("write 2 over")
	}()

	fmt.Printf("cnt %d\n", cnt)
	wg.Wait()
	fmt.Printf("cnt %d\n", cnt)
	cq.Close()
}

//BenchmarkChannelQueue-8                                  3578926               478 ns/op              56 B/op          2 allocs/op
//BenchmarkChannelQueue_concurrency_rw-8                   3920527               293 ns/op              56 B/op          2 allocs/op
//BenchmarkChannelQueue_channel-8                         26014736	48.9 ns/op
//BenchmarkChannelQueue_channel_concurrency_rw-8          18618391	63.8 ns/op
func BenchmarkChannelQueue(b *testing.B) {
	cq := NewChannelQueue()

	b.ReportAllocs()

	for i := 0; i < b.N; i++ {
		cq.PushBack(i)
	}
	cq.Close()
	cnt := 0
	for v := range cq.C {
		if cnt != v {
			b.Errorf("v was not same cnt %v, %v", v, cnt)
		}
		cnt++
	}
	b.Log(cnt)
	if cnt != b.N {
		b.Errorf("%d %d", cnt, b.N)
	}
}

func BenchmarkChannelQueue_concurrency_rw(b *testing.B) {
	cq := NewChannelQueue()

	b.ReportAllocs()
	N := b.N
	wg := &sync.WaitGroup{}
	wg.Add(N)

	go func() {
		for i := 0; i < N; i++ {
			cq.PushBack(i)
		}
		cq.Close()
	}()
	go func() {
		cnt := 0
		for v := range cq.C {
			if cnt != v {
				b.Errorf("v was not same cnt %v, %v", v, cnt)
			}
			cnt++
			wg.Done()
		}
		b.Log(cnt)
	}()

	wg.Wait()
}

func BenchmarkChannelQueue_channel(b *testing.B) {
	ch := make(chan int, b.N)

	for i := 0; i < b.N; i++ {
		ch <- i
	}
	close(ch)
	cnt := 0
	for _ = range ch {
		cnt++
	}
	b.Log(cnt)
}

func BenchmarkChannelQueue_channel_concurrency_rw(b *testing.B) {
	ch := make(chan int, b.N)

	N := b.N
	wg := &sync.WaitGroup{}
	wg.Add(N)

	go func() {
		for i := 0; i < b.N; i++ {
			ch <- i
		}
		close(ch)
	}()
	go func() {
		cnt := 0
		for _ = range ch {
			cnt++
			wg.Done()
		}
		b.Log(cnt)
	}()

	wg.Wait()
}

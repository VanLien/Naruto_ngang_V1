package document

import (
	"container/list"
	"runtime"
	"sync"
	"sync/atomic"
	"time"

	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
)

const flushSecond = 10

var managers sync.Map
var jobNotify = struct{}{}

type wrapper struct {
	v    IWatchedDocument
	last int64
}

// Dirty Queue
type Queue struct {
	mutex    sync.Mutex
	items    *list.List           // dirty list which no `DBUpdate`
	itemsMap map[ID]*list.Element // sync with `items`, keep the elements is unique
	lru      *util.LRUCache       // lru for the new changed doc after flush
}

func (q *Queue) onLRUEvict(v IWatchedDocument) {
	if v.Destroyed() {
		log.Debugf("%s:%v is destroyed", v.CollectionName(), v.GetID())
		return
	}
	q.setdirty(v)
}

func (q *Queue) setdirty(v IWatchedDocument) {
	q.mutex.Lock()
	defer q.mutex.Unlock()

	if _, ok := q.itemsMap[v.GetID()]; !ok {
		q.itemsMap[v.GetID()] = q.items.PushBack(v)
	}
}

func (q *Queue) Put(v IWatchedDocument) bool {
	if !q.lru.Contains(v.GetID()) {
		q.lru.Set(v.GetID(), wrapper{v, time.Now().Unix()})
	}

	q.mutex.Lock()
	defer q.mutex.Unlock()
	return q.items.Len() >= q.lru.Capacity()
}

func (q *Queue) Pop() IWatchedDocument {
	q.mutex.Lock()
	defer q.mutex.Unlock()
	elem := q.items.Front()
	if elem == nil {
		return nil
	}
	v := elem.Value.(IWatchedDocument)
	delete(q.itemsMap, v.GetID())
	q.items.Remove(elem)
	return v
}

func (q *Queue) Peek(id ID) IWatchedDocument {
	q.mutex.Lock()
	defer q.mutex.Unlock()
	v, ok := q.itemsMap[id]
	if ok {
		return v.Value.(IWatchedDocument)
	}
	vv := q.lru.Peek(id)
	if vv == nil {
		return nil
	}
	return vv.(wrapper).v
}

func (q *Queue) Flush(second int64) int {
	now := time.Now().Unix()
	dirtys := make([]interface{}, 0, q.lru.Size())
	q.lru.Range(func(key, value interface{}) bool {
		if now-value.(wrapper).last < second {
			return false
		}
		dirtys = append(dirtys, key)
		return true
	}, true)
	for _, dirty := range dirtys {
		q.lru.Remove(dirty)
	}

	q.mutex.Lock()
	defer q.mutex.Unlock()
	return q.items.Len()
}

func (q *Queue) FlushAll() int {
	q.lru.FlushAll()

	q.mutex.Lock()
	defer q.mutex.Unlock()
	return q.items.Len()
}

func NewQueue(capacity int) *Queue {
	q := &Queue{
		items:    list.New(),
		itemsMap: make(map[ID]*list.Element),
	}
	q.lru = util.NewLRUCache(capacity, func(key, value interface{}) {
		q.onLRUEvict(value.(wrapper).v)
	})
	return q
}

type Manager struct {
	dirtyChan chan IWatchedDocument

	dirtys  *Queue
	storage service.IService
	done    chan struct{}
	logicWG sync.WaitGroup

	flushversion int64

	running int32
	used    int32
}

func (m *Manager) Start() {
	atomic.AddInt32(&m.used, 1)
	if atomic.CompareAndSwapInt32(&m.running, 0, 1) {
		ticker := time.NewTicker(flushSecond * time.Second)
		defer ticker.Stop()

		for {
			select {
			case <-m.done:
				// consume all dirty changes
				m.flushDirtyChan()
				return
			case v, ok := <-m.dirtyChan:
				if ok {
					full := m.dirtys.Put(v)
					if full {
						go m.Flush()
					}
				}
			case <-ticker.C:
				go m.Flush()
			}
		}
	}
}

func (m *Manager) Stop() {
	used := atomic.AddInt32(&m.used, -1)
	if used > 0 {
		return
	}
	if atomic.CompareAndSwapInt32(&m.running, 1, 0) {
		m.logicWG.Wait()
		close(m.dirtyChan)
		close(m.done)
		m.WaitForceFlush()
	}
}

// important for safe exit
func (m *Manager) MarkLogicRoutine() {
	m.logicWG.Add(1)
}

func (m *Manager) DoneLogicRoutine() {
	m.logicWG.Done()
}

// return true only mean all dirty be send to save
// but not guarantee all dirty be save ok
func (m *Manager) processDirty(count int) bool {
	var success, fail int32
	var wg sync.WaitGroup
	jobs := make(chan struct{}, runtime.GOMAXPROCS(0))
	start := time.Now()
	version := atomic.LoadInt64(&m.flushversion)
	var ok int32 = 1

	newjob := func() {
		defer wg.Done()

		newVersion := atomic.LoadInt64(&m.flushversion)
		if version != newVersion {
			if atomic.CompareAndSwapInt32(&ok, 1, 0) {
				log.Infof("skip current process, old %d new %d", version, newVersion)
			}
			return
		}

		v := m.dirtys.Pop()
		if v == nil {
			return
		}
		updater := GetDirtyFieldValuesAndReset(v)
		if updater == nil {
			return
		}

		name := v.CollectionName()
		id := v.GetID()
		_, err := service.Call(m.storage, "DBUpdate", name, id, updater, false)
		if err != nil {
			fail++
			atomic.AddInt32(&fail, 1)
			log.Errorf("save %s:%v error %v", name, id, err)

			// let me try again in the next flush
			// TODO: if always failed?
			v.Watcher().Modify(updater.Keys()...)
			m.dirtys.Put(v)
		} else {
			atomic.AddInt32(&success, 1)
		}
	}

	for i := 0; i < runtime.GOMAXPROCS(0); i++ {
		go func() {
			for range jobs {
				newjob()
			}
		}()
	}

	wg.Add(count)
	for i := 0; i < count; i++ {
		jobs <- jobNotify
	}
	wg.Wait()
	close(jobs)

	if success != 0 || fail != 0 {
		log.Infof("process dirty, count %d success %d fail %d cost %v, dirty %d, lru %d, chan %d", count, success, fail, time.Now().Sub(start), m.dirtys.items.Len(), m.dirtys.lru.Size(), len(m.dirtyChan))
	}
	return ok == 1
}

func (m *Manager) flushDirtyChan() {
	for len(m.dirtyChan) > 0 {
		select {
		case v, ok := <-m.dirtyChan:
			if ok {
				m.dirtys.Put(v)
			}
		}
	}
}

// flush with timeout strategy
func (m *Manager) Flush() {
	count := m.dirtys.Flush(flushSecond)
	if count > 0 {
		atomic.AddInt64(&m.flushversion, 1)
		m.processDirty(count)
	}
}

func (m *Manager) WaitForceFlush() {
	m.flushDirtyChan()
	for {
		count := m.dirtys.FlushAll()
		atomic.AddInt64(&m.flushversion, 1)
		if m.processDirty(count) {
			break
		}
	}
}

// capacity is strategy how many dirty objects in period of flushSecond
func NewManager(storage service.IService, capacity int) *Manager {
	// 6 will be a num to consider, now is num of parallel cpu
	m := &Manager{
		storage:   storage,
		dirtyChan: make(chan IWatchedDocument, 6),
		done:      make(chan struct{}),
		dirtys:    NewQueue(capacity),
	}

	actual, loaded := managers.LoadOrStore(storage.Name(), m)
	if loaded {
		close(m.dirtyChan)
		close(m.done)
	}
	manager := actual.(*Manager)
	return manager
}

type Builder struct {
	mgrs map[string]*Manager
}

func (b *Builder) Indicate(document IWatchedDocument, name string) {
	document.SetDirtyChan(b.mgrs[name].dirtyChan)
}

func (b *Builder) Stop() {
	for _, mgr := range b.mgrs {
		mgr.Stop()
	}
}

func NewBuilder(storage ...service.IService) *Builder {
	builder := &Builder{
		mgrs: make(map[string]*Manager),
	}
	for _, s := range storage {
		mgr := NewManager(s, 1000)
		builder.mgrs[s.Name()] = mgr
	}
	for _, mgr := range builder.mgrs {
		go mgr.Start()
	}
	return builder
}

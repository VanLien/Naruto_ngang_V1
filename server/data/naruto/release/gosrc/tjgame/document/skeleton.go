package document

import (
	"sync/atomic"
)

type Skeleton struct {
	watcher   Watcher
	dirtyChan chan<- IWatchedDocument

	syncWatch  *Watcher
	synclocker int32 // 0: not in get or reset; 1: in get or reset

	destroy bool
}

// partial IWatchedDocument
func (s *Skeleton) Watcher() *Watcher {
	return &s.watcher
}

func (s *Skeleton) SetDirtyChan(c chan<- IWatchedDocument) {
	s.dirtyChan = c
}

func (s *Skeleton) SetDirty(document IWatchedDocument, keys ...string) {
	s.watcher.Modify(keys...)
	if s.dirtyChan == nil {
		panic("no dirty channel")
	}
	s.dirtyChan <- document

	if s.syncWatch != nil {
		s.syncWatch.Modify(keys...)
	}
}

func (s *Skeleton) GetSynchronAndReset(beWatched IDocument) map[string]interface{} {
	if atomic.CompareAndSwapInt32(&s.synclocker, 0, 1) {
		defer atomic.StoreInt32(&s.synclocker, 0)
		defer s.syncWatch.reset()

		keys := s.syncWatch.getdirtykeys()
		if len(keys) == 0 {
			return nil
		}

		return GetFieldInterface(beWatched, keys...)
	}
	return nil
}

func (s *Skeleton) SynchronReset() {
	if atomic.CompareAndSwapInt32(&s.synclocker, 0, 1) {
		defer atomic.StoreInt32(&s.synclocker, 0)

		if s.syncWatch == nil {
			s.syncWatch = &Watcher{}
		} else {
			s.syncWatch.reset()
		}
	}
}

func (s *Skeleton) SetDestroy() {
	s.destroy = true
}

func (s *Skeleton) Destroyed() bool {
	return s.destroy
}

func (s *Skeleton) ReuseID() {
	s.watcher.Flush()
}

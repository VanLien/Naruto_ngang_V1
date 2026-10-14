package document

import (
	"fmt"
	"reflect"
	"sync"
	"sync/atomic"
	"tjgame/ugorji_go/codec"

	"tjgame/mgo.v2/bson"

	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
)

type UnlockFunc func()

type IUpdater interface {
	Update(document IDocument) []string
}

type RawUpdater struct {
	origin IDocument
	keys   []string
}

func (u *RawUpdater) Update(dest IDocument) []string {
	v := reflect.ValueOf(u.origin).Elem()
	visitFields(dest, u.keys, func(key string, fieldName string, field reflect.Value) {
		field.Set(v.FieldByName(fieldName))
	})
	return u.keys
}

func NewRawUpdater(name string, raw codec.Raw) (*RawUpdater, error) {
	diff := make(map[string]codec.Raw)
	if err := util.MsgUnpack(raw, diff); err != nil {
		return nil, err
	}
	keys := make([]string, 0, len(diff))
	for key := range diff {
		keys = append(keys, key)
	}
	origin := New(name, false)
	if err := util.MsgUnpack(raw, origin); err != nil {
		return nil, err
	}
	updater := &RawUpdater{origin, keys}
	return updater, nil
}

type FieldUpdater map[string]reflect.Value

func (u FieldUpdater) Update(dest IDocument) []string {
	keys := make([]string, 0, len(u))
	for key := range u {
		keys = append(keys, key)
	}
	visitFields(dest, keys, func(key string, fieldName string, field reflect.Value) {
		field.Set(u[key])
	})
	return keys
}

func (u FieldUpdater) CodecEncodeSelf(e *codec.Encoder) {
	mm := bson.M{}
	for k, v := range u {
		mm[k] = v.Interface()
	}
	if err := e.Encode(mm); err != nil {
		log.Errorf("FieldUpdater encode error%v", err)
	}
}

func (u FieldUpdater) CodecDecodeSelf(e *codec.Decoder) {
	panic("FieldUpdater unsupport decode")
}

type CodecRawUpdater struct {
	name string
	keys []string
	raw  codec.Raw
}

func (c *CodecRawUpdater) CodecEncodeSelf(e *codec.Encoder) {
	if err := e.Encode(c.raw); err != nil {
		log.Errorf("CodecRawUpdater encode error %v", err)
	}
}

func (c *CodecRawUpdater) CodecDecodeSelf(e *codec.Decoder) {
	panic("CodecRawUpdater unsupported decode")
}

func (c *CodecRawUpdater) Update(dest IDocument) []string {
	// TODO: implement
	return nil
}

func (c *CodecRawUpdater) Keys() []string {
	return c.keys
}

func (c *CodecRawUpdater) String() string {
	return fmt.Sprintf("CodecRawUpdater %s, keys: %v, raw length %d", c.name, c.keys, len(c.raw))
}

func NewCodecRawUpdater(name string, keys []string, updater FieldUpdater) *CodecRawUpdater {
	raw, err := util.MsgPack(updater)
	if err != nil {
		panic(err)
	}
	return &CodecRawUpdater{
		name: name,
		keys: keys,
		raw:  raw,
	}
}

type IWatchedDocument interface {
	IDocument

	Lock()
	Unlock()
	RLock()
	RUnlock()
	RLocker() sync.Locker

	BeWatched() IDocument
	Watcher() *Watcher
	SetDirtyChan(chan<- IWatchedDocument)
	Destroyed() bool
}

type Watcher struct {
	mu    sync.Mutex
	dirty map[string]bool

	flush int32 // if 1, consider all key is dirty exclude _id
}

func (w *Watcher) Modify(keys ...string) {
	w.mu.Lock()
	if w.dirty == nil {
		w.dirty = make(map[string]bool)
	}
	for _, key := range keys {
		w.dirty[key] = true
	}
	w.mu.Unlock()
}

func (w *Watcher) Flush() {
	atomic.StoreInt32(&w.flush, 1)
}

func (w *Watcher) reset() {
	w.mu.Lock()
	w.dirty = make(map[string]bool)
	w.mu.Unlock()
	atomic.StoreInt32(&w.flush, 0)
}

func (w *Watcher) getdirtykeys() []string {
	w.mu.Lock()
	keys := make([]string, 0, len(w.dirty))
	for key := range w.dirty {
		keys = append(keys, key)
	}
	w.mu.Unlock()
	return keys
}

func GetDirtyFieldValuesAndReset(wdoc IWatchedDocument) *CodecRawUpdater {
	wdoc.RLock()
	defer wdoc.RUnlock()

	watcher := wdoc.Watcher()
	doc := wdoc.BeWatched()
	defer watcher.reset()

	if atomic.LoadInt32(&watcher.flush) == 1 {
		diff := GetAllFieldValue(doc)
		delete(diff, "_id")
		log.Debugf("%s:%v reuse id", doc.CollectionName(), doc.GetID())
		return NewCodecRawUpdater(doc.CollectionName(), nil, diff)
	}

	keys := watcher.getdirtykeys()
	if len(keys) == 0 {
		return nil
	}
	diff := GetFieldValue(doc, keys...)
	return NewCodecRawUpdater(doc.CollectionName(), keys, diff)
}

package storage

import (
	"errors"
	"fmt"

	"tjgame/mgo.v2/bson"

	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
)

var (
	persistences = map[string]bool{
		"MailGlobal":         true,
		"ServerGlobalRecord": true,
		"Union":              true,
		"UnionFuben":         true,
	}
)

type Session struct {
	storage     *Storage
	cache       *util.LRUCache
	persistence *util.LRUCache
}

// invoke when document evict from cache
func (s *Session) onDocumentEvict(id ID, document *Document) {
	err := document.Save(s.storage, false)
	if err != nil {
		log.Warningf("onDocumentEvict Save %s:%v error %v", document.CollectionName(), id, err)
	}
}

func (s *Session) Set(document *Document) {
	cache := s.route(document.CollectionName())
	cache.Set(document.GetID(), document)
}

func (s *Session) Get(name string, id ID) (*Document, error) {
	cache := s.route(name)
	v, ok := cache.Get(id)
	if ok { // hit cache
		document := v.(*Document)
		if document.CollectionName() != name {
			return nil, errors.New(fmt.Sprintf("expect %s %v, got %s", name, id, document.CollectionName()))
		}
		return document, nil
	}
	// miss in cache
	document := NewDefaultDocument(name)
	document.SetID(id)
	err := document.Load(s.storage, nil)
	if err != nil {
		return nil, err
	}
	cache.Set(id, document)
	return document, nil
}

func (s *Session) MultipGet(name string, ids []ID) ([]*Document, error) {
	cache := s.route(name)
	keys := make([]interface{}, len(ids))
	for i, id := range ids {
		keys[i] = id
	}
	hits, miss := cache.MultipleGet(keys)
	documents := make([]*Document, 0, len(ids))
	for _, v := range hits {
		documents = append(documents, v.(*Document))
	}
	docs, err := s.storage.Query(name, bson.M{"_id": bson.M{"$in": miss}}, nil, 0)
	if err != nil {
		return nil, err
	}
	for _, document := range docs {
		documents = append(documents, document)
		cache.Set(document.GetID(), document)
	}
	return documents, nil
}

func (s *Session) Query(name string, kvs bson.M) (*Document, error) {
	cache := s.route(name)
	document := NewDefaultDocument(name)
	err := document.Load(s.storage, kvs)
	if err != nil {
		return nil, err
	}
	id := document.GetID()
	if v, ok := cache.Get(id); ok { // hit cache
		document := v.(*Document)
		if document.CollectionName() != name {
			return nil, errors.New(fmt.Sprintf("expect %s, got %s", name, document.CollectionName()))
		}
		return document, nil
	}
	cache.Set(id, document)
	return document, nil
}

// remove from cache
func (s *Session) Forget(name string, id ID) {
	cache := s.route(name)
	cache.Remove(id)
}

// remove from cache and mongodb
func (s *Session) Remove(name string, id ID) (err error) {
	cache := s.route(name)
	cache.Remove(id)
	err = s.storage.RemoveId(name, id)
	return
}

func (s *Session) Commit() {
	objs, success := 0, 0
	for _, cache := range []*util.LRUCache{s.cache, s.persistence} {
		cache.Range(func(key, value interface{}) bool {
			objs += 1
			document := value.(*Document)
			err := document.Save(s.storage, false)
			if err == nil {
				success += 1
			} else {
				log.Warningf("Commit %s:%v error %v", document.CollectionName(), document.GetID(), err)
			}
			return true
		}, false)
	}
	log.Infof("Commit %d objects, success %d", objs, success)
}

func (s *Session) FlushAll() {
	s.cache.FlushAll()
	s.persistence.FlushAll()
}

func (s *Session) route(name string) *util.LRUCache {
	if _, ok := persistences[name]; ok {
		return s.persistence
	}
	return s.cache
}

func NewSession(storage *Storage) *Session {
	session := &Session{
		storage: storage,
	}
	session.cache = util.NewLRUCache(DocumentLRUCapacity, func(key, value interface{}) {
		id := key.(ID)
		v := value.(*Document)
		session.onDocumentEvict(id, v)
	})
	session.persistence = util.NewLRUCache(-1, func(key, value interface{}) {
		id := key.(ID)
		v := value.(*Document)
		session.onDocumentEvict(id, v)
	})
	return session
}

package storage

import (
	"strings"
	"sync"
	"time"
	"tjgame/document"
	"tjgame/server_framework/tj/log"

	mgo "tjgame/mgo.v2"

	"tjgame/mgo.v2/bson"
)

type exec struct {
	f      func() error
	result chan error
}

type Storage struct {
	session *mgo.Session
	name    string
	url     string

	cache map[ID]*Document

	wg    sync.WaitGroup
	queue chan exec
	close chan struct{}
}

func (s *Storage) workerRoutine() {
loop:
	for {
		select {
		case e := <-s.queue:
			e.result <- e.f()
			close(e.result)
		case <-s.close:
			break loop
		}
	}

	for e := range s.queue {
		e.result <- e.f()
		close(e.result)
	}
	s.wg.Done()
}

func (s *Storage) work(f func() error) error {
	result := make(chan error)
	s.queue <- exec{f: f, result: result}
	err := <-result
	return err
}

func (s *Storage) exec(name string, f func(collection *mgo.Collection) error) error {
	wrapp := func() error {
		session := s.session.Copy()
		defer session.Close()
		return f(session.DB(s.name).C(name))
	}

	var err error
	retry := 0
	for retry < 10 {
		err = s.work(wrapp)
		//err = wrapp()
		// Write results unavailable from 9.28.191.37:7012 :: caused by :: End of file
		if err != nil && err != mgo.ErrNotFound && strings.Index(err.Error(), "duplicate key error") < 0 {
			//if err != nil && (strings.Contains(err.Error(), "caused by") || err.Error() == "EOF") {
			retry += 1
			log.Warningf("mgo document exec %s, error %s, retry %d", name, err, retry)
			time.Sleep(time.Duration(retry) * 100 * time.Millisecond)
			continue
		}
		if err != nil {
			log.Warningf("Document exec %s Error: %s", name, err)
			if retry >= 1 && strings.Index(err.Error(), "index: _id_ dup key") >= 0 {
				err = nil
			}
		}
		break
	}

	return err
}

func (s *Storage) Load(document *Document, query bson.M) error {
	if query == nil && document.GetID() == "" {
		return ErrNoDocumentIDOrQuery
	}
	return s.exec(document.CollectionName(), func(collection *mgo.Collection) error {
		if document.GetID() != "" {
			return collection.FindId(document.GetID()).One(document.IDocument)
		} else {
			return collection.Find(query).One(document.IDocument)
		}
	})
}

func (s *Storage) Save(document *Document) error {
	if document.GetID() == "" {
		document.SetID(ID(bson.NewObjectId()))
		return s.exec(document.CollectionName(), func(collection *mgo.Collection) error {
			return collection.Insert(document.IDocument)
		})
	}
	return s.exec(document.CollectionName(), func(collection *mgo.Collection) error {
		return collection.UpdateId(document.GetID(), document.IDocument)
	})
}

func (s *Storage) RemoveId(name string, id ID) error {
	return s.exec(name, func(collection *mgo.Collection) error {
		return collection.RemoveId(id)
	})
}

func (s *Storage) Remove(document *Document) error {
	return s.exec(document.CollectionName(), func(collection *mgo.Collection) error {
		return collection.RemoveId(document.GetID())
	})
}

func (s *Storage) Query(name string, condition bson.M, selector bson.M, limit int) ([]*Document, error) {
	documents := make([]*Document, 0, 10)
	err := s.exec(name, func(collection *mgo.Collection) error {
		query := collection.Find(condition).Select(selector)
		if limit > 0 {
			query = query.Limit(limit)
		}
		iter := query.Iter()
		d := NewDefaultDocument(name)
		for iter.Next(d.IDocument) {
			documents = append(documents, d)
			d = NewDefaultDocument(name)
		}
		return iter.Close()
	})
	if err != nil {
		return nil, err
	}
	return documents, err
}

func (s *Storage) RangeQuery(name string, condition bson.M, selector bson.M, start, end int, sortFields []string) ([]*Document, error) {
	documents := make([]*Document, 0, 10)
	err := s.exec(name, func(collection *mgo.Collection) error {
		query := collection.Find(condition)
		if selector != nil {
			query.Select(selector)
		}

		if start == 0 && end == 0 {
			query = query.Sort(sortFields...)
		} else {
			start = start - 1
			size := end - start
			if start == 0 {
				query = query.Sort(sortFields...).Limit(size)
			} else {
				query = query.Sort(sortFields...).Skip(start).Limit(size)
			}
		}

		iter := query.Iter()
		d := NewDefaultDocument(name)
		for iter.Next(d.IDocument) {
			documents = append(documents, d)
			d = NewDefaultDocument(name)
		}
		return iter.Close()
	})
	if err != nil {
		return nil, err
	}
	return documents, err
}

func (s *Storage) Close() {
	close(s.close)
	close(s.queue)
	s.wg.Wait()
	if s.session != nil {
		s.session.Close()
	}
}

func (s *Storage) EnsureIndex(name string) {
	document.RangeFieldSpec(name, func(spec document.FieldSpec) {
		if spec.Index || spec.Unique {
			err := s.exec(name, func(collection *mgo.Collection) error {
				return collection.EnsureIndex(mgo.Index{
					Key:    []string{spec.IndexKey},
					Unique: spec.Unique,
				})
			})
			if err != nil {
				log.Warningf("Document %s Ensure Index %s Error: %s", name, spec.IndexKey, err)
			}
		}
	})
}

func (s *Storage) IncID(name string) (int, error) {
	change := mgo.Change{
		Update:    bson.M{"$inc": bson.M{"id": 1}},
		Upsert:    true,
		ReturnNew: true,
	}
	doc := struct {
		ID int
	}{}
	err := s.exec("IncID", func(collection *mgo.Collection) error {
		_, err := collection.FindId(name).Apply(change, &doc)
		return err
	})
	if err != nil {
		return 0, err
	}
	return doc.ID, err
}

func NewStorage(url string, name string) *Storage {
	session, err := mgo.Dial(url)
	if err != nil {
		panic(err)
	}
	storage := &Storage{
		session: session,
		url:     url,
		name:    name,
	}
	log.Infof("connect to mongodb %s %s", url, name)

	storage.queue = make(chan exec, 1024)
	storage.close = make(chan struct{})

	num := 20
	storage.wg.Add(num)
	for i := 0; i < num; i++ {
		go storage.workerRoutine()
	}

	return storage
}

package test

import (
	"fmt"
	"sync"
	"testing"
	"time"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/services/storage"
)

func TestDocument(t *testing.T) {
	role := document.New("Role", true)
	r := role.(*scheme.Role)
	r.Name = "xxxx"
	r.UID = 10
	r.Area = 1
	r.Logo = 2
	t.Log(r)
	fmt.Println(document.GetFieldValue(role, "name", "logo", "area", "uid"))
}

type mockManager struct {
	*document.Manager
}

func (m *mockManager) onDirtyEvict(v interface{}) {
	fmt.Println("manager dirty evict", v)
}

func TestDocumentManagerWhenDBUpdateError(t *testing.T) {
	storageSvc := NewService(nil, nil)
	storageSvc.Init()

	mgr := &mockManager{
		Manager: document.NewManager(storageSvc, 0),
	}
	go mgr.Start()

	sdoc := storage.NewDefaultDocument("Role")
	role := sdoc.IDocument.(*scheme.Role)
	obj := scheme.NewRoleObject(role)
	obj.SetDirtyChan(mgr.DirtyChan)

	role.SetID("xxxxxxtest")
	storageSvc.SetTestDoc(obj)
	storageSvc.SetDBUpdateErrorCount(3)

	db, unlock := obj.LockAndGetDB()
	db.Name = "xxxx"
	obj.SetDirty("name")

	obj.SetLogo(22)
	unlock()

	for i := 0; i < 5; i++ {
		mgr.WaitForceFlush()
	}
	<-time.After(time.Second)
	log.Debug("stopping")
	mgr.Stop()
}

func TestDocumentManager(t *testing.T) {
	storageSvc := NewService(nil, nil)
	storageSvc.Init()

	mgr := &mockManager{
		Manager: document.NewManager(storageSvc, 0),
	}
	//mgr.dirty = util.NewLRUCache(0, func(key, value interface{}) {
	//	mgr.onDirtyEvict(value)
	//})
	go mgr.Start()

	sdoc := storage.NewDefaultDocument("Role")
	role := sdoc.IDocument.(*scheme.Role)
	obj := scheme.NewRoleObject(role)
	obj.SetDirtyChan(mgr.DirtyChan)

	role.SetID("xxxxxxtest")
	storageSvc.SetTestDoc(obj)

	//obj.SetDirtyChan(mgr.DirtyChan)

	db, unlock := obj.LockAndGetDB()

	db.Name = "xxxx"
	obj.SetDirty("name")

	db.UID = 10
	obj.SetDirty("uid")

	db.Area = 1
	db.Logo = 2
	obj.SetDirty("area", "logo")

	db.Logos[1] = 1
	db.Logos[2] = 2
	obj.SetDirty("logos")

	unlock()

	t.Log(obj)

	N := 10000
	wg := sync.WaitGroup{}
	wg.Add(3 * N)
	for i := 0; i < 2; i++ {
		go func() {
			// fatal error: concurrent map iteration and map write
			//db, unlock := obj.LockAndGetDB()
			//unlock()
			for i := 0; i < N; i++ {
				db, unlock := obj.LockAndGetDB()

				// fatal error: concurrent map writes
				//unlock()
				db.Logos[document.Integer(i)] = float64(i)
				obj.SetDirty("logos")
				unlock()
				wg.Done()
			}
		}()
	}

	go func() {
		for i := 0; i < N; i++ {
			mgr.Flush()
			wg.Done()
		}
	}()

	wg.Wait()

	mgr.WaitForceFlush()
	<-time.After(time.Second)
	mgr.Stop()
}

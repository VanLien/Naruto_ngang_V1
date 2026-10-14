package storage

import (
	"sync"
	"tjgame/document"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
	"tjgame/ugorji_go/codec"

	mgo "tjgame/mgo.v2"
	"tjgame/mgo.v2/bson"
)

type ID = document.ID

type Document struct {
	document.IDocument

	dirty map[string]bool
	lock  sync.RWMutex
}

func (d *Document) modify(keys ...string) {
	d.lock.Lock()
	defer d.lock.Unlock()

	for _, key := range keys {
		d.dirty[key] = true
	}
}

func (d *Document) Load(storage *Storage, query bson.M) error {
	return storage.Load(d, query)
}

func (d *Document) Update(updater document.IUpdater) {
	d.modify(updater.Update(d.IDocument)...)
}

func (d *Document) Save(storage *Storage, full bool) (err error) {
	defer func() {
		if err == nil {
			util.WithGuard(&d.lock, func() {
				d.dirty = make(map[string]bool)
			})
		}
	}()

	if d.GetID() != "" && !full {
		keys := make([]string, 0, len(d.dirty))
		util.WithGuard(d.lock.RLocker(), func() {
			for key := range d.dirty {
				keys = append(keys, key)
			}
		})
		diff := document.GetFieldInterface(d.IDocument, keys...)
		//log.Debugf("save diff %#v", diff)
		if len(diff) == 0 {
			return
		}
		err = storage.exec(d.CollectionName(), func(collection *mgo.Collection) error {
			return collection.UpdateId(d.GetID(), bson.M{"$set": diff})
		})
		// mgo数据未正确insert时，如有update则再次尝试insert
		// TODO: 上层在delete时也需要做相关处理，防止时序问题导致delete之后insert
		if err == mgo.ErrNotFound {
			log.Warningf("Save try insert %s:%v when not found", d.CollectionName(), d.GetID())
			err = storage.exec(d.CollectionName(), func(collection *mgo.Collection) error {
				return collection.Insert(d.IDocument)
			})
		}
		return
	}
	err = storage.Save(d)
	return
}

func NewDefaultDocument(name string) *Document {
	internal := document.New(name, true)
	return NewDocument(internal)
}

func NewDocument(internal document.IDocument) *Document {
	return &Document{
		IDocument: internal,
		dirty:     make(map[string]bool),
	}
}

type raw codec.Raw

func (r *raw) CodecEncodeSelf(e *codec.Encoder) {
	v := codec.Raw(*r)
	e.Encode(v)
}

func (r *raw) CodecDecodeSelf(e *codec.Decoder) {
	panic("unsupport decode")
}

func (r *raw) GetID() ID {
	return ""
}

func (r *raw) SetID(id ID) {

}

func (r *raw) CollectionName() string {
	return ""
}

func newRawDocument(v interface{}) *raw {
	data, err := util.MsgPack(v)
	if err != nil {
		panic(err)
	}
	vv := raw(data)
	return &vv
}

func documentCustomizeKeys(documents []*Document, keys []string) []*Document {
	flag := true
	for i, key := range keys {
		if key == "id" {
			keys[i] = "_id"
			flag = false
			break
		}
	}
	if flag {
		keys = append(keys, "_id")
	}
	ret := make([]*Document, 0, len(documents))
	for _, doc := range documents {
		v := document.GetFieldInterface(doc.IDocument, keys...)
		if vv, ok := v["_id"]; ok {
			v["id"] = vv
			delete(v, "_id")
		}
		ret = append(ret, &Document{
			IDocument: newRawDocument(v),
		})
	}
	return ret
}

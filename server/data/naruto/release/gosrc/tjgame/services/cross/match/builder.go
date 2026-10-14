package match

import (
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/mgo.v2/bson"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/storage"
)

type Builder struct {
	*document.Builder

	storage service.IService
	cache   *util.LRUCache // cache for PlayRecord
}

func (b *Builder) NewCrossMatch(key string) *Match {
	resp, err := service.Call(b.storage, "DBReadsert", "CrossMatch", bson.M{"key": key}, false)
	if err != nil {
		return nil
	}
	response := resp.(storage.Response)
	db := response.Model.(*scheme.CrossMatch)
	r := &Match{
		CrossMatchObject: scheme.NewCrossMatchObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func NewBuilder(storage service.IService) *Builder {
	return &Builder{
		Builder: document.NewBuilder(storage),
		storage: storage,
		cache:   util.NewLRUCache(1000, nil),
	}
}

package mine

import (
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/mgo.v2/bson"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/storage"
)

type Builder struct {
	*document.Builder

	storage service.IService
	cache   *util.LRUCache // cache for PlayRecord
}

func (b *Builder) NewMine(key string) *Mine {
	resp, err := service.Call(b.storage, "DBReadsert", "CrossMineGlobal", bson.M{"key": key}, false)
	if err != nil {
		return nil
	}
	response := resp.(storage.Response)
	db := response.Model.(*scheme.CrossMineGlobal)
	r := &Mine{
		CrossMineGlobalObject: scheme.NewCrossMineGlobalObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) newCrossMinePlayRecord(response *storage.Response) *PlayRecord {
	db := response.Model.(*scheme.CrossMinePlayRecord)
	r := &PlayRecord{
		CrossMinePlayRecordObject: scheme.NewCrossMinePlayRecordObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) CreateCrossMinePlayRecord(model *scheme.CrossMinePlayRecord) *PlayRecord {
	resp, err := service.Call(b.storage, "DBCreate", model.CollectionName(), model)
	if err != nil {
		log.Errorf("create cross Mine play record error %v", err)
		return nil
	}
	response := resp.(storage.Response)
	record := b.newCrossMinePlayRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

func (b *Builder) GetCrossMinePlayRecord(id document.ID) *PlayRecord {
	if v, ok := b.cache.Get(id); ok {
		return v.(*PlayRecord)
	}
	resp, err := service.Call(b.storage, "DBRead", "CrossMinePlayRecord", id, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	if response.Model == nil {
		return nil
	}
	record := b.newCrossMinePlayRecord(&response)
	b.cache.Set(id, record)
	return record
}

func NewBuilder(storage service.IService) *Builder {
	return &Builder{
		Builder: document.NewBuilder(storage),
		storage: storage,
		cache:   util.NewLRUCache(1000, nil),
	}
}

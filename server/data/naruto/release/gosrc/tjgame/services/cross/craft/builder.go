package craft

import (
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/storage"

	"tjgame/mgo.v2/bson"
)

type Builder struct {
	*document.Builder

	storage service.IService
	cache   *util.LRUCache // cache for PlayRecord
}

func (b *Builder) newCrossCraftPlayRecord(response *storage.Response) *PlayRecord {
	db := response.Model.(*scheme.CrossCraftPlayRecord)
	r := &PlayRecord{
		CrossCraftPlayRecordObject: scheme.NewCrossCraftPlayRecordObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) GetCrossCraftPlayRecord(id document.ID) *PlayRecord {
	if v, ok := b.cache.Get(id); ok {
		return v.(*PlayRecord)
	}
	resp, err := service.Call(b.storage, "DBRead", "CrossCraftPlayRecord", id, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	if response.Model == nil {
		return nil
	}
	record := b.newCrossCraftPlayRecord(&response)
	b.cache.Set(id, record)
	return record
}

func (b *Builder) CreateCrossCraftPlayRecord(model *scheme.CrossCraftPlayRecord) *PlayRecord {
	resp, err := service.Call(b.storage, "DBCreate", model.CollectionName(), model)
	if err != nil {
		log.Errorf("create cross craft play record error %v", err)
		return nil
	}
	response := resp.(storage.Response)
	record := b.newCrossCraftPlayRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

func (b *Builder) NewCraft(key string) *Craft {
	resp, err := service.Call(b.storage, "DBReadsert", "CrossCraftGlobal", bson.M{"key": key}, false)
	if err != nil {
		return nil
	}
	response := resp.(storage.Response)
	db := response.Model.(*scheme.CrossCraftGlobal)
	r := &Craft{
		CrossCraftGlobalObject: scheme.NewCrossCraftGlobalObject(db),
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

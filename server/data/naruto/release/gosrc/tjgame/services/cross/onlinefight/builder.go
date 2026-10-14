package onlinefight

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

func (b *Builder) newCrossOnlineFightPlayRecord(response *storage.Response) *PlayRecord {
	db := response.Model.(*scheme.CrossOnlineFightPlayRecord)
	r := &PlayRecord{
		CrossOnlineFightPlayRecordObject: scheme.NewCrossOnlineFightPlayRecordObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) GetCrossOnlineFightPlayRecord(id document.ID) *PlayRecord {
	if v, ok := b.cache.Get(id); ok {
		return v.(*PlayRecord)
	}
	resp, err := service.Call(b.storage, "DBRead", "CrossOnlineFightPlayRecord", id, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	if response.Model == nil {
		return nil
	}
	record := b.newCrossOnlineFightPlayRecord(&response)
	b.cache.Set(id, record)
	return record
}

func (b *Builder) CreateCrossOnlineFightPlayRecord(model *scheme.CrossOnlineFightPlayRecord) *PlayRecord {
	resp, err := service.Call(b.storage, "DBCreate", model.CollectionName(), model)
	if err != nil {
		log.Errorf("create cross online fight play record error %v", err)
		return nil
	}
	response := resp.(storage.Response)
	record := b.newCrossOnlineFightPlayRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

func (b *Builder) NewCrossOnlineFight(key string) *CrossOnlineFightGlobal {
	resp, err := service.Call(b.storage, "DBReadsert", "CrossOnlineFightGlobal", bson.M{"key": key}, false)
	if err != nil {
		return nil
	}
	response := resp.(storage.Response)
	db := response.Model.(*scheme.CrossOnlineFightGlobal)
	r := &CrossOnlineFightGlobal{
		CrossOnlineFightGlobalObject: scheme.NewCrossOnlineFightGlobalObject(db),
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

package arena

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

// CrossArenaPlayRecord
func (b *Builder) newCrossArenaPlayRecord(response *storage.Response) *PlayRecord {
	db := response.Model.(*scheme.CrossArenaPlayRecord)
	r := &PlayRecord{
		CrossArenaPlayRecordObject: scheme.NewCrossArenaPlayRecordObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) GetCrossArenaPlayRecord(id document.ID) *PlayRecord {
	if v, ok := b.cache.Get(id); ok {
		return v.(*PlayRecord)
	}
	resp, err := service.Call(b.storage, "DBRead", "CrossArenaPlayRecord", id, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	if response.Model == nil {
		return nil
	}
	record := b.newCrossArenaPlayRecord(&response)
	b.cache.Set(id, record)
	return record
}

func (b *Builder) CreateCrossArenaPlayRecord(model *scheme.CrossArenaPlayRecord) *PlayRecord {
	resp, err := service.Call(b.storage, "DBCreate", model.CollectionName(), model)
	if err != nil {
		log.Errorf("create cross arena play record error %v", err)
		return nil
	}
	response := resp.(storage.Response)
	record := b.newCrossArenaPlayRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

func (b *Builder) DeletePlayRecord(playRecordID document.ID) error {
	_, err := service.Call(b.storage, "DBDelete", "CrossArenaPlayRecord", playRecordID, false)
	if err != nil {
		log.Warningf("DBDelete %s:%v error %s", "CrossArenaPlayRecord", playRecordID, err)
		return err
	}
	return nil
}

// CrossArenaGlobal
func (b *Builder) NewCrossArenaGlobal(key string) *Arena {
	resp, err := service.Call(b.storage, "DBReadsert", "CrossArenaGlobal", bson.M{"key": key}, false)
	if err != nil {
		return nil
	}
	response := resp.(storage.Response)
	db := response.Model.(*scheme.CrossArenaGlobal)
	r := &Arena{
		CrossArenaGlobalObject: scheme.NewCrossArenaGlobalObject(db),
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

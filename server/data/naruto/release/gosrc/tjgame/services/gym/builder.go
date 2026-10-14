package gym

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
	cache   *util.LRUCache // cache for Record
}

// GymRecord
func (b *Builder) newGymRecord(response *storage.Response) *GymRecord {
	db := response.Model.(*scheme.GymRecord)
	r := &GymRecord{
		GymRecordObject: scheme.NewGymRecordObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) GetGymRecord(id document.ID) *GymRecord {
	if v, ok := b.cache.Get(id); ok {
		return v.(*GymRecord)
	}
	resp, err := service.Call(b.storage, "DBRead", "GymRecord", id, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	record := b.newGymRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

func (b *Builder) CreateGymRecord(model *scheme.GymRecord) *GymRecord {
	resp, err := service.Call(b.storage, "DBCreate", model.CollectionName(), model)
	if err != nil {
		log.Warningf("%s %v", model.CollectionName(), model)
		panic(err)
	}
	response := resp.(storage.Response)
	record := b.newGymRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

// GymGlobal
func (b *Builder) NewGymGlobal(key string) *Gym {
	resp, err := service.Call(b.storage, "DBReadsert", "GymGlobal", bson.M{"key": key}, false)
	if err != nil {
		return nil
	}
	response := resp.(storage.Response)
	db := response.Model.(*scheme.GymGlobal)
	r := &Gym{
		GymGlobalObject: scheme.NewGymGlobalObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

// GymPlayRecord
func (b *Builder) newGymPlayRecord(response *storage.Response) *PlayRecord {
	db := response.Model.(*scheme.GymPlayRecord)
	r := &PlayRecord{
		GymPlayRecordObject: scheme.NewGymPlayRecordObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) GetGymPlayRecord(id document.ID) *PlayRecord {
	if v, ok := b.cache.Get(id); ok {
		return v.(*PlayRecord)
	}
	resp, err := service.Call(b.storage, "DBRead", "GymPlayRecord", id, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	if response.Model == nil {
		return nil
	}
	record := b.newGymPlayRecord(&response)
	b.cache.Set(id, record)
	return record
}

func (b *Builder) CreateGymPlayRecord(model *scheme.GymPlayRecord) *PlayRecord {
	resp, err := service.Call(b.storage, "DBCreate", model.CollectionName(), model)
	if err != nil {
		log.Errorf("create gym play record error %v", err)
		return nil
	}
	response := resp.(storage.Response)
	record := b.newGymPlayRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

func NewBuilder(storage service.IService) *Builder {
	return &Builder{
		Builder: document.NewBuilder(storage),
		storage: storage,
		cache:   util.NewLRUCache(1000, nil),
	}
}

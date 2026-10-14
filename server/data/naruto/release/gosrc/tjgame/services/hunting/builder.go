package hunting

import (
	"tjgame/document"
	"tjgame/document/scheme"
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

func NewBuilder(storage service.IService) *Builder {
	return &Builder{
		Builder: document.NewBuilder(storage),
		storage: storage,
		cache:   util.NewLRUCache(5000, nil),
	}
}

// HuntingRecord
func (b *Builder) newHuntingRecord(response *storage.Response) *HuntingRecord {
	db := response.Model.(*scheme.HuntingRecord)
	r := &HuntingRecord{
		HuntingRecordObject: scheme.NewHuntingRecordObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) GetHuntingRecord(id document.ID) *HuntingRecord {
	if v, ok := b.cache.Get(id); ok {
		return v.(*HuntingRecord)
	}
	resp, err := service.Call(b.storage, "DBRead", "HuntingRecord", id, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	record := b.newHuntingRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

func (b *Builder) CreateHuntingRecord(model *scheme.HuntingRecord) *HuntingRecord {
	resp, err := service.Call(b.storage, "DBCreate", model.CollectionName(), model)
	if err != nil {
		log.Warningf("%s %v", model.CollectionName(), model)
		panic(err)
	}
	response := resp.(storage.Response)
	record := b.newHuntingRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

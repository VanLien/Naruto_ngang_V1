/*
 * @Date    : 2021/9/9 22:38
 * @File    : builder.go
 * @Version : 1.0.0
 * @Author  : hss
 * @Note    :
 *
 */

package union_fight

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

// CrossUnionFightPlayRecord
func (b *Builder) newCrossUnionFightPlayRecord(response *storage.Response) *CrossUnionFightPlayRecord {
	db := response.Model.(*scheme.CrossUnionFightPlayRecord)
	r := &CrossUnionFightPlayRecord{
		CrossUnionFightPlayRecordObject: scheme.NewCrossUnionFightPlayRecordObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) GetCrossUnionFightPlayRecord(id document.ID) *CrossUnionFightPlayRecord {
	if v, ok := b.cache.Get(id); ok {
		return v.(*CrossUnionFightPlayRecord)
	}
	resp, err := service.Call(b.storage, "DBRead", "CrossUnionFightPlayRecord", id, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	if response.Model == nil {
		return nil
	}
	record := b.newCrossUnionFightPlayRecord(&response)
	b.cache.Set(id, record)
	return record
}

func (b *Builder) CreateCrossUnionFightPlayRecord(model *scheme.CrossUnionFightPlayRecord) *CrossUnionFightPlayRecord {
	resp, err := service.Call(b.storage, "DBCreate", model.CollectionName(), model)
	if err != nil {
		log.Errorf("create cross union fight play record error %v", err)
		return nil
	}
	response := resp.(storage.Response)
	record := b.newCrossUnionFightPlayRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

// CrossUnionFightGlobal
func (b *Builder) NewCrossUnionFightGlobal(key string) *CrossUnionFightGlobal {
	resp, err := service.Call(b.storage, "DBReadsert", "CrossUnionFightGlobal", bson.M{"key": key}, false)
	if err != nil {
		return nil
	}
	response := resp.(storage.Response)
	db := response.Model.(*scheme.CrossUnionFightGlobal)
	r := &CrossUnionFightGlobal{
		CrossUnionFightGlobalObject: scheme.NewCrossUnionFightGlobalObject(db),
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

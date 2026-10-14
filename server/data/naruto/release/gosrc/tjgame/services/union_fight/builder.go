package union_fight

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
	cache   *util.LRUCache
}

func (b *Builder) newUnionFightRoleRecord(response *storage.Response) *RoleRecord {
	db := response.Model.(*scheme.UnionFightRoleRecord)
	r := &RoleRecord{
		UnionFightRoleRecordObject: scheme.NewUnionFightRoleRecordObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) GetUnionFightRoleRecord(id document.ID) *RoleRecord {
	if v, ok := b.cache.Get(id); ok {
		return v.(*RoleRecord)
	}
	resp, err := service.Call(b.storage, "DBRead", "UnionFightRoleRecord", id, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	if response.Model == nil {
		log.Warningf("UnionFightRoleRecord %v not found", id)
		return nil
	}
	record := b.newUnionFightRoleRecord(&response)
	b.cache.Set(id, record)
	return record
}

func (b *Builder) GetUnionFightRoleRecordByRoleID(roleID document.ID) *RoleRecord {
	resp, err := service.Call(b.storage, "DBReadBy", "UnionFightRoleRecord", bson.M{"role_db_id": roleID})
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	if !response.Ret || len(response.Models) == 0 {
		return nil
	} else {
		response.Model = response.Models[0]
	}
	record := b.newUnionFightRoleRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

func (b *Builder) CreateUnionFightRoleRecord(model *scheme.UnionFightRoleRecord) *RoleRecord {
	resp, err := service.Call(b.storage, "DBCreate", model.CollectionName(), model)
	if err != nil {
		log.Warningf("%s %v", model.CollectionName(), model)
		panic(err)
	}
	response := resp.(storage.Response)
	record := b.newUnionFightRoleRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

func (b *Builder) newUnionFightUnionRecord(response *storage.Response) *UnionRecord {
	db := response.Model.(*scheme.UnionFightUnionRecord)
	r := &UnionRecord{
		UnionFightUnionRecordObject: scheme.NewUnionFightUnionRecordObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) GetUnionFightUnionRecord(unionID document.ID) *UnionRecord {
	if v, ok := b.cache.Get(unionID); ok {
		return v.(*UnionRecord)
	}
	resp, err := service.Call(b.storage, "DBReadBy", "UnionFightUnionRecord", bson.M{"union_db_id": unionID})
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	if !response.Ret || len(response.Models) == 0 {
		return nil
	}
	response.Model = response.Models[0]
	record := b.newUnionFightUnionRecord(&response)
	b.cache.Set(unionID, record)
	return record
}

func (b *Builder) CreateUnionFightUnionRecord(union unionCompetitor) *UnionRecord {
	model := document.New("UnionFightUnionRecord", true).(*scheme.UnionFightUnionRecord)
	model.UnionDbId = union.ID
	model.UnionName = union.Name
	model.UnionLevel = union.Level
	model.UnionLogo = union.Logo
	resp, err := service.Call(b.storage, "DBCreate", model.CollectionName(), model)
	if err != nil {
		log.Warningf("%s %v", model.CollectionName(), model)
		panic(err)
	}
	response := resp.(storage.Response)
	record := b.newUnionFightUnionRecord(&response)
	b.cache.Set(record.UnionDbId(), record)
	return record
}

func (b *Builder) newUnionFightPlayRecord(response *storage.Response) *PlayRecord {
	db := response.Model.(*scheme.UnionFightPlayRecord)
	r := &PlayRecord{
		UnionFightPlayRecordObject: scheme.NewUnionFightPlayRecordObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) GetUnionFightPlayRecord(id document.ID) *PlayRecord {
	if v, ok := b.cache.Get(id); ok {
		return v.(*PlayRecord)
	}
	resp, err := service.Call(b.storage, "DBRead", "UnionFightPlayRecord", id, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	record := b.newUnionFightPlayRecord(&response)
	b.cache.Set(id, record)
	return record
}

func (b *Builder) CreateUnionFightPlayRecord(model *scheme.UnionFightPlayRecord) *PlayRecord {
	resp, err := service.Call(b.storage, "DBCreate", model.CollectionName(), model)
	if err != nil {
		log.Errorf("create union fight play record error %v", err)
		return nil
	}
	response := resp.(storage.Response)
	record := b.newUnionFightPlayRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

func (b *Builder) NewUnionFight(key string) *UnionFight {
	resp, err := service.Call(b.storage, "DBReadsert", "UnionFightGlobal", bson.M{"key": key}, false)
	if err != nil {
		return nil
	}
	response := resp.(storage.Response)
	r := &UnionFight{
		UnionFightGlobalObject: scheme.NewUnionFightGlobalObject(response.Model.(*scheme.UnionFightGlobal)),
	}
	b.Indicate(r, response.From)
	return r
}

func NewBuilder(storage service.IService) *Builder {
	return &Builder{
		Builder: document.NewBuilder(storage),
		storage: storage,
		cache:   util.NewLRUCache(7500, nil),
	}
}

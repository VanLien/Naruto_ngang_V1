package pvp

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

// CrossCraft
func (b *Builder) newCrossCraftRecord(response *storage.Response) *CrossCraftRecord {
	db := response.Model.(*scheme.CrossCraftRecord)
	r := &CrossCraftRecord{
		CrossCraftRecordObject: scheme.NewCrossCraftRecordObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) GetCrossCraftRecord(id document.ID) *CrossCraftRecord {
	if v, ok := b.cache.Get(id); ok {
		if v == nil {
			return nil
		}
		return v.(*CrossCraftRecord)
	}
	resp, err := service.Call(b.storage, "DBRead", "CrossCraftRecord", id, false)
	if err != nil {
		log.Error("DBRead error", "id", id, "err", err)
		return nil
	}
	if resp == nil {
		// chưa có record trong DB
		return nil
	}
	response, ok := resp.(storage.Response)
	if !ok {
		log.Error("DBRead response type invalid", "id", id, "resp", resp)
		return nil
	}
	record := b.newCrossCraftRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

func (b *Builder) GetCrossCraftRecordByRoleID(roleID document.ID) *CrossCraftRecord {
	resp, err := service.Call(b.storage, "DBReadBy", "CrossCraftRecord", bson.M{"role_db_id": roleID})
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	if !response.Ret || len(response.Models) == 0 {
		return nil
	} else {
		response.Model = response.Models[0]
	}
	record := b.newCrossCraftRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

func (b *Builder) CreateCrossCraftRecord(model *scheme.CrossCraftRecord) *CrossCraftRecord {
	var resp interface{}
	var err error
	if model.Robot {
		resp, err = service.Call(b.storage, "DBUpsert", model.CollectionName(), model.ID, model)
		if err != nil {
			log.Warningf("create robot %v error %v", model.ID, err)
			return nil
		}
	} else {
		resp, err = service.Call(b.storage, "DBCreate", model.CollectionName(), model)
		if err != nil {
			log.Warningf("%s %v", model.CollectionName(), model)
			panic(err)
		}
	}
	response := resp.(storage.Response)
	record := b.newCrossCraftRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

// CrossArena
func (b *Builder) newCrossArenaRecord(response *storage.Response) *CrossArenaRecord {
	db := response.Model.(*scheme.CrossArenaRecord)
	r := &CrossArenaRecord{
		CrossArenaRecordObject: scheme.NewCrossArenaRecordObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) GetCrossArenaRecord(id document.ID) *CrossArenaRecord {
	if v, ok := b.cache.Get(id); ok {
		return v.(*CrossArenaRecord)
	}
	resp, err := service.Call(b.storage, "DBRead", "CrossArenaRecord", id, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	record := b.newCrossArenaRecord(&response)
	b.cache.Set(record.GetID(), record)

	if len(record.DefenceCardAttrs()) == 0 { // temp fix
		record.SetDefenceCards(record.Cards())
		record.SetDefenceCardAttrs(record.CardAttrs())
	}
	return record
}

func (b *Builder) GetCrossArenaRecordByRoleID(roleID document.ID) *CrossArenaRecord {
	resp, err := service.Call(b.storage, "DBReadBy", "CrossArenaRecord", bson.M{"role_db_id": roleID})
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	if !response.Ret || len(response.Models) == 0 {
		return nil
	} else {
		response.Model = response.Models[0]
	}
	record := b.newCrossArenaRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

func (b *Builder) CreateCrossArenaRecord(model *scheme.CrossArenaRecord) *CrossArenaRecord {
	var resp interface{}
	var err error
	if model.Robot {
		resp, err = service.Call(b.storage, "DBUpsert", model.CollectionName(), model.ID, model)
		if err != nil {
			log.Warningf("create robot %v error %v", model.ID, err)
			return nil
		}
	} else {
		resp, err = service.Call(b.storage, "DBCreate", model.CollectionName(), model)
		if err != nil {
			log.Warningf("%s %v", model.CollectionName(), model)
			panic(err)
		}
	}
	response := resp.(storage.Response)
	record := b.newCrossArenaRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

// CrossOnlineFight
func (b *Builder) newCrossOnlineFightRecord(response *storage.Response) *CrossOnlineFightRecord {
	db := response.Model.(*scheme.CrossOnlineFightRecord)
	r := &CrossOnlineFightRecord{
		CrossOnlineFightRecordObject: scheme.NewCrossOnlineFightRecordObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) GetCrossOnlineFightRecord(id document.ID) *CrossOnlineFightRecord {
	if v, ok := b.cache.Get(id); ok {
		return v.(*CrossOnlineFightRecord)
	}
	resp, err := service.Call(b.storage, "DBRead", "CrossOnlineFightRecord", id, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	record := b.newCrossOnlineFightRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

func (b *Builder) CreateCrossOnlineFightRecord(model *scheme.CrossOnlineFightRecord) *CrossOnlineFightRecord {
	resp, err := service.Call(b.storage, "DBCreate", model.CollectionName(), model)
	if err != nil {
		log.Warningf("%s %v", model.CollectionName(), model)
		panic(err)
	}
	response := resp.(storage.Response)
	record := b.newCrossOnlineFightRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

// CrossMine
func (b *Builder) newCrossMineRecord(response *storage.Response) *CrossMineRecord {
	db := response.Model.(*scheme.CrossMineRecord)
	r := &CrossMineRecord{
		CrossMineRecordObject: scheme.NewCrossMineRecordObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) GetCrossMineRecord(id document.ID) *CrossMineRecord {
	if v, ok := b.cache.Get(id); ok {
		return v.(*CrossMineRecord)
	}
	resp, err := service.Call(b.storage, "DBRead", "CrossMineRecord", id, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	record := b.newCrossMineRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

func (b *Builder) CreateCrossMineRecord(model *scheme.CrossMineRecord) *CrossMineRecord {
	resp, err := service.Call(b.storage, "DBCreate", model.CollectionName(), model)
	if err != nil {
		log.Warningf("%s %v", model.CollectionName(), model)
		panic(err)
	}
	response := resp.(storage.Response)
	record := b.newCrossMineRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

// CrossUnionFightRoleRecord
func (b *Builder) newCrossUnionFightRoleRecord(response *storage.Response) *CrossUnionFightRoleRecord {
	db := response.Model.(*scheme.CrossUnionFightRoleRecord)
	r := &CrossUnionFightRoleRecord{
		CrossUnionFightRoleRecordObject: scheme.NewCrossUnionFightRoleRecordObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) GetCrossUnionFightRoleRecord(id document.ID) *CrossUnionFightRoleRecord {
	if v, ok := b.cache.Get(id); ok {
		return v.(*CrossUnionFightRoleRecord)
	}
	resp, err := service.Call(b.storage, "DBRead", "CrossUnionFightRoleRecord", id, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	record := b.newCrossUnionFightRoleRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

func (b *Builder) CreateCrossUnionFightRoleRecord(model *scheme.CrossUnionFightRoleRecord) *CrossUnionFightRoleRecord {
	resp, err := service.Call(b.storage, "DBReadBy", model.CollectionName(), bson.M{"role_db_id": model.RoleDbId})
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	if !response.Ret || len(response.Models) == 0 {
		resp2, err := service.Call(b.storage, "DBCreate", model.CollectionName(), model)
		if err != nil {
			log.Warningf("%s %v", model.CollectionName(), model)
			panic(err)
		}
		response = resp2.(storage.Response)
	} else {
		response.Model = response.Models[0]
	}
	record := b.newCrossUnionFightRoleRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

func (b *Builder) GetCrossUnionFightRoleRecordByRoleID(roleID document.ID) *CrossUnionFightRoleRecord {
	resp, err := service.Call(b.storage, "DBReadBy", "CrossUnionFightRoleRecord", bson.M{"role_db_id": roleID})
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	if !response.Ret || len(response.Models) == 0 {
		return nil
	} else {
		response.Model = response.Models[0]
	}
	record := b.newCrossUnionFightRoleRecord(&response)
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

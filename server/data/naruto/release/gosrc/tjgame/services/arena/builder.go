package arena

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
	cache   *util.LRUCache // cache for ArenaHuntingRecord
	storage service.IService
}

func (b *Builder) NewArenaRecord(response *storage.Response) *Record {
	db := response.Model.(*scheme.ArenaRecord)
	r := &Record{
		ArenaRecordObject: scheme.NewArenaRecordObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) NewArenaPlayRecord(response *storage.Response) *PlayRecord {
	db := response.Model.(*scheme.ArenaPlayRecord)
	r := &PlayRecord{
		ArenaPlayRecordObject: scheme.NewArenaPlayRecordObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) NewArenaGlobalHistory(response *storage.Response) *GlobalHistory {
	db := response.Model.(*scheme.ArenaGlobalHistory)
	r := &GlobalHistory{
		ArenaGlobalHistoryObject: scheme.NewArenaGlobalHistoryObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) newArenaGlobalHistorys(response *storage.Response) historys {
	historys := make(historys, GlobalHistoryMax)
	for _, m := range response.Models {
		db := m.(*scheme.ArenaGlobalHistory)
		history := &GlobalHistory{
			ArenaGlobalHistoryObject: scheme.NewArenaGlobalHistoryObject(db),
		}
		b.Indicate(history, response.From)
		historys.add(history)
	}
	return historys
}

func (b *Builder) NewArena(response *storage.Response) *Arena {
	db := response.Model.(*scheme.ArenaGlobal)
	r := &Arena{
		ArenaGlobalObject: scheme.NewArenaGlobalObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) GetArenaRecord(id document.ID) *Record {
	resp, err := service.Call(b.storage, "DBRead", "ArenaRecord", id, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	record := b.NewArenaRecord(&response)
	return record
}

// ArenaHuntingRecord
type ArenaHuntingRecord struct {
	*scheme.ArenaHuntingRecordObject
}

func (b *Builder) newArenaHuntingRecord(response *storage.Response) *ArenaHuntingRecord {
	db := response.Model.(*scheme.ArenaHuntingRecord)
	r := &ArenaHuntingRecord{
		ArenaHuntingRecordObject: scheme.NewArenaHuntingRecordObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) GetArenaHuntingRecord(id document.ID) *ArenaHuntingRecord {
	if v, ok := b.cache.Get(id); ok {
		return v.(*ArenaHuntingRecord)
	}
	resp, err := service.Call(b.storage, "DBRead", "ArenaHuntingRecord", id, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	record := b.newArenaHuntingRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

func (b *Builder) CreateArenaHuntingRecord(roleID document.ID) *ArenaHuntingRecord {
	resp, err := service.Call(b.storage, "DBReadsert", "ArenaHuntingRecord", bson.M{"role_db_id": roleID}, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	record := b.newArenaHuntingRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

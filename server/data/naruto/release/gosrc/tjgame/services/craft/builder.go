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
	cache   *util.LRUCache // cache for Record and PlayRecord
}

func (b *Builder) newCraftRecord(response *storage.Response) *Record {
	db := response.Model.(*scheme.CraftRecord)
	r := &Record{
		CraftRecordObject: scheme.NewCraftRecordObject(db),
	}
	b.Indicate(r, response.From)
	if !db.Robot && len(db.HoldCards) == 0 { // 旧数据可能为空
		r.SetHoldCards(db.Cards)
	}
	return r
}

func (b *Builder) GetCraftRecord(id document.ID) *Record {
	if v, ok := b.cache.Get(id); ok {
		return v.(*Record)
	}
	resp, err := service.Call(b.storage, "DBRead", "CraftRecord", id, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	record := b.newCraftRecord(&response)
	b.cache.Set(id, record)
	return record
}

func (b *Builder) GetCraftRecordByRoleID(roleID document.ID) *Record {
	resp, err := service.Call(b.storage, "DBReadBy", "CraftRecord", bson.M{"role_db_id": roleID})
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	if !response.Ret || len(response.Models) == 0 {
		return nil
	} else {
		response.Model = response.Models[0]
	}
	record := b.newCraftRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

func (b *Builder) CreateCraftRecord(model *scheme.CraftRecord) *Record {
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
	record := b.newCraftRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

func (b *Builder) newCraftPlayRecord(response *storage.Response) *PlayRecord {
	defer func() {
		if err := recover(); err != nil {
			log.Errorf("create craft play record panic", err)
		}
	}()
	//db := response.Model.(*scheme.CraftPlayRecord)
	var db *scheme.CraftPlayRecord
	if response.Model != nil {
		switch v := response.Model.(type) {
		case *scheme.CraftPlayRecord:
			db = v
		default:
			log.Errorf("unexpected type %T for CraftPlayRecord model", v)
			return nil
		}
	}
	r := &PlayRecord{
		CraftPlayRecordObject: scheme.NewCraftPlayRecordObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) GetCraftPlayRecord(id document.ID) *PlayRecord {
	// if id == document.ID("") {
	// 	// id is equal to the zero value of the document.ID type
	// 	log.Errorf("id nil")
	// } else {
	// 	// id is not equal to the zero value of the document.ID type
	// 	log.Infof("id not nil ", id)
	// }
    //add by baohong
	if v, ok := b.cache.Get(id); ok {
		log.Infof("get cache record ", id)
		return v.(*PlayRecord)
	}

	resp, err := service.Call(b.storage, "DBRead", "CraftPlayRecord", id, false)
	if err != nil {
		log.Errorf("==========panic: ", err)
		panic(err)
	}
	response,ok_response := resp.(storage.Response)
	if !ok_response {
		log.Errorf("response not ok: ", ok_response)
        return nil
    }
	record := b.newCraftPlayRecord(&response)
	if record == nil {
		log.Errorf("failed to create PlayRecord")
        return nil
    }
	b.cache.Set(id, record)
	return record
}



// func (b *Builder) newCraftPlayRecord(response *storage.Response) *PlayRecord {
// 	db := response.Model.(*scheme.CraftPlayRecord)
// 	r := &PlayRecord{
// 		CraftPlayRecordObject: scheme.NewCraftPlayRecordObject(db),
// 	}
// 	b.Indicate(r, response.From)
// 	return r
// }

// func (b *Builder) GetCraftPlayRecord(id document.ID) *PlayRecord {
// 	if v, ok := b.cache.Get(id); ok {
// 		return v.(*PlayRecord)
// 	}

// 	resp, err := service.Call(b.storage, "DBRead", "CraftPlayRecord", id, false)
// 	if err != nil {
// 		panic(err)
// 	}
// 	response := resp.(storage.Response)
// 	record := b.newCraftPlayRecord(&response)
// 	b.cache.Set(id, record)
// 	return record
// }

func (b *Builder) CreateCraftPlayRecord(model *scheme.CraftPlayRecord) *PlayRecord {
	resp, err := service.Call(b.storage, "DBCreate", model.CollectionName(), model)
	if err != nil {
		log.Errorf("create craft play record error %v", err)
		return nil
	}
	response := resp.(storage.Response)
	record := b.newCraftPlayRecord(&response)
	b.cache.Set(record.GetID(), record)
	return record
}

func (b *Builder) NewCraft(key string) *Craft {
	resp, err := service.Call(b.storage, "DBReadsert", "CraftGlobal", bson.M{"key": key}, false)
	if err != nil {
		return nil
	}
	response := resp.(storage.Response)
	db := response.Model.(*scheme.CraftGlobal)
	r := &Craft{
		CraftGlobalObject: scheme.NewCraftGlobalObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func NewBuilder(storage service.IService) *Builder {
	return &Builder{
		Builder: document.NewBuilder(storage),
		storage: storage,
		cache:   util.NewLRUCache(5000, nil),
	}
}

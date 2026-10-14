package huodongboss

import (
	"tjgame/document"
	"tjgame/document/scheme"
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

func (b *Builder) NewHuoDongBossGlobal(key string, group int) *HuoDongBoss {
	resp, err := service.Call(b.storage, "DBReadsert", "HuoDongBossGlobal", bson.M{"key": key, "group": group}, false)
	if err != nil {
		return nil
	}
	response := resp.(storage.Response)
	db := response.Model.(*scheme.HuoDongBossGlobal)
	r := &HuoDongBoss{
		HuoDongBossGlobalObject: scheme.NewHuoDongBossGlobalObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) NewHuoDongBossGlobalByModel(model document.IDocument, from string) *HuoDongBoss {
	db := model.(*scheme.HuoDongBossGlobal)
	r := &HuoDongBoss{
		HuoDongBossGlobalObject: scheme.NewHuoDongBossGlobalObject(db),
	}
	b.Indicate(r, from)
	return r
}

func NewBuilder(storage service.IService) *Builder {
	return &Builder{
		Builder: document.NewBuilder(storage),
		storage: storage,
		cache:   util.NewLRUCache(1000, nil),
	}
}

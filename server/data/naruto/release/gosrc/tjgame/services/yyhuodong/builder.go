package yyhuodong

import (
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/mgo.v2/bson"
	"tjgame/server_framework/tj/service"
	"tjgame/services/storage"
)

type Builder struct {
	*document.Builder
	storage service.IService
}

func NewBuilder(storage service.IService) *Builder {
	return &Builder{
		Builder: document.NewBuilder(storage),
		storage: storage,
	}
}

// WorldBossGlobal
func (b *Builder) NewWorldBossGlobal(key string) *WorldBossGlobal {
	resp, err := service.Call(b.storage, "DBReadsert", "WorldBossGlobal", bson.M{"key": key}, false)
	if err != nil {
		return nil
	}
	response := resp.(storage.Response)
	db := response.Model.(*scheme.WorldBossGlobal)
	r := &WorldBossGlobal{
		WorldBossGlobalObject: scheme.NewWorldBossGlobalObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) NewBraveChallengeRecord(response *storage.Response) *BraveChallengeRecord {
	db := response.Model.(*scheme.BraveChallengeRecord)
	r := &BraveChallengeRecord{
		BraveChallengeRecordObject: scheme.NewBraveChallengeRecordObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

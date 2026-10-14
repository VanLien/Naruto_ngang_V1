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

// HorseRaceGlobal
func (b *Builder) NewHorseRaceGlobal(key string) *HorseRaceGlobal {
	resp, err := service.Call(b.storage, "DBReadsert", "HorseRaceGlobal", bson.M{"key": key}, false)
	if err != nil {
		return nil
	}
	response := resp.(storage.Response)
	db := response.Model.(*scheme.HorseRaceGlobal)
	r := &HorseRaceGlobal{
		HorseRaceGlobalObject: scheme.NewHorseRaceGlobalObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

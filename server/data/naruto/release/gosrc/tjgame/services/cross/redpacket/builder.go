package redpacket

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

	storage service.IService
	cache   *util.LRUCache // cache for PlayRecord
}

func (b *Builder) NewCrossRedPacketGlobal(key string, group int) *RedPacket {
	resp, err := service.Call(b.storage, "DBReadsert", "CrossRedPacketGlobal", bson.M{"key": key, "group": group}, false)
	if err != nil {
		return nil
	}
	response := resp.(storage.Response)
	db := response.Model.(*scheme.CrossRedPacketGlobal)
	r := &RedPacket{
		CrossRedPacketGlobalObject: scheme.NewCrossRedPacketGlobalObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) NewCrossRedPacketGlobalByModel(model document.IDocument, from string) *RedPacket {
	db := model.(*scheme.CrossRedPacketGlobal)
	r := &RedPacket{
		CrossRedPacketGlobalObject: scheme.NewCrossRedPacketGlobalObject(db),
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

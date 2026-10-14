package ranking

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

func NewBuilder(storage service.IService) *Builder {
	return &Builder{
		Builder: document.NewBuilder(storage),
		storage: storage,
		cache:   util.NewLRUCache(1000, nil),
	}
}

func (b *Builder) NewRankGlobal(key, gamePlay string, group int) Ranker {
	return b.NewCrossRankingGlobal(gamePlay, key, group)
}

func (b *Builder) NewRankGlobalByModel(model document.IDocument, from string) Ranker {
	return b.NewCrossRankingGlobalByModel(model, from)
}

func (b *Builder) NewCrossRankingGlobal(key, gamePlay string, group int) *CrossRanking {
	resp, err := service.Call(b.storage, "DBReadsert", "CrossRankingGlobal", bson.M{"key": key, "game_play": gamePlay, "group": group}, false)
	if err != nil {
		return nil
	}
	response := resp.(storage.Response)
	db := response.Model.(*scheme.CrossRankingGlobal)
	r := &CrossRanking{
		CrossRankingGlobalObject: scheme.NewCrossRankingGlobalObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) NewCrossRankingGlobalByModel(model document.IDocument, from string) *CrossRanking {
	db := model.(*scheme.CrossRankingGlobal)
	r := &CrossRanking{
		CrossRankingGlobalObject: scheme.NewCrossRankingGlobalObject(db),
	}
	b.Indicate(r, from)
	return r
}

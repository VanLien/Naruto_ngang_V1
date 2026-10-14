package card_score

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
	cache   *util.LRUCache
}

func (b *Builder) newCardScoreGlobal(key string) *CardScoreGlobal {
	resp, err := service.Call(b.storage, "DBReadsert", "CardScoreGlobal", bson.M{"key": key}, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	db := response.Model.(*scheme.CardScoreGlobal)
	r := &CardScoreGlobal{
		CardScoreGlobalObject: scheme.NewCardScoreGlobalObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) newCardScoreRole(response *storage.Response) *CardScoreRole {
	db := response.Model.(*scheme.CardScoreRole)
	r := &CardScoreRole{CardScoreRoleObject: scheme.NewCardScoreRoleObject(db)}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) GetCardScoreRole(id document.ID) *CardScoreRole {
	if v, ok := b.cache.Get(id); ok {
		return v.(*CardScoreRole)
	}
	resp, err := service.Call(b.storage, "DBReadBy", "CardScoreRole", bson.M{"role_db_id": id})
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	if !response.Ret || len(response.Models) == 0 {
		return nil
	}
	response.Model = response.Models[0]
	record := b.newCardScoreRole(&response)
	b.cache.Set(id, record)
	return record
}

func (b *Builder) CreateCardScoreRole(roleID document.ID, gameKey string) *CardScoreRole {
	model := document.New("CardScoreRole", true).(*scheme.CardScoreRole)
	model.RoleID = roleID
	model.GameKey = gameKey
	model.CardScore = make(map[document.Integer]int)

	resp, err := service.Call(b.storage, "DBCreate", model.CollectionName(), model)
	if err != nil {
		log.Warningf("CreateCardCommentRole %s %v", model.CollectionName(), model)
		panic(err)
	}
	response := resp.(storage.Response)
	record := b.newCardScoreRole(&response)
	b.cache.Set(record.RoleID(), record)
	return record
}

func NewBuilder(storage service.IService) *Builder {
	return &Builder{
		Builder: document.NewBuilder(storage),
		storage: storage,
		cache:   util.NewLRUCache(10000, nil),
	}
}

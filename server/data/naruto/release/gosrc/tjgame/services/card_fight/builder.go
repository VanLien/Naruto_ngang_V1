package card_fight

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

func (b *Builder) newCardScoreGlobal(key string) *CardFightGlobal {
	resp, err := service.Call(b.storage, "DBReadsert", "CardFightGlobal", bson.M{"key": key}, false)
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	db := response.Model.(*scheme.CardFightGlobal)
	r := &CardFightGlobal{
		CardFightGlobalObject: scheme.NewCardFightGlobalObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) getCardFightTop200Cards(cardIDs []int) []storage.CardFightCard {
	resp, err := service.Call(b.storage, "CardFightTop200Cards", cardIDs)
	if err != nil {
		panic(err)
	}
	return resp.([]storage.CardFightCard)
}

func (b *Builder) getCardFightTop200Roles(roleIDs []document.ID) []storage.CardFightRole {
	resp, err := service.Call(b.storage, "CardFightTop200Roles", roleIDs)
	if err != nil {
		panic(err)
	}
	return resp.([]storage.CardFightRole)
}


func NewBuilder(storage service.IService) *Builder {
	return &Builder{
		Builder: document.NewBuilder(storage),
		storage: storage,
	}
}

package card_comment

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
	manager *Manager

	storage service.IService
}

func (b *Builder) newCardComment(response *storage.Response) *CardComment {
	db := response.Model.(*scheme.CardComment)
	r := &CardComment{CardCommentObject: scheme.NewCardCommentObject(db)}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) GetCardComment(commentID document.ID) *CardComment {
	if v, ok := b.manager.getCardCommentByCache(commentID); ok {
		return v
	}
	resp, err := service.Call(b.storage, "DBRead", "CardComment", commentID, false)
	if err != nil {
		log.Warningf("CardComment %v not find err %v", commentID, err)
		return nil
	}
	response := resp.(storage.Response)
	if response.Model == nil {
		log.Warningf("CardComment %v not find", commentID)
		return nil
	}
	record := b.newCardComment(&response)
	b.manager.setCardCommentCache(record)
	return record
}

func (b *Builder) CreateCardComment(roleID document.ID, markID int, content string) *CardComment {
	model := document.New("CardComment", true).(*scheme.CardComment)
	model.MarkID = markID
	model.Content = content
	model.RoleID = roleID
	model.Time = int(util.NowTime())
	resp, err := service.Call(b.storage, "DBCreate", model.CollectionName(), model)
	if err != nil {
		log.Warningf("CreateCardComment %s %v", model.CollectionName(), model)
		panic(err)
	}
	response := resp.(storage.Response)
	record := b.newCardComment(&response)
	return record
}

func (b *Builder) CardCommentQuery(markID, limit int, roleID document.ID, sortFields []string) []*CardComment {
	resp, err := service.Call(b.storage, "CardCommentQuery", markID, limit, roleID, sortFields)
	if err != nil {
		log.Errorf("CardCommentRangeQuery %v", err)
		return []*CardComment{}
	}
	response := resp.(storage.Response)

	if !response.Ret || len(response.Models) == 0 {
		return []*CardComment{}
	}

	ret := make([]*CardComment, 0, len(response.Models))
	for _, model := range response.Models {
		db := model.(*scheme.CardComment)
		var r *CardComment
		if v, ok := b.manager.getCardCommentByCache(db.GetID()); ok {
			r = v
		} else {
			r = &CardComment{CardCommentObject: scheme.NewCardCommentObject(db)}
			b.Indicate(r, response.From)
		}
		ret = append(ret, r)
	}

	return ret
}

func (b *Builder) newCardCommentRole(response *storage.Response) *CardCommentRole {
	db := response.Model.(*scheme.CardCommentRole)
	r := &CardCommentRole{CardCommentRoleObject: scheme.NewCardCommentRoleObject(db)}
	b.Indicate(r, response.From)
	return r
}

func (b *Builder) GetCardCommentRole(id document.ID) *CardCommentRole {
	if v, ok := b.manager.getRoleByCache(id); ok {
		return v
	}
	resp, err := service.Call(b.storage, "DBReadBy", "CardCommentRole", bson.M{"role_db_id": id})
	if err != nil {
		panic(err)
	}
	response := resp.(storage.Response)
	if !response.Ret || len(response.Models) == 0 {
		return nil
	}
	response.Model = response.Models[0]
	record := b.newCardCommentRole(&response)
	record.init()
	b.manager.setRoleCache(record)
	return record
}

func (b *Builder) CreateCardCommentRole(role ReqRole) *CardCommentRole {
	model := document.New("CardCommentRole", true).(*scheme.CardCommentRole)
	model.RoleID = role.RoleID
	model.GameKey = role.GameKey
	model.Name = role.Name
	model.Logo = role.Level
	model.Frame = role.Frame
	model.Level = role.Level
	model.Vip = role.Vip
	resp, err := service.Call(b.storage, "DBCreate", model.CollectionName(), model)
	if err != nil {
		log.Warningf("CreateCardCommentRole %s %v", model.CollectionName(), model)
		panic(err)
	}
	response := resp.(storage.Response)
	record := b.newCardCommentRole(&response)
	record.init()
	b.manager.setRoleCache(record)
	return record
}

func (b *Builder) DeleteCardComment(commentID document.ID) error {
	_, err := service.Call(b.storage, "DBDelete", "CardComment", commentID, false)
	if err != nil {
		log.Warningf("DBDelete %s:%v error %s", "CardComment", commentID, err)
		return err
	}
	return nil
}

func NewBuilder(storage service.IService) *Builder {
	return &Builder{
		Builder: document.NewBuilder(storage),
		storage: storage,
	}
}

func (b *Builder) setManager(mgr *Manager) {
	b.manager = mgr
}

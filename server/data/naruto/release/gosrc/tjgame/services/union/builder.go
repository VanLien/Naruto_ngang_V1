package union

import (
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/storage"

	"tjgame/mgo.v2/bson"
)

type builder struct {
	*document.Builder
}

func (b *builder) NewUnion(response *storage.Response, refresh bool) *Union {
	db := response.Model.(*scheme.Union)
	r := &Union{
		UnionObject: scheme.NewUnionObject(db),
		camp:        NewTrainingCamp(),
		redpackets:  NewAllRedPackets(),
	}
	b.Indicate(r, response.From)
	r.init(refresh)
	return r
}

func (b *builder) NewRedPacket(response *storage.Response) *RedPacket {
	db := response.Model.(*scheme.UnionRedPacket)
	r := &RedPacket{
		UnionRedPacketObject: scheme.NewUnionRedPacketObject(db),
	}
	b.Indicate(r, response.From)
	return r
}

func (b *builder) NewUnionFuben(response *storage.Response, union *Union) *Fuben {
	db := response.Model.(*scheme.UnionFuben)
	r := &Fuben{
		UnionFubenObject: scheme.NewUnionFubenObject(db),
		union:            union,
	}
	b.Indicate(r, response.From)
	r.Refresh()
	return r
}

func (b *builder) NewUnionTraining(response *storage.Response) *Training {
	db := response.Model.(*scheme.UnionTraining)
	r := &Training{
		UnionTrainingObject: scheme.NewUnionTrainingObject(db),
	}
	b.Indicate(r, response.From)
	r.init()
	return r
}

func (b *builder) CreateUnionRedPacket(s service.IService, unionID document.ID, packetType int) (*RedPacket, error) {
	model := document.New("UnionRedPacket", true).(*scheme.UnionRedPacket)
	model.UnionDbId = unionID
	model.PacketType = packetType
	model.CreatedTime = util.NowTime()
	model.DiscardFlag = false
	// 复用过期的id
	reuse := false
	if id := FreePacketList.Get(); id != "" {
		model.ID = id
		reuse = true
	}

	resp, err := service.Call(s, "DBCreate", model.CollectionName(), model)
	if err != nil {
		return nil, err
	}
	response := resp.(storage.Response)
	packet := b.NewRedPacket(&response)
	if reuse {
		packet.ReuseID()
	}
	return packet, nil
}

func (b *builder) CreateUnionTraining(s service.IService, roleID document.ID) (*Training, error) {
	resp, err := service.Call(s, "DBReadsert", "UnionTraining", bson.M{"role_db_id": roleID}, false)
	if err != nil {
		return nil, err
	}
	response := resp.(storage.Response)
	return b.NewUnionTraining(&response), nil
}

func (b *builder) CreateUnionFuben(s service.IService, union *Union) (*Fuben, error) {
	resp, err := service.Call(s, "DBReadsert", "UnionFuben", bson.M{"union_db_id": union.GetID()}, false)
	if err != nil {
		return nil, err
	}
	response := resp.(storage.Response)
	return b.NewUnionFuben(&response, union), nil
}

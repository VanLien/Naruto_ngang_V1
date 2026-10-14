package codec

/*
import (
	"reflect"

	"tjgame/server_framework/tj/log"
)

type MsgRegister interface {
	RegisterMsgHandler(msgID int32, msg interface{}, h Handler)
	RegisterMsgHandlers(handlers []MsgHandler)
}

type MsgRegisterGetter interface {
	MsgRegister

	GetMsgID(msg interface{}) (int32, error)
	GetMsgType(msgID int32) (reflect.Type, bool)
	GetMsgHandler(msgID int32) Handler
}

type MsgHandler struct {
	MsgID   int32
	Msg     interface{}
	Handler Handler
}

type Map struct {
	ID2Type    map[int32]reflect.Type
	Type2ID    map[reflect.Type]int32
	ID2Handler map[int32]Handler
}

func (p *Map) RegisterMsgHandler(msgID int32, msg interface{}, h Handler) {
	if _, ok := p.ID2Handler[msgID]; ok {
		log.Panic("existed msgID", msgID)
	}

	if msg != nil {
		rt := reflect.TypeOf(msg)
		if rt.Kind() == reflect.Ptr {
			rt = rt.Elem()
		}
		if _, ok := p.Type2ID[rt]; ok {
			log.Panic("existed msgType", rt)
		}
		p.ID2Type[msgID] = rt
		p.Type2ID[rt] = msgID
	}
	p.ID2Handler[msgID] = h
}

func (p *Map) RegisterMsgHandlers(handlers []MsgHandler) {
	for _, h := range handlers {
		p.RegisterMsgHandler(h.MsgID, h.Msg, h.Handler)
	}
}

func (p *Map) GetMsgID(msg interface{}) (int32, error) {
	rt := reflect.TypeOf(msg)
	if rt.Kind() == reflect.Ptr {
		rt = rt.Elem()
	}
	msgID, ok := p.Type2ID[rt]
	if !ok {
		return 0, NoSuchMsgType
	}
	return msgID, nil
}

func (p *Map) GetMsgType(msgID int32) (reflect.Type, bool) {
	rt, ok := p.ID2Type[msgID]
	if !ok {
		return nil, false
	}
	return rt, true
}

func (p *Map) GetMsgHandler(msgID int32) Handler {
	h := p.ID2Handler[msgID]
	return h
}

func NewMap() *Map {
	return &Map{
		ID2Type:    make(map[int32]reflect.Type),
		Type2ID:    make(map[reflect.Type]int32),
		ID2Handler: make(map[int32]Handler),
	}
}
*/

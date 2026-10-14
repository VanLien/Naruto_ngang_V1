package storage

import (
	"tjgame/document"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
	"tjgame/ugorji_go/codec"

	mgo "tjgame/mgo.v2"
)

type errDecode struct {
	err error
}

func (d *errDecode) decode(raw codec.Raw, result interface{}) {
	if d.err != nil {
		return
	}
	d.err = util.MsgUnpack(raw, result)
}

type Response struct {
	Ret    bool
	Err    string
	Model  document.IDocument
	Models []document.IDocument
	From   string

	name     string
	multiple bool
}

func (r *Response) RespLock() {
	panic("implement me")
}

func (r *Response) RespUnlock() {
	panic("implement me")
}

func (r *Response) CodecEncodeSelf(e *codec.Encoder) {
	v := &struct {
		Ret    bool                 `codec:"ret"`
		Err    string               `codec:"err"`
		Model  document.IDocument   `codec:"model"`
		Models []document.IDocument `codec:"models"`
		From   string               `codec:"from"`
	}{r.Ret, r.Err, r.Model, r.Models, r.From}
	if err := e.Encode(v); err != nil {
		log.Error(err)
	}
}

func (r *Response) CodecDecodeSelf(e *codec.Decoder) {
	v := &struct {
		Ret    bool        `codec:"ret"`
		Err    string      `codec:"err"`
		Model  codec.Raw   `codec:"model"`
		Models []codec.Raw `codec:"models"`
		From   string      `codec:"from"`
	}{}
	err := e.Decode(v)
	if err != nil {
		log.Error(err)
		return
	}
	r.Ret = v.Ret
	r.Err = v.Err
	r.From = v.From
	var dec errDecode
	if v.Model != nil {
		r.Model = document.New(r.name, false)
		dec.decode(v.Model, r.Model)
	}
	if v.Models != nil {
		r.Models = make([]document.IDocument, len(v.Models))
		for i, raw := range v.Models {
			r.Models[i] = document.New(r.name, false)
			dec.decode(raw, r.Models[i])
		}
	}
	if dec.err != nil {
		log.Errorf("Response decode error: %v", dec.err)
	}
}

func (r *Response) SetMultiple(multiple bool) {
	r.multiple = multiple
}

func (r *Response) Write(err error, docs ...*Document) {
	if err != nil {
		r.Ret = false
		r.Err = err.Error()
		if err != mgo.ErrNotFound && err != ErrNoAccount && err != ErrExistedName {
			log.Error(err)
		}
	} else {
		r.Ret = true
	}
	if docs == nil || !r.Ret {
		return
	}
	if r.multiple {
		r.Models = make([]document.IDocument, len(docs))
		for i, doc := range docs {
			r.Models[i] = doc.IDocument
		}
	} else {
		r.Model = docs[0].IDocument
	}
}

func NewResponse(from string) *Response {
	return &Response{
		From: from,
	}
}

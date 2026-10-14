package task

import (
	"fmt"
	tjnet "tjgame/server_framework/tj/net"
	"tjgame/server_framework/tj/service"

	"errors"
)

const GameServInternalPassword = "huanxi2394fd79a1ad32ff2e2db603da"

type Record struct {
	account      interface{}
	channel      string
	conn         *tjnet.Conn
	rpc          IRPCOwner
	isNewAccount bool
	Pwd          []byte
}

// c -> s
type Task interface {
	Run(*Record) interface{}
}

// s -> c
type Msg interface {
}

type TaskCreater interface {
	Url() string
	New() Task
}

type MsgCreater interface {
	Url() string
	New() Msg
}

type IRPCOwner interface {
	Storage() service.IService
	Game(string) service.IService
}

type TaskCreaterMap map[string]TaskCreater
type MsgCreaterMap map[string]MsgCreater

var Factory TaskCreaterMap
var MsgFactory MsgCreaterMap

func (t TaskCreaterMap) Register(creater TaskCreater) {
	t[creater.Url()] = creater
}

func (t TaskCreaterMap) CreateByUrl(url string) (Task, error) {
	if creater, ok := t[url]; ok {
		return creater.New(), nil
	}
	return nil, errors.New(fmt.Sprintf("no such url, %s", url))
}

func (t MsgCreaterMap) Register(creater MsgCreater) {
	t[creater.Url()] = creater
}

func (t MsgCreaterMap) CreateByUrl(url string) (Msg, error) {
	if creater, ok := t[url]; ok {
		return creater.New(), nil
	}
	return nil, errors.New(fmt.Sprintf("no such url, %s", url))
}

func NewRecord(conn *tjnet.Conn, rpc IRPCOwner) *Record {
	return &Record{
		conn: conn,
		rpc:  rpc,
	}
}

func init() {
	Factory = make(TaskCreaterMap)
	MsgFactory = make(MsgCreaterMap)

	// TODO: automation gen to taskdefins.lua
	Factory.Register(TaskCheck{})
	Factory.Register(TaskConfirm{})
	Factory.Register(TaskEnterServer{})
	Factory.Register(TaskEnterOK{})

	MsgFactory.Register(MsgFull{})
	MsgFactory.Register(MsgKick{})
}

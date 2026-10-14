package caller

import (
	"fmt"
	"reflect"
	"sync"
)

const (
	Global ServiceMethodType = iota
	RPC
	Notify
)

type ServiceMethodType int
type NewRespFunc func(args ...interface{}) interface{}

type IRPCClient interface {
	Call(method string, result interface{}, args ...interface{}) (interface{}, error)
	ServiceCall(*FuncServiceInfo, interface{}, ...interface{}) (interface{}, error)
}

type RPCCaller struct {
	Client IRPCClient

	resps sync.Map // map[string]*FuncServiceInfo
}

type FuncServiceInfo struct {
	Rcvr      interface{}
	RespNew   NewRespFunc
	ServiceID string
	Name      string
	Method    reflect.Method
	CallType  ServiceMethodType

	respType reflect.Type
}

func NewFuncServiceInfo(typ ServiceMethodType, serviceID string, resolver interface{}, method string, respNew NewRespFunc) *FuncServiceInfo {
	m, _ := reflect.TypeOf(resolver).MethodByName(method)
	rt := m.Func.Type().Out(0)

	return &FuncServiceInfo{
		ServiceID: serviceID,
		Name:      method,
		Method:    m,
		CallType:  typ,
		Rcvr:      resolver,
		RespNew:   respNew,

		respType: rt,
	}
}

func (c *RPCCaller) Register(info FuncServiceInfo) {
	// RPCCaller is remote caller, so f is nil
	// only need method Name
	c.resps.Store(info.Name, &info)
}

func (c *RPCCaller) CanCall(method string) bool {
	_, ok := c.resps.Load(method)
	return ok
}

func (c *RPCCaller) CallInGo(method string, args ...interface{}) (resp interface{}, err error) {
	var r interface{}
	var info *FuncServiceInfo
	if v, ok := c.resps.Load(method); ok {
		info = v.(*FuncServiceInfo)
		method = fmt.Sprintf("%s|%s", info.ServiceID, method)
		if info.RespNew != nil {
			r = info.RespNew(args...)
			if r == nil {
				err = ErrCallRespNewIsNil
				return
			}
		} else {
			r = reflect.New(info.respType).Interface()
		}
	} else {
		// may be old msgpackrpc style, but not used
		r = resp
	}

	if info == nil {
		_, err = c.Client.Call(method, r, args...)
	} else {
		_, err = c.Client.ServiceCall(info, r, args...)
	}

	if err != nil {
		resp = nil
	}
	if r != nil {
		resp = reflect.ValueOf(r).Elem().Interface()
	}
	return
}

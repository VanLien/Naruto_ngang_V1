package caller

import (
	"reflect"
	"sync"
	"tjgame/server_framework/tj/log"
)

var errorType = reflect.TypeOf((*error)(nil)).Elem()

// in-process f caller, like native f
type FuncCaller struct {
	funcs sync.Map
}

type funcType struct {
	rcvr  reflect.Value
	f     reflect.Value
	targs []reflect.Type
}

func CheckFunc(m reflect.Method, respNew NewRespFunc) bool {
	mt := m.Type
	if mt.NumOut() != 2 {
		log.Errorf("func had %d return, only need two", mt.NumOut())
		return false
	}

	if respNew != nil {
		rt := reflect.TypeOf(respNew)
		if rt.Kind() == reflect.Func {
			rt = rt.Out(0)
		}
		// could not determinate type assert in compile period, the chance in runtime
		//if !rt.AssignableTo(mt.Out(0)) {
		//	log.Errorf("resp new func return %s could not assign to %s", rt, mt.Out(0))
		//	return false
		//}
	}

	if !mt.Out(1).Implements(errorType) {
		log.Error("func need the second return is error type")
		return false
	}
	return true
}

// f is func(a,b,c,d,...) (resp interface{}, err error)
func (c *FuncCaller) Register(info FuncServiceInfo) {
	t := info.Method.Type
	v := info.Method.Func
	argTypes := make([]reflect.Type, t.NumIn()-1) // first is receiver
	for i := 0; i < len(argTypes); i++ {
		argTypes[i] = t.In(i)
	}

	c.funcs.Store(info.Name, &funcType{
		rcvr:  reflect.ValueOf(info.Rcvr),
		f:     v,
		targs: argTypes,
	})
}

func (c *FuncCaller) CanCall(method string) bool {
	_, ok := c.funcs.Load(method)
	return ok
}

func (c *FuncCaller) CallInGo(method string, args ...interface{}) (resp interface{}, err error) {
	i, ok := c.funcs.Load(method)
	if !ok {
		log.Warningf("method %s not exist", method)
		err = ErrCallInvalid
		return
	}

	ftype := i.(*funcType)
	ivs := make([]reflect.Value, len(ftype.targs)+1)
	ivs[0] = ftype.rcvr
	for i := 0; i < len(ftype.targs); i++ {
		ivs[i+1] = reflect.ValueOf(args[i])

		// strict type check
		//fmt.Println(reflect.TypeOf(args[i]), ftype.targs[i], reflect.TypeOf(args[i]).ConvertibleTo(ftype.targs[i]))
		//if reflect.TypeOf(args[i]) != ftype.targs[i] {
		//	ivs[i] = reflect.ValueOf(args[i]).Convert(ftype.targs[i])
		//} else {
		//	ivs[i] = reflect.ValueOf(args[i])
		//}
	}

	rets := ftype.f.Call(ivs)
	if !rets[1].IsNil() {
		err = rets[1].Interface().(error)
	}
	resp = rets[0].Interface()
	return
}

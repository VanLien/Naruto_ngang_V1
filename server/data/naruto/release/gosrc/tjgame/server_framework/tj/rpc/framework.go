package rpc

import (
	"errors"
	"fmt"
	"io"
	"net/rpc"
	"reflect"
	"strings"
	"sync"
	"sync/atomic"
	"unicode"
	"unicode/utf8"

	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
)

var nilValue = reflect.ValueOf(nil)

type IServiceReceiver interface {
	Name() string
}

// copy from net/rpc/server.go

// Precompute the reflect type for error. Can't use error directly
// because Typeof takes an empty interface value. This is annoying.
var typeOfError = reflect.TypeOf((*error)(nil)).Elem()

type methodType struct {
	rcvr          reflect.Value // may be not same with service.rcvr in tj service
	method        reflect.Method
	argTypes      []reflect.Type
	replyType     reflect.Type // always pointer
	replyElemType reflect.Type
	isTJFormat    bool
	numCalls      uint32
}

type service struct {
	name   string                 // name of service
	rcvr   reflect.Value          // receiver of methods for the service
	typ    reflect.Type           // type of the receiver
	method map[string]*methodType // registered methods
}

// Request is a header written before every RPC call. It is used internally
// but documented here as an aid to debugging, such as when analyzing
// network traffic.
type Request struct {
	rpc.Request
	next *Request // for free list in Server
}

// Response is a header written before every RPC return. It is used internally
// but documented here as an aid to debugging, such as when analyzing
// network traffic.
type Response struct {
	rpc.Response
	next *Response // for free list in Server
}

// RPCFramework
type RPCFramework struct {
	serviceMap sync.Map   // map[string]*service
	reqLock    sync.Mutex // protects freeReq
	freeReq    *Request
	respLock   sync.Mutex // protects freeResp
	freeResp   *Response
}

type MethodInfo struct {
	Name       string // resolver name
	MethodName string // method name
}

type ResultInfo struct {
	Error  error
	Result interface{}
}

// Is this an exported - upper case - name?
func isExported(name string) bool {
	rune, _ := utf8.DecodeRuneInString(name)
	return unicode.IsUpper(rune)
}

// Is this type exported or a builtin?
func isExportedOrBuiltinType(t reflect.Type) bool {
	for t.Kind() == reflect.Ptr {
		t = t.Elem()
	}
	// PkgPath will be non-empty even for an exported type,
	// so we need to check the type name as well.
	return isExported(t.Name()) || t.PkgPath() == ""
}

// register publishes in the server the set of methods of the
// receiver value that satisfy the following conditions:
//	- exported method of exported type
//	- two arguments, both of exported type
//	- the second argument is a pointer
//	- one return value, of type error
// It returns an error if the receiver is not an exported type or has
// no suitable methods. It also logs the error using package log.
// The client accesses each method using a string of the form "Type.Method",
// where Type is the receiver's concrete type.
func (server *RPCFramework) Register(rcvr interface{}) error {
	return server.register(rcvr, "", false)
}

// RegisterName is like register but uses the provided name for the type
// instead of the receiver's concrete type.
func (server *RPCFramework) RegisterName(name string, rcvr interface{}) error {
	return server.register(rcvr, name, true)
}

func (server *RPCFramework) RegisterService(rcvr IServiceReceiver, methods []reflect.Method) error {
	return server.registerTJService(rcvr, methods)
}

func (server *RPCFramework) UnregisterService(rcvr IServiceReceiver) {
	key := rcvr.Name()
	//if iv, ok := server.serviceMap.Load(key); ok {
	//	svc := iv.(*service)
	//	fmt.Println(svc)
	//}
	server.serviceMap.Delete(key)
}

func (server *RPCFramework) GetMethodNameAndReply() []MethodInfo {
	ret := make([]MethodInfo, 0, 6)
	server.serviceMap.Range(func(key, val interface{}) bool {
		service := val.(*service)
		name := key.(string)
		for mName, _ := range service.method {
			ret = append(ret, MethodInfo{name, mName})
		}
		return true
	})
	return ret
}

// rcvr is tj.service
func (server *RPCFramework) registerTJService(rcvr IServiceReceiver, methods []reflect.Method) error {
	s := &service{
		typ:  reflect.TypeOf(rcvr),
		rcvr: reflect.ValueOf(rcvr),
	}
	s.name = rcvr.Name() // IService.Name
	s.method = suitableTJServiceMethods(rcvr, methods)

	if len(s.method) == 0 {
		str := "rpc.registerTJService: type " + s.name + " has no exported methods of suitable type"
		log.Warning(str)
		return errors.New(str)
	}

	key := s.name
	if old, dup := server.serviceMap.LoadOrStore(key, s); dup {
		svc := old.(*service)
		for k, method := range s.method {
			svc.method[k] = method
		}
	}
	return nil
}

func (server *RPCFramework) register(rcvr interface{}, name string, useName bool) error {
	s := &service{
		typ:  reflect.TypeOf(rcvr),
		rcvr: reflect.ValueOf(rcvr),
	}
	sName := reflect.Indirect(s.rcvr).Type().Name()
	if useName {
		sName = name
	}

	s.name = sName

	// Install the methods
	s.method = suitableMethods(s.typ, true)
	if len(s.method) == 0 {
		str := ""

		// To help the user, see if a pointer receiver would work.
		method := suitableMethods(reflect.PtrTo(s.typ), false)
		if len(method) != 0 {
			str = "rpc.register: type " + sName + " has no exported methods of suitable type (hint: pass a pointer to value of that type)"
		} else {
			str = "rpc.register: type " + sName + " has no exported methods of suitable type"
		}
		log.Warning(str)
		return errors.New(str)
	}

	key := sName
	if !useName {
		key = ""
	}
	if _, dup := server.serviceMap.LoadOrStore(key, s); dup {
		return errors.New("rpc: service already defined: " + sName)
	}
	return nil
}

// tj.service method format:
// func (*svc) method(args ...) (reply, error)
func suitableTJServiceMethods(rcvr IServiceReceiver, methods []reflect.Method) map[string]*methodType {
	rcvrValue := reflect.ValueOf(rcvr)
	methodsMap := make(map[string]*methodType)
	for _, method := range methods {
		mType := method.Type
		mName := method.Name
		// Method must be exported.
		if method.PkgPath != "" {
			log.Warningf("rpc: service method %s must be exported", mName)
			continue
		}

		// -1: svc receiver
		argTypes := make([]reflect.Type, mType.NumIn()-1)
		for i := 1; i <= len(argTypes); i++ {
			argTypes[i-1] = mType.In(i)
		}
		// Method needs two out. reply + error
		if mType.NumOut() != 2 {
			log.Warning("method", mName, "has wrong number of outs:", mType.NumOut())
			continue
		}
		// reply must be a pointer.
		replyType := mType.Out(0)
		if replyType.Kind() != reflect.Ptr {
			replyType = reflect.PtrTo(replyType)
			//log.Warning("method", mName, "reply type not a pointer:", replyType)
			//continue
		}
		// Reply type must be exported.
		if !isExportedOrBuiltinType(replyType) {
			log.Warning("method", mName, "reply type not exported:", replyType)
			continue
		}

		// The return type of the method must be error.
		if returnType := mType.Out(1); returnType != typeOfError {
			log.Warning("method", mName, "returns", returnType.String(), "not error")
			continue
		}
		methodsMap[mName] = &methodType{
			rcvr:          rcvrValue,
			method:        method,
			argTypes:      argTypes,
			replyType:     replyType,
			replyElemType: replyType.Elem(),
			isTJFormat:    true,
		}
	}
	return methodsMap
}

// suitableMethods returns suitable Rpc methods of typ, it will report
// error using log if reportErr is true.
//
// RPC method format:
// func (*rcvr) method(args ..., reply) error
func suitableMethods(typ reflect.Type, reportErr bool) map[string]*methodType {
	methods := make(map[string]*methodType)
	for m := 0; m < typ.NumMethod(); m++ {
		method := typ.Method(m)
		mType := method.Type
		mName := method.Name
		// Method must be exported.
		if method.PkgPath != "" {
			continue
		}
		// Method needs three ins: receiver, *args, *reply.
		//if mType.NumIn() != 3 {
		//	if reportErr {
		//		log.Warning("method", mName, "has wrong number of ins:", mType.NumIn())
		//	}
		//	continue
		//}
		// First arg need not be a pointer.
		//argType := mType.In(1)
		//if !isExportedOrBuiltinType(argType) {
		//	if reportErr {
		//		log.Warning(mName, "argument type not exported:", argType)
		//	}
		//	continue
		//}
		argTypes := make([]reflect.Type, mType.NumIn()-2)
		for i := 1; i <= len(argTypes); i++ {
			argTypes[i-1] = mType.In(i)
		}
		// Second arg must be a pointer.
		replyType := mType.In(mType.NumIn() - 1)
		if replyType.Kind() != reflect.Ptr {
			if reportErr {
				log.Warning("method", mName, "reply type not a pointer:", replyType)
			}
			continue
		}
		// Reply type must be exported.
		if !isExportedOrBuiltinType(replyType) {
			if reportErr {
				log.Warning("method", mName, "reply type not exported:", replyType)
			}
			continue
		}
		// Method needs one out.
		if mType.NumOut() != 1 {
			if reportErr {
				log.Warning("method", mName, "has wrong number of outs:", mType.NumOut())
			}
			continue
		}
		// The return type of the method must be error.
		if returnType := mType.Out(0); returnType != typeOfError {
			if reportErr {
				log.Warning("method", mName, "returns", returnType.String(), "not error")
			}
			continue
		}
		methods[mName] = &methodType{
			method:        method,
			argTypes:      argTypes,
			replyType:     replyType,
			replyElemType: replyType.Elem(),
			isTJFormat:    false,
		}
	}
	return methods
}

// A value sent as a placeholder for the server's response value when the server
// receives an invalid request. It is never decoded by the client since the Response
// contains an error when it is used.
var invalidRequest = struct{}{}

func (server *RPCFramework) sendResponse(sending *sync.Mutex, req *Request, reply interface{}, codec rpc.ServerCodec, errmsg string) {
	resp := server.getResponse()
	// Encode the response header
	resp.ServiceMethod = req.ServiceMethod
	if errmsg != "" {
		resp.Error = errmsg
		reply = invalidRequest
	}
	resp.Seq = req.Seq
	sending.Lock()
	err := codec.WriteResponse(&resp.Response, reply)
	if err != nil {
		log.Warning("rpc: writing response:", err)
	}
	sending.Unlock()
	server.freeResponse(resp)
}

func (m *methodType) NumCalls() uint32 {
	return atomic.LoadUint32(&m.numCalls)
}

func (s *service) call(server *RPCFramework, sending *sync.Mutex, wg *sync.WaitGroup, mtype *methodType, req *Request, argvs []reflect.Value, replyv reflect.Value, codec rpc.ServerCodec) {
	if wg != nil {
		defer wg.Done()
	}
	atomic.AddUint32(&mtype.numCalls, 1)
	function := mtype.method.Func
	// Invoke the method, providing a new value for the reply.
	var callargs []reflect.Value
	if mtype.isTJFormat {
		callargs = make([]reflect.Value, 1, 1+len(argvs))
		callargs[0] = mtype.rcvr
	} else {
		callargs = make([]reflect.Value, 1, 1+len(argvs)+1)
		callargs[0] = s.rcvr
	}
	callargs = append(callargs, argvs...)
	if !mtype.isTJFormat {
		callargs = append(callargs, replyv)
	}
	var errInter interface{}

	util.SimpleTry(func() {
		returnValues := function.Call(callargs)
		// The return value for the method is an error.
		if mtype.isTJFormat {
			replyv = returnValues[0]
			errInter = returnValues[1].Interface()
		} else {
			errInter = returnValues[0].Interface()
		}
	}, func(err interface{}) {
		log.Error("rpc: call err", err)
		errInter = err
	})

	errmsg := ""
	if errInter != nil {
		switch v := errInter.(type) {
		case error:
			errmsg = v.Error()
		case string:
			errmsg = v
		}
	}
	if replyv == nilValue && mtype.isTJFormat {
		server.sendResponse(sending, req, nil, codec, errmsg)
	} else {
		server.sendResponse(sending, req, replyv.Interface(), codec, errmsg)
	}
	server.freeRequest(req)
}

// ServeCodec is like ServeConn but uses the specified codec to
// decode requests and encode responses.
func (server *RPCFramework) ServeCodec(codec rpc.ServerCodec) {
	sending := new(sync.Mutex)
	wg := new(sync.WaitGroup)
	for {
		service, mtype, req, argvs, replyv, keepReading, err := server.readRequest(codec)
		if err != nil {
			if err != io.EOF {
				log.Warning("rpc:", err)
			}
			if !keepReading {
				break
			}
			// send a response if we actually managed to read a header.
			if req != nil {
				server.sendResponse(sending, req, invalidRequest, codec, err.Error())
				server.freeRequest(req)
			}
			continue
		}
		wg.Add(1)
		go service.call(server, sending, wg, mtype, req, argvs, replyv, codec)
	}
	// We've seen that there are no more requests.
	// Wait for responses to be sent before closing codec.
	wg.Wait()
	_ = codec.Close()
}

// ServeRequest is like ServeCodec but synchronously serves a single request.
// It does not close the codec upon completion.
func (server *RPCFramework) ServeRequest(codec rpc.ServerCodec) error {
	sending := new(sync.Mutex)
	service, mtype, req, argvs, replyv, keepReading, err := server.readRequest(codec)
	if err != nil {
		if !keepReading {
			return err
		}
		// send a response if we actually managed to read a header.
		if req != nil {
			server.sendResponse(sending, req, invalidRequest, codec, err.Error())
			server.freeRequest(req)
		}
		return err
	}
	service.call(server, sending, nil, mtype, req, argvs, replyv, codec)
	return nil
}

func (server *RPCFramework) getRequest() *Request {
	server.reqLock.Lock()
	req := server.freeReq
	if req == nil {
		req = new(Request)
	} else {
		server.freeReq = req.next
		*req = Request{}
	}
	server.reqLock.Unlock()
	return req
}

func (server *RPCFramework) freeRequest(req *Request) {
	server.reqLock.Lock()
	req.next = server.freeReq
	server.freeReq = req
	server.reqLock.Unlock()
}

func (server *RPCFramework) getResponse() *Response {
	server.respLock.Lock()
	resp := server.freeResp
	if resp == nil {
		resp = new(Response)
	} else {
		server.freeResp = resp.next
		*resp = Response{}
	}
	server.respLock.Unlock()
	return resp
}

func (server *RPCFramework) freeResponse(resp *Response) {
	server.respLock.Lock()
	resp.next = server.freeResp
	server.freeResp = resp
	server.respLock.Unlock()
}

func (server *RPCFramework) readRequest(codec rpc.ServerCodec) (service *service, mtype *methodType, req *Request, argvs []reflect.Value, replyv reflect.Value, keepReading bool, err error) {
	service, mtype, req, keepReading, err = server.readRequestHeader(codec)
	if err != nil {
		if !keepReading {
			return
		}
		// discard body
		_ = codec.ReadRequestBody(nil)
		return
	}

	ivs := make([]interface{}, 0, len(mtype.argTypes))
	for _, argType := range mtype.argTypes {
		var arg reflect.Value
		// Decode the argument value.
		if argType.Kind() == reflect.Ptr {
			arg = reflect.New(argType.Elem())
		} else {
			arg = reflect.New(argType)
		}
		argvs = append(argvs, arg)
		ivs = append(ivs, arg.Interface())
	}

	if err = codec.ReadRequestBody(&ivs); err != nil {
		return
	}

	if req.Seq != 0 {
		log.Infof("REQ %s %d %+v", req.ServiceMethod, req.Seq, ivs)
	} else {
		log.Infof("NOTIFY %s %+v", req.ServiceMethod, ivs)
	}

	//fmt.Printf("%d ivs= %#v\n", len(ivs), ivs)
	//fmt.Printf("%d argvs= %#v\n", len(argvs), argvs)
	//for i, v := range argvs {
	//	fmt.Printf("%d= %#v\n", i, v.Interface())
	//}

	if len(ivs) != len(mtype.argTypes) {
		err = errors.New(fmt.Sprintf("rpc: %s need %d args, but given %d", mtype.method.Name, len(mtype.argTypes), len(ivs)))
		return
	}

	for i, argType := range mtype.argTypes {
		arg := argvs[i]
		// Decode the argument value.
		if argType.Kind() == reflect.Ptr {
		} else {
			// if true, need to indirect before calling.
			argvs[i] = arg.Elem()
		}
	}

	if mtype.isTJFormat {
		replyv = nilValue
	} else {
		replyv = reflect.New(mtype.replyType.Elem())

		switch mtype.replyElemType.Kind() {
		case reflect.Map:
			replyv.Elem().Set(reflect.MakeMap(mtype.replyElemType))
		case reflect.Slice:
			replyv.Elem().Set(reflect.MakeSlice(mtype.replyElemType, 0, 0))
		}
	}
	return
}

func (server *RPCFramework) readRequestHeader(codec rpc.ServerCodec) (svc *service, mtype *methodType, req *Request, keepReading bool, err error) {
	// Grab the request header.
	req = server.getRequest()
	err = codec.ReadRequestHeader(&req.Request)
	if err != nil {
		req = nil
		if err == io.EOF || err == io.ErrUnexpectedEOF {
			return
		}
		err = errors.New("rpc: server cannot decode request: " + err.Error())
		return
	}

	// We read the header successfully. If we see an error now,
	// we can still recover and move on to the next request.
	keepReading = true

	dot := strings.LastIndexByte(req.ServiceMethod, '.')
	serviceName := ""
	methodName := req.ServiceMethod
	if dot >= 0 {
		serviceName = req.ServiceMethod[:dot]
		methodName = req.ServiceMethod[dot+1:]
	} else {
		methodName = strings.Title(methodName)
	}

	// Look up the request.
	svci, ok := server.serviceMap.Load(serviceName)
	if !ok {
		err = errors.New("rpc: can't find service " + req.ServiceMethod)
		return
	}
	svc = svci.(*service)
	mtype = svc.method[methodName]
	if mtype == nil {
		err = errors.New("rpc: can't find method " + req.ServiceMethod)
	}
	return
}

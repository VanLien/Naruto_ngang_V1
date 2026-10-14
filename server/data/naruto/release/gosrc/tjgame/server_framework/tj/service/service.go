package service

import (
	"encoding/json"
	"fmt"
	"reflect"
	"sync/atomic"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/rpc"
	"tjgame/server_framework/tj/service/caller"
)

type IService interface {
	Name() string
	ServiceName() string
	Language() string
	ID() int

	Stub() []*caller.FuncServiceInfo
	Caller() ICaller
	Container() IContainer
	IsRunning() bool

	Init() bool
	Start() bool
	Stop()
	Destroy()

	Base() *Service
}

type IOption interface {
	Base() *Option
}

type Option struct {
	Name string `json:"name"`

	// for service merge
	Alias []string `json:"alias"`
	// explicit dependency services
	Dependent []string `json:"dependent,omitempty" `
}

func (o *Option) Base() *Option {
	return o
}

// local services
type Service struct {
	name     string // service.language.id
	service  string
	language string
	id       int
	Option   IOption

	container   IContainer
	stub        []*caller.FuncServiceInfo
	inited      int32
	running     int32
	LocalCaller *caller.FuncCaller
}

func (s *Service) Name() string {
	return s.name
}

func (s *Service) ServiceName() string {
	return s.service
}

func (s *Service) Language() string {
	return s.language
}

func (s *Service) ID() int {
	return s.id
}

func (s *Service) Stub() []*caller.FuncServiceInfo {
	return s.stub
}

func (s *Service) IsRunning() bool {
	return atomic.LoadInt32(&s.running) != 0
}

// Register for RPC
func (s *Service) Register(resolver rpc.IServiceReceiver, method string) *caller.FuncServiceInfo {
	return s.RegisterCustom(resolver, caller.RPC, method, nil)
}

// Register for RPC with NewRespFunc
// m is func(a,b,c,d,...) (resp interface{}, err error)
// m depend on FuncCaller
func (s *Service) RegisterWithNew(resolver rpc.IServiceReceiver, method string, respNew caller.NewRespFunc) *caller.FuncServiceInfo {
	return s.RegisterCustom(resolver, caller.RPC, method, respNew)
}

func (s *Service) RegisterCustom(resolver rpc.IServiceReceiver, typ caller.ServiceMethodType, method string, respNew caller.NewRespFunc) *caller.FuncServiceInfo {
	m, ok := reflect.TypeOf(resolver).MethodByName(method)
	if !ok {
		panic(fmt.Sprintf("method %s not exited", method))  // đây e xem đứa nào gọi nó
	}
	if !caller.CheckFunc(m, respNew) {
		panic(fmt.Sprintf("%s m not valid", method))
	}
	ret := caller.NewFuncServiceInfo(typ, resolver.Name(), resolver, method, respNew)
	s.stub = append(s.stub, ret)
	return ret
}

func (s *Service) Init() bool {
	if atomic.CompareAndSwapInt32(&s.inited, 0, 1) {
		c := s.Caller()
		for _, info := range s.stub {
			c.Register(*info)
		}
		return true
	}
	return false
}

func (s *Service) Start() bool {
	if atomic.LoadInt32(&s.inited) == 0 {
		log.Errorf("services %s not inited", s.name)
		return false
	}
	if atomic.CompareAndSwapInt32(&s.running, 0, 1) {
		return true
	}
	return false
}

func (s *Service) Stop() {
	atomic.CompareAndSwapInt32(&s.running, 1, 0)
}

func (s *Service) Destroy() {
	atomic.CompareAndSwapInt32(&s.inited, 1, 0)
}

// implement in specific struct
func (s *Service) Caller() ICaller {
	return s.LocalCaller
}

func (s *Service) Container() IContainer {
	return s.container
}

func (s *Service) Base() *Service {
	return s
}

func (s *Service) Hello(data string) (response []byte, err error) {
	return json.Marshal(s.Option)
}

func NewService(option IOption, container IContainer) *Service {
	serviceName, language, id := SplitServiceName(option.Base().Name)
	svc := &Service{
		name:        option.Base().Name,
		service:     serviceName,
		language:    language,
		id:          id,
		Option:      option,
		container:   container,
		stub:        make([]*caller.FuncServiceInfo, 0, 4),
		inited:      0,
		running:     0,
		LocalCaller: &caller.FuncCaller{},
	}
	svc.Register(svc, "Hello")
	return svc
}

// remote service
type remoteService struct {
	IService

	caller ICaller
}

func (s *remoteService) Caller() ICaller {
	return s.caller
}

func (s *remoteService) Init() bool {
	if s.caller == nil {
		return false
	}
	ls := s.IService.Base()
	if atomic.CompareAndSwapInt32(&ls.inited, 0, 1) {
		for _, info := range ls.stub {
			s.caller.Register(*info)
		}
		return true
	}
	return false
}

// remoteService will be skip the IService.Init()
// DO NOT PUT INIT WORK IN START!!!
func (s *remoteService) Start() bool {
	return s.IService.Base().Start()
}

// remote is wrap for local
func NewRemoteService(factory IFactory, name string, container IContainer, c ICaller) IService {
	// remote Option is no real usage
	s := factory.NewService(&Option{name, []string{}, []string{}}, container)
	s.Base().LocalCaller = nil
	return &remoteService{
		IService: s,
		caller:   c,
	}
}

type IFactory interface {
	NewService(option IOption, container IContainer) IService
}

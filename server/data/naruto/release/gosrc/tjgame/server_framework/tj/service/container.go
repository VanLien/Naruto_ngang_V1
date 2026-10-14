package service

import (
	"encoding/json"
	"errors"
	"fmt"
	"regexp"
	"strings"
	"sync"
	"time"
	"tjgame/server_framework/tj/conf"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/nsq"
	"tjgame/server_framework/tj/service/caller"
	"tjgame/server_framework/tj/util"
)

const DingUrl = "https://oapi.dingtalk.com/robot/send?access_token=cf33ac5c154294f61591e4da4e7150f8448c2d5207a82dae73397253ae967c9e"

type IContainer interface {
	GetService(string) IService
	GetServices(string) []IService
	AddRemoteService(string) error

	Start() bool
	Stop()

	OnServicePanic(IService, interface{})
}

type ContainerOption struct {
	Name string

	Debug bool   `json:"debug,omitempty"`
	Addr  string `json:"addr"`

	NSQLookupd      string   `json:"nsqlookupd"`
	Mainnsqd        string   `json:"mainnsqd,omitempty"`
	NSQTcpAddresses []string `json:"nsqd_tcp_addresses,omitempty"`

	Shushu bool `json:"shushu,omitempty"`

	Services    []IOption         // []*services.Option
	ServicesRaw []json.RawMessage `json:"services"`
}

// ICustomJsonDefine
func (c *ContainerOption) OnAfterUnmarshal(impl conf.ICustomJsonDefine) {
	// 区别serviceID，如storage.cn.1和@storage.cn.1
	// 看上去更像邮箱地址cache.cn.1@storage.cn.1
	c.Name = "@" + c.Name
	c.Services = make([]IOption, len(c.ServicesRaw))
	for i, raw := range c.ServicesRaw {
		opt := &Option{}
		err := json.Unmarshal(raw, opt)
		if err != nil {
			panic(err)
		}
		c.Services[i] = impl.GetExtend(opt, raw).(IOption)
	}
	c.ServicesRaw = nil
}

// ICustomJsonDefine
func (c *ContainerOption) GetExtend(opt interface{}, raw json.RawMessage) interface{} {
	return opt
}

type Container struct {
	services sync.Map //map[string]IService
	factory  IFactory

	nsq       *nsq.NSQRPCServer
	nsqClient *nsq.NSQRPCClient

	option ContainerOption
	inited bool
}

func (c *Container) AddService(service IService) {
	if c.inited {
		log.Warningf("container inited, could not add the service %s", service.Name())
		return
	}

	name := service.Name()
	other, loaded := c.services.LoadOrStore(name, service)
	if loaded {
		otherService := other.(IService)
		log.Warningf("service %s already in container, previous was %s", name, otherService.Name())
		return
	}

	if _, ok := service.(*remoteService); ok {

	} else {
		// every service RegisterCustom to discovery
		// name and serviceName
	}
}

func (c *Container) AddRemoteService(name string) error {
	cl := &caller.RPCCaller{Client: c.nsqClient}
	service := NewRemoteService(c.factory, name, c, cl)
	if !service.Init() {
		return errors.New("remote service init failed")
	}
	actual, loaded := c.services.LoadOrStore(name, service)
	if loaded {
		log.Warningf("service %s already in container", name)
	}
	log.Debugf("remote service %s add to container", name)
	service = actual.(IService)
	if !service.IsRunning() {
		if !service.Start() {
			return errors.New(fmt.Sprintf("remote service %s start failed", name))
		}
		log.Infof("remote service %s start", name)
	}
	return nil
}

func (c *Container) addServiceAlias(name string, service IService) {
	if c.inited {
		panic("container inited")
	}

	other, loaded := c.services.LoadOrStore(name, service)
	if loaded {
		otherService := other.(IService)
		log.Warningf("service alias %s already in container, previous was %s", name, otherService.Name())
		return
	}

	c.nsq.AddServiceAlias(service.Name(), name)
}

// full-name or alias-name
func (c *Container) GetService(name string) IService {
	service, ok := c.services.Load(name)
	if ok {
		ret := service.(IService)
		if ret.IsRunning() {
			return ret
		}
	}
	return nil
}

func (c *Container) GetServices(pattern string) []IService {
	ret := make([]IService, 0)
	re, err := regexp.Compile(pattern)
	if err != nil {
		return ret
	}

	c.services.Range(func(key, value interface{}) bool {
		name := key.(string)
		if ok := re.MatchString(name); ok {
			ret = append(ret, value.(IService))
		}
		return true
	})
	return ret
}

func (c *Container) Init() {
	addrs := make(map[string]bool)
	if c.option.NSQTcpAddresses != nil {
		for _, addr := range c.option.NSQTcpAddresses {
			addrs[addr] = true
		}
	}
	if c.option.Mainnsqd != "" {
		addrs[c.option.Mainnsqd] = true
	}
	if len(addrs) == 0 {
		panic("no nsqd address")
	}
	nsqds := make([]string, 0, len(addrs))
	for addr := range addrs {
		nsqds = append(nsqds, addr)
	}

	c.nsq = nsq.NewNSQRPCServer(c.option.Name)
	c.nsq.Init(c.option.NSQLookupd, nsqds...)

	c.nsqClient = nsq.NewNSQRPCClient(c.option.Name)

	// init global notify caller
	SetNotifyCaller(&caller.NotifyCaller{Client: c.nsqClient})

	// init all services
	for _, option := range c.option.Services {
		opt := option.Base()

		// init dependent remote services
		for _, dep := range opt.Dependent {
			// service in local, but it not started
			_, ok := c.services.Load(dep)
			if !ok {
				cl := &caller.RPCCaller{
					Client: c.nsqClient,
				}
				svc := NewRemoteService(c.factory, dep, c, cl)
				if !svc.Init() {
					panic(fmt.Sprintf("remote service %s init failed", opt.Name))
				}
				c.AddService(svc)
			}
		}

		// init local service
		svc := c.factory.NewService(option, c)
		if !svc.Init() {
			panic(fmt.Sprintf("service %s init failed", opt.Name))
		}
		c.AddService(svc)
		c.nsq.RegisterServiceStub(svc, svc.Stub())

		// add alias
		for _, alias := range opt.Alias {
			c.addServiceAlias(alias, svc)
			log.Infof("alias %s to service %s", alias, svc.Name())
		}
	}

	c.nsqClient.Connect(nsqds...)

	c.inited = true
}

func (c *Container) Start() bool {
	if !c.inited {
		panic("container no inited")
	}

	// start all services
	for _, option := range c.option.Services {
		opt := option.Base()

		// start dependent remote services
		for _, dep := range opt.Dependent {
			svci, _ := c.services.Load(dep)
			svc := svci.(IService)
			if !svc.IsRunning() {
				if !svc.Start() {
					panic(fmt.Sprintf("remote service %s start failed", dep))
				}
				log.Infof("remote service %s start", dep)
			}
		}

		// start local service
		svci, _ := c.services.Load(opt.Name)
		if !svci.(IService).Start() {
			panic(fmt.Sprintf("service %s start failed", opt.Name))
		}
		log.Infof("service %s start", opt.Name)
	}

	go c.nsq.Start()

	log.Infof("container %s start", c.option.Name)
	return true
}

func (c *Container) Stop() {
	c.nsq.Stop()

	// stop all services in config
	// NOTE: exclude be added in runtime
	for _, option := range c.option.Services {
		name := option.Base().Name
		if s := c.GetService(name); s != nil {
			if s.IsRunning() {
				s.Stop()
				s.Destroy()
				log.Infof("service %s stop", name)
			}
		}
	}

	c.services = sync.Map{}

	log.Infof("container %s stop", c.option.Name)
}

func (c *Container) Backoff(topic string, v bool) {
	c.nsq.Backoff(topic, v)
}

func (c *Container) OnServicePanic(service IService, err interface{}) {
	log.Errorf("service %s panic", service.Name())

	// remove service and alias
	lefts := make([]string, 0)
	c.services.Range(func(key, value interface{}) bool {
		svc := value.(IService)
		if svc != service {
			if _, ok := value.(*remoteService); !ok {
				lefts = append(lefts, svc.Name())
			}
		} else {
			c.services.Delete(key)
		}
		return true
	})

	service.Stop()
	service.Destroy()

	// TODO: who depend the service

	// only one service, panic it
	// keep other running when had other services
	stime := time.Now().Format("2006-01-02 15:04:05")
	if len(lefts) == 0 {
		// send message to dingding
		content := `#### %s\n
日期时间：%s\n
崩溃服务：%s\n
崩溃信息：%s\n
没有其它存活服务，进程直接退出，请手动重启
`
		content = fmt.Sprintf(content, c.option.Name, stime, service.Name(), err)
		util.SendToDingDing(DingUrl, "口袋Service报警", content)
		panic("no more services, restart me")
	}

	// unregister service in rpc
	c.nsq.UnregisterService(service)

	// send message to dingding
	content := `#### %s\n
日期时间：%s\n
崩溃服务：%s\n
崩溃信息：%s\n
存活服务：%s\n
`
	content = fmt.Sprintf(content, c.option.Name, stime, service.Name(), err, strings.Join(lefts, ", "))
	go util.SendToDingDing(DingUrl, "口袋Service报警", content)
}

func NewContainer(option ContainerOption, factory IFactory) *Container {
	c := &Container{
		option:  option,
		factory: factory,
	}
	return c
}

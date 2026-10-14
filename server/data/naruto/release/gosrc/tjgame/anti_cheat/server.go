package main

import (
	"encoding/json"
	"fmt"
	"tjgame/server_framework/tj/log"
	anti_cheat "tjgame/services/anti-cheat"

	"tjgame/server_framework/tj/service"
)

type Define struct {
	service.ContainerOption `json:",inline"`
}

// ICustomJsonDefine
func (d *Define) GetExtend(opt interface{}, raw json.RawMessage) interface{} {
	name := opt.(*service.Option).Name
	serv, _, _ := service.SplitServiceName(name)
	var optEx interface{}
	if serv == anti_cheat.Name {
		optEx = new(anti_cheat.Option)
	}
	if optEx != nil {
		err := json.Unmarshal(raw, optEx)
		if err != nil {
			panic(err)
		}
		log.Debugf("GetExtend service %s %#v", name, optEx)
		return optEx
	}
	log.Debugf("GetExtend service %s %#v", name, opt)
	return opt
}

type Server struct {
	define Define

	container *service.Container
}

func (s *Server) OnStart() bool {
	s.container.Init()
	return s.container.Start()
}

func (s *Server) OnStop() {
	s.container.Stop()
}

func NewServer(define Define) *Server {
	return &Server{
		container: service.NewContainer(define.ContainerOption, &factory{}),
		define:    define,
	}
}

type factory struct{}

func (f *factory) NewService(option service.IOption, container service.IContainer) service.IService {
	name := option.Base().Name
	serviceName, _, _ := service.SplitServiceName(name)
	if serviceName != anti_cheat.Name {
		panic(fmt.Sprintf("must be anti cheat service, expect %s, got %s", anti_cheat.Name, serviceName))
	}
	return anti_cheat.NewService(option, container)
}

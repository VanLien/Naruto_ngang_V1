package main

import (
	"fmt"
	"math/rand"
	"time"
	"tjgame/server_framework/tj/service"
	"tjgame/services"
	"tjgame/ta"
)

type Server struct {
	define services.Define

	container *service.Container
}

func (s *Server) OnStart() bool {
	rand.Seed(time.Now().Unix())
	s.container.Init()

	if s.define.Shushu {
		// TA 统计
		ta.Init(fmt.Sprintf("/mnt/logbus_data/%s", s.define.Name))
	}

	return s.container.Start()
}

func (s *Server) OnStop() {
	s.container.Stop()
	ta.Stop()
}

func NewServer(define services.Define) *Server {
	return &Server{
		container: service.NewContainer(define.ContainerOption, services.Factory),
		define:    define,
	}
}

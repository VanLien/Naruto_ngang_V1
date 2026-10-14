package main

import (
	"fmt"
	"io/ioutil"
	"net"
	"net/http"
	"strings"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/services"
	"tjgame/services/cross/onlinefight/forward"
)

var pattern = fmt.Sprintf("^%s", forward.Name)

type Define struct {
	service.ContainerOption `json:",inline"`

	IP string `json:"ip,omitempty"`

	QueryIPUrl string `json:"query_ip_url,omitempty"`
}

func (d *Define) queryIp() {
	if d.QueryIPUrl == "" {
		return
	}


	log.Debugf("Query %s", d.QueryIPUrl)

	resp, err := http.Get(d.QueryIPUrl)
	if err != nil {
		panic(err)
	}
	s, err := ioutil.ReadAll(resp.Body)
	resp.Body.Close()
	content := string(s)
	log.Debugf("%s response %s", d.QueryIPUrl, content)
	ip := strings.Split(content, ":")[0]
	d.IP = ip
	log.Infof("query ip %s", d.IP)
}

type Server struct {
	address string

	define    Define
	container *service.Container
}

// IConnServer
func (s *Server) OnStart() bool {
	return s.container.Start()
}

func (s *Server) OnStop() {
	s.container.Stop()
}

func (s *Server) InitNewConnHandle(connchan <-chan net.Conn) {
	ss := s.container.GetServices(pattern)[0]
	fs := ss.(*forward.Service)
	fs.SetAddress(s.address)
	go func() {
		for conn := range connchan {
			log.Debugf("new conn %s", conn.RemoteAddr())
			fs.OnNewConn(conn)
		}
	}()
}

func (s *Server) OnNewConnFull(conn net.Conn) {
	// TODO:
	log.Warningf("OnNewConnFull")
}

func (s *Server) ListenOn(addr net.Addr) {
	domain := strings.Split(addr.String(), ":")
	port := domain[len(domain)-1]
	s.address = s.define.IP + ":" + port
	log.Infof("address %s", s.address)
}

func NewServer(define Define) *Server {
	s := &Server{
		container: service.NewContainer(define.ContainerOption, services.Factory),
		define:    define,
	}
	s.container.Init()
	return s
}

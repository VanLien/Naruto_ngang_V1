package main

import (
	"fmt"
	"io"
	"net"
	"net/http"
	"os"
	"runtime"
	"strings"
	"time"
	"tjgame/services"

	"login/checkin"
	"login/diff"
	"login/servers"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"

	"github.com/fsnotify/fsnotify"
)

type Define struct {
	service.ContainerOption `json:",inline"`

	HTTPAddr string `json:"http_addr"`
	PatchUrl string `json:"patch_url"`
}

type Server struct {
	loginManager *checkin.Manager

	httpMux    *http.ServeMux
	httpServer *http.Server

	define Define

	container *service.Container

	storage service.IService
}

func (s *Server) initHTTP(addr string) {
	s.httpMux.HandleFunc("/", s.sayhello)
	s.httpMux.HandleFunc("/ip", s.ip)
	s.httpServer = &http.Server{Addr: addr, Handler: s.httpMux}
}

func (s *Server) sayhello(w http.ResponseWriter, req *http.Request) {
	st := time.Now()
	defer func() {
		log.Infof("%s %s (%s) %.2f ms", req.Method, req.RequestURI, req.RemoteAddr, float64(time.Now().Sub(st).Nanoseconds())/1000000)
	}()

	dir, _ := os.Getwd()
	io.WriteString(w, "hello, world!\n")
	io.WriteString(w, dir)
	io.WriteString(w, fmt.Sprint(req.Header))
}

func (s *Server) ip(w http.ResponseWriter, req *http.Request) {
	io.WriteString(w, req.RemoteAddr)
}

func (s *Server) initRPC() {
	s.container.Init()
	s.container.Start()

	if s.Storage() == nil {
		panic("no storage service")
	}
}

// IServer
func (s *Server) OnStart() bool {
	go func() {
		err := s.httpServer.ListenAndServe()
		if err != nil {
			// may be 'Server closed'
			if err != http.ErrServerClosed {
				log.Warning("http listen", err)
			}
		}
	}()
	return true
}

func (s *Server) OnStop() {
	s.httpServer.Close()
	s.container.Stop()

	s.loginManager.StopAndWait()
}

// IRPCOwner
func (s *Server) Storage() service.IService {
	if s.storage == nil {
		s.storage = s.container.GetServices("^accountdb")[0]
	}
	return s.storage
}

func (s *Server) Game(serverKey string) service.IService {
	if ss := s.container.GetService(serverKey); ss != nil {
		return ss
	}
	err := s.container.AddRemoteService(serverKey)
	if err != nil {
		log.Warningf("add remote game service %s error %v", serverKey, err)
	} else {
		log.Infof("add remote game service %s success", serverKey)
	}
	return s.container.GetService(serverKey)
}

// IConnServer
func (s *Server) InitNewConnHandle(connChan <-chan net.Conn) {
	s.loginManager.Work(connChan)
}

func (s *Server) OnNewConnFull(conn net.Conn) {
	s.loginManager.OnNewConnFull(conn)
}

func NewServer(define Define, language string) *Server {
	define.ContainerOption.Name = define.Name
	log.Info("langKey", language)

	mux := http.NewServeMux()
	diff.Init(define.Name, language, define.PatchUrl, mux)
	servers.Init(define.Name, language, mux)

	if !define.Debug {
		// auto append dependent game services
		for _, opt := range define.Services {
			opt.Base().Dependent = append(opt.Base().Dependent, servers.GetAllGameKeys()...)
		}
	}

	s := &Server{
		httpMux:   mux,
		define:    define,
		container: service.NewContainer(define.ContainerOption, services.Factory),
	}

	s.initRPC()
	s.initHTTP(define.HTTPAddr)
	s.loginManager = checkin.NewManager(runtime.GOMAXPROCS(0), s)

	// file watcher
	watch, err := fsnotify.NewWatcher()
	if err != nil {
		log.Panic(err)
	}
	// paths := []string{"patch", "patch_test", "conf", "blacklist"}
	
	
	paths := []string{"patch", "conf", "blacklist"}


	paths = append(paths, fmt.Sprintf("patch/%s", language), fmt.Sprintf("conf/%s", language))
	log.Infof("watch paths %v", paths)
	for _, s := range paths {
		err = watch.Add(s)
		if err != nil {
			log.Panic(err)
		}
		log.Info("fsnotify add watch", s)
	}
	go func() {
		for {
			select {
			case ev := <-watch.Events:
				{
					log.Info("fsnotify event:", ev)
					if strings.Contains(ev.Name, "blacklist") {
						servers.OnBlackListConfigChanged()
					} else {
						diff.OnConfigChanged()
						servers.OnConfigChanged()
					}
				}
			case err := <-watch.Errors:
				{
					log.Warning("fsnotify error:", err)
					return
				}
			}
		}
	}()

	return s
}

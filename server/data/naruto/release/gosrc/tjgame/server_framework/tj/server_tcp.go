package tj

import (
	"net"
	"os"
	"os/signal"
	"sync/atomic"
	"syscall"
	"time"

	"tjgame/server_framework/tj/log"
)

const defaultNewConnMax = 1024

type IConnServer interface {
	IServer

	InitNewConnHandle(<-chan net.Conn)
	OnNewConnFull(net.Conn)
}

type TCPServerFramework struct {
	newConnMax int
	impl       IConnServer
	lis        net.Listener
	exitChan   chan bool
	connChan   chan net.Conn
	running    int32
	addr       string
}

func (s *TCPServerFramework) Init(addr string) {
	atomic.StoreInt32(&s.running, 0)
	s.lis = nil
	s.exitChan = make(chan bool)
	s.addr = addr
	s.connChan = make(chan net.Conn, s.newConnMax)
}

func (s *TCPServerFramework) Start() {
	if s.addr == "" {
		log.Panic("tcp server not inited")
	}

	// init lis
	lis, err := net.Listen("tcp", s.addr)
	if err != nil {
		log.Panic(err)
	}
	s.lis = lis
	log.Info("tcp server listen", s.addr)

	// listening close signals
	stopChan := make(chan os.Signal)
	signal.Notify(stopChan, syscall.SIGINT, syscall.SIGTERM)
	go func() {
		<-stopChan
		s.Stop()
	}()

	s.impl.InitNewConnHandle(s.connChan)
	s.impl.OnStart()

	atomic.StoreInt32(&s.running, 1)
	log.Infof("tcp server %s start ok", s.addr)
	var tempDelay time.Duration
	for atomic.LoadInt32(&s.running) == 1 {
		conn, err := s.lis.Accept()
		if err != nil {
			if atomic.LoadInt32(&s.running) != 1 {
				continue
			}
			log.Warning("net accept error:", err)
			if ne, ok := err.(net.Error); ok && ne.Temporary() {
				if tempDelay == 0 {
					tempDelay = 5 * time.Millisecond
				} else {
					tempDelay *= 2
				}
				if max := time.Second; tempDelay > max {
					tempDelay = max
				}
				time.Sleep(tempDelay)
			}
			continue
		}
		tempDelay = 0

		select {
		case s.connChan <- conn:
		default:
			log.Warning("conn chan is full")
			s.impl.OnNewConnFull(conn)
		}
	}
	log.Infof("tcp server %s stopping", s.addr)

	<-s.exitChan
	log.Infof("tcp server %s stop ok", s.addr)
}

func (s *TCPServerFramework) Stop() {
	if atomic.CompareAndSwapInt32(&s.running, 1, 0) {
		_ = s.lis.Close()
		close(s.connChan)

		s.impl.OnStop()

		close(s.exitChan)
	}
}

func (s *TCPServerFramework) IsRunning() bool {
	return atomic.LoadInt32(&s.running) == 1
}

func NewTCPServerFramework(impl IConnServer) *TCPServerFramework {
	return &TCPServerFramework{
		newConnMax: defaultNewConnMax,
		impl:       impl,
	}
}

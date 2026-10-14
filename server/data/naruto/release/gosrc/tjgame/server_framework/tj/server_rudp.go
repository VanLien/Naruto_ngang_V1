package tj

import (
	"net"
	"os"
	"os/signal"
	"sync/atomic"
	"syscall"
	"time"

	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/rudp"
)

type ListenOn interface {
	ListenOn(net.Addr)
}

type RudpServerFramework struct {
	newConnMax int
	impl       IConnServer
	lis        *rudp.Listener
	exitChan   chan bool
	connChan   chan net.Conn
	running    int32
	addr       string
}

func (s *RudpServerFramework) Init(addr string) {
	atomic.StoreInt32(&s.running, 0)
	s.lis = nil
	s.exitChan = make(chan bool)
	s.addr = addr
	s.connChan = make(chan net.Conn, s.newConnMax)
}

func (s *RudpServerFramework) Start() {
	if s.addr == "" {
		log.Panic("rudp server not inited")
	}

	lis, err := rudp.Listen(s.addr)
	if err != nil {
		log.Panic(err)
	}
	s.lis = lis
	s.addr = lis.LocalAddr().String()
	log.Infof("rudp server listen %s", s.addr)

	if v, ok := s.impl.(ListenOn); ok {
		v.ListenOn(s.lis.LocalAddr())
	}

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
	log.Infof("rudp server %s start ok", s.addr)
	var tempDelay time.Duration
	for atomic.LoadInt32(&s.running) == 1 {
		conn, err := s.lis.AcceptRudp()
		if err != nil {
			if atomic.LoadInt32(&s.running) != 1 {
				continue
			}
			log.Warning("net accept error:", err)
			// TODO: handler error
			_ = tempDelay
			continue
		}
		tempDelay = 0

		select {
		case s.connChan <- conn:
		default:
			log.Warningf("conn chan is full")
			s.impl.OnNewConnFull(conn)
		}
	}
	log.Infof("rudp server %s stopping", s.addr)

	<-s.exitChan
	log.Infof("rudp server %s stop ok", s.addr)
}

func (s *RudpServerFramework) Stop() {
	if atomic.CompareAndSwapInt32(&s.running, 1, 0) {
		_ = s.lis.Close()
		close(s.connChan)

		s.impl.OnStop()

		close(s.exitChan)
	}
}

func (s *RudpServerFramework) IsRunning() bool {
	return atomic.LoadInt32(&s.running) == 1
}

func NewRudpServerFramework(impl IConnServer) *RudpServerFramework {
	return &RudpServerFramework{
		newConnMax: defaultNewConnMax,
		impl:       impl,
	}
}

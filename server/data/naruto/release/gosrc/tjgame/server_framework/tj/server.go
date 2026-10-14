package tj

import (
	_ "net/http/pprof"
	"os"
	"os/signal"
	"sync/atomic"
	"syscall"

	"tjgame/server_framework/tj/log"
)

// IServer
type IServer interface {
	OnStart() bool
	OnStop()
}

type ServerFramework struct {
	stopping uint32
	impl     IServer
}

func (s *ServerFramework) Start() {
	if !s.impl.OnStart() {
		log.Panic("server not start")
	}

	log.Info("server start ok")

	//go func() {
	//	err := http.ListenAndServe("localhost:6060", nil)
	//	println("pprof ok", err)
	//}()

	signalChannel := make(chan os.Signal, 1)
	signal.Notify(signalChannel, syscall.SIGTERM, syscall.SIGINT)
	<-signalChannel
	s.Stop()
}

func (s *ServerFramework) Stop() {
	if !atomic.CompareAndSwapUint32(&s.stopping, 0, 1) {
		return
	}

	s.impl.OnStop()

	log.Info("server stop ok")
}

func (s *ServerFramework) IsRunning() bool {
	return s.stopping == 0
}

func NewServerFramework(impl IServer) *ServerFramework {
	return &ServerFramework{
		stopping: 0,
		impl:     impl,
	}
}

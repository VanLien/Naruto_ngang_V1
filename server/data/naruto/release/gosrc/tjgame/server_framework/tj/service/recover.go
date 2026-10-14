package service

import (
	"sync"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
)

var recording sync.Map

// like go XXX
func GoWithRecover(service IService, f func()) {
	go CallWithRecover(service, f)
}

// like time.AfterFunc(1, XXX)
func FuncWithRecover(service IService, f func()) func() {
	return func() {
		CallWithRecover(service, f)
	}
}

func CallWithRecover(service IService, f func()) (ret bool) {
	defer func() {
		if err := recover(); err != nil {
			log.Errorf("panic happened in service %s\n!!! %s", service, err)
			if service != nil {
				service.Container().OnServicePanic(service, err)
			}
		}
	}()

	ret = false
	f()
	ret = true
	return
}

func WithRecord(service IService, f func()) {
	defer AutoRecord(service)()
	f()
}

// example: defer service.AutoRecord(s)()
// no support for nest call
func AutoRecord(service IService) func() {
	goid := util.GoID()
	recording.Store(goid, service)
	return func() {
		recording.Delete(goid)
	}
}

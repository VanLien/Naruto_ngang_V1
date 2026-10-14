package service

import (
	"errors"
	"time"

	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service/caller"
	"tjgame/server_framework/tj/util"
)

// global notify caller
var notifyCaller ICaller

func SetNotifyCaller(c ICaller) {
	notifyCaller = c
}

type ICaller interface {
	Register(caller.FuncServiceInfo)
	CanCall(string) bool
	CallInGo(string, ...interface{}) (interface{}, error)
}

func CallAsync(service IService, method string, args ...interface{}) *Future {
	c := service.Caller()
	if c == nil {
		log.Warningf("services %s no caller, may be no inited", service.Name())
		return nil
	}
	if !c.CanCall(method) {
		log.Warningf("services %s method %s can not be call", service.Name(), method)
		return nil
	}
	fu := NewFuture()

	go util.SimpleTry(func() {
		ret, err := c.CallInGo(method, args...)
		fu.Set(ret, err)
	}, func(err interface{}) {
		switch e := err.(type) {
		case error:
			fu.Set(nil, e)
		case string:
			fu.Set(nil, errors.New(e))
		default:
			log.Warningf("no recognize error type %T value %#v\n", err, err)
			fu.Set(nil, caller.ErrCallException)
		}
	})
	return fu
}

func Call(service IService, method string, args ...interface{}) (resp interface{}, err error) {
	fu := CallAsync(service, method, args...)
	if fu == nil {
		return nil, caller.ErrCallInvalid
	}
	return fu.Get()
}

func CallWithTimeout(service IService, method string, duration time.Duration, args ...interface{}) (resp interface{}, err error) {
	fu := CallAsync(service, method, args...)
	if fu == nil {
		return nil, caller.ErrCallInvalid
	}
	return fu.GetWithTimeout(duration)
}

func Notify(method string, args ...interface{}) error {
	var err error
	go util.SimpleTry(func() {
		_, err = notifyCaller.CallInGo(method, args...)
	}, func(i interface{}) {
		switch e := i.(type) {
		case error:
			err = e
		case string:
			err = errors.New(e)
		default:
			log.Warningf("no recognize error type %T value %#v\n", e, e)
			err = caller.ErrCallException
		}
	})
	return err
}

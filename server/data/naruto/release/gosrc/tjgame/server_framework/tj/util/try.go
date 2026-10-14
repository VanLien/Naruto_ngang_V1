package util

import (
	"errors"
	"fmt"
	"reflect"
	"regexp"

	"tjgame/server_framework/tj/log"
)

func SimpleTry(f func(), handler func(interface{})) {
	defer func() {
		if err := recover(); err != nil {
			log.Error("panic happened, but recover\n!!!", err)
			if handler != nil {
				handler(err)
			}
		}
	}()
	f()
}

// Example:
//		Try(func() {
//			bb := make([]int, 1)
//			bb[0] = 1
//			bb[1] = 2
//			//panic(TestErr{})
//			//panic(&TestErr{})
//		}).Except("123", func(err interface{}) {
//			fmt.Println("catch1", err)
//		}).Except("index*xxx", func(err interface{}) {
//			fmt.Println("catch2", err)
//		}).Except("index out of range", func(err interface{}) {
//			fmt.Println("catch3", err)
//		}).Except(TestErr{}, func(err interface{}) {
//			fmt.Println("catch4", err)
//		})

type catcher struct {
	err   error
	other interface{}
}

func Try(f func()) (c *catcher) {
	defer func() {
		if err := recover(); err != nil {
			switch e := err.(type) {
			case error:
				c = &catcher{e, nil}
			case string:
				c = &catcher{errors.New(e), nil}
			case fmt.Stringer:
				c = &catcher{errors.New(e.String()), nil}
			default:
				c = &catcher{nil, err}
			}
		}
	}()
	f()
	return
}

func (c *catcher) Except(regOrType interface{}, handler func(interface{})) *catcher {
	if c == nil {
		return nil
	}

	reg, isReg := regOrType.(string)
	if isReg {
		if c.err != nil {
			matched, _ := regexp.MatchString(reg, c.err.Error())
			if matched {
				handler(c.err)
				return nil
			}
		}
	} else {
		if c.other != nil {
			et := reflect.TypeOf(c.other)
			ct := reflect.TypeOf(regOrType)
			if et.Kind() == reflect.Ptr {
				et = et.Elem()
			}
			if ct.Kind() == reflect.Ptr {
				ct = ct.Elem()
			}
			if et == ct {
				handler(c.other)
				return nil
			}
		}
	}
	return c
}

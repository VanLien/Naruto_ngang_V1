package conf

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"path/filepath"
	"reflect"

	"tjgame/server_framework/tj/log"
)

type ICustomJsonDefine interface {
	OnAfterUnmarshal(ICustomJsonDefine)
	GetExtend(interface{}, json.RawMessage) interface{}
}

func loadFrom(filename string, name string, conf interface{}) interface{} {
	var mapVal reflect.Value
	data, err := ioutil.ReadFile(filename)
	if err == nil {
		// new map[string]Define
		mapVal = reflect.New(reflect.MapOf(reflect.TypeOf(""), reflect.TypeOf(conf)))
		err = json.Unmarshal(data, mapVal.Interface())
	}
	if err != nil {
		log.Panicf("load %s err %v", filename, err)
	}

	// get map[name]
	t := mapVal.Elem().MapIndex(reflect.ValueOf(name))
	if !t.IsValid() {
		return nil
	}

	// assign name
	t.Elem().FieldByName("Name").Set(reflect.ValueOf(name))

	// return Define or its derived
	ret := t.Interface()
	if c, ok := ret.(ICustomJsonDefine); ok {
		c.OnAfterUnmarshal(c)
	}
	return ret
}

func LoadDefine(name string, conf interface{}) interface{} {
	dir, _ := os.Getwd()
	log.Debug("cwd in", dir)

	files, err := filepath.Glob("*.json")
	if err != nil {
		log.Panic("lookup defines file error %v", err)
	}

	var ret interface{}
	for _, file := range files {
		ret = loadFrom(file, name, conf)
		if ret != nil {
			log.Infof("%s config in %s", name, file)
			break
		}
	}
	if ret == nil {
		log.Panicf("%s no such define", name)
	}
	return ret
}

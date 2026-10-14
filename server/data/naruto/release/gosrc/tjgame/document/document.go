package document

import (
	"reflect"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
)

type IDocument interface {
	GetID() ID
	SetID(id ID)
	CollectionName() string
}

func GetFieldInterface(document IDocument, keys ...string) map[string]interface{} {
	diff := make(map[string]interface{}, len(keys))
	visitFields(document, keys, func(key string, fieldName string, field reflect.Value) {
		diff[key] = field.Interface()
	})
	return diff
}

func GetFieldValue(document IDocument, keys ...string) map[string]reflect.Value {
	diff := make(map[string]reflect.Value, len(keys))
	visitFields(document, keys, func(key string, fieldName string, field reflect.Value) {
		diff[key] = field
	})
	return diff
}

func GetAllFieldValue(document IDocument) map[string]reflect.Value {
	specs := specs[document.CollectionName()].FieldSpecs
	keys := make([]string, 0, len(specs))
	for key := range specs {
		keys = append(keys, key)
	}
	return GetFieldValue(document, keys...)
}

func visitFields(document IDocument, keys []string, visit func(key string, fieldName string, field reflect.Value)) {
	value := reflect.ValueOf(document).Elem()
	for _, key := range keys {
		spec, ok := specs[document.CollectionName()].FieldSpecs[key]
		if !ok {
			log.Warningf("%s without field %s", document.CollectionName(), key)
			continue
		}
		v := value
		for _, name := range spec.Path {
			v = v.FieldByName(name)
		}
		v = v.FieldByName(spec.Name)
		visit(key, spec.Name, v)
	}
}

func SetDefault(document IDocument) {
	value := reflect.ValueOf(document).Elem()
	for _, spec := range specs[document.CollectionName()].FieldSpecs {
		v := value
		for _, name := range spec.Path {
			v = v.FieldByName(name)
		}
		v = v.FieldByName(spec.Name)
		if v.CanSet() && isZeroValue(v) {
			if spec.fill != nil {
				spec.fill.setDefault(v)
			} else {
				if v.Kind() != reflect.Map && v.Kind() != reflect.Slice {
					continue
				}
				// 给slice，map默认创建空数据, 给python那边用的
				if v.IsNil() {
					switch v.Kind() {
					case reflect.Map:
						v.Set(reflect.MakeMap(v.Type()))
					case reflect.Slice:
						v.Set(reflect.MakeSlice(v.Type(), 0, 0))
					}
				}
			}
		}
	}
}

func isZeroValue(value reflect.Value) bool {
	switch value.Kind() {
	case reflect.Bool:
		return !value.Bool()
	case reflect.Int, reflect.Int8, reflect.Int16, reflect.Int32, reflect.Int64:
		return value.Int() == 0
	case reflect.Uint, reflect.Uint8, reflect.Uint16, reflect.Uint32, reflect.Uint64:
		return value.Uint() == 0
	case reflect.Float32, reflect.Float64:
		return value.Float() == .0
	case reflect.String:
		return value.String() == ""
	case reflect.Map:
		return value.Len() == 0
	case reflect.Slice:
		return value.Len() == 0
	}

	return false
}

func New(name string, useDefault bool) IDocument {
	documentType := specs[name].Type
	v := reflect.New(documentType.Elem())
	document := v.Interface().(IDocument)
	if useDefault {
		SetDefault(document)
	}
	return document
}

func init() {
	RegisterDefaultFunction("nowtime_t", func() interface{} {
		return util.NowTime()
	})
	RegisterDefaultFunction("todaydate2int", func() interface{} {
		return util.Todaydate2int()
	})
	RegisterDefaultFunction("todaymonth2int", func() interface{} {
		return util.Todaymonth2int()
	})
	RegisterDefaultFunction("todayinclock5date2int", func() interface{} {
		return util.Todayinclock5date2int()
	})
	RegisterDefaultFunction("weekinclock5date2int", func() interface{} {
		return util.Weekinclock5date2int()
	})
	RegisterDefaultFunction("nowtime2int", func() interface{} {
		return util.Nowtime2int()
	})
	RegisterDefaultFunction("dict", func() interface{} {
		data, err := util.MsgPack(map[interface{}]interface{}{})
		if err != nil {
			panic(err)
		}
		return data
	})
	RegisterDefaultFunction("list", func() interface{} {
		data, err := util.MsgPack([]interface{}{})
		if err != nil {
			panic(err)
		}
		return data
	})

	log.Info("register document default ok")
}

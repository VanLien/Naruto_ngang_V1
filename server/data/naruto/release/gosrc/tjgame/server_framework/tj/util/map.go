package util

import "reflect"

func MapGet(iv interface{}, args ...interface{}) (interface{}, bool) {
	for i, k := range args {
		if reflect.TypeOf(iv).Kind() != reflect.Map {
			return nil, false
		}
		val := reflect.ValueOf(iv).MapIndex(reflect.ValueOf(k))
		if !val.IsZero() {
			iv = val.Interface()
			if i >= len(args)-1 {
				continue
			}
			switch iv.(type) {
			case []interface{}:
				return SliceGet(iv, args[i+1:]...)
			}
		} else {
			return nil, false
		}
	}
	return iv, true
}

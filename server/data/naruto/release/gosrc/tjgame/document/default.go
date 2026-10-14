package document

import (
	"fmt"
	"reflect"
	"strconv"
)

// --------------------------------------------------------------------------
// Maintain Document field default value

var functions = make(map[string]reflect.Value)

func RegisterDefaultFunction(name string, f func() interface{}) {
	if _, ok := functions[name]; !ok {
		functions[name] = reflect.ValueOf(f)
	}
}

type Default struct {
	raw string

	// document field kind
	kind reflect.Kind

	// function reflect value
	value    reflect.Value
	function bool

	str   string
	bool  bool
	int   int64
	uint  uint64
	float float64
}

func (d *Default) setDefault(value reflect.Value) {
	if d.function {
		outs := d.value.Call(nil)
		value.Set(outs[0].Elem())
	} else {
		switch d.kind {
		case reflect.Int, reflect.Int8, reflect.Int16, reflect.Int32, reflect.Int64:
			value.SetInt(d.int)
		case reflect.Uint, reflect.Uint8, reflect.Uint16, reflect.Uint32, reflect.Uint64:
			value.SetUint(d.uint)
		case reflect.Float32, reflect.Float64:
			value.SetFloat(d.float)
		case reflect.String:
			value.SetString(d.str)
		case reflect.Bool:
			value.SetBool(d.bool)
		default:
			value.Set(d.value)
		}
	}
}

func newDefault(raw string, kind reflect.Kind) *Default {
	def := &Default{
		raw:      raw,
		kind:     kind,
		function: false,
	}

	if value, ok := functions[raw]; ok {
		def.function = true
		def.value = value
		return def
	}

	switch kind {
	case reflect.Bool:
		if value, err := strconv.ParseBool(raw); err == nil {
			def.bool = value
		}
	case reflect.Int, reflect.Int8, reflect.Int16, reflect.Int32, reflect.Int64:
		if value, err := strconv.ParseInt(raw, 10, 64); err == nil {
			def.int = value
		}
	case reflect.Uint, reflect.Uint8, reflect.Uint16, reflect.Uint32, reflect.Uint64:
		if value, err := strconv.ParseUint(raw, 10, 64); err == nil {
			def.uint = value
		}
	case reflect.Float32, reflect.Float64:
		if value, err := strconv.ParseFloat(raw, 64); err == nil {
			def.float = value
		}
	case reflect.String:
		def.str = raw
	default:
		panic(fmt.Sprintf("unsupported %s, kind %s", raw, kind.String()))
	}

	return def
}

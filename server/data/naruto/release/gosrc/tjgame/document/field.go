package document

import (
	"reflect"
	"strconv"
	"strings"
)

// --------------------------------------------------------------------------
// Maintain a mapping of keys to document field indexes

type Spec struct {
	Type       reflect.Type
	FieldSpecs map[string]FieldSpec // key is FieldSpec.Alias
}

type FieldSpec struct {
	// Name is the field name.
	Name string
	// Alias is the field alias name, which is define in struct tag
	Alias string
	// path to field in embedded
	Path     []string
	Index    bool
	Unique   bool
	IndexKey string
	fill     *Default
}

func newFieldSpec(field reflect.StructField, path []string) FieldSpec {

	// alias
	var alias string
	keys := []string{"bson", "codec"}
	for _, key := range keys {
		alias = field.Tag.Get(key)
		if alias != "" {
			break
		}
	}
	fields := strings.Split(alias, ",")
	if len(fields) > 0 {
		alias = fields[0]
	}
	if alias == "" {
		alias = strings.ToLower(field.Name)
	}
	// index
	var err error
	indexKey := ""
	index := false
	if v := field.Tag.Get("index"); v != "" {
		if index, err = strconv.ParseBool(v); err == nil {
			indexKey = alias
		} else {
			err = nil
			index = true
			indexKey = v
		}
	}
	unique := false
	if v := field.Tag.Get("unique"); v != "" {
		if unique, err = strconv.ParseBool(v); err == nil {
			indexKey = alias
		} else {
			err = nil
			unique = true
			indexKey = v
		}
	}
	var fill *Default
	if v := field.Tag.Get("default"); v != "" {
		fill = newDefault(v, field.Type.Kind())
	}
	return FieldSpec{field.Name, alias, path, index, unique, indexKey, fill}
}

var specs = make(map[string]Spec)

func Register(document IDocument) {
	name := document.CollectionName()
	if _, ok := specs[name]; ok {
		return
	}

	documentType := reflect.TypeOf(document)
	st := documentType.Elem()
	num := st.NumField()
	documentSpec := Spec{
		Type:       documentType,
		FieldSpecs: make(map[string]FieldSpec, num),
	}
	fieldspecs := deepFields(document, nil)
	for _, spec := range fieldspecs {
		if _, found := documentSpec.FieldSpecs[spec.Alias]; found {
			panic("Duplicated Key '" + spec.Alias + "' in document " + st.String())
		}
		documentSpec.FieldSpecs[spec.Alias] = spec
	}
	specs[name] = documentSpec
}

func deepFields(iface interface{}, parent []string) []FieldSpec {
	specs := make([]FieldSpec, 0)
	t := reflect.TypeOf(iface)
	v := reflect.ValueOf(iface)
	if t.Kind() == reflect.Ptr {
		t = t.Elem()
		v = v.Elem()
	}
	num := t.NumField()
	for i := 0; i < num; i++ {
		field := t.Field(i)
		if field.PkgPath != "" {
			continue // Private field
		}
		if field.Type.Kind() == reflect.Struct && field.Anonymous {
			// in an embedded field
			p := parent
			p = append(p, field.Name)
			specs = append(specs, deepFields(v.Field(i).Interface(), p)...)
			continue
		}
		specs = append(specs, newFieldSpec(field, parent))
	}
	return specs
}

func MakeDocumentSlice(name string, len int, cap int) reflect.Value {
	documentType := specs[name].Type
	slice := reflect.MakeSlice(reflect.SliceOf(documentType), len, cap)
	value := reflect.New(slice.Type())
	value.Elem().Set(slice)
	return value
}

func RangeFieldSpec(name string, f func(spec FieldSpec)) {
	for _, spec := range specs[name].FieldSpecs {
		f(spec)
	}
}

func GetAllRegistered() []string {
	names := make([]string, 0, len(specs))
	for name := range specs {
		names = append(names, name)
	}
	return names
}

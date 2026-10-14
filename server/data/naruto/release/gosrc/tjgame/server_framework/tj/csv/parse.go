package csv

import (
	"bufio"
	"os"
	"strconv"
	"strings"
	"tjgame/server_framework/tj/util"

	"tjgame/server_framework/tj/log"
)

const (
	NilType int = iota
	BoolType
	IntType
	FloatType
	StringType
	ArrayType
	MapType
)

var delimMatch = map[rune]rune{'"': '"', '\'': '\'', '<': '>', '{': '}'}
var boolSet = map[string]bool{"true": true, "false": true, "True": true, "False": true, "TRUE": true, "FALSE": true}
var languages = []string{"_tw", "_en", "_th", "_vn", "_kr"}

type Row map[string]interface{}

type File struct {
	Rows     map[int]*Row
	Defaults Row
}

func (f *File) Get(row int, field string) (interface{}, error) {
	content, ok := f.Rows[row]
	if !ok {
		return nil, RowNotFound
	}
	val, ok := (*content)[field]
	if ok {
		return val, nil
	}
	// get default value
	val, ok = f.Defaults[field]
	if ok {
		return val, nil
	}
	return nil, FieldNotFound
}

func (f *File) GetRow(row int) (*Row, error) {
	content, ok := f.Rows[row]
	if !ok {
		return nil, RowNotFound
	}
	if len(*content) != len(f.Defaults) {
		for k, v := range f.Defaults {
			if _, ok := (*content)[k]; !ok {
				(*content)[k] = v
			}
		}
	}
	return content, nil
}

func (r *Row) ID() int {
	v := (*r)["_id"]
	return v.(int)
}

func isBool(v string) bool {
	_, ok := boolSet[v]
	return ok
}

func isInt(v string) bool {
	_, err := strconv.Atoi(strings.TrimSpace(v))
	return err == nil
}

func isFloat(v string) bool {
	_, err := strconv.ParseFloat(strings.TrimSpace(v), 64)
	return err == nil
}

func isString(v string) bool {
	return v[0] == '"' || v[0] == '\''
}

func isArray(v string) bool {
	return v[0] == '<' && v[len(v)-1] == '>'
}

func isMap(v string) bool {
	return v[0] == '{' && v[len(v)-1] == '}'
}

func isCSV(v string) bool {
	return strings.HasSuffix(v, ".csv")
}

func whatType(v string) int {
	v = strings.TrimSpace(v)
	if len(v) == 0 {
		return NilType
	} else if isInt(v) {
		return IntType
	} else if isFloat(v) {
		return FloatType
	} else if isCSV(v) {
		return StringType
	} else if isBool(v) {
		return BoolType
	} else if isString(v) {
		return StringType
	} else if isArray(v) {
		return ArrayType
	} else if isMap(v) {
		return MapType
	}
	return StringType
}

func makeElem(t int, v string) interface{} {
	v = strings.TrimSpace(v)
	switch t {
	case NilType:
		return nil
	case IntType:
		ret, err := strconv.Atoi(v)
		if err != nil {
			log.Errorf("field make error! %d, %s, %s", t, v, err)
		}
		return ret
	case FloatType:
		ret, err := strconv.ParseFloat(v, 64)
		if err != nil {
			log.Errorf("field make error! %d, %s, %s", t, v, err)
		}
		return ret
	case StringType:
		return makeString(v)
	case BoolType:
		return strings.ToLower(v) == "true"
	case ArrayType:
		return makeArray(v)
	case MapType:
		return makeMap(v)
	}
	return nil
}

func autoMake(v string) interface{} {
	t := whatType(v)
	return makeElem(t, v)
}

func makeString(v string) string {
	// # csv """""" -> str "" -> val ''
	// # csv """1    2""" -> str "1    2" -> val '1    2'
	v = strings.Replace(v, `"""`, `"`, -1)
	v = strings.Replace(v, `'''`, `'`, -1)
	if v[0] == '"' || v[0] == '\'' {
		v = v[1 : len(v)-1]
	}
	return v
}

func makeValueArray(v string, makef func(string) interface{}) []interface{} {
	delim, array := []rune{}, []interface{}{}
	s := 0
	for i, c := range v {
		if len(delim) > 0 {
			if c == delim[len(delim)-1] {
				delim = delim[:len(delim)-1]
			} else if c == '<' || c == '{' {
				delim = append(delim, delimMatch[c])
			}
		} else if c == '<' || c == '{' {
			delim = append(delim, delimMatch[c])
		} else if c == ';' {
			array = append(array, makef(v[s:i]))
			s = i + 1
		}
	}
	if len(v) > s {
		array = append(array, makef(v[s:]))
	}
	return array
}

func makeArray(v string) []interface{} {
	return makeValueArray(v[1:len(v)-1], autoMake)
}

func makeMap(v string) map[interface{}]interface{} {
	array := makeValueArray(v[1:len(v)-1], func(vv string) interface{} {
		return vv
	})

	mapp := map[interface{}]interface{}{}
	for _, ikv := range array {
		kv := strings.TrimSpace(ikv.(string))
		if len(kv) == 0 {
			continue
		}
		pos := strings.Index(kv, "=")
		if pos == -1 {
			log.Debug(v)
			log.Debug(kv)
			log.Warning("map k-v must be split by '='!")
		}
		kType := whatType(kv[:pos])
		if kType != StringType && kType != IntType {
			log.Debug(v)
			log.Debug(kv)
			log.Warning("map key must be integer or string!")
		}
		kk, vv := autoMake(kv[:pos]), autoMake(kv[pos+1:])
		if vv == nil {
			continue
		}
		if kk == nil {
			log.Debug(v)
			log.Debug(kv)
			log.Warning("map key must not be empty!")
		}
		if _, ok := mapp[kk]; ok {
			log.Debug(v)
			log.Debug(kv)
			log.Warning("map key duplicated!")
		}
		mapp[kk] = vv
	}
	return mapp
}

func splitLine(v string) []string {
	ret := []string{}
	s, strb, ignore := 0, false, false
	v = strings.TrimSpace(v)
	for i, c := range v {
		if ignore {
			ignore = false
			continue
		}

		if c == ',' {
			if !strb {
				ret = append(ret, v[s:i])
				s = i + 1
				continue
			}
		} else if c == '"' {
			if strb {
				if i+1 < len(v) && v[i+1] == '"' {
					// ignore """
					ignore = true
				} else {
					strb = false
				}
			} else {
				strb = true
			}
		}
	}
	if len(v) > s {
		ret = append(ret, v[s:])
	} else if v[len(v)-1] == ',' {
		ret = append(ret, "")
	}
	return ret
}

func (f *File) load(path, l10n string) {
	fp, err := os.Open(path)
	if err != nil {
		return
	}
	defer fp.Close()

	rd := bufio.NewReader(fp)
	langSuffix := ""
	needRemove := false
	if l10n != "cn" {
		langSuffix = "_" + l10n
	}

	// key
	line, _, err := rd.ReadLine()
	fields := strings.Split(strings.TrimSpace(string(line)), ",")[1:]
	fieldTypes := make([]int, len(fields))
	fieldsMap := make(map[string]int)
	for i, s := range fields {
		s = strings.TrimSpace(s)
		fields[i] = s
		fieldsMap[s] = i
		// ignore "_" prefix
		if s[0] == '_' {
			fieldsMap[s] = -1
			needRemove = true
		}
	}

	// default
	line, _, err = rd.ReadLine()
	defaults := strings.Split(strings.TrimSpace(string(line)), ",")[1:]
	defFieldTypes := make([]int, len(fields))
	f.Defaults = make(Row)
	for i, s := range defaults {
		if len(s) != 0 {
			defFieldTypes[i] = whatType(s)
		} else {
			defFieldTypes[i] = NilType
		}
		fieldTypes[i] = defFieldTypes[i]
	}

	// language map
	for i, s := range fields {
		if len(langSuffix) > 0 {
			if strings.HasSuffix(s, langSuffix) {
				base := s[:len(s)-len(langSuffix)]
				fieldsMap[base] = i
				for _, other := range languages {
					fieldsMap[base+other] = i
				}
				needRemove = true
			}
		} else {
			for _, other := range languages {
				if strings.HasSuffix(s, other) {
					base := s[:len(s)-len(other)]
					fieldsMap[s] = fieldsMap[base]
					needRemove = true
				}
			}
		}
	}

	// comment
	line, _, err = rd.ReadLine()

	// rows type
	rows := []string{}
	for {
		line, _, err = rd.ReadLine()
		line, _ := util.GBKToUTF8([]byte(line))
		if err != nil {
			break
		}
		rows = append(rows, strings.TrimSpace(string(line)))
	}

	rowFields := [][]string{}
	for _, row := range rows {
		vals := splitLine(row)
		l := len(vals)
		if l != 1+len(fields) {
			log.Debug(vals)
			log.Errorf("fields count error! %d, %d", 1+len(fields), l)
		}
		// no id
		if len(strings.TrimSpace(vals[0])) == 0 {
			continue
		}

		newVals := make([]string, 0, len(vals))
		newVals = append(newVals, vals[0])
		for i := 1; i < l; i++ {
			if fieldsMap[fields[i-1]] != i-1 {
				continue
			}
			val := strings.TrimSpace(vals[i])
			newVals = append(newVals, val)
			if len(val) != 0 {
				t := whatType(val)
				if t > fieldTypes[i-1] {
					fieldTypes[i-1] = t
				}
			}
		}
		rowFields = append(rowFields, newVals)
	}

	// if existed default, rows value must same as default type
	for i, _ := range defaults {
		if defFieldTypes[i] != NilType {
			t1, t2 := defFieldTypes[i], fieldTypes[i]
			if t1 != t2 {
				if t1+t2 == IntType+FloatType && t1*t2 == IntType*FloatType {
					fieldTypes[i] = FloatType
				} else {
					log.Panicf("%s field %s type %d not same as default %d", path, fields[i], fieldTypes[i], defFieldTypes[i])
				}
			}
		}
	}

	// adjust default type
	for i, s := range defaults {
		if fieldsMap[fields[i]] != i {
			continue
		}
		if len(s) == 0 {
			switch fieldTypes[i] {
			case NilType:
				f.Defaults[fields[i]] = nil
			case IntType:
				f.Defaults[fields[i]] = 0
			case FloatType:
				f.Defaults[fields[i]] = 0.0
			case StringType:
				f.Defaults[fields[i]] = ""
			case ArrayType:
				f.Defaults[fields[i]] = []interface{}{}
			case MapType:
				f.Defaults[fields[i]] = map[interface{}]interface{}{}
			}
		} else {
			f.Defaults[fields[i]] = makeElem(fieldTypes[i], s)
		}
	}

	// remove other languages
	newFields := fields
	newFieldTypes := fieldTypes
	if needRemove {
		newFields = make([]string, 0, len(fields))
		newFieldTypes = make([]int, 0, len(fields))
		for i, s := range fields {
			if fieldsMap[s] != i {
				continue
			}
			if len(langSuffix) > 0 && strings.HasSuffix(s, langSuffix) {
				s = s[:len(s)-len(langSuffix)]
			}
			newFields = append(newFields, s)
			newFieldTypes = append(newFieldTypes, fieldTypes[i])
		}
	}

	// rows
	f.parseRows(rowFields, newFields, newFieldTypes)
}

func (f *File) parseRows(rows [][]string, fields []string, fieldTypes []int) {
	for _, vals := range rows {
		l := len(vals)
		id, _ := strconv.Atoi(vals[0])
		row := &Row{"_id": id}
		for i := 1; i < l; i++ {
			field := fields[i-1]
			val := vals[i]
			if len(val) != 0 {
				(*row)[field] = makeElem(fieldTypes[i-1], val)
			}
		}
		f.Rows[id] = row
	}
}

//func visitCsvFiles(path, l10n string, csv map[string]interface{}) {
//	files, _ := ioutil.ReadDir(path)
//	for _, fi := range files {
//		name := fi.name()
//		fpath := filepath.Join(path, name)
//		log.Debug("visit", name, fpath)
//		if fi.IsDir() {
//			csv[name] = make(map[string]interface{})
//			visitCsvFiles(fpath, l10n, csv[name].(map[string]interface{}))
//		} else {
//			if strings.HasSuffix(name, ".csv") {
//				csvName := name[:len(name)-4]
//				csv[csvName] = parseCsv(fpath, l10n)
//			}
//		}
//	}
//}

//func parseCsv(path, l10n string) *File {
//	file := &File{
//		Rows:     make(map[int]*Row),
//		Defaults: make(Row),
//	}
//	file.load(path, l10n)
//	return file
//}

//func parse(path, l10n string) map[string]interface{} {
//	ret := make(map[string]interface{})
//	visitCsvFiles(path, l10n, ret)
//	return ret
//}

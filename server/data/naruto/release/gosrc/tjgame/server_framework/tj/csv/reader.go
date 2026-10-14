package csv

import (
	"bufio"
	gocsv "encoding/csv"
	"fmt"
	"os"
	"strings"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"

	"github.com/tealeg/xlsx"
)

type Reader struct {
	colnum   int
	keys     []string
	keyTypes []int // set in outside
	defs     []string
	comments []string
	content  [][]string
}

func (r *Reader) Keys() []string {
	return r.keys
}

func (r *Reader) KeyTypes() []int {
	return r.keyTypes
}

func (r *Reader) Defs() []string {
	return r.defs
}

func (r *Reader) Comments() []string {
	return r.comments
}

func (r *Reader) Content() [][]string {
	return r.content
}

func NewReader(name string) *Reader {
	if strings.HasSuffix(name, ".csv") {
		return NewCSVReader(name)
	}
	if strings.HasSuffix(name, ".xlsx") {
		return NewXlsxReader(name)
	}
	panic(fmt.Sprintf("unknow suffix, %s", name))
}

func checkAllKeyTypes(keys []string, defs []string, content [][]string, path string) []int {
	ret := make([]int, len(keys))

	for i, key := range keys {
		if strings.Index(key, "_") > -1 {
			continue
		}
		var typ int
		if i == 0 {
			key = "ID"
			typ = IntType
		} else {
			typ = whatType(defs[i])
		}

		// check all field value type
		fieldType := typ
		for j := 0; j < len(content); j++ {
			val := content[j][i]
			if len(val) != 0 {
				t := whatType(val)
				if t > fieldType {
					fieldType = t
				}
			}
		}

		// if existed default, rows value must same as default type
		if typ != NilType {
			t1, t2 := typ, fieldType
			if t1 != t2 {
				if t1+t2 == IntType+FloatType && t1*t2 == IntType*FloatType {
					typ = FloatType
				} else {
					log.Panicf("%s field %s type %d not same as default %d", path, key, fieldType, typ)
				}
			}
		} else {
			typ = fieldType
		}
		ret[i] = typ
	}
	return ret
}

func NewCSVReader(name string) *Reader {
	defer func() {
		if err := recover(); err != nil {
			log.Errorf("error in file %s", name)
			panic(err)
		}
	}()

	f, err := os.Open(name)
	if err != nil {
		panic(err)
	}
	defer f.Close()

	bom := true
	br := bufio.NewReader(f)
	r, _, err := br.ReadRune()
	if err != nil {
		panic(err)
	}
	if r != '\uFEFF' {
		br.UnreadRune() // Not a BOM -- put the rune back
		bom = false
	}
	//fmt.Printf("file %s, bom %v\n", name, bom)

	content, err := gocsv.NewReader(br).ReadAll()
	if err != nil {
		panic(fmt.Sprintf("read %s error %v", name, err))
	}

	valid := make([]int, 0, len(content[0]))
	for i, key := range content[0] {
		if key == "" {
			break
		}
		if key[0] != '_' {
			valid = append(valid, i)
		}
	}

	validFunc := func(col []string) []string {
		values := make([]string, 0, len(col))
		for _, i := range valid {
			var s string
			if bom {
				s = col[i]
			} else {
				ss, _ := util.GBKToUTF8([]byte(col[i]))
				s = string(ss)
			}
			values = append(values, strings.TrimSpace(s))
		}
		return values
	}

	reader := &Reader{
		colnum: len(valid),
	}
	reader.keys = validFunc(content[0])
	reader.defs = validFunc(content[1])
	reader.comments = validFunc(content[2])
	reader.content = make([][]string, 0, len(content)-3)
	for _, col := range content[3:] {
		if col[0] == "" {
			continue
		}
		reader.content = append(reader.content, validFunc(col))
	}
	reader.keyTypes = checkAllKeyTypes(reader.keys, reader.defs, reader.content, name)

	return reader
}

func NewXlsxReader(name string) *Reader {
	defer func() {
		if err := recover(); err != nil {
			log.Errorf("error in file %s", name)
			panic(err)
		}
	}()

	f, err := xlsx.OpenFile(name)
	if err != nil {
		panic(err)
	}
	sheet := f.Sheets[0]
	row := sheet.Rows[0]
	valid := make([]int, 0, len(row.Cells))
	for i, cell := range row.Cells {
		key := cell.String()
		if key == "" {
			break
		}
		if key[0] != '_' {
			valid = append(valid, i)
		}
	}
	reader := &Reader{
		colnum: len(valid),
	}
	content := make([][]string, 0, sheet.MaxRow)
	for _, row := range sheet.Rows {
		length := len(row.Cells)
		if length == 0 || row.Cells[0].String() == "" {
			continue
		}
		col := make([]string, 0, reader.colnum)
		for _, j := range valid {
			if j >= length {
				col = append(col, "")
			} else {
				col = append(col, strings.TrimSpace(row.Cells[j].String()))
			}
		}
		content = append(content, col)
	}
	reader.keys = content[0]
	reader.defs = content[1]
	reader.comments = content[2]
	reader.content = content[3:]
	reader.keyTypes = checkAllKeyTypes(reader.keys, reader.defs, reader.content, name)

	return reader
}

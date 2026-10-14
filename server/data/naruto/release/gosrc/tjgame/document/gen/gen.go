package gen

import (
	"bufio"
	"fmt"
	"go/ast"
	"go/parser"
	"go/token"
	"html/template"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
)

var goTmpl = `
// Code generated - gen by document/gen - DO NOT EDIT.
package scheme

import (
	"tjgame/document"
	"tjgame/server_framework/tj/log"
	"tjgame/ugorji_go/codec"
	"sync"
	"sync/atomic"
)

{{range $i, $s := .}}
{{ $objname := printf "%sObject" .Name }}
// {{ .Name }}
type {{ $objname }} struct {
	document.Skeleton

	lock   sync.RWMutex
	locked int32
	db     *{{ .Name }}
}

// IDocument
func (o *{{ $objname }}) GetID() document.ID {
	return o.db.GetID()
}

func (o *{{ $objname }}) SetID(id document.ID) {
	o.db.SetID(id)
}

func (o *{{ $objname }}) CollectionName() string {
	return o.db.CollectionName()
}

// IWatchedDocument
func (o *{{ $objname }}) BeWatched() document.IDocument {
	return o.db
}

func (o *{{ $objname }}) SetDirty(keys ...string) {
	o.Skeleton.SetDirty(o, keys...)
}

func (o *{{ $objname }}) Lock() {
	o.lock.Lock()
	atomic.AddInt32(&o.locked, 1)
}

func (o *{{ $objname }}) Unlock() {
	atomic.AddInt32(&o.locked, 0)
	o.lock.Unlock()
}

func (o *{{ $objname }}) RLock() {
	o.lock.RLock()
	atomic.AddInt32(&o.locked, 1)
}

func (o *{{ $objname }}) RUnlock() {
	atomic.AddInt32(&o.locked, 0)
	o.lock.RUnlock()
}

func (o *{{ $objname }}) RLocker() sync.Locker {
	return (*rlocker{{ $objname }})(o)
}

type rlocker{{ $objname }} {{ $objname }}

func (r *rlocker{{ $objname }}) Lock()   { (*{{ $objname }})(r).RLock() }
func (r *rlocker{{ $objname }}) Unlock() { (*{{ $objname }})(r).RUnlock() }

// Selfer
func (o *{{ $objname }}) CodecEncodeSelf(e *codec.Encoder) {
	o.RLock()
	defer o.RUnlock()

	if err := e.Encode(o.db); err != nil {
		log.Errorf("{{ $objname }}:%v encode self error:%v", o.GetID(), err)
	}
}

func (o *{{ $objname }}) CodecDecodeSelf(e *codec.Decoder) {
	db := &{{ .Name }}{}
	if err := e.Decode(db); err != nil {
		log.Errorf("{{ $objname }} decode self error:%v", err)
	} else {
		o.db = db
	}
}

func (o *{{ $objname }}) RLockAndGetDB() (*{{ .Name }}, document.UnlockFunc) {
	o.RLock()
	return o.db, o.RUnlock
}

func (o *{{ $objname }}) LockAndGetDB() (*{{ .Name }}, document.UnlockFunc) {
	o.Lock()
	return o.db, o.Unlock
}

func (o *{{ $objname }}) GetLockedDB() *{{ .Name }} {
	if atomic.LoadInt32(&o.locked) > 0 {
		return o.db
	}
	// cause panic in outside code
	log.Errorf("{{ $objname }}:%v get db without locked", o.GetID())
	return nil
}

func New{{ $objname }}(db *{{ .Name }}) *{{ $objname }} {
	return &{{ $objname }} {
		db: db,
		locked: 0,
	}
}

{{ range .Fields }}
// {{ .Name }}
// {{ .Tag }}
func (o *{{ $objname }}) {{ .Name }}() {{ .Type }} {
	return o.db.{{ .Name }}
}

func (o *{{ $objname }}) Set{{ .Name }}(v {{ .Type }}) {
	o.db.{{ .Name }} = v
	o.Skeleton.SetDirty(o, "{{ .DBKey }}")
}
{{ end }}
{{ end }}
`

type fieldspec struct {
	Name  string
	Type  string
	Tag   string
	DBKey string
}

type structspec struct {
	Name string // struct name

	Fields []fieldspec
}

func writeToFile(name string, specs []structspec) {
	f, err := os.Create(name)
	if err != nil {
		panic(err)
	}
	defer f.Close()

	//tmpl := strings.Replace(goTmpl, "%GEN_DATE%", time.Now().Format("2006-01-02 15:04:05"), 1)
	tmpl := goTmpl
	t, err := template.New("obj.go.tmpl").Parse(tmpl)
	if err != nil {
		panic(err)
	}

	bw := bufio.NewWriter(f)
	err = t.Execute(bw, specs)
	if err != nil {
		bw.Flush()
		panic(err)
	}
	err = bw.Flush()
	if err != nil {
		panic(err)
	}
}

func Scheme2ORM(schemeDir string) {
	if err := os.Chdir(schemeDir); err != nil {
		panic(err)
	}
	genFiles, err := filepath.Glob("*.gen.go")
	if err != nil {
		panic(err)
	}
	for _, f := range genFiles {
		if err := os.Remove(f); err != nil {
			panic(err)
		}
	}

	// Create the AST by parsing src.
	fset := token.NewFileSet() // positions are relative to fset

	files, _ := ioutil.ReadDir(".")
	for _, info := range files {
		if info.IsDir() {
			continue
		}
		if strings.Index(info.Name(), ".gen.go") != -1 {
			continue
		}

		fmt.Println(info.Name())
		data, err := ioutil.ReadFile(info.Name())
		fmt.Println(len(data), err)
		if err != nil {
			panic(err)
		}

		f, err := parser.ParseFile(fset, info.Name(), data, 0)
		if err != nil {
			panic(err)
		}

		// Print the AST.
		//ast.Print(fset, f)

		classes := []structspec{}

		i := 0
		for _, decl := range f.Decls {
			gdecl, ok := decl.(*ast.GenDecl)
			if !ok {
				continue
			}
			if gdecl.Tok != token.TYPE {
				continue
			}
			typeSpec, ok := gdecl.Specs[0].(*ast.TypeSpec)
			if !ok {
				continue
			}
			structType, ok := typeSpec.Type.(*ast.StructType)
			if !ok {
				continue
			}
			firstField := structType.Fields.List[0]
			if id, ok := firstField.Type.(*ast.SelectorExpr); !ok {
				continue
			} else {
				if id.Sel.Name != "DocumentID" {
					continue
				}
			}

			i += 1
			fmt.Println("-----------------")
			fmt.Println(i, typeSpec.Name.Name)

			class := structspec{
				Name:   typeSpec.Name.Name,
				Fields: make([]fieldspec, 0, 5),
			}
			for j := 1; j < len(structType.Fields.List); j += 1 {
				field := structType.Fields.List[j]
				//fmt.Printf("%s %d %#v\n", class.Name, j, field)
				//ast.Print(fset, field)

				p := fset.Position(field.Type.Pos())
				typ := string(data[p.Offset : p.Offset+int(field.Type.End()-field.Type.Pos())])
				//typ = strings.TrimRight(typ, " \t\r\n")
				//typ := field.Type.(*ast.Ident).Name
				tag := field.Tag.Value
				tag = strings.Replace(tag, `"`, "", -1)
				tag = strings.Replace(tag, "`", "", -1)
				tag = strings.Trim(tag, "\r\n")
				pos := strings.Index(tag, "codec:")
				if pos == -1 {
					panic(fmt.Sprintf("field %s no codec tag", field.Names[0].Name))
				}
				key := strings.Fields(tag[pos:])[0][6:]
				class.Fields = append(class.Fields, fieldspec{
					Name:  field.Names[0].Name,
					Type:  typ,
					Tag:   tag,
					DBKey: key,
				})

			}
			fmt.Println(class)
			classes = append(classes, class)
		}

		if len(classes) == 0 {
			continue
		}

		genFilename := strings.Replace(info.Name(), ".go", ".gen.go", 1)
		writeToFile(genFilename, classes)
		//break
	}
}

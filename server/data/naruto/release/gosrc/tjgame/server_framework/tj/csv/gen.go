package csv

import (
	"bufio"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"path"
	"path/filepath"
	"regexp"
	"runtime"
	"strconv"
	"strings"
	"sync"
	"text/template"
	"time"

	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
)

var format = "`yaml:\"%s\" codec:\"%s\"`"
var reservedKeys = []string{"var", "const", "type", "package", "import", "func", "return", "defer", "go", "select", "interface", "struct", "break", "case", "continue", "for", "fallthrough", "else", "if", "switch", "goto", "default", "chan", "map", "range", "slice", "channel", "version", "init", "reload", "load"}
var ignoreFiles = []string{
	"[^_]buff.csv",
	"buff_group_relation.csv",
	"skill_process.csv",
	"skill_auto_test.csv",
	"unit_csv_test.csv",
	"game_end_special_rule.csv",
	"effect_event.csv",
	"formula_const.csv",
	"damage_process.csv",
	"combat_manual.csv",
	"draw_preview.csv",
	`scene[\/\\]`,
	`stage[\/\\]`,
	`^weather`, // 战斗天气相关表
	"card_battle_recommend.csv",
	"card_bag.csv",
	"cityscene.csv",
	"citysound.csv",
	"color.csv",
	"huodong_display_replace.csv",
	"loading_tips.csv",
}

func formatTag(tag string) string {
	return fmt.Sprintf(format, tag, tag)
}

type fieldspec struct {
	Name    string
	Type    string
	Comment string
	Tag     string
}

type structspec struct {
	Name    string // struct name
	Vname   string // variate name
	Comment string

	Fields []fieldspec
}

type inode struct {
	name  string
	isdir bool
	path  string
	nodes []*inode
	prev  *inode

	structname  string
	variatename string

	csvLock sync.Mutex
}

var prefix string

func prettycomment(s string) string {
	comment := filepath.ToSlash(s)
	if strings.HasPrefix(comment, prefix) {
		idx := len(prefix)
		if idx >= len(comment) {
			comment = ""
		} else {
			if comment[idx] == '/' {
				idx += 1
			}
			comment = comment[idx:]
		}
	}
	return comment
}

func (n *inode) gen() structspec {
	sp := structspec{
		Name:    n.structname,
		Vname:   n.variatename,
		Comment: prettycomment(n.path),
	}
	if n.isdir {
		sp.Fields = make([]fieldspec, 0, len(n.nodes))
		for _, nn := range n.nodes {
			typ := fmt.Sprintf("*%s", nn.structname)
			if !nn.isdir {
				typ = fmt.Sprintf("map[int]*%s", nn.structname)
			}
			sp.Fields = append(sp.Fields, fieldspec{nn.variatename, typ, prettycomment(nn.path), formatTag(nn.name)})
		}
	} else {
		sp.Fields = n.parseCSVFields()
	}
	return sp
}

func (n *inode) parseCSVFields() []fieldspec {
	reader := NewReader(n.path)
	keys := reader.Keys()
	keyTypes := reader.KeyTypes()
	specs := make([]fieldspec, 0, len(keys))
	for i, key := range keys {
		if strings.Index(key, "_") > -1 {
			continue
		}
		var typ int
		if i == 0 {
			key = "ID"
			typ = IntType
		} else {
			typ = keyTypes[i]
		}

		spec := fieldspec{
			strings.Title(key),
			goTypes[typ],
			reader.Comments()[i],
			formatTag(key),
		}
		specs = append(specs, spec)
	}
	return specs
}

func abs(a int) int {
	if a < 0 {
		return -a
	}
	return a
}

func (n *inode) parseCSV(lang string, csv map[string]interface{}) {
	//fmt.Printf("parse %s\n", n.path)

	reader := NewReader(n.path)
	keys := reader.Keys()
	keyTypes := reader.KeyTypes()
	content := reader.Content()
	defs := reader.Defs()

	keyMap := make(map[string]int, len(keys))
	for i, key := range keys {
		keyMap[key] = i
	}
	// for language
	for i, key := range keys {
		// _xxx is ignore
		// xxx_tw is l10n
		if strings.Index(key, "_") > -1 {
			keyMap[key] = -keyMap[key]
			continue
		}
		langKey := key + lang
		if j, ok := keyMap[langKey]; ok {
			keyMap[key] = abs(j)
		} else {
			keyMap[key] = i
		}
	}

	selfCsv := make(map[int]map[string]interface{}, len(content))
	for _, line := range content {
		row := make(map[string]interface{}, len(keys))
		id, _ := strconv.Atoi(line[0])
		row["ID"] = id
		for i, key := range keys[1:] {
			if idx := keyMap[key]; idx > 0 {
				typ := keyTypes[i+1]
				value := line[idx]
				if value == "" {
					value = defs[idx]
				}

				if value == "" {
					// adjust default
					if len(defs[i]) == 0 {
						switch typ {
						case NilType:
							row[key] = nil
						case IntType:
							row[key] = 0
						case FloatType:
							row[key] = 0.0
						case StringType:
							row[key] = ""
						case ArrayType:
							row[key] = Slice{}
						case MapType:
							row[key] = Map{}
						}
					}
				} else {
					//row[key] = autoMake(value)
					row[key] = makeElem(typ, value)
				}
			}
		}
		selfCsv[id] = row
	}

	//n.prev.csvLock.Lock()
	//n.prev.csv[n.name] = csv
	//n.prev.csvLock.Unlock()

	n.prev.csvLock.Lock()
	csv[n.name] = selfCsv
	n.prev.csvLock.Unlock()
}

func (n *inode) parse(lang string, csv map[string]interface{}) {
	if n.isdir {
		selfCsv := make(map[string]interface{}, len(n.nodes))
		csv[n.name] = selfCsv
		for _, nn := range n.nodes {
			nn.parse(lang, selfCsv)
		}
	} else {
		if parseChan != nil {
			parseWgs[lang].Add(1)
			parseChan <- func() {
				n.parseCSV(lang, csv)
				parseWgs[lang].Done()
			}
		} else {
			n.parseCSV(lang, csv)
		}
	}
}

func visit(path string, parent *inode, exists map[string]bool) {
	// filenames in lexicographical order
	files, _ := ioutil.ReadDir(path)
	parent.nodes = make([]*inode, 0, len(files))

	for _, fi := range files {
		name := fi.Name()
		if name[0] == '.' {
			continue
		}
		if !fi.IsDir() {
			if !strings.HasSuffix(name, ".csv") && !strings.HasSuffix(name, ".xlsx") {
				log.Warningf("no supported file %s", name)
				continue
			}
		}
		fpath := filepath.Join(path, name)
		fmt.Printf("visit %s\n", fpath)
		flag := false
		for _, pattern := range ignoreFiles {
			matched, err := regexp.MatchString(pattern, fpath)
			if err != nil {
				log.Warningf("regexp match error %v, pattern %s, %s", err, pattern, fpath)
			}
			if matched {
				flag = true
				break
			}
		}
		if flag {
			log.Warningf("ignore file %s", fpath)
			continue
		}

		n := strings.Split(filepath.Base(name), ".")[0]
		subpath := strings.Split(fpath, ".")[0]
		subpath = prettycomment(subpath)
		structname := strings.Join(strings.Split(subpath, "/"), "_")
		structname = strings.Title(structname)
		if exists[structname] {
			log.Panicf("already existed %s, %s", structname, fpath)
		}

		exists[structname] = true
		node := &inode{
			name:        n,
			isdir:       fi.IsDir(),
			path:        fpath,
			structname:  structname,
			variatename: strings.Title(n),
		}
		//if node.isdir && parent.csv != nil {
		//	node.csv = make(map[string]interface{})
		//	parent.csv[n] = node.csv
		//}
		node.prev = parent
		parent.nodes = append(parent.nodes, node)

		if fi.IsDir() {
			visit(fpath, node, exists)
		}
	}
}

func Csv2src(in string, out string) {
	prefix = filepath.ToSlash(in)
	start := time.Now().Unix()
	defer func() {
		end := time.Now().Unix()
		fmt.Printf("cost time: %ds\n", end-start)
	}()

	root := &inode{
		name:       "config",
		isdir:      true,
		path:       in,
		structname: "csvConfig",
	}
	exists := make(map[string]bool, len(reservedKeys))
	for _, key := range reservedKeys {
		exists[strings.Title(key)] = true
	}
	visit(in, root, exists)

	files := strings.Split(out, "+")
	for _, filename := range files {
		switch path.Ext(filename) {
		case ".msgpack":
			csv2msgpack(root, filename)
		case ".go":
			csv2go(root, filename)
		//case ".yaml":
		//	csv2yaml(root, filename)
		default:
			panic(fmt.Sprintf("unsupport %s", path.Ext(filename)))
		}
		runtime.GC()
	}
}

var parseChan chan func()
var parseWgs map[string]*sync.WaitGroup
var allWg sync.WaitGroup

func runInGo(thread int, root *inode, f func(string, interface{})) {
	langs := append([]string{"_cn"}, languages...)
	parseWgs = make(map[string]*sync.WaitGroup, len(langs))
	for _, lang := range langs {
		parseWgs[lang] = &sync.WaitGroup{}
	}
	allWg.Add(len(langs))

	parseChan = make(chan func(), 999)
	for i := 0; i < thread; i++ {
		go func() {
			for f := range parseChan {
				//fmt.Println(util.GoID(), n.name)
				f()
			}
		}()
	}

	for _, lang := range langs {
		l := lang
		ff := func() {
			csv := make(map[string]interface{}, len(root.nodes))
			root.parse(l, csv)

			parseWgs[l].Wait()

			f(l, csv[root.name])

			allWg.Done()
		}

		if thread > 1 {
			go ff()
		} else {
			ff()
		}
	}

	allWg.Wait()

	close(parseChan)
	parseChan = nil
}

func csv2msgpack(root *inode, out string) {
	handle := func(lang string, csv interface{}) {
		data, err := util.MsgPack(csv)
		if err != nil {
			panic(err)
		}
		runtime.GC()

		filename := fmt.Sprintf("%s/%s.%s", filepath.Dir(out), lang[1:], filepath.Base(out))
		writeToFile(filename, func(writer io.Writer) {
			writer.Write(data)
		})
	}

	runInGo(1, root, handle)
}

//func csv2yaml(root *inode, out string) {
//	handle := func(lang string, csv interface{}) {
//		data, err := yaml.Marshal(csv)
//		if err != nil {
//			panic(err)
//		}
//		runtime.GC()
//
//		filename := fmt.Sprintf("%s/%s.%s", path.Dir(out), lang[1:], path.Base(out))
//		writeToFile(filename, func(writer io.Writer) {
//			writer.Write(data)
//		})
//	}
//
//	runInGo(1, root, handle)
//}

var goTypes = []string{"interface{}", "bool", "int", "float64", "string", "tjcsv.Slice", "tjcsv.Map"}
var goTmpl = `
// Code generated - temporary package for csvgen - DO NOT EDIT.
package csv

import tjcsv "tjgame/server_framework/tj/csv"

{{range .}}// {{ .Comment }}
type {{ .Name }} struct {
{{ range .Fields }}	// {{ .Comment }}
	{{ .Name }} {{ .Type }} {{ .Tag }}
{{ end }}}
{{ end }}
`

func csv2go(root *inode, out string) {
	specs := bfs(root)

	writeToFile(out, func(writer io.Writer) {
		t, err := template.New("csv.go.tmpl").Parse(goTmpl)
		if err != nil {
			panic(err)
		}

		bw := bufio.NewWriter(writer)
		err = t.Execute(bw, specs)
		if err != nil {
			bw.Flush()
			panic(err)
		}
		err = bw.Flush()
		if err != nil {
			panic(err)
		}
	})
}

func writeToFile(name string, do func(writer io.Writer)) {
	os.RemoveAll(name)
	f, err := os.Create(name)
	if err != nil {
		panic(err)
	}
	defer f.Close()

	do(f)
}

func bfs(node *inode) []structspec {
	//fmt.Printf("bfs: %s\n", node.path)
	specs := make([]structspec, 0, len(node.nodes))
	specs = append(specs, node.gen())
	for _, n := range node.nodes {
		specs = append(specs, bfs(n)...)
	}
	return specs
}

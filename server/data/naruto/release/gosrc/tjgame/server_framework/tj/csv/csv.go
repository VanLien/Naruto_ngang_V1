package csv

import (
	"errors"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"reflect"
	"runtime"
	"time"
	"tjgame/ugorji_go/codec"

	"tjgame/server_framework/tj/log"
)

var (
	DirNotFound   = errors.New("csv: dir not found")
	FileNotFound  = errors.New("csv: file not found")
	RowNotFound   = errors.New("csv: row not found")
	FieldNotFound = errors.New("csv: field not found")
	TypeError     = errors.New("csv: value type assert error")
)

var csvPath string
var csvL10n string
var csvFile string
var csvVersion int64
var csvDebug bool

var handle *codec.MsgpackHandle

func msgunpack(data []byte, csv interface{}) error {
	return codec.NewDecoderBytes(data, handle).Decode(csv)
}

func load(csv interface{}) error {
	data, err := ioutil.ReadFile(csvFile)
	if err != nil {
		log.Errorf("load csv file %s error %v", csvFile, err)
		return err
	}

	//err = yaml.Unmarshal(data, csv)
	err = msgunpack(data, csv)
	if err != nil {
		log.Errorf("unmarshal error %v", err)
		return err
	}
	runtime.GC()
	return nil
}

func Reload(csv interface{}) error {
	csvVersion = time.Now().Unix() - 1400000000
	if csvDebug {
		log.Infof("csv generated %s %s %s", csvPath, csvL10n, csvFile)
		Csv2src(csvPath, csvFile)
	}
	return load(csv)
}

func locatecsvfile(filename string) (string, error) {
	path, _ := os.Getwd()
	csvfile := filepath.Join(path, filename)
	var err error
	for {
		if _, err = os.Stat(csvfile); err == nil {
			break
		} else if os.IsNotExist(err) {
			old := path
			path = filepath.Dir(path)
			if old == path { // root directory
				return "", FileNotFound
			}
			csvfile = filepath.Join(path, filename)
		} else {
			return "", err
		}
	}
	return csvfile, err
}

func Init(csv interface{}, path string, l10n string, debug bool) error {
	csvPath = path
	csvL10n = l10n
	csvFile = fmt.Sprintf("%s.config_csv.msgpack", l10n)
	csvDebug = debug
	if path, err := locatecsvfile(csvFile); err == nil {
		csvFile = path
	} else if err != FileNotFound {
		return err
	}
	log.Debugf("locate %s\n", csvFile)
	return Reload(csv)
}

func Version() int64 {
	return csvVersion
}

func init() {
	handle = new(codec.MsgpackHandle)
	handle.MapType = reflect.TypeOf(Map{})
	handle.SliceType = reflect.TypeOf(Slice{})
	handle.InternString = true
	handle.RawToString = true
}

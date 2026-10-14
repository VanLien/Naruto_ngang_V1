// Its only reference to tjcsv
package csv

import (
	"bytes"
	"errors"
	"fmt"
	"io"
	"os"
	"os/exec"
	"reflect"
	"sync/atomic"
	"time"

	tjcsv "tjgame/server_framework/tj/csv"
	"tjgame/server_framework/tj/log"
)

var csv atomic.Value
var csvPath string
var csvDebug bool

func Reload() (string, error) {
	var buffer bytes.Buffer
	st := time.Now()
	if csvDebug {
		cd(csvPath, func() {
			buffer.WriteString("旧版本信息:\n")
			run(&buffer, &buffer, "svn info")
			buffer.WriteString("\n====================\n")

			run(nil, nil, "svn update")

			buffer.WriteString("现版本信息:\n")
			run(&buffer, &buffer, "svn info")
		})
	}

	old := GetConfig()
	log.Infof("CSV Reload before, %d %p", Version(), old)
	v := &csvConfig{}
	err := tjcsv.Reload(v)
	if err == nil {
		csv.Store(v)
	}
	log.Infof("CSV Reload after, %d %p", Version(), GetConfig())
	if err == nil && old == GetConfig() {
		return "", errors.New("csv reload maybe failed")
	}
	buffer.WriteString("CSV Reload Over.\n")
	buffer.WriteString(fmt.Sprintf("Cost %v.\n", time.Now().Sub(st)))
	log.Infof("%s", buffer.String())
	return buffer.String(), err
}

func Init(path string, l10n string, debug bool) error {
	csvPath = path
	csvDebug = debug
	v := &csvConfig{}
	err := tjcsv.Init(v, path, l10n, debug)
	if err == nil {
		csv.Store(v)
	}
	err = LoadMergeConfig()
	return err
}

func Version() int64 {
	return tjcsv.Version()
}

func GetConfig() *csvConfig {
	// log.Infof("[chanlong] csv GetConfig: csvPath=%s",csvPath)
	return csv.Load().(*csvConfig)
}

func run(stdout io.Writer, stderr io.Writer, name string, arg ...string) {
	cmd := exec.Command(name, arg...)
	cmd.Stdout = stdout
	cmd.Stderr = stderr
	cmd.Run()
}

func cd(path string, f func()) {
	dir, _ := os.Getwd()
	defer os.Chdir(dir)
	os.Chdir(path)
	f()
}

func Interface2int(v interface{}) int {
	switch vv := v.(type) {
	case int:
		return vv
	case int8:
		return int(vv)
	case int16:
		return int(vv)
	case int32:
		return int(vv)
	case int64:
		return int(vv)
	case uint:
		return int(vv)
	case uint8:
		return int(vv)
	case uint16:
		return int(vv)
	case uint32:
		return int(vv)
	case uint64:
		return int(vv)
	default:
		panic("can not convert to int")
	}
	return 0
}

func Interface2string(v interface{}) string {
	switch vv := v.(type) {
	case string:
		return vv
	case []byte:
		return string(vv)
	default:
		panic("can not convert to string")
	}
	return ""
}

func FieldByName(cfg interface{}, name string) interface{} {
	v := reflect.ValueOf(cfg)
	if v.Kind() == reflect.Ptr {
		v = v.Elem()
	}
	field := v.FieldByName(name)
	return field.Interface()
}

func FieldRangeValue(cfg interface{}, format string, f func(value interface{}) bool) {
	v := reflect.ValueOf(cfg)
	if v.Kind() == reflect.Ptr {
		v = v.Elem()
	}
	i := 1
	for {
		field := v.FieldByName(fmt.Sprintf(format, i))
		if !field.IsValid() {
			break
		}
		if !f(field.Interface()) {
			break
		}
	}
}

func FieldRangeValues(cfg interface{}, formats []string, f func(values []interface{}) bool) {
	v := reflect.ValueOf(cfg)
	if v.Kind() == reflect.Ptr {
		v = v.Elem()
	}
	i := 1
	for {
		broken := false
		values := make([]interface{}, len(formats))
		for idx, format := range formats {
			field := v.FieldByName(fmt.Sprintf(format, i))
			if !field.IsValid() {
				broken = true
				break
			}
			values[idx] = field.Interface()
		}
		if broken {
			break
		}
		if !f(values) {
			break
		}
		i++
	}
}

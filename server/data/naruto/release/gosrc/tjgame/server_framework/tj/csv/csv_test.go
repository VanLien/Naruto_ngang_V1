package csv

import "testing"

//func TestGenYaml(t *testing.T) {
//	Csv2src("./config", "config_csv.yaml")
//}

func TestGenGo(t *testing.T) {
	Csv2src("./config", "csv.generated.go")
}

func TestGenMsgpack(t *testing.T) {
	Csv2src("./config", "config_csv.msgpack")
}

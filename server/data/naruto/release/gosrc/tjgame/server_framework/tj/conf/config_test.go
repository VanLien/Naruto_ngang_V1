package conf

import (
	"testing"
)

type Define struct {
	Name      string
	Addr      string `json:"addr"`      // listen ip or port
	Key       string `json:"key"`       // nsq client id or machine alias name
	Discovery string `json:"discovery"` // python discovery

	NSQLookupD string `json:"nsqlookupd"` // nsq lookup addr(not used now, only one nsqd)
	MainNSQD   string `json:"mainnsqd"`   // only one or standby
}

func Test_loadConfig(t *testing.T) {
	m := LoadDefine("sample", Define{})
	t.Log(m.(Define))
	c := m.(Define)
	t.Log(c.Addr)
}

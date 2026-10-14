package main

import (
	"bytes"
	"encoding/json"
	"io"
	"login/checkin/task"
	"net"
	"testing"
	"time"
	"tjgame/server_framework/tj"
	tjnet "tjgame/server_framework/tj/net"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
)

//type Define struct {
//	name     string
//	Debug    bool   `json:"debug"`
//	Addr     string `json:"addr"`
//	HTTPAddr string `json:"http_addr"`
//	PatchUrl string `json:"patch_url"`
//}

func setupServer() *tj.TCPServerFramework {

	define := Define{
		ContainerOption: service.ContainerOption{
			Name: "test",
			Addr: ":12345",

			NSQLookupd: "http://192.168.1.125:4161/",
			Mainnsqd:   "192.168.1.125:4150",
			ServicesRaw: []json.RawMessage{
				[]byte(`{
				"name": "login.test.1",
				"dependent":[
					"storage.dev.2",
					"game.dev.1",
					"game.dev.2"
				]
			}`),
			},
		},

		HTTPAddr: ":12346",
		PatchUrl: "http://192.168.1.98:8008/pokemon/patch/",
	}
	define.OnAfterUnmarshal(&define)
	//log.Init(define.name, log.INFO)

	serv := tj.NewTCPServerFramework(NewServer(define, "cn"))
	serv.Init(define.Addr)
	go serv.Start()
	return serv
}

func TestServer_Login(t *testing.T) {
	serv := setupServer()
	defer serv.Stop()

	time.Sleep(time.Second)
	t.Log("server ok")

	conn, err := net.Dial("tcp", ":12345")
	if err != nil {
		t.Error(err)
	}

	var data []byte
	task := &task.TaskCheck{
		Name:       "usertest",
		AppVersion: "1.3.0",
		Patch:      1,
		MinPatch:   0,
		Channel:    "none",
		Language:   "cn",
		Tag:        "ttt",
	}
	writer := bytes.NewBuffer(make([]byte, 0))
	{
		data, _ = util.MsgPack(task)
		syn := tjnet.NewPacket(tjnet.WithUrl("/login/check"))
		syn.SetBody(data)
		syn.Write(writer)
		data = writer.Bytes()
	}

	n, err := conn.Write(data)
	if n != len(data) {
		t.Error("no send all")
	}

	//rdata := make([]byte, 20)
	//conn.Read(rdata)
	//t.Log(rdata)

	// read flag
	flagBytes := make([]byte, tjnet.PackageFlagLen)
	_, err = io.ReadFull(conn, flagBytes)
	if err != nil {
		t.Error(err)
	}
	flag := flagBytes[0]

	ack := tjnet.NewPacket(tjnet.WithFlag(flag))
	//p.SetPwd(conn.aesKey)
	err = ack.Read(conn)
	if err != nil {
		t.Error(err)
	}

	mm := map[string]interface{}{}
	util.MsgUnpack(ack.Body(), mm)
	t.Logf("testmm=%#v\n", mm)
}

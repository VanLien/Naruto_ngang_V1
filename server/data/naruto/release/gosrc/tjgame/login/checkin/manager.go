package checkin

import (
	"bytes"
	"net"
	"sync"
	"time"

	"login/checkin/task"
	"tjgame/server_framework/tj/log"
	tjnet "tjgame/server_framework/tj/net"
	"tjgame/server_framework/tj/util"
)

const zombieConnMaxTime = 30 * time.Second

type Manager struct {
	rpc            task.IRPCOwner
	receps         []*receptionist
	closeWg        *sync.WaitGroup
	fullChan       chan net.Conn
	fullTaskData   []byte
	kickTaskData   []byte
	accountRecords sync.Map // map[*tjconn]*Record
}

func (m *Manager) Work(connChan <-chan net.Conn) {
	m.closeWg.Add(len(m.receps) + 1)
	for _, recep := range m.receps {
		go recep.Work(connChan)
	}
	go m.cleanThread()
	log.Infof("%d new conn goroutines be created", len(m.receps))
}

func (m *Manager) OnReceptionistDone() {
	m.closeWg.Done()
}

func (m *Manager) OnNewConnFull(conn net.Conn) {
	m.fullChan <- conn
}

func (m *Manager) StopAndWait() {
	close(m.fullChan)
	for _, recep := range m.receps {
		recep.Stop()
	}
	m.closeWg.Wait()
	log.Info("all new conn goroutines were closed")
}

func (m *Manager) cleanThread() {
	timer := time.NewTimer(zombieConnMaxTime)
	util.SimpleTry(func() {
	FOR:
		for {
			select {
			case conn, ok := <-m.fullChan:
				if !ok || conn == nil {
					break FOR
				}
				conn.Write(m.fullTaskData)
				conn.Close()
			case <-timer.C:
				// clean zombie conn
				timer.Reset(zombieConnMaxTime)
			}
		}
	}, nil)

	timer.Stop()
	m.closeWg.Done()
}

func NewManager(num int, rpc task.IRPCOwner) *Manager {
	m := &Manager{
		rpc:      rpc,
		receps:   make([]*receptionist, num),
		closeWg:  &sync.WaitGroup{},
		fullChan: make(chan net.Conn),
	}
	for i := 0; i < num; i++ {
		m.receps[i] = newReceptionist(m)
	}

	// init full packet data and cache it
	writer := bytes.NewBuffer(make([]byte, 0))
	{
		msg, _ := task.MsgFactory.CreateByUrl("/login/full")
		data, _ := util.MsgPack(msg)
		syn := tjnet.NewPacket()
		syn.SetBody(data)
		syn.Write(writer)
		m.fullTaskData = writer.Bytes()
	}

	writer.Reset()
	{
		msg, _ := task.MsgFactory.CreateByUrl("/login/kick")
		data, _ := util.MsgPack(msg)
		syn := tjnet.NewPacket()
		syn.SetBody(data)
		syn.Write(writer)
		m.kickTaskData = writer.Bytes()
	}

	return m
}

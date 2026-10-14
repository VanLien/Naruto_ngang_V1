package checkin

import (
	"context"
	"net"

	"login/checkin/task"
	"tjgame/server_framework/tj/log"
	tjnet "tjgame/server_framework/tj/net"
	"tjgame/server_framework/tj/util"
)

type receptionist struct {
	manager     *Manager
	connsCtx    context.Context
	connsCancel context.CancelFunc
}

func (r *receptionist) Work(connChan <-chan net.Conn) {
	// TODO: safe run
	for conn := range connChan {
		log.Debug("new conn", conn.RemoteAddr())
		tjconn := tjnet.NewNetConn(conn, r)
		tjconn.Start()
		r.manager.accountRecords.Store(tjconn, task.NewRecord(tjconn, r.manager.rpc))
	}
	r.manager.OnReceptionistDone()
}

func (r *receptionist) Stop() {
	r.connsCancel() // meaningless now, only for adapt IConnHandle
}

// IConnHandle
func (r *receptionist) ConnDone(conn *tjnet.Conn) <-chan struct{} {
	return r.connsCtx.Done()
}

func (r *receptionist) OnConnClose(conn *tjnet.Conn) {
	r.manager.accountRecords.Delete(conn)
}

func (r *receptionist) OnConnPacket(syn *tjnet.Packet, conn *tjnet.Conn) {
	util.SimpleTry(func() {

		var record *task.Record
		if v, ok := r.manager.accountRecords.Load(conn); ok {
			record = v.(*task.Record)
		} else {
			log.Warning("no record in manager")
			conn.Close()
			return
		}

		t, err := task.Factory.CreateByUrl(syn.Url())
		if err != nil {
			log.Warning(err, syn.Url())
			conn.Close()
			return
		}

		//mm := map[string]interface{}{}
		//util.MsgUnpack(syn.Body(), mm)
		//log.Debugf("testmm=%#v\n", mm)

		if err := util.MsgUnpack(syn.Body(), t); err != nil {
			log.Warningf("OnConnPacket request MsgUnpack err %v", err)
			conn.Close()
			return
		}
		if v, ok := t.(*task.TaskCheck); ok {
			v.IP = conn.RemoteAddr()
		}

		log.Debugf("%p %#v\n", t, t)

		if resp := t.Run(record); resp != nil {
			log.Debugf("%p %#v\n", resp, resp)
			ack := tjnet.NewAckUrlPacket(syn)
			if data, err := util.MsgPack(resp); err == nil {
				ack.SetBody(data)
				conn.SendPacket(ack)
			} else {
				log.Warningf("OnConnPacket response MsgPack err %v", err)
			}
		}

	}, func(err interface{}) {
		log.Warningf("OnConnPacket err %s", err)
		conn.Close()
	})
}

func newReceptionist(manager *Manager) *receptionist {
	r := &receptionist{
		manager: manager,
	}
	r.connsCtx, r.connsCancel = context.WithCancel(context.Background())
	return r
}

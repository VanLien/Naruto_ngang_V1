package net

import (
	"bufio"
	"context"
	"io"
	"net"
	"sync"
	"time"

	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
)

type IConnHandle interface {
	ConnDone(*Conn) <-chan struct{}
	OnConnClose(*Conn)
	OnConnPacket(*Packet, *Conn)
}

type Conn struct {
	handle        IConnHandle
	heartLastTime int64

	//sendChan   chan *Packet
	//handleChan chan *Packet
	sendChan   *util.ChannelQueue
	handleChan *util.ChannelQueue

	rawConn    net.Conn
	readWriter *bufio.ReadWriter
	running    bool
	aesKey     string
	nextAesKey string

	once   sync.Once
	mu     sync.Mutex
	ctx    context.Context
	cancel context.CancelFunc
}

func NewNetConn(rawConn net.Conn, handle IConnHandle) *Conn {
	conn := &Conn{
		rawConn:       rawConn,
		handle:        handle,
		heartLastTime: time.Now().Unix(),
	}
	reader := bufio.NewReader(rawConn)
	writer := bufio.NewWriter(rawConn)
	conn.readWriter = bufio.NewReadWriter(reader, writer)
	conn.running = false

	//conn.sendChan = make(chan *Packet, 100)
	//conn.handleChan = make(chan *Packet, 100)
	conn.sendChan = util.NewChannelQueueWithCapacity(100)
	conn.handleChan = util.NewChannelQueue()

	conn.ctx, conn.cancel = context.WithCancel(context.Background())

	return conn
}

func (conn *Conn) RemoteAddr() net.Addr {
	return conn.rawConn.RemoteAddr()
}

func (conn *Conn) SetAESKey(key string) {
	conn.aesKey = key
}

// new key be set util one send
func (conn *Conn) SetAESKeyInNext(key string) {
	conn.nextAesKey = key
}

func (conn *Conn) SetHandle(handle IConnHandle) {
	conn.handle = handle
}

func (conn *Conn) Start() bool {
	log.Debugf("conn start, <%v -> %v>", conn.rawConn.LocalAddr(), conn.rawConn.RemoteAddr())
	conn.running = true
	go conn.recvLoop()
	go conn.sendLoop()
	go conn.handleLoop()
	return true
}

func (conn *Conn) Close() {
	conn.cancel()
}

func (conn *Conn) Running() bool {
	return conn.running
}

func (conn *Conn) recvLoop() {
	for conn.running {
		log.Debugf("conn %s start read packet", conn.RemoteAddr())
		packet, err := conn.GetPacket()
		if err != nil {
			if err != io.EOF {
				log.Warning(err)
			}
			conn.running = false
		} else {
			if packet.GetFlag(HeartSynBit) {
				log.Debugf("recvLoop conn %s heart\n", conn.RemoteAddr())
			} else {
				log.Debugf("recvLoop conn %s syn %d url %s\n", conn.RemoteAddr(), packet.SynID(), packet.Url())
			}
			//conn.handleChan <- packet
			conn.handleChan.PushBack(packet)
		}
	}
	//close(conn.handleChan)
	conn.handleChan.Close()
	log.Debugf("conn %s recvLoop over", conn.RemoteAddr())
}

func (conn *Conn) sendLoop() {
	for p := range conn.sendChan.C {
		packet := p.(*Packet)
		err := packet.Write(conn.readWriter)
		if err != nil {
			log.Errorf("send loop Error %s\n", err.Error())
		}
		err = conn.readWriter.Flush()
		if err != nil {
			log.Errorf("flush Error %s\n", err.Error())
		}
	}
	conn.closeRawConn()
	log.Debugf("conn %s sendLoop over", conn.RemoteAddr())
}

func (conn *Conn) handleLoop() {
	addr := conn.RemoteAddr()
	for conn.running {
		select {
		case <-conn.ctx.Done():
			conn.running = false
		case <-conn.handle.ConnDone(conn):
			log.Debug("handleLoop receiving cancel signal from server")
			conn.running = false
		case p, ok := <-conn.handleChan.C:
			if ok {
				packet := p.(*Packet)
				if packet.GetFlag(HeartSynBit) {
					conn.heartLastTime = time.Now().Unix()
				} else {
					conn.handle.OnConnPacket(packet, conn)
				}
			} else {
				log.Debugf("conn %s handleChan closed", addr)
			}
		}
	}
	conn.close()
	log.Debugf("conn %s handleLoop over", addr)
}

func (conn *Conn) close() {
	conn.once.Do(func() {
		log.Debugf("conn close gracefully, <%v -> %v>", conn.rawConn.LocalAddr(), conn.rawConn.RemoteAddr())

		conn.running = false

		// close all channel
		//close(conn.sendChan)
		conn.sendChan.Close()

		// tell server, I'm done.
		conn.handle.OnConnClose(conn)
	})
}

func (conn *Conn) closeRawConn() {
	// close net.Conn
	//if tc, ok := conn.rawConn.(*net.TCPConn); ok {
	//	tc.SetLinger(0)
	//}
	err := conn.rawConn.Close()
	log.Debugf("close socket over, %v", err)
}

func (conn *Conn) GetPacket() (*Packet, error) {
	//log.Debug("start read package")
	var err error

	// read flag
	flagBytes := make([]byte, PackageFlagLen)
	_, err = io.ReadFull(conn.readWriter, flagBytes)
	if err != nil {
		return nil, err
	}
	flag := flagBytes[0]
	//log.Debugf("flag : %b\n", flag)

	p := NewPacket(WithFlag(flag))
	p.SetPwd(conn.aesKey)
	err = p.Read(conn.readWriter)
	if err != nil {
		return nil, err
	}
	return p, nil
}

func (conn *Conn) SendPacket(packet *Packet) {
	if conn.running {
		select {
		case <-conn.ctx.Done():
			return
		case <-conn.handle.ConnDone(conn):
			return
		default:
			packet.SetPwd(conn.aesKey)
			if conn.nextAesKey != "" {
				conn.aesKey = conn.nextAesKey
				conn.nextAesKey = ""
			}
			//select {
			//case conn.sendChan <- packet:
			//	return
			//default:
			//	log.Warningf("sendChan full on send to %s", conn.RemoteAddr())
			//	conn.close()
			//}
			if !conn.sendChan.PushBack(packet) {
				log.Warningf("sendChan full on send to %s", conn.RemoteAddr())
				conn.close()
			}
		}
	}
}

func (conn *Conn) IsAlive(dur time.Duration) bool {
	now := time.Now().Unix()
	return now-conn.heartLastTime < int64(dur.Seconds())
}

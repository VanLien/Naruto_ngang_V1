package net

import (
	"context"
	"net"
	"sync"

	"tjgame/server_framework/tj/log"
)

type Node struct {
	ctx    context.Context
	cancel context.CancelFunc
	wg     sync.WaitGroup
	mu     sync.Mutex

	address    string
	l          net.Listener
	running    bool
	handleChan chan connPacket

	handlePacketFunc HandleFunc
	handleStreamFunc HandleStreamFunc
}

type connPacket struct {
	*Conn
	*Packet
}

func NewNode(address string) *Node {
	n := &Node{}
	n.ctx, n.cancel = context.WithCancel(context.Background())
	n.address = address
	n.running = false
	n.handleChan = make(chan connPacket)
	return n
}

func (n *Node) Start() error {
	var err error
	n.l, err = net.Listen("tcp", n.address)
	if err != nil {
		log.Panicf("Error listening:", err)
		return err
	}
	defer n.l.Close()
	log.Info("Listening on " + n.Address())
	n.running = true

	go n.runLoop()
	n.wg.Add(1)

	for n.running {
		rawConn, err := n.l.Accept()
		if err != nil {
			log.Warningf("accept error %v", err)
			continue
		}
		log.Debugf("Received connection %s -> %s \n", rawConn.RemoteAddr(), rawConn.LocalAddr())

		conn := NewNetConn(rawConn, n)
		if n.handleStreamFunc != nil {
			n.handleStreamFunc(conn)
		}
		n.wg.Add(1)
		go func() {
			conn.Start()
		}()
	}
	return nil
}

func (n *Node) Stop() {
	n.running = false
	n.l.Close()

	n.mu.Lock()
	n.cancel()
	n.mu.Unlock()

	close(n.handleChan)

	n.wg.Wait()

	log.Info("server stopped gracefully, bye.")
}

func (n *Node) IsRunning() bool {
	return n.running
}

func (n *Node) Address() string {
	return n.l.Addr().String()
}

type HandleFunc func(packet *Packet, conn *Conn)

func (n *Node) SetHandlePacketFunc(f HandleFunc) {
	n.handlePacketFunc = f
}

type HandleStreamFunc func(conn *Conn)

func (n *Node) SetHandleStreamFunc(f HandleStreamFunc) {
	n.handleStreamFunc = f
}

func (n *Node) runLoop() {
	defer n.wg.Done()

	for n.running {
		select {
		case <-n.ctx.Done():
			log.Debug("receiving cancel signal from server, runLoop")
			return
		case cp, ok := <-n.handleChan:
			if !ok {
				return
			}
			if n.handlePacketFunc != nil {
				n.handlePacketFunc(cp.Packet, cp.Conn)
			}
		}
	}
}

// IConnHandle
func (n *Node) ConnDone(*Conn) <-chan struct{} {
	return n.ctx.Done()
}

func (n *Node) OnConnClose(*Conn) {
	n.wg.Done()
}

func (n *Node) OnConnPacket(p *Packet, c *Conn) {
	n.handleChan <- connPacket{c, p}
}

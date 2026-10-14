package rudp

import (
	"errors"
	"io"
	"math/rand"
	"net"
	"sync"
	"sync/atomic"
	"time"

	"tjgame/server_framework/tj/log"
)

const (
	MaxIdleTimeout          = time.Second * 120
	ConnectionDrainDuration = time.Minute * 10
)

var (
	ErrConnectionStale  = errors.New("connection stale")
	ErrConnectionIdle   = errors.New("connection idle too long")
	ErrConnectionClosed = errors.New("connection closed")
)

type Connection struct {
	conn    *net.UDPConn
	ownConn bool
	rudp    *Rudp
	l       *Listener

	mu sync.Mutex

	// recvbuf turns packages into stream
	recvbuf []byte
	bufptr  []byte

	readNotify chan struct{}
	close      chan struct{}
	closed     int32

	writeNotify chan struct{}

	remote *net.UDPAddr

	alivetime time.Time
}

func (c *Connection) Read(b []byte) (int, error) {
	for {
		if len(c.bufptr) > 0 { // copy from buffer into b
			n := copy(b, c.bufptr)
			c.bufptr = c.bufptr[n:]
			SnmpBytesReceived(uint64(n))
			return n, nil
		}
		// read from rudp
		if len(c.recvbuf) > 0 {
			c.recvbuf = make([]byte, 0, MaxPackage)
		}
		size := 0
		for {
			buf := make([]byte, MaxPackage)
			c.mu.Lock()
			n, err := c.rudp.Read(buf)
			c.mu.Unlock()
			if err != nil {
				return 0, err
			}
			if n == 0 {
				break
			}
			c.recvbuf = append(c.recvbuf, buf[:n]...)
			size += n
		}
		if size > 0 {
			c.recvbuf = c.recvbuf[:size]
			n := copy(b, c.recvbuf) // copy in b
			c.bufptr = c.recvbuf[n:]
			SnmpBytesReceived(uint64(n))
			return n, nil
		}
		select {
		case <-c.readNotify:

		}
	}
}

func (c *Connection) Write(b []byte) (int, error) {
	if atomic.LoadInt32(&c.closed) == 1 {
		return 0, ErrConnectionClosed
	}
	var n int
	var err error
	mss := GeneralPackage - MaxMsgHead
	c.mu.Lock()
	defer c.mu.Unlock()

	for {
		if len(b) <= mss {
			var nn int
			nn, err = c.rudp.Write(b)
			n += nn
			break
		} else {
			var nn int
			nn, err = c.rudp.Write(b[:mss])
			n += nn
			if err != nil {
				break
			}
			b = b[mss:]
		}
	}
	SnmpBytesSend(uint64(n))
	c.notifyWrite()
	return n, err
}

func (c *Connection) Close() error {
	if atomic.CompareAndSwapInt32(&c.closed, 0, 1) {
		close(c.close)
	}
	return nil
}

func (c *Connection) LocalAddr() net.Addr {
	return c.conn.LocalAddr()
}

func (c *Connection) RemoteAddr() net.Addr {
	return c.remote
}

func (c *Connection) SetDeadline(t time.Time) error {
	return nil
}

func (c *Connection) SetReadDeadline(t time.Time) error {
	return nil
}

func (c *Connection) SetWriteDeadline(t time.Time) error {
	return nil
}

// send package from rudp
func (c *Connection) output(b []byte) {
	drop := rand.Int31n(100)
	if false && drop > 50 {
		log.Warningf("connection %d drop length %d", c.rudp.id, len(b))
		return
	}

	var n int
	var err error
	if c.ownConn {
		n, err = c.conn.Write(b)
	} else {
		n, err = c.conn.WriteToUDP(b, c.remote)
		
	}
	if err != nil {
		log.Debug("session output error %v", err)
	}
	log.Debugf("connection %d send %d, %s -> %s, %v", c.rudp.id, n, c.conn.LocalAddr(), c.remote, err)
	SnmpOutBytes(uint64(n))
	SnmpOutPackages(1)
}

func (c *Connection) rudpInput(b []byte) {
	log.Debugf("connection %d receive %d, %s -> %s", c.rudp.id, len(b), c.remote, c.conn.LocalAddr())
	c.mu.Lock()
	defer c.mu.Unlock()

	if c.rudp.Input(b) {
		c.alivetime = time.Now()
	}
	c.notifyRead()
	SnmpInBytes(uint64(len(b)))
	SnmpInPackages(1)
}

func (c *Connection) notifyRead() {
	select {
	case <-c.close:
		return
	default:
	}

	select {
	case <-c.close:
		return
	case c.readNotify <- struct{}{}:
	default:
	}
}

func (c *Connection) notifyWrite() {
	select {
	case <-c.close:
		return
	default:
	}

	select {
	case <-c.close:
		return
	case c.writeNotify <- struct{}{}:
	default:
	}
}

func (c *Connection) closeLocal(err error) {
	if err != nil {
		log.Warningf("closing connection %d with error %s", c.rudp.id, err)
	} else {
		log.Infof("closing connection %d", c.rudp.id)
	}

	c.rudp.corrupt.Store(ErrorEof)
	close(c.readNotify)

	if c.l != nil { // belong to listener
		c.l.closeSession(c.remote)
	} else if c.ownConn { // client socket close
		c.conn.Close()
	}

}

// the read loop for a client session
func (c *Connection) readLoop() {
	buff := make([]byte, MaxPackage)
L:
	for {
		select {
		case <-c.close:
			log.Debugf("connection %d readLoop exit", c.rudp.id)
			break L
		default:

		}

		n, err := c.conn.Read(buff)
		//log.Infof("rudp %d readLoop %d, %v, %s", c.rudp.id, n, err, c.remote)
		if err != nil {
			log.Infof("read error", err)
			return
		}
		c.rudpInput(buff[:n])
	}
}

func (c *Connection) loop() {
	if c.l == nil { // it's a client connection
		go c.readLoop()
	}

	var err error
	t := time.NewTicker(time.Millisecond * 1)
	defer t.Stop()

	exit := false

	for {
		select {
		case <-c.close:
			exit = true
		case <-t.C:
		case <-c.writeNotify:
		}

		c.mu.Lock()
		packages, allsend, flag := c.rudp.Update()
		c.mu.Unlock()
		for _, p := range packages {
			c.output(p)
		}

		if exit && allsend {
			log.Debugf("connection %d loop exit", c.rudp.id)
			break
		}

		corrupt := c.rudp.corrupt
		if corrupt.Load() == ErrorCorrupt {
			log.Warningf("connection %d is stale, closing...", c.rudp.id)
			err = ErrConnectionStale
			break
		}
		if corrupt.Load() != ErrorNil {
			err = corrupt.Error()
			log.Warningf("connection %d %v, closing...", c.rudp.id, err)
			break
		}

		now := time.Now()
		if flag {
			c.alivetime = now
		} else {
			if now.Sub(c.alivetime) > MaxIdleTimeout {
				log.Warningf("connection %d is idle %v, closing...", c.rudp.id, now.Sub(c.alivetime))
				err = ErrConnectionIdle
				break
			}
		}
	}
	if err == nil {
		c.output(terminate())
	} else {
		c.output(corrupt())
	}
	c.closeLocal(err)
}

func newConnection(id int, conn *net.UDPConn, l *Listener, ownConn bool, remote *net.UDPAddr) *Connection {
	s := &Connection{
		conn:      conn,
		ownConn:   ownConn,
		l:         l,
		rudp:      NewRudp(id),
		remote:    remote,
		alivetime: time.Now(),
	}
	s.recvbuf = make([]byte, 0, MaxPackage)
	s.readNotify = make(chan struct{}, 1)
	s.writeNotify = make(chan struct{}, 1)
	s.close = make(chan struct{})
	go s.loop()
	return s
}

type Listener struct {
	conn    *net.UDPConn
	ownConn bool

	connections    map[string]*Connection
	draining       map[string]time.Time // all closed endpoint
	connectionLock sync.Mutex

	chAccept     chan *Connection
	chConnClosed chan *net.UDPAddr

	socketReadError chan error

	closed     chan struct{}
	closedOnce sync.Once
}

func (l *Listener) AcceptRudp() (*Connection, error) {
	select {
	case s := <-l.chAccept:
		return s, nil
	case e := <-l.socketReadError:
		return nil, e
	case <-l.closed:
		return nil, io.ErrClosedPipe
	}
}

func (l *Listener) Close() error {
	var once bool
	l.closedOnce.Do(func() {
		close(l.closed)
		once = true
	})
	if !once {
		return io.ErrClosedPipe
	}
	if l.ownConn {
		// TODO: remote all session
		return l.conn.Close()
	}
	return nil
}

func (l *Listener) LocalAddr() net.Addr {
	return l.conn.LocalAddr()
}

func (l *Listener) closeSession(addr *net.UDPAddr) bool {
	l.connectionLock.Lock()
	defer l.connectionLock.Unlock()

	if _, ok := l.connections[addr.String()]; ok {
		delete(l.connections, addr.String())
		l.draining[addr.String()] = time.Now()
	}
	return false
}

func (l *Listener) isAlreadyClosed(addr *net.UDPAddr) bool {
	l.connectionLock.Lock()
	defer l.connectionLock.Unlock()
	_, ok := l.draining[addr.String()]
	return ok
}

var id int

// monitor incoming data for all connections of server
func (l *Listener) monitor() {
	buf := make([]byte, MaxPackage)
	for {
		n, addr, err := l.conn.ReadFromUDP(buf)
		//log.Debug("monitor", n, addr, err)
		if err != nil {
			l.socketReadError <- err
			// TODO: close ?
			return
		}

		l.connectionLock.Lock()
		session, ok := l.connections[addr.String()]
		l.connectionLock.Unlock()
		if !ok {
			// is already closed endpoint
			if l.isAlreadyClosed(addr) {
				l.conn.WriteToUDP(terminate(), addr)
				log.Warningf("connection %s already closed", addr.String())
				continue
			}

			id++
			session = newConnection(id, l.conn, l, false, addr)
			l.connectionLock.Lock()
			l.connections[addr.String()] = session
			l.connectionLock.Unlock()
			l.chAccept <- session
		}
		session.rudpInput(buf[:n])
	}
}

func (l *Listener) dropDraining() {
	l.connectionLock.Lock()
	defer l.connectionLock.Unlock()
	now := time.Now()
	draining := make(map[string]time.Time)
	for addr, t := range l.draining {
		if now.Sub(t) < ConnectionDrainDuration {
			draining[addr] = t
		}
	}
	num := len(l.draining) - len(draining)
	l.draining = draining
	log.Debugf("dropDraining %d", num)
}

func newListener(conn *net.UDPConn) *Listener {
	l := &Listener{
		conn:            conn,
		ownConn:         true,
		connections:     make(map[string]*Connection),
		draining:        make(map[string]time.Time),
		chAccept:        make(chan *Connection, 1024),
		chConnClosed:    make(chan *net.UDPAddr),
		socketReadError: make(chan error),
		closed:          make(chan struct{}),
	}
	go l.monitor()

	go func() {
		timer := time.NewTimer(time.Minute * 5)
		defer timer.Stop()
	L:
		for {
			select {
			case <-l.closed:
				break L
			case <-timer.C:
				l.dropDraining()
			}
		}
	}()

	return l
}

func Dial(address string) (*Connection, error) {
	addr, err := net.ResolveUDPAddr("udp", address)
	if err != nil {
		return nil, err
	}
	conn, err := net.DialUDP("udp", nil, addr)
	if err != nil {
		return nil, err
	}
	id++
	session := newConnection(id, conn, nil, true, addr)
	return session, nil
}

func Listen(address string) (*Listener, error) {
	addr, err := net.ResolveUDPAddr("udp", address)
	if err != nil {
		return nil, err
	}
	conn, err := net.ListenUDP("udp", addr)
	if err != nil {
		return nil, err
	}
	l := newListener(conn)
	log.Infof("Listen on %s ...", conn.LocalAddr())
	return l, nil
}

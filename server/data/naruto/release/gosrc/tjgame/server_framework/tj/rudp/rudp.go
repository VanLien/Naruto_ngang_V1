package rudp

import (
	"bytes"
	"encoding/binary"
	"errors"
	"io"
	"sort"
	"sync/atomic"
	"time"

	"tjgame/server_framework/tj/log"
)

const (
	TypePing = iota
	TypeEof
	TypeCorrupt
	TypeRequest // +2
	TypeMissing // +2
	TypeAck     // +2(id) // less then id package confirmed delivery
	TypeNormal  // +2(id) + data
)

const (
	MaxMsgHead = 4
	//GENERAL_PACKAGE = 576 - 60 - 8
	GeneralPackage = 512 // 在国内最好udp包大小最好不超过576
	MaxPackage     = 0xffff - TypeNormal
	MaxRtoTimeout  = time.Second * 120
)

const (
	ErrorNil int32 = iota
	ErrorEof
	ErrorRemoteEof
	ErrorCorrupt
	ErrorMsgSize
)

var (
	ErrMsgSizeMax = errors.New("msg size max")
	ErrCorrupt    = errors.New("corrupt")
)

type Error struct {
	v int32
}

func (e *Error) Load() int32 {
	return atomic.LoadInt32(&e.v)
}

func (e *Error) Store(n int32) {
	atomic.StoreInt32(&e.v, n)
}

func (e *Error) Error() error {
	switch e.Load() {
	case ErrorEof:
		return io.EOF
	case ErrorRemoteEof:
		return io.ErrClosedPipe
	case ErrorCorrupt:
		return ErrCorrupt
	case ErrorMsgSize:
		return errors.New("recive msg size error")
	default:
		return nil
	}
}

type Rudp struct {
	id int

	sendQueue   messageQueue
	recvQueue   messageQueue
	sendHistory messageQueue
	sendAgain   []int

	corrupt Error
	sendId  uint16
	recvMin int
	recvMax int
	lastAck int

	// timestamp
	current  time.Time
	lastSend time.Time
	lastRecv time.Time

	// configure
	expired   time.Duration
	heartbeat time.Duration
	ackDelay  time.Duration

	rto time.Duration // retransmission timeout
}

func (r *Rudp) Write(b []byte) (int, error) {
	if err := r.corrupt.Load(); err != ErrorNil {
		return 0, r.corrupt.Error()
	}
	if len(b) == 0 {
		return 0, nil
	}
	if len(b) > MaxPackage {
		return 0, ErrMsgSizeMax
	}
	m := &message{
		id:   int(r.sendId),
		time: r.current,
	}
	m.buffer.Write(b)
	r.sendId++
	r.sendQueue.push(m)
	return len(b), nil
}

func (r *Rudp) Read(b []byte) (int, error) {
	if err := r.corrupt.Load(); err != ErrorNil {
		return 0, r.corrupt.Error()
	}
	m := r.recvQueue.pop(r.recvMin)
	if m == nil {
		return 0, nil
	}
	r.recvMin++
	copy(b, m.buffer.Bytes())
	return m.buffer.Len(), nil
}

func (r *Rudp) Update() ([][]byte, bool, bool) {
	if r.corrupt.Load() != ErrorNil {
		return nil, false, false
	}
	r.current = time.Now()

	if r.current.Sub(r.lastRecv) > r.heartbeat {
		r.corrupt.Store(ErrorCorrupt)
		return nil, false, false
	}

	var flag bool
	packages := make([][]byte, 0, 16)
	// 1. request missing
	packages = r.requestMissing(packages)
	// 2. reply request
	packages = r.replyRequest(packages)
	// 3. reply ack
	packages = r.replayAck(packages)
	// 4. retransmission
	packages = r.retransmission(packages)
	// 5. send message
	packages, flag = r.sendMessage(packages)

	// 6. send hearbeat
	if len(packages) == 0 {
		if r.current.Sub(r.lastSend) > r.heartbeat/2 {
			packages = r.sendHeartbeat(packages)
		}
	}
	if len(packages) > 0 {
		r.lastSend = r.current
		SnmpOutSegments(uint64(len(packages)))
	}
	return packages, r.sendHistory.head == nil, flag
}

func (r *Rudp) Input(b []byte) (flag bool) {
	//log.Debugf("input %v", b)
	r.lastRecv = r.current
	sz := len(b)
	for sz > 0 {
		tag := binary.BigEndian.Uint16(b[:2])
		b = b[2:]
		sz -= 2

		SnmpInSegments(1)
		switch tag {
		case TypePing:
			// TODO:
		case TypeEof:
			r.corrupt.Store(ErrorEof)
			return
		case TypeCorrupt:
			r.corrupt.Store(ErrorRemoteEof)
			return
		case TypeRequest, TypeMissing:
			if sz < 2 {
				r.corrupt.Store(ErrorMsgSize)
				return
			}
			id := getID(b[:2], r.recvMax)
			if tag == TypeRequest {
				r.addRequest(id) // C -> P
			} else {
				r.addMissing(id) // P -> C
			}
			b = b[2:]
			sz -= 2
		case TypeAck:
			if sz < 2 {
				r.corrupt.Store(ErrorMsgSize)
				return
			}
			id := getID(b[:2], r.recvMax)
			log.Debugf("rudp %d receive ack %d", r.id, id)
			r.clearSendHistory(id) // less then id package confirmed delivery
			b = b[2:]
			sz -= 2
		default:
			length := tag - TypeNormal
			if sz < int(length+2) {
				r.corrupt.Store(ErrorMsgSize)
				return
			}
			id := getID(b[:2], r.recvMax)
			b = b[2:]
			sz -= 2
			log.Infof("rudp %d input id %d, length %d", r.id, id, length)
			if r.insertRecvQueue(id, b[:length]) {
				flag = true
			}
			b = b[length:]
			sz -= int(length)
		}
	}
	return
}

func (r *Rudp) clearSendHistory(id int) {
	num := 0
	m := r.sendHistory.head
	for m != nil {
		if m.id >= id {
			break
		}
		m = m.next
		num += 1
	}
	r.sendHistory.head = m
	r.sendHistory.num -= num
	if m == nil {
		r.sendHistory.tail = m
	}
}

func (r *Rudp) requestMissing(packages [][]byte) [][]byte {
	id := r.recvMin
	m := r.recvQueue.head
	for m != nil {
		if m.id < id {
			panic("error")
		}
		if m.id > id {
			log.Debugf("start request missing [%d, %d)", id, m.id)
			for i := id; i < m.id; i++ {
				log.Debugf("request missing %d", i)
				packages = append(packages, request(i))
			}
		}
		id = m.id + 1
		m = m.next
	}
	return packages
}

func (r *Rudp) replayAck(packages [][]byte) [][]byte {
	id := r.recvMin
	m := r.recvQueue.head
	for m != nil {
		if m.id < id {
			panic("error")
		}
		if m.id > id {
			break
		}
		id = m.id + 1
		m = m.next
	}
	if id == r.lastAck {
		return packages
	}
	log.Debugf("rudp %d send ack %d", r.id, id)
	r.lastAck = id
	packages = append(packages, ack(id))
	return packages
}

func (r *Rudp) replyRequest(packages [][]byte) [][]byte {
	sort.Ints(r.sendAgain)
	history := r.sendHistory.head
	for _, id := range r.sendAgain {
		for {
			if history == nil || id < history.id {
				packages = append(packages, missing(id))
				break
			} else if id == history.id {
				packages = append(packages, history.pack())
				break
			}
			history = history.next
		}
	}
	r.sendAgain = make([]int, 0, 16)
	return packages
}

func (r *Rudp) retransmission(packages [][]byte) [][]byte {
	m := r.sendHistory.head
	for m != nil {
		rto := r.rto * time.Duration(m.retries+1)
		if rto > MaxRtoTimeout {
			rto = MaxRtoTimeout
		}
		if r.current.Sub(m.time) > rto {
			m.retries += 1
			m.time = r.current
			packages = append(packages, m.pack())
			SnmpRetransSegements(1)
		}
		m = m.next
	}
	return packages
}

func (r *Rudp) sendMessage(packages [][]byte) ([][]byte, bool) {
	flag := false
	m := r.sendQueue.head
	for m != nil {
		//log.Debugf("rudp %d send id %d, length %d", r.id, m.id, m.buffer.Len())
		packages = append(packages, m.pack())
		m = m.next
		flag = true
	}
	if r.sendQueue.head != nil {
		if r.sendHistory.tail == nil {
			r.sendHistory = r.sendQueue
		} else {
			r.sendHistory.tail.next = r.sendQueue.head
			r.sendHistory.tail = r.sendQueue.tail
			r.sendHistory.num += r.sendQueue.num
		}
		r.sendQueue.head = nil
		r.sendQueue.tail = nil
		r.sendQueue.num = 0
	}
	return packages, flag
}

func (r *Rudp) sendHeartbeat(packages [][]byte) [][]byte {
	packages = append(packages, keepalive())
	return packages
}

func (r *Rudp) addRequest(id int) {
	log.Debugf("addRequest %d", id)
	r.sendAgain = append(r.sendAgain, id)
}

func (r *Rudp) addMissing(id int) {
	r.insertRecvQueue(id, nil)
	SnmpLostSegments(1)
}

// insert into recvQueue
func (r *Rudp) insertRecvQueue(id int, b []byte) bool {
	if id < r.recvMin {
		log.Infof("already recv %d, length %d", id, len(b))
		SnmpRepeatSegment(1)
		return false
	}
	m := &message{
		id: id,
	}
	m.buffer.Write(b)
	if id > r.recvMax || r.recvQueue.head == nil {
		r.recvQueue.push(m)
		r.recvMax = id
	} else {
		r.recvQueue.insert(m)
	}
	return true
}

func packRequest(id int, tag int) []byte {
	var buffer bytes.Buffer
	fillHeader(&buffer, id, tag)
	return buffer.Bytes()
}

// keepalive package
func keepalive() []byte {
	data := make([]byte, 2)
	binary.BigEndian.PutUint16(data, TypePing)
	return data
}

// terminate package
func terminate() []byte {
	data := make([]byte, 2)
	binary.BigEndian.PutUint16(data, TypeEof)
	return data
}

// corrupt package
func corrupt() []byte {
	data := make([]byte, 2)
	binary.BigEndian.PutUint16(data, TypeCorrupt)
	return data
}

// ack package
func ack(id int) []byte {
	return packRequest(id, TypeAck)
}

// request package
func request(id int) []byte {
	return packRequest(id, TypeRequest)
}

// missing package
func missing(id int) []byte {
	return packRequest(id, TypeMissing)
}

// [tag(length) (2 byte) id(2 byte)][data(len)]

func fillHeader(buffer *bytes.Buffer, id int, length int) {
	data := make([]byte, 4)
	binary.BigEndian.PutUint16(data[:2], uint16(length))
	binary.BigEndian.PutUint16(data[2:], uint16(id))
	buffer.Write(data)
}

func getID(b []byte, max int) int {
	id := int(binary.BigEndian.Uint16(b))
	// 每个逻辑包都有一个 16bit 的序号，从 0 开始编码，如果超过 64K 则回到 0 。
	// 通讯过程中，如果收到一个数据包和之前的数据包 id 相差正负 32K ，则做一下更合理的调整。
	// 例如，如果之前收到的序号为 2 ，而下一个包是 FFFF ，则认为是 2 这个序号的前三个，而不是向后一个很远的序号。
	// |id-max| > 32k
	if id > max+0x8000 {
		id -= 0x10000
	} else if id < max-0x8000 {
		id += 0x10000
	}
	return id
}

type message struct {
	id      int
	buffer  bytes.Buffer
	time    time.Time
	retries int
	next    *message
}

func (m *message) pack() []byte {
	var buffer bytes.Buffer
	fillHeader(&buffer, m.id, m.buffer.Len()+TypeNormal)
	buffer.Write(m.buffer.Bytes())
	return buffer.Bytes()
}

type messageQueue struct {
	head *message
	tail *message
	num  int
}

func (q *messageQueue) pop(id int) *message {
	if q.head == nil {
		return nil
	}
	m := q.head
	if m.id != id {
		return nil
	}
	q.head = m.next
	m.next = nil
	if q.head == nil {
		q.tail = nil
	}
	q.num--
	return m
}

func (q *messageQueue) push(m *message) {
	if q.tail == nil {
		q.head = m
		q.tail = m
	} else {
		q.tail.next = m
		q.tail = m
	}
	q.num++
}

func (q *messageQueue) insert(m *message) {
	cur := q.head
	last := &q.head
	for cur != nil {
		if cur.id == m.id {
			return
		}
		if cur.id > m.id {
			// insert here
			m.next = cur
			*last = m
			q.num++
			return
		}
		last = &cur.next
		cur = cur.next
	}
}

func NewRudp(id int) *Rudp {
	rudp := &Rudp{
		id:        id,
		sendAgain: make([]int, 0, 16),
		current:   time.Now(),
		expired:   10 * time.Second,
		heartbeat: 20 * time.Second,
	}
	rudp.lastSend = rudp.current
	rudp.lastRecv = rudp.current
	rudp.rto = 500 * time.Millisecond
	return rudp
}

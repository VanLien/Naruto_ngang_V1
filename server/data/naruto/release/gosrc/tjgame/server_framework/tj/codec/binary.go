package codec

import (
	"bufio"
	"bytes"
	"encoding/binary"
	"io"
	"reflect"
)

const binaryHeadSize = 8
const binaryMaxSize = 1024 * 1024

type BinaryProtocol struct {
}

func (p *BinaryProtocol) NewCodec(rwc io.ReadWriteCloser) (Codec, error) {
	c := &binaryCodec{
		p:    p,
		rwc:  rwc,
		buf:  bytes.NewBuffer(make([]byte, 0, 64)),
		wBuf: bufio.NewWriter(rwc),
	}
	return c, nil
}

func NewBinaryProtocol() *BinaryProtocol {
	return &BinaryProtocol{}
}

type binaryCodec struct {
	p    *BinaryProtocol
	rwc  io.ReadWriteCloser
	buf  *bytes.Buffer
	wBuf *bufio.Writer
	head binaryHead
}

type binaryHead struct {
	MsgID int32
	Size  uint32
}

func (c *binaryCodec) Recv() (int32, interface{}, error) {
	head := &binaryHead{}
	if err := binary.Read(c.rwc, binary.LittleEndian, head); err != nil {
		return 0, nil, err
	}
	if head.Size > binaryMaxSize {
		return 0, nil, TooLargeMsg
	}
	rt, ok := c.p.ID2Type[head.MsgID]
	if !ok {
		return 0, nil, NoSuchMsgType
	}
	msg := reflect.New(rt).Interface()
	if err := binary.Read(c.rwc, binary.LittleEndian, msg); err != nil {
		return 0, nil, err
	}
	return head.MsgID, msg, nil
}

func (c *binaryCodec) Send(msg interface{}) error {
	rt := reflect.TypeOf(msg)
	if rt.Kind() == reflect.Ptr {
		rt = rt.Elem()
	}
	msgID, ok := c.p.Type2ID[rt]
	if !ok {
		return NoSuchMsgType
	}

	c.buf.Reset()
	if err := binary.Write(c.buf, binary.LittleEndian, msg); err != nil {
		return err
	}
	body := c.buf.Bytes()
	c.head.Size = uint32(len(body))
	c.head.MsgID = msgID
	binary.Write(c.wBuf, binary.LittleEndian, &c.head)
	for len(body) > 0 {
		n, err := c.wBuf.Write(body)
		if err != nil {
			return err
		}
		body = body[n:]
	}
	return c.wBuf.Flush()
}

func (c *binaryCodec) Close() error {
	return c.rwc.Close()
}

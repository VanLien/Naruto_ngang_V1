package net

/*
synID 是请求发起方的id序号
ackID=request.synID 是请求接受方返回请求id序号，用于标识请求来源
packet内保存的synID，只是id，没有请求或相应的含义
请求为ping-pong模式，synID在请求后续操作自增1，即关联请求也是一个新的请求
通过ping-pong，逻辑上保证请求和应答的完整性
对于notify模式，可认为是没有应答的特殊ping-pong

1. c --synID1--> s --ackID1 --> c
2. c --synID2--> s --ackID2 --> c
3. s --synID11--> c --ackID11 --> s

1,2 可能是关联请求，但协议上视为两个独立请求
1,3 c/s 的synID计数器各自独立维护，判断单方递增即可
*/

import (
	"bytes"
	"encoding/binary"
	"errors"
	"fmt"
	"io"
	"math/rand"
	"strings"
	"sync/atomic"

	"tjgame/server_framework/tj/util"
)

const (
	FlagMask       = 0xFF
	MagicFlag      = 0x80 // 1000 0000
	OKACKBit       = 1 << 0
	ErrACKBit      = 1 << 1
	HeartSynBit    = 1 << 2
	ZipFlagBit     = 1 << 3
	LongLenFlagBit = 1 << 4
	ACKFlagBit     = 1 << 5
	UrlFlagBit     = 1 << 6

	PackageFlagLen = 1
)

const (
	NormalPacketHeadSize     = 11
	NormalPacketHeadLongSize = 13
	NormalPacketBodySizeMax  = 65535
	SynIDMax                 = 65500
	defaultSynID             = 65535 // if defaultSynID, will through increaseSyncID() get synID
)

const (
	AESIV  = "YouMi_Technology"
	AESPWD = "tjshuma081610888"
)

const (
	packetFormat = `
flag: %b
len=%d, pad_len=%d, crc32=%d, cmd=%d, syn=%d, ack=%d`

	packetUrlFormat = `
flag: %b
len=%d, pad_len=%d, crc32=%d, url=%s, syn=%d, ack=%d`
)

var (
	errUrlInvalid = errors.New("packet url invalid")
)

var (
	AESIVBYTES       = []byte(AESIV)
	AESPWDBYTES      = []byte(AESPWD)
	globalSynCounter uint32
)

func increaseSyncID() uint16 {
	var n uint32
	n = atomic.AddUint32(&globalSynCounter, 1)
	if n > SynIDMax {
		atomic.StoreUint32(&globalSynCounter, 1)
	}
	return uint16(n)
}

type (
	Packet struct {
		// flag: [1:ok_ack][2:err_ack][3:heart_syn][4:zip_flag][5:long_len_flag][6:ack_flag][7:url_flag][8:magic_flag]
		flag byte

		bodyData []byte
		len      uint32 // body len
		padLen   uint8
		crc32    uint32
		cmd      uint16
		synID    uint16

		// may be exist when flag with UrlFlagBit
		url string

		// not in pack data
		pwd    string
		urlLen uint8
	}

	Flag interface {
		GetFlag(bit byte) bool
		SetFlag(reset bool, bit byte)
	}

	Header interface {
		HeaderLen() uint32

		Len() uint32
		PadLen() uint8
		Crc32() uint32
		Cmd() uint16
		SynID() uint16
		Url() string

		MarshalHeader() ([]byte, error)
		UnmarshalHeader(bodyBytes []byte) error

		HeaderExtraLen() uint32
		UnmarshalHeaderExtra([]byte) error
	}

	Body interface {
		Body() []byte
		SetBody(body []byte)
		MarshalBody() ([]byte, error)
		UnmarshalBody(bodyBytes []byte) error
	}
)

func (p *Packet) doSetting(setting ...PacketSetting) {
	for _, fn := range setting {
		if fn != nil {
			fn(p)
		}
	}
}

func (p *Packet) GetFlag(bit byte) bool {
	return p.flag&bit > 0
}

func (p *Packet) SetFlag(reset bool, bit byte) {
	if reset {
		p.flag |= bit
	} else {
		p.flag &= FlagMask ^ bit
	}
}

func (p *Packet) SetPwd(pwd string) {
	if len(pwd) == 16 {
		p.pwd = pwd
	}
}

func (p *Packet) HeaderLen() uint32 {
	var n uint32
	if p.GetFlag(LongLenFlagBit) {
		n = NormalPacketHeadLongSize
	} else {
		n = NormalPacketHeadSize
	}
	if p.GetFlag(UrlFlagBit) {
		n += 1
	}
	return n
}

func (p *Packet) Len() uint32 {
	return p.len
}

func (p *Packet) PadLen() uint8 {
	return p.padLen
}

func (p *Packet) Crc32() uint32 {
	return p.crc32
}

func (p *Packet) Cmd() uint16 {
	return p.cmd
}

func (p *Packet) SynID() uint16 {
	return p.synID
}

func (p *Packet) AckID() uint16 {
	if p.IsAck() {
		return p.synID
	}
	return 0
}

func (p *Packet) IsAck() bool {
	return p.flag&ACKFlagBit > 0
}

func (p *Packet) Url() string {
	return p.url
}

func (p *Packet) MarshalHeader() ([]byte, error) {
	urlPadLen := 0
	if p.GetFlag(UrlFlagBit) {
		urlPadLen = ((len(p.url)+2-1)/16 + 1) * 16
	}

	buf := make([]byte, int(p.HeaderLen())+urlPadLen)
	start, end := 0, 0
	if p.GetFlag(LongLenFlagBit) {
		start, end = end, end+4
		binary.BigEndian.PutUint32(buf[start:end], p.len)
	} else {
		start, end = end, end+2
		binary.BigEndian.PutUint16(buf[start:end], uint16(p.len))
	}
	start, end = end, end+1
	buf[start] = p.padLen
	start, end = end, end+4
	binary.BigEndian.PutUint32(buf[start:end], p.crc32)
	start, end = end, end+2
	binary.BigEndian.PutUint16(buf[start:end], p.cmd)
	start, end = end, end+2
	binary.BigEndian.PutUint16(buf[start:end], p.synID)

	if p.GetFlag(UrlFlagBit) {
		start, end = end, end+1
		p.urlLen = uint8(len(p.url))
		buf[start] = p.urlLen

		start, end = end, end+urlPadLen
		url := buf[start:end]
		copy(url, p.url)
		binary.BigEndian.PutUint16(url[urlPadLen-2:], p.cmd)
		encodeUrl, err := util.AESCBCEncrypter(url, AESPWDBYTES, AESIVBYTES)
		if err != nil {
			return nil, err
		}
		copy(url, encodeUrl)
	}

	return buf, nil
}

func (p *Packet) UnmarshalHeader(headerBytes []byte) error {
	start, end := 0, 0
	if p.GetFlag(LongLenFlagBit) {
		start, end = end, end+4
		p.len = binary.BigEndian.Uint32(headerBytes[start:end])
	} else {
		start, end = end, end+2
		p.len = uint32(binary.BigEndian.Uint16(headerBytes[start:end]))
	}
	start, end = end, end+1
	p.padLen = uint8(headerBytes[start])
	start, end = end, end+4
	p.crc32 = binary.BigEndian.Uint32(headerBytes[start:end])
	start, end = end, end+2
	p.cmd = binary.BigEndian.Uint16(headerBytes[start:end])
	start, end = end, end+2
	p.synID = binary.BigEndian.Uint16(headerBytes[start:end])

	if p.GetFlag(UrlFlagBit) {
		start, end = end, end+1
		p.urlLen = headerBytes[start]
	}

	return nil
}

func (p *Packet) HeaderExtraLen() uint32 {
	if p.GetFlag(UrlFlagBit) {
		n := int(p.urlLen)
		n = ((n+2-1)/16 + 1) * 16
		return uint32(n)
	}
	return 0
}

func (p *Packet) UnmarshalHeaderExtra(extraBytes []byte) error {
	start, end := 0, 0
	if p.GetFlag(UrlFlagBit) {
		n := int(p.urlLen)
		n = ((n+2-1)/16 + 1) * 16
		start, end = end, end+n
		decodeUrl, err := util.AESCBCDecrypter(extraBytes[start:end], AESPWDBYTES, AESIVBYTES)
		if err != nil {
			return err
		}
		p.url = util.Byte2String(decodeUrl[:p.urlLen])
		if len(p.url) == 0 || p.url[0] != '/' {
			return errUrlInvalid
		}
	}

	return nil
}

func (p *Packet) Body() []byte {
	return p.bodyData
}

func (p *Packet) SetBody(data []byte) {
	p.bodyData = data
}

func (p *Packet) MarshalBody() ([]byte, error) {
	p.SetFlag(true, ZipFlagBit) // default zip

	var err error
	var zdata []byte
	if strings.HasPrefix(p.url, "/onlinefight") {
		zdata, err = util.LZ4Compress(p.bodyData)
		if zdata == nil || len(zdata) == 0 {
			p.SetFlag(false, ZipFlagBit)
			zdata = p.bodyData
		}
	} else {
		if len(p.bodyData) < 32 {
			p.SetFlag(false, ZipFlagBit)
			zdata = p.bodyData
		} else {
			zdata, err = util.LZ4Compress(p.bodyData)
			if zdata == nil || len(p.bodyData) <= len(zdata) || len(zdata) == 0 {
				p.SetFlag(false, ZipFlagBit)
				zdata = p.bodyData
			}
		}
	}
	//log.Debugf("after zip %v\n", zdata)

	padlen := 0
	if len(zdata)%16 != 0 {
		padlen = 16 - len(zdata)%16
		fill := make([]byte, padlen)
		zdata = append(zdata, fill...)
	}
	//log.Debugf("after padding %v\n", zdata)
	p.padLen = uint8(padlen)

	zdata, err = util.AESCBCEncrypter(zdata, util.String2ReadOnlyBytes(p.pwd), AESIVBYTES)
	if err != nil {
		return nil, err
	}
	//log.Debugf("after encrypt: %v\n", zdata)

	p.crc32 = util.CheckCRC32Sum(zdata, p.Cmd(), p.SynID(), p.Url())

	if len(zdata) > NormalPacketBodySizeMax {
		p.SetFlag(true, LongLenFlagBit)
	}
	p.len = uint32(len(zdata))

	//log.Debugf("MarshalBody %s", p)

	return zdata, nil
}

func (p *Packet) UnmarshalBody(bodyBytes []byte) error {
	//log.Debugf("UnmarshalBody %s", p)

	//log.Debugf("before decrypt: %v\n", bodyBytes)
	bodyData, err := util.AESCBCDecrypter(bodyBytes, util.String2ReadOnlyBytes(p.pwd), AESIVBYTES)
	//log.Debugf("after decrypt: %v\n", bodyData)
	if err != nil {
		return err
	}
	if p.PadLen() > 0 {
		bodyData = bodyData[:len(bodyData)-int(p.PadLen())]
	}
	//log.Debugf("before unzip: %v\n", bodyData)
	if p.GetFlag(ZipFlagBit) {
		bodyData, err = util.LZ4Uncompress(bodyData)
		//log.Debugf("after unzip: %v\n", bodyData)
		if err != nil {
			return err
		}
	}
	p.bodyData = bodyData
	return nil
}

func (p *Packet) String() string {
	if p.GetFlag(UrlFlagBit) {
		return fmt.Sprintf(packetUrlFormat, p.flag, p.Len(), p.PadLen(), p.Crc32(), p.Url(), p.SynID(), p.AckID())
	}
	return fmt.Sprintf(packetFormat, p.flag, p.Len(), p.PadLen(), p.Crc32(), p.Cmd(), p.SynID(), p.AckID())
}

func (p *Packet) Write(w io.Writer) error {
	buffer := new(bytes.Buffer)
	if p.GetFlag(OKACKBit) || p.GetFlag(ErrACKBit) {
		buffer.WriteByte(p.flag)
		buffer.Write(uint16ToBytes(p.synID))
	} else if p.GetFlag(HeartSynBit) {
		buffer.WriteByte(p.flag)
	} else {
		bodyBytes, err := p.MarshalBody()
		if err != nil {
			return err
		}
		headerBytes, err := p.MarshalHeader()
		if err != nil {
			return err
		}
		buffer.WriteByte(p.flag)
		buffer.Write(headerBytes)
		buffer.Write(bodyBytes)
	}

	packData := buffer.Bytes()
	//log.Debugf("send Data size: %d byte", len(packData))
	length := 0
	for length < len(packData) {
		l, err := w.Write(packData[length:])
		if err == nil {
			length += l
		} else {
			return err
		}
	}
	return nil
}

func (p *Packet) Read(reader io.Reader) error {
	var err error

	if p.GetFlag(OKACKBit) || p.GetFlag(ErrACKBit) {
		synIDBytes := make([]byte, 2)
		_, err = io.ReadFull(reader, synIDBytes)
		if err != nil {
			return err
		}
		synID := bytesToUint16(synIDBytes)
		p.synID = synID
		return nil
	} else if p.GetFlag(HeartSynBit) {
		return nil
	}

	// read head
	headerBytes := make([]byte, p.HeaderLen())
	_, err = io.ReadFull(reader, headerBytes)
	if err != nil {
		return err
	}
	err = p.UnmarshalHeader(headerBytes)
	if err != nil {
		return err
	}
	//log.Debugf("len=%d, pad_len=%d, crc32=%d, cmd=%d, syn_id=%d\n", p.Len(), p.PadLen(), p.Crc32(), p.Cmd(), p.SynID())

	// read head extra
	extraLen := p.HeaderExtraLen()
	if extraLen > 0 {
		extraBytes := make([]byte, extraLen)
		_, err = io.ReadFull(reader, extraBytes)
		if err != nil {
			return err
		}
		err = p.UnmarshalHeaderExtra(extraBytes)
		if err != nil {
			return err
		}
	}

	// read body
	bodyBytes := make([]byte, p.Len())
	_, err = io.ReadFull(reader, bodyBytes)
	if err != nil {
		return err
	}

	// crc32 check
	if util.CheckCRC32Sum(bodyBytes, p.Cmd(), p.SynID(), p.Url()) != p.Crc32() {
		return errors.New("crc32 error")
	}

	err = p.UnmarshalBody(bodyBytes)
	if err != nil {
		return err
	}
	//log.Debugf("final body data: %v\n", p.bodyData)

	return nil
}

// PacketSetting set header field
type PacketSetting func(*Packet)

func WithCmd(cmd uint16) PacketSetting {
	return func(p *Packet) {
		p.cmd = cmd
	}
}

func WithUrl(url string) PacketSetting {
	return func(p *Packet) {
		p.url = url
		// cmd is salt, rand it
		p.cmd = uint16(rand.Intn(65536))
		p.SetFlag(true, UrlFlagBit)
	}
}

func WithSynID(synID uint16) PacketSetting {
	return func(p *Packet) {
		p.synID = synID
		p.SetFlag(false, ACKFlagBit)
	}
}

func WithAckID(ackID uint16) PacketSetting {
	return func(p *Packet) {
		p.synID = ackID
		p.SetFlag(true, ACKFlagBit)
	}
}

func WithFlag(f byte) PacketSetting {
	return func(p *Packet) {
		p.flag = f
	}
}

func WithPwd(pwd string) PacketSetting {
	return func(p *Packet) {
		p.pwd = pwd
	}
}

// syn 请求数据包
func NewPacket(setting ...PacketSetting) *Packet {
	var p = &Packet{
		flag:  MagicFlag,
		synID: defaultSynID,
		pwd:   AESPWD,
	}
	p.doSetting(setting...)
	if p.synID == defaultSynID {
		p.synID = increaseSyncID()
	}
	return p
}

// ack 响应数据包
func NewAckPacket(synHead Header, setting ...PacketSetting) *Packet {
	varg := append([]PacketSetting{
		WithCmd(synHead.Cmd()),
		WithAckID(synHead.SynID()),
	}, setting...)
	return NewPacket(varg...)
}

// ack 响应数据包
func NewAckUrlPacket(synHead Header, setting ...PacketSetting) *Packet {
	varg := append([]PacketSetting{
		WithUrl(synHead.Url()),
		WithAckID(synHead.SynID()),
	}, setting...)
	return NewPacket(varg...)
}

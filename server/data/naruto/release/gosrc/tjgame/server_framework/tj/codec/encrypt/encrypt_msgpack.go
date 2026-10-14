/*
WANetTask: [flag(1 byte)][...]

flag: [1:ok_ack][2:err_ack][3:heart_syn][4:zip_flag][5:long_len_flag][6:ack_flag][7-8:magic_flag]

	`1:ok_ack`: [syn_id(2 bytes)]
		mean is ok ack, no other data
	`2:err_ack`: [syn_id(2 bytes)]
		mean is err ack, no other data
	`3:heart_syn`: None
		mean is heart-beat syn, no other data, need client heart ack
	`4:zip_flag`:
		mean `data`: AES128_CBC(raw_data + '\0'*pad_len)
	`5:long_len_flag`:
		mean `len`(4 bytes)
	`5:ack_flag`:
		mean packet is ack, its syn_id belong to client
	`7-8:magic_flag`:
		magic binary bit: 11

normal task: [len(*2 bytes) pad_len(1 bytes) crc32(4 bytes) cmd(2 bytes) syn_id(2 bytes)][data(len)]

	`crc32`: crc32(data + str(cmd) + str(syn_id))
	`data`: AES128_CBC(ZIP(raw_data) + '\0'*pad_len)
*/
package codec

/*
import (
	"bufio"
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"encoding/binary"
	"errors"
	"fmt"
	"hash/crc32"
	"io"
	"math/rand"
	"reflect"

	"github.com/pierrec/lz4"
	"gopkg.in/vmihailenco/msgpack.v2"
	"pegasus/command"
)

const enMsgpackHeadSize = 14
const enMsgpackMaxSize = 10 * 1024 * 1024

var (
	CRC32Error = errors.New("codec: crc32 error")

	flagMask  = byte(0xFF)
	magicFlag = byte(0xC0)

	okACKBit       = 0 // decrepted
	errACKBit      = 1 // decrepted
	heartSynBit    = 2
	zipFlagBit     = 3
	longLenFlagBit = 4 // always 1
	ackFlagBit     = 5

	aesInitIV       = []byte("YouMi_Technology")
	aesAlignFill    = []byte("tjpegasus163_com")
	aesInitPassword = []byte("tjshuma081610888")
)

type EncryptMsgpackProtocol struct {
	*command.Map
}

func (p *EncryptMsgpackProtocol) NewCodec(rwc io.ReadWriteCloser) (Codec, error) {
	block, _ := aes.NewCipher(aesInitPassword)
	c := &enMsgpackCodec{
		p:           p,
		rwc:         rwc,
		buf:         bytes.NewBuffer(make([]byte, 0, 64)),
		zwByteBuf:   make([]byte, 0, 4*1024),
		zrByteBuf:   make([]byte, 0, 4*1024),
		wBuf:        bufio.NewWriter(rwc),
		headRBytes:  make([]byte, enMsgpackHeadSize),
		headWBytes:  make([]byte, enMsgpackHeadSize),
		cipherBlock: block,
	}
	return c, nil
}

func NewEncryptMsgpackProtocol() *EncryptMsgpackProtocol {
	return &EncryptMsgpackProtocol{
		command.NewMap(),
	}
}

type enMsgpackCodec struct {
	p           *EncryptMsgpackProtocol
	rwc         io.ReadWriteCloser
	buf         *bytes.Buffer
	zwByteBuf   []byte
	zrByteBuf   []byte
	wBuf        *bufio.Writer
	headRBytes  []byte
	headWBytes  []byte
	head        enMsgpackHead
	cipherBlock cipher.Block
}

type enMsgpackHead struct {
	Flag  byte
	Size  uint32
	Pad   byte
	CRC32 uint32
	MsgID int16
	SynID uint16
}

func (h *enMsgpackHead) isValid() bool {
	if h.Flag&magicFlag != magicFlag {
		return false
	}
	if h.Pad >= 16 {
		return false
	}
	return true
}

func (h *enMsgpackHead) GetFlag(bit int) bool {
	return h.Flag&(1<<uint(bit)) > 0
}

func (h *enMsgpackHead) SetFlag(reset bool, bits ...int) {
	if reset {
		h.Flag = magicFlag
	}
	for _, bit := range bits {
		h.Flag = h.Flag | (1 << uint(bit))
	}
}

// BigEndian
func (c *enMsgpackCodec) readHead() enMsgpackHead {
	h, b := enMsgpackHead{}, c.headRBytes
	h.Flag = b[0]
	h.Size = binary.BigEndian.Uint32(b[1:5])
	h.Pad = b[5]
	h.CRC32 = binary.BigEndian.Uint32(b[6:10])
	h.MsgID = int16(binary.BigEndian.Uint16(b[10:12]))
	h.SynID = binary.BigEndian.Uint16(b[12:14])
	return h
}

// BigEndian
func (c *enMsgpackCodec) writeHead() {
	h, b := c.head, c.headWBytes
	b[0] = h.Flag
	binary.BigEndian.PutUint32(b[1:5], h.Size)
	b[5] = h.Pad
	binary.BigEndian.PutUint32(b[6:10], h.CRC32)
	binary.BigEndian.PutUint16(b[10:12], uint16(h.MsgID))
	binary.BigEndian.PutUint16(b[12:14], h.SynID)
}

func (c *enMsgpackCodec) Recv() (int32, interface{}, error) {
	// read head
	if _, err := io.ReadFull(c.rwc, c.headRBytes); err != nil {
		return 0, nil, err
	}
	head := c.readHead()
	if !head.isValid() {
		return 0, nil, InvalidHead
	}
	if head.Size > enMsgpackMaxSize {
		return 0, nil, TooLargeMsg
	}
	rt, ok := c.p.ID2Type[int32(head.MsgID)]
	if !ok {
		return 0, nil, NoSuchMsgType
	}
	// read body
	data := make([]byte, head.Size)
	if _, err := io.ReadFull(c.rwc, data); err != nil {
		return 0, nil, err
	}
	// crc32 check
	crc := crc32.ChecksumIEEE(data)
	s := fmt.Sprintf("%d%d", head.MsgID, head.SynID)
	crc = crc32.Update(crc, crc32.IEEETable, []byte(s))
	if crc != head.CRC32 {
		return 0, nil, CRC32Error
	}
	// aes decrypt
	decrypt := make([]byte, len(data))
	mode := cipher.NewCBCDecrypter(c.cipherBlock, aesInitIV)
	mode.CryptBlocks(decrypt, data)
	// remove aes pad
	decrypt = decrypt[:len(decrypt)-int(head.Pad)]
	if head.GetFlag(zipFlagBit) {
		// lz4 uncompress
		// https://github.com/lz4/lz4/blob/dev/doc/lz4_Frame_format.md#Data Blocks
		// pierrec/lz4 no header of block size
		n := int(binary.LittleEndian.Uint32(decrypt[:4]))
		if n > len(c.zrByteBuf) {
			c.zrByteBuf = make([]byte, n)
		}
		n, err := lz4.UncompressBlock(decrypt[4:], c.zrByteBuf, 0)
		if err != nil {
			return 0, nil, err
		}
		decrypt = c.zrByteBuf[:n]
	}
	// unmsgpack
	msg := reflect.New(rt).Interface()
	if err := msgpack.Unmarshal(decrypt, msg); err != nil {
		return 0, nil, err
	}
	return int32(head.MsgID), msg, nil
}

func (c *enMsgpackCodec) Send(msg interface{}) error {
	rt := reflect.TypeOf(msg)
	if rt.Kind() == reflect.Ptr {
		rt = rt.Elem()
	}
	msgID, ok := c.p.Type2ID[rt]
	if !ok {
		return NoSuchMsgType
	}
	// msgpack
	c.buf.Reset()
	data, err := msgpack.Marshal(msg)
	if err != nil {
		return err
	}
	// TODO: msg may be server notify, not response
	// TODO: ackFlagBit is mean response
	c.head.SetFlag(true, ackFlagBit, longLenFlagBit)
	if len(data) > 64 {
		// lz4 compress
		if 4+lz4.CompressBlockBound(len(data)) > len(c.zwByteBuf) {
			c.zwByteBuf = make([]byte, 4+lz4.CompressBlockBound(len(data)))
		}
		binary.LittleEndian.PutUint32(c.zwByteBuf, uint32(len(data)))
		n, err := lz4.CompressBlock(data, c.zwByteBuf[4:], 0)
		if err != nil {
			return err
		}
		if n+32 > len(data) {
			c.head.SetFlag(false, zipFlagBit)
			data = c.zwByteBuf[:4+n]
		}
	}
	// add aes pad
	c.head.Pad = byte((aes.BlockSize - (len(data) % aes.BlockSize)) % aes.BlockSize)
	if c.head.Pad != 0 {
		i := rand.Intn(len(aesAlignFill) - int(c.head.Pad))
		data = append(data, aesAlignFill[i:i+int(c.head.Pad)]...)
	}
	// aes encrypt
	encrypt := make([]byte, len(data))
	mode := cipher.NewCBCEncrypter(c.cipherBlock, aesInitIV)
	mode.CryptBlocks(encrypt, data)

	c.head.Size = uint32(len(encrypt))
	c.head.MsgID = int16(msgID)
	c.head.SynID = 0
	// crc32
	crc := crc32.ChecksumIEEE(encrypt)
	s := fmt.Sprintf("%d%d", c.head.MsgID, c.head.SynID)
	crc = crc32.Update(crc, crc32.IEEETable, []byte(s))
	c.head.CRC32 = crc
	c.writeHead()
	c.wBuf.Write(c.headWBytes)
	for len(encrypt) > 0 {
		n, err := c.wBuf.Write(encrypt)
		if err != nil {
			return err
		}
		encrypt = encrypt[n:]
	}
	return c.wBuf.Flush()
}

func (c *enMsgpackCodec) Close() error {
	return c.rwc.Close()
}
*/

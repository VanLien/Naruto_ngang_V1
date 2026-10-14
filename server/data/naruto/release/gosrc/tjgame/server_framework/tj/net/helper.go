package net

import (
	"encoding/binary"
)

func uint16ToBytes(input uint16) []byte {
	buf := make([]byte, 2)
	binary.BigEndian.PutUint16(buf, input)
	return buf
}

func bytesToUint16(buf []byte) uint16 {
	return binary.BigEndian.Uint16(buf)
}

func uint32ToBytes(input uint32) []byte {
	buf := make([]byte, 4)
	binary.BigEndian.PutUint32(buf, input)
	return buf
}

func bytesToUint32(buf []byte) uint32 {
	return binary.BigEndian.Uint32(buf)
}

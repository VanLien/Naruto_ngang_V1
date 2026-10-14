package util

import (
	"encoding/binary"
	"errors"
	"tjgame/server_framework/tj/log"

	"github.com/pierrec/lz4"
)

const maxLZ4Size = 128 * 1024 * 1024

var (
	ErrTooLargeMem = errors.New("too large mem")
)

func LZ4Uncompress(data []byte) ([]byte, error) {
	length := int(binary.LittleEndian.Uint32(data[:4]))
	if length > maxLZ4Size {
		log.Warningf("LZ4Uncompress too large mem %d", length)
		return nil, ErrTooLargeMem
	}
	decompressed := make([]byte, length)
	l, err := lz4.UncompressBlock(data[4:], decompressed)
	if err != nil {
		return nil, err
	}
	data = decompressed[:l]
	return data, nil
}

func LZ4Compress(data []byte) ([]byte, error) {
	length := 4 + lz4.CompressBlockBound(len(data))
	compressed := make([]byte, length)
	binary.LittleEndian.PutUint32(compressed, uint32(len(data)))
	// if compressed length bigger than data, it will return l=0, err=nil
	l, err := lz4.CompressBlockHC(data, compressed[4:], -1)
	if err != nil || l == 0 {
		return nil, err
	}
	data = compressed[:4+l]
	return data, nil
}

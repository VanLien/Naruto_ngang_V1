package util

import (
	"fmt"
	"hash/crc32"
)

func CheckCRC32Sum(bodyBytes []byte, cmd, synID uint16, url string) uint32 {
	crcSum := crc32.ChecksumIEEE(bodyBytes)
	s := fmt.Sprintf("%d%d%s", cmd, synID, url)
	crcSum = crc32.Update(crcSum, crc32.IEEETable, []byte(s))
	return crcSum
}

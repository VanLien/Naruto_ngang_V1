package util

import (
	"bytes"
	"runtime"
	"strconv"
	"sync"
)

var goroutinePrefix = []byte("goroutine ")

func GoID() int {
	var buf [64]byte
	n := runtime.Stack(buf[:], false)
	idField := bytes.Fields(bytes.TrimPrefix(buf[:n], goroutinePrefix))[0]
	id, err := strconv.Atoi(string(idField))
	if err != nil {
		return -1
	}
	return id
}

func GetStack(bufSize int) string {
	if bufSize == 0 {
		bufSize = 1024
	}
	buf := make([]byte, bufSize)
	n := runtime.Stack(buf[:], false)
	return string(buf[:n])
}

func WithGuard(l sync.Locker, f func()) {
	l.Lock()
	defer l.Unlock()
	f()
}

func WithDefer(f func(), df func()) {
	defer df()
	f()
}

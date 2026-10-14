package ymrand

/*
#cgo CFLAGS: -Ilua
#cgo CPPFLAGS: -Ilua
#cgo llua LDFLAGS: -lluajit-5.1
#cgo luaa LDFLAGS: -lluajit-5.1 -lm -ldl
#cgo linux,!llua,!luaa LDFLAGS: -lluajit-5.1
#cgo darwin,!luaa pkg-config: lua5.1
#cgo freebsd,!luaa LDFLAGS: -llua-5.1
#cgo windows,!llua LDFLAGS: -L${SRCDIR}/../bin/windows_amd64 -lluajit -lmingwex -lmingw32

#include <lua.h>
#include "lua_rand.h"

*/
import "C"
import "unsafe"

func OpenLib(L unsafe.Pointer) {
	C.luaopen_random((*C.lua_State)(L))
}

func CloseLib(L unsafe.Pointer) {
	C.luaclose_random((*C.lua_State)(L))
}

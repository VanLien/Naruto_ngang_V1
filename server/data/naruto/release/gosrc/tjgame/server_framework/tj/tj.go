package tj

import (
	"runtime"
	"tjgame/server_framework/tj/util"
)

type Runnable interface {
	Start()
	Stop()
}

func init() {
	// limit cpu by default
	// you could set the new in your code
	runtime.GOMAXPROCS(4)

	util.ReseedRandom()
}

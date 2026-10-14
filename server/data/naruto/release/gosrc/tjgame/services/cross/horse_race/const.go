package yyhuodong

import (
	"errors"
	"tjgame/server_framework/tj/util"
)

var (
	ErrStatusStart  = errors.New("horse race status is start")
	ErrStatusClosed = errors.New("horse race status is closed")
	ErrNoThisPlay   = errors.New("noThisPlay")
	ErrNoInPrepare  = errors.New("noInPrepare")
)

var (
	closeTime = util.Time{Hour: 5} // 结束

	TestInQuick   = false
	TestInPrepare = false
)

package caller

import "errors"

var (
	ErrCallInvalid      = errors.New("call invalid")
	ErrCallException    = errors.New("call exception")
	ErrCallRespNewIsNil = errors.New("call new response is nil")
)

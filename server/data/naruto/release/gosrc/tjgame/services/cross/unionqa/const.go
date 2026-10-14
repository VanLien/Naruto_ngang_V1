package unionqa

import (
	"errors"
	"tjgame/server_framework/tj/util"
)

var (
	ErrGroupPlayNotExist = errors.New("groupPlayNotExist")
	closedTime           = util.Time{Hour: 23, Minute: 59, Second: 59}
	totalRankNum         = 8
	rankNums             = []int{6, 7, 8}
)

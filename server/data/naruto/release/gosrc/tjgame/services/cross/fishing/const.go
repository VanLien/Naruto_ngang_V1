package fishing

import (
	"errors"
	"tjgame/server_framework/tj/util"
)

const (
	CrossFishingRankSize     = 50
	CrossFishingRankTop3Size = 3
)

var (
	ErrGroupPlayNotExist = errors.New("groupPlayNotExist")

	closedTime = util.Time{Hour: 23}
)

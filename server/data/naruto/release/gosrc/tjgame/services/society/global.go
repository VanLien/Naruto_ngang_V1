// @Time     : 2019/5/14 15:00
// @Author   : cancan
// @File     : global.go
// @Function : 全局变量、类型、方法等

package society

import (
	"errors"
	"tjgame/document"

	"tjgame/document/scheme"
)

const (
	// 空数据库 ID
	NilID = document.ID("")

	// 体力数值服务器上限
	StaminaLimitMax = 3000

	// 好友(申请)列表上限
	FriendsMax = 60

	// 好友体力赠送
	FriendSendStamina = 3

	// 好友体力每日赠送次数上限
	FriendSendStaminaTimesMax = 100

	// 好友体力每日领取次数上限
	FriendRecvStaminaTimesMax = 20

	// 申请好友列表一页数量
	FriendListMax = 10

	// 好友 LRU 大小
	SocietyRoleCacheCapacity = 1000
)

var (
	ErrFriendSearchNoSuchRole = errors.New("FriendSearchNoSuchRole")
	ErrFriendSearchMyself     = errors.New("FriendSearchMyself")
	ErrFriendAlready          = errors.New("FriendAlready")
	ErrFriendMax              = errors.New("FriendMax")
	ErrFriendFriendMax        = errors.New("FriendFriendMax")
	ErrFriendFriendReqMax     = errors.New("FriendFriendReqMax")
	ErrFriendNone             = errors.New("FriendNone")
	ErrSocietyBlackListHasAdd = errors.New("SocietyBlackListHasAdd")
	ErrSocietyBlackListNoThis = errors.New("societyBlackListNoThis")
	ErrFriendStaminaSendMax   = errors.New("FriendStaminaSendMax")
	ErrStaminaCanNotGive      = errors.New("StaminaCanNotGive")
	ErrFriendStaminaRecvMax   = errors.New("FriendStaminaRecvMax")
	ErrFriendStaminaNone      = errors.New("FriendStaminaNone")
)

type Role struct {
	*scheme.RoleObject
}

func NewRole(role *scheme.Role) *Role {
	return &Role{
		RoleObject: scheme.NewRoleObject(role),
	}
}

type Society struct {
	*scheme.SocietyObject
}

func NewSociety(society *scheme.Society) *Society {
	return &Society{
		SocietyObject: scheme.NewSocietyObject(society),
	}
}

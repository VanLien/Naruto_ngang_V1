package union

import (
	"errors"
	"math/rand"
	"sync"
	"sync/atomic"
	"time"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/util"

	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
)

type RedPacketViewInfo struct {
	ID         document.ID   `codec:"id"`
	PacketFlag int           `codec:"packet_flag"`
	PacketType int           `codec:"packet_type"`
	TotalVal   int           `codec:"total_val"`
	TotalCount int           `codec:"total_count"`
	UsedVal    int           `codec:"used_val"`
	UsedCount  int           `codec:"used_count"`
	Members    []document.ID `codec:"members"`

	TopRoleName string `codec:"top_role_name,omitempty"`

	RoleName    string  `codec:"role_name,omitempty"`
	CSVID       int     `codec:"csv_id,omitempty"`
	CreatedTime float64 `codec:"created_time,omitempty"`
}

type RedPacket struct {
	*scheme.UnionRedPacketObject

	topRoleName string
	topVal      int

	// protect rob and push to free
	using int32 // 0: not in using, 1: in using
}

func (p *RedPacket) GetViewInfo() (info RedPacketViewInfo) {
	info.ID = p.GetID()
	info.PacketFlag = p.PacketFlag()
	info.PacketType = p.PacketType()
	info.TotalCount = p.TotalCount()
	info.UsedCount = len(p.Members())
	info.TotalVal = p.TotalVal()
	info.UsedVal = p.UsedVal()
	members := make([]document.ID, 0, info.UsedCount)
	for _, member := range p.Members() {
		members = append(members, member.ID)
	}
	info.Members = members

	if p.PacketFlag() == RedPacketFlagRole {
		info.RoleName = p.RoleName()
		info.CSVID = p.CSVID()
		info.CreatedTime = p.CreatedTime()
	} else {
		info.TopRoleName = p.topRoleName
	}
	return
}

func (p *RedPacket) UsedVal() int {
	val := 0
	for _, member := range p.Members() {
		val += member.Val
	}
	return val
}

func (p *RedPacket) Detail() map[document.ID]scheme.UnionRedPacketMember {
	members := make(map[document.ID]scheme.UnionRedPacketMember)
	for _, member := range p.Members() {
		members[member.ID] = member
	}
	return members
}

func (p *RedPacket) Rob(role scheme.UnionMemberRole) (int, error) {
	if !atomic.CompareAndSwapInt32(&p.using, 0, 1) {
		return 0, errors.New("disabled")
	}
	defer func() {
		atomic.StoreInt32(&p.using, 0)
	}()

	db, unlock := p.LockAndGetDB()
	defer unlock()

	if db.DiscardFlag {
		return 0, errors.New("discard")
	}
	usedCount := len(db.Members)
	if usedCount >= db.TotalCount {
		return 0, ErrUnionRedPacketNoRemain
	}
	usedVal := 0
	for _, member := range db.Members {
		if member.ID == role.ID {
			return 0, ErrUnionRedPacketAlreadyRob
		}
		usedVal += member.Val
	}
	remainCount := db.TotalCount - usedCount
	val := 0
	if remainCount == 1 {
		val = db.TotalVal - usedVal
	} else {
		right := (db.TotalVal - usedVal - remainCount) * 2 / remainCount
		if right <= 0 {
			right = 1
		}
		val = int(rand.Int31n(int32(right)+1)) + 1
	}
	if val < 1 {
		val = 1
	}
	db.Members[role.ID] = scheme.UnionRedPacketMember{role, val}
	p.SetMembers(db.Members)
	if val > p.topVal {
		p.topVal = val
		p.topRoleName = role.Name
	}
	return val, nil
}

func (p *RedPacket) CanRobByRole(id document.ID) bool {
	if len(p.Members()) >= p.TotalCount() {
		return false
	}
	_, ok := p.Members()[id]
	return !ok
}

func (p *RedPacket) SysReset(level int, now int) {
	p.topRoleName = ""
	p.topVal = 0
	p.SetDate(now)
	p.SetMembers(map[document.ID]scheme.UnionRedPacketMember{})
	config := GetConfig().CSVSysRedPackets[level][p.PacketType()]
	p.SetTotalVal(config[0])
	p.SetTotalCount(config[1])
}

type idlist struct {
	sync.Mutex
	free []document.ID
}

func (l *idlist) Init(ids []document.ID) {
	l.Lock()
	defer l.Unlock()
	l.free = ids
}

func (l *idlist) Put(id document.ID) {
	l.Lock()
	defer l.Unlock()
	l.free = append(l.free, id)
}

func (l *idlist) Get() document.ID {
	l.Lock()
	defer l.Unlock()
	if len(l.free) > 0 {
		id := l.free[0]
		l.free = l.free[1:]
		return id
	}
	return ""
}

var FreePacketList idlist

type AllRedPackets struct {
	sync.Map // map[document.ID]*RedPacket
}

func (all *AllRedPackets) createRolePacket(packet *RedPacket, roleID document.ID, roleName string, csvID int, totalVal int, totalCount int) {
	db, unlock := packet.LockAndGetDB()
	defer unlock()

	db.PacketFlag = RedPacketFlagRole
	db.RoleDbId = roleID
	db.RoleName = roleName
	db.CSVID = csvID
	db.TotalVal = totalVal
	db.TotalCount = totalCount
	packet.SetDirty("packet_flag", "role_db_id", "role_name", "csv_id", "total_val", "total_count")
	all.Store(db.ID, packet)
	time.AfterFunc(RoleRedPacketDuration, func() {
		all.pushPacketToFree(packet)
	})
}

func (all *AllRedPackets) createSysPacket(packet *RedPacket, totalVal int, totalCount int) {
	db, unlock := packet.LockAndGetDB()
	defer unlock()

	db.PacketFlag = RedPacketFlagSys
	db.RoleDbId = ""
	db.RoleName = ""
	db.CSVID = 0
	db.TotalVal = totalVal
	db.TotalCount = totalCount
	packet.SetDirty("packet_flag", "role_db_id", "role_name", "csv_id", "total_val", "total_count")
	all.Store(db.ID, packet)
}

func (all *AllRedPackets) addPacket(packet *RedPacket) {
	all.Store(packet.GetID(), packet)
	if packet.PacketFlag() == RedPacketFlagRole {
		delta := RoleRedPacketDuration - time.Duration(util.NowTime()-packet.CreatedTime())*time.Second
		if delta <= 0 {
			delta = 1
		}
		if packet.CSVID() == 0 { // fix some error data, role packet csvid can not be 0
			log.Warningf("union role packet %v csv id is 0, force discard", packet.GetID())
			delta = 1
		}
		time.AfterFunc(delta, func() {
			all.pushPacketToFree(packet)
		})
	} else {
		packet.topRoleName = ""
		packet.topVal = 0
		for _, v := range packet.Members() {
			if v.Val > packet.topVal {
				packet.topVal = v.Val
				packet.topRoleName = v.Name
			}
		}
	}
}

func (all *AllRedPackets) pushPacketToFree(packet *RedPacket) {
	id := packet.GetID()
	all.Delete(id)

	for !atomic.CompareAndSwapInt32(&packet.using, 0, 1) { // may be in rob, wait rob end
		time.Sleep(time.Millisecond)
	}
	packet.SetMembers(map[document.ID]scheme.UnionRedPacketMember{})
	packet.SetDiscardFlag(true)
	FreePacketList.Put(id)
	log.Debugf("push packet %v to free", id)
}

func (all *AllRedPackets) hasSysPacket() bool {
	flag := false
	all.Range(func(key, value interface{}) bool {
		packet := value.(*RedPacket)
		if packet.PacketFlag() == RedPacketFlagSys {
			flag = true
			return false
		}
		return true
	})
	return flag
}

func (all *AllRedPackets) createSysPackets(builder *builder, s service.IService, unionID document.ID) error {
	types := []int{RedPacketGold, RedPacketRMB, RedPacketCoin3}
	packets := make([]*RedPacket, 0, 3)
	for _, t := range types {
		packet, err := builder.CreateUnionRedPacket(s, unionID, t)
		if err != nil {
			return err
		}
		packets = append(packets, packet)
	}

	for _, packet := range packets {
		all.createSysPacket(packet, 0, 0) // 具体数值会在 refreshSysPackets 重新设置
	}
	return nil
}

func (all *AllRedPackets) refreshSysPackets(level int) {
	now := util.Perioddate2int(RedPacketRefreshHour, util.Now())

	all.Range(func(key, value interface{}) bool {
		packet := value.(*RedPacket)
		if packet.PacketFlag() == RedPacketFlagSys {
			if packet.Date() != now {
				packet.SysReset(level, now)
			}
		}
		return true
	})
}

func (all *AllRedPackets) getPacketsInfo() map[document.ID]RedPacketViewInfo {
	views := make(map[document.ID]RedPacketViewInfo)
	all.Range(func(key, value interface{}) bool {
		id := key.(document.ID)
		packet := value.(*RedPacket)
		views[id] = packet.GetViewInfo()
		return true
	})
	return views
}

func (all *AllRedPackets) HasRolePacketCanRob(roleID document.ID) bool {
	flag := false
	all.Range(func(key, value interface{}) bool {
		packet := value.(*RedPacket)
		if packet.PacketFlag() == RedPacketFlagRole {
			flag = packet.CanRobByRole(roleID)
			if flag {
				return false
			}
		}
		return true
	})
	return flag
}

func (all *AllRedPackets) HasSysPacketCanRob(roleID document.ID) bool {
	flag := false
	all.Range(func(key, value interface{}) bool {
		packet := value.(*RedPacket)
		if packet.PacketFlag() == RedPacketFlagSys {
			flag = packet.CanRobByRole(roleID)
			if flag {
				return false
			}
		}
		return true
	})
	return flag
}

func (all *AllRedPackets) getPacket(id document.ID) *RedPacket {
	if v, ok := all.Load(id); ok {
		return v.(*RedPacket)
	}
	return nil
}

func NewAllRedPackets() *AllRedPackets {
	all := &AllRedPackets{}
	return all
}

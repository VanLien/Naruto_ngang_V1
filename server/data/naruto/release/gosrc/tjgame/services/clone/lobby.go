package clone

import (
	"sync"
	"tjgame/document"
	"tjgame/document/scheme"
)

type spaces map[*CloneRoom]bool

func (s *spaces) pop() *CloneRoom {
	var room *CloneRoom
	for v := range *s {
		room = v
	}
	if room != nil {
		delete(*s, room)
	}
	return room
}

type Lobby struct {
	rooms      sync.Map // map[document.ID]*CloneRoom
	roleRoom   sync.Map // map[role.ID]*CCloneRoom
	roleBattle sync.Map // map[role.ID]bool

	mu        sync.Mutex
	fastRooms map[int]map[int]spaces // {nature: {剩余空位: set}}
	freeRooms []document.ID
}

func (l *Lobby) storeRoleRoom(roleID document.ID, room *CloneRoom) {
	l.roleRoom.Store(roleID, room)
}

func (l *Lobby) DeleteRoleRoom(roleID document.ID) {
	l.roleRoom.Delete(roleID)
}

func (l *Lobby) InitFree(ids []document.ID) {
	l.freeRooms = ids
}

func (l *Lobby) AddRoomToIndex(room *CloneRoom) {
	l.rooms.Store(room.GetID(), room)
	l.mu.Lock()
	defer l.mu.Unlock()
	if room.Fast() && room.space() > 0 {
		l.fastRooms[room.NatureID()][room.space()][room] = true
	}

	places := room.Places()
	for _, place := range places {
		l.storeRoleRoom(place.ID, room)

		// 如果不能退出，说明已经战斗过
		if !place.CanQuit {
			l.RecordRoleBattle(place.ID)
		}
	}

}

func (l *Lobby) pushRoomToFree(room *CloneRoom) {
	oldspace := room.space()
	room.SetPlaces(map[document.Integer]*scheme.CloneRoomPlace{})
	room.SetDiscard(true)
	l.rooms.Delete(room.GetID())
	delete(l.fastRooms[room.NatureID()][oldspace], room)
	l.freeRooms = append(l.freeRooms, room.GetID())
}

func (l *Lobby) UpdateRoomIndex(room *CloneRoom, oldspace int) {
	l.mu.Lock()
	defer l.mu.Unlock()
	if oldspace > 0 {
		delete(l.fastRooms[room.NatureID()][oldspace], room)
	}

	space := room.space()
	if space >= CloneRoomMemberMax {
		l.pushRoomToFree(room)
		return
	}

	if space > 0 {
		if room.Fast() {
			l.fastRooms[room.NatureID()][space][room] = true
		} else {
			delete(l.fastRooms[room.NatureID()][space], room)
		}
	}
}

func (l *Lobby) FindFastRoom(natureID int) *CloneRoom {
	l.mu.Lock()
	defer l.mu.Unlock()

	rooms := l.fastRooms[natureID]
	var room *CloneRoom
	for i := 1; i < CloneRoomMemberMax; i++ {
		space := rooms[i]
		room = space.pop()
		if room != nil {
			break
		}
	}
	return room
}

func (l *Lobby) GetFreeRoomID() document.ID {
	l.mu.Lock()
	defer l.mu.Unlock()
	if len(l.freeRooms) > 0 {
		id := l.freeRooms[0]
		l.freeRooms = l.freeRooms[1:]
		return id
	}
	return ""
}

func (l *Lobby) GetRoom(id document.ID) *CloneRoom {
	v, ok := l.rooms.Load(id)
	if !ok {
		return nil
	}
	return v.(*CloneRoom)
}

func (l *Lobby) ResetFast(natures []int) {
	l.fastRooms = make(map[int]map[int]spaces)
	// 初始化 fastRooms
	for _, csvid := range natures {
		l.fastRooms[csvid] = make(map[int]spaces)
		for i := 1; i < CloneRoomMemberMax; i++ {
			l.fastRooms[csvid][i] = make(spaces)
		}
	}
}

func (l *Lobby) Refresh(natures []int) {
	l.mu.Lock()
	defer l.mu.Unlock()
	ids := make([]document.ID, 0, 64)
	l.rooms.Range(func(key, value interface{}) bool {
		l.rooms.Delete(key)
		ids = append(ids, key.(document.ID))
		room := value.(*CloneRoom)
		room.Clear()
		return true
	})
	l.freeRooms = append(l.freeRooms, ids...)
	l.ResetFast(natures)
	l.roleBattle.Range(func(key, value interface{}) bool {
		l.roleBattle.Delete(key)
		return true
	})
}

func (l *Lobby) RecordRoleBattle(roleID document.ID) {
	l.roleBattle.Store(roleID, true)
}

func (l *Lobby) HasBattleFriends(onlineFriends []document.ID) []document.ID {
	ret := []document.ID{}
	for _, v := range onlineFriends {
		if _, ok := l.roleBattle.Load(v); ok {
			ret = append(ret, v)
		}
	}
	return ret
}

func (l *Lobby) getRoomByRoleID(roleID document.ID) *CloneRoom {
	cache, ok := l.roleRoom.Load(roleID)
	if ok {
		return cache.(*CloneRoom)
	} else {
		return nil
	}
}

func NewLobby() *Lobby {
	l := &Lobby{
		fastRooms: make(map[int]map[int]spaces),
	}
	return l
}

package forward

import (
	"context"
	"fmt"
	"sync"
	"time"

	"tjgame/document"
	"tjgame/server_framework/tj/log"
	tjnet "tjgame/server_framework/tj/net"
	"tjgame/server_framework/tj/util"
)

var (
	SessionNoBattleZombieDuration = time.Minute
)

type SessionManager struct {
	mutex        sync.RWMutex
	sessions     map[document.ID]*Session
	connSessions map[*tjnet.Conn]*Session

	zombieTimer *time.Timer
}

func (m *SessionManager) SetSession(session *Session) {
	m.mutex.Lock()
	defer m.mutex.Unlock()

	id := session.id
	if old := m.sessions[id]; old != nil {
		delete(m.sessions, id)
		if old.conn != nil {
			delete(m.connSessions, old.conn)
		}
		old.onDiscard(true)
	}
	m.sessions[id] = session
	session.setLasttime()
}

func (m *SessionManager) GetSession(id document.ID) *Session {
	m.mutex.RLock()
	defer m.mutex.RUnlock()
	return m.sessions[id]
}

func (m *SessionManager) GetSessionByConn(conn *tjnet.Conn) *Session {
	m.mutex.RLock()
	defer m.mutex.RUnlock()
	return m.connSessions[conn]
}

func (m *SessionManager) SetSessionConn(session *Session, conn *tjnet.Conn) {
	session.setLasttime()
	if conn == session.conn {
		return
	}
	m.mutex.Lock()
	defer m.mutex.Unlock()
	delete(m.connSessions, session.conn)
	session.SetConn(conn)
	m.connSessions[conn] = session
}

func (m *SessionManager) onCleanZombie() {
	m.mutex.Lock()
	defer m.mutex.Unlock()

	now := util.Now()
	delList := make([]document.ID, 0, 8)
	for id, session := range m.sessions {
		if session.battle == nil {
			if now.Sub(session.lasttime) > SessionNoBattleZombieDuration {
				delList = append(delList, id)
				continue
			}
		}
	}

	for _, id := range delList {
		session := m.sessions[id]
		delete(m.connSessions, session.conn)
		delete(m.sessions, id)
		session.onDiscard(true)
	}
	if len(delList) > 0 {
		log.Debugf("session manager onCleanZombie, remove no battle session %d", len(delList))
	}
}

func newSessionManager(ctx context.Context) *SessionManager {
	mgr := &SessionManager{
		sessions:     make(map[document.ID]*Session),
		connSessions: make(map[*tjnet.Conn]*Session),
	}
	go func() {
		timer := time.NewTimer(SessionNoBattleZombieDuration)
		for {
			select {
			case <-ctx.Done():
				break
			case <-timer.C:
				mgr.onCleanZombie()
				timer.Reset(SessionNoBattleZombieDuration)
			}
		}
	}()
	return mgr
}

type Session struct {
	id        document.ID
	conn      *tjnet.Conn
	lasttime  time.Time
	lastrtt   int64
	stale     bool
	staleTime time.Time

	battle *Battle
}

func (s *Session) setLasttime() {
	s.lasttime = util.Now()
}

func (s *Session) SetConn(conn *tjnet.Conn) {
	if s.conn == conn {
		return
	}
	if s.conn != nil {
		log.Debugf("session %s old %s replace %s", s.id, s.conn.RemoteAddr(), conn.RemoteAddr())
		s.conn.Close()
	}
	s.conn = conn
	s.stale = false
}

func (s *Session) WritePacket(packet *tjnet.Packet) {
	if s.conn != nil {
		if !s.stale {
			//log.Debugf("%v session %s, write packet url %s", s.conn.RemoteAddr(), s.id, packet.Url())
			s.conn.SendPacket(packet)
		} else {
			s.conn = nil
		}
	}
}

func (s *Session) onDiscard(close bool) {
	s.battle = nil
	if s.conn != nil {
		if close {
			s.conn.Close()
		}
		s.conn = nil
	}
}

func NewSession(id document.ID, conn *tjnet.Conn) *Session {
	return &Session{
		id:        id,
		conn:      conn,
		stale:     true,
		staleTime: util.Now(),
	}
}

// network receptionist
type receptionist struct {
	mgr *SessionManager

	ctx    context.Context // TODO:
	cancel context.CancelFunc
}

func (r *receptionist) EnsureSession(id document.ID) *Session {
	session := NewSession(id, nil)
	r.mgr.SetSession(session)
	return session
}

// IConnHandle
func (r *receptionist) ConnDone(conn *tjnet.Conn) <-chan struct{} {
	return r.ctx.Done()
}

func (r *receptionist) OnConnClose(conn *tjnet.Conn) {
	log.Debugf("OnConnClose %s", conn.RemoteAddr())
	session := r.mgr.GetSessionByConn(conn)
	if session != nil {
		session.stale = true
		session.staleTime = util.Now()
	}
}

func (r *receptionist) OnConnPacket(request *tjnet.Packet, conn *tjnet.Conn) {
	util.SimpleTry(func() {
		t := GetTaskByURL(request.Url())
		if t == nil {
			log.Debugf("unknown %s url", request.Url())
			conn.Close()
			return
		}

		if err := util.MsgUnpack(request.Body(), t); err != nil {
			log.Warningf("OnConnPacket request MsgUnpack err %v", err)
			conn.Close()
			return
		}

		if p, ok := t.(prepare); ok {
			p.prepare(Context{mgr: r.mgr, conn: conn})
		}

		var response Response
		var battle *Battle
		session := r.mgr.GetSessionByConn(conn) // if new connection, session is nil by connection query

		if t.Url() != "/onlinefight/net/test" {
			if session != nil {
				battle = session.battle
				if battle == nil {
					response = &clientResponse{Err: ErrNoBattle.Error(), closed: true}
				}
			} else {
				response = &clientResponse{Err: ErrNoSession.Error(), closed: true}
			}
		}

		ctx := Context{
			mgr:     r.mgr,
			conn:    conn,
			session: session,
			battle:  battle,
		}

		if response == nil {
			response = t.Run(ctx)
		}

		pack := tjnet.NewAckUrlPacket(request)
		if data, err := util.MsgPack(response); err != nil {
			pack.SetFlag(true, tjnet.ErrACKBit)
		} else {
			pack.SetBody(data)
		}
		conn.SendPacket(pack)

		suffix := fmt.Sprintf("%s %s, %v %s", conn.RemoteAddr(), request.Url(), t, response.Error())
		if session != nil {
			if battle != nil {
				log.Infof("session %s battle %s %s", session.id, battle.id, suffix)
			} else {
				log.Infof("session %s %s", session.id, suffix)
			}
		} else {
			log.Infof("unidentified %s", suffix)
		}

		if response.Over() {
			log.Debugf("close connection %s, %s error %s", conn.RemoteAddr(), request.Url(), response.Error())
			conn.Close()
		}
		if f, ok := t.(finish); ok {
			f.finish(ctx)
		}

	}, func(err interface{}) {
		log.Warningf("OnConnPacket err %r", err)
		conn.Close()
	})
}

package redpacket

import (
	"sync"
	"tjgame/document"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/cross"
)

type Manager struct {
	cross.Coordinator

	container  service.IContainer
	key        string
	builder    *Builder
	plays      map[int]*RedPacket // 是否缓存
	gameToPlay map[string]*RedPacket

	lock sync.RWMutex
}

func NewRedPacketManager() *Manager {
	return &Manager{gameToPlay: make(map[string]*RedPacket)}
}

func (m *Manager) init(s *Service) {
	m.container = s.Container()
	m.Coordinator.SetContainer(m.container)
	m.key = s.Name()
	m.builder = s.builder
	m.plays = make(map[int]*RedPacket)
}

func (m *Manager) onGameCheck(id int, plays map[document.Integer][]string) {
	log.Info("CrossRedPacketManager game check start")

	onInitPlays := make(map[*RedPacket][]string)
	for k, games := range plays {
		group := int(k)
		var play *RedPacket
		play = m.getPlay(group)
		if play == nil {
			play = m.builder.NewCrossRedPacketGlobal(m.key, group)
			play.init(m.container, m)
			m.addPlay(play)
		}

		if play.isOver() {
			cross.OnCrossFishingServiceCheck(m.Coordinator, m.key, Name, games, func() {
				log.Infof("CrossRedPacketManager cross %v group %v games %v check ok", m.key, group, games)
				//play.onInit(games)
				onInitPlays[play] = games
			})
			log.Info("CrossRedPacketManager game check finished")
		} else {
			log.Infof("CrossRedPacketManager cross %v group %v games %v not over", m.key, group, games)
		}
	}
	log.Infof("%v", onInitPlays)
	for play, games := range onInitPlays {
		play.onInit(id, games)
		m.addGameToPlay(play)
	}
}

func (m *Manager) addPlay(play *RedPacket) {
	m.lock.Lock()
	defer m.lock.Unlock()

	m.plays[play.Group()] = play
}

func (m *Manager) getPlay(group int) *RedPacket {
	m.lock.RLock()
	defer m.lock.RUnlock()

	return m.plays[group]
}

func (m *Manager) addGameToPlay(play *RedPacket) {
	m.lock.Lock()
	defer m.lock.Unlock()

	var status string
	var games []string
	util.WithGuard(play, func() {
		status = play.Status()
		games = play.Servers()
	})

	if status == "closed" {
		return
	}

	for _, gameKey := range games {
		m.gameToPlay[gameKey] = play
	}
}

func (m *Manager) getPlayByGame(gameKey string) *RedPacket {
	m.lock.RLock()
	defer m.lock.RUnlock()

	return m.gameToPlay[gameKey]
}

func (m *Manager) clearGameToPlay(games []string) {
	m.lock.Lock()
	defer m.lock.Unlock()

	for _, gameKey := range games {
		delete(m.gameToPlay, gameKey)
	}
}

func (m *Manager) crossRedPacketGameAdd(groupID document.Integer, gameKeys []string) (bool, error) {
	group := int(groupID)
	play := m.getPlay(group)
	if play == nil {
		return false, ErrGroupPlayNotExist
	}

	play.Lock()
	defer play.Unlock()

	games := play.Servers()
	for _,gameKey := range gameKeys {
		games = append(games, gameKey)
	}
	play.SetServers(games)
	return true, nil
}
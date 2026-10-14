package unionqa

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
	plays      map[int]*UnionQA
	gameToPlay map[string]*UnionQA

	lock sync.RWMutex
}

func NewCrossUnionQAManager() *Manager {
	return &Manager{gameToPlay: make(map[string]*UnionQA)}
}

func (m *Manager) init(s *Service) {
	m.container = s.Container()
	m.Coordinator.SetContainer(m.container)
	m.key = s.Name()
	m.builder = s.builder
	m.plays = make(map[int]*UnionQA)
}

func (m *Manager) onGameCheck(id int, plays map[document.Integer][]string) {
	log.Info("CrossUnionQAManager game check start")

	onInitPlays := make(map[*UnionQA][]string)
	for k, games := range plays {
		group := int(k)
		var play *UnionQA
		play = m.getPlay(group)
		if play == nil {
			play = m.builder.NewCrossUnionQAGlobal(m.key, group)
			play.init(m.container, m)
			m.addPlay(play)
		}

		if play.isOver() {
			cross.OnCrossFishingServiceCheck(m.Coordinator, m.key, Name, games, func() {
				log.Infof("CrossUnionQAManager cross %v group %v games %v check ok", m.key, group, games)
				onInitPlays[play] = games
				m.clearGameToPlay(games)
			})
			log.Info("CrossUnionQAManager game check finished")
		} else {
			log.Infof("CrossUnionQAManager cross %v group %v games %v not over", m.key, group, games)
		}
	}

	for play, games := range onInitPlays {
		play.onInit(id, games)
		log.Infof("CrossUnionQAManager cross %v games %v", m.key, games)
		m.addGameToPlay(play)
	}
}

func (m *Manager) addPlay(play *UnionQA) {
	m.lock.RLock()
	defer m.lock.RUnlock()

	m.plays[play.Group()] = play
}

func (m *Manager) getPlay(group int) *UnionQA {
	m.lock.RLock()
	defer m.lock.RUnlock()

	return m.plays[group]
}

func (m *Manager) getPlayByGame(gameKey string) *UnionQA {
	m.lock.RLock()
	defer m.lock.RUnlock()

	return m.gameToPlay[gameKey]
}

func (m *Manager) clearGameToPlay(games []string) {
	m.lock.RLock()
	defer m.lock.RUnlock()

	for _, gameKey := range games {
		delete(m.gameToPlay, gameKey)
	}
}

func (m *Manager) addGameToPlay(play *UnionQA) {
	m.lock.RLock()
	defer m.lock.RUnlock()

	var round string
	var games []string
	util.WithGuard(play, func() {
		round = play.Round()
		games = play.Servers()
	})

	for _, gameKey := range games {
		m.gameToPlay[gameKey] = play
	}
}

func (m *Manager) startCrossUnionQA(groupID document.Integer, gameKey string) (string, error) {
	group := int(groupID)
	play := m.getPlay(group)
	if play == nil {
		return "", ErrGroupPlayNotExist
	}

	play.Lock()
	defer play.Unlock()

	games := play.Servers()
	games = append(games, gameKey)
	play.SetServers(games)
	return play.Key(), nil
}

func (m *Manager) closeCrossUnionQA(gameKey string) (bool, error) {
	play := m.getPlayByGame(gameKey)
	if play == nil {
		return false, ErrGroupPlayNotExist
	}
	play.Lock()
	defer play.Unlock()

	games := play.Servers()
	var servers []string
	for _, game := range games {
		if game != gameKey {
			servers = append(servers, game)
		}
	}
	play.SetServers(servers)
	return true, nil
}

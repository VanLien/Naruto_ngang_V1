package skyscraper

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
	plays      map[int]*Skyscraper // 是否缓存
	gameToPlay map[string]*Skyscraper

	lock sync.RWMutex
}

func NewSkyscraperManager() *Manager {
	return &Manager{gameToPlay: make(map[string]*Skyscraper)}
}

func (m *Manager) init(s *Service) {
	m.container = s.Container()
	m.Coordinator.SetContainer(m.container)
	m.key = s.Name()
	m.builder = s.builder
	m.plays = make(map[int]*Skyscraper)
}

func (m *Manager) onGameCheck(id int, plays map[document.Integer][]string) {
	log.Info("SkyscraperManager game check start")

	onInitPlays := make(map[*Skyscraper][]string)
	for k, games := range plays {
		group := int(k)
		var play *Skyscraper
		play = m.getPlay(group)
		if play == nil {
			play = m.builder.NewSkyscraperGlobal(m.key, group)
			play.init(m.container, m)
			m.addPlay(play)
		}

		if play.isOver() {
			cross.OnCrossFishingServiceCheck(m.Coordinator, m.key, Name, games, func() {
				log.Infof("SkyscraperManager cross %v group %v games %v check ok", m.key, group, games)
				//play.onInit(games)
				onInitPlays[play] = games
			})
			log.Info("SkyscraperManager game check finished")
		} else {
			log.Infof("SkyscraperManager cross %v group %v games %v not over", m.key, group, games)
		}
	}
	log.Infof("%v", onInitPlays)
	for play, games := range onInitPlays {
		play.onInit(id, games)
		m.addGameToPlay(play)
	}
}

func (m *Manager) addPlay(play *Skyscraper) {
	m.lock.RLock()
	defer m.lock.RUnlock()

	m.plays[play.Group()] = play
}

func (m *Manager) getPlay(group int) *Skyscraper {
	m.lock.RLock()
	defer m.lock.RUnlock()

	return m.plays[group]
}

func (m *Manager) getPlayByGame(gameKey string) *Skyscraper {
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

func (m *Manager) addGameToPlay(play *Skyscraper) {
	m.lock.RLock()
	defer m.lock.RUnlock()

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

func (m *Manager) startSkyscraper(groupID document.Integer, gameKey string) (bool, error) {
	group := int(groupID)
	play := m.getPlay(group)
	if play == nil {
		return false, ErrGroupPlayNotExist
	}

	play.Lock()
	defer play.Unlock()

	games := play.Servers()
	games = append(games, gameKey)
	play.SetServers(games)
	return true, nil
}

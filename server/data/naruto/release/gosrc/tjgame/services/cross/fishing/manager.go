package fishing

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
	plays      map[int]*Fishing
	gameToPlay map[string]*Fishing

	lock sync.RWMutex
}

func NewCrossFishingManager() *Manager {
	return &Manager{gameToPlay: make(map[string]*Fishing)}
}

func (m *Manager) init(s *Service) {
	m.container = s.Container()
	m.Coordinator.SetContainer(m.container)
	m.key = s.Name()
	m.builder = s.builder
	m.plays = make(map[int]*Fishing)
}

func (m *Manager) onGameCheck(plays map[document.Integer][]string) {
	log.Info("CrossFishingManager game check start")

	onInitPlays := make(map[*Fishing][]string)
	for k, games := range plays {
		group := int(k)
		var play *Fishing
		play = m.getPlay(group)
		if play == nil {
			play = m.builder.NewCrossFishingGlobal(m.key, group)
			play.init(m.container, m)
			m.addPlay(play)
		}

		if play.isOver() {
			cross.OnCrossFishingServiceCheck(m.Coordinator, m.key, Name, games, func() {
				log.Infof("CrossFishingManager cross %v group %v games %v check ok", m.key, group, games)
				//play.onInit(games)
				onInitPlays[play] = games
			})
			log.Info("CrossFishingManager game check finished")
		} else {
			log.Infof("CrossFishingManager cross %v group %v games %v not over", m.key, group, games)
		}
	}

	for play, games := range onInitPlays {
		play.onInit(games)
		m.addGameToPlay(play)
	}
}

func (m *Manager) addPlay(play *Fishing) {
	m.lock.RLock()
	defer m.lock.RUnlock()

	m.plays[play.Group()] = play
}

func (m *Manager) getPlay(group int) *Fishing {
	m.lock.RLock()
	defer m.lock.RUnlock()

	return m.plays[group]
}

func (m *Manager) getPlayByGame(gameKey string) *Fishing {
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

func (m *Manager) addGameToPlay(play *Fishing) {
	m.lock.RLock()
	defer m.lock.RUnlock()

	var round string
	var games []string
	util.WithGuard(play, func() {
		round = play.Round()
		games = play.Servers()
	})

	if round == "closed" {
		return
	}

	for _, gameKey := range games {
		m.gameToPlay[gameKey] = play
	}
}

package ranking

import (
	"sync"
	"tjgame/document"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/cross"
)

type PlayGame struct {
	plays      map[int]Ranker // 是否缓存
	gameToPlay map[string]Ranker
}

type Manager struct {
	cross.Coordinator

	container service.IContainer
	key       string
	builder   *Builder
	playGame  map[string]PlayGame

	lock sync.RWMutex
}

func NewRankingManager() *Manager {
	return &Manager{playGame: make(map[string]PlayGame)}
}

func (m *Manager) init(s *Service) {
	m.container = s.Container()
	m.Coordinator.SetContainer(m.container)
	m.key = s.Name()
	m.builder = s.builder
}

func (m *Manager) onGameCheck(gamePlay string, id int, plays map[document.Integer][]string) {
	log.Info("%s game check start", gamePlay)

	onInitPlays := make(map[Ranker][]string)
	for k, games := range plays {
		group := int(k)
		var play Ranker
		play = m.getPlay(gamePlay, group)
		if play == nil {
			play = m.builder.NewRankGlobal(gamePlay, m.key, group)
			play.init(m.container, m)
			m.addPlay(gamePlay, play)
		}

		if play.isOver() {
			gamePlay2Game := Name + "_" + gamePlay  // 排行榜都带前缀，game那边可以统一处理
			cross.OnCrossFishingServiceCheck(m.Coordinator, m.key, gamePlay2Game, games, func() { // 通知game对应的排行榜开了
				log.Infof("%sManager cross %v group %v games %v check ok", gamePlay, m.key, group, games)
				onInitPlays[play] = games
			})
			log.Info("%sManager game check finished", gamePlay)
		} else {
			log.Infof("%sManager cross %v group %v games %v not over", gamePlay, m.key, group, games)
		}
	}
	log.Infof("%v", onInitPlays)
	for play, games := range onInitPlays {
		play.onInit(id, games)
		m.addGameToPlay(gamePlay, play)
	}
}

func (m *Manager) addPlay(gamePlay string, play Ranker) {
	m.lock.RLock()
	defer m.lock.RUnlock()

	if _, ok := m.playGame[gamePlay]; !ok {
		m.playGame[gamePlay] = PlayGame{
			plays:      make(map[int]Ranker),
			gameToPlay: make(map[string]Ranker),
		}
	}
	m.playGame[gamePlay].plays[play.Group()] = play
}

func (m *Manager) getPlay(gamePlay string, group int) Ranker {
	m.lock.RLock()
	defer m.lock.RUnlock()
	return m.playGame[gamePlay].plays[group]
}

func (m *Manager) getPlayByGame(gameKey, gamePlay string) Ranker {
	m.lock.RLock()
	defer m.lock.RUnlock()

	return m.playGame[gamePlay].gameToPlay[gameKey]
}

func (m *Manager) clearGameToPlay(gamePlay string, games []string) {
	m.lock.RLock()
	defer m.lock.RUnlock()

	for _, gameKey := range games {
		delete(m.playGame[gamePlay].gameToPlay, gameKey)
	}
}

func (m *Manager) addGameToPlay(gamePlay string, play Ranker) {
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
	if _, ok := m.playGame[gamePlay]; !ok {
		m.playGame[gamePlay] = PlayGame{
			plays:      make(map[int]Ranker),
			gameToPlay: make(map[string]Ranker),
		}
	}
	for _, gameKey := range games {
		m.playGame[gamePlay].gameToPlay[gameKey] = play
	}
}

func (m *Manager) startRanking(gamePlay string, groupID document.Integer, gameKey string) (bool, error) {
	group := int(groupID)
	play := m.getPlay(gamePlay, group)
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

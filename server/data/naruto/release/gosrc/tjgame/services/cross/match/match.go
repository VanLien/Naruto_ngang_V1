package match

import (
	"strings"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/cross"
	"tjgame/services/cross/fishing"
	"tjgame/services/cross/huodongboss"
	"tjgame/services/cross/ranking"
	"tjgame/services/cross/redpacket"
	"tjgame/services/cross/skyscraper"
	"tjgame/services/cross/unionqa"
)

type Match struct {
	*scheme.CrossMatchObject

	container service.IContainer
	key       string
	builder   *Builder

	services     map[string]int      // value openday
	serviceToSrc map[string][]string // value [srcKey1, srcKey2...]

	serverCheckStatus int // 1 进行中，0 结束
}

var (
	CrossFishingClosedTime = util.Time{Hour: 23} // 钓鱼大赛结束时间
	CrossRankingNewMethod  = "RankingNewPlays"
	SupportServiceNames    = map[string]string{
		fishing.Name:     "CrossFishingNewPlays",
		huodongboss.Name: "HuoDongBossNewPlays",
		unionqa.Name:     "CrossUnionQANewPlays",
		redpacket.Name:   "CrossRedPacketNewPlays",
		skyscraper.Name:  "SkyscraperNewPlays",
	}
	Services2Server = map[string]string{}
)

func initPlayRankings() {
	for rank := range ranking.PlayRankings {
		SupportServiceNames[rank] = CrossRankingNewMethod
		Services2Server[rank] = ranking.Name
	}
}

func (m *Match) init(s *Service) {
	m.Lock()
	defer m.Unlock()

	m.container = s.Container()
	m.key = s.Name()
	m.builder = s.builder

	initPlayRankings()
}

func (m *Match) startServiceCheck() {
	now := util.Now()
	date := util.Date2int(now)
	time5 := util.DateTimeCombine(date, 5, 0, 0)
	duration := time5.Sub(now)
	if duration <= 0 {
		m.onServerCheckStart()
		duration = time5.Add(util.OneDay).Sub(now)
	}
	log.Infof("CrossMatch next %v, onServiceCheck", duration)
	time.AfterFunc(duration, m.startServiceCheck)
}

func (m *Match) onServerCheckStart() {
	log.Infof("CrossMatch onServerCheckStart")

	// 1. 确定今日是否有玩法需要开启
	today := util.Todaydate2int()
	config := csv.GetConfig()
	need := false
	for _, cfg := range config.Cross.Service {
		if SupportServiceNames[cfg.Service] != "" && cfg.Date == today {
			need = true
			break
		}
	}
	if !need {
		log.Infof("today %d not need check", today)
		return
	}

	// 2. 收集所有game以及玩法cross

	m.Lock()
	m.serverCheckStatus = 1
	m.services = make(map[string]int)
	m.serviceToSrc = make(map[string][]string)
	m.Unlock()

	t := float64(util.DateTimeCombine(util.Date2int(util.Now()), 5, 0, 0).Unix())
	err := service.Notify("CrossMatchServerCheck", m.key, t)
	if err != nil {
		log.Warningf("CrossMatch onServerCheckStart err %v", err)
	}
	//time.AfterFunc(time.Minute, m.onServerCheckEnd)
	time.AfterFunc(time.Second*15, m.onServerCheckEnd)
}

func (m *Match) onServerCheckEnd() {
	pairs := m.onMatchStart()
	m.onMatchFinish(pairs)
}

type matchgroup struct {
	id      int      // csv_id
	servers []string // game service key
	service string   // cross service key
	group   int
}

func (m *Match) onMatchStart() map[[2]string][]*matchgroup {
	m.Lock()
	defer m.Unlock()
	m.serverCheckStatus = 0
	today := util.Todaydate2int()
	config := csv.GetConfig()

	log.Infof("CrossMatch.onMatchStart date %d", today)

	matched := make(map[string]map[string]bool) // key is service name (crossfishing)
	automatch := make(map[[2]string]int)        // {id: (service, channel)}
	pairs := make(map[[2]string][]*matchgroup)  // 匹配组合

	for id, cfg := range config.Cross.Service {
		if SupportServiceNames[cfg.Service] != "" && cfg.Date == today && m.isValidServiceChannel(cfg.Service, cfg.Cross, today) {
			if _, ok := matched[cfg.Service]; !ok {
				matched[cfg.Service] = make(map[string]bool)
			}
			key := [2]string{cfg.Service, cfg.Cross} // 这里cfg.Cross就是channel
			if _, ok := pairs[key]; !ok {
				pairs[key] = make([]*matchgroup, 0, 8)
			}
			// 1. 优先配置里的固定匹配组合
			if len(cfg.Servers) > 0 { // 固定组合
				pairs[key] = append(pairs[key], &matchgroup{id: id, servers: cfg.Servers.ToStringSlice()})
				for _, v := range cfg.Servers {
					server := v.(string)
					matched[cfg.Service][server] = true
				}
			} else {
				automatch[key] = id
			}
		}
	}

	// 2. 自动匹配games
	for key, id := range automatch {
		checkService := key[0]
		checkChannel := key[1]
		// 过滤有效game
		games := make([]string, 0, 8)
		for key := range m.services {
			if matched[checkService][key] {
				continue
			}
			name, channel, _ := service.SplitServiceName(key)
			if channel != checkChannel {
				continue
			}
			if name == "game" || name == "gamemerge" {
				// 开服天数判断
				if checkService == fishing.Name {
					if m.services[key] < GetConfig().CrossFishingConfig.servOpenDays {
						continue
					}
				} else if checkService == unionqa.Name {
					if m.services[key] < GetConfig().CrossUnionQAServOpenDays {
						continue
					}
				}
				games = append(games, key)
			}
		}
		var groups []*matchgroup
		if checkService == fishing.Name {
			groups = crossfishingAutomatch(id, games)
		} else if checkService == huodongboss.Name {
			groups = huodongBossAutoMatch(id, games)
		} else if checkService == unionqa.Name {
			groups = crossUnionQAAutoMath(id, games)
		} else if checkService == redpacket.Name {
			groups = crossRedPacketAutoMatch(id, games)
		} else if checkService == skyscraper.Name {
			groups = crossSkyscraperAutoMatch(id, games)
		} else if checkService == ranking.CrossBraveChallengeRanking || checkService == ranking.CrossNormalBraveChallengeRanking{
			groups = crossCrossBraveChallengeRankingAutoMatch(id, games)
		} else if checkService == ranking.CrossHorseRaceRanking {
			groups = crossCrossHorseRaceRankingAutoMatch(id, games)
		} else if checkService == ranking.CrossVolleyballRanking {
			groups = crossVolleyballRankingAutoMatch(id, games)
		} else if checkService == ranking.CrossShavediceRanking {
			groups = crossShavediceRankingAutoMatch(id, games)
		}
		pairs[key] = append(pairs[key], groups...)
	}

	popGroups := [][2]string{}
	// 3. 分配cross
	for key, groups := range pairs {
		checkService := key[0]
		if v, ok := Services2Server[checkService]; ok {
			checkService = v
		}
		checkChannel := key[1]

		// 获取有效cross
		crosses := make([]string, 0, 8)
		for key := range m.services {
			name, channel, _ := service.SplitServiceName(key)
			if channel != checkChannel {
				continue
			}
			if name == checkService {
				crosses = append(crosses, key)
			}
		}
		crosses = sortServices(crosses)
		num := len(crosses)
		if num == 0 {
			popGroups = append(popGroups, key)
			continue
		}
		idx := 0
		log.Infof("key %v, total cross %d, groups %d", key, num, len(groups))
		for i, group := range groups {
			group.group = i + 1
			group.service = crosses[idx]
			if idx == num-1 {
				idx = 0
			} else {
				idx++
			}
		}

		checkService = key[0] // 此处重新获取一遍，以防被修改
		if checkService == fishing.Name {
			db := m.GetLockedDB()
			db.CrossFishingLastDate[checkChannel] = today
			m.SetCrossFishingLastDate(db.CrossFishingLastDate)
		} else if checkService == huodongboss.Name {
			db := m.GetLockedDB()
			db.HuoDongBossLastDate[checkChannel] = today
			m.SetHuoDongBossLastDate(db.HuoDongBossLastDate)
		} else if checkService == unionqa.Name {
			db := m.GetLockedDB()
			db.CrossUnionQALastDate[checkChannel] = today
			m.SetCrossUnionQALastDate(db.CrossUnionQALastDate)
		} else if checkService == redpacket.Name {
			db := m.GetLockedDB()
			db.CrossRedPacketLastDate[checkChannel] = today
			m.SetCrossRedPacketLastDate(db.CrossRedPacketLastDate)
		} else if checkService == skyscraper.Name {
			db := m.GetLockedDB()
			db.SkyscraperLastDate[checkChannel] = today
			m.SetSkyscraperLastDate(db.SkyscraperLastDate)
		} else if _, ok := ranking.PlayRankings[checkService]; ok {
			db := m.GetLockedDB()
			if db.PlayRankingsLastDate[checkService] == nil {
				db.PlayRankingsLastDate[checkService] = make(map[string]int)
			}
			db.PlayRankingsLastDate[checkService][checkChannel] = today
			m.SetPlayRankingsLastDate(db.PlayRankingsLastDate)
		}
	}

	for _, key := range popGroups {
		log.Infof("pop key %v, groups %d", key, len(pairs[key]))
		delete(pairs, key)
	}

	return pairs
}

func (m *Match) onMatchFinish(pairs map[[2]string][]*matchgroup) {
	log.Infof("CrossMatch.onMatchFinish")
	for key, groups := range pairs {
		serviceName := key[0]
		method := SupportServiceNames[serviceName]
		for _, group := range groups {
			servers := make([]string, 0, len(group.servers))
			for _, key := range group.servers {
				srcServKeys, ok := m.serviceToSrc[key]
				if ok {
					servers = append(servers, srcServKeys...)
				} else {
					servers = append(servers, key)
				}
			}
			log.Infof("service %s method %s id %d group %d servers %v", group.service, method, group.id, group.group, servers)
			if method != CrossRankingNewMethod {
				m.onNotifyCross(group.service, method, group.id, map[document.Integer][]string{document.Integer(group.group): servers})
			} else {
				m.onNotifyCrossRanking(group.service, method, serviceName, group.id, map[document.Integer][]string{document.Integer(group.group): servers})
			}
		}
	}
}

func crossfishingAutomatch(id int, games []string) []*matchgroup {
	size := GetConfig().CrossFishingConfig.GroupSize
	return matchingMethod1(id, games, size)
}

func crossRedPacketAutoMatch(id int, games []string) []*matchgroup {
	log.Infof("CrossMatch.crossRedPacketAutoMatch")
	size := GetConfig().CrossRedPacketGroupSize
	return matchingMethod2(id, games, size)
}

func crossSkyscraperAutoMatch(id int, games []string) []*matchgroup {
	log.Infof("CrossMatch.crossSkyscraperAutoMatch")
	size := GetConfig().SkyscraperGroupSize
	return matchingMethod2(id, games, size)
}

func crossCrossBraveChallengeRankingAutoMatch(id int, games []string) []*matchgroup {
	log.Infof("CrossMatch.crossCrossBraveChallengeRankingAutoMatch")
	size := GetConfig().CrossBraveChallengeGroupSize
	num := len(games)
	games = sortServices(games)
	groups := make([]*matchgroup, 0, num/size+1)
	if size > num { // 不够分组直接一组
		servers := make([]string, len(games))
		copy(servers, games)
		groups = append(groups, &matchgroup{id: id, servers: servers})
	} else {
		for len(games) >= size {
			servers := make([]string, len(games[:size]))
			copy(servers, games[:size])
			groups = append(groups, &matchgroup{id: id, servers: servers})
			games = games[size:]
		}
		// 多余 game一组
		if len(groups) > 0 {
			groups = append(groups, &matchgroup{id: id, servers: games})
		}
	}
	return groups
}

func crossVolleyballRankingAutoMatch(id int, games []string) []*matchgroup {
	log.Infof("CrossMatch.crossVolleyballRankingAutoMatch")
	size := GetConfig().CrossVolleyballGroupSize
	return matchingMethod1(id, games, size)
}

func crossShavediceRankingAutoMatch(id int, games []string) []*matchgroup {
	log.Infof("CrossMatch.crossShavediceRankingAutoMatch")
	size := GetConfig().CrossShavediceGroupSize
	return matchingMethod1(id, games, size)
}

func crossCrossHorseRaceRankingAutoMatch(id int, games []string) []*matchgroup {
	log.Infof("CrossMatch.crossCrossHorseRaceRankingAutoMatch")
	size := GetConfig().CrossHorseRaceGroupSize
	return matchingMethod1(id, games, size)
}

func huodongBossAutoMatch(id int, games []string) []*matchgroup {
	size := GetConfig().HuodongBossGroupSize
	reserve := GetConfig().HuodongBossReserve
	games = sortServices(games)
	num := len(games)
	groups := make([]*matchgroup, 0, num/size+1)
	if size > num { // 不够分组直接一组
		servers := make([]string, len(games))
		copy(servers, games)
		groups = append(groups, &matchgroup{id: id, servers: servers})
	} else {
		for len(games) >= size && len(games) > reserve {
			servers := make([]string, len(games[:size]))
			copy(servers, games[:size])
			groups = append(groups, &matchgroup{id: id, servers: servers})
			games = games[size:]
		}
		// 当分到最后剩余的跨服数量小于一定值（由配置决定），剩余的组按照平分的方式，得到最后的两个跨服组
		idx := len(games) / 2
		servers := make([]string, len(games[:idx]))
		copy(servers, games[:idx])
		groups = append(groups, &matchgroup{id: id, servers: servers})
		servers = make([]string, len(games[idx:]))
		copy(servers, games[idx:])
		groups = append(groups, &matchgroup{id: id, servers: servers})
	}
	return groups
}

func crossUnionQAAutoMath(id int, games []string) []*matchgroup {
	size := GetConfig().CrossUnionQAGroupSize
	return matchingMethod1(id, games, size)
}

// 匹配方式1: 按size均分，不够分组直接一组， 若有多余的随机加入分组
func matchingMethod1(id int, games []string, size int) []*matchgroup {
	num := len(games)
	groups := make([]*matchgroup, 0, num/size+1)
	if size > num { // 不够分组直接一组
		servers := make([]string, len(games))
		copy(servers, games)
		groups = append(groups, &matchgroup{id: id, servers: servers})
	} else {
		for len(games) >= size {
			servers := make([]string, len(games[:size]))
			copy(servers, games[:size])
			groups = append(groups, &matchgroup{id: id, servers: servers})
			games = games[size:]
		}
		// 多余 game 随机加入分组
		for len(games) > 0 {
			for _, group := range groups {
				game := games[0]
				games = games[1:]
				group.servers = append(group.servers, game)
				if len(games) == 0 {
					break
				}
			}
		}
	}
	return groups
}

// 匹配方式2: 按size均分，不够分组直接一组， 若不足 2*size，均分为两组
func matchingMethod2(id int, games []string, size int) []*matchgroup {
	num := len(games)
	games = sortServices(games)
	groups := make([]*matchgroup, 0, num/size+1)
	if size > num { // 不够分组直接一组
		servers := make([]string, len(games))
		copy(servers, games)
		groups = append(groups, &matchgroup{id: id, servers: servers})
	} else {
		for len(games) >= 2*size || len(games) == size {
			servers := make([]string, len(games[:size]))
			copy(servers, games[:size])
			groups = append(groups, &matchgroup{id: id, servers: servers})
			games = games[size:]
		}
		// 不足 2*size，均分为两组
		if len(games) > 0 {
			halfSize := len(games) / 2
			servers := make([]string, len(games[:halfSize]))
			copy(servers, games[:halfSize])
			groups = append(groups, &matchgroup{id: id, servers: servers})

			servers = make([]string, len(games[halfSize:]))
			copy(servers, games[halfSize:])
			groups = append(groups, &matchgroup{id: id, servers: servers})
		}
	}
	return groups
}

func (m *Match) onNotifyCross(name string, method string, id int, servers map[document.Integer][]string) {
	if err := cross.ContainerServices(m.container, name); err != nil {
		log.Warningf("CrossMatch.onNotifyCross cross %s not existed", name)
	}
	if _, err := service.Call(m.container.GetService(name), method, id, servers); err != nil {
		log.Warningf("CrossMatch.onNotifyCross cross %s call %s id %d servers %v error %s", name, method, id, servers, err)
	}
}

func (m *Match) onNotifyCrossRanking(name string, method string, gamePlay string, id int, servers map[document.Integer][]string) {
	if err := cross.ContainerServices(m.container, name); err != nil {
		log.Warningf("CrossMatch.onNotifyCrossRanking cross %s not existed", name)
	}
	if _, err := service.Call(m.container.GetService(name), method, gamePlay, id, servers); err != nil {
		log.Warningf("CrossMatch.onNotifyCrossRanking cross %s call %s id %d servers %v error %s", name, method, id, servers, err)
	}
}

func (m *Match) onServerCheckBack(serverKey string, srcServKeys []string, openDays int) {
	m.Lock()
	defer m.Unlock()

	if m.serverCheckStatus == 0 {
		log.Infof("onServerCheckBack check end %v timeout", serverKey)
		return
	}

	m.services[serverKey] = openDays
	if len(srcServKeys) > 0 {
		m.serviceToSrc[serverKey] = srcServKeys
	}
	log.Debugf("onServerCheckBack %s openday %d", serverKey, openDays)
}

func (m *Match) isValidServiceChannel(name string, channel string, today int) bool {
	if strings.Contains(channel, ".") {
		return false
	}
	if name == fishing.Name {
		db := m.GetLockedDB()
		if db.CrossFishingLastDate[channel] == today {
			return false
		}
		if CrossFishingClosedTime.CombineDateInt(today).Sub(util.Now()) <= 0 {
			return false
		}
	} else if name == huodongboss.Name {
		db := m.GetLockedDB()
		if db.HuoDongBossLastDate[channel] == today {
			return false
		}
	} else if name == unionqa.Name {
		db := m.GetLockedDB()
		if db.CrossUnionQALastDate[channel] == today {
			return false
		}
	} else if name == redpacket.Name {
		db := m.GetLockedDB()
		if db.CrossRedPacketLastDate[channel] == today {
			return false
		}
	} else if name == skyscraper.Name {
		db := m.GetLockedDB()
		if db.SkyscraperLastDate[channel] == today {
			return false
		}
	} else if _, ok := ranking.PlayRankings[name]; ok {
		db := m.GetLockedDB()
		if db.PlayRankingsLastDate[name][channel] == today {
			return false
		}
	}
	return true
}

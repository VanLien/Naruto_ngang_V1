package cross

import (
	"encoding/json"
	"io/ioutil"
	"strings"
	"tjgame/csv"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	tjutil "tjgame/server_framework/tj/util"
)

func readAllServers(lang string) []string {
	games := make([]struct {
		Key string `codec:"key"`
	}, 0, 64)
	data, err := ioutil.ReadFile("../login/conf/game.json")
	if err == nil {
		err = json.Unmarshal(data, &games)
	}
	if err != nil {
		return nil
	}
	servers := make([]string, 0, 64)
	for _, s := range games {
		_, language, _ := service.SplitServiceName(s.Key)
		if language == lang {
			servers = append(servers, s.Key)
		}
	}
	return servers
}

func OnServiceCheck(coordinator Coordinator, key string, transaction string, start func(id int, key string, services []string)) {
	today := tjutil.Todaydate2int()
	log.Infof("%s transaction %s OnServiceCheck %d", key, transaction, today)

	// cross需要处理协商过程
	ids := make([]int, 0, 8)
	config := csv.GetConfig()
	for id, cfg := range config.Cross.Service {
		// log.Infof("[chanlong] OnServiceCheck: transaction=%s cfg.Service=%s cfg.Date=%s cfg.Cross=%s",transaction,cfg.Service,cfg.Date,cfg.Cross)
		//if cfg.Service != transaction || cfg.Date != today {
		if cfg.Service != transaction {
			continue
		}
		if cfg.Cross == "" || cfg.Cross == key {
			ids = append(ids, id)
		}
	}

	length := len(ids)

	// log.Infof("[chanlong] OnServiceCheck | length=%s",length)
	if length == 1 {
		cfg := config.Cross.Service[ids[0]]
		services := cfg.Servers.ToStringSlice()
		if strings.ToLower(services[0]) == "all" { // 支持 all 配置
			_, lang, _ := service.SplitServiceName(cfg.Cross)
			services = readAllServers(lang)
			if services == nil {
				log.Warning("onServiceCheck finished, no services, check csv")
				return
			}
		}

		if err := coordinator.dynamicAddServices(services); err != nil {
			log.Warningf("dynamicAddServices %v failed, %v", services, err)
		} else {
			// note: stuck if game service not ready
			for {
				log.Infof("[liemia] onServiceCheck FOR | services=%s",services)

				if ret, err := coordinator.TransactionCommit(services, key, transaction); err == nil {
					// log.Infof("transaction_commit %s %v", key, ret)
					log.Infof("transaction_commit OK")
					if ret {
						start(cfg.ID, key, services)
					}
					break
				} else {
					//log.Warningf("transaction_commit %s error, %v", key, err)
					log.Infof("transaction_commit ERR")
				}

			}
		}

	} else if length > 1 {
		log.Warningf("%s transaction %s duplicative, %v", key, transaction, ids)
	}

	log.Infof("onServiceCheck finished")
}

func OnCrossFishingServiceCheck(coordinator Coordinator, key string, transaction string, services []string, callback func()) {
	if err := coordinator.dynamicAddServices(services); err != nil {
		log.Warningf("dynamicAddServices %v failed, %v", services, err)
	} else {
		for {
			if ret, err := coordinator.TransactionCommit(services, key, transaction); err == nil {
				log.Infof("transaction_commit %s %v %v", key, ret, services)
				if ret {
					callback()
				}
				break
			} else {
				log.Warningf("transaction_commit %s error, %v", key, err)
			}
		}
	}
}

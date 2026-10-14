package main

import (
	"flag"
	"fmt"
	"net/http"
	"tjgame/server_framework/tj/util"
	anti_cheat "tjgame/services/anti-cheat"

	"github.com/prometheus/client_golang/prometheus/promhttp"

	"tjgame/server_framework/tj"
	"tjgame/server_framework/tj/conf"
	"tjgame/server_framework/tj/log"
)

func main() {
	var name string
	var limit int
	var scripts string
	var agent string
	flag.StringVar(&name, "config", "agent.dev.1", "config name")
	flag.IntVar(&limit, "limit", 4, "max agent limit")
	flag.StringVar(&scripts, "scripts", "", "game scripts path")
	flag.StringVar(&agent, "agent", "", "agent binary path")
	flag.Parse()

	c := conf.LoadDefine(name, &Define{})
	define := c.(*Define)
	if define.Debug {
		log.Init(name, log.DEBUG)
	} else {
		log.Init(name, log.INFO)
	}
	log.Infof("%#v", define)
	anti_cheat.SetMaxAgent(limit)
	anti_cheat.SetAgentBinary(agent)
	anti_cheat.SetScriptPath(scripts)

	localIP := util.GetLocalIP()
	addr := fmt.Sprintf("%s:2112", localIP)
	http.Handle("/metrics", promhttp.Handler())
	log.Infof("metrics listen: %s", addr)
	go http.ListenAndServe(addr, nil)

	s := tj.NewServerFramework(NewServer(*define))
	s.Start()
}

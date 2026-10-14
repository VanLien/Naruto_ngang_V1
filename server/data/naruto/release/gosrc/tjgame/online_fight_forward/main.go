package main

import (
	"flag"
	"fmt"
	"net/http"
	"tjgame/csv"
	"tjgame/server_framework/tj"
	"tjgame/server_framework/tj/conf"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
	"tjgame/services/cross/onlinefight/forward"

	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func main() {
	var name string
	var address string
	var scripts string
	var agent string
	var language string
	var metricsAddress string
	flag.StringVar(&name, "config", "online_fight_forward.dev.1", "config name")
	flag.StringVar(&address, "address", "0.0.0.0:0", "listen address")
	flag.StringVar(&scripts, "scripts", "", "game scripts path")
	flag.StringVar(&agent, "agent", "", "agent binary path")
	flag.StringVar(&language, "language", "cn", "language")
	flag.StringVar(&metricsAddress, "metrics-address", "", "<addr>:<port> to listen on for prometheus metrics")
	flag.Parse()

	c := conf.LoadDefine(name, &Define{})
	define := c.(*Define)
	if define.Debug {
		log.Init(name, log.DEBUG)
	} else {
		log.Init(name, log.INFO)
	}
	log.Infof("%#v", define)
	define.queryIp()
	forward.SetDebug(define.Debug)
	forward.SetAgentBinary(agent)
	forward.SetScriptPath(scripts)

	if err := csv.Init("./", language, false); err != nil {
		panic(err)
	}
	util.InitTimeZoneAndDailyRefreshHour(language)
	tj.SetLanguage(language)

	if metricsAddress == "" {
		localIP := util.GetLocalIP()
		//metricsAddress = fmt.Sprintf("%s:2113", localIP)
		metricsAddress = fmt.Sprintf("%s:2112", localIP)
	}
	http.Handle("/metrics", promhttp.Handler())
	log.Infof("metrics listen: %s", metricsAddress)
	go http.ListenAndServe(metricsAddress, nil)

	s := tj.NewRudpServerFramework(NewServer(*define))
	s.Init(address)
	s.Start()
}

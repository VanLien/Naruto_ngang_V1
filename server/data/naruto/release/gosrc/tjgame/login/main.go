package main

import (
	"flag"
	"fmt"
	"tjgame/server_framework/tj"
	"tjgame/server_framework/tj/conf"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
)

var (
	Branch    string
	Commit    string
	BuildTime string
	GoVersion string
)

func main() {
	var configName string
	var version bool
	var language string
	flag.StringVar(&configName, "config", "login", "config name")
	flag.StringVar(&language, "language", "cn", "language")
	flag.BoolVar(&version, "v", false, "-v")
	flag.Parse()
	if version {
		fmt.Printf("Branch: %s\nBuild: %s\nBuild Time: %s\nGo Version: %s\n", Branch, Commit, BuildTime, GoVersion)
		return
	}

	c := conf.LoadDefine(configName, &Define{})
	define := c.(*Define)

	if define.Debug {
		log.Init(configName, log.DEBUG)
	} else {
		log.Init(configName, log.INFO)
	}
	log.Infof("%#v", define)

	util.InitTimeZoneAndDailyRefreshHour(language)
	tj.SetLanguage(language)

	serv := tj.NewTCPServerFramework(NewServer(*define, language))
	serv.Init(define.Addr)
	serv.Start()
}

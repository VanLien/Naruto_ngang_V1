package main

import (
	"flag"
	"fmt"
	"tjgame/csv"
	"tjgame/server_framework/tj"
	"tjgame/server_framework/tj/conf"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
	"tjgame/services"
)

var (
	Branch    string
	Commit    string
	BuildTime string
	GoVersion string
)

func main() {
	var name string
	var version bool
	var nocsv bool
	var language string

	flag.StringVar(&name, "config", "cross.dev.1", "config name")
	flag.BoolVar(&version, "v", false, "version")
	flag.BoolVar(&nocsv, "nocsv", false, "not use csv config")
	flag.StringVar(&language, "language", "cn", "language")
	flag.Parse()
	if version {
		fmt.Printf("Branch: %s\nBuild: %s\nBuild Time: %s\nGo Version: %s\n", Branch, Commit, BuildTime, GoVersion)
		return
	}

	c := conf.LoadDefine(name, &services.Define{})
	define := c.(*services.Define)
	if define.Debug {
		log.Init(name, log.DEBUG)
	} else {
		log.Init(name, log.INFO)
	}
	log.Infof("%#v", define)

	if !nocsv {
		if err := csv.Init("./", language, false); err != nil {
			panic(err)
		}
	}

	util.InitTimeZoneAndDailyRefreshHour(language)
	tj.SetLanguage(language)

	s := tj.NewServerFramework(NewServer(*define))
	s.Start()
}

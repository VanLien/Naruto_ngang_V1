package main

import (
	"flag"
	"tjgame/tools/transition"
)

func main() {
	var uid int
	var rid string
	var serv string
	var filename string

	flag.IntVar(&uid, "uid", 0, "role uid")
	flag.StringVar(&rid, "rid", "", "role id")
	flag.StringVar(&serv, "serv", "", "serv name")
	flag.StringVar(&filename, "filename", "", "file name")
	flag.Parse()

	transition.Download(serv, rid, uid, filename)
}

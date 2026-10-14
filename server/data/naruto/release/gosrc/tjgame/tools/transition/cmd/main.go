package main

import (
	"flag"
	"tjgame/tools/transition"
)

func main() {
	var model string
	var filename string

	flag.StringVar(&model, "model", "query", "model")
	flag.StringVar(&filename, "filename", "", "file name")
	flag.Parse()

	if model == "upload" {
		transition.Upload(filename)
		return
	}
	transition.Run(model, filename)
}

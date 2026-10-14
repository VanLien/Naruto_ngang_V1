package util

import (
	"net/http"
	"time"

	"tjgame/server_framework/tj/log"
)

func LogHTTPReq(req *http.Request, st time.Time) {
	log.Infof("%s %s (%s) %.2f ms", req.Method, req.RequestURI, req.RemoteAddr, float64(time.Now().Sub(st).Nanoseconds())/1000000)
}

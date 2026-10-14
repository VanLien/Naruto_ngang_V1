package main

import (
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"net/http"
	"os"
	"strconv"
	"sync"
	"sync/atomic"
	"time"

	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
)

type server struct {
	httpMux    *http.ServeMux
	httpServer *http.Server
}

type task struct {
	id        int64
	account   string
	msg       string
	content   string
	words     []string
	err       string
	errWord   string
	ban       bool
	hash      uint64
	process   int
	onlytrain bool
	finished  int64
	dest      int64
	resultCh  chan bool

	servName string
	role     string
	level    int
	vip      int
}

func (t *task) setDest(dest int64) {
	atomic.StoreInt64(&t.dest, dest)
}

func (t *task) isFinished() bool {
	return atomic.LoadInt64(&t.finished) >= atomic.LoadInt64(&t.dest)
}

func (t *task) errResult(err, word string) {
	log.Warningf("task %d %d %d %s by %s", t.id, t.process, t.finished, err, word)

	// 0 -> 2 * the first err
	// ok: 1 -> 3 * the first err
	dest := atomic.LoadInt64(&t.dest)
	if atomic.AddInt64(&t.finished, dest) < 2*dest {
		t.err = err
		t.errWord = word
		go func() {
			t.resultCh <- false
			newDisableSentence <- t
		}()
	}
}

func (t *task) okResult() {
	// 0 -> 1
	// 1 -> 2 * all is ok
	// err: > 2
	dest := atomic.LoadInt64(&t.dest)
	if atomic.AddInt64(&t.finished, 1) == dest {
		t.err = ""
		t.errWord = ""
		go func() {
			t.resultCh <- true
		}()
	}
}

func (t *task) qqResult(result bool, err, word string) {
	if result {
		t.err = ""
		t.errWord = ""
	} else {
		log.Warningf("task %d %d %d qq-%s by %s", t.id, t.process, t.finished, err, word)

		t.err = err
		t.errWord = word
	}

	go func() {
		t.resultCh <- result
		if result == false {
			newDisableSentence <- t
		}
	}()
}

var TaskParallel = 4

var TaskCounter int64 = 0
var WordCountMap = &sync.Map{}

func (s *server) sayhello(w http.ResponseWriter, req *http.Request) {
	st := time.Now()
	defer func() {
		log.Infof("%s %s (%s) %.2f ms", req.Method, req.RequestURI, req.RemoteAddr, float64(time.Now().Sub(st).Nanoseconds())/1000000)
	}()

	dir, _ := os.Getwd()
	io.WriteString(w, "hello, world!\n")
	io.WriteString(w, dir+"\n")
	io.WriteString(w, fmt.Sprintf("Branch: %s\nBuild: %s\nBuild Time: %s\nGo Version: %s\n", Branch, Commit, BuildTime, GoVersion))
	io.WriteString(w, fmt.Sprint(req.Header))
}

func (s *server) check(w http.ResponseWriter, req *http.Request) {
	st := time.Now()
	defer func() {
		log.Infof("%s %s (%s) %.2f ms", req.Method, req.RequestURI, req.RemoteAddr, float64(time.Now().Sub(st).Nanoseconds())/1000000)
	}()

	msg := ""
	if req.Method == "POST" {
		body, err := ioutil.ReadAll(req.Body)
		req.Body.Close()
		if err == nil {
			msg = string(body)
		}
	}

	req.ParseForm()
	if len(msg) == 0 {
		msg = req.FormValue("msg")
	}

	log.Debug("msg", msg)
	if len(msg) == 0 {
		w.WriteHeader(404)
		return
	}
	//u, _ := req.URL.Parse(req.RequestURI)
	//servName: u.Query()["server"][0]

	account := req.FormValue("account")
	servName := req.FormValue("server")
	role := req.FormValue("role")
	levelS := req.FormValue("level")
	vipS := req.FormValue("vip")
	level := 0
	vip := 0
	if levelS != "" {
		level, _ = strconv.Atoi(levelS)
	}
	if vipS != "" {
		vip, _ = strconv.Atoi(vipS)
	}

	t := &task{
		id:        atomic.AddInt64(&TaskCounter, 1),
		account:   account,
		msg:       msg,
		content:   msg,
		words:     nil,
		err:       "",
		errWord:   "",
		ban:       false,
		process:   0,
		onlytrain: false,
		finished:  0,
		dest:      1,
		resultCh:  make(chan bool),

		servName: servName,
		role:     role,
		level:    level,
		vip:      vip,
	}

	//                                   -> SimilarCh -> SimilarSearchCh
	// t -> TaskCh -> JieBaCh -> CheckCh                                 -> resultCh -> resultCh (qq)
	//                                   -> FreqCh
	log.Infof("task %d %d msg %s", t.id, t.process, t.msg)
	TaskCh <- t

	result := <-t.resultCh
	defer close(t.resultCh)

	for _, word := range t.words {
		iv, ok := WordCountMap.LoadOrStore(word, 1)
		if ok {
			v := iv.(int)
			WordCountMap.Store(word, v+1)
		}
	}

	//if result {
	//	QQCh <- t
	//	result = <-t.resultCh
	//}
	//
	//if t.err != "" {
	//	result = false
	//}

	ret := make(map[string]interface{})
	ret["ret"] = result
	ret["error"] = t.err
	ret["ban"] = t.ban
	b, _ := json.Marshal(ret)
	w.Header().Set("Content-Type", "text/json")
	io.WriteString(w, util.Byte2String(b))
}

func (s *server) stats(w http.ResponseWriter, req *http.Request) {
	st := time.Now()
	defer func() {
		log.Infof("%s %s (%s) %.2f ms", req.Method, req.RequestURI, req.RemoteAddr, float64(time.Now().Sub(st).Nanoseconds())/1000000)
	}()

	WordCountMap.Range(func(key, value interface{}) bool {
		io.WriteString(w, fmt.Sprintf("%s: %d\n", key, value))
		return true
	})
}

func (s *server) msg(w http.ResponseWriter, req *http.Request) {
	st := time.Now()
	defer func() {
		log.Infof("%s %s (%s) %.2f ms", req.Method, req.RequestURI, req.RemoteAddr, float64(time.Now().Sub(st).Nanoseconds())/1000000)
	}()

	io.WriteString(w, "ok")
}

func (s *server) initHTTP(addr string) {
	s.httpMux.HandleFunc("/", s.sayhello)
	s.httpMux.HandleFunc("/check", s.check)
	s.httpMux.HandleFunc("/stats", s.stats)
	s.httpMux.HandleFunc("/msg", s.msg)
	s.httpServer = &http.Server{Addr: addr, Handler: s.httpMux}
}

func (s *server) start() {
	log.Infof("http listen %s start", s.httpServer.Addr)
	err := s.httpServer.ListenAndServe()
	if err != nil {
		// may be 'Server closed'
		if err != http.ErrServerClosed {
			log.Warning("http listen", err)
		}
	}
}

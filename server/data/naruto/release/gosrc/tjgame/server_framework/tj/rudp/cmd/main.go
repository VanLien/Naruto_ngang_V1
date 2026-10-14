package main

import (
	"bufio"
	"math/rand"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"syscall"
	"time"

	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/rudp"

	_ "net/http/pprof"
)

func reverse(s []byte) []byte {
	for i, j := 0, len(s)-1; i < j; i, j = i+1, j-1 {
		s[i], s[j] = s[j], s[i]
	}
	return s
}

func server(addr string) {
	listener, err := rudp.Listen(addr)
	if err != nil {
		panic(err)
	}

	go func() {
		for {
			session, err := listener.AcceptRudp()
			if err != nil {
				panic(err)
			}
			log.Info("new session", session)

			go func(s *rudp.Connection) {
				reader := bufio.NewReader(s)
				//buff := make([]byte, rudp.MaxPackage)
				for {
					str, err := reader.ReadString('\n')
					log.Infof("server read %s", str, err)
					if err != nil {
						s.Close()
						break
					}
					str = strings.Replace(str, "client", "server", 1)
					n, err := s.Write([]byte(str))
					log.Info("server write", n, err, str)
					if err != nil {
						s.Close()
						break
					}

					//n, err := s.Read(buff)
					//log.Info("server read", n, err, buff[:n])
					//if err != nil {
					//	s.Close()
					//	break
					//}
					//reverse(buff[:n])
					//n, err = s.Write(buff[:n])
					//log.Info("server write", n, err, buff[:n])
					//if err != nil {
					//	s.Close()
					//	break
					//}
				}
			}(session)
		}
	}()
}

func test(addr string) {
	go server(addr)

	// client
	s, err := rudp.Dial(addr)
	if err != nil {
		panic(err)
	}
	for i := 0; i < 5; i++ {
		p := make([]byte, 8)
		n, _ := rand.Read(p)
		msg := p[:n]
		n, err := s.Write(msg)
		log.Info("client write", n, err, msg)
		buff := make([]byte, rudp.MaxPackage)
		n, err = s.Read(buff)
		log.Info("client read", n, err, buff[:n])
	}
}

func test2(addr string) {
	go server(addr)

	// client
	s, err := rudp.Dial(addr)
	if err != nil {
		panic(err)
	}
	num := 10
	for i := 0; i < num; i++ {
		p := make([]byte, 8)
		n, _ := rand.Read(p)
		msg := p[:n]
		n, err := s.Write(msg)
		log.Info("client write", n, err, msg)
	}

	size := 0
	for size < (num * 8) {
		buff := make([]byte, rudp.MaxPackage)
		n, err := s.Read(buff)
		log.Info("client read", n, err, buff[:n])
		size += n
	}
	log.Infof("read length %d", size)
}

func test3(addr string) {
	go server(addr)

	// client
	s, err := rudp.Dial(addr)
	if err != nil {
		panic(err)
	}

	time.Sleep(time.Millisecond * 100 * 70)
	s.Close()
}

func main() {
	go func() {
		log.Info(http.ListenAndServe("localhost:6060", nil))
	}()

	rand.Seed(time.Now().UnixNano())
	addr := "127.0.0.1:1234"

	//test(addr)
	//test2(addr)
	//test3(addr)

	server(addr)

	signalChannel := make(chan os.Signal, 1)
	signal.Notify(signalChannel, syscall.SIGTERM, syscall.SIGINT)
	<-signalChannel
}

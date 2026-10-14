package rudp

import (
	"fmt"
	"testing"
	"time"
	"tjgame/server_framework/tj/log"
)

func TestConnection(t *testing.T) {
	log.Init("test", log.DEBUG)
	address := "127.0.0.1:1234"
	l, err := Listen(address)
	if err != nil {
		t.Fatal(err)
	}

	go func() {
		defer l.Close()

		for {
			c, err := l.AcceptRudp()
			if err != nil {
				break
			}
			go func(connection *Connection) {
				buffer := make([]byte, MaxPackage)
				for {
					n, err := connection.Read(buffer)
					if err != nil {
						t.Logf("read from client error %s", err)
						break
					}
					if n == 0 {
						continue
					}
					t.Logf("read from client, length %d", n)
				}
			}(c)
		}
	}()

	//total := 1
	total := 10
	c, err := Dial(address)
	if err != nil {
		panic(err)
	}
	for i := 0; i < total; i++ {
		b := []byte("hello from client")
		n, err := c.Write(b)
		fmt.Println(i, "client write", n, err)
	}

	time.Sleep(3 * time.Second)
	fmt.Println(defaultSnmp)
}

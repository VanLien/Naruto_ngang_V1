package tunnel

import (
	"context"
	"io"
	"io/ioutil"
	"log"
	"net"

	"golang.org/x/crypto/ssh"
)

type SSHTunnel struct {
	config *ssh.ClientConfig
	addr   string
	client *ssh.Client
}

func PrivateKeyFile(file string) ssh.AuthMethod {
	key, err := ioutil.ReadFile(file)
	if err != nil {
		log.Fatalf("key file %s not found", file)
		return nil
	}
	signer, err := ssh.ParsePrivateKey(key)
	if err != nil {
		log.Fatalf("key file %s parse error %v", file, err)
		return nil
	}
	return ssh.PublicKeys(signer)
}

// forward local
func (t *SSHTunnel) Forward(ctx context.Context, localAddr string, remoteAddr string) (string, error) {
	l, err := net.Listen("tcp", localAddr)
	if err != nil {
		return "", err
	}
	localAddr = l.Addr().String()

	go func() {
		defer l.Close()
		for {
			select {
			case <-ctx.Done():
				return
			default:
				conn, err := l.Accept()
				if err != nil {
					log.Printf("%s accpet error %s", localAddr, err)
					return
				}
				log.Printf("accepted %s (1 of 2)\n", conn.RemoteAddr())
				go t.forward(ctx, conn, remoteAddr)
			}
		}
	}()
	return localAddr, nil
}

func (t *SSHTunnel) forward(ctx context.Context, conn net.Conn, remoteAddr string) {
	remote, err := t.client.Dial("tcp", remoteAddr)
	if err != nil {
		log.Printf("client dial %s error %s", remoteAddr, err)
		return
	}
	log.Printf("connected to %s (2 of 2)\n", remoteAddr)

	go io.Copy(conn, remote)
	go io.Copy(remote, conn)

	go func() {
		<-ctx.Done()
		conn.Close()
		remote.Close()
	}()
}

func (t *SSHTunnel) Stop() {
	t.client.Close()
}

func NewSSHTunnel(addr string, config *ssh.ClientConfig) *SSHTunnel {
	client, err := ssh.Dial("tcp", addr, config)
	if err != nil {
		log.Panicf("dial %s, error %v", addr, err)
	}
	t := &SSHTunnel{
		config: config,
		addr:   addr,
		client: client,
	}
	return t
}

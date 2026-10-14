package rpc

import (
	"net"
	"net/rpc"
	"tjgame/server_framework/tj/service/caller"
	"sync/atomic"

	"tjgame/server_framework/tj/log"
	"tjgame/ugorji_go/codec"
)

// MsgpackRPCServer
type MsgpackRPCServer struct {
	*RPCFramework

	lis     net.Listener
	stopped bool
}

func (s *MsgpackRPCServer) Init(addr string) {
	l, err := net.Listen("tcp", addr)
	if err != nil {
		log.Panic("fail to create listener err:", err)
	}
	s.lis = l
}

func (s *MsgpackRPCServer) Start() {
	lis := s.lis
	if lis == nil {
		log.Panic("server not inited")
	}
	for !s.stopped {
		conn, err := lis.Accept()
		if err != nil {
			if !s.stopped {
				log.Warning("rpc accept err:", err)
			}
			s.stopped = true
			return
		}
		go s.ServeCodec(codec.MsgpackSpecRpc.ServerCodec(conn, &codec.MsgpackHandle{RawToString: true}))
	}
}

func (s *MsgpackRPCServer) Stop() {
	s.stopped = true
	s.lis.Close()
}

func NewMsgpackRPCServer() *MsgpackRPCServer {
	return &MsgpackRPCServer{
		RPCFramework: &RPCFramework{},
		stopped:      false,
	}
}

// MsgpackRPCClient
type MsgpackRPCClient struct {
	*rpc.Client

	addr         string
	reconnecting int32
	connected    int32
}

// 不重试，但下次请求时尝试重连
// 即不保证每个请求均得到远程响应，但远程恢复后可恢复rpc连接
func (c *MsgpackRPCClient) reconnect() {
	if atomic.CompareAndSwapInt32(&c.reconnecting, 0, 1) {
		atomic.StoreInt32(&c.connected, 0)
		log.Warning("rpc client reconnecting", c.addr)
		if c.Client != nil {
			c.Close()
		}
		conn, err := net.Dial("tcp", c.addr)
		if err == nil {
			c.Client = rpc.NewClientWithCodec(codec.MsgpackSpecRpc.ClientCodec(conn, &codec.MsgpackHandle{RawToString: true}))
			atomic.StoreInt32(&c.connected, 1)
			log.Warning("rpc client reconnect ok")
		} else {
			log.Warning("rpc client reconnect err", err)
		}
		atomic.StoreInt32(&c.reconnecting, 0)
	}
}

func (c *MsgpackRPCClient) Call(method string, result interface{}, args ...interface{}) (interface{}, error) {
	if atomic.LoadInt32(&c.connected) == 0 {
		c.reconnect()
		return nil, rpc.ErrShutdown
	}

	call := <-c.Client.Go(method, (codec.MsgpackSpecRpcMultiArgs)(args), result, make(chan *rpc.Call, 1)).Done
	if call.Error == rpc.ErrShutdown {
		c.reconnect()
	}
	return call.Reply, call.Error
}

func (c *MsgpackRPCClient) CallAsync(method string, result interface{}, args ...interface{}) <-chan *ResultInfo {
	ret := make(chan *ResultInfo, 1)
	if atomic.LoadInt32(&c.connected) == 0 {
		c.reconnect()
		ret <- &ResultInfo{
			Error: rpc.ErrShutdown,
		}
		close(ret)
		return ret
	}

	callChan := c.Client.Go(method, (codec.MsgpackSpecRpcMultiArgs)(args), result, make(chan *rpc.Call, 1)).Done
	go func() {
		call := <-callChan
		if call.Error == rpc.ErrShutdown {
			c.reconnect()
		}
		ret <- &ResultInfo{
			Error:  call.Error,
			Result: call.Reply,
		}
		close(ret)
	}()
	return ret
}

func (c *MsgpackRPCClient) ServiceCall(*caller.FuncServiceInfo, interface{}, ...interface{}) (interface{}, error) {
	log.Panic("msgpack rpc client no implement ServiceCall")
	return nil, nil
}

func NewMsgpackRPCClient(addr string) *MsgpackRPCClient {
	conn, err := net.Dial("tcp", addr)
	if err != nil {
		return &MsgpackRPCClient{
			addr:         addr,
			reconnecting: 0,
			connected:    0,
		}
	}
	return &MsgpackRPCClient{
		Client:       rpc.NewClientWithCodec(codec.MsgpackSpecRpc.ClientCodec(conn, &codec.MsgpackHandle{RawToString: true})),
		addr:         addr,
		reconnecting: 0,
		connected:    1,
	}
}

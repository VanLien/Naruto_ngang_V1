package nsq

import (
	"context"
	"errors"
	"fmt"
	"reflect"
	"sync"
	"sync/atomic"
	"time"
	"tjgame/server_framework/tj/util"

	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/rpc"
	"tjgame/server_framework/tj/service/caller"
	"tjgame/ugorji_go/codec"

	"github.com/nsqio/go-nsq"
)

const msgZombieDuration = time.Hour

var msgCount uint32
var msgIDMap sync.Map // map[msgID]ClientReqInfo
var msgLeastTime int64
var clientMap sync.Map // map[id]bool

var (
	ErrResultDecode = errors.New("nsqrpc/c: result decode error")
)

func getMsgID() uint32 {
	msgID := atomic.AddUint32(&msgCount, 1)
	if msgID > 1<<30 {
		atomic.CompareAndSwapUint32(&msgCount, msgID, 0)
	}
	return msgID
}

func cleanZombieMsg() {
	timer := time.NewTimer(msgZombieDuration)
	go func() {
		for {
			select {
			case <-timer.C:
				delta := msgZombieDuration
				if atomic.LoadInt64(&msgLeastTime) != 0 {
					var t int64 = 0
					now := time.Now()
					msgIDMap.Range(func(key, value interface{}) bool {
						msgID := key.(uint32)
						req := value.(ClientReqInfo)
						if now.Sub(req.ReqTime) > msgZombieDuration {
							log.Debugf("msg %d was zombie", msgID)
							msgIDMap.Delete(msgID)
							return true
						}
						lastTime := req.ReqTime.Unix()
						if t == 0 || t > lastTime {
							t = lastTime
						}
						return true
					})

					// for next loop
					atomic.StoreInt64(&msgLeastTime, t)
					delta = time.Now().Sub(time.Unix(t, 0))
					if delta > msgZombieDuration {
						delta = msgZombieDuration
					} else if delta < 10*time.Second {
						delta = time.Minute
					}
				}
				timer.Reset(delta)
			}
		}
	}()
}

type ClientReqInfo struct {
	RespChan  chan<- *rpc.ResultInfo
	ResultPtr interface{}
	ReqTime   time.Time // for clean zombie
}

// NSQRPCClient
type NSQRPCClient struct {
	defaultConfig *nsq.Config
	id            string
	nsqds         []string

	producer    *Producer
	consumer    *nsq.Consumer
	cancel      context.CancelFunc
	reqDoneChan chan *nsq.ProducerTransaction
	respChan    chan *RPCMessageRESP

	closed int32
	mutex  sync.Mutex
}

func (c *NSQRPCClient) Connect(nsqd ...string) {
	var err error
	c.nsqds = nsqd
	c.producer, err = NewWriter(c.nsqds, c.defaultConfig)
	if err != nil {
		log.Panicf("client %s could not create producer %v", c.id, nsqd)
	}
	c.producer.SetLogger(log.GetNSQLogger(), nsq.LogLevel(log.GetNSQLogLevel()))

	c.initResponseConsumer()

	// resp processor goroutine
	go func() {
	LOOP:
		for {
			select {
			case resp, ok := <-c.respChan:
				if ok {
					msgID := resp.MsgID
					val, ok := msgIDMap.Load(msgID)
					if !ok {
						// may be req broadcast, the same MsgID will be come back many times
						// but the result use the first one
						log.Warningf("msg %d no exist", msgID)
						continue
					}
					msgIDMap.Delete(msgID)
					req := val.(ClientReqInfo)
					req.RespChan <- c.unpackResp(resp, req.ResultPtr)
					close(req.RespChan)
					req.RespChan = nil
				} else {
					break LOOP
				}

			case nsqTran, ok := <-c.reqDoneChan:
				if ok {
					msgID := nsqTran.Args[0].(uint32)
					if nsqTran.Error != nil {
						val, ok := msgIDMap.Load(msgID)
						if !ok {
							continue
						}
						log.Warningf("msg %d pub error %s", msgID, nsqTran.Error)
						msgIDMap.Delete(msgID)
						req := val.(ClientReqInfo)
						req.RespChan <- &rpc.ResultInfo{
							Error: nsqTran.Error,
						}
						close(req.RespChan)
						req.RespChan = nil
					}
				}
			}
		}
	}()
}

func (c *NSQRPCClient) Close() {
	if !atomic.CompareAndSwapInt32(&c.closed, 0, 1) {
		return
	}

	c.cancel()
	c.producer.Stop()

	close(c.reqDoneChan)
	close(c.respChan)
	c.reqDoneChan = nil
	c.respChan = nil
}

func (c *NSQRPCClient) Call(method string, result interface{}, args ...interface{}) (interface{}, error) {
	log.Panic("nsq rpc client no implement Call")
	return nil, nil
}

func (c *NSQRPCClient) CallAsync(method string, result interface{}, args ...interface{}) <-chan *rpc.ResultInfo {
	log.Panic("nsq rpc client no implement CallAsync")
	return nil
}

func (c *NSQRPCClient) ServiceCall(info *caller.FuncServiceInfo, result interface{}, args ...interface{}) (interface{}, error) {
	// TODO: its not ok when CallAsync running, Close be called at same time
	if atomic.LoadInt32(&c.closed) != 0 {
		return nil, nil
	}

	method := info.Name
	if reflect.TypeOf(result).Kind() != reflect.Ptr {
		log.Warningf("method %s result need pointer", method)
		return nil, nil
	}

	if info.CallType == caller.Notify {
		c.Notify(method, args...)
		return nil, nil
	}

	// prepare
	msgID := getMsgID()
	topic := ClientTopic(info.CallType, info.ServiceID, method)
	data := PackMessageReq(msgID, c.id, method, args)

	var result2 interface{}
	var err error

	for {
		ret := make(chan *rpc.ResultInfo)
		t := time.Now()
		msgIDMap.Store(msgID, ClientReqInfo{ret, result, t})
		atomic.CompareAndSwapInt64(&msgLeastTime, 0, t.Unix())
		for {
			err := c.producer.PublishAsync(topic, data, c.reqDoneChan, msgID)
			if err == nil {
				break
			}
			log.Warningf("msg %d request err: %s", msgID, err)
			time.Sleep(time.Second * 2)
		}

		resp, ok := <-ret
		if !ok {
			err = caller.ErrCallException
			break
		}
		if resp.Error == nsq.ErrNotConnected {
			time.Sleep(time.Second * 2)
			continue
		}
		result2 = resp.Result
		err = resp.Error
		break
	}
	return result2, err
}

func (c *NSQRPCClient) Notify(method string, args ...interface{}) {
	if atomic.LoadInt32(&c.closed) != 0 {
		return
	}

	// prepare
	data := PackMessageNotify(method, args)
	topic := ClientNotifyTopic(method)

	err := c.producer.PublishAsync(topic, data, c.reqDoneChan, uint32(0))
	if err != nil {
		log.Warning("msg notify err:", err)
		return
	}
}

func (c *NSQRPCClient) unpackResp(resp *RPCMessageRESP, resultPtr interface{}) *rpc.ResultInfo {
	var err error
	if resp.Error() == "" {
		err = nil
		dec := codec.NewDecoderBytes(resp.Result(), handle)
		if err := dec.Decode(resultPtr); err != nil {
			log.Warning("result can not decode err:", err)
			return &rpc.ResultInfo{
				Error:  ErrResultDecode,
				Result: nil,
			}
		}
	} else {
		err = errors.New(resp.Error())
		resultPtr = nil
	}

	return &rpc.ResultInfo{
		Error:  err,
		Result: resultPtr,
	}
}

func (c *NSQRPCClient) initResponseConsumer() bool {
	// Notify no resp
	// RPC and Global are same topic and channel
	topic, channel := ClientRespTopicAndChannel(c.id)
	for _, addr := range c.nsqds {
		clients := getClientsNum(addr, topic, channel)
		if clients > 0 {
			log.Panicf("the consumer %s/%s already be consumed", topic, channel)
		}
	}
	consumer, err := nsq.NewConsumer(topic, channel, c.defaultConfig)
	if err != nil {
		log.Panicf("create client consumer %s/%s err: %s", topic, channel, err)
	}
	log.Infof("create client consumer %s/%s", topic, channel)
	consumer.SetLogger(log.GetNSQLogger(), nsq.LogLevel(log.GetNSQLogLevel()))

	// context manage
	ctx, cancel := context.WithCancel(context.Background())
	respCtx, respCancel := context.WithCancel(ctx)
	go func() {
		<-ctx.Done()
		respCancel()

		consumer.Stop()
	}()

	// subscribe resp-serviceMethod
	timeStamp := time.Now().UnixNano()
	consumer.AddConcurrentHandlers(nsq.HandlerFunc(func(message *nsq.Message) error {
		message.Finish()
		// ignore old resp
		// TODO: test maybe failed because datetime be changed in LAN
		_ = timeStamp
		// 		log.Debug(timeStamp - message.Timestamp)
		//if message.Timestamp < timeStamp {
		//	return nil
		//}
		resp, ok := UnpackMessage(message.Body).(*RPCMessageRESP)
		if ok {
			select {
			case <-respCtx.Done():
			default:
				c.respChan <- resp
			}
		}

		return nil
	}), concurrentMax)

	err = consumer.ConnectToNSQDs(c.nsqds)
	if err != nil {
		log.Warningf("could not connect nsqd %v err: %s", c.nsqds, err)
		cancel()
		return false
	}

	c.cancel = cancel
	c.consumer = consumer
	return true
}

func NewNSQRPCClient(containerID string) *NSQRPCClient {
	if _, ok := clientMap.Load(containerID); ok {
		panic(fmt.Sprintf("the client id %s already exited", containerID))
	}
	clientMap.Store(containerID, true)

	// nsq topic format [.a-zA-Z0-9_-]
	id := containerID
	if id[0] == '@' {
		id = "c_" + id[1:]
	}
	localIP := util.GetLocalIP()
	c := &NSQRPCClient{
		defaultConfig: NewConfig(fmt.Sprintf("%s/%s", localIP, id)),
		id:            id,
		reqDoneChan:   make(chan *nsq.ProducerTransaction, concurrentMax),
		respChan:      make(chan *RPCMessageRESP, concurrentMax),
		closed:        0,
	}
	return c
}

func init() {
	cleanZombieMsg()
}

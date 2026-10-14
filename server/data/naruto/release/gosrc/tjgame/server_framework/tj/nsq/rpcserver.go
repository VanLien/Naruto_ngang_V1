package nsq

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"net"
	"net/http"
	"net/rpc"
	"net/url"
	"reflect"
	"sync"
	"sync/atomic"
	"time"
	"tjgame/server_framework/tj/log"
	tjrpc "tjgame/server_framework/tj/rpc"
	"tjgame/server_framework/tj/service/caller"
	"tjgame/server_framework/tj/util"

	"github.com/nsqio/go-nsq"
)

const concurrentMax = 4

var (
	ErrParamsDecode   = errors.New("nsqrpc/s: params decode error")
	ErrMessageUnknown = errors.New("nsqrpc/s: message type unknown")
	ErrNotImplement   = errors.New("nsqrpc/s: no implement")
	NoReply           = errors.New("nsqrpc/s: no error but do not reply")

	NoResultType = reflect.TypeOf(&NoResult{})
)

type NoResult struct{}

type ReqInfo struct {
	MsgID       uint32
	ContainerID string
	ReqTime     time.Time // for clean zombie and log
}

type RespInfo struct {
	SeqID     uint64
	Error     string
	NoReply   bool
	ReplyPack []byte
}

type multiplexingHandler struct {
	topic   string
	channel string
	c       *nsq.Consumer

	reqChan     chan *RPCMessageREQ
	respChan    chan *RespInfo
	subReqChans map[string]chan *RPCMessageREQ

	notifyChan chan *RPCMessageNTF

	cancel context.CancelFunc
}

type reqAndRespInfo struct {
	topic string
	*ReqInfo
	*RespInfo
}

// NSQRPCServer
type NSQRPCServer struct {
	*NSQServer
	*tjrpc.RPCFramework

	backoff  sync.Map
	seqIDMap sync.Map // map[seqID]*ReqInfo
	seqCount uint64
	msgIDMap sync.Map // map[seqID]*reqAndRespInfo

	alias        map[string][]string
	methods      map[string]*caller.FuncServiceInfo
	topicHandler map[string]*multiplexingHandler

	respDoneChan chan *nsq.ProducerTransaction
}

func (s *NSQRPCServer) Register(rcvr interface{}) error {
	return s.RPCFramework.Register(rcvr)
}

func (s *NSQRPCServer) RegisterName(name string, rcvr interface{}) error {
	return s.RPCFramework.RegisterName(name, rcvr)
}

func (s *NSQRPCServer) RegisterServiceStub(svc tjrpc.IServiceReceiver, stub []*caller.FuncServiceInfo) error {
	methodsByRcvr := make(map[uintptr][]reflect.Method)
	rcvrMap := make(map[uintptr]tjrpc.IServiceReceiver)
	for _, info := range stub {
		k := reflect.ValueOf(info.Rcvr).Pointer()
		methodsByRcvr[k] = append(methodsByRcvr[k], info.Method)
		rcvr := info.Rcvr.(tjrpc.IServiceReceiver)
		rcvrMap[k] = rcvr
		// cache the method info for call type
		s.methods[fmt.Sprintf("%s|%s", rcvr.Name(), info.Name)] = info
	}
	// first register the svc
	k := reflect.ValueOf(svc).Pointer()
	if err := s.RPCFramework.RegisterService(svc, methodsByRcvr[k]); err != nil {
		return err
	}
	delete(rcvrMap, k)
	// svc may contain other rcvr
	for k, rcvr := range rcvrMap {
		if err := s.RPCFramework.RegisterService(rcvr, methodsByRcvr[k]); err != nil {
			return err
		}
	}
	return nil
}

func (s *NSQRPCServer) UnregisterService(svc tjrpc.IServiceReceiver) {
	array, ok := s.alias[svc.Name()]
	if !ok {
		array = make([]string, 0)
	}
	array = append(array, svc.Name())
	delete(s.alias, svc.Name())

	for topic, hdl := range s.topicHandler {
		hit := false
		for _, name := range array {
			if util.EndsWith(topic, name) {
				hit = true
				break
			}
		}
		if !hit {
			continue
		}

		delete(s.topicHandler, topic)

		hdl.cancel()
	}

	s.RPCFramework.UnregisterService(svc)
}

func (s *NSQRPCServer) AddServiceAlias(service, serviceID string) {
	array, ok := s.alias[service]
	if !ok {
		array = make([]string, 0)
	}
	s.alias[service] = append(array, serviceID)
}

func (s *NSQRPCServer) Start() {
	methods := s.RPCFramework.GetMethodNameAndReply()
	for _, method := range methods {
		info, methodInService := s.methods[fmt.Sprintf("%s|%s", method.Name, method.MethodName)]
		serviceMethod := fmt.Sprintf("%s.%s", method.Name, method.MethodName)
		if method.Name == "" {
			serviceMethod = method.MethodName
		}
		// service method no resolver prefix
		methodKey := method.MethodName
		// older msgpack-rpc style
		if !methodInService {
			info = &caller.FuncServiceInfo{
				ServiceID: s.containerID,
				CallType:  caller.RPC,
			}
			// msgpack-rpc will contain resolver prefix
			methodKey = serviceMethod
		}

		alias, ok := s.alias[method.Name]
		if !ok {
			alias = make([]string, 0)
		}
		alias = append(alias, info.ServiceID)

		for _, serviceID := range alias {
			log.Debugf("%s method %s for key %s", serviceID, method.MethodName, methodKey)
			if info.CallType == caller.Notify {
				if serviceID != info.ServiceID {
					continue
				}
				notifyChan := s.AddNotifyConsumer(serviceID, method.MethodName)
				go s.RPCFramework.ServeCodec(&NSQRPCServerCodec{
					serviceMethod: serviceMethod,
					server:        s,
					notifyChan:    notifyChan,
				})
			} else {
				reqGlobalChan, reqRPCChan, respChan := s.AddRequestConsumer(info.CallType, serviceID, method.MethodName, methodKey)
				go s.RPCFramework.ServeCodec(&NSQRPCServerCodec{
					serviceMethod: serviceMethod,
					server:        s,
					reqGlobalChan: reqGlobalChan,
					reqRPCChan:    reqRPCChan,
					respChan:      respChan,
					seqIDFunc:     s.getSeqID,
				})
			}
		}
	}

	go func() {
		for nsqTrans := range s.respDoneChan {
			msgID := nsqTrans.Args[0].(uint32)
			if nsqTrans.Error != nil {
				log.Warningf("msg %d response err: %s", msgID, nsqTrans.Error)
				if nsqTrans.Error == nsq.ErrNotConnected {
					if v, ok := s.msgIDMap.Load(msgID); ok {
						w := v.(reqAndRespInfo)
						// try again
						respChan := s.topicHandler[w.topic].respChan
						s.seqIDMap.Store(w.RespInfo.SeqID, w.ReqInfo)
						respChan <- w.RespInfo
					}
				}
			}
			s.msgIDMap.Delete(msgID)
		}
	}()

	s.NSQServer.Start()
}

// SeqID was abide by golang net/rpc
// MsgID was for our rpc framework logic
func (s *NSQRPCServer) getSeqID(req *RPCMessageREQ) uint64 {
	seqID := atomic.AddUint64(&s.seqCount, 1)
	if seqID > 1<<63 {
		atomic.CompareAndSwapUint64(&s.seqCount, seqID, 0)
	}
	s.seqIDMap.Store(seqID, &ReqInfo{req.MsgID, req.ContainerID(), time.Now()})
	return seqID
}

func (s *NSQRPCServer) AddRequestConsumer(typ caller.ServiceMethodType, serviceID, method, methodKey string) (<-chan *RPCMessageREQ, <-chan *RPCMessageREQ, chan<- *RespInfo) {
	reqChan, respChan, hdl := s.addRequestConsumer(typ, serviceID, method)
	if typ == caller.RPC {
		// first key is ServiceID, in addRequestConsumer
		// second key is method, in here
		if len(hdl.subReqChans) == 0 {
			// from ServiceID.* to [ServiceID][methodKey]
			go func() {
				for req := range reqChan {
					subReqChan, ok := hdl.subReqChans[req.Method()]
					if ok {
						subReqChan <- req
					} else {
						log.Warningf("method %s not in handler %s/%s", req.Method(), hdl.topic, hdl.channel)
					}
				}
			}()
		}
		// [topic] - [methodKey]
		subReqChan := make(chan *RPCMessageREQ, concurrentMax)
		hdl.subReqChans[methodKey] = subReqChan
		return nil, subReqChan, respChan
	}
	return reqChan, nil, respChan
}

func getClientsNum(nsqdAddr, topic, channel string) int {
	addr, err := net.ResolveTCPAddr("tcp", nsqdAddr)
	if err != nil {
		log.Panicf("nsqd addr %s format err: %s", nsqdAddr, err)
	}
	nsqdHTTP := fmt.Sprintf("%s:%d", addr.IP, 1+addr.Port)

	queryUrl := fmt.Sprintf("http://%s/stats?topic=%s&channel=%s&format=json", nsqdHTTP, url.QueryEscape(topic), url.QueryEscape(channel))
	resp, err := http.Get(queryUrl)
	if err != nil {
		log.Panicf("nsqd http %s get err: %s", queryUrl, err)
	}
	body, err := ioutil.ReadAll(resp.Body)
	resp.Body.Close()
	if err != nil {
		log.Panicf("nsqd http %s read err: %s", queryUrl, err)
	}
	if resp.StatusCode != 200 {
		log.Panicf("nsqd http %s code err: %d", queryUrl, resp.StatusCode)
	}

	log.Debug(queryUrl)
	log.Debug(string(body))

	stats := make(map[string]interface{})
	err = json.Unmarshal(body, &stats)
	if err != nil {
		log.Panicf("nsqd http %s unmarshal err: %d", queryUrl, err)
	}

	topics := stats["topics"].([]interface{})
	for _, v := range topics {
		tp := v.(map[string]interface{})
		if tp["topic_name"] == topic {
			//if iv, ok := util.MapGet(stats, "topics", 0, "channels", 0, "clients"); ok {
			if iv, ok := util.MapGet(tp, "channels", 0, "clients"); ok {
				if clients, ok := iv.([]interface{}); ok {
					for i, iv := range clients {
						client := iv.(map[string]interface{})
						log.Warningf("consumer %s/%s had %d client %s %s", topic, channel, i+1, client["client_id"], client["remote_address"])
					}
					return len(clients)
				}
			}
			break
		}
	}

	return 0
}

func (s *NSQRPCServer) addRequestConsumer(typ caller.ServiceMethodType, serviceID, method string) (<-chan *RPCMessageREQ, chan<- *RespInfo, *multiplexingHandler) {
	if s.started {
		log.Panic("nsq server already started")
	}

	// check if existed in local
	// rpc: serviceMethod is service id(many methods in one), channel always be same
	// global: serviceMethod is method(uniq in default), channel always be same
	topic, channel := ReqTopicAndChannel(typ, serviceID, method)
	if hdl, ok := s.topicHandler[topic]; ok {
		return hdl.reqChan, hdl.respChan, hdl
	}

	// check if existed in remote
	// RPC must be unique consumer <topic, channel>
	if typ == caller.RPC {
		for _, addr := range s.nsqds {
			clients := getClientsNum(addr, topic, channel)
			if clients > 0 {
				log.Panicf("the consumer %s/%s already be consumed", topic, channel)
			}
		}
	}

	c, err := nsq.NewConsumer(topic, channel, s.defaultConfig)
	if err != nil {
		log.Panicf("create server consumer %s/%s err: %s", topic, channel, err)
	}
	log.Infof("create server consumer %s/%s", topic, channel)
	c.SetLogger(log.GetNSQLogger(), nsq.LogLevel(log.GetNSQLogLevel()))

	// concurrentMax for socket recv and unpack

	// context manage
	ctx, cancel := context.WithCancel(context.Background())
	reqCtx, reqCancel := context.WithCancel(ctx)
	reqChan := make(chan *RPCMessageREQ, concurrentMax)
	respChan := make(chan *RespInfo, concurrentMax)
	go func() {
		<-ctx.Done()
		reqCancel()

		close(respChan)
		c.Stop()
	}()

	// subscribe req-serviceMethod
	c.AddConcurrentHandlers(nsq.HandlerFunc(func(message *nsq.Message) error {
		if v, ok := s.backoff.Load(topic); ok && v.(bool) == true {
			log.Warningf("topic %s logic backoff, message %s attempts %d", topic, message.ID, message.Attempts)
			message.Requeue(10 * time.Millisecond)
			return nil
		}
		req, ok := UnpackMessage(message.Body).(*RPCMessageREQ)
		if ok {
			select {
			case <-reqCtx.Done():
				// may be server closing, could not handle the message
				message.Requeue(-1)
				close(reqChan)
			default:
				// quick finish before logic run
				message.Finish()
				reqChan <- req
			}
		} else {
			message.Finish()
			log.Warningf("message %d unpack error, %s", message.ID, message.Body)
		}

		return nil
	}), concurrentMax)

	// publish resp-serviceMethod
	go func() {
		for respInfo := range respChan {
			v, ok := s.seqIDMap.Load(respInfo.SeqID)
			if !ok {
				log.Warningf("msg seq %d not exist", respInfo.SeqID)
				continue
			}
			s.seqIDMap.Delete(respInfo.SeqID)

			// req for broadcast
			if respInfo.NoReply {
				continue
			}

			reqInfo := v.(*ReqInfo)
			respData := PackMessageResp(reqInfo.MsgID, respInfo.Error, respInfo.ReplyPack)

			s.msgIDMap.Store(reqInfo.MsgID, reqAndRespInfo{
				topic:    topic,
				ReqInfo:  reqInfo,
				RespInfo: respInfo,
			})

			respTopic, _ := RespTopicAndChannel(typ, reqInfo.ContainerID)
			err := s.producer.PublishAsync(respTopic, respData, s.respDoneChan, reqInfo.MsgID)
			if err != nil {
				log.Warningf("msg %d response err: %s", reqInfo.MsgID, err)
				// try again
				s.seqIDMap.Store(respInfo.SeqID, reqInfo)
				go func(r *RespInfo) {
					respChan <- r
				}(respInfo)
				s.msgIDMap.Delete(reqInfo.MsgID)
			}
		}
	}()

	s.cancels = append(s.cancels, cancel)
	s.consumers = append(s.consumers, c)
	s.topicHandler[topic] = &multiplexingHandler{
		topic:       topic,
		channel:     channel,
		c:           c,
		reqChan:     reqChan,
		respChan:    respChan,
		subReqChans: make(map[string]chan *RPCMessageREQ),
		cancel:      cancel,
	}
	return reqChan, respChan, s.topicHandler[topic]
}

func (s *NSQRPCServer) AddNotifyConsumer(serviceID, method string) <-chan *RPCMessageNTF {
	if s.started {
		log.Panic("nsq server already started")
	}

	topic := ClientNotifyTopic(method)
	channel := serviceID
	c, err := nsq.NewConsumer(topic, channel, s.defaultConfig)
	if err != nil {
		log.Panicf("create server consumer %s/%s err: %s", topic, channel, err)
	}
	log.Infof("create server consumer %s/%s", topic, channel)
	c.SetLogger(log.GetNSQLogger(), nsq.LogLevel(log.GetNSQLogLevel()))

	// context manage
	ctx, cancel := context.WithCancel(context.Background())
	notifyCtx, notifyCancel := context.WithCancel(ctx)
	notifyChan := make(chan *RPCMessageNTF, concurrentMax)
	go func() {
		<-ctx.Done()
		notifyCancel()

		c.Stop()
	}()

	c.AddConcurrentHandlers(nsq.HandlerFunc(func(message *nsq.Message) error {
		message.Finish()
		notify, ok := UnpackMessage(message.Body).(*RPCMessageNTF)
		if ok {
			select {
			case <-notifyCtx.Done():
				close(notifyChan)
			default:
				notifyChan <- notify
			}
		}
		return nil
	}), concurrentMax)

	s.cancels = append(s.cancels, cancel)
	s.consumers = append(s.consumers, c)
	s.topicHandler[topic] = &multiplexingHandler{
		topic:      topic,
		channel:    channel,
		c:          c,
		notifyChan: notifyChan,
		cancel:     cancel,
	}
	return notifyChan
}

func (s *NSQRPCServer) Backoff(topic string, v bool) {
	log.Infof("topic %s Backoff %v", topic, v)
	s.backoff.Store(topic, v)
}

func NewNSQRPCServer(containerID string) *NSQRPCServer {
	return &NSQRPCServer{
		NSQServer:    NewNSQServer(containerID),
		RPCFramework: &tjrpc.RPCFramework{},
		alias:        make(map[string][]string),
		methods:      make(map[string]*caller.FuncServiceInfo),
		topicHandler: make(map[string]*multiplexingHandler),
		respDoneChan: make(chan *nsq.ProducerTransaction, concurrentMax),
	}
}

// NSQRPCServerCodec
type NSQRPCServerCodec struct {
	// ServiceMethod = serviceMethod[.channel]
	serviceMethod string
	server        *NSQRPCServer

	reqRPCChan    <-chan *RPCMessageREQ
	reqGlobalChan <-chan *RPCMessageREQ
	notifyChan    <-chan *RPCMessageNTF
	respChan      chan<- *RespInfo
	seqIDFunc     func(*RPCMessageREQ) uint64

	currentMessage interface{}
}

// in only one goroutine
func (c *NSQRPCServerCodec) ReadRequestHeader(req *rpc.Request) error {
	var notify *RPCMessageNTF
	var request *RPCMessageREQ

	ok := false
	select {
	case request, ok = <-c.reqRPCChan:
		if ok {
			c.currentMessage = request
			req.Seq = c.seqIDFunc(request)
		}
	case request, ok = <-c.reqGlobalChan:
		if ok {
			c.currentMessage = request
			req.Seq = c.seqIDFunc(request)
		}
	case notify, ok = <-c.notifyChan:
		if ok {
			c.currentMessage = notify
			req.Seq = 0
		}
	}
	if !ok {
		return io.EOF
	}

	// ServiceMethod for Name resolver
	req.ServiceMethod = c.serviceMethod
	return nil
}

func (c *NSQRPCServerCodec) ReadRequestBody(body interface{}) error {
	var params []byte
	switch msg := c.currentMessage.(type) {
	case *RPCMessageREQ:
		params = msg.Params()
	case *RPCMessageNTF:
		params = msg.Params()
	default:
		log.Warningf("unknown message type %T", c.currentMessage)
	}
	c.currentMessage = nil

	if params != nil {
		if err := UnpackParams(params, body); err != nil {
			log.Warning("params can not fill the body err:", err)
			return ErrParamsDecode
		}
		return nil
	}

	return ErrMessageUnknown
}

// WriteResponse must be safe for concurrent use by multiple goroutines.
func (c *NSQRPCServerCodec) WriteResponse(resp *rpc.Response, reply interface{}) error {
	if c.respChan == nil {
		return nil
	}

	replyFlag := true
	if len(resp.Error) > 0 {
		reply = nil
		if resp.Error == NoReply.Error() {
			replyFlag = false
		}
	}

	data := Pack(reply)
	c.respChan <- &RespInfo{
		resp.Seq,
		resp.Error,
		!replyFlag,
		data,
	}

	c.logResponse(resp, reply, replyFlag, len(data))
	return nil
}

func (c *NSQRPCServerCodec) logResponse(resp *rpc.Response, reply interface{}, replyFlag bool, l int) {
	costMS := "-ms"
	respFrom := ""
	if v, ok := c.server.seqIDMap.Load(resp.Seq); ok {
		reqInfo := v.(*ReqInfo)
		costMS = fmt.Sprintf("%s", time.Now().Sub(reqInfo.ReqTime))
		respFrom = fmt.Sprintf(" from %s", reqInfo.ContainerID)
	}

	if reply == nil && replyFlag {
		log.Warningf("ERR %s %d %s%s %+v", resp.ServiceMethod, resp.Seq, costMS, respFrom, resp.Error)
	} else {
		if replyFlag {
			log.Infof("RESP %s %d %dB %s%s", resp.ServiceMethod, resp.Seq, l, costMS, respFrom)
		} else {
			log.Infof("NOTIFY %s %s%s", resp.ServiceMethod, costMS, respFrom)
		}
	}
}

func (c *NSQRPCServerCodec) Close() error {
	return nil
}

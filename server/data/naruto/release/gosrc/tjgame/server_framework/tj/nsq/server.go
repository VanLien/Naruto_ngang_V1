package nsq

import (
	"context"
	"fmt"
	"tjgame/server_framework/tj/util"

	"tjgame/server_framework/tj/log"

	"github.com/nsqio/go-nsq"
)

// NSQServer
type NSQServer struct {
	defaultConfig     *nsq.Config
	nsqds             []string
	defaultNSQLookupD string
	containerID       string
	producer          *Producer
	consumers         []*nsq.Consumer
	cancels           []context.CancelFunc
	started           bool
	stopped           chan struct{}
}

func (s *NSQServer) Init(defaultNSQLookupD string, nsqd ...string) {
	localIP := util.GetLocalIP()
	config := NewConfig(fmt.Sprintf("%s%s", localIP, s.containerID))

	s.defaultConfig = config
	s.nsqds = nsqd
	s.defaultNSQLookupD = defaultNSQLookupD
}

//
// Examples:
//
//func (s *LobbyServer) OnStart() bool {
//	config := nsq.NewConfig()
//	s.nsq.Init(config, s.define.Key, "lobby", s.define.MainNSQD)
//	reqChan := s.nsq.AddConsumer("room_join", 6)
//
//	cnt := 0
//	go func() {
//		for msg := range reqChan {
//			cnt += 1
//			log.Debugf("Begin a message: %d %v", cnt, msg.MsgID)
//		}
//		log.Warning("test chan closed")
//		close(respChan)
//	}()
//
//	s.nsq.Init()
//	return true
//}
//
func (s *NSQServer) Start() {
	nsqlookupd := s.defaultNSQLookupD
	_ = nsqlookupd

	var err error
	s.producer, err = NewWriter(s.nsqds, s.defaultConfig)
	if err != nil {
		log.Panicf("could not connect nsqd %v err: %s", s.nsqds, err)
	}
	s.producer.SetLogger(log.GetNSQLogger(), nsq.LogLevel(log.GetNSQLogLevel()))

	// TODO: if in debug, the err "could not connected to lookupd" be raised, because i/o timeout
	for _, c := range s.consumers {
		err = c.ConnectToNSQDs(s.nsqds)
		// if serviceMethod not created, nsqlookupd query will be error
		//err = c.ConnectToNSQLookupd(nsqlookupd)
		if err != nil {
			log.Panicf("could not connect nsqd %v err: %s", s.nsqds, err)
		}
	}
	s.started = true
	<-s.stopped
}

func (s *NSQServer) Stop() {
	for _, cancel := range s.cancels {
		cancel()
	}
	s.producer.Stop()
	close(s.stopped)
}

// NOTE: `consumers` not safe in thread, see `NSQRPCClient.initResponseConsumer`
func (s *NSQServer) AddConsumer(topic string, concurrent int) <-chan *nsq.Message {
	if s.started {
		log.Panic("nsq server already started")
	}

	c, err := nsq.NewConsumer(topic, s.containerID, s.defaultConfig)
	if err != nil {
		log.Panicf("create consumer %s/%s err: %s", topic, s.containerID, err)
	}
	log.Infof("create consumer %s/%s", topic, s.containerID)
	c.SetLogger(log.GetNSQLogger(), nsq.LogLevel(log.GetNSQLogLevel()))

	// context manage
	ctx, cancel := context.WithCancel(context.Background())
	msgCtx, msgCancel := context.WithCancel(ctx)
	msgChan := make(chan *nsq.Message, concurrent)
	go func() {
		<-ctx.Done()
		msgCancel()

		close(msgChan)
		c.Stop()
	}()

	// subscribe req-serviceMethod
	c.AddConcurrentHandlers(nsq.HandlerFunc(func(message *nsq.Message) error {
		message.Finish()
		select {
		case <-msgCtx.Done():
		default:
			msgChan <- message
		}
		return nil
	}), concurrent)

	s.cancels = append(s.cancels, cancel)
	s.consumers = append(s.consumers, c)
	return msgChan
}

func NewNSQServer(containerID string) *NSQServer {
	return &NSQServer{
		containerID: containerID,
		consumers:   make([]*nsq.Consumer, 0, 6),
		started:     false,
		stopped:     make(chan struct{}),
	}
}

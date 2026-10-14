package nsq

import (
	"errors"
	"math/rand"
	"sync"
	"time"
	"tjgame/server_framework/tj/log"

	"github.com/nsqio/go-nsq"
)

var (
	ErrNoProducer = errors.New("no producer")
)

type Producer struct {
	addresses []string
	config    *nsq.Config
	producers sync.Map //map[string]*nsq.Producer
	weights   int32

	reconnectInterval time.Duration
}

func (w *Producer) Stop() {
	w.producers.Range(func(key, value interface{}) bool {
		producer := value.(*nsq.Producer)
		producer.Stop()
		return true
	})
}

func (w *Producer) PublishAsync(topic string, body []byte, doneChan chan *nsq.ProducerTransaction,
	args ...interface{}) error {
	var addr string
	var producer *nsq.Producer
	rnd := rand.Int31n(w.weights)
	w.producers.Range(func(key, value interface{}) bool {
		rnd -= 1
		if rnd <= 0 {
			addr = key.(string)
			producer = value.(*nsq.Producer)
			return false
		}
		return true
	})
	if producer == nil {
		return ErrNoProducer
	}
	err := producer.PublishAsync(topic, body, doneChan, args...)
	if err != nil {
		w.producers.Delete(addr)
		go func(address string) {
			for {
				log.Infof("%s attempting to reconnect in %v", address, w.reconnectInterval)
				time.Sleep(w.reconnectInterval)
				if producer, err := nsq.NewProducer(address, w.config); err == nil {
					if producer.Ping() == nil {
						w.producers.Store(address, producer)
						break
					} else {
						log.Warningf("reconnect %s, error %v", address, err)
					}
				} else {
					log.Warningf("reconnect %s, error %v", address, err)
				}
			}
		}(addr)
	}
	return err
}

func (w *Producer) SetLogger(l *log.NSQLogger, lvl nsq.LogLevel) {
	w.producers.Range(func(key, value interface{}) bool {
		producer := value.(*nsq.Producer)
		producer.SetLogger(l, lvl)
		return true
	})
}

func NewWriter(addresses []string, config *nsq.Config) (*Producer, error) {
	w := &Producer{
		addresses:         addresses,
		config:            config,
		reconnectInterval: time.Second * 5,
	}
	for _, addr := range addresses {
		if producer, err := nsq.NewProducer(addr, w.config); err != nil {
			return nil, err
		} else {
			w.producers.Store(addr, producer)
		}
	}
	w.weights = int32(len(addresses))
	return w, nil
}

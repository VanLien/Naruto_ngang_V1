package nsq

import (
	"time"

	"github.com/nsqio/go-nsq"
)

func NewConfig(serverID string) *nsq.Config {
	config := nsq.NewConfig()
	config.MaxInFlight = 10
	config.DialTimeout = 5 * time.Second
	config.ReadTimeout = 5 * time.Minute
	config.WriteTimeout = 5 * time.Minute
	config.ClientID = serverID
	// Snappy 会导致qps明显下降 5k -> 3k sayhello
	//config.Snappy = true
	//config.Set("snappy", true)
	config.OutputBufferTimeout = 25 * time.Millisecond
	config.LookupdPollInterval = 5 * time.Second

	config.MaxAttempts = 0
	return config
}

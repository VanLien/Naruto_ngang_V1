package ta

import (
	"os"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"

	"github.com/ThinkingDataAnalytics/go-sdk/thinkingdata"
)

var ta *thinkingdata.TDAnalytics

const (
	fakeCrossMineAccount = "cross_mine"
	fakeArenaAccount     = "arena"
)

func Init(directory string) {
	_, err := os.Stat(directory)
	if err != nil {
		if os.IsNotExist(err) {
			err = os.MkdirAll(directory, os.ModePerm)
		}
	}
	if err != nil {
		panic(err)
	}
	log.Infof("thinkingdata log directory %s", directory)
	consumer, err := thinkingdata.NewLogConsumer(directory, thinkingdata.ROTATE_DAILY)
	//consumer, err := thinkingdata.NewDebugConsumer("http://49.234.226.168", "debug-appid")
	if err != nil {
		panic(err)
	}
	t := thinkingdata.New(consumer)
	ta = &t
}

func Stop() {
	if ta == nil {
		return
	}
	log.Infof("Stopping TA")
	ta.Close()
}

func TrackCrossMineBoss(key string, bosses map[document.ID]*scheme.CrossMineBoss) {
	if ta == nil {
		return
	}

	for _, boss := range bosses {
		hp := 0
		for _, v := range boss.HP {
			hp += v
		}
		damage := 0
		for _, v := range boss.Damage {
			damage += v
		}
		properties := map[string]interface{}{
			"service":      key,
			"csv_id":       boss.CsvID,
			"total_damage": damage,
			"total_hp":     hp,
		}
		ta.Track(fakeCrossMineAccount, "", "cross_mine_boss", properties)
	}
}

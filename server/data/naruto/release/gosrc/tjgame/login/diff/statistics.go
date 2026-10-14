package diff

import (
	"encoding/json"
	"net/http"
	"sync"
	"time"
)

type queryInfo struct {
	TimeInt int
	Patchs  map[int]int
}

var queryInfos = []queryInfo{{
	makeTimeInt(),
	make(map[int]int),
}}

var queryLock = sync.Mutex{}

func makeTimeInt() int {
	st := time.Now()
	return int(st.Month())*1000000 + st.Day()*10000 + st.Hour()*100 + st.Minute()
}

func recordQuery(patch int) {
	queryLock.Lock()
	defer queryLock.Unlock()

	nt := makeTimeInt()
	if queryInfos[len(queryInfos)-1].TimeInt != nt {
		queryInfos = append(queryInfos, queryInfo{
			nt,
			make(map[int]int),
		})
		if len(queryInfos) > 24*60 {
			copy(queryInfos, queryInfos[12*60:])
		}
	}
	ptr := &queryInfos[len(queryInfos)-1]
	ptr.Patchs[patch] += 1
}

func statisticsHandler(w http.ResponseWriter, req *http.Request) {
	queryLock.Lock()
	defer queryLock.Unlock()

	w.Header().Set("Content-Type", "text/json")
	data, _ := json.Marshal(&queryInfos)
	w.Write(data)
}

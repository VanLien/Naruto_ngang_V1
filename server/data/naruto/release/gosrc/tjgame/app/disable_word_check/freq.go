package main

import (
	"sort"
	"strings"
	"sync/atomic"
	"time"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
	"unicode/utf8"

	"github.com/Chain-Zhang/pinyin"
)

const FreqMaxInMinute = 5

type freqinfo struct {
	count int64
	freq  float64 // minute
	warn  int64
	first time.Time
	last  time.Time
}

var FreqMap *util.LRUCache

var FreqCh chan *task

func freq() {
NEXT_TASK:
	for t := range FreqCh {
		t.process++

		if len(t.words) < 3 {
			t.okResult()
			continue NEXT_TASK
		}

		// sort for order insensitive
		words := make([]string, 0, len(t.words))

		// char insensitive
		nchar := 0
		for _, word := range t.words {
			py, _ := pinyin.New(word).Split("").Mode(pinyin.InitialsInCapitals).Convert()
			// 相同可能不是汉字，过滤掉
			if py != word {
				words = append(words, py)
				nchar += utf8.RuneCountInString(word)
			}
		}

		if nchar < 3 {
			t.okResult()
			continue NEXT_TASK
		}

		sort.Strings(words)
		s := strings.Join(words, "")

		tm := time.Now()
		iv, ok := FreqMap.Get(s)
		if iv == nil || !ok {
			FreqMap.Set(s, &freqinfo{
				freq:  1,
				count: 1,
				first: tm,
				last:  tm,
			})
			t.okResult()
			continue NEXT_TASK
		}

		info := iv.(*freqinfo)
		count := atomic.AddInt64(&info.count, 1)
		minutes := tm.Sub(info.last).Minutes()
		refresh := false
		if minutes >= 1 || count > FreqMaxInMinute {
			newfreq := float64(count) / minutes
			//newfreq = (newfreq + info.freq) / 2
			// more sensitive
			info.freq = newfreq
			info.last = tm
			atomic.StoreInt64(&info.count, 0)
			refresh = true
		}

		w := 1.0
		if info.warn > 0 {
			warn := info.warn
			// 5^0.5 => 2.23 -1 => 1.23 / 0.2 => 6 warn
			// 0 => w=1 => 5
			// 1 => w=1.44 => 3.47
			// 2 => w=1.96 => 2.55
			// 3 => w=2.56 => 1.95
			w = 1.0 + 0.2*float64(warn)
			w *= w
		}
		if refresh {
			if info.freq > FreqMaxInMinute {
				info.warn++
			} else {
				info.warn--
				if info.warn < 0 {
					info.warn = 0
				}
			}
		}

		if info.freq*w > FreqMaxInMinute {
			log.Warningf("%.2f = freqwarn(%.2f, %d)", info.freq*w, info.freq, info.warn)
			t.errResult("freq", s)
			continue NEXT_TASK
		}

		t.okResult()
	}
}

func onLRUEvict(key, value interface{}) {
	info := value.(*freqinfo)

	log.Infof("freq lru evict %d %.2f %d %s coming at %s duration %s", info.warn, info.freq, info.count, key, info.first, info.last.Sub(info.first))
}

func initFreq() {
	FreqMap = util.NewLRUCache(4000, onLRUEvict)

	FreqCh = make(chan *task, TaskParallel)

	for i := 0; i < TaskParallel; i++ {
		go freq()
	}
}

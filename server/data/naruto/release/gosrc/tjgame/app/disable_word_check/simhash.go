package main

import (
	"bytes"
	"crypto/md5"
	"io/ioutil"
	"math"
	"math/bits"
	"strings"
	"sync"
	"time"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
)

// https://segmentfault.com/a/1190000018328273
// https://zhuanlan.zhihu.com/p/71488127

var SimilarWordsNeed = 5
var SimilarDisMax = 3

var WordWeightMap *sync.Map // [word string] weight int
var HashMap *sync.Map       // [ hash[-16:] ][hash] string

var SimilarCh chan *task
var SimilarSearchCh chan *task

var newDisableSentence chan *task
var sentencesLib []string

type wordhash struct {
	word   string
	hash   uint64
	weight int
}

func writeSentencesFile() int {
	data := strings.Join(sentencesLib, "\n")
	err := ioutil.WriteFile("conf/disable_sentences.new.txt", util.String2ReadOnlyBytes(data), 0644)
	if err != nil {
		log.Errorf("writeSentencesFile err: %s", err)
	}
	return len(sentencesLib)
}

func updateSentences() {
	timer := time.NewTimer(time.Minute)
	oldLen := len(sentencesLib)
	for {
		select {
		case t := <-newDisableSentence:
			sentencesLib = append(sentencesLib, t.msg)
			if len(sentencesLib)%50 == 0 {
				oldLen = writeSentencesFile()
			}
			// TODO: update HashMap and WordWeightMap for simhash
			t.onlytrain = true
			var chNext chan *task
			if t.hash == 0 {
				if t.words == nil {
					chNext = TaskCh
				} else if len(t.words) > SimilarWordsNeed {
					chNext = SimilarCh
				}
			} else {
				chNext = SimilarSearchCh
			}
			// TODO: 误识别较高，暂时离线手动更新库
			chNext = nil
			if chNext != nil {
				chNext <- t
				log.Infof("add train task %d %d %s %s %d", t.id, t.process, t.content, t.words, t.hash)
			}

		case <-timer.C:
			if oldLen < len(sentencesLib) {
				oldLen = writeSentencesFile()
			}
			timer.Reset(time.Minute)
		}
	}
}

func simhash() {
NEXT_TASK:
	for t := range SimilarCh {
		t.process++

		// word太少，识别率低
		if len(t.words) < SimilarWordsNeed {
			t.okResult()
			continue NEXT_TASK
		}

		vec := make([]wordhash, 0, len(t.words))
		for _, word := range t.words {
			iv, ok := WordWeightMap.Load(word)
			if ok {
				md5bytes := md5.Sum(util.String2ReadOnlyBytes(word))
				h := uint64(0)
				for i := 0; i < 8; i++ {
					h = (h << 8) + uint64(md5bytes[i]^md5bytes[i+8])
				}
				vec = append(vec, wordhash{
					word:   word,
					weight: iv.(int),
					hash:   h,
				})
			}
		}

		// 词库数量不够
		if len(vec) == 0 {
			t.okResult()
			continue NEXT_TASK
		}

		var bit64 [64]int
		for _, info := range vec {
			h := info.hash
			for i := 0; i < 64; i++ {
				flag := 1
				if h&1 == 0 {
					flag = -1
				}
				bit64[i] += flag * info.weight
				h >>= 1
			}
		}

		h := uint64(0)
		for i := 0; i < 64; i++ {
			h <<= 1
			if bit64[i] > 0 {
				h |= 1
			}
		}
		t.hash = h

		SimilarSearchCh <- t
	}
}

type dochash struct {
	hash uint64
	doc  string
}

var testHash = make([]*dochash, 0, 16)

func simhashSearch() {
NEXT_TASK:
	for t := range SimilarSearchCh {
		t.process++

		h := t.hash
		//last16 := h & 0xffff
		//iv, _ := HashMap.LoadOrStore(last16, &sync.Map{})
		//lastHash := iv.(*sync.Map)

		// 文档不多，暂时全遍历
		lastHash := HashMap

		if t.onlytrain {
			lastHash.Store(h, t.content)
			t.okResult()
			if DebugMode {
				testHash = append(testHash, &dochash{
					hash: h,
					doc:  t.content,
				})
			}
			continue NEXT_TASK
		}

		checkAll := false
		//if DebugMode {
		//	for _, doc := range testHash {
		//		x := h ^ doc.hash
		//		hmDis := bits.OnesCount64(x)
		//		log.Debugf("test %d = hmdis(%d, %d, %s, %s)", hmDis, h, doc.hash, t.content, doc.doc)
		//		if hmDis <= SimilarDisMax {
		//			log.Warningf("test %d = hmdis(%d, %d, %s, %s)", hmDis, h, doc.hash, t.content, doc.doc)
		//			checkAll = true
		//		}
		//	}
		//}

		lastHash.Range(func(key, value interface{}) bool {
			if t.isFinished() {
				return false
			}
			h2 := key.(uint64)
			x := h ^ h2
			hmDis := bits.OnesCount64(x)
			if hmDis <= SimilarDisMax {
				log.Warningf("%d = hmdis(%d, %d, %s, %s)", hmDis, h, h2, t.content, value)
				t.errResult("simhash", value.(string))
				return false
			}
			return true
		})

		if DebugMode && (t.err == "simhash") != checkAll {
			log.Warning("missmatch in last16 mode", checkAll, t)
		}

		//if t.isFinished() {
		//	continue NEXT_TASK
		//}

		t.okResult()
	}
}

func initSimHash() {
	HashMap = &sync.Map{}

	SimilarCh = make(chan *task, TaskParallel)
	SimilarSearchCh = make(chan *task, TaskParallel)

	newDisableSentence = make(chan *task, 2*TaskParallel)
	sentencesLib = make([]string, 0, 32)

	// disable_sentences
	data, err := ioutil.ReadFile("conf/disable_sentences.txt")
	if err != nil {
		panic("no conf/disable_sentences.txt file")
	}

	// TF-IDF (term frequency–inverse document frequency)
	// https://baike.baidu.com/item/tf-idf
	WordWeightMap = &sync.Map{}
	tf := make(map[string]int)
	df := make(map[string]int)
	arr := bytes.Split(data, []byte{'\n'})
	tasks := make([]*task, 0, len(arr))

	dSum := float64(0)
	for _, b := range arr {
		s := string(bytes.TrimSpace(b))
		if len(s) == 0 {
			continue
		}
		sentencesLib = append(sentencesLib, s)

		t := &task{
			id:        0,
			msg:       s,
			content:   s,
			words:     nil,
			err:       "",
			finished:  0,
			dest:      1,
			onlytrain: true,
			resultCh:  make(chan bool),
		}
		tasks = append(tasks, t)

		TaskCh <- t
		select {
		case <-SimilarCh:
		case <-t.resultCh:
		}

		log.Debug("simhash words", t.words)
		if len(t.words) <= SimilarWordsNeed {
			log.Error("SimilarNeedMoreWords", t.msg, t.words)
		}

		tfInD := make(map[string]int)
		for _, word := range t.words {
			tf[word]++
			tfInD[word]++
		}
		for word := range tfInD {
			df[word]++
		}
		dSum += 1
	}

	tSum := float64(0)
	for _, cnt := range tf {
		tSum += float64(cnt)
	}

	log.Infof("term total %.0f", tSum)
	log.Infof("document total %.0f", dSum)
	tfidf := make(map[string]float64)
	vmin, vmax := float64(1e99), float64(0)
	for word, cnt := range tf {
		dCnt := float64(df[word])
		tmp := float64(cnt) / tSum * math.Log10(dSum/dCnt)
		tfidf[word] = tmp
		vmin = math.Min(vmin, tmp)
		vmax = math.Max(vmax, tmp)
		log.Debug(word, cnt, dCnt, "tfidf", tmp)
	}
	rate := (vmax - vmin) / 10
	for word, t := range tfidf {
		w := int(math.Round((t - vmin) / rate))
		if w <= 0 {
			w = 1
		}
		WordWeightMap.Store(word, w)
		if w > 1 {
			log.Debug(word, "weight", w)
		}
	}

	log.Infof("WordWeightMap %d", len(tfidf))

	for i := 0; i < TaskParallel; i++ {
		go simhash()
		go simhashSearch()
	}
	go updateSentences()

	// fill the base disable_sentences
	for _, t := range tasks {
		if !t.isFinished() {
			SimilarCh <- t
			<-t.resultCh
		}
	}
}

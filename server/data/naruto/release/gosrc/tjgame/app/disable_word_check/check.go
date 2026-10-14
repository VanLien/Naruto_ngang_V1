package main

import (
	"bytes"
	"io/ioutil"
	"strings"
	"sync"
	"unicode"
	"unicode/utf8"

	"tjgame/server_framework/tj/log"
)

var CheckCh chan *task

var WordsLib []string
var DisableWordsLib *sync.Map
var StopWordsLib *sync.Map
var CharMap *sync.Map

// 12288 12288 3000 　 true true
// 12289 12289 3001 、 false true
// 12290 12290 3002 。 false true
var unacceptable = &unicode.RangeTable{
	R16: []unicode.Range16{
		{0x00a4, 0x2fff, 1},
		{0x3003, 0x33ff, 1},
	},
}

func isUnacceptable(c rune) bool {
	return unicode.In(c, unacceptable)
}

func isQuanJiao(c rune) bool {
	cc := c
	if c == 0x3000 {
		c = 0x0020
	} else {
		c -= 0xfee0
	}
	if c < 0x0020 || c > 0x007e {
	} else {
		// ff0c ，
		// 3000 space
		// 3002 。
		// ff01 ！
		// ff1f ？
		switch cc {
		case 0xff0c:
			fallthrough
		case 0xff01:
			fallthrough
		case 0xff1f:
			fallthrough
		case 0x3000:
			fallthrough
		case 0x3002:
			return false
		}
		return true
	}
	return false
}

func normalizeString(s string) string {
	rs := make([]rune, 0, len(s))
	for _, c := range s {
		// 全角转半角
		if c == 0x3000 {
			c = 0x0020
		} else if c >= 0xff01 && c <= 0xff5e {
			c -= 0xfee0
		}
		rs = append(rs, c)
	}
	// 大写转小写
	ret := strings.ToLower(string(rs))
	ret = strings.ToLowerSpecial(unicode.AzeriCase, ret)
	ret = strings.ToLowerSpecial(unicode.TurkishCase, ret)
	return ret
}

func normalizeRune(c rune) rune {
	// 全角转半角
	if c == 0x3000 {
		c = 0x0020
	} else if c >= 0xff01 && c <= 0xff5e {
		c -= 0xfee0
	}

	// 大写转小写
	ret := unicode.ToLower(c)
	ret = unicode.AzeriCase.ToLower(ret)
	ret = unicode.TurkishCase.ToLower(ret)
	return ret
}

func clean() {
NEXT_TASK:
	for t := range TaskCh {
		t.setDest(1)
		t.process++

		rs := make([]rune, 0, len(t.content))
		for i, c := range t.content {
			_ = i
			// 全角就是有鬼
			if isQuanJiao(c) && !t.onlytrain {
				t.errResult("quanjiao", string(c))
				continue NEXT_TASK
			}
			if isUnacceptable(c) && !t.onlytrain {
				t.errResult("unacceptable", string(c))
				continue NEXT_TASK
			}
			//log.Debugf("%d: %T %c %d %x IsPunct %v IsSymbol %v IsMark %v Han %v", i, c, c, c, c, unicode.IsPunct(c), unicode.IsSymbol(c), unicode.IsMark(c), unicode.Is(unicode.Han, c))
			if unicode.Is(unicode.Han, c) || unicode.IsLetter(c) || unicode.IsNumber(c) {
				rs = append(rs, normalizeRune(c))
			}
		}

		t.content = string(rs)
		JiebaCh <- t
	}
}

func check() {
NEXT_TASK:
	for t := range CheckCh {
		t.process++

		charmap := make(map[string]string)
		for _, word := range t.words {
			if _, ok := DisableWordsLib.Load(word); ok && !t.onlytrain {
				t.errResult("disable", word)
				continue NEXT_TASK
			}

			cc, ok := CharMap.Load(word)
			if ok {
				charmap[word] = string(cc.(rune))
			}
			if ok || utf8.RuneCountInString(word) == 1 {
				//log.Debug(word, "only one char, ignore")
				continue
			}
		}

		// 单字转换，繁体、同音字
		if len(charmap) > 0 {
			if DebugMode {
				for k, v := range charmap {
					log.Debugf("%v -> %v", k, v)
				}
			}

			s := t.content
			for k, v := range charmap {
				s = strings.Replace(s, k, v, -1)
			}

			t.content = s
			JiebaCh <- t
			continue NEXT_TASK
		}

		// 忽略停用词
		var newWords []string
		var copyWords []string
		//for i, word := range t.words {
		//	_, ok := StopWordsLib.Load(word)
		//	if ok {
		//		if newWords == nil {
		//			newWords = t.words[:i]
		//			if DebugMode {
		//				copyWords = make([]string, len(t.words))
		//				copy(copyWords, t.words)
		//			}
		//		}
		//	} else {
		//		if newWords != nil {
		//			newWords = append(newWords, word)
		//		}
		//	}
		//}
		if newWords != nil {
			if DebugMode {
				log.Debugf("silm words by stopword %v %v", newWords, copyWords)
			}
			t.words = newWords
		}

		t.setDest(1)
		FreqCh <- t
		//SimilarCh <- t
	}
}

func initWordLib() {
	// disable_words
	data, err := ioutil.ReadFile("conf/disable_words.txt")
	if err != nil {
		panic("no conf/disable_words.txt file")
	}

	arr := bytes.Split(data, []byte{'\n'})
	DisableWordsLib = &sync.Map{}
	for _, b := range arr {
		DisableWordsLib.Store(string(bytes.TrimSpace(b)), true)
	}
	cnt := 0
	DisableWordsLib.Range(func(key, value interface{}) bool {
		cnt++
		return true
	})
	log.Infof("DisableWordsLib %d", cnt)

	// words
	data, err = ioutil.ReadFile("conf/words.txt")
	if err != nil {
		panic("no conf/words.txt file")
	}
	arr = bytes.Split(data, []byte{'\n'})
	WordsLib = make([]string, 0, len(arr))
	for _, b := range arr {
		WordsLib = append(WordsLib, string(bytes.TrimSpace(b)))
	}
	log.Infof("WordsLib %d", len(WordsLib))

	// char_map
	data, err = ioutil.ReadFile("conf/char_map.txt")
	if err != nil {
		panic("no conf/char_map.txt file")
	}

	CharMap = &sync.Map{}
	arr = bytes.Split(data, []byte{'\n'})
	for _, b := range arr {
		bb := bytes.Split(b, []byte{' '})
		if len(bb) != 2 {
			continue
		}
		newc, _ := utf8.DecodeRune(bb[1])
		CharMap.Store(string(bb[0]), newc)
	}
	log.Infof("CharMap %d", len(arr))
	if DebugMode {
		CharMap.Range(func(key, value interface{}) bool {
			log.Debugf("%v -> %c", key, value)
			return true
		})
	}

	// stopwords
	data, err = ioutil.ReadFile("conf/stopwords.txt")
	if err != nil {
		panic("no conf/stopwords.txt file")
	}
	arr = bytes.Split(data, []byte{'\n'})
	StopWordsLib = &sync.Map{}
	for _, b := range arr {
		StopWordsLib.Store(string(bytes.TrimSpace(b)), true)
	}
	cnt = 0
	StopWordsLib.Range(func(key, value interface{}) bool {
		cnt++
		return true
	})
	log.Infof("StopWordsLib %d", cnt)
}

func initCheck() {
	CheckCh = make(chan *task, TaskParallel)
	for i := 0; i < TaskParallel; i++ {
		go clean()
		go check()
	}
}

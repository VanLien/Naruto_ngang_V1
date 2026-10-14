package main

import (
	"os"
	"path"
	"strings"
	"unicode/utf8"

	"github.com/wangbin/jiebago"

	"tjgame/server_framework/tj/log"
)

var JiebaCh chan *task

type IJieba interface {
	CutForSearch(s string, hmm bool) []string
	Free()
}

type JiebaGoImpl struct {
	jiebago.Segmenter
}

func (j *JiebaGoImpl) CutForSearch(s string, hmm bool) []string {
	ch := j.Segmenter.CutForSearch(s, hmm)
	ret := make([]string, 0, 4)
	for word := range ch {
		ret = append(ret, word)
	}
	return ret
}

func (j *JiebaGoImpl) Free() {
}

func newJieba() IJieba {
	jbgo := &JiebaGoImpl{}

	cwd, _ := os.Getwd()
	dictDir := path.Join(cwd, "dict")
	jiebaPath := path.Join(dictDir, "jieba.dict.utf8")
	//hmmPath := path.Join(dictDir, "hmm_model.utf8")
	//userPath := path.Join(dictDir, "user.dict.utf8")
	//idfPath := path.Join(dictDir, "idf.utf8")
	//stopPath := path.Join(dictDir, "stop_words.utf8")

	jbgo.LoadDictionary(jiebaPath)
	//jbgo.LoadUserDictionary(userPath)

	//x := gojieba.NewJieba(jiebaPath, hmmPath, userPath, idfPath, stopPath)
	for _, word := range WordsLib {
		//x.AddWord(word)
		jbgo.AddWord(word, 1)
	}
	DisableWordsLib.Range(func(key, value interface{}) bool {
		word := key.(string)
		//x.AddWord(word)
		jbgo.AddWord(word, 1)
		return true
	})
	StopWordsLib.Range(func(key, value interface{}) bool {
		word := key.(string)
		if utf8.RuneCountInString(word) > 1 {
			//x.AddWord(word)
			jbgo.AddWord(word, 1)
		}
		return true
	})

	//return x
	return jbgo
}

func jieba() {
	x := newJieba()
	defer x.Free()

	for t := range JiebaCh {
		t.process++

		t.words = x.CutForSearch(t.content, true)
		log.Debugf("task %d %d content %s", t.id, t.process, t.content)
		log.Infof("task %d %d words %s", t.id, t.process, strings.Join(t.words, "/"))

		CheckCh <- t
	}
}

func initJieBa() {
	JiebaCh = make(chan *task, TaskParallel)
	for i := 0; i < TaskParallel; i++ {
		go jieba()
	}
}

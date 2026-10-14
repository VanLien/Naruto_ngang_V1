package main

import (
	"flag"
	"fmt"
	"net/http"
	"time"
	"tjgame/server_framework/tj/log"

	"github.com/Chain-Zhang/pinyin"
)

var (
	Branch    string
	Commit    string
	BuildTime string
	GoVersion string
)

var DebugMode = Branch != "master"

var TaskCh chan *task

func test() {
	go func() {
		time.Sleep(time.Second)

		fmt.Println("----------------------------------------")
		msg2 := ",，.。!！-－+＋包123AB包１２３ＡＢ()（）（）!！！~～【】[]【】老而黄"
		for i, c := range msg2 {
			cc := []byte(string(c))
			fmt.Printf("%d %d %x %c %v %v %v\n", i, c, c, c, cc, isQuanJiao(c), isUnacceptable(c))
		}

		//for i := 0xa0; i < 0x4e0d; i++ {
		//	c := rune(i)
		//	fmt.Printf("%d %d %x %c %v %v\n", i, c, c, c, isQuanJiao(c), isUnacceptable(c))
		//}

		msg2 = "Ａｎｇｅｌａｂａｂｙ123你好，安哥拉八步摇。！！！~～"
		fmt.Println(msg2)
		fmt.Println(normalizeString(msg2))

		msg := "欢迎来到德玛西亚，都伽下薇e3aa。拉你们进公会裙，拿礼包"
		t := &task{
			id:        0,
			msg:       msg,
			content:   msg,
			onlytrain: false,
			dest:      1,
			resultCh:  make(chan bool),
		}
		TaskCh <- t
		fmt.Println("!!!", <-t.resultCh, msg)

		msgs := []string{
			"全区，1亓=一百.万.砖炻，另外还有S精力呢，要的家Ｑ365-717-561",
			"1亓=一百.万.砖炻，另外还有S精力呢，要的家Ｑ365-71-7561",
			"打开手丨机浏览器搜 丨索【神 丨宠宝贝.cn】，领百连抽和500个超级球",
			"lO块=866万钻+3OO万金币，S.┼睛.零+扣：l68-422-406",
			"兄弟们加下会长威信：５９８８  ２３７，进裙领礼包攻略，一起作战，不加当人工踢了",
			"家族内部扣裙543—269——380，进来免费拿抽卡卷上千钻和百万金币材料！没进oo裙优先踢",
			"伙伴们伽我薇信：cJnb770 领取多个激活码，备注名字，以免下线被误当机器人踢了。",
			"38万钻送v9+超梦`加扣168-999-817.到付",
			"1员38万砖头+s精灵.壬选扣168-999-817，到付",
			"先货：10=99万钅占送V11+200万金币，S+精灵（5个任选），加扣：553999357",
			"朋友加微信2293434152进群，大家一起玩",
			"朋友们进下咱们家族内部扣裙543—269——380，免费拿抽卡卷上千钻百万金币材料！老司机指导",
			"关于来到可爱的萌萌哒。我是这里的*主，大家都要听我的话哟。",
			"各位伙伴，已经有一半的伙伴添加VX了，，还没有添加VX的速度了，看公会添加vx，谢谢配合",
			"各位伙伴，没有添加会长vx请速度了，没加的一律提出公会，查看公会公告添加会长呢，谢谢",
			"公会位置有限，没在君羊的加微729154278等下清理了",
			"好厉害啊啊五环",
			"在线的都把公会任务做下。玩家公会活跃就行。谢谢",
			"在线的公会任务，公会boss清了，玩家公会，活跃就行谢谢",
			"朋友们进下咱们家族内部扣裙543—269——380，免费拿抽卡卷上千钻百万金币材料！老司机指导",
			"加徽信1156268050进玩家游戏君羊，领礼包码攻略，没加的定期清人",
			"大家都帮忙扩大下公会 我一个弱女子能力有限哥哥们",
			"大家加下裙 165891446",
			"分享礼包码加V：hmb6746。进公会裙分享礼包码ckd",
			"公会位置有限，没在君羊的加微729154278等下清理了",
			"周卡洛奇亚妙蛙种子",
			"┼快给8O8W金占+6l0万J币，S.┼睛.零+抠：195-695-22ll",
			"lo元=888W砖+300万金 币，S+睛.零+扣：123123123",
			"┼快给8O8W金占+6l0万J币，S.┼睛.零+抠：448-O23-146",
			"┼快给815W【钻】+6l0W【J币】，S.┼【睛.零】，【找我扣壠】-【168壠422壠406】[]【】",
			"cby1071避免下线丢出去了哈",
			"CByI07I会长威。迦，，才不会提",
		}
		rs := make([]*task, len(msgs))
		for i, msg := range msgs {
			t := &task{
				id:       int64(i),
				msg:      msg,
				content:  msg,
				dest:     1,
				resultCh: make(chan bool),
			}

			TaskCh <- t
			ret := <-t.resultCh
			rs[i] = t
			fmt.Println("!!!", ret, msg)
		}

		fmt.Println(pinyin.New("┼").Mode(pinyin.InitialsInCapitals).Convert())

		for _, t := range rs {
			str, err := pinyin.New(t.msg).Mode(pinyin.InitialsInCapitals).Convert()
			fmt.Println("pinying", str, err)
		}

		for i, t := range rs {
			fmt.Println("!!!", i, t.err, t.errWord, t)
		}

		// test simhash
		//for i, msg := range msgs {
		//	t := &task{
		//		id:       int64(i),
		//		msg:      msg,
		//		content:  normalizeString(msg),
		//		resultCh: make(chan bool),
		//	}
		//
		//	JiebaCh <- t
		//	ret := <-t.resultCh
		//	if ret == false && t.err != "simhash" {
		//		t.onlytrain = false
		//		SimilarCh <- t
		//	}
		//}

		close(t.resultCh)
		fmt.Println("----------------------------------------")
	}()
}

func main() {
	var version bool
	flag.BoolVar(&version, "v", false, "-v")
	flag.Parse()
	if version {
		fmt.Printf("Branch: %s\nBuild: %s\nBuild Time: %s\nGo Version: %s\n", Branch, Commit, BuildTime, GoVersion)
		return
	}

	TaskCh = make(chan *task, TaskParallel)

	initWordLib()
	initCheck()
	initJieBa()
	initFreq()
	initSimHash()
	initQQ()

	if DebugMode {
		test()
		log.Init("disable_word_check", log.DEBUG)
		log.Debug("i am in debug mode")
		TaskParallel = 1
	} else {
		log.Init("disable_word_check", log.INFO)
		log.Info("i am in release mode")
	}

	s := &server{httpMux: http.NewServeMux()}
	s.initHTTP(":1144")
	s.start()
}

package ta

import (
	"encoding/json"
	"time"
)

type segment struct {
	win   bool
	cards []int
}

type BattleCardTrack struct {
	scene   string // battle scene, arena, cross_mine, cross_arena
	account string
	event   string
	wins    map[int]int
	fails   map[int]int
	ch      chan segment
	last    time.Time // last track

	theme int // online fight theme
}

func (t *BattleCardTrack) track() {
	if len(t.wins) == 0 && len(t.fails) == 0 {
		return
	}
	properties := map[string]interface{}{
		"scene": t.scene,
	}
	flag := len(t.wins) > 0 || len(t.fails) > 0
	data1, err := json.Marshal(t.wins)
	if err != nil {
		return
	}
	data2, err := json.Marshal(t.fails)
	if err != nil {
		return
	}
	properties["battle_card_win"] = string(data1)
	properties["battle_card_fail"] = string(data2)
	if t.theme > 0 {
		properties["theme"] = t.theme
	}

	t.wins = make(map[int]int)
	t.fails = make(map[int]int)
	t.last = time.Now()
	if flag {
		go ta.Track(t.account, "", t.event, properties)
	}
}

func (t *BattleCardTrack) Start() {
	if ta == nil {
		return
	}

	t.wins = make(map[int]int)
	t.fails = make(map[int]int)
	t.last = time.Now()
	t.ch = make(chan segment, 8)

	go func() {
		for {
			select {
			case v, ok := <-t.ch:
				if !ok {
					t.track()
					return
				}
				if v.win {
					for _, id := range v.cards {
						t.wins[id] += 1
					}
				} else {
					for _, id := range v.cards {
						t.fails[id] += 1
					}
				}

				// 写入数数
				if time.Now().Sub(t.last) > time.Hour*2 {
					t.track()
				}
			}
		}
	}()
}

func (t *BattleCardTrack) Stop() {
	if ta == nil {
		return
	}

	close(t.ch)
}

func (t *BattleCardTrack) Track(win bool, cards []int) {
	if ta == nil {
		return
	}
	if len(cards) > 0 {
		select {
		case t.ch <- segment{win: win, cards: cards}:
		default:
		}

	}
}

func (t *BattleCardTrack) SetTheme(n int) {
	t.theme = n
}

func NewBattleCardTrack(key string, scene string) *BattleCardTrack {
	return &BattleCardTrack{
		scene:   scene,
		account: key,
		event:   "battle_cards",
	}
}

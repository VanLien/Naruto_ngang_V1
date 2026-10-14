package yyhuodong

import (
	"fmt"
	"io/ioutil"
	"math"
	"sync"
	"sync/atomic"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/mgo.v2/bson"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"

	tjcards "tjgame/services/game/cards"
)

var config atomic.Value

func GetConfig() *Config {
	return config.Load().(*Config)
}

func LoadConfig() error {
	cfg := csv.GetConfig()
	v := &Config{
		WorldBossHP:       make(map[int]int),
		WorldBossHPFix:    make(map[int]float64),
		WorldBossMinLevel: 1,
	}

	for _, c := range cfg.World_boss.Base {
		v.WorldBossHP[c.HuodongID] = c.BaseHP
	}

	for _, c := range cfg.World_boss.Hp_fix {
		v.WorldBossHPFix[c.Level] = c.HpFix
		if c.Level > v.WorldBossMaxLevel {
			v.WorldBossMaxLevel = c.Level
		}
	}

	config.Store(v)
	return nil
}

func WorldBossLevelCheck(level int) int {
	cfg := GetConfig()
	level = int(math.Max(float64(level), float64(cfg.WorldBossMinLevel)))
	level = int(math.Min(float64(level), float64(cfg.WorldBossMaxLevel)))
	return level
}

func Max(v1, v2 int) int {
	if v1 >= v2 {
		return v1
	}
	return v2
}

func Min(v1, v2 int) int {
	if v1 < v2 {
		return v1
	}
	return v2
}

type battleInfo struct {
	RoleID      document.ID
	RecordID    document.ID
	YYID        int
	battleID    document.ID
	monsterID   int
	mu          sync.Mutex
	result      string
	agentResult string

	model       interface{}
	agentFinish chan int
}

func (b *battleInfo) onAgentFinish() {
	select {
	case b.agentFinish <- 1:
	default:
	}
}

var battleType = map[string]string{
	"brave_challenge":  "NewBraveChallengeBattle",
	"summer_challenge": "NewSummerChallengeBattle",
}

type AntiAgent struct {
	name              string
	battles           sync.Map
	agent             service.IService // 反作弊
	battleVerifyQueue chan *battleInfo // 反作弊校验队列
	server            *Service
	sync              bool     // 是否等待反作弊同步结果
	banRoles          sync.Map // 封禁角色
	flag              bool     // 是否开启反作弊封禁
	saveRecord        bool     // 是否保存战报
}

func (aa *AntiAgent) banRole(roleID document.ID) {
	aa.banRoles.Store(roleID, util.NowTime())
}

func (aa *AntiAgent) isBanned(roleID document.ID) error {
	if !aa.flag {
		return nil
	}
	if t, ok := aa.banRoles.Load(roleID); ok {
		banTime := t.(float64)
		if banTime+BanHours.Seconds() > util.NowTime() {
			return CheatBraveChallengeBanned
		}
	}
	return nil
}

// 保存战报
func (aa *AntiAgent) RecordPlay(data []byte, battleID document.ID) error {
	if !aa.saveRecord {
		return nil
	}
	filename := fmt.Sprintf("%s_%s.play", aa.name, bson.ObjectId(battleID).Hex())
	playRecord := []interface{}{aa.name, data}
	d, _ := util.MsgPack(playRecord)
	_ = ioutil.WriteFile(filename, d, 0777)
	return nil
}

// 反作弊校验
func runBattleAgentVerify(anti *AntiAgent) {
	log.Infof("%s start runBattleAgentVerify\n", anti.name)
	util.SimpleTry(func() {
		for {
			select {
			case b := <-anti.battleVerifyQueue:

				data, err := util.MsgPack(b.model)
				if err != nil {
					log.Warningf("%s battle %v verify msgpack err %v", anti.name, b.battleID, err)
					b.onAgentFinish()
					continue
				}

				result, err := service.CallWithTimeout(anti.agent, battleType[anti.name], BattleVerifyTimeout, anti.server.Name(), b.battleID, data)
				if err != nil {
					log.Warningf("%s battle %v verify call err %v", anti.name, b.battleID, err)
					b.onAgentFinish()
					continue
				}

				b.mu.Lock()
				b.agentResult = result.(string)
				b.mu.Unlock()

				if b.agentResult != "win" {
					log.Warningf("%s roleID %v battle %v verify result err %v", anti.name, b.RoleID, b.battleID, result)
					anti.banRole(b.RoleID)
					anti.RecordPlay(data, b.battleID)
					b.onAgentFinish()
					continue
				}
				b.onAgentFinish()
			}
		}
	}, nil)
}

func pushBattleToVerifyQueue(anti *AntiAgent, battle *battleInfo) {
	util.SimpleTry(func() {
		t := time.NewTicker(BattleWaitVerifyTimeout)
		select {
		case anti.battleVerifyQueue <- battle:
			select {
			case <-battle.agentFinish:
			case <-t.C:
				log.Warningf("%s battle %v wait verify timeout", anti.name, battle.battleID)
			}
		case <-t.C:
			log.Warningf("%s battle %v push verify timeout", anti.name, battle.battleID)
		}
	}, nil)
}

func makeBattleCardHalo(ids []int, cardAttrs map[int]*scheme.CardBattleModel, cards []int, scene int) []int {
	consts, percents, chooses := tjcards.MakeBattleCardHaloBest(cards, scene)
	for _, csvID := range ids {
		card := cardAttrs[csvID]
		for attr, val := range consts {
			if val > 0 {
				card.Attrs[attr] += val
			}
		}
		for attr, val := range percents {
			if val > 0 {
				card.Attrs[attr] *= 1 + val
			}
		}
	}
	return chooses
}

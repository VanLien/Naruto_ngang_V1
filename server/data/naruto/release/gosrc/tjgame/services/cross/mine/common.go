// @Time     : 2020/12/8 10:13
// @Author   : cancan
// @File     : common.go
// @Function :

package mine

import (
	"math"
	"math/rand"
	"sort"
	"strconv"
	"sync/atomic"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/document/schemeutil"
	"tjgame/server_framework/tj/log"
	tjutil "tjgame/server_framework/tj/util"
	"tjgame/services/game/cards"
)

var config atomic.Value

func GetConfig() *Config {
	return config.Load().(*Config)
}

func LoadConfig() error {
	cfg := csv.GetConfig()

	ranges := make([]Range, 0, len(cfg.Cross.Mine.Match))
	for _, matchCfg := range cfg.Cross.Mine.Match {
		ranges = append(ranges, NewPWRange(matchCfg))
	}

	cfgBase := cfg.Cross.Mine.Base[1]

	// 基础配置和初始化
	v := &Config{
		RobPct:                      cfgBase.RobCorrect,
		RobHourTimes:                cfgBase.RobTimes,
		BeRodDayLimit:               cfgBase.ByRobLimit,
		BeRevengedByCommonRoleLimit: cfgBase.BeRevengedLimitByRole,
		ServerBuffFeedLevelLimit:    cfgBase.ServerAddLevelLimit.ToIntSlice(),
		ServerBuffLevelExp:          map[int]int{0: 0},
		RoleBuffFeedLevelLimit:      cfgBase.RoleAddLevelLimit,
		RoleBuffLevelExp:            map[int]int{0: 0},
		TopBattleHistoryPeriods:     cfgBase.TopBattleHistoryPeriods.ToIntSlice(),
		TopBattleRank:               cfgBase.TopBattleRank,
		MatchRanges:                 NewRanges(ranges...),
		ProductCfgIDSortMap:         make(map[int][][2]int),
		ServerPointRank:             cfgBase.ServerPointRank,
		BossHpFix:                   make(map[int]float64),
		BossRankAwardCfgIDSortMap:   make(map[int][][2]int),
		RandEventLibs:               make(map[int]*tjutil.WeightRandom),
	}

	csvIDs := make([]int, 0, len(cfg.Cross.Mine.Rob))
	for idx := range cfg.Cross.Mine.Rob {
		csvIDs = append(csvIDs, idx)
	}
	sort.Ints(csvIDs)
	for _, csvID := range csvIDs {
		robCfg := cfg.Cross.Mine.Rob[csvID]
		v.RobFight = append(v.RobFight, robCfg.FightDiff)
		v.RobFightPct = append(v.RobFightPct, robCfg.RobCorrect)
	}

	// buff 喂养
	for level := 1; level < 999; level++ {
		buffAddCfg, ok := cfg.Cross.Mine.Buff_add[level]
		if !ok {
			break
		}
		v.ServerBuffLevelExp[level] = v.ServerBuffLevelExp[level-1] + buffAddCfg.ServerExp
		v.RoleBuffLevelExp[level] = v.RoleBuffLevelExp[level-1] + buffAddCfg.RoleExp
		v.ServerBuffLevelMax = level
		v.RoleBuffLevelMax = level
	}

	// 排名对应的资源生产
	for idx, rankCfg := range cfg.Cross.Mine.Rank {
		v.ProductCfgIDSortMap[rankCfg.Version] = append(v.ProductCfgIDSortMap[rankCfg.Version], [2]int{idx, rankCfg.RankMax})
	}
	for version, cfgIDs := range v.ProductCfgIDSortMap {
		ranks := &rankSort{
			items: make([]rankItem, 0, len(cfgIDs)),
		}

		for _, cfgIDItem := range cfgIDs {
			ranks.items = append(ranks.items, rankItem{
				items: map[string]int{
					"csvID":   cfgIDItem[0],
					"rankMax": cfgIDItem[1],
				},
			})
		}
		ranks.keys = [][]string{{"rankMax", "asc"}}
		sort.Sort(ranks)
		newCfgIDs := make([][2]int, 0, len(cfgIDs))
		for _, item := range ranks.items {
			newCfgIDs = append(newCfgIDs, [2]int{item.items["csvID"], item.items["rankMax"]})
		}

		v.ProductCfgIDSortMap[version] = newCfgIDs
	}

	// Boss
	for _, bossHpFixCfg := range cfg.Cross.Mine.Boss_hp_fix {
		v.BossHpFix[bossHpFixCfg.ServerOpenDays] = float64(bossHpFixCfg.HpFix) / 100
		if bossHpFixCfg.ServerOpenDays > v.BossHpFixMaxServerOpenDays {
			v.BossHpFixMaxServerOpenDays = bossHpFixCfg.ServerOpenDays
		}
	}
	for idx, bossRankAwardCfg := range cfg.Cross.Mine.Boss_rank_award {
		v.BossRankAwardCfgIDSortMap[bossRankAwardCfg.Version] = append(v.BossRankAwardCfgIDSortMap[bossRankAwardCfg.Version], [2]int{idx, bossRankAwardCfg.Rank})
	}
	for version, cfgIDs := range v.BossRankAwardCfgIDSortMap {
		ranks := &rankSort{
			items: make([]rankItem, 0, len(cfgIDs)),
		}

		for _, cfgIDItem := range cfgIDs {
			ranks.items = append(ranks.items, rankItem{
				items: map[string]int{
					"csvID":   cfgIDItem[0],
					"rankMax": cfgIDItem[1],
				},
			})
		}
		ranks.keys = [][]string{{"rankMax", "asc"}}
		sort.Sort(ranks)
		newCfgIDs := make([][2]int, 0, len(cfgIDs))
		for _, item := range ranks.items {
			newCfgIDs = append(newCfgIDs, [2]int{item.items["csvID"], item.items["rankMax"]})
		}

		v.BossRankAwardCfgIDSortMap[version] = newCfgIDs
		//log.Info(version, v.BossRankAwardCfgIDSortMap[version])
	}

	// 常量配置
	for _, commonCfg := range cfg.Common_config {
		switch commonCfg.Name {
		case "crossMineBossMaxDamageMultiple":
			v.BossMaxDamageMultiple = int(commonCfg.Value)
		case "crossMineBossAgentCheckDamageFix":
			v.BossAgentCheckDamgeFix = float64(1 + commonCfg.Value/100)
		case "crossMineBossMaxTime":
			v.BossBattleMaxTime = int(commonCfg.Value)
		case "crossMineDisablenBattleProtectBeforeOver":
			v.DisablenBattleProtectBeforeOver = commonCfg.Value
		}
	}

	// 事件库
	eventLibTmp := make(map[int][]tjutil.WeightElement)
	for _, eventLibCfg := range cfg.Cross.Mine.Event_lib {
		eventLibTmp[eventLibCfg.EventLib] = append(eventLibTmp[eventLibCfg.EventLib], tjutil.WeightInts{
			eventLibCfg.ID, eventLibCfg.Weight,
		})
	}
	for eventLib, weightElem := range eventLibTmp {
		v.RandEventLibs[eventLib] = tjutil.NewWeightRandom(weightElem)
	}

	config.Store(v)
	return nil
}

// Range
type Range interface {
	start() int
	end() int
	in(rank int) bool
}

type Ranges []Range

func (rs Ranges) GetRange(rank int) Range {
	max := len(rs)
	idx := sort.Search(max, func(i int) bool {
		return rs[i].start() > rank
	})
	idx -= 1
	if idx >= 0 && rs[idx].in(rank) {
		return rs[idx]
	}
	return nil
}

func (rs Ranges) Len() int {
	return len(rs)
}

func (rs Ranges) Less(i, j int) bool {
	return rs[i].start() < rs[j].start()
}

func (rs Ranges) Swap(i, j int) {
	rs[i], rs[j] = rs[j], rs[i]
}

func NewRanges(ranges ...Range) Ranges {
	rs := make(Ranges, 0, len(ranges))
	rs = append(rs, ranges...)
	sort.Sort(rs)
	return rs
}

// CSVRange
type CSVRange [2]int

func (r CSVRange) start() int {
	return r[0]
}

func (r CSVRange) end() int {
	return r[1]
}

func (r CSVRange) in(rank int) bool {
	return r.start() <= rank && rank < r.end()
}

// PWRange
type PWRange struct {
	CSVRange
	ranges [][2]float64
}

func NewPWRange(cfg *csv.Cross_mine_match) *PWRange {
	r := &PWRange{
		CSVRange: [2]int{int(cfg.Range[0].(int64)), int(cfg.Range[1].(int64))},
	}

	r.ranges = make([][2]float64, 0, 4)
	r.ranges = append(r.ranges, [2]float64{str2num(cfg.EnemyRange1[0].(string)), str2num(cfg.EnemyRange1[1].(string))})
	r.ranges = append(r.ranges, [2]float64{str2num(cfg.EnemyRange2[0].(string)), str2num(cfg.EnemyRange2[1].(string))})
	r.ranges = append(r.ranges, [2]float64{str2num(cfg.EnemyRange3[0].(string)), str2num(cfg.EnemyRange3[1].(string))})
	r.ranges = append(r.ranges, [2]float64{str2num(cfg.EnemyRange4[0].(string)), str2num(cfg.EnemyRange4[1].(string))})
	r.ranges = append(r.ranges, [2]float64{str2num(cfg.EnemyRange5[0].(string)), str2num(cfg.EnemyRange5[1].(string))})
	r.ranges = append(r.ranges, [2]float64{str2num(cfg.EnemyRange6[0].(string)), str2num(cfg.EnemyRange6[1].(string))})
	r.ranges = append(r.ranges, [2]float64{str2num(cfg.EnemyRange7[0].(string)), str2num(cfg.EnemyRange7[1].(string))})
	r.ranges = append(r.ranges, [2]float64{str2num(cfg.EnemyRange8[0].(string)), str2num(cfg.EnemyRange8[1].(string))})
	r.ranges = append(r.ranges, [2]float64{str2num(cfg.EnemyRange9[0].(string)), str2num(cfg.EnemyRange9[1].(string))})
	r.ranges = append(r.ranges, [2]float64{str2num(cfg.EnemyRange10[0].(string)), str2num(cfg.EnemyRange10[1].(string))})
	return r
}

func (r *PWRange) getEnemies(rank, limit, rankMax int) []int {
	if !r.in(rank) {
		return nil
	}
	enemys := make([]int, 0, limit)

	existed := map[int]bool{rank: true}
	for _, x := range r.ranges {
		choose := 0
		left, right := int(math.Ceil(float64(rank)*x[0])), int(math.Ceil(float64(rank)*x[1]))
		if right > rankMax {
			right = rankMax
		}
		if left > rankMax {
			left = rankMax
		}
		if left < right {
			for i := 0; i < 10; i++ {
				r := rand.Intn(right-left) + left
				if _, ok := existed[r]; !ok {
					choose = r
					break
				}
			}
			if choose == 0 {
				log.Warningf("pw battle.csv range too small %d %d %v", rank, limit, x)
			}
		} else {
			if _, ok := existed[left]; !ok {
				choose = left
			}
		}

		// 过滤前十，前十建筑和10名后建筑不一致界面显示异常
		if choose > 10 {
			existed[choose] = true
			enemys = append(enemys, choose)
		}
	}
	return enemys
}

// string => num
func str2num(s string) float64 {
	num, _ := strconv.ParseFloat(s[:len(s)-1], 64)
	num /= 100
	return num
}

func min(a, b int) int {
	m := 0
	if a > b {
		m = b
	} else {
		m = a
	}
	return m
}

func max(a, b int) int {
	m := 0
	if a < b {
		m = b
	} else {
		m = a
	}
	return m
}

func calcCardAttr(cardAttrs map[document.ID]*scheme.CardBattleModel, serverBuffLevel, roleBuffLevel int, bossBuffAdd float64) map[document.ID]*scheme.CardBattleModel {
	hpAdd := 1.0
	damageAdd := 1.0
	defenceAdd := 1.0

	// 全服 buff
	serverBuffCfg := csv.GetConfig().Cross.Mine.Buff_add[serverBuffLevel]
	if serverBuffCfg != nil {
		hpAdd += serverBuffCfg.ServerHpAdd
		damageAdd += serverBuffCfg.ServerDamageAdd
		defenceAdd += serverBuffCfg.ServerDefenceAdd
	}

	// 个人 buff
	roleBuffCfg := csv.GetConfig().Cross.Mine.Buff_add[roleBuffLevel]
	if roleBuffCfg != nil {
		hpAdd += roleBuffCfg.RoleHpAdd
		damageAdd += roleBuffCfg.RoleDamageAdd
		defenceAdd += roleBuffCfg.RoleDefenceAdd
	}

	newCardAttrs := schemeutil.CopyCardAttrs(cardAttrs)

	for _, cardAttr := range newCardAttrs {
		// 血量
		cardAttr.Attrs["hp"] *= hpAdd

		// 双攻
		cardAttr.Attrs["damage"] *= damageAdd
		cardAttr.Attrs["specialDamage"] *= damageAdd

		// 双防
		cardAttr.Attrs["defence"] *= defenceAdd
		cardAttr.Attrs["specialDefence"] *= defenceAdd

		// boss 个体值属性 buff
		if bossBuffAdd > 0 {
			for _, attr := range cards.NValueAttrs {
				cardAttr.Attrs[attr] *= (1 + bossBuffAdd)
			}
		}
	}

	return newCardAttrs
}

func inValidTime(openTime float64, duration int) bool {
	now := tjutil.NowTime()
	return openTime < now && openTime+float64(duration*60) > now
}

func bossDamgeIsCheat(clientDamges, agentDamages map[document.Integer]int) bool {
	var clientSum, agentSum int
	for _, v := range clientDamges {
		clientSum += v
	}
	for _, v := range agentDamages {
		agentSum += v
	}

	if clientSum > int(float64(agentSum)*GetConfig().BossAgentCheckDamgeFix) {
		return true
	} else {
		return false
	}
}

func getMergeServKey(key string) string {
	return csv.GetMergeConfig().GetMergeServKey(key)
}

func isFriendlyForces(key1, key2 string) bool {
	cfg := csv.GetMergeConfig()
	return cfg.GetMergeServKey(key1) == cfg.GetMergeServKey(key2)
}

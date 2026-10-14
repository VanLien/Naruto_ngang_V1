/*
 * @Time     : 2019/10/15 16:25
 * @Author   : cancan
 * @File     : global.go
 * @Function :
 */

package clone

import (
	"sort"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
)

type CloneGlobal struct {
	*scheme.CloneGlobalObject

	s *Service

	*Lobby
}

func NewCloneGlobal(global *scheme.CloneGlobal) *CloneGlobal {
	c := &CloneGlobal{
		CloneGlobalObject: scheme.NewCloneGlobalObject(global),
		Lobby:             NewLobby(),
	}
	return c
}

func (c *CloneGlobal) init() {
	natures := c.CloneNatures()
	if len(natures) == 0 {
		c.RefreshNature(0)
		return
	}

	natureSlice := make([]int, 0, len(natures))
	for _, v := range natures {
		natureSlice = append(natureSlice, v.Nature)
	}
	c.Lobby.ResetFast(natureSlice)
}

// 刷新元素
func (c *CloneGlobal) RefreshNature(serverOpenDays int) {
	_, unlock := c.LockAndGetDB()
	defer unlock()
	natures := c.randNature()
	raritys := c.randRarity()
	natureMonster := c.randMonster(natures, c.createSupData(natures, raritys, serverOpenDays))
	c.setNatureList(natures, natureMonster)
}

func (c *CloneGlobal) setNatureList(natures []int, natureMonster map[int][]int) {
	cloneCDRecord := c.CloneCDRecord()
	if cloneCDRecord.Nature == nil {
		cloneCDRecord.Nature = make(map[document.Integer]int)
	}
	if cloneCDRecord.Monster == nil {
		cloneCDRecord.Monster = make(map[document.Integer]int)
	}
	now := util.Perioddate2int(CloneRefreshTime, util.Now())
	newNatureList := make([]scheme.Nature, 0, 5)
	for i := len(natures) - 1; i >= 0; i-- {
		nature := natures[i]
		monsters := natureMonster[nature]
		sort.Sort(Monsters(monsters))
		cloneCDRecord.Nature[document.Integer(nature)] = now
		for _, v := range monsters {
			cloneCDRecord.Monster[document.Integer(v)] = now
		}
		newNatureList = append(newNatureList, scheme.Nature{Nature: nature, Monster: monsters})
	}

	yynm := c.CloneYYNature()
	if yynm != nil {
		newNatureList = append(newNatureList, scheme.Nature{Nature: yynm.Nature, Monster: yynm.Monster})
		natures = append(natures, yynm.Nature)
	}

	c.SetCloneNatures(newNatureList)
	c.SetCloneCDRecord(cloneCDRecord)
	c.Refresh(natures)
}

func (c *CloneGlobal) randRarity() []int {
	csvID := GetConfig().RarityRandom.GetRandom().(util.WeightInts)[0]
	rarityMatch := csv.GetConfig().Clone.Rarity[csvID].RarityMatch.ToIntMap()
	raritys := make([]int, 0, 12)
	for rarity, num := range rarityMatch {
		for i := 0; i < num; i++ {
			raritys = append(raritys, rarity)
		}
	}
	sort.Ints(raritys)
	return raritys
}

func (c *CloneGlobal) randNature() []int {
	cloneCDRecord := c.CloneCDRecord()
	yynm := c.CloneYYNature()
	cfg := csv.GetConfig().Clone.Nature
	weights := make([]util.WeightElement, 0, len(cfg))
	for idx, v := range cfg {
		if yynm != nil && yynm.Nature == idx {
			continue
		}
		if old, ok := cloneCDRecord.Nature[document.Integer(idx)]; ok && InCDTime(old, v.CDTime) {
			//log.Infof("nature %v old %v now %v cd ....\n", k, old, tjtime.Perioddate2int(CloneRefreshTime, tjtime.Now()))
			continue
		}

		if v.Weight <= 0 {
			continue
		}

		weights = append(weights, util.WeightInts{v.ID, v.Weight})
	}
	randNatureInts := util.OnceSimpleRandom(weights, 5)
	randNature := make([]int, 0, 5)
	for _, v := range randNatureInts {
		randNature = append(randNature, v.(util.WeightInts)[0])
	}
	sort.Ints(randNature)
	return randNature
}

func (c *CloneGlobal) createSupData(randNature []int, monsterRarity []int, serverOpenDays int) map[int]map[int]*RandWeightObj {
	tmp := make(map[int]map[int]*RandWeightTmp)
	nmw := make(map[int]map[int]*RandWeightObj)
	for _, v := range randNature {
		tmp[v] = make(map[int]*RandWeightTmp)
		nmw[v] = make(map[int]*RandWeightObj)
	}

	natureIndex := 0
	monsterIndex := 0
	randNatureNum := len(randNature)
	for monsterIndex < len(monsterRarity) {
		nature := randNature[natureIndex]
		rarity := monsterRarity[monsterIndex]
		if _, ok := nmw[nature][rarity]; !ok {
			nmw[nature][rarity] = &RandWeightObj{}
		}
		nmw[nature][rarity].RandNum++
		monsterIndex++
		natureIndex++
		if natureIndex == randNatureNum {
			natureIndex = 0
		}
	}

	cloneCDRecord := c.CloneCDRecord()
	config := csv.GetConfig()
	cfg := config.Clone.Monster
	for idx, v := range cfg {
		if serverOpenDays < v.ServerOpenDays {
			continue
		}
		if old, ok := cloneCDRecord.Monster[document.Integer(idx)]; ok && InCDTime(old, v.CDTime) {
			//log.Infof("monster %v old %v now %v cd ....\n", k, old, tjtime.Perioddate2int(CloneRefreshTime, tjtime.Now()))
			continue
		}
		card := config.Cards[v.CardID]
		if card == nil {
			log.Warningf("Clone createSupData monster %v not find card", idx)
			continue
		}
		if !tj.IsLanguageOpen(card.Languages.ToStringSlice()) {
			continue
		}
		rarity := config.Unit[card.UnitID].Rarity
		natureType := config.Unit[card.UnitID].NatureType
		natureType2 := config.Unit[card.UnitID].NatureType2
		var nature, weight int
		// 需求变动：原本只要第一属性存在则不会出现在第二属性随机库中，改为增加一个权重判断控制是否出现在第一属性还是第二属性
		// 配置上保证同一系列精灵只会出现在一个元素里面
		if _, ok := nmw[natureType]; ok && v.Weight > 0 {
			nature = natureType
			weight = v.Weight
		} else if _, ok := nmw[natureType2]; ok && v.Weight2 > 0 {
			nature = natureType2
			weight = v.Weight2
		} else {
			continue
		}

		if _, ok := tmp[nature][rarity]; !ok {
			tmp[nature][rarity] = &RandWeightTmp{}
		}

		if weight <= 0 {
			continue
		}

		if cfg[idx].IsForce == 1 {
			tmp[nature][rarity].ForceWeights = append(tmp[nature][rarity].ForceWeights, util.WeightInts{idx, weight})
		} else {
			tmp[nature][rarity].Weights = append(tmp[nature][rarity].Weights, util.WeightInts{idx, weight})
		}
	}

	for nature, v := range tmp {
		for rarity, weightTmp := range v {
			if _, ok := nmw[nature][rarity]; !ok {
				nmw[nature][rarity] = &RandWeightObj{}
			}
			if len(weightTmp.Weights) > 0 {
				nmw[nature][rarity].Obj = util.NewWeightRandom(weightTmp.Weights)
			}
			if len(weightTmp.ForceWeights) > 0 {
				nmw[nature][rarity].ForceObj = util.NewWeightRandom(weightTmp.ForceWeights)
			}
		}
	}

	return nmw
}

func (c *CloneGlobal) randMonster(natures []int, nmw map[int]map[int]*RandWeightObj) map[int][]int {
	natureMonster := make(map[int][]int)
	for _, v := range natures {
		natureMonster[v] = []int{}
	}

	config := csv.GetConfig()
	for nature, v := range nmw {
		var tmpMonster, tmpMarkID int
		hasMarkID := make(map[int]int)
		raritySlice := []int{}
		for rarity, weights := range v {
			raritySlice = append(raritySlice, rarity)
			// 备用稀有度随机库
			if weights.RandNum <= 0 {
				continue
			}
			n := 0
			for !weights.IsEmpty() && n < weights.RandNum {
				tmpMonster = weights.RandOneMonster()
				tmpMarkID = config.Cards[config.Clone.Monster[tmpMonster].CardID].CardMarkID
				if _, ok := hasMarkID[tmpMarkID]; ok {
					continue
				} else {
					hasMarkID[tmpMarkID] = tmpMonster
				}
				natureMonster[nature] = append(natureMonster[nature], tmpMonster)
				n++
			}
		}
		sort.Ints(raritySlice)
		for i := 0; i < len(raritySlice) && len(natureMonster[nature]) < 3; i++ {
			rarity := raritySlice[i]
			if _, ok := nmw[nature][rarity]; !ok {
				continue
			}
			for !nmw[nature][rarity].IsEmpty() && len(natureMonster[nature]) < 3 {
				tmpMonster = nmw[nature][rarity].RandOneMonster()
				tmpMarkID = config.Cards[config.Clone.Monster[tmpMonster].CardID].CardMarkID
				if _, ok := hasMarkID[tmpMarkID]; ok {
					continue
				} else {
					hasMarkID[tmpMarkID] = tmpMonster
				}
				natureMonster[nature] = append(natureMonster[nature], tmpMonster)
			}
		}
	}
	return natureMonster
}

func (c *CloneGlobal) YYActive(yyObj *scheme.CloneYYNature) {
	if yyObj == nil {
		return
	}
	if yyObj.YYID <= 0 || yyObj.Nature <= 0 || len(yyObj.Monster) == 0 {
		log.Warningf("Clone YYActive Error %d %d %v", yyObj.YYID, yyObj.Nature, yyObj.Monster)
		return
	}
	c.Lock()
	defer c.Unlock()
	c.SetCloneYYNature(yyObj)
}

func (c *CloneGlobal) YYClose() {
	c.Lock()
	defer c.Unlock()
	c.SetCloneYYNature(nil)
}

func (c *CloneGlobal) monsters(csvID int) ([]int, bool) {
	for _, v := range c.CloneNatures() {
		if v.Nature == csvID {
			ret := make([]int, len(v.Monster))
			copy(ret, v.Monster)
			return ret, true
		}
	}
	return nil, false
}

func (c *CloneGlobal) CheckRoleCards(natureID int, markIDs []int) ([]int, error) {
	c.Lock()
	defer c.Unlock()
	monsters, ok := c.monsters(natureID)
	if !ok {
		return nil, ErrNatureNotExists
	}
	config := csv.GetConfig()
	check := make(map[int]bool)
	log.Warningf("CheckRoleCards - monsters=%v ", monsters)
	for _, monster := range monsters {
		cfg := config.Clone.Monster[monster]
		check[config.Cards[cfg.CardID].CardMarkID] = true
	}
	log.Infof("CheckRoleCards - config.Clone.Monster[]=%v ", config.Clone.Monster)
	log.Infof("CheckRoleCards - config.Cards[]=%v ", config.Cards)
	flag := false
	for _, markID := range markIDs {
		if _, ok := check[markID]; ok {
			flag = true
			break
		}
	}
	if flag {
		return monsters, nil
	}
	return nil, ErrCanNotJoinRoom
}

type Monsters []int

func (s Monsters) Len() int {
	return len(s)
}

func (s Monsters) Less(i, j int) bool {
	config := csv.GetConfig()
	card1 := config.Cards[config.Clone.Monster[s[i]].CardID]
	card2 := config.Cards[config.Clone.Monster[s[j]].CardID]
	rarity1 := config.Unit[card1.UnitID].Rarity
	rarity2 := config.Unit[card2.UnitID].Rarity
	if rarity1 == rarity2 {
		return i < j
	}
	return rarity1 < rarity2
}

func (s Monsters) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}

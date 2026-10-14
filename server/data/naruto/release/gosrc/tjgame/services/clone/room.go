/*
 * @Time     : 2019/10/16 11:52
 * @Author   : cancan
 * @File     : room.go
 * @Function :
 */

package clone

import (
	"fmt"
	"math"
	"math/rand"
	"strconv"
	"sync"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/util"
)

var ClonePlaces = [5]int{1, 2, 3, 4, 5}

type CloneRoom struct {
	*scheme.CloneRoomObject
	battleMap sync.Map // {role.id: *ClonePlayRecord}
	robotMap  sync.Map // {role.id: robots}
	robot2Map sync.Map // {role.id: robots2}
}

func NewCloneRoom(cloneRoom *scheme.CloneRoom) *CloneRoom {
	return &CloneRoom{
		CloneRoomObject: scheme.NewCloneRoomObject(cloneRoom),
	}
}

func (r *CloneRoom) join(role ReqRoleJoin) (int, error) {
	if r.isPast() {
		return 0, ErrRoomOutDate
	}
	if r.inRoom(role.ID) {
		return 0, ErrAlreadyInRoom
	}
	if r.space() <= 0 {
		return 0, ErrRoomFull
	}
	places := r.Places()
	for _, v := range ClonePlaces {
		pk := document.Integer(v)
		if _, ok := places[pk]; !ok {
			places[pk] = &scheme.CloneRoomPlace{
				ID:           role.ID,
				Play:         0,
				Name:         role.Name,
				Logo:         role.Logo,
				Vip:          role.Vip,
				Frame:        role.Frame,
				Level:        role.Level,
				Monster:      -1, // -1 表示没有选择目标精灵
				Card:         role.Card,
				Card2:        role.Card2,
				CanQuit:      true,
				BattleDeploy: make([]document.ID, 0, 6),
				NeedRobot:    false,
				Time:         int(util.NowTime()),
				KickLeader:   0,
			}
			break
		}
	}
	r.SetPlaces(places)
	return r.space(), nil
}

func (r *CloneRoom) quit(roleID document.ID, isKicked bool) (int, error) {
	if r.isPast() {
		return 0, ErrRoomOutDate
	}

	name := ""

	idx := 0
	places := r.Places()
	for k, place := range places {
		if place.ID == roleID {
			idx = int(k)
			// 是否可以踢出在之前已经判断
			// 被踢出时 不考虑 canQuit 字段
			if !place.CanQuit && !isKicked {
				return 0, ErrCanNotQuitRoom
			}

			name = place.Name
			delete(places, k)

			break
		}
	}
	r.SetPlaces(places)

	if r.Leader() == roleID {
		r.changeLeader()
	}

	if idx == 0 {
		return 0, ErrNotInRoom
	}

	if isKicked {
		r.addHistory(HistoryBeKicked, name)
	}

	return r.space(), nil
}

func (r *CloneRoom) changeLeader() {
	r.SetLeader("")

	places := r.Places()
	var rolePlace *scheme.CloneRoomPlace
	var changePk document.Integer
	for _, v := range ClonePlaces {
		pk := document.Integer(v)
		if _, ok := places[pk]; ok {
			if rolePlace == nil {
				rolePlace = places[pk]
				changePk = pk
			}

			if places[pk].Play > rolePlace.Play {
				rolePlace = places[pk]
				changePk = pk
			}
		}
	}

	if rolePlace != nil {
		delete(places, changePk)
		places[document.Integer(ClonePlaces[0])] = rolePlace
		r.SetLeader(rolePlace.ID)
		r.SetPlaces(places)
	}
}

func (r *CloneRoom) space() int {
	return CloneRoomMemberMax - len(r.Places())
}

func (r *CloneRoom) inRoom(roleID document.ID) bool {
	for _, v := range r.Places() {
		if v.ID == roleID {
			return true
		}
	}
	return false
}

func (r *CloneRoom) deployCard(roleID document.ID, card *scheme.CardBattleModel, card2 *scheme.CardBattleModel) {
	places := r.Places()
	for _, v := range places {
		if v.ID == roleID {
			v.Card = card
			v.Card2 = card2
		}
	}
	r.SetPlaces(places)
}

func (r *CloneRoom) getRoleMonster(roleID document.ID) int {
	places := r.Places()
	for _, v := range places {
		if v.ID == roleID {
			return v.Monster
		}
	}
	return -1
}

func (r *CloneRoom) battleStart(csvID int, rolePlace *scheme.CloneRoomPlace, cardIDs []document.ID, role ReqRoleBattle, bf BattleFix) *ClonePlayRecord {
	record := &ClonePlayRecord{
		ID:       document.ID(CreateBattleID(role.ID)),
		Date:     util.Todaydate2int(),
		Time:     util.NowTime(),
		RandSeed: rand.Int31n(99999999) + 1,
		RoleDbId: role.ID,
		Name:     role.Name,
		Logo:     role.Logo,
		Level:    role.Level,
		Frame:    role.Frame,
		Figure:   role.Figure,
		Cards:    cardIDs,
	}
	record.CardAttrs = make(map[document.ID]*scheme.CardBattleModel)
	record.CardAttrs2 = make(map[document.ID]*scheme.CardBattleModel)
	var cards []*scheme.CardBattleModel
	places := r.Places()
	for _, v := range places {
		record.CardAttrs[v.Card.ID] = v.Card
		cards = append(cards, v.Card)
		if v.Card2 != nil {
			record.CardAttrs2[v.Card2.ID] = v.Card2
		}
	}

	config := csv.GetConfig()

	robots, robots2 := r.getRobots(rolePlace)
	if len(robots) > 0 {
		for k, v := range robots {
			record.CardAttrs[k] = v
			if config.Unit[config.Cards[v.CardId].UnitID].TwinFlag {
				record.CardAttrs2[k] = robots2[k]
			}
			cards = append(cards, v)
		}
	}

	roomMonsters := r.Monsters()
	mLen := len(roomMonsters)
	mIndex := rolePlace.Play
	if mIndex > mLen-1 {
		mIndex = mLen - 1
	}

	monsterCardID := config.Clone.Monster[roomMonsters[mIndex]].CardID
	record.DefenceName = config.Cards[monsterCardID].Name
	record.DefenceLogo = config.Cards[monsterCardID].UnitID
	record.DefenceLevel = rolePlace.Card.Level
	record.DefenceCards = make([]document.ID, 6)
	record.DefenceCardAttrs = make(map[document.ID]*scheme.CardBattleModel)
	record.DefenceCardAttrs2 = make(map[document.ID]*scheme.CardBattleModel)
	monsters, monsters2 := r.createMonsters(monsterCardID, cards, bf, rolePlace)
	twinFlag := config.Unit[config.Cards[monsterCardID].UnitID].TwinFlag
	idx := 0
	for k, v := range monsters {
		record.DefenceCards[idx] = k
		record.DefenceCardAttrs[k] = v
		if twinFlag {
			record.DefenceCardAttrs2[k] = monsters2[k]
		}
		idx++
	}

	r.battleMap.Store(role.ID, record)
	return record
}

func (r *CloneRoom) createMonsters(monsterCardID int, cards []*scheme.CardBattleModel, bf BattleFix, rolePlace *scheme.CloneRoomPlace) (map[document.ID]*scheme.CardBattleModel, map[document.ID]*scheme.CardBattleModel) {
	monsters := map[document.ID]*scheme.CardBattleModel{}
	monsters2 := map[document.ID]*scheme.CardBattleModel{}
	levelAvg := 0
	attrsAvg := make(map[string]float64)
	attrs2Avg := make(map[string]float64)
	cardCfg := csv.GetConfig().Cards[monsterCardID]
	unitCfg := csv.GetConfig().Unit[cardCfg.UnitID]
	for i, v := range cards {
		skillLevel := int(math.Ceil(float64(v.Level) * bf.SkillLevelFix))
		levelAvg += v.Level
		monster := &scheme.CardBattleModel{
			ID:            document.ID(fmt.Sprintf("%v", i)),
			CardId:        monsterCardID,
			SkinId:        0,
			Level:         v.Level,
			FightingPoint: 0,
			Star:          v.Star,
			Advance:       v.Advance,
		}
		monster.Skills = make(map[document.Integer]int)
		for _, v := range cardCfg.SkillList {
			monster.Skills[document.Integer(v.(int64))] = skillLevel
		}
		monster.PassiveSkills = make(map[document.Integer]int)
		monster.Attrs = make(map[string]float64)
		for k, v := range v.Attrs {
			if _, ok := bf.AttrFix[k]; ok {
				monster.Attrs[k] = v * bf.AttrFix[k]
			} else {
				monster.Attrs[k] = v
			}
			attrsAvg[k] += v
		}
		monster.Attrs2 = make(map[string]float64)
		for k, v := range v.Attrs2 {
			if _, ok := bf.AttrFix[k]; ok {
				monster.Attrs2[k] = v * bf.AttrFix[k]
			} else {
				monster.Attrs2[k] = v
			}
			attrs2Avg[k] += v
		}

		monsters[monster.ID] = monster
		if unitCfg.TwinFlag {
			monster2 := makeTwinCardBattleModel(cardCfg.CardMarkID, cardCfg.Branch, cardCfg.Develop, skillLevel, monster)
			monsters2[monster2.ID] = monster2
		}
	}

	roleCardNum := len(monsters)
	levelAvg = int(math.Ceil(float64(levelAvg) / float64(roleCardNum)))
	skillLevel := int(math.Ceil(float64(levelAvg) * bf.SkillLevelFix))
	for k, v := range attrsAvg {
		attrsAvg[k] = v / float64(roleCardNum)
	}
	for k, v := range attrs2Avg {
		attrs2Avg[k] = v / float64(roleCardNum)
	}

	for i := roleCardNum; i < 6; i++ {
		monster := &scheme.CardBattleModel{
			ID:            document.ID(strconv.Itoa(i)),
			CardId:        monsterCardID,
			SkinId:        0,
			Level:         levelAvg,
			FightingPoint: 0,
			Star:          rolePlace.Card.Star,
			Advance:       rolePlace.Card.Advance,
		}
		monster.Skills = make(map[document.Integer]int)
		for _, v := range cardCfg.SkillList {
			monster.Skills[document.Integer(v.(int64))] = skillLevel
		}
		monster.PassiveSkills = make(map[document.Integer]int)
		monster.Attrs = make(map[string]float64)
		for k, v := range attrsAvg {
			monster.Attrs[k] = v
		}
		monster.Attrs2 = make(map[string]float64)
		for k, v := range attrs2Avg {
			monster.Attrs2[k] = v
		}

		monsters[monster.ID] = monster
		if unitCfg.TwinFlag {
			monster2 := makeTwinCardBattleModel(cardCfg.CardMarkID, cardCfg.Branch, cardCfg.Develop, skillLevel, monster)
			monsters2[monster2.ID] = monster2
		}
	}

	return monsters, monsters2
}

func (r *CloneRoom) getPlaceByRoleID(roleID document.ID) *scheme.CloneRoomPlace {
	places := r.Places()
	for _, v := range places {
		if v.ID == roleID {
			return v
		}
	}
	return nil
}

func (r *CloneRoom) checkBattleCards(rolePlace *scheme.CloneRoomPlace, cardIDs []document.ID) bool {
	check := make(map[document.ID]bool)

	robots, _ := r.getRobots(rolePlace)

	for _, v := range cardIDs {
		if v != "" {
			if string(v)[:len(CloneRobotPrfeix)] == CloneRobotPrfeix {
				// 服务器重启内存中的机器人删除
				if len(robots) <= 0 {
					return false
				}
				if _, ok := robots[v]; !ok {
					return false
				}
			} else {
				check[v] = true
			}
		}
	}

	places := r.Places()
	nowCardNum := 0
	for _, v := range places {
		if _, ok := check[v.Card.ID]; !ok {
			return false
		}
		nowCardNum++
	}

	if len(check) != nowCardNum {
		return false
	}

	return true
}

func (r *CloneRoom) updateRolePace(rolePlace *scheme.CloneRoomPlace) {
	places := r.Places()
	for k, v := range places {
		if v.ID == rolePlace.ID {
			places[k] = rolePlace
			r.SetPlaces(places)
			return
		}
	}
}

func (r *CloneRoom) checkTargetMonster(csvID int) bool {
	monsters := r.Monsters()
	for _, v := range monsters {
		if v == csvID {
			return true
		}
	}
	return false
}

func (r *CloneRoom) getBattleByRoleID(roleID document.ID) *ClonePlayRecord {
	if cache, ok := r.battleMap.Load(roleID); ok {
		return cache.(*ClonePlayRecord)
	} else {
		return nil
	}
}

func (r *CloneRoom) calcFinishMailAward(roleID document.ID) []BattleFinishMail {
	places := r.Places()
	var first *scheme.CloneRoomPlace
	whos := []*scheme.CloneRoomPlace{}
	count := 0
	for _, v := range places {
		if v.Play >= ClonePlayMaxTimes {
			count++
			whos = append(whos, v)
			if v.ID == roleID {
				first = v
			}
		}
	}
	finished := count
	r.SetFinishNum(finished)

	ret := []BattleFinishMail{}
	if count < CloneFinishLimit {
		return ret
	}

	clonecfg := csv.GetConfig().Clone

	for _, v := range whos {
		ret = append(ret, BattleFinishMail{
			RoleDBID: v.ID,
			Count:    count,
			Award:    clonecfg.Monster[v.Monster].ExtraAward,
		})
	}

	if first != nil {
		count--
		for count >= CloneFinishLimit {
			ret = append(ret, BattleFinishMail{
				RoleDBID: first.ID,
				Count:    count,
				Award:    clonecfg.Monster[first.Monster].ExtraAward,
			})
			count--
		}
	}

	return ret
}

func (r *CloneRoom) isLeader(roleID document.ID) bool {
	return r.Leader() == roleID
}

func (r *CloneRoom) isPast() bool {
	return r.Discard()
}

func (r *CloneRoom) InRoom(id document.ID) bool {
	r.RLock()
	defer r.RUnlock()

	if r.isPast() {
		return false
	}
	return r.inRoom(id)
}

func (r *CloneRoom) setNeedRobot(roleID document.ID, enbale bool) {
	places := r.Places()
	for _, v := range places {
		if v.ID == roleID {
			v.NeedRobot = enbale
		}
	}
	r.SetPlaces(places)
}

func (r *CloneRoom) getRobots(rolePlace *scheme.CloneRoomPlace) (map[document.ID]*scheme.CardBattleModel, map[document.ID]*scheme.CardBattleModel) {
	if !rolePlace.NeedRobot {
		return nil, nil
	}

	if !r.inUseRobotTime() {
		return nil, nil
	}

	var robots, robots2 map[document.ID]*scheme.CardBattleModel

	cache1, ok1 := r.robotMap.Load(rolePlace.ID)
	cache2, ok2 := r.robot2Map.Load(rolePlace.ID)
	if ok1 {
		robots = cache1.(map[document.ID]*scheme.CardBattleModel)
	}
	if ok2 {
		robots2 = cache2.(map[document.ID]*scheme.CardBattleModel)
	}

	return robots, robots2
}

func (r *CloneRoom) createRobot(roleID document.ID) map[document.ID]*scheme.CardBattleModel {
	places := r.Places()
	maxFP := 0
	var maxPlaceKey document.Integer
	for k, v := range places {
		if v.ID == roleID {
			if !v.NeedRobot {
				return nil
			}

			if !r.inUseRobotTime() {
				return nil
			}
		}
		if v.Card.FightingPoint > maxFP {
			maxFP = v.Card.FightingPoint
			maxPlaceKey = k
		}
	}
	maxCard := places[maxPlaceKey].Card
	natureRobotCfg := GetConfig().NatureRobotMap[r.NatureID()]
	cardcfgs := csv.GetConfig().Cards
	unitcfgs := csv.GetConfig().Unit
	space := r.space()
	robots := make(map[document.ID]*scheme.CardBattleModel)
	robots2 := make(map[document.ID]*scheme.CardBattleModel)
	for i := 0; i < space; i++ {
		cardID := natureRobotCfg.CardIDs[i]
		robotLevel := int(math.Ceil(float64(maxCard.Level) * natureRobotCfg.LevelFix))
		robot := &scheme.CardBattleModel{
			ID:            document.ID(fmt.Sprintf(CloneRobotPrfeix+"%d", i)),
			CardId:        cardID,
			Level:         robotLevel,
			Star:          maxCard.Star,
			Advance:       maxCard.Advance,
			Skills:        make(map[document.Integer]int),
			PassiveSkills: make(map[document.Integer]int),
			Attrs:         make(map[string]float64),
			Attrs2:        make(map[string]float64),
		}
		for _, v := range cardcfgs[cardID].SkillList {
			robot.Skills[document.Integer(v.(int64))] = robotLevel
		}
		for k, v := range maxCard.Attrs {
			if _, ok := natureRobotCfg.AttrFix[k]; ok {
				robot.Attrs[k] = v * natureRobotCfg.AttrFix[k]
			} else {
				robot.Attrs[k] = v
			}
		}
		for k, v := range maxCard.Attrs2 {
			if _, ok := natureRobotCfg.AttrFix[k]; ok {
				robot.Attrs2[k] = v * natureRobotCfg.AttrFix[k]
			} else {
				robot.Attrs2[k] = v
			}
		}

		robots[robot.ID] = robot
		if unitcfgs[cardcfgs[cardID].UnitID].TwinFlag {
			cardCfg := cardcfgs[cardID]
			robot2 := makeTwinCardBattleModel(cardCfg.CardMarkID, cardCfg.Branch, cardCfg.Develop, robotLevel, robot)
			robots2[robot2.ID] = robot2
		}
	}
	r.robotMap.Store(roleID, robots)
	r.robot2Map.Store(roleID, robots2)
	return robots
}

func (r *CloneRoom) inUseRobotTime() bool {
	cfg := GetConfig()
	if int(util.NowTime())-r.CreateTime() > cfg.CloneRobotTime*60 ||
		GetCloneNextRefreshTime()-r.CreateTime() < cfg.CloneRobotRefreshTime*60 {
		return true
	}
	return false
}

func (r *CloneRoom) Clear() {
	r.Lock()
	defer r.Unlock()

	r.SetDiscard(true)
	r.SetPlaces(make(map[document.Integer]*scheme.CloneRoomPlace))
	r.battleMap.Range(func(key, value interface{}) bool {
		r.battleMap.Delete(key)
		return true
	})
	r.robotMap.Range(func(key, value interface{}) bool {
		r.robotMap.Delete(key)
		return true
	})
	r.robot2Map.Range(func(key, value interface{}) bool {
		r.robot2Map.Delete(key)
		return true
	})
}

func (r *CloneRoom) canKick(roleID, kickRoleID document.ID, inVote bool) bool {
	leader := r.Leader()
	// 投票只能投票房主
	if inVote && leader != kickRoleID {
		return false
	}

	// 非投票中房主不能踢自己，不是房主不能踢人
	if !inVote && (leader != roleID || leader == kickRoleID) {
		return false
	}

	var rolePlace, kickRolePlace *scheme.CloneRoomPlace
	finishNum := 0

	for _, place := range r.Places() {
		switch place.ID {
		case roleID:
			rolePlace = place
		case kickRoleID:
			kickRolePlace = place
		}

		if place.Play >= ClonePlayMaxTimes {
			finishNum++
		}
	}

	if rolePlace == nil {
		return false
	}

	// 房主踢房客，自己完成过至少 1 次
	// 房客投票房主，自己需要完成 3 次
	if kickRoleID == leader {
		if rolePlace.Play < ClonePlayMaxTimes {
			return false
		}
	} else {
		if rolePlace.Play < 1 {
			return false
		}
	}

	// 投票中已经有结果或已经通过过票不能重复投
	if leader == kickRoleID && (r.VoteRound() == "end" || r.VoteRound() == "fail" || rolePlace.KickLeader != 0) {
		return false
	}

	// 完成人数不足不能踢
	if finishNum < GetConfig().CloneCanKickFinishNum {
		return false
	}

	// 被踢的人已经退出房间
	if kickRolePlace == nil {
		return false
	}

	// 角色呆的时间没到不能踢
	if int(util.NowTime())-kickRolePlace.Time <= GetConfig().CLoneCanKickTime*60 {
		return false
	}

	// 已经打赢过一次了不能踢
	if kickRolePlace.Play > 0 {
		return false
	}

	return true
}

func (r *CloneRoom) setKickLeader(roleID document.ID, vote int) {
	places := r.Places()
	winNum := 0   // 赞成票数
	failNum := 0  // 反对票数
	totalNum := 0 // 总可投票人数
	for _, place := range places {
		// 未完成过3次的无法投票
		if place.Play < ClonePlayMaxTimes {
			continue
		}

		if place.ID == roleID {
			place.KickLeader = vote
		}

		switch place.KickLeader {
		case 1:
			winNum++
		case -1:
			failNum++
		}

		totalNum++
	}

	r.SetPlaces(places)

	target := totalNum / 2

	if r.VoteRound() == "" {
		r.SetVoteRound("start")
	}

	if winNum > target {
		r.SetVoteRound("win")
		// TODO 测试
	} else if (totalNum%2 == 0 && failNum >= target) || (totalNum%2 != 0 && failNum > target) {
		r.SetVoteRound("fail")
	}
}

func (r *CloneRoom) addHistory(historyType int, name string) {
	history := r.History()
	history = append(history, scheme.CloneHistory{
		Type: historyType,
		Time: int(util.NowTime()),
		Name: name,
	})
	r.SetHistory(history)
}

func (r *CloneRoom) getPlaceRoleName(roleID document.ID) string {
	var ret string
	for _, v := range r.Places() {
		if v.ID == roleID {
			ret = v.Name
			break
		}
	}
	return ret
}

func (r *CloneRoom) resetVote() {
	places := r.Places()
	for _, place := range places {
		place.KickLeader = 0
	}
	r.SetPlaces(places)
	r.SetVoteRound("")
}

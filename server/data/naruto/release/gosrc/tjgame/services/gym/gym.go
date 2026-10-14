package gym

import (
	"errors"
	"strings"
	"sync"
	"time"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	tjutil "tjgame/server_framework/tj/util"
	"tjgame/services/anti-cheat/manager"
	"tjgame/services/game"
)

// GymGlobalObject
type Gym struct {
	*scheme.GymGlobalObject
	container service.IContainer
	builder   *Builder
	key       string
	game      service.IService

	mgr *manager.AgentManager

	vieRankQue map[document.ID]viefor // 记录挑战 因为有start end 防止同一个人被同时挑战
	battles    sync.Map               // 预存挑战 {roleID: battle}

	// 状态定时器
	timer *time.Timer
}

func (gym *Gym) init(game service.IService, builder *Builder) {
	gym.builder = builder
	gym.key = gym.Key()
	gym.game = game
	gym.vieRankQue = make(map[document.ID]viefor)
}

func (gym *Gym) isOver() bool {
	if gym.Round() == "closed" {
		return true
	}
	return false
}

// 赛季初始化及准备 prepare
func (gym *Gym) onPrepare() {
	log.Infof("Gym.onPrepare")
	round := "closed"
	gym.reset()

	gymGates := GetGymGates()
	gym.eventToGame("prepare", EventToGame{GymGates: gymGates}, true)

	// 倒计时
	now := tjutil.Now()
	duration := startTime.Combine(now).Sub(now)

	if TestInQuick {
		duration = TestDuration
		TestInQuick = false
	}
	log.Infof("round %s next %s time delta %s", round, "start", duration)
	gym.timer = time.AfterFunc(duration, gym.onStart)
}

// 快速初始化启动
func (gym *Gym) quickStart() {
	log.Infof("Gym.quickStart")
	round := "closed"
	gym.reset()

	gymGates := GetGymGates()

	gym.eventToGame("prepare", EventToGame{GymGates: gymGates}, true)
	log.Infof("round %s next %s", round, "start")
	gym.onStart()
}

// 赛季开始 prepare -> start
func (gym *Gym) onStart() {
	round := "start"
	tjutil.WithGuard(gym, func() {
		gym.SetRound(round)
	})
	log.Infof("Gym.onStart %s", round)

	gym.eventToGame("start", EventToGame{}, true)

	// 本周周一
	monday := tjutil.Weekinclock5date2int()

	// 倒计时 结束
	duration := closeTime.CombineDateInt(monday).AddDate(0, 0, 6).Sub(tjutil.Now())
	log.Infof("round %s next %s time delta %s", round, "closed", duration)
	gym.timer = time.AfterFunc(duration, gym.onClosed)
}

// 赛季结束 start -> closed
func (gym *Gym) onClosed() {
	round := "closed"
	tjutil.WithGuard(gym, func() {
		gym.SetRound(round)
	})
	log.Infof("Gym.onClosed %s", round)

	gym.eventToGame("closed", EventToGame{LastLeaderRoles: gym.LeaderRoles()}, true)

	tjutil.WithGuard(gym, gym.clean)

	log.Infof("round %s next %s", "closed", "gymLeaderAward")
	// 荣誉馆主奖励
	gym.onLeaderAward()

	// 结束日志 数据
	rGymID := map[document.ID]int{} // {recordID: gymID}
	for gymID, roleInfo := range gym.LeaderRoles() {
		rGymID[roleInfo.RecordID] = int(gymID)
	}
	for recordID, num := range gym.PassNums() {
		closeInfo := scheme.GymCloseInfo{}
		closeInfo.PassNum = num
		record := gym.builder.GetGymRecord(recordID)
		if gymID, ok := rGymID[recordID]; ok {
			closeInfo.LeaderGymID = gymID
		}
		record.setCloseLog(closeInfo)
	}

	// 下一次的启动
	go gym.ResetToday()
}

// 发荣誉馆主奖励 closed -> gymLeaderAward
func (gym *Gym) onLeaderAward() {
	log.Infof("Gym.onLeaderAward")
	leaderRoles := make(map[document.Integer]*scheme.GymRoleInfo)
	tjutil.WithGuard(gym, func() {
		leaderRoles = gym.LeaderRoles()
	})

	leaderRoleIDs := make(map[document.Integer]document.ID)
	for gymID, roleInfo := range leaderRoles {
		leaderRoleIDs[gymID] = roleInfo.RoleID
	}
	gym.eventToGame("gymLeaderAward", EventToGame{LeaderRoleIDs: leaderRoleIDs}, false)
}

func (gym *Gym) reset() {
	log.Infof("Gym Reset %s %s", gym.key, gym.Round())
	gym.SetLeaderRoles(map[document.Integer]*scheme.GymRoleInfo{})
	gym.SetPassNums(map[document.ID]int{})
}

func (gym *Gym) clean() {
	log.Infof("Gym Clean %s %s", gym.key, gym.Round())
	gym.SetRound("closed")
}

func (gym *Gym) ResetToday() {
	round := gym.Round()
	// 本周的周一（自然0点）
	monday := tjutil.WeekDate2int()
	now := tjutil.Now()
	log.Infof("Gym.ResetToday key %s round %s monday %d", gym.key, round, monday)
	if round == "closed" {
		if now.Weekday() == time.Sunday && (now.Hour() > 21 || (now.Hour() == 21 && now.Minute() >= 45)) {
			// 下周一5点
			duration := prepareTime.CombineDateInt(monday).AddDate(0, 0, 7).Sub(tjutil.Now())
			log.Infof("Restart round %s next %s time delta %s", round, "prepare", duration)
			gym.timer = time.AfterFunc(duration, gym.onPrepare)
		} else if now.Weekday() == time.Monday && now.Hour() < 5 {
			// 本周一5点
			duration := prepareTime.CombineDateInt(monday).Sub(tjutil.Now())
			log.Infof("Restart round %s next %s time delta %s", round, "prepare", duration)
			gym.timer = time.AfterFunc(duration, gym.onPrepare)
		} else if now.Weekday() == time.Monday && now.Hour() >= 5 && now.Hour() < 10 {
			gym.onPrepare()
		} else {
			// 立即启动
			gym.quickStart()
		}
	} else if round == "start" {
		// 定时器
		duration := closeTime.CombineDateInt(monday).AddDate(0, 0, 6).Sub(tjutil.Now())
		log.Infof("Restart round %s next %s time delta %s", round, "closed", duration)
		gym.timer = time.AfterFunc(duration, gym.onClosed)
	} else {
		panic("Restart round error")
	}
}

// 道馆馆主空时占坑
func (gym *Gym) occupyGymLeader(roleInfo scheme.GymRoleInfo, gymID int) error {
	db, unlock := gym.LockAndGetDB()
	defer unlock()

	// 判断 该道馆馆主是否是空的
	if _, ok := db.LeaderRoles[document.Integer(gymID)]; ok {
		return ErrGymLeaderNotEmpty
	}

	// 判断是否是其他馆主，有则删掉
	for gID, r := range db.LeaderRoles {
		if r.RoleID == roleInfo.RoleID {
			delete(db.LeaderRoles, gID)
			break
		}
	}

	// 自己变身新馆主
	db.LeaderRoles[document.Integer(gymID)] = &roleInfo
	gym.SetLeaderRoles(db.LeaderRoles)

	// 占领本服某馆主 日志
	record := gym.builder.GetGymRecord(roleInfo.RecordID)
	logInfo := scheme.GymLogInfo{
		Time:  tjutil.NowTime(),
		Type:  GymOccupy,
		GymID: gymID,
	}
	record.addLog(logInfo)

	return nil
}

// 战斗缓存
func (gym *Gym) storeForRole(gymID int, roleID, enemyRoleID, recordID, enemyRecordID document.ID) error {
	db, unlock := gym.LockAndGetDB()
	defer unlock()

	// 判断对手 是否还是该道馆馆主
	roleInfo, ok := db.LeaderRoles[document.Integer(gymID)]
	if !ok || roleInfo.RoleID != enemyRoleID || roleInfo.RecordID != enemyRecordID {
		return ErrGymLeaderEnemyChanged
	}

	// 判断对手 是否正在战斗
	if v, ok := gym.vieRankQue[enemyRoleID]; ok {
		if time.Now().Unix()-v.time < 60 {
			return ErrInBattle
		}
	}

	gym.vieRankQue[enemyRoleID] = viefor{roleID, recordID, enemyRoleID, enemyRecordID, time.Now().Unix()}
	return nil
}

// 战斗结果处理
func (gym *Gym) resultForRole(roleID document.ID, bb *battle, result string, gymID int) error {
	db, unlock := gym.LockAndGetDB()
	defer unlock()

	v, ok := gym.vieRankQue[bb.enemyRoleID]
	if !ok {
		return ErrNotInBattle
	}
	if v.role != roleID {
		return errors.New("not your battle")
	}
	// 删除战斗缓存
	delete(gym.vieRankQue, bb.enemyRoleID)

	playRecord := gym.builder.GetGymPlayRecord(bb.playRecordID)
	model, pUnlock := playRecord.LockAndGetDB()
	defer pUnlock()
	if result == "win" {
		// 判断是否是其他馆主，有则删掉
		for gID, r := range db.LeaderRoles {
			if r.RoleID == roleID {
				delete(db.LeaderRoles, gID)
				break
			}
		}

		// 自己变身馆主
		fightingPoint := 0
		for _, battleModel := range model.CardAttrs {
			fightingPoint += battleModel.FightingPoint
		}
		roleInfo := &scheme.GymRoleInfo{
			RoleID: roleID,
			Name:   model.Name,
			Logo:   model.Logo,
			Frame:  model.Frame,
			Level:  model.Level,
			Figure: model.Figure,
			Vip:    model.Vip,

			RecordID:      model.RecordDbId,
			FightingPoint: fightingPoint,
		}
		db.LeaderRoles[document.Integer(gymID)] = roleInfo
		gym.SetLeaderRoles(db.LeaderRoles)
	}
	return nil
}

// 战斗结束
func (gym *Gym) battleEndUpdate(bb *battle, roleID, recordID document.ID, result string, fromAnti bool, gymID int) (*ResponseBattleEnd, error) {
	bb.mu.Lock()
	defer bb.mu.Unlock()

	// 战斗结果判断 客户端和反作弊比较
	if fromAnti {
		bb.result.anticheat = result
		log.Infof(" role %v anti result %s", roleID, result)
	} else {
		bb.result.client = result
	}
	if bb.result.anticheat != "" && bb.result.client != "" && bb.result.anticheat != bb.result.client {
		log.Warningf("role %v cheat, client %s anti %s", roleID, bb.result.client, bb.result.anticheat)
		if !fromAnti {
			return nil, ErrCheat
		}
	}

	playRecord := gym.builder.GetGymPlayRecord(bb.playRecordID)
	model, unlock := playRecord.LockAndGetDB()
	tjutil.WithDefer(func() {
		playRecord.SetResult(result)
	}, unlock)

	// 战斗结果处理（馆主更新）
	err := gym.resultForRole(roleID, bb, result, gymID)
	if err != nil {
		return nil, err
	}

	// 本服馆主 战斗记录
	record := gym.builder.GetGymRecord(model.RecordDbId)
	defenceRecord := gym.builder.GetGymRecord(model.DefenceRecordId)
	history := record.newHistory(playRecord.GymPlayRecordObject, "")
	defenceHistory := defenceRecord.newHistory(playRecord.GymPlayRecordObject, "")
	logInfo1 := scheme.GymLogInfo{}
	logInfo2 := scheme.GymLogInfo{}
	if result == "win" {
		// 进攻方挑战胜利 日志
		logInfo1 = scheme.GymLogInfo{
			Time:             tjutil.NowTime(),
			Type:             GymLeaderWin,
			GymID:            gymID,
			GymBattleHistory: history,
		}
		// 防守方防守失败 日志
		logInfo2 = scheme.GymLogInfo{
			Time:             tjutil.NowTime(),
			Type:             GymLeaderDefenceFail,
			GymID:            gymID,
			GymBattleHistory: defenceHistory,
		}
	} else {
		// 进攻方挑战失败 日志
		logInfo1 = scheme.GymLogInfo{
			Time:             tjutil.NowTime(),
			Type:             GymLeaderFail,
			GymID:            gymID,
			GymBattleHistory: history,
		}
		// 防守方防守成功 日志
		logInfo2 = scheme.GymLogInfo{
			Time:             tjutil.NowTime(),
			Type:             GymLeaderDefenceWin,
			GymID:            gymID,
			GymBattleHistory: defenceHistory,
		}
	}
	record.addLog(logInfo1)
	defenceRecord.addLog(logInfo2)

	return &ResponseBattleEnd{Cards: playRecord.Cards()}, nil
}

func (gym *Gym) eventToGame(event string, data EventToGame, sync bool) *game.GymEventResponse {
	var model *SyncModel
	if gym.game == nil { // maybe in test model
		return nil
	}
	if sync {
		model = gym.syncModel()
	}
	key := service.TransformName(gym.key, "game")
	if strings.Contains(gym.key, "merge") {
		key = service.TransformName(gym.key, "gamemerge")
	}
	resp, err := service.Call(gym.game, "GymEvent", event, key, data, model)
	if err != nil {
		log.Warningf("GymEvent %s response error %v", event, err)
		return nil
	}
	return resp.(*game.GymEventResponse)
}

func (gym *Gym) syncModel() *SyncModel {
	return &SyncModel{}
}

package gym

import (
	"errors"
	"math/rand"
	"sync"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	tjutil "tjgame/server_framework/tj/util"
	"tjgame/services/anti-cheat/manager"
	"tjgame/services/game"
)

// CrossGymGlobalObject
type CrossGym struct {
	*scheme.CrossGymGlobalObject
	container service.IContainer
	builder   *Builder
	key       string

	mgr *manager.AgentManager

	// 状态定时器
	timer      *time.Timer
	vieRankQue map[document.ID]viefor // 记录挑战 因为有start end 防止同一个人被同时挑战
	battles    sync.Map               // 预存挑战 {roleID: battle}
}

func (gym *CrossGym) init(builder *Builder) {
	gym.builder = builder
	gym.key = gym.Key()
	gym.vieRankQue = make(map[document.ID]viefor)
}

func (gym *CrossGym) SetAgentManager(name string, agent service.IService) {
	if gym.mgr != nil {
		gym.mgr.Stop()
		gym.mgr = nil
	}
	gym.mgr = manager.NewAgentManager(name, "NewCrossGymBattle", agent)
}

func (gym *CrossGym) IsOver() bool {
	if gym.Round() == "closed" {
		return true
	}
	date := gym.Date()
	if date == 0 {
		return true
	}
	startDate := tjutil.Int2Date(date)
	nowDate := tjutil.Int2Date(tjutil.Todayinclock5date2int())
	duration := nowDate.Sub(startDate)
	return duration > tjutil.OneDay*7
}

func (gym *CrossGym) isServerOK(key string) bool {
	db := gym.GetLockedDB()
	if csv.GetMergeConfig().IsMergeKeyInServers(key, db.Servers) {
		return true
	}
	return false
}

// 跨服赛季开始 重新初始化
func (gym *CrossGym) OnInit(id int, servers []string) {
	log.Infof("CrossGym.OnInit")

	// 给game的数据
	var model *DBForGame
	tjutil.WithGuard(gym, func() {
		ndt := tjutil.Todaydate2int()
		gym.SetDate(ndt)
		gym.SetCsvId(id)
		gym.SetServers(servers)
		gym.reset()
		model = gym.dbForGame()
	})

	// event to game
	gym.eventToGame("crossInit", EventToGame{Model: model}, false)

	round := gym.Round()
	log.Infof("round %s next %s", round, "start")

	// 跨服 初始化的时候 直接开
	gym.onStart()

}

// 跨服赛季开始 init -> start
func (gym *CrossGym) onStart() {
	round := "start"
	tjutil.WithGuard(gym, func() {
		gym.SetRound(round)
	})
	log.Infof("CrossGym.onStart %s", round)

	// 倒计时 结束
	config := csv.GetConfig()
	cfg := config.Cross.Service[gym.CsvId()]
	duration := closeTime.CombineDateInt(cfg.EndDate).Sub(tjutil.Now())
	log.Infof("round %s next %s time delta %s", round, "closed", duration)
	gym.timer = time.AfterFunc(duration, gym.onClosed)
}

// 跨服赛季结束 start -> closed
func (gym *CrossGym) onClosed() {
	round := "closed"
	tjutil.WithGuard(gym, func() {
		gym.SetRound(round)
	})
	log.Infof("CrossGym.onClosed %s", round)

	gym.eventToGame("crossClosed", EventToGame{LastCrossGymRoles: gym.CrossGymRoles()}, false)

	tjutil.WithGuard(gym, gym.clean)

	log.Infof("round %s next %s", "closed", "crossGymAward")
	// 跨服馆主/馆员奖励
	gym.onCrossGymAward()

	// 结束日志 数据
	for gymID, roleInfos := range gym.CrossGymRoles() {
		for pos, roleInfo := range roleInfos {
			closeInfo := scheme.GymCloseInfo{}
			gameKey := roleInfo.GameKey
			gymService := gym.container.GetService(Game2GymService(gameKey))
			if pos == 1 {
				closeInfo.CrossLeaderGymID = int(gymID)
			} else {
				closeInfo.CrossGymID = int(gymID)
			}
			_, _ = service.Call(gymService, "AddCrossGymID", roleInfo.RecordID, closeInfo)
		}
	}

}

// 跨服馆主/馆员奖励 gymLeaderAward -> crossGymAward
func (gym *CrossGym) onCrossGymAward() {
	round := "closed"
	log.Infof("CrossGym.onCrossGymAward %s", round)

	d := gym.getCrossGymAward()
	gym.eventToSomeGame("crossGymAward", d, false)
}

// 获取跨服奖励
func (gym *CrossGym) getCrossGymAward() map[string]*EventToGame {
	db, unlock := gym.RLockAndGetDB()
	defer unlock()
	d := make(map[string]*EventToGame) // {gameKey: EventToGame}
	for gymID, rr := range db.CrossGymRoles {
		for pos, r := range rr {
			gameKey := r.GameKey
			if _, ok := d[gameKey]; !ok {
				d[gameKey] = &EventToGame{
					CrossLeaderRoleIDs:  make(map[document.Integer]document.ID),
					CrossGeneralRoleIDs: make(map[document.Integer][]document.ID),
				}
			}
			if pos == 1 { // 馆主
				d[gameKey].CrossLeaderRoleIDs[gymID] = r.RoleID
			} else {
				if roleIDs, ok := d[gameKey].CrossGeneralRoleIDs[gymID]; ok {
					roleIDs = append(roleIDs, r.RoleID)
					d[gameKey].CrossGeneralRoleIDs[gymID] = roleIDs
				} else {
					d[gameKey].CrossGeneralRoleIDs[gymID] = []document.ID{r.RoleID}
				}
			}
		}
	}
	return d
}

// 跨服数据同步
func (gym *CrossGym) dbForGame() *DBForGame {
	db := gym.GetLockedDB()
	return &DBForGame{
		Servers: db.Servers,
		CsvId:   db.CsvId,
		Date:    db.Date,
		Round:   db.Round,
	}
}

// 同步全量数据
func (gym *CrossGym) syncModel() *SyncModel {
	return &SyncModel{
		Round: gym.Round(),
	}
}

// 事件响应到game (init、start、close)
func (gym *CrossGym) eventToGame(event string, data EventToGame, sync bool) map[string]*game.GymEventResponse {
	d := make(map[string]*EventToGame)
	for _, key := range gym.Servers() {
		d[key] = &data
	}
	return gym.eventToSomeGame(event, d, sync)
}

func (gym *CrossGym) eventToSomeGame(event string, d map[string]*EventToGame, sync bool) map[string]*game.GymEventResponse {
	var model *SyncModel
	if sync {
		model = gym.syncModel()
	}
	keys := make([]string, 0, len(d))
	futures := make([]*service.Future, 0, len(d))
	for key, data := range d {
		keys = append(keys, key)
		s := gym.container.GetService(key)
		future := service.CallAsync(s, "GymEvent", event, key, data, model)
		futures = append(futures, future)
	}

	ret := make(map[string]*game.GymEventResponse)
	resp, err := service.MultiFuture(futures, false).Get()
	if err != nil {
		log.Warningf("GymEvent %s response error %v", event, err)
		return nil
	}
	response := resp.([]interface{})
	for i, key := range keys {
		ret[key] = response[i].(*game.GymEventResponse)
	}
	return ret
}

func (gym *CrossGym) ResetToday() {
	round := gym.Round()
	date := gym.Date()
	server := gym.Servers()
	csvID := gym.CsvId()
	log.Infof("CrossGym.ResetToday date %d round %s", date, round)
	ndt := tjutil.Todaydate2int()

	if round == "closed" {
		// 如果是今天，重新 OnInit
		if ndt == date {
			gym.OnInit(csvID, server)
		}
	} else if round == "start" {
		// 定时器
		config := csv.GetConfig()
		cfg := config.Cross.Service[gym.CsvId()]
		duration := closeTime.CombineDateInt(cfg.EndDate).Sub(tjutil.Now())
		log.Infof("Restart round %s next %s time delta %s", round, "closed", duration)
		gym.timer = time.AfterFunc(duration, gym.onClosed)
	} else {
		panic("Restart round error")
	}
}

func (gym *CrossGym) reset() {
	gym.clean()
	log.Infof("CrossGym Reset %d %s", gym.Date(), gym.Round())
	gym.SetCrossGymRoles(map[document.Integer]map[document.Integer]*scheme.CrossGymRoleInfo{})
}

func (gym *CrossGym) clean() {
	log.Infof("CrossGym Clean %d %s", gym.Date(), gym.Round())
	gym.SetRound("closed")
}

// 跨服道馆位置空时占坑
func (gym *CrossGym) occupyCrossGym(roleInfo scheme.CrossGymRoleInfo, gymID int, pos int) (bool, error) {
	db, unlock := gym.LockAndGetDB()
	defer unlock()

	isSelf := false
	// 判断 该道馆该位置 是否是空的
	if roles, ok := db.CrossGymRoles[document.Integer(gymID)]; ok {
		if role, ok := roles[document.Integer(pos)]; ok {
			if role.RoleID != roleInfo.RoleID {
				return false, ErrGymNotEmpty
			} else {
				isSelf = true
			}
		}
	}

	if !isSelf {
		// 判断是否是其他馆员，有则删掉
		rs := make(map[document.Integer]*scheme.CrossGymRoleInfo)
		for gID, rr := range db.CrossGymRoles {
			for pos, r := range rr {
				if r.RoleID == roleInfo.RoleID {
					rs = rr
					delete(rs, pos)
					db.CrossGymRoles[gID] = rs
					break
				}
			}
		}
	}

	// 自己变身馆员
	if roles, ok := db.CrossGymRoles[document.Integer(gymID)]; ok {
		roles[document.Integer(pos)] = &roleInfo
		db.CrossGymRoles[document.Integer(gymID)] = roles
	} else {
		db.CrossGymRoles[document.Integer(gymID)] = map[document.Integer]*scheme.CrossGymRoleInfo{document.Integer(pos): &roleInfo}
	}
	gym.SetCrossGymRoles(db.CrossGymRoles)

	return isSelf, nil
}

// 战斗缓存
func (gym *CrossGym) storeForRole(gymID int, roleID, enemyRoleID, recordID, enemyRecordID document.ID, pos int) error {
	db, unlock := gym.LockAndGetDB()
	defer unlock()

	// 判断对手 是否还是该道馆馆主
	if roles, ok := db.CrossGymRoles[document.Integer(gymID)]; ok {
		roleInfo, ok2 := roles[document.Integer(pos)]
		if !ok2 || roleInfo.RoleID != enemyRoleID || roleInfo.RecordID != enemyRecordID {
			return ErrGymEnemyChanged
		}
	} else {
		return ErrGymEnemyChanged
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
func (gym *CrossGym) resultForRole(roleID document.ID, bb *battle, result string, gymID int, pos int) (bool, error) {
	db, unlock := gym.LockAndGetDB()
	defer unlock()

	v, ok := gym.vieRankQue[bb.enemyRoleID]
	if !ok {
		return false, ErrNotInBattle
	}
	if v.role != roleID {
		return false, errors.New("not your battle")
	}
	// 删除战斗缓存
	delete(gym.vieRankQue, bb.enemyRoleID)

	playRecord := gym.builder.GetGymPlayRecord(bb.playRecordID)
	model, pUnlock := playRecord.LockAndGetDB()
	defer pUnlock()
	if result == "win" {
		exchangePos := 0
		// 判断是否是其他馆员，有则删掉
		rs := make(map[document.Integer]*scheme.CrossGymRoleInfo)
		for gID, rr := range db.CrossGymRoles {
			for p, r := range rr {
				if r.RoleID == roleID {
					// 同服馆主打馆员 位置不变 阵容变
					if pos != 1 && p == 1 {
						if int(gID) != gymID {
							return false, nil
						}
						return true, nil
					}
					rs = rr
					delete(rs, p)
					db.CrossGymRoles[gID] = rs
					// 同道馆下打上或同级 位置交换
					if gymID == int(gID) {
						exchangePos = int(p)
					}
					break
				}
			}
		}

		// 自己变身馆主
		fightingPoint := 0
		for _, battleModel := range model.CardAttrs {
			fightingPoint += battleModel.FightingPoint
		}
		roleInfo := &scheme.CrossGymRoleInfo{}
		roleInfo.RoleID = roleID
		roleInfo.Name = model.Name
		roleInfo.Logo = model.Logo
		roleInfo.Frame = model.Frame
		roleInfo.Figure = model.Figure
		roleInfo.Vip = model.Vip
		roleInfo.RecordID = model.RecordDbId
		roleInfo.FightingPoint = fightingPoint
		roleInfo.GameKey = model.RoleKey

		if roles, ok := db.CrossGymRoles[document.Integer(gymID)]; ok {
			// 同道馆 对手交换到自己位置
			if exchangePos != 0 {
				roles[document.Integer(exchangePos)] = roles[document.Integer(pos)]
			}
			roles[document.Integer(pos)] = roleInfo
			db.CrossGymRoles[document.Integer(gymID)] = roles
		} else {
			db.CrossGymRoles[document.Integer(gymID)] = map[document.Integer]*scheme.CrossGymRoleInfo{document.Integer(pos): roleInfo}
		}
		gym.SetCrossGymRoles(db.CrossGymRoles)
	}
	return true, nil
}

// 战斗结束
func (gym *CrossGym) battleEndUpdate(bb *battle, roleID, recordID document.ID, result string, fromAnti bool, gymID int, pos int) (*ResponseBattleEndUpdate, error) {
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
	isSwapDeploy, err := gym.resultForRole(roleID, bb, result, gymID, pos)
	if err != nil {
		return nil, err
	}

	// 跨服馆主或馆员 战斗记录
	history := NewHistory(playRecord.GymPlayRecordObject, gym.Key(), 1)
	defenceHistory := NewHistory(playRecord.GymPlayRecordObject, gym.Key(), 2)
	logInfo1 := scheme.GymLogInfo{}
	logInfo2 := scheme.GymLogInfo{}
	if result == "win" {
		key1 := CrossGymLeaderWin
		key2 := CrossGymLeaderDefenceFail
		if pos != 1 {
			key1 = CrossGymWin
			key2 = CrossGymDefenceFail
		}
		// 进攻方挑战胜利 日志
		logInfo1 = scheme.GymLogInfo{
			Time:             tjutil.NowTime(),
			Type:             key1,
			GymID:            gymID,
			GymBattleHistory: history,
		}
		// 防守方防守失败 日志
		logInfo2 = scheme.GymLogInfo{
			Time:             tjutil.NowTime(),
			Type:             key2,
			GymID:            gymID,
			GymBattleHistory: defenceHistory,
		}
	} else {
		key3 := CrossGymLeaderFail
		key4 := CrossGymLeaderDefenceWin
		if pos != 1 {
			key3 = CrossGymFail
			key4 = CrossGymDefenceWin
		}
		// 进攻方挑战失败 日志
		logInfo1 = scheme.GymLogInfo{
			Time:             tjutil.NowTime(),
			Type:             key3,
			GymID:            gymID,
			GymBattleHistory: history,
		}
		// 防守方防守成功 日志
		logInfo2 = scheme.GymLogInfo{
			Time:             tjutil.NowTime(),
			Type:             key4,
			GymID:            gymID,
			GymBattleHistory: defenceHistory,
		}
	}
	res := ResponseBattleEndUpdate{
		Cards:          model.Cards,
		IsSwapDeploy:   isSwapDeploy,
		LogInfo:        logInfo1,
		DefenceLogInfo: logInfo2,
	}
	return &res, nil
}

func NewPlayModel(record, enemyRecord *scheme.GymRecord, roleKey, enemyRoleKey string, deploy gymDeployment) *scheme.GymPlayRecord {

	playModel := document.New("GymPlayRecord", true).(*scheme.GymPlayRecord)

	playModel.Date = tjutil.Todaydate2int()
	playModel.Time = tjutil.NowTime()
	playModel.RandSeed = rand.Int31n(99999999) + 1

	playModel.RoleDbId = record.RoleId
	playModel.RoleKey = roleKey
	playModel.RecordDbId = record.ID
	playModel.Name = record.RoleName
	playModel.Logo = record.RoleLogo
	playModel.Frame = record.RoleFrame
	playModel.Level = record.RoleLevel
	playModel.Vip = record.RoleVip
	playModel.Figure = record.RoleFigure
	playModel.Cards = deploy.CrossCards
	playModel.CardAttrs = deploy.CrossCardAttrs
	playModel.CardAttrs2 = deploy.CrossCardAttrs2
	playModel.PassiveSkills = deploy.CrossPassiveSkills

	playModel.DefenceRoleDbId = enemyRecord.RoleId
	playModel.DefenceRoleKey = enemyRoleKey
	playModel.DefenceRecordId = enemyRecord.ID
	playModel.DefenceName = enemyRecord.RoleName
	playModel.DefenceLogo = enemyRecord.RoleLogo
	playModel.DefenceFrame = enemyRecord.RoleFrame
	playModel.DefenceLevel = enemyRecord.RoleLevel
	playModel.DefenceVip = enemyRecord.RoleVip
	playModel.DefenceFigure = enemyRecord.RoleFigure
	playModel.DefenceCards = enemyRecord.CrossCards
	playModel.DefenceCardAttrs = enemyRecord.CrossCardAttrs
	playModel.DefenceCardAttrs2 = enemyRecord.CrossCardAttrs2
	playModel.DefencePassiveSkills = enemyRecord.CrossPassiveSkills

	return playModel
}

// 构建对战详情
func NewHistory(model *scheme.GymPlayRecordObject, crossKey string, flag int) *scheme.GymBattleHistory {

	h := scheme.GymBattleHistory{}

	cardAttrs := map[document.ID]*scheme.CardSlimModel{}
	for id, v := range model.CardAttrs() {
		cardAttrs[id] = &scheme.CardSlimModel{
			CardId:        v.CardId,
			FightingPoint: v.FightingPoint,
			NatureChoose:  v.NatureChoose,
			Level:         v.Level,
			Star:          v.Star,
			Advance:       v.Advance,
			SkinId:        v.SkinId,
		}
	}
	defenceCardAttrs := map[document.ID]*scheme.CardSlimModel{}
	for id, v := range model.DefenceCardAttrs() {
		defenceCardAttrs[id] = &scheme.CardSlimModel{
			CardId:        v.CardId,
			FightingPoint: v.FightingPoint,
			NatureChoose:  v.NatureChoose,
			Level:         v.Level,
			Star:          v.Star,
			Advance:       v.Advance,
			SkinId:        v.SkinId,
		}
	}
	// 进攻方 1
	if flag == 1 {
		h = scheme.GymBattleHistory{
			Result:       model.Result(),
			CrossKey:     crossKey,
			PlayRecordID: model.GetID(),

			RoleID:    model.RoleDbId(),
			RoleKey:   model.RoleKey(),
			RecordID:  model.RecordDbId(),
			Name:      model.Name(),
			Logo:      model.Logo(),
			Frame:     model.Frame(),
			Level:     model.Level(),
			Vip:       model.Vip(),
			Cards:     model.Cards(),
			CardAttrs: cardAttrs,

			DefenceRoleID:    model.DefenceRoleDbId(),
			DefenceRoleKey:   model.DefenceRoleKey(),
			DefenceRecordID:  model.DefenceRecordId(),
			DefenceName:      model.DefenceName(),
			DefenceLogo:      model.DefenceLogo(),
			DefenceFrame:     model.DefenceFrame(),
			DefenceLevel:     model.DefenceLevel(),
			DefenceVip:       model.DefenceVip(),
			DefenceCards:     model.DefenceCards(),
			DefenceCardAttrs: defenceCardAttrs,
		}
	} else if flag == 2 {
		result := "win"
		if model.Result() == "win" {
			result = "fail"
		}
		h = scheme.GymBattleHistory{
			Result:       result,
			CrossKey:     crossKey,
			PlayRecordID: model.GetID(),

			RoleID:    model.DefenceRoleDbId(),
			RoleKey:   model.DefenceRoleKey(),
			RecordID:  model.DefenceRecordId(),
			Name:      model.DefenceName(),
			Logo:      model.DefenceLogo(),
			Frame:     model.DefenceFrame(),
			Level:     model.DefenceLevel(),
			Vip:       model.DefenceVip(),
			Cards:     model.DefenceCards(),
			CardAttrs: defenceCardAttrs,

			DefenceRoleID:    model.RoleDbId(),
			DefenceRoleKey:   model.RoleKey(),
			DefenceRecordID:  model.RecordDbId(),
			DefenceName:      model.Name(),
			DefenceLogo:      model.Logo(),
			DefenceFrame:     model.Frame(),
			DefenceLevel:     model.Level(),
			DefenceVip:       model.Vip(),
			DefenceCards:     model.Cards(),
			DefenceCardAttrs: cardAttrs,
		}
	}
	return &h
}

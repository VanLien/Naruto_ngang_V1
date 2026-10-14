package union

import (
	"math/rand"
	"sync"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/util"

	"tjgame/server_framework/tj/log"
)

type Trainingsee struct {
	id       document.ID
	roledbid document.ID

	Slots          map[document.Integer]*scheme.UnionTrainingSlot `codec:"slots"`
	Opened         map[document.Integer]bool                      `codec:"opened"`
	OfflineExp     map[document.ID]int                            `codec:"offline_exp"`
	OfflineSpeedup map[document.Integer][]string                  `codec:"offline_speedup"`
}

func TrainingExpPerMinute(rolelevel, unionlevel int) int {
	cfg := csv.GetConfig()
	fix := cfg.Base_attribute.Role_level[rolelevel].UnionTrainingFix
	return int(cfg.Union.Union_level[unionlevel].TrainingExp * float64(fix))
}

type Training struct {
	*scheme.UnionTrainingObject

	card2idx map[document.ID]int
}

func (t *Training) init() {
	t.card2idx = make(map[document.ID]int)
	for idx, slot := range t.Slots() {
		t.card2idx[slot.ID] = int(idx)
	}
	alltrainings.Store(t.RoleDbId(), t)
}

func (t *Training) AutoOpen(level int, vip int) {
	cfg := csv.GetConfig()
	db, unlock := t.LockAndGetDB()
	defer unlock()

	for idx, cfg := range cfg.Union.Training {
		if db.Opened[document.Integer(idx)] {
			continue
		}
		if cfg.CostRMB == 0 && level >= cfg.OpenLevel && vip >= cfg.OpenVIP {
			db.Opened[document.Integer(idx)] = true
		}
	}
	t.SetOpened(db.Opened)
}

func (t *Training) Open(idx int) {
	db, unlock := t.LockAndGetDB()
	defer unlock()

	if db.Opened[document.Integer(idx)] {
		return
	}

	db.Opened[document.Integer(idx)] = true
	t.SetOpened(db.Opened)
}

func (t *Training) RefreshToOffline(expPerMin int) {
	db, unlock := t.LockAndGetDB()
	defer unlock()

	now := util.NowTime()
	for _, slot := range db.Slots {
		cardexp := 0
		minutes := int((now - slot.LastTime) / 60)
		// 时间累计经验
		if minutes > 0 {
			cardexp += expPerMin * minutes
			slot.LastTime = now
		}
		db.OfflineExp[slot.ID] += cardexp
	}
	t.SetSlots(db.Slots)
	t.SetOfflineExp(db.OfflineExp)
}

func (t *Training) SyncExp() map[document.ID]int {
	cardexps := make(map[document.ID]int)
	db, unlock := t.LockAndGetDB()
	defer unlock()

	for id, exp := range db.OfflineExp {
		cardexps[id] = exp
	}
	t.SetOfflineExp(map[document.ID]int{})
	return cardexps
}

func (t *Training) BeSpeedUp(idx int, name string, exp int) error {
	db, unlock := t.LockAndGetDB()
	defer unlock()

	if !db.Opened[document.Integer(idx)] {
		return ErrUnionTrainingSlotNotOpen
	}
	slot := db.Slots[document.Integer(idx)]
	if slot == nil {
		return ErrUnionTrainingCardNotExisted
	}

	date := document.Integer(util.Todayinclock5date2int())
	history := db.OfflineSpeedup[date]
	if len(history) > TrainingSpeedUpMax {
		return ErrUnionTrainingBeSpeedUpMax
	}
	db.OfflineExp[slot.ID] += exp
	t.SetOfflineExp(db.OfflineExp)
	if history == nil {
		history = []string{name}
	} else {
		history = append(history, name)
	}
	t.SetOfflineSpeedup(map[document.Integer][]string{date: history})
	return nil
}

func (t *Training) StartTraining(idx int, card scheme.UnionTrainingCard) error {
	db, unlock := t.LockAndGetDB()
	defer unlock()

	if !db.Opened[document.Integer(idx)] {
		return ErrUnionTrainingSlotNotOpen
	}
	if t.card2idx[card.ID] != 0 {
		return ErrUnionTrainingCardYetInTraing
	}
	if db.Slots[document.Integer(idx)] != nil {
		return ErrUnionTrainingSlotBeTrain
	}

	db.Slots[document.Integer(idx)] = &scheme.UnionTrainingSlot{
		UnionTrainingCard: card,
		LastTime:          util.NowTime(),
	}
	t.card2idx[card.ID] = idx
	t.SetSlots(db.Slots)
	return nil
}

func (t *Training) ReplaceTraining(idx int, card scheme.UnionTrainingCard) error {
	db, unlock := t.LockAndGetDB()
	defer unlock()

	if !db.Opened[document.Integer(idx)] {
		return ErrUnionTrainingSlotNotOpen
	}
	if t.card2idx[card.ID] != 0 {
		return ErrUnionTrainingCardYetInTraing
	}

	if db.Slots[document.Integer(idx)] != nil {
		delete(t.card2idx, db.Slots[document.Integer(idx)].ID)
	}

	db.Slots[document.Integer(idx)] = &scheme.UnionTrainingSlot{
		UnionTrainingCard: card,
		LastTime:          util.NowTime(),
	}
	t.card2idx[card.ID] = idx
	return nil
}

func (t *Training) GetCards() []document.ID {
	ids := make([]document.ID, 0, len(t.Slots()))
	for _, s := range t.Slots() {
		ids = append(ids, s.ID)
	}
	return ids
}

func (t *Training) UpdateCardModel(card scheme.UnionTrainingCard) {
	idx := t.card2idx[card.ID]
	if idx == 0 {
		log.Warningf("card %v not in slot", card.ID)
		return
	}
	db, unlock := t.LockAndGetDB()
	defer unlock()

	db.Slots[document.Integer(idx)].UnionTrainingCard = card
	t.SetSlots(db.Slots)
}

func (t *Training) clean() {
	// 栏位开启和离线经验获得（别人的加速）保留，其它数据清理
	t.SetSlots(map[document.Integer]*scheme.UnionTrainingSlot{})

	t.card2idx = map[document.ID]int{}
}

func (t *Training) onJoinUnion() {
	t.clean()
}

func (t *Training) onQuitUnion() {
	t.clean()
}

func (t *Training) seemodel() Trainingsee {
	return Trainingsee{
		t.GetID(),
		t.RoleDbId(),
		t.Slots(),
		t.Opened(),
		t.OfflineExp(),
		t.OfflineSpeedup(),
	}
}

type TrainingCamp struct {
	trainings map[document.ID]*Training
}

func (camp *TrainingCamp) add(roleID document.ID, training *Training) {
	camp.trainings[roleID] = training
}

func (camp *TrainingCamp) discard(roleID document.ID) *Training {
	training := camp.trainings[roleID]
	delete(camp.trainings, roleID)
	return training
}

func (camp *TrainingCamp) RandomSpeedup(roleID, chooseRoleID document.ID) (document.ID, int) {
	if chooseRoleID != "" && camp.trainings[chooseRoleID] == nil {
		return "", 0
	}

	// 最多尝试5次
	keys := make([]document.ID, 0, len(camp.trainings))
	for key, training := range camp.trainings {
		if key != roleID && len(training.Slots()) > 0 {
			keys = append(keys, key)
		}
	}
	for i := 0; i < 5; i++ {
		choose := chooseRoleID
		if choose == "" {
			choose = keys[rand.Int31n(int32(len(keys)))]
		}
		training := camp.trainings[choose]
		count := len(training.Slots())
		if count == 0 {
			continue
		}
		idxs := make([]int, 0, count)
		for idx := range training.Slots() {
			idxs = append(idxs, int(idx))
		}
		idx := idxs[rand.Int31n(int32(len(idxs)))]
		return choose, idx
	}
	return "", 0
}

func (camp *TrainingCamp) GetTraining(roleID document.ID) *Training {
	return camp.trainings[roleID]
}

type traininginfo struct {
	_struct    struct{} `codec:",toarray"`
	RoleID     document.ID
	InTraining int
}

func (camp *TrainingCamp) List() []traininginfo {
	infos := make([]traininginfo, 0, len(camp.trainings))
	for roleID, training := range camp.trainings {
		infos = append(infos, traininginfo{RoleID: roleID, InTraining: len(training.Slots())})
	}
	return infos
}

func NewTrainingCamp() *TrainingCamp {
	camp := &TrainingCamp{
		trainings: make(map[document.ID]*Training),
	}
	return camp
}

// 全局训练中心
var alltrainings sync.Map // {role.id: training}

func GetTraining(roleID document.ID) *Training {
	t, ok := alltrainings.Load(roleID)
	if !ok {
		return nil
	}
	training := t.(*Training)
	return training
}

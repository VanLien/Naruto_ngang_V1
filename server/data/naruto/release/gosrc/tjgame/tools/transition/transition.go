package transition

import (
	"fmt"
	"reflect"
	"strings"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/storage"

	"tjgame/mgo.v2/bson"

	mgo "tjgame/mgo.v2"
)

var selector bson.M   // Role selector
var discards []string // Role discard field name

func init() {
	selector = bson.M{
		"_id": 1,
	}
	discards = []string{
		"uid",
		"mailbox",
		"read_mailbox",
		"global_mail_idx",
		"reunion", // 重聚活动
	}
	rt := reflect.TypeOf(scheme.Role{})
	num := rt.NumField()
	for i := 0; i < num; i++ {
		field := rt.Field(i)
		if field.Anonymous {
			continue
		}
		v := field.Tag.Get("bson")
		if v == "mailbox" || v == "read_mailbox" || v == "global_mail_idx" || v == "reunion" { // 邮件丢弃
			continue
		}
		// 只保留竞技场和石英的Record
		if !strings.HasSuffix(v, "_db_id") || v == "pvp_record_db_id" || v == "craft_record_db_id" || v == "fishing_db_id" {
			selector[v] = 1
		} else {
			discards = append(discards, v)
		}
	}
	log.Infof("discard %v", discards)
}

type Payload struct {
	Role      *scheme.Role                         `codec:"role"`
	Cards     map[document.ID]*scheme.RoleCard     `codec:"cards"`
	HeldItems map[document.ID]*scheme.RoleHeldItem `codec:"held_items"`
	Gems      map[document.ID]*scheme.RoleGem      `codec:"gems"`
	Chips     map[document.ID]*scheme.RoleChip     `codec:"chips"`

	// 竞技场
	ArenaRecord *scheme.ArenaRecord `codec:"arena_record"`
	// 石英
	CraftRecord *scheme.CraftRecord `codec:"craft_record"`
	// 钓鱼
	FishingRecord *scheme.Fishing `codec:"fishing_record"`

	// 账号
	Account *scheme.Account `codec:"account"`
}

type Delivery struct {
	session *mgo.Session
	dbName  string
	db      *mgo.Database
	id      document.ID
	uid     int

	payload *Payload
	err     error
}

func (d *Delivery) acquire(trial bool) error {
	d.payload = &Payload{}

	// Role
	role := &scheme.Role{}
	if d.id != "" {
		d.err = d.db.C("Role").FindId(d.id).Select(selector).One(role)
	} else {
		d.err = d.db.C("Role").Find(bson.M{"uid": d.uid}).Select(selector).One(role)
	}
	if d.err == nil {
		d.payload.Role = role
	}

	d.fetchCards()
	d.fetchHeldItems()
	d.fetchGems()
	d.fetchChips()

	// ArenaRecord
	if d.err == nil {
		record := &scheme.ArenaRecord{}
		err := d.db.C("ArenaRecord").FindId(d.payload.Role.PvpRecordDbId).One(record)
		if err == nil {
			d.payload.ArenaRecord = record
		}
		if trial {
			d.err = err
		}
	}

	// CraftRecord
	if d.err == nil {
		record := &scheme.CraftRecord{}
		err := d.db.C("CraftRecord").FindId(d.payload.Role.CraftRecordDbId).One(record)
		if err == nil {
			d.payload.CraftRecord = record
		}
		if trial {
			d.err = err
		}
	}

	// FishingRecord
	if d.err == nil {
		record := &scheme.Fishing{}
		fishing := bson.M{
			"_id":        1,
			"level":      1,
			"role_db_id": 1,
		}
		err := d.db.C("Fishing").FindId(d.payload.Role.FishingDbId).Select(fishing).One(record)
		if err == nil {
			d.payload.FishingRecord = record
		}
		if trial {
			d.err = err
		}
	}

	return d.err
}

func (d *Delivery) acquireAccount(session *mgo.Session) error {
	if d.err != nil {
		return d.err
	}
	account := &scheme.Account{}
	d.err = session.DB("account").C("Account").FindId(d.payload.Role.AccountId).One(account)
	if d.err == nil {
		d.payload.Account = account
	}
	return d.err
}

func (d *Delivery) fetchCards() {
	if d.err != nil {
		return
	}

	ids := d.payload.Role.Cards
	models := make([]*scheme.RoleCard, 0, len(ids))
	d.err = d.db.C("RoleCard").Find(bson.M{"_id": bson.M{"$in": ids}}).All(&models)
	if d.err == nil {
		cards := make(map[document.ID]*scheme.RoleCard)
		for _, card := range models {
			cards[card.ID] = card
		}
		d.payload.Cards = cards
	}
}

func (d *Delivery) fetchHeldItems() {
	if d.err != nil {
		return
	}

	ids := d.payload.Role.HeldItems
	models := make([]*scheme.RoleHeldItem, 0, len(ids))
	d.err = d.db.C("RoleHeldItem").Find(bson.M{"_id": bson.M{"$in": ids}}).All(&models)
	if d.err == nil {
		helditems := make(map[document.ID]*scheme.RoleHeldItem)
		for _, helditem := range models {
			helditems[helditem.ID] = helditem
		}
		d.payload.HeldItems = helditems
	}
}

func (d *Delivery) fetchGems() {
	if d.err != nil {
		return
	}

	ids := d.payload.Role.Gems
	models := make([]*scheme.RoleGem, 0, len(ids))
	d.err = d.db.C("RoleGem").Find(bson.M{"_id": bson.M{"$in": ids}}).All(&models)
	if d.err == nil {
		gems := make(map[document.ID]*scheme.RoleGem)
		for _, gem := range models {
			gems[gem.ID] = gem
		}
		d.payload.Gems = gems
	}
}

func (d *Delivery) fetchChips() {
	if d.err != nil {
		return
	}
	ids := d.payload.Role.Chips
	models := make([]*scheme.RoleChip, 0, len(ids))
	d.err = d.db.C("RoleChip").Find(bson.M{"_id": bson.M{"$in": ids}}).All(&models)
	if d.err == nil {
		chips := make(map[document.ID]*scheme.RoleChip)
		for _, chip := range models {
			chips[chip.ID] = chip
		}
		d.payload.Chips = chips
	}
}

func (r *Payload) commit(s service.IService) (err error) {
	resp, err := service.Call(s, "RoleGet", map[string]interface{}{"role_id": r.Role.ID})
	if err != nil {
		return err
	}
	response := resp.(storage.Response)
	if response.Model == nil {
		// 不存在对应的角色
		// 保证 role.id 不变化，所以采用 Transition
		_, err = service.Call(s, "Transition", "Role", r.Role.ID, r.Role)
		if err != nil {
			log.Warningf("Transition Role %s error %v", r.Role.Name, err)
		}
	} else {
		m := make(bson.M)
		if data, err := util.MsgPack(r.Role); err == nil {
			err = util.MsgUnpack(data, &m)
			if err == nil {
				for _, key := range discards {
					delete(m, key)
				}
			}
		}
		if len(m) == 0 {
			panic("role error")
		}
		_, err = service.Call(s, "DBUpdate", "Role", r.Role.ID, m, true)
		if err != nil {
			log.Warningf("DBUpdate Role %s error %v", r.Role.Name, err)
		}
	}

	// RoleCard
	futures := make([]*service.Future, 0, len(r.Cards))
	for _, card := range r.Cards {
		future := service.CallAsync(s, "Transition", "RoleCard", card.ID, card)
		futures = append(futures, future)
	}
	_, err = service.MultiFuture(futures, false).Get()
	if err != nil {
		log.Warningf("Transition RoleCard %s error %v", r.Role.Name, err)
	}

	// RoleHeldItem
	futures = make([]*service.Future, 0, len(r.HeldItems))
	for _, helditem := range r.HeldItems {
		future := service.CallAsync(s, "Transition", "RoleHeldItem", helditem.ID, helditem)
		futures = append(futures, future)
	}
	_, err = service.MultiFuture(futures, false).Get()
	if err != nil {
		log.Warningf("Transition RoleHeldItem %s error %v", r.Role.Name, err)
	}

	// RoleGem
	futures = make([]*service.Future, 0, len(r.Gems))
	for _, gem := range r.Gems {
		future := service.CallAsync(s, "Transition", "RoleGem", gem.ID, gem)
		futures = append(futures, future)
	}
	_, err = service.MultiFuture(futures, false).Get()
	if err != nil {
		log.Warningf("Transition RoleGem %s error %v", r.Role.Name, err)
	}

	// RoleChip
	futures = make([]*service.Future, 0, len(r.Chips))
	for _, chip := range r.Chips {
		future := service.CallAsync(s, "Transition", "RoleChip", chip.ID, chip)
		futures = append(futures, future)
	}
	_, err = service.MultiFuture(futures, false).Get()
	if err != nil {
		log.Warningf("Transition RoleChip %s error %v", r.Role.Name, err)
	}

	// ArenaRecord
	_, err = service.Call(s, "Transition", "ArenaRecord", r.Role.PvpRecordDbId, r.ArenaRecord)
	if err != nil {
		log.Warningf("Transition ArenaRecord %s error %v", r.Role.Name, err)
	}

	// CraftRecord
	_, err = service.Call(s, "Transition", "CraftRecord", r.Role.CraftRecordDbId, r.CraftRecord)
	if err != nil {
		log.Warningf("Transition CraftRecord %s error %v", r.Role.Name, err)
	}

	// FishingRecord
	_, err = service.Call(s, "Transition", "Fishing", r.Role.FishingDbId, r.FishingRecord)
	if err != nil {
		log.Warningf("Transition FishingRecord %s error %v", r.Role.Name, err)
	}
	return
}

func Transition(session *mgo.Session, db string, id document.ID, s service.IService) error {
	delivery := &Delivery{
		session: session,
		dbName:  db,
		id:      id,
	}
	delivery.db = session.DB(db)
	err := delivery.acquire(true)
	if err == nil {
		role := delivery.payload
		_, _, area := service.SplitServiceName(s.Name())
		role.Role.Name = fmt.Sprintf("%s.%d", role.Role.Name, role.Role.Area)
		role.Role.Area = area
		err = role.commit(s)
	}
	return err
}

func RebuildSociety(s service.IService, id document.ID, friends []document.ID) error {
	friends = idSliceExclude(friends, id)
	resp, err := service.Call(s, "DBReadBy", "Society", map[string]interface{}{"role_db_id": id})
	response := resp.(storage.Response)
	if err != nil || len(response.Models) == 0 {
		log.Infof("role %s need create society", id)
		society := document.New("Society", true).(*scheme.Society)
		society.RoleDbId = id
		society.Friends = friends
		resp, err := service.Call(s, "DBCreate", "Society", society)
		if err != nil {
			return err
		}
		response := resp.(storage.Response)
		society = response.Model.(*scheme.Society)
		_, err = service.Call(s, "DBUpdate", "Role", id, map[string]interface{}{"society_db_id": society.ID}, true)
		return err
	}
	log.Infof("role %s update society", id)
	society := response.Models[0].(*scheme.Society)
	set := make(map[document.ID]bool)
	for _, i := range friends {
		set[i] = true
	}
	for _, i := range society.Friends {
		if set[i] {
			continue
		}
		set[i] = true
		friends = append(friends, i)
	}
	_, err = service.Call(s, "DBUpdate", "Society", society.ID, map[string]interface{}{"friends": friends}, true)
	return err
}

func CopyAccount(session *mgo.Session, id document.ID, s service.IService) (string, error) {
	var err error
	account := &scheme.Account{}
	err = session.DB("account").C("Account").FindId(id).One(account)
	if err == nil {
		account.RoleInfos = map[string]scheme.RoleInfo{"game.cn.1": {}}
		_, err = service.Call(s, "Transition", "Account", id, account)
	}
	return account.Name, err
}

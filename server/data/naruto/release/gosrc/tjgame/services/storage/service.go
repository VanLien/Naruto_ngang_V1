package storage

import (
	"context"
	"encoding/hex"
	"errors"
	"fmt"
	"math/rand"
	"strings"
	"sync"
	"time"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/ugorji_go/codec"

	mgo "tjgame/mgo.v2"
	"tjgame/mgo.v2/bson"

	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	tjutil "tjgame/server_framework/tj/util"
)

const (
	Name      = "storage"
	namemerge = "storagemerge"
)

func GetNameFromDependent(dependent []string) string {
	for _, name := range dependent {
		ns, _, _ := service.SplitServiceName(name)
		if ns == Name || ns == namemerge {
			return name
		}
	}
	panic("no storage service")
}

var (
	Alias    = []string{"accountdb", "giftdb", "paymentdb", "crossdb", "commentdb"}
	specials = map[string][]string{
		"accountdb": {"Account", "GMAccount", "RmbReturn"},
		"giftdb":    {"Gift"},
		"paymentdb": {"PayOrder"},
		"crossdb": {
			"CrossCraftPlayRecord", "CrossCraftGlobal", // 跨服石英
			"CrossArenaPlayRecord", "CrossArenaGlobal", // 跨服竞技场
			"CrossOnlineFightPlayRecord", "CrossOnlineFightGlobal", // 实时对战
			"CrossMinePlayRecord", "CrossMineGlobal", // 跨服资源战
			"CrossMatch",           // 匹配服
			"CrossFishingGlobal",   // 跨服钓鱼大赛
			"CrossGymGlobal",       // 跨服道馆
			"CrossRedPacketGlobal", // 跨服红包
			"SkyscraperGlobal",
			"CrossRankingGlobal",
			"HorseRaceGlobal",                                    // 赛马
			"HuntingGlobal",                                      // 远征
			"CrossUnionFightPlayRecord", "CrossUnionFightGlobal", // 跨服部屋
		},
		"commentdb": {"CardComment", "CardCommentRole", "CardScoreGlobal", "CardScoreRole"},
	}

	ErrNoAccount           = errors.New("no account")
	ErrExistedName         = errors.New("existed name")
	ErrNoDocumentIDOrQuery = errors.New("can not load document without id or query")
	ErrAccountDisabled     = errors.New("account disabled")
)

const (
	CommitTimerDuration = 2 * time.Minute
	DocumentLRUCapacity = 1000
)

type Option struct {
	service.Option `json:",inline"`

	MongoDB string `json:"mongodb,omitempty"`
	DBName  string `json:"dbname,omitempty"`

	MGOPoolLimit int  `json:"pool_limit,omitempty"`
	MGOStats     bool `json:"mgo_stats,omitempty"`
}

type Service struct {
	*service.Service

	storage *Storage
	session *Session

	ctx    context.Context
	cancel context.CancelFunc

	rmbReturnQuery sync.Map // {name: key}
}

func (s *Service) Init() bool {
	if ok := s.Service.Init(); !ok {
		return false
	}

	opt := s.Option.(*Option)
	limit := opt.MGOPoolLimit
	if limit == 0 {
		limit = 10
	}
	log.Debugf("MGO PoolLimit %d", limit)

	s.storage = NewStorage(opt.MongoDB, opt.DBName)
	s.storage.session.SetPoolLimit(limit) // test maximum number of sockets in use
	s.storage.session.SetSafe(&mgo.Safe{WMode: "majority"})
	s.session = NewSession(s.storage)

	if opt.MGOStats {
		mgo.SetStats(true)
	}
	//s.SetMGOLoggerAndDebug(true, false)

	alias := s.ServiceName() != Name && s.ServiceName() != namemerge
	if alias {
		for _, name := range specials[s.ServiceName()] {
			s.storage.EnsureIndex(name)
		}
	} else {
		invalid := make(map[string]bool)
		for _, v := range specials {
			for _, vv := range v {
				invalid[vv] = true
			}
		}
		names := document.GetAllRegistered()
		for _, name := range names {
			if !invalid[name] {
				s.storage.EnsureIndex(name)
			}
		}
	}

	if !alias {
		RankensureIndex(s.storage)

		// ensure RoleCard index
		s.storage.exec("RoleCard", func(collection *mgo.Collection) error {
			return collection.EnsureIndexKey("card_id", "-fighting_point")
		})

		// ensure expired index
		ensureExpiredIndex(s.storage)
	} else {
		names := []string{s.ServiceName()}
		names = append(names, s.Option.Base().Alias...)
		for _, name := range names {
			n, _, _ := service.SplitServiceName(name)
			if n == "commentdb" {
				// ensure CardComment index
				err := s.storage.exec("CardComment", func(collection *mgo.Collection) error {
					return collection.EnsureIndexKey("mark_id", "-like")
				})
				log.Warningf("EnsureIndexKey CardComment error %v", err)
				err = s.storage.exec("CardComment", func(collection *mgo.Collection) error {
					return collection.EnsureIndexKey("mark_id", "-time")
				})
				log.Warningf("EnsureIndexKey CardComment error %v", err)
			} else if n == "giftdb" {
				err := s.storage.exec("Gift", func(collection *mgo.Collection) error {
					return collection.EnsureIndex(mgo.Index{
						Key:    []string{"order_id"},
						Unique: true,
						Sparse: true,
					})
				})
				if err != nil {
					log.Warningf("EnsureIndexKey Gift.order_id error %v", err)
				}
				log.Debugf("EnsureIndexKey Gift.order_id error %v", err)
			}
		}
	}

	log.Debugf("Mongodb Ensure Index OK")

	s.ctx, s.cancel = context.WithCancel(context.Background())

	return true
}

func (s *Service) Start() bool {
	go func() {
		timer := time.NewTimer(CommitTimerDuration)
		defer timer.Stop()
		for {
			select {
			case <-s.ctx.Done():
				return
			case <-timer.C:
				s.session.Commit()
				timer.Reset(CommitTimerDuration)
			}
		}
	}()

	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.cancel()
	s.session.Commit()
}

func (s *Service) Destroy() {
	s.storage.Close()
}

func (s *Service) GetMGOStats() (string, error) {
	snapshot := mgo.GetStats()
	log.Infof("mgo stats: %#v", snapshot)
	return fmt.Sprintf("%#v", snapshot), nil
}

func (s *Service) DBCreate(name string, internal document.IDocument) (response *Response, err error) {
	if name == "Union" { // 公会特殊uid逻辑
		union := internal.(*scheme.Union)
		if union.UID, err = s.storage.IncID("Union"); err != nil {
			response.Write(err)
			return
		}
	}
	doc := NewDocument(internal)
	err = doc.Save(s.storage, true)
	if err == nil {
		s.session.Set(doc)
	}
	response = NewResponse(s.Name())
	response.Write(err, doc)
	return
}

func (s *Service) DBUpdate(name string, id ID, updater document.IUpdater, forget bool) (response *Response, err error) {
	response = NewResponse(s.Name())
	defer response.Write(err)
	doc, err := s.session.Get(name, id)
	if err != nil {
		return
	}
	doc.Update(updater)
	s.session.Set(doc)
	if forget {
		//log.Debug(doc.IDocument, doc.dirty)
		err = doc.Save(s.storage, false)
	}
	return
}

func (s *Service) DBUpsert(name string, id ID, internal document.IDocument) (response *Response, err error) {
	s.session.Forget(name, id)
	err = s.storage.exec(name, func(collection *mgo.Collection) error {
		_, err := collection.UpsertId(id, internal)
		return err
	})
	if err != nil {
		return
	}
	return s.DBRead(name, id, false)
}

func (s *Service) DBRead(name string, id ID, forget bool) (response *Response, err error) {
	doc, err := s.session.Get(name, id)
	response = NewResponse(s.Name())
	response.Write(err, doc)
	if err == mgo.ErrNotFound {
		err = nil
	}
	return
}

func (s *Service) DBDelete(name string, id ID, delay bool) (response *Response, err error) {
	if name == "RoleCard" && delay {
		s.session.Forget(name, id)
		card := NewRoleCardExpired()
		if err := card.migrate(s.storage, id); err != nil {
			log.Warningf("card %v expired migrate error %v", id, err)
		}
	}
	err = s.session.Remove(name, id)
	response = NewResponse(s.Name())
	response.Write(err)
	return
}

func (s *Service) DBMultipleRead(name string, ids []ID) (response *Response, err error) {
	documents, err := s.session.MultipGet(name, ids)
	response = NewResponse(s.Name())
	response.SetMultiple(true)
	response.Write(err, documents...)
	return
}

func (s *Service) DBMultipleDelete(name string, ids []ID) (response *Response, err error) {
	for _, id := range ids {
		err = s.session.Remove(name, id)
		if err != nil {
			log.Warningf("DBMultipleDelete %s:%v error %v", name, id, err)
		}
	}
	err = nil
	response = NewResponse(s.Name())
	response.Write(nil)
	return
}

func pretty(kvs bson.M) bson.M {
	ret := make(bson.M, len(kvs))
	for k, v := range kvs {
		switch vv := v.(type) {
		case []byte:
			if strings.HasSuffix(k, "_db_id") || strings.HasSuffix(k, "account_id") {
				ret[k] = ID(string(vv))
				log.Debugf("pretty convert, %v -> %v", vv, ret[k])
			} else {
				ret[k] = string(vv)
			}
		case string:
			if strings.HasSuffix(k, "_db_id") || strings.HasSuffix(k, "account_id") {
				ret[k] = ID(vv)
			} else {
				ret[k] = vv
			}
		default:
			ret[k] = v
		}
	}
	return ret
}

func (s *Service) DBReadsert(name string, kvs bson.M, forget bool) (response *Response, err error) {
	kvs = pretty(kvs)
	response = NewResponse(s.Name())
	doc, err := s.session.Query(name, kvs)
	if err == nil {
		response.Write(err, doc)
		return
	}
	if err != mgo.ErrNotFound {
		response.Write(err)
		return
	}

	raw, err := tjutil.MsgPack(kvs)
	if err != nil {
		response.Write(err)
		return
	}
	internal := document.New(name, true)
	err = tjutil.MsgUnpack(raw, internal)
	if err != nil {
		response.Write(err)
		return
	}
	return s.DBCreate(name, internal)
}

func (s *Service) DBMultipleReadKeys(name string, ids []ID, keys []string) (response *Response, err error) {
	documents, err := s.session.MultipGet(name, ids)
	documents = documentCustomizeKeys(documents, keys)
	response = NewResponse(s.Name())
	response.SetMultiple(true)
	response.Write(err, documents...)
	return
}

func (s *Service) DBReadBy(name string, kvs bson.M) (response *Response, err error) {
	kvs = pretty(kvs)
	documents, err := s.storage.Query(name, kvs, nil, 0)
	response = NewResponse(s.Name())
	response.SetMultiple(true)
	response.Write(nil, documents...)
	return
}

func (s *Service) DBReadIn(name string, keys string, ids []ID) (response *Response, err error) {
	documents, err := s.storage.Query(name, bson.M{keys: bson.M{"$in": ids}}, nil, 0)
	response = NewResponse(s.Name())
	response.SetMultiple(true)
	response.Write(nil, documents...)
	return
}

func (s *Service) DBReadAll(name string) (response *Response, err error) {
	documents, err := s.storage.Query(name, nil, nil, 0)
	response = NewResponse(s.Name())
	response.SetMultiple(true)
	response.Write(nil, documents...)
	return
}

type Regex struct {
	Pattern string `codec:"pattern"`
	Options string `codec:"options"`
}

func (s *Service) DBReadByPattern(name string, regexs map[string]Regex, size int) (response *Response, err error) {
	query := bson.M{}
	for k, v := range regexs {
		query[k] = bson.M{"$regex": bson.RegEx{
			Pattern: v.Pattern,
			Options: v.Options,
		}}
	}
	documents, err := s.storage.Query(name, query, nil, size)
	response = NewResponse(s.Name())
	response.SetMultiple(true)
	response.Write(nil, documents...)
	return
}

func prettyQuery(kvs bson.M) bson.M {
	query := bson.M{}
	for k, v := range kvs {
		switch vv := v.(type) {
		case []interface{}:
			query[k] = bson.M{"$gte": vv[0], "$lte": vv[1]}
		default:
			query[k] = v
		}
	}
	return query
}

func (s *Service) DBReadRangeBy(name string, kvs bson.M, size int) (response *Response, err error) {
	// kvs : {key: [start, end], }
	query := prettyQuery(kvs)
	documents, err := s.storage.Query(name, query, nil, size)
	response = NewResponse(s.Name())
	response.SetMultiple(true)
	response.Write(nil, documents...)
	return
}

func prettyRecord(kvs bson.M) bson.M {
	ret := make(bson.M, len(kvs))
	for k, v := range kvs {
		switch vv := v.(type) {
		case []byte:
			if strings.HasSuffix(k, "_db_id") || strings.HasSuffix(k, "account_id") || strings.HasSuffix(k, "role_key.id") {
				ret[k] = ID(string(vv))
				log.Debugf("prettyRecord convert, %v -> %v", vv, ret[k])
			} else {
				ret[k] = string(vv)
			}
		case string:
			if strings.HasSuffix(k, "_db_id") || strings.HasSuffix(k, "account_id") || strings.HasSuffix(k, "role_key.id") {
				ret[k] = ID(vv)
			} else {
				ret[k] = vv
			}
		case []interface{}:
			ret[k] = bson.M{"$gte": vv[0], "$lte": vv[1]}
		default:
			ret[k] = v
		}
	}
	return ret
}
func (s *Service) DBReadRecordBy(name string, kvs bson.M) (response *Response, err error) {
	kvs = prettyRecord(kvs)
	documents, err := s.storage.Query(name, kvs, nil, 0)
	response = NewResponse(s.Name())
	response.SetMultiple(true)
	response.Write(nil, documents...)
	return
}

func (s *Service) DBReadKeysRangeBy(name string, kvs bson.M, keys []string, size int) (response *Response, err error) {
	// kvs : {key: [start, end], }
	query := prettyQuery(kvs)
	selector := bson.M{}
	for _, key := range keys {
		selector[key] = 1
	}
	documents, err := s.storage.Query(name, query, selector, size)
	documents = documentCustomizeKeys(documents, keys)
	response = NewResponse(s.Name())
	response.SetMultiple(true)
	response.Write(nil, documents...)
	return
}

func (s *Service) DBCommit(full bool, all bool) (response *Response, err error) {
	s.session.Commit()
	response = NewResponse(s.Name())
	response.Write(nil)
	return
}

func (s *Service) DBCommitObject(name string, id ID) (response *Response, err error) {
	doc, err := s.session.Get(name, id)
	if doc != nil {
		err = doc.Save(s.storage, false)
		if err == nil {
			s.session.Forget(name, id)
		}
	}
	response = NewResponse(s.Name())
	response.Write(err)
	return
}

func (s *Service) DBFlush(full bool, all bool) (response *Response, err error) {
	s.session.FlushAll()
	response = NewResponse(s.Name())
	response.Write(nil)
	return
}



// Account Operation

func (s *Service) AccountAdd(document *scheme.Account) (response *Response, err error) {
	
	// add by chanlong
	
	if document.PayID, err = s.storage.IncID("Account"); err != nil {
		log.Errorf("err key increment Account.PayID")
		response.Write(err)
		return
	}
	if document.PayID < 100000 {
		document.PayID = document.PayID +100000
	}
	// end add


	return s.DBCreate("Account", document)
}

func (s *Service) AccountLogin(name string) (response *Response, err error) {
	response = NewResponse(s.Name())
	doc, err := s.session.Query("Account", bson.M{"name": name})
	if err == mgo.ErrNotFound {
		err = ErrNoAccount
	}
	if doc != nil {
		account := doc.IDocument.(*scheme.Account)
		if account.DisableFlag {
			err = ErrAccountDisabled
			doc = nil
		}
	}
	response.Write(err, doc)
	return
}

func (s *Service) AccountLogin2(name string, pass_md5 string) (response *Response, err error) {
	response = NewResponse(s.Name())
	doc, err := s.session.Query("Account", bson.M{"name": name, "pass_md5": pass_md5, "disable_flag":false})
	if err == mgo.ErrNotFound {
		err = ErrNoAccount
	}
	// if doc != nil {
	// 	account := doc.IDocument.(*scheme.Account)
	// 	if account.DisableFlag {
	// 		err = ErrAccountDisabled
	// 		doc = nil
	// 	}
	// }
	response.Write(err, doc)
	return
}

func (s *Service) AccountRoleCheckIn(id ID, servKey string, info scheme.RoleInfo) (response *Response, err error) {
	response = NewResponse(s.Name())
	defer response.Write(err)
	doc, err := s.session.Get("Account", id)
	if err == nil {
		account := doc.IDocument.(*scheme.Account)
		account.LastTime = tjutil.NowTime()
		roleInfos := make(map[string]scheme.RoleInfo)
		for k, v := range account.RoleInfos {
			roleInfos[k] = v
		}
		roleInfos[servKey] = info
		// use swap replace map write to avoid concurrently
		account.RoleInfos = roleInfos
		doc.modify("last_time", "role_infos")
		s.session.Set(doc)
	}
	return
}

func (s *Service) AccountAge(id ID, age int) (response *Response, err error) {
	response = NewResponse(s.Name())
	defer response.Write(err)
	doc, err := s.session.Get("Account", id)
	if err == nil {
		account := doc.IDocument.(*scheme.Account)
		account.Age = age
		doc.modify("age")
		s.session.Set(doc)
	}
	return
}

func (s *Service) AccountDisable(id ID, disable bool) (response *Response, err error) {
	response = NewResponse(s.Name())
	defer response.Write(err)
	doc, err := s.session.Get("Account", id)
	if err == nil {
		account := doc.IDocument.(*scheme.Account)
		account.DisableFlag = disable
		doc.modify("disable_flag")
		s.session.Set(doc)
	}
	return
}

func (s *Service) AccountQuery(id ID) (response *Response, err error) {
	return s.DBRead("Account", id, true)
}

func (s *Service) AccountQueryByName(name string) (response *Response, err error) {
	response = NewResponse(s.Name())
	doc, err := s.session.Query("Account", bson.M{"name": name})
	response.Write(err, doc)
	if err == mgo.ErrNotFound {
		err = nil
	}
	return
}
func (s *Service) AccountQueryByEmail(email string) (response *Response, err error) {
	response = NewResponse(s.Name())
	doc, err := s.session.Query("Account", bson.M{"email": email})
	response.Write(err, doc)
	if err == mgo.ErrNotFound {
		err = nil
	}
	return
}
func (s *Service) AccountMigrate(old string, new string) (response *Response, err error) {
	response = NewResponse(s.Name())
	defer response.Write(err)
	var olddoc *Document
	olddoc, err = s.session.Query("Account", bson.M{"name": old})
	if err != nil {
		return
	}
	oldacc := olddoc.IDocument.(*scheme.Account)
	oldchannel := oldacc.Channel

	var newdoc *Document
	newdoc, err = s.session.Query("Account", bson.M{"name": new})
	if err != nil {
		return
	}
	newacc := newdoc.IDocument.(*scheme.Account)
	newchannel := newacc.Channel

	newacc.Name = old + "@"
	newacc.Channel = oldchannel
	newdoc.modify("name", "channel")
	newdoc.Save(s.storage, false)

	oldacc.Name = new
	oldacc.Channel = newchannel
	olddoc.modify("name", "channel")
	olddoc.Save(s.storage, false)

	newacc.Name = old
	newdoc.modify("name")
	newdoc.Save(s.storage, false)

	log.Infof("account migrate %s -> %s success", old, new)

	return
}

// GMAccount Operation
func (s *Service) GMAdd(document document.IDocument) (response *Response, err error) {
	response = NewResponse(s.Name())
	account := document.(*scheme.GMAccount)
	var doc *Document
	if doc, err = s.session.Query("GMAccount", bson.M{"name": account.Name}); err == mgo.ErrNotFound {
		doc = NewDocument(document)
		err = s.storage.Save(doc)
		response.Write(err, doc)
		return
	}
	if doc != nil && err == nil {
		response.Write(ErrExistedName)
		return
	}
	response.Write(err)
	return
}

func (s *Service) GMLogin(name string, pass string) (response *Response, err error) {
	response = NewResponse(s.Name())
	doc, err := s.session.Query("GMAccount", bson.M{"name": name})
	if err != nil {
		if err == mgo.ErrNotFound {
			response.Write(ErrNoAccount)
			err = nil
			return
		}
		response.Write(err)
		return
	}
	account := doc.IDocument.(*scheme.GMAccount)
	if account.PassMd5 != pass {
		response.Write(errors.New("pass_error"))
		return
	}
	account.LastTime = tjutil.NowTime()
	doc.modify("last_time")
	response.Write(nil, doc)
	return
}

func (s *Service) GMOpHistory(name string, history scheme.GMOpHistory) (response *Response, err error) {
	response = NewResponse(s.Name())
	doc, err := s.session.Query("GMAccount", bson.M{"name": name})
	if err != nil {
		if err == mgo.ErrNotFound {
			response.Write(ErrNoAccount)
			err = nil
			return
		}
		response.Write(err)
		return
	}
	account := doc.IDocument.(*scheme.GMAccount)
	account.LastTime = tjutil.NowTime()
	account.OperatedHistory = append(account.OperatedHistory, history)
	if len(account.OperatedHistory) > 1000 {
		account.OperatedHistory = account.OperatedHistory[len(account.OperatedHistory)-1000:]
	}
	doc.modify("last_time", "operated_history")
	err = doc.Save(s.storage, false)
	return
}

// Role Operation

func randomName() string {
	name := make([]byte, 5)
	rand.Read(name)
	return fmt.Sprintf("%x", name)
}

func (s *Service) RoleAdd(role *scheme.Role) (response *Response, err error) {
	response = NewResponse(s.Name())
	if role.UID, err = s.storage.IncID("Role"); err != nil {
		response.Write(err)
		return
	}
	doc := NewDocument(role)
	for i := 0; i < 4; i++ {
		if role.Name == "" {
			name := randomName()
			name = fmt.Sprintf("%s#%d", name, role.UID)
			role.Name = name
		}
		err = doc.Save(s.storage, true)
		if err == nil {
			break
		}
		if strings.Index(err.Error(), "duplicate key error") == -1 {
			response.Write(err)
			return
		}
		role.Name = ""
		role.ID = ""
	}
	s.session.Set(doc)
	response.Write(nil, doc)
	return
}

type roleQuery struct {
	AccountID ID  `codec:"account_id,omitempty" bson:"account_id,omitempty"`
	Area      int `codec:"area,omitempty" bson:"area,omitempty"`
	RoleID    ID  `codec:"role_id,omitempty" bson:"role_id,omitempty"`
}

func (s *Service) RoleGet(query roleQuery) (response *Response, err error) {
	if query.RoleID != "" {
		return s.DBRead("Role", query.RoleID, false)
	}
	response = NewResponse(s.Name())
	if query.AccountID == "" {
		err = errors.New("miss account_id")
		response.Write(err)
		return
	}
	m := bson.M{
		"account_id": query.AccountID,
	}
	if query.Area > 0 {
		m["area"] = query.Area
	}
	doc, err := s.session.Query("Role", m)
	if err != nil {
		response.Write(err)
		if err == mgo.ErrNotFound {
			err = nil
		}
	} else {
		response.Write(nil, doc, nil)
	}
	return
}

func (s *Service) RoleGetRobots(ids []ID) (response *Response, err error) {
	documents, err := s.session.MultipGet("Role", ids)
	valid := make([]*Document, 0, len(documents))
	isRobotObjectId := func(id ID) bool {
		return strings.HasPrefix(string(id), "robot")
	}
	for _, d := range documents {
		role := d.IDocument.(*scheme.Role)
		if isRobotObjectId(role.AccountId) {
			valid = append(valid, d)
		}
	}
	response = NewResponse(s.Name())
	response.SetMultiple(true)
	response.Write(err, valid...)
	return
}

// CardComment Operation

func (s *Service) CardCommentQuery(markID, limit int, roleID document.ID, sortFields []string) (response *Response, err error) {
	query := bson.M{"mark_id": markID}
	if roleID != "" {
		query["role_db_id"] = roleID
	}
	queryDocuments, err := s.storage.RangeQuery("CardComment", query, nil, 1, limit, sortFields)
	documents := make([]*Document, 0, len(queryDocuments))
	sessionCache := s.session.route("CardComment")
	for _, doc := range queryDocuments {
		cache, ok1 := sessionCache.Get(doc.GetID())
		cacheDoc, ok2 := cache.(*Document)
		if ok1 && ok2 {
			documents = append(documents, cacheDoc)
		} else {
			documents = append(documents, doc)
		}
	}
	response = NewResponse(s.Name())
	response.SetMultiple(true)
	response.Write(nil, documents...)
	return
}

// CardFightGlobal Operation

type CardFightCard struct {
	ID            ID      `bson:"_id" codec:"id"`
	RoleID        ID      `bson:"role_db_id" codec:"role_db_id"`
	CardId        int     `bson:"card_id" codec:"card_id"`
	Advance       int     `bson:"advance" codec:"advance"`
	Star          int     `bson:"star" codec:"star"`
	Level         int     `bson:"level" codec:"level"`
	SkinId        int     `bson:"skin_id" codec:"skin_id"`
	FightingPoint int     `bson:"fighting_point" codec:"fighting_point"`
	CreatedTime   float64 `bson:"created_time" codec:"created_time"`
}

type CardFightRole struct {
	ID       ID     `bson:"_id" codec:"id"`
	Name     string `bson:"name" codec:"name"`
	Logo     int    `bson:"logo" codec:"logo"`
	Frame    int    `bson:"frame" codec:"frame"`
	Title    int    `bson:"title_id" codec:"title_id"`
	Level    int    `bson:"level" codec:"level"`
	Figure   int    `bson:"figure" codec:"figure"`
	VipLevel int    `bson:"vip_level" codec:"vip_level"`
	VipHide  bool   `bson:"vip_hide" codec:"vip_hide"`
}

var cardFightCardSelector = bson.M{"_id": 1, "role_db_id": 1, "card_id": 1, "advance": 1, "star": 1, "skin_id": 1, "level": 1, "fighting_point": 1, "created_time": 1}
var cardFightRoleSelector = bson.M{"_id": 1, "name": 1, "logo": 1, "frame": 1, "title_id": 1, "level": 1, "figure": 1, "vip_level": 1, "vip_hide": 1}

func (s *Service) CardFightTop200Cards(cardIDs []int) ([]CardFightCard, error) {
	cards := make([]CardFightCard, 0, 200)
	err := s.storage.exec("RoleCard", func(collection *mgo.Collection) error {
		return collection.Find(bson.M{"card_id": bson.M{"$in": cardIDs}, "exist_flag": true}).Select(cardFightCardSelector).Sort("-fighting_point").Limit(200).All(&cards)
	})
	return cards, err
}

func (s *Service) CardFightTop200Roles(roleIDs []document.ID) ([]CardFightRole, error) {
	roles := make([]CardFightRole, 0, 200)
	err := s.storage.exec("Role", func(collection *mgo.Collection) error {
		return collection.Find(bson.M{"_id": bson.M{"$in": roleIDs}}).Select(cardFightRoleSelector).All(&roles)
	})
	return roles, err
}

// Rank Operation

func (s *Service) DBRankRoleAdd(name string, id ID, element RoleElement, gameKey string) (int, error) {
	if err := element.Complete(id, name); err != nil {
		return 0, err
	}
	if err := RankAdd(s.storage, name, id, element); err != nil {
		return 0, nil
	}
	rank, _, err := RankQuery(s.storage, name, id, false, gameKey)
	return rank, err
}

func (s *Service) DBRankRoleAddBulk(name string, elements map[document.ID]RoleElement) (int, error) {
	succeed := 0
	for id, element := range elements {
		err := element.Complete(id, name)
		if err == nil {
			err = RankAdd(s.storage, name, id, element)
		}
		if err == nil {
			succeed += 1
		} else {
			log.Warningf("RankAdd %s error %v", name, err)
		}
	}
	return succeed, nil
}

func (s *Service) DBRankCardAdd(name string, id ID, element CardElement) (int, error) {
	if err := element.Complete(id, name); err != nil {
		return 0, err
	}
	err := RankAdd(s.storage, name, id, element)
	if err != nil {
		return 0, err
	}
	rank, _, err := RankQuery(s.storage, name, id, false, "")
	return rank, err
}

func (s *Service) DBRank(name string, id ID, tied bool, gameKey string) ([]interface{}, error) {
	rank, element, err := RankQuery(s.storage, name, id, tied, gameKey)
	return []interface{}{rank, element}, err
}

func (s *Service) DBRankRangeByScore(name string, max int, min int) (interface{}, error) {
	return RankRangeByScoreQuery(s.storage, name, max, min)
}

func (s *Service) DBGetRankSize(name string, start int, end int, gameKey string) (interface{}, error) {
	return RankRangeQuery(s.storage, name, start, end, gameKey)
}

func (s *Service) DBSummaryRange(name string, start int, end int, gameKey string) (interface{}, error) {
	return RankSummaryRangeQuery(s.storage, name, start, end, gameKey)
}

func (s *Service) DBDrop(name string) (bool, error) {
	err := RankDrop(s.storage, name)
	return err == nil, err
}

func (s *Service) DBRankClearRole(id ID, names []string) (bool, error) {
	err := RankClearRole(s.storage, id, names)
	return err == nil, err
}

// Slim Role Card Operation

type Slimrole struct {
	ID                  ID      `bson:"_id" codec:"id"`
	Name                string  `bson:"name" codec:"name"`
	PersonalSign        string  `bson:"personal_sign" codec:"personal_sign"`
	LastTime            float64 `bson:"last_time" codec:"last_time"`
	Logo                int     `bson:"logo" codec:"logo"`
	Frame               int     `bson:"frame" codec:"frame"`
	Figure              int     `bson:"figure" codec:"figure"`
	TitleId             int     `bson:"title_id" codec:"title_id"`
	Level               int     `bson:"level" codec:"level"`
	VipLevel            int     `bson:"vip_level" codec:"vip_level"`
	BattleFightingPoint int     `bson:"battle_fighting_point" codec:"battle_fighting_point"`

	Pokedex    map[document.Integer]float64 `bson:"pokedex" codec:"-"`
	CollectNum int                          `bson:"-" codec:"collect_num"`

	VipHide bool `bson:"vip_hide" codec:"-"`

	BattleCards [6]document.ID `bson:"battle_cards" codec:"-"`
	Cards       []cardbasic    `bson:"-" codec:"cards"`
}

var roleselector = bson.M{"_id": 1, "name": 1, "personal_sign": 1, "last_time": 1, "logo": 1, "frame": 1, "figure": 1, "title_id": 1, "level": 1, "vip_level": 1, "battle_fighting_point": 1, "pokedex": 1, "battle_cards": 1, "vip_hide": 1}

type cardbasic struct {
	ID      ID     `bson:"_id" codec:"id"`
	Name    string `bson:"name" codec:"name"`
	CardId  int    `bson:"card_id" codec:"card_id"`
	Advance int    `bson:"advance" codec:"advance"`
	Star    int    `bson:"star" codec:"star"`
	Level   int    `bson:"level" codec:"level"`
	SkinId  int    `bson:"skin_id" codec:"skin_id"`
}

type Slimcard struct {
	cardbasic     `bson:",inline"`
	Gender        int                      `bson:"gender" codec:"gender"`
	Character     int                      `bson:"character" codec:"character"`
	NValue        map[string]int           `bson:"nvalue" codec:"nvalue"`
	FightingPoint int                      `bson:"fighting_point" codec:"fighting_point"`
	Skills        map[document.Integer]int `bson:"skills" codec:"skills"`
	ZawakeSkills  []int                    `bson:"zawake_skills" codec:"zawake_skills"`

	Attrs map[string]float64 `bson:"db_attrs" codec:"attrs"`

	HeldItemID document.ID    `bson:"held_item" codec:"-"`
	HeldItem   map[string]int `bson:"-" codec:"held_item,omitempty"`

	RoleDbId document.ID `bson:"role_db_id" codec:"-"`
	RoleName string      `bson:"-" codec:"role_name"`
}

var cardselector = bson.M{"_id": 1, "name": 1, "card_id": 1, "advance": 1, "star": 1, "level": 1, "gender": 1, "character": 1, "nvalue": 1, "skin_id": 1, "fighting_point": 1, "skills": 1, "db_attrs": 1, "held_item": 1, "role_db_id": 1, "zawake_skills": 1}
var helditemselector = bson.M{"held_item_id": 1, "level": 1, "advance": 1}

func (s *Service) GetSlimRole(id ID) (*Slimrole, error) {
	role := new(Slimrole)
	err := s.storage.exec("Role", func(collection *mgo.Collection) error {
		return collection.Find(bson.M{"_id": id}).Select(roleselector).One(role)
	})
	if err != nil {
		return nil, err
	}

	cardids := make([]ID, 0, 6)
	for _, id := range role.BattleCards {
		if id != "" {
			cardids = append(cardids, id)
		}
	}
	cards := make([]cardbasic, 0, 6)
	err = s.storage.exec("RoleCard", func(collection *mgo.Collection) error {
		return collection.Find(bson.M{"_id": bson.M{"$in": cardids}}).Select(cardselector).All(&cards)
	})
	if err != nil {
		return nil, err
	}
	battlecards := make(map[ID]cardbasic)
	for _, card := range cards {
		battlecards[card.ID] = card
	}
	role.Cards = make([]cardbasic, 0, 6)
	for _, id := range role.BattleCards {
		if id != "" {
			role.Cards = append(role.Cards, battlecards[id])
		}
	}
	role.CollectNum = len(role.Pokedex)
	if role.VipHide {
		role.VipLevel = 0
	}

	return role, nil
}

func (s *Service) GetSlimCard(id ID) (*Slimcard, error) {
	card := new(Slimcard)
	err := s.storage.exec("RoleCard", func(collection *mgo.Collection) error {
		return collection.Find(bson.M{"_id": id}).Select(cardselector).One(card)
	})
	if err != nil {
		return nil, err
	}
	if card.HeldItemID != "" {
		card.HeldItem = make(map[string]int)
		err := s.storage.exec("RoleHeldItem", func(collection *mgo.Collection) error {
			return collection.Find(bson.M{"_id": card.HeldItemID}).Select(helditemselector).One(&card.HeldItem)
		})
		if err != nil {
			card.HeldItem = nil
			log.Warningf("Query Card:%v HeldItem:%v error %v", id, card.HeldItemID, err)
		}
	}
	if card.RoleDbId != "" {
		resp := make(map[string]string)
		err := s.storage.exec("Role", func(collection *mgo.Collection) error {
			return collection.FindId(card.RoleDbId).Select(bson.M{"name": 1}).One(&resp)
		})
		if err == nil {
			card.RoleName = resp["name"]
		} else {
			log.Warningf("Query Card:%v Role:%v error %v", id, card.RoleDbId, err)
		}
	}
	return card, err
}

func (s *Service) MultipGetSlimRoles(ids []ID) ([]Slimrole, error) {
	roles := make([]Slimrole, 0, len(ids))
	err := s.storage.exec("Role", func(collection *mgo.Collection) error {
		return collection.Find(bson.M{"_id": bson.M{"$in": ids}}).Select(roleselector).All(&roles)
	})
	if err != nil {
		return nil, err
	}

	cardids := make([]ID, 0, len(ids)*6)
	for _, role := range roles {
		for _, id := range role.BattleCards {
			if id != "" {
				cardids = append(cardids, id)
			}
		}
	}
	cards := make([]cardbasic, 0, len(ids)*6)
	err = s.storage.exec("RoleCard", func(collection *mgo.Collection) error {
		return collection.Find(bson.M{"_id": bson.M{"$in": cardids}}).Select(cardselector).All(&cards)
	})
	if err != nil {
		return nil, err
	}
	battlecards := make(map[ID]cardbasic)
	for _, card := range cards {
		battlecards[card.ID] = card
	}

	for i := range roles {
		roles[i].Cards = make([]cardbasic, 0, 6)
		for _, id := range roles[i].BattleCards {
			if id != "" {
				roles[i].Cards = append(roles[i].Cards, battlecards[id])
			}
		}
		roles[i].CollectNum = len(roles[i].Pokedex)
		if roles[i].VipHide {
			roles[i].VipLevel = 0
		}
	}

	return roles, err
}

func (s *Service) MultipGetSlimCards(ids []ID) ([]Slimcard, error) {
	cards := make([]Slimcard, 0, len(ids))
	err := s.storage.exec("RoleCard", func(collection *mgo.Collection) error {
		return collection.Find(bson.M{"_id": bson.M{"$in": ids}}).Select(cardselector).All(&cards)
	})
	if err != nil {
		return nil, err
	}
	for i := range cards {
		if cards[i].HeldItemID == "" {
			continue
		}
		heldItemID := cards[i].HeldItemID
		cards[i].HeldItem = make(map[string]int)
		err := s.storage.exec("RoleHeldItem", func(collection *mgo.Collection) error {
			return collection.Find(bson.M{"_id": heldItemID}).Select(helditemselector).One(&cards[i].HeldItem)
		})
		if err != nil {
			cards[i].HeldItem = nil
			log.Warningf("Query Card:%v HeldItem:%v error %v", cards[i].ID, heldItemID, err)
		}
	}

	return cards, err
}

// Order Operation
func (s *Service) PayOrderAdd(order *scheme.PayOrder) (response *Response, err error) {
	doc := NewDocument(order)
	err = doc.Save(s.storage, true)
	if err == nil {
		s.session.Set(doc)
	}
	response = NewResponse(s.Name())
	response.Write(err, doc)
	if err != nil && strings.Index(err.Error(), "duplicate key error") != -1 {
		doc, _ := s.session.Query("PayOrder", bson.M{"order_id": order.OrderID})
		response.Model = doc.IDocument
		err = nil
	}
	return
}

func (s *Service) PayOrderRecharge(id ID) (response *Response, err error) {
	doc, err := s.session.Get("PayOrder", id)
	if err == nil {
		order := doc.IDocument.(*scheme.PayOrder)
		order.RechargeFlag = true
		doc.modify("recharge_flag")
		err = doc.Save(s.storage, false)
		if err == nil {
			s.session.Forget("PayOrder", id)
		}
	}
	response = NewResponse(s.Name())
	response.Write(err)
	return
}

func (s *Service) PayOrderBad(id ID) (response *Response, err error) {
	doc, err := s.session.Get("PayOrder", id)
	if err == nil {
		order := doc.IDocument.(*scheme.PayOrder)
		order.BadFlag = true
		doc.modify("bad_flag")
		err = doc.Save(s.storage, false)
		if err == nil {
			s.session.Forget("PayOrder", id)
		}
	}
	response = NewResponse(s.Name())
	response.Write(err)
	return
}

const MyPayOrderKey = "MyPayOrder"

func (s *Service) MyPayOrderCreate(kvs map[string]string, flush bool) (resp bool, err error) {
	err = s.storage.exec(MyPayOrderKey, func(collection *mgo.Collection) error {
		var err error
		if flush {
			_, err = collection.Upsert(nil, kvs)
		} else {
			_, err = collection.Upsert(nil, bson.M{"$set": kvs})
		}
		return err
	})
	resp = err == nil
	return
}

func (s *Service) MyPayOrderAll() (resp map[string]string, err error) {
	resp = make(map[string]string)
	err = s.storage.exec(MyPayOrderKey, func(collection *mgo.Collection) error {
		err := collection.Find(nil).Select(bson.M{"_id": 0}).One(&resp)
		return err
	})
	if err == mgo.ErrNotFound {
		err = nil
	}
	return
}

// Gift Operation
func (s *Service) GiftGen(giftID int, size int, ops []string) ([]string, error) {
	randkey := func() string {
		r := make([]byte, 6)
		rand.Read(r)
		key := hex.EncodeToString(r)
		return key
	}
	ret := make([]string, 0, size)
	for i := 0; i < size; i++ {
		key := randkey()
		gift := document.New("Gift", true).(*scheme.Gift)
		gift.Key = key
		gift.CSVID = giftID
		gift.OptServerKeys = ops
		doc := NewDocument(gift)
		err := doc.Save(s.storage, true)
		if err == nil {
			ret = append(ret, key)
		}
	}
	return ret, nil
}

// 自定义礼包码生成
func (s *Service) GiftGenManual(key string, giftID int, ops []string) ([]string, error) {
	gift := document.New("Gift", true).(*scheme.Gift)
	gift.Key = key
	gift.CSVID = giftID
	gift.OptServerKeys = ops
	doc := NewDocument(gift)
	err := doc.Save(s.storage, true)
	if err != nil {
		return nil, err
	}
	return []string{key}, nil
}

// 订单礼包码生成
func (s *Service) OrderGiftGen(orderID string, giftID int, ops []string) (string, error) {
	randkey := func() string {
		r := make([]byte, 6)
		rand.Read(r)
		key := hex.EncodeToString(r)
		return key
	}
	gift := document.New("Gift", true).(*scheme.Gift)
	gift.CSVID = giftID
	gift.OptServerKeys = ops
	gift.OrderID = orderID
	doc := NewDocument(gift)
	for i := 0; i < 10; i++ {
		key := randkey()
		gift.Key = key
		err := doc.Save(s.storage, true)
		if err == nil {
			return key, nil
		}
	}
	return "", errors.New("gift code gen error")
}

// 订单礼包码查询
func (s *Service) OrderGiftQuery(orderID string) (string, error) {
	doc, err := s.session.Query("Gift", bson.M{"order_id": orderID})
	if err != nil {
		if err == mgo.ErrNotFound {
			err = nil
		}
		return "", err
	}
	gift := doc.IDocument.(*scheme.Gift)
	return gift.Key, nil
}
 
func (s *Service) GiftExisted(key string, serverKey string, accountID ID) (response *Response, err error) {
	response = NewResponse(s.Name())
	doc, err := s.session.Query("Gift", bson.M{"key": key})
	if err != nil {
		if err == mgo.ErrNotFound {
			err = nil
			response.Write(errors.New("no_gift"))
		} else {
			response.Write(err)
		}
		return response, err
	}
	gift := doc.IDocument.(*scheme.Gift)
	if gift.AccountDBID != "" {
		if gift.AccountDBID == accountID {
			err = errors.New("gift_used")
		} else {
			err = errors.New("gift_other_used")
		}
	} else {
		if len(gift.OptServerKeys) > 0 {
			ok := false
			for _, key := range gift.OptServerKeys {
				if serverKey == key {
					ok = true
					break
				}
			}
			if !ok {
				err = errors.New("gift_cannot_use")
			}
		}
	}
	s.session.Forget("Gift", gift.ID)
	response.Write(err, doc)
	return response, nil
}

// RmbReturn Operation
func (s *Service) RmbReturnQuery(name string, key string) (map[string]int, error) {
	// 通过name查，返回是否为空
	// 1.若查询不为空则判断Area是否存在，若Area存在则与 key 比对一下，不同返回空。
	// 若不存在则将Key写入到Area；且返回rmb、vip的map
	// 2.若返回为空，则没有充值过，直接返回空的{}

	_, ok := s.rmbReturnQuery.LoadOrStore(name, key)
	if ok {
		return map[string]int{}, errors.New("the same name is logging in")
	}
	defer s.rmbReturnQuery.Delete(name)

	doc, err := s.session.Query("RmbReturn", bson.M{"name": name})
	if err != nil {
		if err == mgo.ErrNotFound {
			return map[string]int{}, nil
		}
		return map[string]int{}, err
	}
	rmbReturn := doc.IDocument.(*scheme.RmbReturn)
	if rmbReturn.Area != "" {
		if rmbReturn.Area != key {
			return map[string]int{}, err
		}
	} else {
		// 写回去
		rmbReturn.Area = key
		doc.modify("area")
		doc.Save(s.storage, false)
		s.session.Forget("RmbReturn", rmbReturn.ID)
	}
	return map[string]int{"rmb": rmbReturn.Rmb, "vip": rmbReturn.Vip}, err
}

func (s *Service) GiftUse(key string, serverKey string, accountID ID) (map[string]interface{}, error) {
	doc, err := s.session.Query("Gift", bson.M{"key": key})
	if err != nil {
		if err == mgo.ErrNotFound {
			return map[string]interface{}{"ret": false, "err": "no_gift"}, nil
		}
		return map[string]interface{}{"ret": false, "err": err.Error()}, err
	}
	gift := doc.IDocument.(*scheme.Gift)
	if gift.AccountDBID != "" {
		if gift.AccountDBID == accountID {
			return map[string]interface{}{"ret": false, "err": "gift_used"}, nil
		} else {
			return map[string]interface{}{"ret": false, "err": "gift_other_used"}, nil
		}
	} else {
		if len(gift.OptServerKeys) > 0 {
			ok := false
			for _, key := range gift.OptServerKeys {
				if serverKey == key {
					ok = true
					break
				}
			}
			if !ok {
				return map[string]interface{}{"ret": false, "err": "gift_cannot_use"}, nil
			}
		}
		gift.UseTime = time.Now().Unix()
		gift.AccountDBID = accountID
		gift.UseServerKey = serverKey
		doc.modify("use_time", "account_db_id", "use_server_key")
		doc.Save(s.storage, false)
		s.session.Forget("Gift", gift.ID)
		return map[string]interface{}{"ret": true}, nil
	}
}

func (s *Service) GiftQuery(key string) (*scheme.Gift, error) {
	doc, err := s.session.Query("Gift", bson.M{"key": key})
	if err != nil {
		return nil, err
	}
	gift := doc.IDocument.(*scheme.Gift)
	return gift, nil
}

// Document 数据转移
func (s *Service) Transition(name string, id document.ID, doc document.IDocument) (resp bool, err error) {
	if name == "Role" {
		_, err := s.session.Get("Role", id)
		if err != nil { // not existed role
			role := doc.(*scheme.Role) // 角色特殊uid逻辑
			if role.UID, err = s.storage.IncID("Role"); err != nil {
				return false, err
			}
			doc = role
		}
	}
	err = s.storage.exec(name, func(collection *mgo.Collection) error {
		_, err := collection.UpsertId(id, doc)
		return err
	})
	return err == nil, err
}

// 删除卡牌恢复
func (s *Service) RoleCardRecover(id document.ID) (bool, error) {
	card := NewRoleCardExpired()
	err := card.recover(s.storage, id)
	return err == nil, err
}

// 获取已删除卡牌列表，参数id为 role.id
func (s *Service) RoleCardExpiredGet(id document.ID) ([]*RoleCardExpired, error) {
	cards := make([]*RoleCardExpired, 0, 8)
	err := s.storage.exec("RoleCardExpired", func(collection *mgo.Collection) error {
		return collection.Find(bson.M{"role_db_id": id}).Sort("-delete_at").All(&cards)
	})
	for _, card := range cards {
		card.DeleteTime = card.DeleteAt.Unix()
	}
	return cards, err
}

type logger struct {
	*log.Logger
}

func (l *logger) Output(calldepth int, s string) error {
	oldDepth := l.Logger.ExtraCalldepth
	l.Logger.ExtraCalldepth = calldepth + 1
	l.Logger.Info(s)
	l.Logger.ExtraCalldepth = oldDepth
	return nil
}

func (s *Service) SetMGOLoggerAndDebug(logflag bool, debug bool) (bool, error) {
	mgo.SetDebug(debug)
	if logflag {
		mgo.SetLogger(&logger{Logger: log.GetLogger()})
	} else {
		mgo.SetLogger(nil)
	}
	return true, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}

	s.Register(s, "GetMGOStats")

	r := &Resolver{s}

	dbResp := func(args ...interface{}) interface{} { return &Response{name: args[0].(string)} }
	s.RegisterWithNew(r, "DBCreate", dbResp)
	s.RegisterWithNew(r, "DBUpdate", dbResp)
	s.RegisterWithNew(r, "DBUpsert", dbResp)
	s.RegisterWithNew(s, "DBRead", dbResp)
	s.RegisterWithNew(s, "DBDelete", dbResp)
	s.RegisterWithNew(s, "DBMultipleRead", dbResp)
	s.RegisterWithNew(s, "DBMultipleDelete", dbResp)
	s.RegisterWithNew(s, "DBReadsert", dbResp)
	s.RegisterWithNew(s, "DBMultipleReadKeys", dbResp)
	s.RegisterWithNew(s, "DBReadBy", dbResp)
	s.RegisterWithNew(s, "DBReadIn", dbResp)
	s.RegisterWithNew(s, "DBReadAll", dbResp)
	s.RegisterWithNew(s, "DBReadByPattern", dbResp)
	s.RegisterWithNew(s, "DBReadRangeBy", dbResp)
	s.RegisterWithNew(s, "DBReadKeysRangeBy", dbResp)
	s.RegisterWithNew(s, "DBCommitObject", dbResp)
	s.RegisterWithNew(s, "DBReadRecordBy", dbResp)

	s.Register(s, "DBCommit")
	s.Register(s, "DBFlush")

	accountResp := func(...interface{}) interface{} { return &Response{name: "Account"} }
	s.RegisterWithNew(r, "AccountAdd", accountResp)
	s.RegisterWithNew(s, "AccountLogin", accountResp)
	s.RegisterWithNew(s, "AccountLogin2", accountResp)
	s.RegisterWithNew(s, "AccountRoleCheckIn", accountResp)
	s.RegisterWithNew(s, "AccountQuery", accountResp)
	s.RegisterWithNew(s, "AccountQueryByName", accountResp)
	s.RegisterWithNew(s, "AccountQueryByEmail", accountResp)
	s.RegisterWithNew(s, "AccountMigrate", accountResp)
	s.RegisterWithNew(s, "AccountDisable", accountResp)
	s.RegisterWithNew(s, "AccountAge", accountResp)


	gmResp := func(...interface{}) interface{} { return &Response{name: "GMAccount"} }
	s.RegisterWithNew(r, "GMAdd", gmResp)
	s.RegisterWithNew(s, "GMLogin", gmResp)
	s.RegisterWithNew(s, "GMOpHistory", gmResp)

	roleResp := func(...interface{}) interface{} { return &Response{name: "Role"} }
	s.RegisterWithNew(r, "RoleAdd", roleResp)
	s.RegisterWithNew(s, "RoleGet", roleResp)
	s.RegisterWithNew(s, "RoleGetRobots", roleResp)

	cardCommentResp := func(...interface{}) interface{} { return &Response{name: "CardComment"} }
	s.RegisterWithNew(s, "CardCommentQuery", cardCommentResp)
	s.Register(s, "CardFightTop200Cards")
	s.Register(s, "CardFightTop200Roles")

	s.Register(s, "DBRankRoleAdd")
	s.Register(s, "DBRankRoleAddBulk")
	s.Register(s, "DBRankCardAdd")
	s.Register(s, "DBRank")
	s.Register(s, "DBRankRangeByScore")
	s.Register(s, "DBGetRankSize")
	s.Register(s, "DBSummaryRange")
	s.Register(s, "DBDrop")
	s.Register(s, "DBRankClearRole")

	s.Register(s, "GetSlimRole")
	s.Register(s, "GetSlimCard")
	s.Register(s, "MultipGetSlimRoles")
	s.Register(s, "MultipGetSlimCards")

	orderResp := func(...interface{}) interface{} { return &Response{name: "PayOrder"} }
	s.RegisterWithNew(r, "PayOrderAdd", orderResp)
	s.Register(s, "PayOrderRecharge")
	s.Register(s, "PayOrderBad")
	s.Register(s, "MyPayOrderCreate")
	s.Register(s, "MyPayOrderAll")

	giftResp := func(...interface{}) interface{} { return &Response{name: "Gift"} }
	s.Register(s, "GiftGen")
	s.Register(s, "GiftGenManual")
	s.RegisterWithNew(s, "GiftExisted", giftResp)
	s.Register(s, "GiftUse")
	s.Register(s, "OrderGiftGen")
	s.Register(s, "OrderGiftQuery")
	s.Register(s, "GiftQuery")

	s.Register(s, "RmbReturnQuery")

	s.Register(r, "Transition")

	// 已删除卡牌恢复相关
	s.Register(s, "RoleCardRecover")
	s.Register(s, "RoleCardExpiredGet")

	s.Register(s, "SetMGOLoggerAndDebug")

	return s
}

type Resolver struct {
	s *Service
}

func (r *Resolver) Name() string {
	return r.s.Name()
}

func (r *Resolver) DBCreate(name string, raw codec.Raw) (resp *Response, err error) {
	internal := document.New(name, true)
	if err = tjutil.MsgUnpack(raw, internal); err != nil {
		return
	}
	return r.s.DBCreate(name, internal)
}

func (r *Resolver) DBUpdate(name string, id ID, raw codec.Raw, forget bool) (resp *Response, err error) {
	updater, err := document.NewRawUpdater(name, raw)
	if err != nil {
		return nil, err
	}
	return r.s.DBUpdate(name, id, updater, forget)
}

// update or insert
func (r *Resolver) DBUpsert(name string, id ID, raw codec.Raw) (resp *Response, err error) {
	internal := document.New(name, true)
	if err = tjutil.MsgUnpack(raw, internal); err != nil {
		return
	}
	return r.s.DBUpsert(name, id, internal)
}

func (r *Resolver) RoleAdd(raw codec.Raw) (resp *Response, err error) {
	internal := document.New("Role", true)
	if err = tjutil.MsgUnpack(raw, internal); err != nil {
		return
	}
	return r.s.RoleAdd(internal.(*scheme.Role))
}

func (r *Resolver) AccountAdd(raw codec.Raw) (response *Response, err error) {
	internal := document.New("Account", true)
	if err = tjutil.MsgUnpack(raw, internal); err != nil {
		return
	}
	return r.s.AccountAdd(internal.(*scheme.Account))
}

func (r *Resolver) GMAdd(raw codec.Raw) (response *Response, err error) {
	internal := document.New("GMAccount", true)
	if err = tjutil.MsgUnpack(raw, internal); err != nil {
		return
	}
	return r.s.GMAdd(internal.(*scheme.GMAccount))
}

func (r *Resolver) PayOrderAdd(raw codec.Raw) (response *Response, err error) {
	internal := document.New("PayOrder", true)
	if err = tjutil.MsgUnpack(raw, internal); err != nil {
		return
	}
	return r.s.PayOrderAdd(internal.(*scheme.PayOrder))
}

func (r *Resolver) Transition(name string, id document.ID, raw codec.Raw) (resp bool, err error) {
	internal := document.New(name, true)
	if err = tjutil.MsgUnpack(raw, internal); err != nil {
		return
	}
	return r.s.Transition(name, id, internal)
}

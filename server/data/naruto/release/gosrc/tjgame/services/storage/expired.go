package storage

import (
	"time"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"

	mgo "tjgame/mgo.v2"
)

var ExpireAfter = util.OneDay * 30

type RoleCardExpired struct {
	scheme.RoleCard `bson:",inline"`
	DeleteTime      int64     `bson:"-" codec:"delete_time"`
	DeleteAt        time.Time `bson:"delete_at" codec:"-"`
}

func (*RoleCardExpired) CollectionName() string {
	return "RoleCardExpired"
}

func (*RoleCardExpired) OriginCollectionName() string {
	return "RoleCard"
}

func (r *RoleCardExpired) migrate(storage *Storage, id ID) error {
	var err error
	err = storage.exec(r.OriginCollectionName(), func(collection *mgo.Collection) error {
		return collection.FindId(id).One(r)
	})
	if err != nil {
		return err
	}
	r.DeleteAt = util.Now()
	r.DeleteTime = r.DeleteAt.Unix()

	err = storage.exec(r.CollectionName(), func(collection *mgo.Collection) error {
		return collection.Insert(r)
	})
	return err
}

func (r *RoleCardExpired) recover(storage *Storage, id ID) error {
	var err error
	err = storage.exec(r.CollectionName(), func(collection *mgo.Collection) error {
		return collection.FindId(id).One(r)
	})
	if err == nil {
		r.ExistFlag = true
		err = storage.exec(r.OriginCollectionName(), func(collection *mgo.Collection) error {
			return collection.Insert(r.RoleCard)
		})
	}
	if err == nil { // 删除 expired 中的数据
		err = storage.exec(r.CollectionName(), func(collection *mgo.Collection) error {
			return collection.RemoveId(id)
		})
	}
	return err
}

func ensureExpiredIndex(storage *Storage) {
	log.Debugf("ensureExpiredIndex")
	storage.exec("RoleCardExpired", func(collection *mgo.Collection) error {
		if err := collection.EnsureIndexKey("role_db_id"); err != nil {
			log.Warningf("RoleCardExpired EnsureIndexKey role_db_id error %v", err)
		}
		if err := collection.EnsureIndex(mgo.Index{Key: []string{"delete_at"}, ExpireAfter: ExpireAfter}); err != nil {
			log.Warningf("RoleCardExpired EnsureIndexKey delete_at error %v", err)
		}
		return nil
	})
}

func NewRoleCardExpired() *RoleCardExpired {
	card := &RoleCardExpired{}
	card.RoleCard = *document.New(card.OriginCollectionName(), true).(*scheme.RoleCard)
	return card
}

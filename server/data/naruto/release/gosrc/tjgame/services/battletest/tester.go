package battletest

import (
	"math/rand"
	"strings"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/service"
	"tjgame/services/storage"

	"tjgame/mgo.v2/bson"
)

type Role struct {
	ID                   document.ID `codec:"id" json:"-"`
	UID                  int         `codec:"uid" json:"uid"`
	Name                 string      `codec:"name" json:"-"`
	PvpRecordDbId        document.ID `codec:"pvp_record_db_id" json:"-"`
	CraftRecordDbId      document.ID `codec:"craft_record_db_id" json:"-"`
	CrossCraftRecordDbId document.ID `codec:"cross_craft_record_db_id" json:"-"`
	UnionFightRecordDbId document.ID `codec:"union_fight_record_db_id" json:"-"`

	GameKey string `codec:"-" json:"key"`
	PID     string `json:"id"`
}

func (r *Role) Key(service string) string {
	v := strings.Split(r.GameKey, ".")
	v[0] = service
	if service == "storage" && v[2] == "2" {
		return "storagemerge.dev.1"
	}
	return strings.Join(v, ".")
}

func (r *Role) fetch(s service.IService) error {
	resp, err := service.Call(s, "RoleGet", bson.M{"role_id": r.ID})
	if err != nil {
		return err
	}
	response := resp.(storage.Response)
	model := response.Model.(*scheme.Role)
	r.ID = model.ID
	r.UID = model.UID
	r.Name = model.Name
	r.PvpRecordDbId = model.PvpRecordDbId
	r.CraftRecordDbId = model.CraftRecordDbId
	r.CrossCraftRecordDbId = model.CrossCraftRecordDbId
	r.UnionFightRecordDbId = model.UnionFightRecordDbId
	return nil
}

func NewRole(key string, id document.ID) *Role {
	return &Role{
		GameKey: key,
		ID:      id,
	}
}

func RandomShuffleRoles(roles []*Role) {
	rand.Shuffle(len(roles), func(i, j int) {
		roles[i], roles[j] = roles[j], roles[i]
	})
}

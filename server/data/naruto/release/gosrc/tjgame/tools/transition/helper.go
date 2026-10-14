package transition

import (
	"strings"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/services/storage"
)

func dbNameFromMongoURL(url string) string {
	s := strings.Split(url, "/")
	name := s[len(s)-1]
	name = strings.Split(name, "?")[0]
	return name
}

func idSliceExclude(ids []document.ID, id document.ID) []document.ID {
	v := make([]document.ID, 0, len(ids))
	for _, vv := range ids {
		if vv != id {
			v = append(v, vv)
		}
	}
	return v
}

func storageResponseToRole(response interface{}) *scheme.Role {
	r := response.(storage.Response)
	if r.Model == nil {
		return nil
	}
	role := r.Model.(*scheme.Role)
	return role
}

func storageResponseToAccount(response interface{}) *scheme.Account {
	r := response.(storage.Response)
	if r.Model != nil {
		return r.Model.(*scheme.Account)
	}
	return nil
}

func queryRole(id document.ID, dbc service.IService) *scheme.Role {
	resp, err := service.Call(dbc, "RoleGet", map[string]interface{}{"role_id": id})
	if err != nil {
		log.Warningf("role %s get error %s", id, err)
		return nil
	}
	response := resp.(storage.Response)
	if response.Model == nil {
		return nil
	}
	return response.Model.(*scheme.Role)
}

func queryAccount(id document.ID, rpc service.IService) *scheme.Account {
	resp, err := service.Call(rpc, "AccountQuery", id)
	if err != nil {
		return nil
	}
	response := resp.(storage.Response)
	if response.Model == nil {
		return nil
	}
	return response.Model.(*scheme.Account)
}

package services

import (
	"encoding/json"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
)

type Define struct {
	service.ContainerOption `json:",inline"`
}

// ICustomJsonDefine
func (d *Define) GetExtend(opt interface{}, raw json.RawMessage) interface{} {
	name := opt.(*service.Option).Name
	serv, _, _ := service.SplitServiceName(name)
	optEx := Factory.NewOption(serv)
	if optEx != nil {
		err := json.Unmarshal(raw, optEx)
		if err != nil {
			panic(err)
		}
		log.Debugf("GetExtend service %s %#v", name, optEx)
		return optEx
	}
	log.Debugf("GetExtend service %s %#v", name, opt)
	return opt
}

package task

import (
	"login/servers"
	"time"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/services/game"
)

type TaskEnterServer struct {
	Key  string `codec:"key"`
	Name string `codec:"name"`
	Age  int    `codec:"age"`
}

type taskEnterServerResponse struct {
	Ret      bool   `codec:"ret"`
	Err      string `codec:"err,omitempty"`
	ServID   int    `codec:"serv_id"`
	ServKey  string `codec:"serv_key"`
	ServName string `codec:"serv_name"`
	Servers  string `codec:"servers"`
}

func (t *TaskEnterServer) Run(record *Record) interface{} {
	account, ok := record.account.(*scheme.Account)
	if !ok {
		log.Warningf("account err: %#v", record.account)
		return &taskEnterServerResponse{
			Ret: false,
			Err: "no such account",
		}
	}

	_, _, id := service.SplitServiceName(t.Key)

	log.Infof("`%s` login in server %d `%s` `%s`", account.Name, id, t.Key, t.Name)

	passed := record.channel == "none" || record.channel == "luo"

	if !passed && servers.IsGameMantain(t.Key) { // 单服维护状态
		return &taskEnterServerResponse{
			Ret: false,
			Err: "server_maintain",
		}
	}

	if _, ok := account.RoleInfos[t.Key]; !ok {
		if servers.IsGameRegisterDisable(t.Key) { // 单服注册关闭
			return &taskEnterServerResponse{
				Ret:     false,
				Err:     "register_disable",
				Servers: servers.GetChannelServersJson(record.channel, record.conn.RemoteAddr().String()),
			}
		}
	}

	gameRpc := record.rpc.Game(t.Key)
	if gameRpc == nil {
		return &taskEnterServerResponse{
			Ret: false,
			Err: "no such server " + t.Key,
		}
	}

	// 处理钻石返还
	dbRmbReturnMap := map[string]int{}
	if servers.IsRmbReturn() {
		_, k, _ := service.SplitServiceName(t.Key)
		if k == "cn_qd" {
			rmbRResp, errQ := service.Call(record.rpc.Storage(), "RmbReturnQuery", account.Name, t.Key)
			dbRmbReturnMap = rmbRResp.(map[string]int)
			if errQ != nil {
				log.Warning("rmbReturn db rpc error", errQ)
				return &taskCheckResponse{
					Ret: false,
					Err: errQ.Error(),
				}
			}
			if len(dbRmbReturnMap) > 0 {
				log.Infof("account: `%s` %s rmbReturn rmb: `%d` vip: `%d`", account.Name, t.Key, dbRmbReturnMap["rmb"], dbRmbReturnMap["vip"])
			}
		}
	}

	// 实名注册奖励
	sdkInfo := map[string]interface{}{}
	if account.Age == 0 && t.Age > 0 {
		if _, err := service.Call(record.rpc.Storage(), "AccountAge", account.ID, t.Age); err == nil {
			sdkInfo["age"] = t.Age
			log.Infof("`%s` age %d send award in server %d `%s` `%s`", account.Name, t.Age, id, t.Key, t.Name)
		}
	}

	args := []interface{}{
		GameServInternalPassword,
		id,
		account.ID,
		account.Name,
		account.Channel,
		record.Pwd,
		record.isNewAccount,
		sdkInfo,
	}
	if len(dbRmbReturnMap) > 0 {
		args = append(args, dbRmbReturnMap)
	}

	ret, err := service.CallWithTimeout(gameRpc, "AccountLogin", 20*time.Second, args...)
	if err != nil {
		log.Warningf("AccountLogin %s err: %v", t.Key, err)
		//time.Sleep(10 * time.Millisecond)
	} else {
		arr := ret.(*game.LoginResponse)
		log.Debug(ret, arr, err)
		if arr != nil {
			_, err = service.Call(record.rpc.Storage(), "AccountRoleCheckIn", account.ID, t.Key, arr.Role)
		}
	}

	if err != nil {
		return &taskEnterServerResponse{
			Ret: false,
			Err: err.Error(),
		}
	}
	resp := &taskEnterServerResponse{
		Ret:      true,
		ServID:   id,
		ServKey:  t.Key,
		ServName: t.Name,
	}
	return resp
}

func (TaskEnterServer) Url() string {
	return "/login/enter_server"
}

func (TaskEnterServer) New() Task {
	return &TaskEnterServer{}
}

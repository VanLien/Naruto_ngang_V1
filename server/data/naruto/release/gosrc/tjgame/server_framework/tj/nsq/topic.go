package nsq

import (
	"fmt"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service/caller"
)

// https://nsq.io/clients/tcp_protocol_spec.html#notes
// Valid serviceMethod and channel names are characters [.a-zA-Z0-9_-] and 1 < length <= 64 (max length was 32 prior to nsqd 0.2.28)

// NSQ 定义
// 1. 全局型服务
// REQ:
//   Topic = MethodName
//   Channel = "global"
//   Host one/cluster
//   1:1:N
// RESP:
//   -> 2
// 比如:
//   newBattlePlay game -> agent manager -> agent -> game
//
// 2. RPC型服务
// REQ:
//   Topic = REQ-ServiceID
//   Topic = RESP-ContainerID
//   Channel = "rpc"
//   Host one
//   1:1:1
// RESP:
//   -> 2
// 比如:
//   getPvPRecord game -> pvp -> game
//
// 3. 通知型服务
// NTF:
//   Topic = MethodName
//   Channel = ContainerID
//   Host many
//   1:N:Method
// 比如:
//   log -> gmweb
//       -> logarchive
//
// 1,2型服务均有RESP回包
// 3型服务没有，即使有client端也无法处理多种不同数据的回包

const (
	GlobalServiceChannel = "global"
	RPCServiceChannel    = "rpc"
	ServiceRespChannel   = "0global_1rpc"
)

func ClientTopic(typ caller.ServiceMethodType, serviceID, method string) string {
	switch typ {
	case caller.Global:
		return method
	case caller.RPC:
		return fmt.Sprintf("REQ-%s", serviceID)
	case caller.Notify:
		return method
	}
	return ""
}

func ClientNotifyTopic(method string) string {
	return method
}

func ClientRespTopicAndChannel(containerID string) (string, string) {
	return fmt.Sprintf("RESP-%s", containerID), ServiceRespChannel
}

func ReqTopicAndChannel(typ caller.ServiceMethodType, serviceID, method string) (string, string) {
	switch typ {
	case caller.Global:
		return method, GlobalServiceChannel
	case caller.RPC:
		return fmt.Sprintf("REQ-%s", serviceID), RPCServiceChannel
	case caller.Notify:
		return method, serviceID
	}
	return "", ""
}

func RespTopicAndChannel(typ caller.ServiceMethodType, containerID string) (string, string) {
	switch typ {
	case caller.Global:
		return fmt.Sprintf("RESP-%s", containerID), ServiceRespChannel
	case caller.RPC:
		return fmt.Sprintf("RESP-%s", containerID), ServiceRespChannel
	case caller.Notify:
		log.Warning("notify no resp")
	}
	return "", ""
}

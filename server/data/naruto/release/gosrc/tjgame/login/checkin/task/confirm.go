package task

import (
	"login/servers"
)

type TaskConfirm struct {
}

type taskConfirmResponse struct {
	Ret     bool   `codec:"ret"`
	Servers string `codec:"servers"`
}

// only s->c, run by server
func (t *TaskConfirm) Run(record *Record) interface{} {
	return &taskConfirmResponse{
		Ret:     true,
		Servers: servers.GetChannelServersJson(record.channel, record.conn.RemoteAddr().String()),
	}
}

func (TaskConfirm) Url() string {
	return "/login/confirm"
}

func (TaskConfirm) New() Task {
	return &TaskConfirm{}
}

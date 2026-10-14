package task

type MsgFull struct {
	Notice string `codec:"notice"`
}

func (MsgFull) Url() string {
	return "/login/full"
}

func (MsgFull) New() Msg {
	return &MsgFull{Notice: "queue too long"}
}

//-------------------------

type MsgKick struct {
	Notice string `codec:"notice"`
}

func (MsgKick) Url() string {
	return "/login/kick"
}

func (MsgKick) New() Msg {
	return &MsgKick{Notice: "what are you doing now"}
}

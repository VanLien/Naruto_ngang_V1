package caller

type INotifyClient interface {
	Notify(method string, args ...interface{})
}

type NotifyCaller struct {
	Client INotifyClient
}

func (c *NotifyCaller) Register(info FuncServiceInfo) {
	// NotifyCaller is remote caller, don't care response
	// so the function is empty implement
}

func (c *NotifyCaller) CanCall(method string) bool {
	return true
}

func (c *NotifyCaller) CallInGo(method string, args ...interface{}) (resp interface{}, err error) {
	c.Client.Notify(method, args...)
	return nil, nil
}

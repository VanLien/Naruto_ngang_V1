package cross

import "tjgame/server_framework/tj/service"

func EventToSomeGame(container service.IContainer, method string, event string, d map[string]interface{}, sync interface{}, responses func(string, interface{})) error {
	keys := make([]string, 0, len(d))
	futures := make([]*service.Future, 0, len(d))
	for key, data := range d {
		keys = append(keys, key)
		s := container.GetService(key)
		future := service.CallAsync(s, method, event, key, data, sync)
		futures = append(futures, future)
	}

	resp, err := service.MultiFuture(futures, false).Get()
	if err != nil {
		return err
	}
	response := resp.([]interface{})
	for i, key := range keys {
		responses(key, response[i])
	}
	return nil
}

func ContainerServices(container service.IContainer, services ...string) error {
	for _, name := range services {
		if container.GetService(name) == nil {
			if err := container.AddRemoteService(name); err != nil {
				return err
			}
		}
	}
	return nil
}

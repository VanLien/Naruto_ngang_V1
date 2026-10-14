package transition

import (
	"io/ioutil"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
)

func dump(payload *Payload, filename string) (string, error) {
	id := payload.Role.ID
	//now := time.Now()
	//filename := fmt.Sprintf("%s/%x_%s", path, string(id), now.Format("200601021504"))
	data, err := util.MsgPack(payload)
	if err == nil {
		err = ioutil.WriteFile(filename, data, 0777)
	}
	if err != nil {
		return "", err
	}
	log.Infof("dump role %v, %s", id, filename)
	return filename, err
}

func load(filename string) (*Payload, error) {
	data, err := ioutil.ReadFile(filename)
	payload := &Payload{}
	if err == nil {
		err = util.MsgUnpack(data, payload)
	}
	if err != nil {
		return nil, err
	}
	return payload, nil
}

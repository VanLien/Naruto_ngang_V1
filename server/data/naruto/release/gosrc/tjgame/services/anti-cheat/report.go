package anti_cheat

import (
	"bytes"
	"net/http"
	"tjgame/document"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
)

type TracebackReport struct {
	Type       BattleType  `codec:"type"`
	ServKey    string      `codec:"serv_key"`
	PlayID     document.ID `codec:"play_id"`
	PlayRecord []byte      `codec:"play_record"`
	Traceback  string      `codec:"traceback"`
}

func (r *TracebackReport) reportToCrash() {
	if tracebackReportUrl == "" {
		return
	}
	data, err := util.MsgPack(r)
	if err != nil {
		return
	}
	buffer := bytes.NewBuffer(data)
	resp, err := http.Post(tracebackReportUrl, "", buffer)
	log.Debug(resp, err)
}

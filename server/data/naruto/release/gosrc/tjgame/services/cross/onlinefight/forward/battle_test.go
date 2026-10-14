package forward

import (
	"io/ioutil"
	"testing"
	"tjgame/server_framework/tj/util"
	"tjgame/services/cross/onlinefight/proto"
)

func loadTestBattleInfo() *proto.BattleInfo {
	data, err := ioutil.ReadFile("host/limited_battle.data")
	if err != nil {
		panic(err)
	}
	info := &proto.BattleInfo{}
	err = util.MsgUnpack(data, info)
	if err != nil {
		panic(err)
	}
	return info
}

func TestBattleManager_NewBattle(t *testing.T) {
	info := loadTestBattleInfo()
	battle := NewBattle(info)
	battle.SetProxyRunner(&FakeProxyRunner{})

	// both loading ok
	battle.State = BothBanPick
	go battle.startBanPickLoop()

	<-battle.Done()
}

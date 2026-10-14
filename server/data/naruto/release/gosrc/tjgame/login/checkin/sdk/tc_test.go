package sdk

import "testing"

func TestTc_FetchUID(t *testing.T) {
	sdk := &tc{}
	t.Log(sdk.Channel())
	ret, err := sdk.FetchUID(sdk, map[string]interface{}{
		"channelId": "channelID",
		"userId":    "userId",
		"token":     "token",
	})

	t.Log(err)
	t.Log(ret)
}

func TestTc_FetchUID2(t *testing.T) {
	sdk := &tc_qd{}
	t.Log(sdk.Channel())
	ret, err := sdk.FetchUID(sdk, map[string]interface{}{
		"channelId": "channelID",
		"userId":    "userId",
		"token":     "token",
	})

	t.Log(err)
	t.Log(ret)
}

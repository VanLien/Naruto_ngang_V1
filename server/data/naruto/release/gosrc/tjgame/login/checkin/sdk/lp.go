package sdk

// import (
// 	"crypto/md5"
// 	"errors"
// 	"fmt"
// 	"tjgame/server_framework/tj/log"
// )

// 伦奇 tw vn

type lpConfig struct {
	SiteCode string `json:"siteCode"`
	GameCode string `json:"gameCode"`
	Key      string `json:"key"`  // 獲取角色key
	Key1     string `json:"key1"` // 登入驗證和點擊儲值時的加密key1
	Key2     string `json:"key2"` // 儲值遊戲幣或儲值成功后客戶端返回的驗證信息key2
}

type lp struct {
}

func (s *lp) Channel() string {
	return "lp"
}

func (s *lp) FetchUID(sdk SDKVerifier, params map[string]interface{}) (*SDKAccount, error) {
	//cfg := gConfigs[sdk.Channel()]

	user_id := params["user_id"].(string)
	

	// site_code := params["site_code"].(string)
	// t := params["t"].(string)
	// passport := params["passport"].(string)
	// ck := params["ck"].(string)

	// sign := site_code + t + cfg.Key1 + passport
	// fmt.Println("sign:", sign)

	// sign = fmt.Sprintf("%x", md5.Sum([]byte(sign)))
	// fmt.Println("sign md5:", sign)

	// if sign != ck {
	// 	log.Errorf("sign error %s %s", sign, ck)
	// 	return nil, errors.New("sign error")
	// }

	// return &SDKAccount{
	// 	Channel:       sdk.Channel(),
	// 	ChannelPrefix: sdk.Channel(),
	// 	Name:          passport,
	// }, nil

	return &SDKAccount{
		Channel:       sdk.Channel(),
		ChannelPrefix: sdk.Channel(),
		Name:          user_id,
	}, nil
}

package task

import (
	"crypto/rand"
	"encoding/json"
	"login/servers"
	"net"
	"strings"

	"login/checkin/sdk"
	"login/diff"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/storage"
)

type TaskCheck struct {
	Name       string `codec:"name"`
	AppVersion string `codec:"app"`
	Patch      int    `codec:"patch"`
	MinPatch   int    `codec:"minpatch"`
	Channel    string `codec:"channel"`
	Language   string `codec:"language"`
	Tag        string `codec:"tag"`
	Fake       bool   `codec:"fake"`    // if true, ignore app_version and patch check
	Guarder    string `codec:"guarder"` // check lua files were valid to anti moder

	IP       net.Addr `codec:"-"`
	Platform string   `codec:"platform"`
}

type taskCheckResponse struct {
	Ret     bool        `codec:"ret"`
	Err     string      `codec:"err,omitempty"`
	Pwd     []byte      `codec:"session_pwd,omitempty"`
	Account interface{} `codec:"account,omitempty"`
	Login   string      `codec:"login,omitempty"` // 审核login地址
}

func (t *TaskCheck) Run(record *Record) interface{} {
	t.Name = strings.TrimSpace(t.Name)
	t.Channel = strings.ToLower(t.Channel)

	log.Infof("`%s` login request with channel `%s` tag `%s`", t.Name, t.Channel, t.Tag)
	log.Infof("`%s` channel `%s` tag `%s` guarder `%s`", t.Name, t.Channel, t.Tag, t.Guarder)

	// 黑名单判断
	if servers.IsInBlackList(t.IP) {
		return &taskCheckResponse{
			Ret: false,
			Err: "",
		}
	}

	// if t.Channel == "lp_en" {
	// 	platform := t.Platform
	// 	if platform == "" {
	// 		platform = "ios"
	// 	}
	// 	if servers.CheckIsp(t.IP.String(), platform) {
	// 		return &taskCheckResponse{
	// 			Ret:   false,
	// 			Err:   servers.MaintainBillboard(),
	// 			Login: servers.ShenheLogin(),
	// 		}
	// 	}
	// }

	// 白名单判断
	if servers.WhiteListEnable() && !servers.IsInWhiteList(t.Tag, t.IP) {
		return &taskCheckResponse{
			Ret: false,
			Err: servers.WhiteListBillboard(),
		}
	}

	// 审核包的tag 和 none 可通过
	passed := t.Tag == "com_meng_chongjy_1" || t.Channel == "none"

	// 维护公告
	if servers.IsMaintain() && !passed {
		return &taskCheckResponse{
			Ret: false,
			Err: servers.MaintainBillboard(),
		}
	}

	isDisableRegister := false
	name := t.Name
	channel := t.Channel
	record.channel = t.Channel
	if t.Channel != "none" && t.Channel != "luo" {
		// sdk verify token
		channelSDK, ok := sdk.Factory[t.Channel]
		if ok {
			params := make(map[string]interface{})
			err := json.Unmarshal(util.String2ReadOnlyBytes(t.Name), &params)
			if err != nil {
				return &taskCheckResponse{
					Ret: false,
					Err: "name_error",
				}
			}
			sdkAccount, err := channelSDK.FetchUID(channelSDK, params)
			if err != nil {
				return &taskCheckResponse{
					Ret: false,
					Err: err.Error(),
				}
			}
			name = sdkAccount.GetName()
			channel = sdkAccount.Channel
			isDisableRegister = sdkAccount.IsDisableRegister
		} else {
			log.Warningf("no such sdk %s", t.Channel)
			return &taskCheckResponse{
				Ret: false,
				Err: channel + "_sdk_error",
			}
		}

		// guarder verify
		if t.Guarder != servers.GetGuarderMD5() {
			log.Warningf("guarder error %s %s", t.Guarder,servers.GetGuarderMD5())
			return &taskCheckResponse{
				Ret: false,
				Err: "files_error",
			}
		}
	}

	version, patch := diff.GetVersionPatch()
	log.Debug(version, patch, t.AppVersion, t.Patch)
	ignore := t.Fake
	if !ignore {
		if !strings.HasPrefix(version, t.AppVersion) {
			log.Warningf("%s client version error, expect %s got %s", name, version, t.AppVersion)
			return &taskCheckResponse{
				Ret: false,
				Err: "version_error",
			}
		}
		patchInvalid := false
		if patch != t.Patch {
			patchInvalid = true
			if t.Channel == "luo" || t.Channel == "none" {
				if diff.GetTestPatch() == t.Patch {
					patchInvalid = false
				} else {
					log.Warningf("%s client patch error, expect test %d got %d", name, diff.GetTestPatch(), t.Patch)
				}
			}
		}
		if patchInvalid {
			log.Warningf("%s client patch error, expect %d got %d", name, patch, t.Patch)
			return &taskCheckResponse{
				Ret: false,
				Err: "patch_error",
			}
		}
	}

	r, err := service.Call(record.rpc.Storage(), "AccountLogin", name)
	dbResp := r.(storage.Response)
	if err != nil && err.Error() != storage.ErrNoAccount.Error() {
		log.Warning("db rpc error", err)
		errRet := "check_account_error"
		switch err.Error() {
		case storage.ErrAccountDisabled.Error():
			errRet = "account_disabled"
		}
		return &taskCheckResponse{
			Ret: false,
			Err: errRet,
		}
	}

	if dbResp.Ret {
		record.isNewAccount = false
		record.account = dbResp.Model
	} else {
		record.isNewAccount = true
		if isDisableRegister {
			log.Warning("register account disable", name, t.Language, channel)
			return &taskCheckResponse{
				Ret: false,
				Err: "register_account_disable",
			}
		}

		account := document.New("Account", true).(*scheme.Account)
		account.Name = name
		account.Language = t.Language
		account.Channel = channel
		r, _ := service.Call(record.rpc.Storage(), "AccountAdd", account)
		dbResp := r.(storage.Response)
		if dbResp.Ret {
			record.account = dbResp.Model
			log.Infof("`%s` is new account with channel `%s` tag `%s`", account.Name, t.Channel, t.Tag)
		} else {
			log.Warning("add new account failed", name, t.Language, channel)
			return &taskCheckResponse{
				Ret: false,
				Err: "add_new_account_failed",
			}
		}
	}

	resp := &taskCheckResponse{
		Ret:     true,
		Account: record.account,
	}
	pwd := make([]byte, 16)
	n, err := rand.Read(pwd)
	if n != 16 || err != nil {
		log.Warning("pwd rand err", n, err)
		return &taskCheckResponse{
			Ret: false,
			Err: "pwd rand err",
		}
	}
	record.Pwd = pwd
	resp.Pwd = pwd
	record.conn.SetAESKeyInNext(string(record.Pwd))

	log.Debug(resp)
	return resp
}

func (TaskCheck) Url() string {
	return "/login/check"
}

func (TaskCheck) New() Task {
	return &TaskCheck{}
}

package task

import (
	"crypto/rand"
	"encoding/json"
	"crypto/md5"
	"encoding/hex"
	"login/servers"
	"net"
	"strings"
	"net/mail"
	"login/checkin/sdk"
	"login/diff"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
	"tjgame/services/storage"
)

type TaskCheckCreate struct {
	Name       string `codec:"name"`	
	Pass       string `codec:"pass"`
	Email       string `codec:"email"`
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


type taskCheckCreateResponse struct {
	Ret     bool        `codec:"ret"`
	Err     string      `codec:"err,omitempty"`
	Pwd     []byte      `codec:"session_pwd,omitempty"`
	Account interface{} `codec:"account,omitempty"`
	Login   string      `codec:"login,omitempty"` // 审核login地址
}
func valid(email string) bool {
    _, err := mail.ParseAddress(email)
    return err == nil
}
func GetMD5HashWithSumPass(text string) string {
    hash := md5.Sum([]byte(text))
    return hex.EncodeToString(hash[:]) 
}
func (t *TaskCheckCreate) Run(record *Record) interface{} {
	log.Infof("dcm co vo day khong")
	t.Name = strings.TrimSpace(t.Name)
	t.Pass = strings.TrimSpace(t.Pass)
	t.Channel = strings.ToLower(t.Channel)
	if(!valid(t.Email)){
		return &taskCheckCreateResponse{
			Ret: false,
			Err: "Vui lòng nhập đúng định dạng email",
		}
	}
	log.Infof("`%s` `%s` create account request with channel `%s` tag `%s`", t.Name,t.Pass, t.Channel, t.Tag)
	log.Infof("`%s` `%s` channel `%s` tag `%s` guarder `%s`", t.Name,t.Pass, t.Channel, t.Tag, t.Guarder)

	// 黑名单判断
	if servers.IsInBlackList(t.IP) {
		return &taskCheckCreateResponse{
			Ret: false,
			Err: "",
		}
	}

	if t.Channel == "lp_en" {
		platform := t.Platform
		if platform == "" {
			platform = "ios"
		}
		if servers.CheckIsp(t.IP.String(), platform) {
			return &taskCheckCreateResponse{
				Ret:   false,
				Err:   servers.MaintainBillboard(),
				Login: servers.ShenheLogin(),
			}
		}
	}

	// 白名单判断
	if servers.WhiteListEnable() && !servers.IsInWhiteList(t.Tag, t.IP) {
		return &taskCheckCreateResponse{
			Ret: false,
			Err: servers.WhiteListBillboard(),
		}
	}

	// 审核包的tag 和 none 可通过
	passed := t.Tag == "com_meng_chongjy_1" || t.Channel == "none"

	// 维护公告
	if servers.IsMaintain() && !passed {
		return &taskCheckCreateResponse{
			Ret: false,
			Err: servers.MaintainBillboard(),
		}
	}

	isDisableRegister := false
	name := t.Name
	pass_md5 := GetMD5HashWithSumPass(t.Pass)
	log.Infof("`%s` `%s` register request ", name,pass_md5)
	channel := t.Channel
	record.channel = t.Channel
	if t.Channel != "none" && t.Channel != "luo" {
		// sdk verify token
		channelSDK, ok := sdk.Factory[t.Channel]
		if ok {
			params := make(map[string]interface{})
			err := json.Unmarshal(util.String2ReadOnlyBytes(t.Name), &params)
			if err != nil {
				return &taskCheckCreateResponse{
					Ret: false,
					Err: "name_error",
				}
			}
			sdkAccount, err := channelSDK.FetchUID(channelSDK, params)
			if err != nil {
				return &taskCheckCreateResponse{
					Ret: false,
					Err: err.Error(),
				}
			}
			name = sdkAccount.GetName()
			channel = sdkAccount.Channel
			isDisableRegister = sdkAccount.IsDisableRegister
		} else {
			log.Warningf("no such sdk %s", t.Channel)
			return &taskCheckCreateResponse{
				Ret: false,
				Err: channel + "_sdk_error",
			}
		}

		// guarder verify
		if t.Guarder != servers.GetGuarderMD5() {
			log.Warningf("guarder error %s", t.Guarder)
			return &taskCheckCreateResponse{
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
			return &taskCheckCreateResponse{
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
			return &taskCheckCreateResponse{
				Ret: false,
				Err: "patch_error",
			}
		}
	}

	r, err := service.Call(record.rpc.Storage(), "AccountQueryByName", name)
	dbResp := r.(storage.Response)
	if err != nil && err.Error() != storage.ErrNoAccount.Error() {
		log.Warning("db rpc error", err)
		errRet := "check_account_error"
		switch err.Error() {
		case storage.ErrAccountDisabled.Error():
			errRet = "account_disabled"
		}
		return &taskCheckCreateResponse{
			Ret: false,
			Err: errRet,
		}
	}

	if dbResp.Ret {
		record.isNewAccount = false
		record.account = dbResp.Model
		return &taskCheckCreateResponse{
			Ret: false,
			Err: "Tài khoản này đã được đăng kí",
		}
	} else {
		record.isNewAccount = true
		
		if isDisableRegister {
			log.Warning("register account disable", name, t.Language, channel)
			return &taskCheckCreateResponse{
				Ret: false,
				Err: "register_account_disable",
			}
		}

		account := document.New("Account", true).(*scheme.Account)
		account.Name = name
		account.PassMd5 = pass_md5
		account.Email = t.Email
		
		account.Money = int64(0)

		//account.PayID = int64(100003)


		account.Language = t.Language
		account.Channel = channel
		r, _ := service.Call(record.rpc.Storage(), "AccountAdd", account)
		dbResp := r.(storage.Response)
		if dbResp.Ret {
			record.account = dbResp.Model
			log.Infof("`%s` is new account with channel `%s` tag `%s`", account.Name, t.Channel, t.Tag)
		} else {
			log.Warning("add new account failed", name, t.Language, channel)
			return &taskCheckCreateResponse{
				Ret: false,
				Err: "Tạo tài khoản thất bại",
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

func (TaskCheckCreate) Url() string {
	return "/login/create_account"
}

func (TaskCheckCreate) New() Task {
	return &TaskCheckCreate{}
}

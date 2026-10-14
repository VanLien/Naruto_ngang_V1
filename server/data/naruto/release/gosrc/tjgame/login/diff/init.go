package diff

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"login/servers"
	"net/http"
	"net/url"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"sync"
	"time"
	"tjgame/server_framework/tj"

	"github.com/xxtea/xxtea-go/xxtea"

	"login/util"
	"tjgame/server_framework/tj/log"
	tjutil "tjgame/server_framework/tj/util"
)

const (
	version          = "2.1.0.0"
	noticePath       = "conf/notice.json"
	noticePathFormat = "conf/%s/notice.json"
	shenhePath       = "conf/shenhe.json"
	patchUrlPath     = "conf/patch_url.json"
)

var (
	patchUrl      string // 默认patch url
	shenheVersion string
	langKey       string
	majorVersion  string

	initWaiter           = &sync.RWMutex{}
	responseCache        = make(map[int][]byte)
	responseEncryptCache = make(map[int][]byte)
	noticeCache          = []byte{}
	shenhePatchMap       = make(map[string]int64)  // {tag: patch}
	patchUrlMap          = make(map[string]string) // 增对特殊tag包的patch url
)

type PatchInfo struct {
	AppVersion    string      `json:"app_version"`
	Version       string      `json:"version"`
	Patch         int         `json:"patch"`
	PatchUrl      string      `json:"patch_url"`
	ShenheVersion string      `json:"shenhe_version"`
	UpdateClose   bool        `json:"update_close"`
	Files         []*FileInfo `json:"files"`
}

func initShenheMap() {
	dir, _ := os.Getwd()
	path := filepath.Join(dir, shenhePath)
	content, err := ioutil.ReadFile(path)
	if err != nil {
		log.Panic(err)
	}

	err = json.Unmarshal(content, &shenhePatchMap)
	if err != nil {
		log.Panic(err)
	}
}

func isInShenhe(tag string) bool {
	if _, ok := shenhePatchMap[tag]; ok {
		return false
	}
	return true
}

func initPatchUrlMap() {
	dir, _ := os.Getwd()
	path := filepath.Join(dir, patchUrlPath)
	if _, err := os.Stat(path); err != nil {
		log.Warningf("%s not existed", patchUrlPath)
		return
	}
	content, err := ioutil.ReadFile(path)
	if err != nil {
		log.Panic(err)
	}

	v := make(map[string]map[string]string)
	err = json.Unmarshal(content, &v)
	if err != nil {
		log.Panic(err)
	}
	patchUrlMap = v[langKey]
	log.Infof("patch url map %v", patchUrlMap)
}

func getPatchUrl(tag string) string {
	if s, ok := patchUrlMap[tag]; ok {
		return s
	}
	return patchUrl
}

func makeNoticeCache() {
	data, _ := json.Marshal(map[string]interface{}{
		"version": &PatchInfo{
			version,
			version,
			maxPatch,
			patchUrl,
			shenheVersion,
			false,
			nil,
		},
	})
	dir, _ := os.Getwd()
	path := filepath.Join(dir, fmt.Sprintf(noticePathFormat, langKey))
	if _, err := os.Stat(path); err != nil {
		log.Warningf("%s stats error %s", path, err)
		path = filepath.Join(dir, noticePath)
	}
	content, err := ioutil.ReadFile(path)
	if err == nil {
		data = bytes.Join([][]byte{data[:len(data)-1], []byte(`,"notice":`), content, []byte("}")}, []byte(""))
	}

	data, _ = tjutil.GZipCompress(data)
	noticeCache = data
}

func makeResponseForShenhe(tag string, patch int, encrypt bool) []byte {
	initWaiter.Lock()
	defer initWaiter.Unlock()

	data, _ := json.Marshal(&PatchInfo{
		version,
		version,
		maxPatch,
		getPatchUrl(tag),
		shenheVersion,
		false,
		getPatchsFrom(patch+1, true),
	})
	if encrypt {
		data = encryptResponse(data)
	}
	data, _ = tjutil.GZipCompress(data)
	return data
}

func makeResponse(tag string, patch int) []byte {
	data, _ := json.Marshal(&PatchInfo{
		version,
		version,
		maxPatch,
		getPatchUrl(tag),
		shenheVersion,
		false,
		getPatchsFrom(patch+1, false),
	})
	return data
}

func makeResponseCache(tag string, patch int, encrypt bool) []byte {
	initWaiter.Lock()
	defer initWaiter.Unlock()

	if langKey == "en" { // en 特殊判，先不用缓存
		if encrypt {
			data := makeResponse(tag, patch)
			data = encryptResponse(data)
			data, _ = tjutil.GZipCompress(data)
			return data
		} else {
			data := makeResponse(tag, patch)
			data, _ = tjutil.GZipCompress(data)
			return data
		}
	}

	if encrypt {
		if _, ok := responseEncryptCache[patch]; !ok {
			data := makeResponse(tag, patch)
			data = encryptResponse(data)
			data, _ = tjutil.GZipCompress(data)
			responseEncryptCache[patch] = data
		}
		return responseEncryptCache[patch]
	}

	if _, ok := responseCache[patch]; !ok {
		data := makeResponse(tag, patch)
		data, _ = tjutil.GZipCompress(data)
		responseCache[patch] = data
	}
	return responseCache[patch]
}

const xxteakey = "HangZhou@TianJi_"

func encryptResponse(data []byte) []byte {
	s := xxtea.EncryptString(string(data), xxteakey)
	return []byte(s)
}

func decryptRequest(r *http.Request) bool {
	encrypt := false
	if s := r.FormValue("q"); len(s) > 0 {
		encrypt = true
		var err error
		var query string
		var values url.Values
		query, err = xxtea.DecryptString(s, xxteakey)
		if err == nil {
			values, err = url.ParseQuery(query)
		}
		if err != nil {
			panic(err)
		}
		r.Form = values // replace original request form
	}
	return encrypt
}

func noticeHandler(w http.ResponseWriter, req *http.Request) {
	defer util.LogHTTPReq(req, time.Now())

	initWaiter.RLock()
	defer initWaiter.RUnlock()

	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.Header().Set("Content-Encoding", "gzip")
	w.Header().Set("Content-Length", strconv.Itoa(len(noticeCache)))
	w.Write(noticeCache)
}

func versionTestHandler(w http.ResponseWriter, req *http.Request) {
	defer util.LogHTTPReq(req, time.Now())

	req.ParseForm()
	encrypt := decryptRequest(req)

	w.Header().Set("Content-Type", "text/plain")
	w.Header().Set("Content-Encoding", "gzip")

	// patch
	var patch int64 = 0
	if s := req.FormValue("patch"); len(s) > 0 {
		patch, _ = strconv.ParseInt(s, 10, 32)
	}

	// max_patch
	var userMaxPatch int64 = 0
	if s := req.FormValue("max_patch"); len(s) > 0 {
		userMaxPatch, _ = strconv.ParseInt(s, 10, 32)
	}

	// tag
	tag := ""
	if s := req.FormValue("tag"); len(s) > 0 {
		tag = strings.ToLower(s)
	}

	// shenhe
	isShenhe := false
	shenhe := "false"
	if s := req.FormValue("shenhe"); len(s) > 0 {
		shenhe = strings.ToLower(s)
	}
	if shenhe == "true" {
		isShenhe = true
	}

	// fake
	fake := "false"
	if s := req.FormValue("fake"); len(s) > 0 {
		fake = strings.ToLower(s)
	}
	if fake == "true" || (isShenhe && isInShenhe(tag)) {
		data, _ := json.Marshal(&PatchInfo{
			version,
			version,
			int(patch),
			getPatchUrl(tag),
			shenheVersion,
			true,
			emptyCache,
		})
		if encrypt {
			data = encryptResponse(data)
		}
		data, _ = tjutil.GZipCompress(data)
		w.Header().Set("Content-Length", strconv.Itoa(len(data)))
		w.Write(data)
		return
	}

	// obb
	isOBB := false
	obb := "false"
	if s := req.FormValue("obb"); len(s) > 0 {
		obb = strings.ToLower(s)
	}
	if obb == "true" {
		isOBB = true
	}

	// client download version.plist for normalize if it open update
	if isShenhe || isOBB {
		// include myself for no update, but need version.plist
		patch--
	}

	testMaxPatch, files := getTestPatchFrom(int(patch)+1, int(userMaxPatch), isShenhe)
	testMaxPatchCache = testMaxPatch
	data, _ := json.Marshal(&PatchInfo{
		version,
		version,
		testMaxPatch,
		getPatchUrl(tag),
		shenheVersion,
		false,
		files,
	})
	if encrypt {
		data = encryptResponse(data)
	}
	data, _ = tjutil.GZipCompress(data)

	w.Header().Set("Content-Length", strconv.Itoa(len(data)))
	w.Write(data)
}

func versionHandler(w http.ResponseWriter, req *http.Request) {
	if isIPEnableTest(req.RemoteAddr) {
		// may be use version/test in intranet, not real version
		versionTestHandler(w, req)
		return
	}

	defer util.LogHTTPReq(req, time.Now())

	req.ParseForm()
	encrypt := decryptRequest(req)

	w.Header().Set("Content-Type", "text/plain")
	w.Header().Set("Content-Encoding", "gzip")

	// patch
	var patch int64 = 0
	if s := req.FormValue("patch"); len(s) > 0 {
		patch, _ = strconv.ParseInt(s, 10, 32)
	}

	// tag
	tag := ""
	if s := req.FormValue("tag"); len(s) > 0 {
		tag = strings.ToLower(s)
	}

	// shenhe
	isShenhe := false
	shenhe := "false"
	if s := req.FormValue("shenhe"); len(s) > 0 {
		shenhe = strings.ToLower(s)
	}
	if shenhe == "true" {
		isShenhe = true
	}

	// fake
	fake := "false"
	if s := req.FormValue("fake"); len(s) > 0 {
		fake = strings.ToLower(s)
	}

	ispCheck := false
	if tj.Language() == "en" {
		platform := "ios"
		if s := req.FormValue("plat"); len(s) > 0 {
			platform = strings.ToLower(s)
		}
		if servers.CheckIsp(req.RemoteAddr, platform) {
			ispCheck = true
		}
	}

	if fake == "true" || (isShenhe && isInShenhe(tag)) || ispCheck {
		data, _ := json.Marshal(&PatchInfo{
			version,
			version,
			int(patch),
			getPatchUrl(tag),
			shenheVersion,
			true,
			emptyCache,
		})
		if encrypt {
			data = encryptResponse(data)
		}
		data, _ = tjutil.GZipCompress(data)
		w.Header().Set("Content-Length", strconv.Itoa(len(data)))
		w.Write(data)
		return
	}

	if patch <= 0 || patch > int64(maxPatch) {
		log.Warning("error patch")
		w.WriteHeader(404)
		return
	}

	// app
	var app string
	if s := req.FormValue("app"); len(s) > 0 {
		app = strings.Join(strings.Split(s, ".")[:3], ".")
	}
	if app != majorVersion {
		log.Warning("error app")
		w.WriteHeader(404)
		return
	}

	// arch
	var arch string = ""
	if s := req.FormValue("arch"); len(s) > 0 {
		arch = s
	}
	if arch != "x86" && arch != "x64" {
		log.Warning("error arch")
		w.WriteHeader(404)
		return
	}

	// obb
	// =true, need download 0 patch
	// =false, may be apk+obb and 0 patch already in client
	isOBB := false
	obb := "false"
	if s := req.FormValue("obb"); len(s) > 0 {
		obb = strings.ToLower(s)
	}
	if obb == "true" {
		isOBB = true
	}

	// client download version.plist for normalize if it open update
	if isShenhe || isOBB {
		// include myself for no update, but need version.plist
		patch--
	}

	var data []byte
	if isShenhe && shenhePatchMap[tag] > 0 {
		patch = shenhePatchMap[tag]
		patch--
	}
	if (isShenhe && shenhePatchMap[tag] <= 0) || isOBB {
		recordQuery(0)
		data = makeResponseForShenhe(tag, int(patch), encrypt)
	} else {
		recordQuery(int(patch))
		data = makeResponseCache(tag, int(patch), encrypt)
	}

	if data != nil {
		w.Header().Set("Content-Length", strconv.Itoa(len(data)))
		w.Write(data)
	} else {
		log.Warningf("empty patch %d", patch)
		w.WriteHeader(404)
		return
	}
}

func Init(key, lang, url string, mux *http.ServeMux) {
	if patchUrl != "" {
		return
	}
	patchUrl = url
	langKey = lang
	log.Info("version", version)
	log.Info("patchUrl", patchUrl)

	majorVersion = strings.Join(strings.Split(version, ".")[:3], ".")

	OnConfigChanged()

	mux.HandleFunc("/notice", noticeHandler)
	mux.HandleFunc("/version", versionHandler)
	mux.HandleFunc("/version/test", versionTestHandler)
	mux.HandleFunc("/stat", statisticsHandler)
}

func OnConfigChanged() {
	initWaiter.Lock()
	defer initWaiter.Unlock()

	responseCache = make(map[int][]byte)
	responseEncryptCache = make(map[int][]byte)
	noticeCache = []byte{}
	shenhePatchMap = make(map[string]int64)

	initFilterMap()
	initTestIPMap()
	initShenheMap()
	initPatchUrlMap()
	initPatchCache()
	makeNoticeCache()

	shenheVersion = getShenheVersion()
}

func GetVersionPatch() (string, int) {
	return version, maxPatch
}

func GetTestPatch() int {
	return testMaxPatchCache
}

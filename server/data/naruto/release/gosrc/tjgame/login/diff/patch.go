package diff

import (
	"encoding/json"
	"io/ioutil"
	"path"
	"path/filepath"
	"sort"
	"strconv"
	"strings"

	"tjgame/server_framework/tj/log"
)

const (
	patchDir      = "patch"
	patchTestPath = "patch_test"

	shenhePatch = 0
	// negative mean test patch
)

type FileInfo struct {
	Name  string `json:"name"`
	Size  uint   `json:"size"`
	MD5   string `json:"md5"`
	Patch int    `json:"patch"`
}

type clientPatchInfo struct {
	SvnVersion string      `json:"svn_version"`
	GitVersion string      `json:"git_version"`
	Files      []*FileInfo `json:"files"`
}

var (
	maxPatch          int
	testMaxPatchCache int
	patchs            map[int]clientPatchInfo

	emptyCache = []*FileInfo{}
)

func getPatchsFrom(from int, isShenhe bool) []*FileInfo {
	if maxPatch == 0 {
		return emptyCache
	}

	hash := make(map[string]*FileInfo, 16)
	if isShenhe {
		if _, ok := patchs[shenhePatch]; ok {
			patch := patchs[shenhePatch]
			files := patch.Files
			for _, file := range files {
				hash[file.Name] = file
			}
		}
	}
	for i := from; i <= maxPatch; i++ {
		patch, ok := patchs[i]
		if !ok {
			continue
		}
		files := patch.Files
		for _, file := range files {
			hash[file.Name] = file
		}
	}
	ret := make([]*FileInfo, 0, len(hash))
	for _, file := range hash {
		ret = append(ret, file)
	}
	return ret
}

func walkPatchDirFiles(dirname string, maxPatch *int, patchs *map[int]clientPatchInfo) error {
	files, _ := ioutil.ReadDir(dirname)
	for _, fi := range files {
		filename := filepath.Join(dirname, fi.Name())
		if strings.HasSuffix(fi.Name(), ".json") {
			data, _ := ioutil.ReadFile(filename)
			patch := &clientPatchInfo{}
			err := json.Unmarshal(data, patch)
			if err != nil {
				log.Panic(err)
			}
			name := fi.Name()
			skey := name[:len(name)-5]
			key64, err := strconv.ParseInt(skey, 10, 32)
			key := int(key64)
			if err == nil {
				valid := false
				files := make([]*FileInfo, 0, len(patch.Files))
				for _, file := range patch.Files {
					if !isDisable(file.Name) {
						file.Patch = key
						files = append(files, file)
					}
					if file.Name == "res/version.plist" {
						valid = true
					}
				}
				if !valid {
					log.Panicf("%s not contain res/version.plist", filename)
				}
				if key > *maxPatch {
					*maxPatch = key
				}
				(*patchs)[key] = *patch
			}
		}
	}
	return nil
}

func initPatchCache() {
	maxPatch = 0
	patchs = map[int]clientPatchInfo{}

	patchPath := path.Join(patchDir, langKey)
	err := walkPatchDirFiles(patchPath, &maxPatch, &patchs)
	if err != nil {
		log.Panic(err)
	}

	log.Infof("%s init ok", patchPath)
	arr := make([]int, 0, len(patchs))
	for k := range patchs {
		arr = append(arr, k)
	}
	sort.Ints(arr)
	for _, k := range arr {
		log.Info("patch", k, "files", len(patchs[k].Files))
	}
}

func getTestPatchFrom(from, requireMaxPatch int, isShenhe bool) (int, []*FileInfo) {
	// initPatchCache from test
	testMaxPatch := 0
	testPatchs := map[int]clientPatchInfo{}

	err := walkPatchDirFiles(patchTestPath, &testMaxPatch, &testPatchs)
	if requireMaxPatch == 0 {
		requireMaxPatch = testMaxPatch
		if maxPatch > testMaxPatch {
			requireMaxPatch = maxPatch
		}
	}

	if err != nil {
		log.Warning(err)
		return requireMaxPatch, emptyCache
	}

	arr := make([]int, 0, len(testPatchs))
	for k := range testPatchs {
		arr = append(arr, k)
	}
	sort.Ints(arr)
	for _, k := range arr {
		log.Info(patchTestPath, "patch", k, "files", len(testPatchs[k].Files))
	}

	// getPatchsFrom from test
	if maxPatch == 0 && testMaxPatch == 0 {
		return 0, emptyCache
	}

	hash := make(map[string]*FileInfo, 16)
	if isShenhe {
		if _, ok := patchs[shenhePatch]; ok {
			patch := patchs[shenhePatch]
			files := patch.Files
			for _, file := range files {
				hash[file.Name] = file
			}
		}
	}
	for i := from; i <= requireMaxPatch; i++ {
		patch1, ok1 := patchs[i]
		patch2, ok2 := testPatchs[i]
		if !ok1 && !ok2 {
			continue
		}
		files1 := patch1.Files
		files2 := patch2.Files
		files := files2
		if !ok2 {
			files = files1
		}
		for _, file := range files {
			if ok2 {
				// negative mean test patch
				file.Patch = -file.Patch
			}
			hash[file.Name] = file
		}
	}
	ret := make([]*FileInfo, 0, len(hash))
	for _, file := range hash {
		ret = append(ret, file)
	}
	return requireMaxPatch, ret
}

func getShenheVersion() string {
	if patch, ok := patchs[shenhePatch]; ok {
		return patch.SvnVersion
	}
	return ""
}

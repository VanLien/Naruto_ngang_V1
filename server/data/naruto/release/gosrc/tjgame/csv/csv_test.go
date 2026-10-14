package csv

import (
	"fmt"
	"runtime"
	"testing"

	tjcsv "tjgame/server_framework/tj/csv"
)

func Test_Load(t *testing.T) {
	stats := &runtime.MemStats{}
	runtime.ReadMemStats(stats)
	fmt.Printf("%+v\n", stats)

	Init("./", "cn", false)

	fmt.Println(Config.Unit[101])
	fmt.Printf("EveryPos %#v\n", Config.Unit[101].EveryPos)
	fmt.Printf("%#v\n", Config.Unit[101].EveryPos["lifePos"].(tjcsv.Map))
	fmt.Printf("%#v\n", Config.Unit[101].EveryPos["lifePos"].(tjcsv.Map)["y"])
	fmt.Printf("%#v\n", Config.Unit[101].EveryPos.GetMap("lifePos")["y"])
	fmt.Printf("%#v\n", Config.Unit[101].EveryPos.GetMap("lifePos2").GetMap("y")[11])

	a := Config.Unit[101]
	fmt.Println(a)

	b := Config.Unit[101]
	c := Config.Unit[101]
	fmt.Printf("%p %p %p\n", &a, &b, &c)

	// <11;12;13;{aaaa=1};<bbb;123;ccc>;{d=<dddd;222>;e={fff=123}}>
	fmt.Println(Config.Skill[13])
	fmt.Printf("SkillProcess %#v\n", Config.Skill[13].SkillProcess)
	//fmt.Printf("%#v\n", Config.Skill[13].SkillProcess.GetMap(3))
	//fmt.Printf("%#v\n", Config.Skill[13].SkillProcess.GetMap(3)["aaaa"])
	//fmt.Printf("%#v\n", Config.Skill[13].SkillProcess.GetSlice(4))
	//fmt.Printf("%#v\n", Config.Skill[13].SkillProcess.GetSlice(4)[1])
	//
	//fmt.Printf("%T\n", Config.Skill[13].SkillProcess.GetMap(3)["aaaa"])

	runtime.GC()
	runtime.Gosched()
	runtime.GC()

	runtime.ReadMemStats(stats)
	fmt.Printf("%+v\n", stats)
}

func TestReload(t *testing.T) {
	stats := &runtime.MemStats{}
	runtime.ReadMemStats(stats)
	fmt.Printf("%+v\n", stats)

	Init("./", "cn", false)
	csv := GetConfig()
	t.Logf("csv %p", csv)

	_, err := Reload()
	if err != nil {
		t.Fatal(err)
	}

	runtime.GC()
	runtime.Gosched()
	runtime.GC()

	runtime.ReadMemStats(stats)
	fmt.Printf("%+v\n", stats)
}

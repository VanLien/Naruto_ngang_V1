// @Time     : 2020/12/24 16:49
// @Author   : cancan
// @File     : crossmine_test.go
// @Function : 

package mine

import (
	"fmt"
	"testing"
	"tjgame/csv"
)

func Test_config(t *testing.T) {
	if err := csv.Init("./", "cn", false); err != nil {
		panic(err)
	}

	LoadConfig()

	//for version, cfgIDs := range GetConfig().ProductCfgIDSortMap {
	//	for _, cfgIDInfo := range cfgIDs {
	//		fmt.Println(version, cfgIDInfo[0], cfgIDInfo[1])
	//	}
	//}

	//t.Log("------------", getBuildID(3, 3, 0))

	ranges := GetConfig().MatchRanges
	rankMax := 27
	rank := 2
	for i := 0; i < 10; i++ {
		if rr := ranges.GetRange(rank); rr != nil {
			pwrange := rr.(*PWRange)
			enemies := pwrange.getEnemies(rank, RandomEnemiesSize, int(rankMax))
			fmt.Println("--------------", enemies)
		} else {
			fmt.Printf("rank %d can not get range", rank)
		}
	}

	//fmt.Println(max(10, 0))
	//fmt.Println(max(-10, 0))

}

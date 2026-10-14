package fishing

import (
	"fmt"
	"math/rand"
	"sort"
	"testing"
	"time"
	"tjgame/document"
	"tjgame/document/scheme"
	"unsafe"
)

func Test_rank_calc(t *testing.T) {
	testNum := 20000
	roles := make(map[document.ID]*scheme.CrossFishingRoleItem, testNum)

	rand.Seed(time.Now().UnixNano())
	var size, total uintptr
	for i := 0; i < testNum; i++ {
		r := &scheme.CrossFishingRoleItem{
			CrossFishingRoleInfo: scheme.CrossFishingRoleInfo{
				RoleID:  document.ID(fmt.Sprintf("%012d", i)),
				GameKey: "game.cn_qd.100",
				Name:    "是不是很好小智",
				Logo:    1,
				Frame:   10,
				Level:   100,
			},
			Rank:           1,
			Point:          rand.Intn(testNum),
			SpecialFishNum: 10,
		}
		roles[r.RoleID] = r
		tmp := unsafe.Sizeof(r)
		total += tmp
		if tmp > size {
			size = tmp
		}
	}

	fmt.Printf("size max %v total %v \n", size, total)

	s := time.Now()
	ranks := &ranks{
		items: make([]rankItem, 0, testNum),
	}

	for roleID, role := range roles {
		ranks.items = append(ranks.items, rankItem{
			id: roleID,
			items: map[string]int{
				"point": role.Point,
			},
		})
	}
	ranks.keys = [][]string{{"point", "desc"}}
	sort.Sort(ranks)
	for idx, item := range ranks.items {
		rank := idx + 1
		roles[item.id].Rank = rank
	}
	fmt.Printf("roles %d cost %v \n", len(roles), time.Now().Sub(s))
}

func Test_ranks(t *testing.T) {
	ranks := &ranks{
		items: []rankItem{},
	}

	ranks.items = append(ranks.items, rankItem{
		id: "1",
		items: map[string]int{
			"point":     1000,
			"last_time": 1,
		},
	})
	ranks.items = append(ranks.items, rankItem{
		id: "2",
		items: map[string]int{
			"point":     1000,
			"last_time": 2,
		},
	})
	ranks.items = append(ranks.items, rankItem{
		id: "3",
		items: map[string]int{
			"point":     2000,
			"last_time": 1,
		},
	})
	ranks.keys = [][]string{{"point", "desc"}, {"last_time", "asc"}}
	sort.Sort(ranks)

	for _, item := range ranks.items {
		fmt.Println(item.id, item.items["point"], item.items["last_time"])
	}
}


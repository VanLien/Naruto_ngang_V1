/*
 * @Time     : 2019/10/16 10:12
 * @Author   : cancan
 * @File     : model.go
 * @Function :
 */

package clone

import (
	"tjgame/document"
	"tjgame/document/scheme"
	tjcsv "tjgame/server_framework/tj/csv"
	"tjgame/server_framework/tj/util"
)

type RandWeightTmp struct {
	Weights      []util.WeightElement
	ForceWeights []util.WeightElement
}

type RandWeightObj struct {
	Obj      *util.WeightRandom
	ForceObj *util.WeightRandom
	RandNum  int
}

func (r *RandWeightObj) IsEmpty() bool {
	flag1 := true
	flag2 := true
	if r.ForceObj != nil && !r.ForceObj.IsEmpty() {
		flag1 = false
	}
	if r.Obj != nil && !r.Obj.IsEmpty() {
		flag2 = false
	}
	return flag1 && flag2
}

func (r *RandWeightObj) RandOneMonster() int {
	var force util.WeightElement
	if r.ForceObj != nil && !r.ForceObj.IsEmpty() {
		force = r.ForceObj.GetRandomDrop()
	}
	if force != nil {
		return force.(util.WeightInts)[0]
	} else {
		return r.Obj.GetRandomDrop().(util.WeightInts)[0]
	}
}

type ReqRoleJoin struct {
	ID      document.ID             `codec:"id"`
	Name    string                  `codec:"name"`
	Logo    int                     `codec:"logo"`
	Vip     int                     `codec:"vip"`
	Frame   int                     `codec:"frame"`
	Level   int                     `codec:"level"`
	Card    *scheme.CardBattleModel `codec:"card"`
	Card2   *scheme.CardBattleModel `codec:"card2"` // 双属性
	MarkIDs []int                   `codec:"markIDs"`
}

type ReqRoleBattle struct {
	ID     document.ID `codec:"id"`
	Name   string      `codec:"name"`
	Logo   int         `codec:"logo"`
	Level  int         `codec:"level"`
	Frame  int         `codec:"frame"`
	Figure int         `codec:"figure"`
}

type ReqYYObj struct {
	YYID    int   `codec:"yyID"`
	Nature  int   `codec:"nature"`
	Monster []int `codec:"monster"`
}

type RespNatureList struct {
	Nature []scheme.Nature         `codec:"nature"`
	Room   *scheme.CloneRoomObject `codec:"room"`
}

type BattleFix struct {
	AttrFix       map[string]float64
	SkillLevelFix float64
}

type RespBattleEnd struct {
	Box      *BattleAward            `codec:"box"`
	Finished int                     `codec:"finished"`
	Mails    []BattleFinishMail      `codec:"mails"`
	Room     *scheme.CloneRoomObject `codec:"room"`
}

type RespBattleStart struct {
	Room   *scheme.CloneRoomObject `codec:"room"`
	Record *ClonePlayRecord        `codec:"record"`
}

type BattleFinishMail struct {
	RoleDBID document.ID `codec:"role_db_id"`
	Count    int         `codec:"count"`
	Award    tjcsv.Map   `codec:"award"`
}

type BattleAward struct {
	FragID  int   `codec:"fragID"`
	FragNum int   `codec:"fragNum"`
	DropLib []int `codec:"dropLib"`
}

type ClonePlayRecord struct {
	ID                document.ID                             `codec:"id"`
	Date              int                                     `codec:"date"`
	Time              float64                                 `codec:"time"`
	RandSeed          int32                                   `codec:"rand_seed"`
	RoleDbId          document.ID                             `codec:"role_db_id"`
	RecordDbId        document.ID                             `codec:"record_db_id"`
	Name              string                                  `codec:"name"`
	Logo              int                                     `codec:"logo"`
	Level             int                                     `codec:"level"`
	Frame             int                                     `codec:"frame"`
	Figure            int                                     `codec:"figure"`
	Cards             []document.ID                           `codec:"cards"`
	CardAttrs         map[document.ID]*scheme.CardBattleModel `codec:"card_attrs"`
	CardAttrs2        map[document.ID]*scheme.CardBattleModel `codec:"card_attrs2"`
	DefenceRoleDbId   document.ID                             `codec:"defence_role_db_id"`
	DefenceRecordId   document.ID                             `codec:"defence_record_id"`
	DefenceName       string                                  `codec:"defence_name"`
	DefenceLogo       int                                     `codec:"defence_logo"`
	DefenceLevel      int                                     `codec:"defence_level"`
	DefenceFrame      int                                     `codec:"defence_frame"`
	DefenceFigure     int                                     `codec:"defence_figure"`
	DefenceCards      []document.ID                           `codec:"defence_cards"`
	DefenceCardAttrs  map[document.ID]*scheme.CardBattleModel `codec:"defence_card_attrs"`
	DefenceCardAttrs2 map[document.ID]*scheme.CardBattleModel `codec:"defence_card_attrs2"`
	Result            string                                  `codec:"result"`
}

type NatureRobot struct {
	LevelFix float64
	AttrFix  map[string]float64
	CardIDs  []int
}

type RespVoteRoom struct {
	Room      *scheme.CloneRoomObject `codec:"room"`
	First     bool                    `codec:"first"`
	OldLeader document.ID             `codec:"oldLeader"`
	Result    string                  `codec:"result"`
}

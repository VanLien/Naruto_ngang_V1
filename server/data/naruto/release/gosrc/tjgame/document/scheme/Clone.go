package scheme

import "tjgame/document"

// 元素挑战玩法全局变量
type CloneGlobal struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key" unique:"true"`
	// 元素挑战元素列表
	CloneNatures []Nature `bson:"clone_natures" codec:"clone_natures"`
	// 元素挑战随机CD记录
	CloneCDRecord CloneCDRecord `bson:"clone_cd_record" codec:"clone_cd_record"`
	// 元素挑战活动元素
	CloneYYNature *CloneYYNature `bson:"clone_yy_nature" codec:"clone_yy_nature"`
}

// 元素列表
type Nature struct {
	_struct struct{} `codec:",toarray"`

	Nature  int   `bson:"nature" codec:"nature"`
	Monster []int `bson:"monster" codec:"monster"`
}

// 精灵 CD 记录
type CloneCDRecord struct {
	Nature  map[document.Integer]int `bson:"nature" codec:"nature"`
	Monster map[document.Integer]int `bson:"monster" codec:"monster"`
}

// 活动元素精灵信息
type CloneYYNature struct {
	YYID    int   `bson:"yy_id" codec:"yy_id"`
	Nature  int   `bson:"nature" codec:"nature"`
	Monster []int `bson:"monster" codec:"monster"`
}

func (*CloneGlobal) CollectionName() string {
	return "CloneGlobal"
}

// 元素挑战玩法房间
type CloneRoom struct {
	document.DocumentID `bson:",inline"`

	// 日期, 12点刷新
	Date int `bson:"date" codec:"date"`
	// 元素ID
	NatureID int `bson:"nature_id" codec:"nature_id"`
	// 房间位置, idx从1开始
	Places map[document.Integer]*CloneRoomPlace `bson:"places" codec:"places"`
	// 队长的Role.id
	Leader document.ID `bson:"leader" codec:"leader"`
	// 是否允许快速加入
	Fast bool `bson:"fast" codec:"fast" default:"True"`
	// 是否已废弃
	Discard bool `bson:"discard" codec:"discard" index:"true"`
	// 目标精灵
	Monsters []int `bson:"monsters" codec:"monsters"`
	// 完成人数
	FinishNum int `bson:"finish_num" codec:"finish_num"`
	// 创建时间
	CreateTime int `bson:"create_time" codec:"create_time"`
	// 投票结果
	VoteRound string `bson:"vote_round" codec:"vote_round"`
	// 房间记录
	History []CloneHistory `bson:"history" codec:"history"`
}

func (*CloneRoom) CollectionName() string {
	return "CloneRoom"
}

// 元素挑战位置信息
type CloneRoomPlace struct {
	ID           document.ID      `bson:"id" codec:"id"`
	Play         int              `bson:"play" codec:"play"`
	Name         string           `bson:"name" codec:"name"`
	Logo         int              `bson:"logo" codec:"logo"`
	Vip          int              `bson:"vip" codec:"vip"`
	Frame        int              `bson:"frame" codec:"frame"`
	Level        int              `bson:"level" codec:"level"`
	Monster      int              `bson:"Monster" codec:"monster"`
	Card         *CardBattleModel `bson:"card" codec:"card"`
	Card2        *CardBattleModel `bson:"card2" codec:"card2"` // 双属性
	CanQuit      bool             `bson:"can_quit" codec:"can_quit"`
	BattleDeploy []document.ID    `bson:"battle_deploy" codec:"battle_deploy"`
	NeedRobot    bool             `bson:"need_robot" codec:"need_robot"`
	Time         int              `bson:"time" codec:"time"`
	KickLeader   int              `bson:"kick_leader" codec:"kick_leader"`
}

type CloneHistory struct {
	Type int    `bson:"type" codec:"type"`
	Time int    `bson:"time" codec:"time"`
	Name string `bson:"name" codec:"name"`
}

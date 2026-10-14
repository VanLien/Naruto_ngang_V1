// @Time     : 2019/5/16 17:14
// @Author   : cancan
// @File     : model.go
// @Function :

package society

import (
	"tjgame/document"
	"tjgame/document/scheme"
)

// 好友展示的角色信息
type RoleInfo struct {
	Id                  document.ID                            `codec:"id"`                    // role 数据库ID
	Uid                 int                                    `codec:"uid"`                   // 用于方面查找Role，单服唯一
	Name                string                                 `codec:"name"`                  // 角色名字
	LastTime            float64                                `codec:"last_time"`             // 上次操作时间
	Logo                int                                    `codec:"logo"`                  // 角色头像ID
	Frame               int                                    `codec:"frame"`                 // 角色头像框ID
	Level               int                                    `codec:"level"`                 // 主角等级
	VipLevel            int                                    `codec:"vip_level"`             // 当前玩家VIP等级
	PvpRecordDbId       document.ID                            `codec:"pvp_record_db_id"`      // pvp竞技场数据 PVPRecord.id
	SocietyDbId         document.ID                            `codec:"society_db_id"`         // 社交数据 Society.id
	BattleFightingPoint int                                    `codec:"battle_fighting_point"` // 卡牌战斗力
	TalentTrees         map[document.Integer]scheme.TalentTree `codec:"talent_trees" `         // {treeID:{cost:talent_point, talnet: {talentID:level}}}
	PersonalSign        string                                 `codec:"personal_sign"`         // 个性签名
}

// 接受请求的返回数据结构
type AcceptResp struct {
	Friends    []document.ID `codec:"friends"`
	FriendReqs []document.ID `codec:"friend_reqs"`
}

// 送体力返回结构
type StaminaSendResp struct {
	FriendStaminaRecv map[document.ID][]document.ID `codec:"friendStaminaRecv"`
	DailySend         []document.ID                 `codec:"dailySend"`
	Send              int                           `codec:"send"`
}

// 收体力返回结构
type StaminaRecvResp struct {
	StaminaRecv []document.ID `codec:"staminaRecv"`
	DailyGain   int           `codec:"dailyGain"`
	Recv        int           `codec:"recv"`
}

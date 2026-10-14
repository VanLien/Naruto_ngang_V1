/*
 * @Time     : 2019/11/13 15:56
 * @Author   : cancan
 * @File     : Capture.go
 * @Function :
 */

package scheme

import "tjgame/document"

// 捕捉
type Capture struct {
	document.DocumentID `bson:",inline"`

	// Role.id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// 捕捉等级
	Level int `bson:"level" codec:"level"`
	// 当前累计的捕捉经验
	Exp int `bson:"exp" codec:"exp"`
	// 当前等级下累计的经验
	LevelExp int `bson:"level_exp" codec:"level_exp"`
	// 累计成功捕捉次数
	SuccessSum int `bson:"success_sum" codec:"success_sum"`
	// 关卡捕捉精灵
	GateSprites map[document.Integer]int `bson:"gate_sprites" codec:"gate_sprites"`
	// 关卡捕捉精灵权值
	GateSpritesWeight map[document.Integer]int `bson:"gate_sprites_weight" codec:"gate_sprites_weight"`
	// 限时捕捉精灵
	LimitSprites []*CaptureLimit `bson:"limit_sprites" codec:"limit_sprites"`
	// cd 记录
	CDRecord map[document.Integer]int `bson:"cd_record" codec:"cd_record"`
	// 累计触发次数
	ActiveSum int `bson:"active_sum" codec:"active_sum"`
}

func (*Capture) CollectionName() string {
	return "Capture"
}

type CaptureLimit struct {
	// /capture/sprite.csv id
	CsvID int `bson:"csv_id" codec:"csv_id"`
	// 发现时间
	FindTime int `bson:"find_time" codec:"find_time"`
	// 总的
	TotalTimes int `bson:"total_times" codec:"total_times"`
	// 捕捉结果 1 可捕捉 0 不可捕捉
	State int `bson:"state" codec:"state"`
	// 权值
	Weight int `bson:"weight" codec:"weight"`
}

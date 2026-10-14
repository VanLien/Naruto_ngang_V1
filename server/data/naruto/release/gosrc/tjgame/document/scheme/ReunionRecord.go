package scheme

import "tjgame/document"

// 重聚活动记录
type ReunionRecord struct {
	document.DocumentID `bson:",inline"`

	// 回归玩家role id
	RoleDbId document.ID `bson:"role_db_id" codec:"role_db_id" index:"true"`
	// 绑定历史信息
	BindHistory []document.ID `bson:"bind_history" codec:"bind_history"`
	// 绑定玩家db id
	BindRoleDbId document.ID `bson:"bind_role_db_id" codec:"bind_role_db_id"`
	// 绑定积分
	BindPoint int `bson:"bind_point" codec:"bind_point"`
	// 全目标记录
	Targets map[string]int `bson:"targets" codec:"targets"`
	// 最后上线日期
	LastDate int `bson:"last_date" codec:"last_date"`
	// 累计登录天数
	LoginDays int `bson:"login_days" codec:"login_days"`
	// 协作任务领取状态
	Stamps map[document.Integer]int `bson:"stamps" codec:"stamps"`
	// 通用任务
	Valsums map[document.Integer][2]int `bson:"valsums" codec:"valsums"`
	// 额外信息
	Valinfo map[document.Integer]map[string]int `bson:"valinfo" codec:"valinfo"`
	// 重聚活动csvID
	YYID int `bson:"yyID" codec:"yyID"`
	// 绑定结束时间
	EndTime float64 `bson:"end_time" codec:"end_time"`
}

func (*ReunionRecord) CollectionName() string {
	return "ReunionRecord"
}

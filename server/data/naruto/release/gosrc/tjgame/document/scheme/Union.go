package scheme

import "tjgame/document"

// 公会
type Union struct {
	document.DocumentID `bson:",inline"`

	// 用于方面查找Union，单服唯一
	UID int `bson:"uid" codec:"uid" unique:"true"`
	// 区服
	Area int `bson:"area" codec:"area"`
	// 公会名称
	Name string `bson:"name" codec:"name" unique:"true"`
	// 公会头像ID
	Logo int `bson:"logo" codec:"logo" default:"1"`
	// 公会创建时间
	CreatedTime float64 `bson:"created_time" codec:"created_time" default:"nowtime_t"`
	// 公会等级
	Level int `bson:"level" codec:"level" index:"true" default:"1"`
	// 公会总贡献值
	Contrib int `bson:"contrib" codec:"contrib" index:"true"`
	// 公会当日贡献值计数
	DayContrib int `bson:"day_contrib" codec:"day_contrib"`
	// 公会每周任务贡献值计数
	WeekTaskContrib int `bson:"week_task_contrib" codec:"week_task_contrib"`
	// 结算日期时间
	LastDate int `bson:"last_date" codec:"last_date" default:"todayinclock5date2int"`
	// 公会简介
	Intro string `bson:"intro" codec:"intro"`
	// 0 审批加入 1 直接加入 2 拒绝加入
	JoinType int `bson:"join_type" codec:"join_type"`
	// 申请加入公会的角色等级限制
	JoinLevel int `bson:"join_level" codec:"join_level"`
	// 招募说明
	JoinDesc string `bson:"join_desc" codec:"join_desc"`
	// 公会会长 Role.id
	ChairmanDbId document.ID `bson:"chairman_db_id" codec:"chairman_db_id" unique:"true"`
	// 公会副会长 [Role.id, ...]
	ViceChairmans []document.ID `bson:"vice_chairmans" codec:"vice_chairmans"`
	// 公会成员 {Role.id: {id:Role.id, lg:Role.logo, n:Role.name, lvl:Role.level, fp:战力, lt:上次登录时间, rps:发送红包消费钻石, rpsc:发送红包总个数, rpr:抢红包得到钻石, rprc:抢红包总个数}, ...}
	Members map[document.ID]*UnionMember `bson:"members" codec:"members"`
	// 加入公会申请 {id: {t:申请时间, id:Role.id, lg:Role.logo, n:Role.name, lvl:Role.level, fp:战力}, ...}
	JoinNotes []*UnionJoinNote `bson:"join_notes" codec:"join_notes"`
	// 公会历史（最多100条） [{t:时间, tp:类型, r:参数, c:参数}, ...]
	History []UnionHistory `bson:"history" codec:"history"`
	// 捐献任务 {csvid: (count, flag)}
	ContribTasks map[document.Integer][]int `bson:"contrib_tasks" codec:"contrib_tasks"`
	// 每日公会招募邀请次数
	JoinupInviteTimes int `bson:"joinup_invite_times" codec:"joinup_invite_times"`
	// 每日公会邮件发送次数
	SendMailTimes int `bson:"send_mail_times" codec:"send_mail_times"`
	// 公会邮件邮件缩略数据 [{db_id:Mail.id, subject:Mail.subject, time:Mail.time, type=Mail.type, mtype=邮件类型, sender:Mail.sender}, ...]
	Mails []UnionMailThumb `bson:"mails" codec:"mails"`
	// 公会碎片赠与
	FragDonate map[document.ID]*UnionFragmentDonate `bson:"frag_donate" codec:"frag_donate"`
}

func (*Union) CollectionName() string {
	return "Union"
}

type UnionMemberRole struct {
	ID            document.ID `bson:"id" codec:"id"`
	Name          string      `bson:"name" codec:"name"`
	Logo          int         `bson:"logo" codec:"logo"`
	Level         int         `bson:"level" codec:"level"`
	Vip           int         `bson:"vip" codec:"vip"`
	FightingPoint int         `bson:"fighting_point" codec:"fighting_point"`
	Frame         int         `bson:"frame" codec:"frame"`
}

type UnionMember struct {
	UnionMemberRole `bson:",inline"`
	Contrib         int     `bson:"contrib" codec:"contrib"`
	FubenTimes      int     `bson:"fuben_times" codec:"fuben_times"`
	LastTime        float64 `bson:"lasttime" codec:"lasttime"`
}

type UnionJoinNote struct {
	UnionMemberRole `bson:",inline"`
	Time            float64 `bson:"time" codec:"time"`
	LastTime        float64 `bson:"lasttime" codec:"lasttime"`
}

type UnionHistory struct {
	Type  int     `bson:"type" codec:"type"`
	Time  float64 `bson:"time" codec:"time"`
	Name1 string  `bson:"name1" codec:"name1"`
	Name2 string  `bson:"name2" codec:"name2"`
}

type UnionMailThumb struct {
	MailThumb `bson:",inline"`
	Mtype     int `bson:"mtype" codec:"mtype"`
}

type UnionFragmentDonate struct {
	FragID   int           `bson:"frag_id" codec:"frag_id"`
	Current  int           `bson:"current" codec:"current"`
	TotalMax int           `bson:"totalmax" codec:"totalmax"`
	History  []document.ID `bson:"history" codec:"history"`
}

type UnionFuben struct {
	document.DocumentID `bson:",inline"`

	// Union.id
	UnionDbId document.ID `bson:"union_db_id" codec:"union_db_id"`
	// 重置月份
	Month int `bson:"month" codec:"month" default:"todaymonth2int"`
	// 奖励日期 21:30
	AwardDate int `bson:"award_date" codec:"award_date" default:"todaydate2int"`
	//重置日期 5:00
	ResetDate int `bson:"reset_date" codec:"reset_date" default:"todaydate2int"`
	// 战斗进度状态
	States map[document.Integer]*UnionFubenState `bson:"states" codec:"states"`
}

func (*UnionFuben) CollectionName() string {
	return "UnionFuben"
}

type UnionFubenState struct {
	// 伤害值
	Damage int `bson:"damage" codec:"damage"`
	//  通关时间
	Time int64 `bson:"time" codec:"time"`
	// 总血量
	HPMax int `bson:"hpmax" codec:"hpmax"`
	// 周期内奖励是否已发送
	Award bool `bson:"award" codec:"award"`
	// 未通关次数
	Fail int `bson:"fail" codec:"fail"`
	// {Role.id: 伤害值}
	Members map[document.ID]int `bson:"members" codec:"members"`
	// 加成百分比
	Buff int `bson:"buff" codec:"buff"`
	// 首次通关时间(当月)
	FirstTime int64 `bson:"first_time" codec:"first_time"`
}

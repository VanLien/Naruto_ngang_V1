package match

type Config struct {
	CrossFishingConfig CrossFishingConfig

	HuodongBossGroupSize int // 活动boss跨服分组大小
	HuodongBossReserve   int // 活动boss跨服分组保留数量，会被平分为2组

	CrossUnionQAGroupSize    int // 公会问答跨服分组大小
	CrossUnionQAServOpenDays int // 公会问答跨服相对开服天数限制

	CrossRedPacketGroupSize      int // 跨服红包分组区服数量
	SkyscraperGroupSize          int // 跨服摩天大楼分组区服数量
	CrossBraveChallengeGroupSize int // 勇者挑战
	CrossHorseRaceGroupSize      int // 赛马
	CrossVolleyballGroupSize     int // 沙滩排球
	CrossShavediceGroupSize      int // 夏日刨冰
}

type CrossFishingConfig struct {
	servOpenDays int
	GroupSize    int
}

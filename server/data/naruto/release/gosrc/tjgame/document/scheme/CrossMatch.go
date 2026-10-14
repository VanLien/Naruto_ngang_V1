package scheme

import "tjgame/document"

type CrossMatch struct {
	document.DocumentID `bson:",inline"`

	// servkey
	Key string `bson:"key" codec:"key" unique:"true"`
	// 最后一次匹配钓鱼大赛的日期
	CrossFishingLastDate map[string]int `bson:"cross_fishing_last_date" codec:"cross_fishing_last_date"`
	// 匹配结果
	CrossFishingMatches map[string]map[document.Integer][]string `bson:"cross_fishing_matches" codec:"cross_fishing_matches"`
	// 最后一次匹配活动Boss日期
	HuoDongBossLastDate map[string]int `bson:"huodongboss_last_date" codec:"huodongboss_last_date"`
	// 活动Boss匹配结果
	HuoDongBossMatches map[string]map[document.Integer][]string `bson:"huodongboss_matches" codec:"huodongboss_matches"`
	// 最后一次匹配活动Boss日期
	CrossUnionQALastDate map[string]int `bson:"cross_union_qa_last_date" codec:"cross_union_qa_last_date"`
	// 活动Boss匹配结果
	CrossUnionQAMatches map[string]map[document.Integer][]string `bson:"cross_union_qa_matches" codec:"cross_union_qa_matches"`
	// 最后一次匹配跨服红包活动日期
	CrossRedPacketLastDate map[string]int `bson:"cross_redpacket_last_date" codec:"cross_redpacket_last_date"`
	// 跨服红包活动匹配结果
	CrossRedPacketMatches map[string]map[document.Integer][]string `bson:"cross_redpacket_matches" codec:"cross_redpacket_matches"`
	// 最后一次匹配摩天大楼活动日期
	SkyscraperLastDate map[string]int `bson:"cross_skyscraper_last_date" codec:"cross_skyscraper_last_date"`
	// 摩天大楼活动匹配结果
	SkyscraperMatches map[string]map[document.Integer][]string `bson:"cross_skyscraper_matches" codec:"cross_skyscraper_matches"`
	// 各种玩法的排行榜最后一次匹配日期
	PlayRankingsLastDate map[string]map[string]int `bson:"play_rankings_last_date" codec:"play_rankings_last_date"`
}

func (*CrossMatch) CollectionName() string {
	return "CrossMatch"
}

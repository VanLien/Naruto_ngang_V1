package storage

import (
	"errors"
	"tjgame/document"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"

	mgo "tjgame/mgo.v2"

	"tjgame/mgo.v2/bson"
)

var (
	ErrCompoundScoreLackScore = errors.New("compound score lack source")
)

type spec struct {
	name       string
	collection string
	score      string // score field
	fields     []string
	compound   bool // if true will use CompoundScoreField

	selector map[string]int // selector for fields
	keys     []string       // Index key fields; prefix name with dash (-) for descending order
}

func TimestampField(name string) string {
	return name + "_t"
}

func CompoundScoreField(name string) string {
	return name + "_s"
}

// if compound is true, ignore score parameter, use CompoundScoreField as score field
func newspec(collection string, name string, fields []string, score string, compound bool) *spec {
	s := &spec{
		name:       name,
		collection: collection,
		score:      score,
		fields:     fields,
		compound:   compound,
	}
	if compound {
		s.score = CompoundScoreField(name)
	}

	s.selector = make(map[string]int, len(s.fields))
	for _, field := range s.fields {
		s.selector[field] = 1
	}

	s.keys = []string{"-" + s.score, TimestampField(s.name), "_id"} // score, timestamp and _id
	return s
}

func initRankSpec(name string, collection string, fields []string, score string, compound bool) {
	specs[name] = newspec(collection, name, fields, score, compound)
}

var specs map[string]*spec

const (
	RankRoleCollectionName = "RankRole"
	//RankCardCollectionName = "RankCard"
)

func init() {
	specs = make(map[string]*spec)

	// 历史top6最高战力
	initRankSpec("Rank_fight", RankRoleCollectionName, []string{"role", "fighting_point", "top6_cards"}, "fighting_point", false)
	// 关卡总星数
	initRankSpec("Rank_star", RankRoleCollectionName, []string{"role", "star"}, "star", false)
	// 图鉴收集率
	initRankSpec("Rank_pokedex", RankRoleCollectionName, []string{"role", "pokedex"}, "pokedex", false)
	// 无尽之塔
	initRankSpec("Rank_endless", RankRoleCollectionName, []string{"role", "endless", "fighting_point"}, "endless", false)
	// 王者之战
	initRankSpec("Rank_craft", RankRoleCollectionName, []string{"role", "craft"}, "", true)
	// 试炼塔
	initRankSpec("Rank_random_tower", RankRoleCollectionName, []string{"role", "random_tower"}, "", true)
	// 限时神兽  合服后带gameKey,排名也要按照原始服排名
	initRankSpec("Rank_yybox", RankRoleCollectionName, []string{"role", "box_point", "game_key"}, "box_point", false)
	// 成就
	initRankSpec("Rank_achievement", RankRoleCollectionName, []string{"role", "achievement"}, "achievement", false)
	// 扔雪球
	initRankSpec("Rank_snowball", RankRoleCollectionName, []string{"role", "snowball"}, "", true)

	// 单卡牌战力
	//initRankSpec("Rank_card1fight", RankCardCollectionName, []string{"role_db_id", "card_id", "advance", "star", "level", "develop", "fighting_point"}, "fighting_point", false)
}

func RankensureIndex(s *Storage) {
	err := s.exec(RankRoleCollectionName, func(collection *mgo.Collection) error {
		return collection.EnsureIndex(mgo.Index{Key: []string{"game_key"}, Name: "game_key"})
	})
	if err != nil {
		log.Warningf("%s EnsureIndex game_key error: %v", RankRoleCollectionName, err)
	}

	for name, spec := range specs {
		f := func() error {
			return s.exec(spec.collection, func(collection *mgo.Collection) error {
				return collection.EnsureIndex(mgo.Index{
					Key:  spec.keys,
					Name: name,
				})
			})
		}

		err := f()
		if err != nil {
			log.Warningf("%v", err)
			log.Infof("%s EnsureIndex %s error, drop old index", spec.collection, name)
			err = s.exec(spec.collection, func(collection *mgo.Collection) error {
				return collection.DropIndexName(name)
			})
			if err == nil {
				err = f()
			}
		}
		if err != nil {
			log.Warningf("%s EnsureIndex %s error: %v", spec.collection, name, err)
		}
	}
}

type Role struct {
	ID       ID     `bson:"id" codec:"id"`
	Logo     int    `bson:"logo" codec:"logo"`
	Frame    int    `bson:"frame" codec:"frame"`
	Title    int    `bson:"title" codec:"title"`
	Name     string `bson:"name" codec:"name"`
	Level    int    `bson:"level" codec:"level"`
	VipLevel int    `bson:"vip_level" codec:"vip_level"`
}

// 角色排行榜信息
type RoleElement struct {
	ID document.ID `bson:"_id,omitempty" codec:"id,omitempty"` // Role.id

	Role    *Role  `bson:"role,omitempty" codec:"role,omitempty"`
	GameKey string `bson:"game_key,omitempty" codec:"game_key,omitempty"`

	// 战力排行
	FightingPoint int `bson:"fighting_point,omitempty" codec:"fighting_point,omitempty"`
	Top6Cards     []struct {
		CardID int `bson:"card_id" codec:"card_id"`
		SkinID int `bson:"skin_id" codec:"skin_id"`
		Level  int `bson:"level" codec:"level"`
	} `bson:"top6_cards,omitempty" codec:"top6_cards,omitempty"`

	// 关卡总星数排行
	Star int `bson:"star,omitempty" codec:"star,omitempty"`

	// 收藏率排行
	Pokedex int `bson:"pokedex,omitempty" codec:"pokedex,omitempty"`

	// 无尽之塔排行
	EndLess int `bson:"endless,omitempty" codec:"endless,omitempty"`

	// 王者排行
	Craft *struct {
		Round int `bson:"round" codec:"round"`
		Win   int `bson:"win" codec:"win"`
		Point int `bson:"point" codec:"point"`
	} `bson:"craft,omitempty" codec:"craft,omitempty"`

	// 试炼塔排行
	RandomTower *struct {
		DayPoint int `bson:"day_point" codec:"day_point"`
		Room     int `bson:"room" codec:"room"`
	} `bson:"random_tower,omitempty" codec:"random_tower,omitempty"`

	// 限时神兽
	BoxPoint int `bson:"box_point,omitempty" codec:"box_point,omitempty"`

	// 成就排行
	Achievement int `bson:"achievement,omitempty" codec:"achievement,omitempty"`

	// 雪球
	SnowBall *struct {
		Point int `bson:"point" codec:"point"`
		Time  int `bson:"time" codec:"time"`
		Role  int `bson:"role" codec:"role"`
	} `bson:"snowball,omitempty" codec:"snowball,omitempty"`

	Inline map[string]int64 `bson:",inline" codec:"-"`
}

func (e *RoleElement) CalcCompoundScore(name string) error {
	if name == "Rank_craft" {
		if e.Craft == nil {
			return ErrCompoundScoreLackScore
		}
		if e.Craft.Point >= 1000000 {
			e.Craft.Point = 1000000 - 1
		}
		score := e.Craft.Round*100000000 + e.Craft.Win*1000000 + e.Craft.Point
		e.Inline[CompoundScoreField(name)] = int64(score)
	} else if name == "Rank_random_tower" {
		if e.RandomTower == nil {
			return ErrCompoundScoreLackScore
		}
		score := e.RandomTower.DayPoint*1000 + e.RandomTower.Room
		e.Inline[CompoundScoreField(name)] = int64(score)
	} else if name == "Rank_snowball" {
		if e.SnowBall == nil {
			return ErrCompoundScoreLackScore
		}
		score := e.SnowBall.Point*1000 + e.SnowBall.Time
		e.Inline[CompoundScoreField(name)] = int64(score)
	}

	return nil
}

func (e *RoleElement) Complete(id document.ID, name string) error {
	e.ID = id
	e.Inline = map[string]int64{TimestampField(name): util.Now().Unix()}
	err := e.CalcCompoundScore(name)
	return err
}

func (e *RoleElement) Score(name string) int {
	if specs[name].compound {
		return int(e.Inline[CompoundScoreField(name)])
	}
	switch name {
	case "Rank_fight":
		return e.FightingPoint
	case "Rank_star":
		return e.Star
	case "Rank_pokedex":
		return e.Pokedex
	case "Rank_endless":
		return e.EndLess
	case "Rank_yybox":
		return e.BoxPoint
	case "Rank_achievement":
		return e.Achievement
	default:
		return 0
	}
}

// 排行榜卡牌信息
type CardElement struct {
	ID document.ID `bson:"_id,omitempty" codec:"id,omitempty"` // RoleCard.id

	RoleDBID      ID  `bson:"role_db_id" codec:"role_db_id"`
	CardID        int `bson:"card_id" codec:"card_id"`
	Advance       int `bson:"advance" codec:"advance"`
	Star          int `bson:"star" codec:"star"`
	Level         int `bson:"level" codec:"level"`
	Develop       int `bson:"develop" codec:"develop"`
	FightingPoint int `bson:"fighting_point" codec:"fighting_point"`

	Inline map[string]int64 `bson:",inline" codec:"-"`
}

func (e *CardElement) Complete(id document.ID, name string) error {
	e.ID = id
	e.Inline = map[string]int64{TimestampField(name): util.Now().Unix()}
	return nil
}

func (e *CardElement) Score(name string) int {
	return e.FightingPoint
}

func newRankQueryResult(name string, cap int) interface{} {
	if cap == 0 {
		cap = 16
	}
	if name == RankRoleCollectionName {
		result := make([]RoleElement, 0, cap)
		return &result
	} else {
		result := make([]CardElement, 0, cap)
		return &result
	}
}

func RankQuery(s *Storage, name string, id ID, tied bool, gameKey string) (rank int, element interface{}, err error) {
	// TODO: 未处理卡牌排行榜的
	spec := specs[name]
	s.exec(spec.collection, func(collection *mgo.Collection) error {
		timekey := TimestampField(name)
		result := &RoleElement{}
		selector := bson.M{}
		for _, key := range spec.fields {
			if key != "role" {
				selector[key] = 1
			}
		}
		selector["_id"] = 0
		selector[timekey] = 1
		if spec.compound {
			selector[CompoundScoreField(name)] = 1
		}
		err = collection.FindId(id).Select(selector).One(result)
		if err != nil {
			return err
		}
		score := result.Score(name)
		if score == 0 { // not in rank
			return nil
		}
		var query bson.M
		if gameKey != "" {
			query = bson.M{spec.score: bson.M{"$gt": score}, "game_key": gameKey}
		} else {
			query = bson.M{spec.score: bson.M{"$gt": score}}
		}

		if !tied {
			timestamp := result.Inline[timekey]
			query2 := bson.M{"$and": []bson.M{{spec.score: bson.M{"$eq": score}}, {timekey: bson.M{"$lt": timestamp}}}}
			if gameKey != "" {
				query2 = bson.M{"$and": []bson.M{{"game_key": gameKey}, {spec.score: bson.M{"$eq": score}}, {timekey: bson.M{"$lt": timestamp}}}}
			}
			query3 := bson.M{"$and": []bson.M{{spec.score: bson.M{"$eq": score}}, {timekey: bson.M{"$eq": timestamp}}, {"_id": bson.M{"$lt": id}}}}
			if gameKey != "" {
				query3 = bson.M{"$and": []bson.M{{"game_key": gameKey}, {spec.score: bson.M{"$eq": score}}, {timekey: bson.M{"$eq": timestamp}}, {"_id": bson.M{"$lt": id}}}}
			}
			query = bson.M{"$or": []bson.M{query, query2, query3}}
		}
		rank, err = collection.Find(query).Count()
		if err == nil {
			rank += 1
			element = result
		}
		return err
	})
	return
}

func RankRangeQuery(s *Storage, name string, start, end int, gameKey string) (interface{}, error) {
	start = start - 1
	size := end - start
	spec := specs[name]
	result := newRankQueryResult(spec.collection, size)

	var query bson.M
	if gameKey != "" {
		query = bson.M{spec.score: bson.M{"$gt": 0}, "game_key": gameKey}
	} else {
		query = bson.M{spec.score: bson.M{"$gt": 0}}
	}

	err := s.exec(spec.collection, func(collection *mgo.Collection) error {
		return collection.Find(query).Select(spec.selector).Sort(spec.keys...).Skip(start).Limit(size).All(result)
	})
	if err != nil {
		return nil, err
	}
	return result, nil
}

func RankSummaryRangeQuery(s *Storage, name string, start, end int, gameKey string) (interface{}, error) {
	start = start - 1
	size := end - start
	spec := specs[name]
	result := make([]bson.M, 0, size)

	var query bson.M
	if gameKey != "" {
		query = bson.M{spec.score: bson.M{"$gt": 0}, "game_key": gameKey}
	} else {
		query = bson.M{spec.score: bson.M{"$gt": 0}}
	}
	err := s.exec(spec.collection, func(collection *mgo.Collection) error {
		return collection.Find(query).Select(bson.M{spec.score: 1}).Sort(spec.keys...).Skip(start).Limit(size).All(&result)
	})
	if err != nil {
		return nil, err
	}
	response := make([][2]interface{}, 0, size)
	for _, m := range result {
		response = append(response, [2]interface{}{m["_id"], m[spec.score]})
	}
	return response, nil
}

func RankRangeByScoreQuery(s *Storage, name string, max, min int) (interface{}, error) {
	spec := specs[name]
	result := newRankQueryResult(spec.collection, 0)
	err := s.exec(spec.collection, func(collection *mgo.Collection) error {
		return collection.Find(bson.M{spec.score: bson.M{"$gte": min, "$lte": max}}).Select(spec.selector).Sort(spec.keys...).All(result)
	})
	if err != nil {
		return nil, err
	}
	return result, nil
}

func RankAdd(s *Storage, name string, id ID, element interface{}) error {
	spec := specs[name]
	return s.exec(spec.collection, func(collection *mgo.Collection) error {
		_, err := collection.UpsertId(id, bson.M{"$set": element})
		return err
	})
}

func RankDrop(s *Storage, name string) error {
	spec := specs[name]
	keys := bson.M{}
	for _, field := range spec.fields {
		if field == "role" {
			continue
		}
		keys[field] = 1
	}
	if spec.compound {
		keys[CompoundScoreField(name)] = 1
	}
	query := bson.M{spec.score: bson.M{"$gte": 0}}
	return s.exec(spec.collection, func(collection *mgo.Collection) error {
		_, err := collection.UpdateAll(query, bson.M{"$unset": keys})
		return err
	})
}

func RankClearRole(s *Storage, id ID, names []string) error {
	for _, name := range names {
		spec := specs[name]
		err := s.exec(spec.collection, func(collection *mgo.Collection) error {
			return collection.UpdateId(id, bson.M{"$set": bson.M{spec.score: 0}})
		})
		if err != nil && err != mgo.ErrNotFound {
			log.Warningf("clear role %v rank %s error, %v", id, name, err)
		}
	}
	return nil
}

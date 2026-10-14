package anti_cheat

import "tjgame/document"

type CraftBattleResult struct {
	_struct struct{} `codec:",toarray"`

	Result string
	Point1 int
	Point2 int
}

type UnionFightBattleResult struct {
	_struct struct{} `codec:",toarray"`

	Result string
	States map[document.ID][2]float64
}

type CrossMineBossResult struct {
	_struct struct{} `codec:",toarray"`

	Result  string
	Damages map[document.Integer]int
}

type CrossUnionFightBattleResult struct {
	_struct struct{} `codec:",toarray"`

	Result string
	States map[document.ID][2]float64
}

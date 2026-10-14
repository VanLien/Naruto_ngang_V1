package card_score

import (
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/util"
)

type CardScoreRole struct {
	*scheme.CardScoreRoleObject
}

func (r *CardScoreRole) getScore(markID int) int {
	db, unlock := r.RLockAndGetDB()
	defer unlock()
	return db.CardScore[document.Integer(markID)]
}

func (r *CardScoreRole) setScore(markID int, score int) {
	db, unlcok := r.LockAndGetDB()
	defer unlcok()
	db.CardScore[document.Integer(markID)] = score
	db.LastTime = int(util.NowTime())
	r.SetCardScore(db.CardScore)
	r.SetLastTime(db.LastTime)
}

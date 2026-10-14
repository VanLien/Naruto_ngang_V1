package union_fight

import "tjgame/document/scheme"

// UnionFightRecord
type UnionRecord struct {
	*scheme.UnionFightUnionRecordObject
}

func (u *UnionRecord) updateUnion(union unionCompetitor) {
	db, unlock := u.LockAndGetDB()
	defer unlock()

	db.UnionName = union.Name
	db.UnionLogo = union.Logo
	db.UnionLevel = union.Level
	u.SetDirty("union_name", "union_logo", "union_level")
}

func (u *UnionRecord) pushUnionRoundResult(round string, roundResult scheme.UnionFightResultInfo) {
	u.Lock()
	defer u.Unlock()

	roundResults := u.RoundResults()
	roundResults[round] = append(roundResults[round], roundResult)
	u.SetRoundResults(roundResults)
}

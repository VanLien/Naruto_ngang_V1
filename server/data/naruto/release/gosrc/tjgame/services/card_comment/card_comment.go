package card_comment

import (
	"tjgame/document/scheme"
)

type CardComment struct {
	*scheme.CardCommentObject
}

func (cc *CardComment) updateLikeAndDislike(changeLike, changeDislike int) {
	db, unlock := cc.LockAndGetDB()
	defer unlock()

	if changeLike != 0 {
		cc.SetLike(maxInt(db.Like+changeLike, 0))
	}

	if changeDislike != 0 {
		cc.SetDislike(maxInt(db.Dislike+changeDislike, 0))
	}
}

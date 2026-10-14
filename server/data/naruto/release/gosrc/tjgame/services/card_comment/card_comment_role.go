package card_comment

import (
	"tjgame/document"
	"tjgame/document/scheme"
)

type CardCommentRole struct {
	*scheme.CardCommentRoleObject

	like    map[document.ID]bool
	disLike map[document.ID]bool
}

func (r *CardCommentRole) init() {
	db, unlcok := r.RLockAndGetDB()
	defer unlcok()

	r.like = make(map[document.ID]bool, len(db.CommentLike))
	r.disLike = make(map[document.ID]bool, len(db.CommentDisLike))

	for _, commentID := range db.CommentLike {
		r.like[commentID] = true
	}

	for _, commentID := range db.CommentDisLike {
		r.disLike[commentID] = true
	}
}

func (r *CardCommentRole) updateRoleInfo(role ReqRole) {
	db, unlock := r.LockAndGetDB()
	defer unlock()

	if db.GameKey != role.GameKey {
		r.SetGameKey(role.Name)
	}
	if db.Name != role.Name {
		r.SetName(role.Name)
	}
	if db.Logo != role.Logo {
		r.SetLogo(role.Logo)
	}
	if db.Frame != role.Frame {
		r.SetFrame(role.Frame)
	}
	if db.Level != role.Level {
		r.SetLevel(role.Level)
	}
	if db.Vip != role.Vip {
		r.SetVip(role.Vip)
	}
}

func (r *CardCommentRole) cardCommentEvaluate(commentID document.ID, evaluateType string) (changeLike, changeDislike int) {
	r.Lock()
	defer r.Unlock()

	switch evaluateType {
	case "like":
		changeLike, changeDislike = r.likeComment(commentID)
	case "dislike":
		changeLike, changeDislike = r.dislikeComment(commentID)
	case "revokeLike":
		changeLike, changeDislike = r.revokeLikeComment(commentID)
	case "revokeDislike":
		changeLike, changeDislike = r.revokeDislikeComment(commentID)
	}

	return
}

func (r *CardCommentRole) likeComment(commentID document.ID) (changeLike, changeDislike int) {
	db := r.GetLockedDB()

	if !r.like[commentID] {
		changeLike = 1
		db.CommentLike = append(db.CommentLike, commentID)
		r.SetCommentLike(db.CommentLike)
		r.like[commentID] = true
	}

	if r.disLike[commentID] {
		changeDislike = -1
		db.CommentDisLike = documentIDSliceDel(db.CommentDisLike, commentID)
		r.SetCommentDisLike(db.CommentDisLike)
		delete(r.disLike, commentID)
	}

	return
}

func (r *CardCommentRole) dislikeComment(commentID document.ID) (changeLike, changeDislike int) {
	db := r.GetLockedDB()

	if !r.disLike[commentID] {
		changeDislike = 1
		db.CommentDisLike = append(db.CommentDisLike, commentID)
		r.SetCommentDisLike(db.CommentDisLike)
		r.disLike[commentID] = true
	}

	if r.like[commentID] {
		changeLike = -1
		db.CommentLike = documentIDSliceDel(db.CommentLike, commentID)
		r.SetCommentLike(db.CommentLike)
		delete(r.like, commentID)
	}

	return
}

func (r *CardCommentRole) revokeLikeComment(commentID document.ID) (changeLike, changeDislike int) {
	db := r.GetLockedDB()

	if r.like[commentID] {
		changeLike = -1
		db.CommentLike = documentIDSliceDel(db.CommentLike, commentID)
		r.SetCommentLike(db.CommentLike)
		delete(r.like, commentID)
	}

	return
}

func (r *CardCommentRole) revokeDislikeComment(commentID document.ID) (changeLike, changeDislike int) {
	db := r.GetLockedDB()

	if r.disLike[commentID] {
		changeDislike = -1
		db.CommentDisLike = documentIDSliceDel(db.CommentDisLike, commentID)
		r.SetCommentDisLike(db.CommentDisLike)
		delete(r.disLike, commentID)
	}

	return
}

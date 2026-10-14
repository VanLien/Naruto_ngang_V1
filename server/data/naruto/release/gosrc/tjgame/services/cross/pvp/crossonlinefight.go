package pvp

import (
	"tjgame/document/scheme"
	"tjgame/document/schemeutil"
)

type CrossOnlineFightRecord struct {
	*scheme.CrossOnlineFightRecordObject
}

func (r *CrossOnlineFightRecord) updateRole(role competitor) {
	db, unlock := r.LockAndGetDB()
	defer unlock()
	db.RoleName = role.Name
	db.RoleLogo = role.Logo
	db.RoleFrame = role.Frame
	db.RoleLevel = role.Level
	db.RoleFigure = role.Figure
	r.SetDirty("role_name", "role_logo", "role_frame", "role_level", "role_figure")
}

func (r *CrossOnlineFightRecord) deployCards(deploy deployment) {
	db, unlock := r.LockAndGetDB()
	defer unlock()

	if len(deploy.Cards) > 0 {
		r.SetCards(deploy.Cards)
	}
	if len(deploy.CardAttrs) > 0 {
		db.CardAttrs = schemeutil.UpdateCardAttrs(db.CardAttrs, deploy.CardAttrs, db.Cards)
		r.SetCardAttrs(db.CardAttrs)
	}
	if len(deploy.CardAttrs2) > 0 {
		db.CardAttrs2 = schemeutil.UpdateCardAttrs(db.CardAttrs2, deploy.CardAttrs2, db.Cards)
		r.SetCardAttrs2(db.CardAttrs2)
	}
	r.SetPassiveSkills(deploy.PassiveSkills)
}

func (r *CrossOnlineFightRecord) addHistory(pattern int, history *scheme.CrossOnlineFightHistory) {
	db, unlock := r.LockAndGetDB()
	defer unlock()
	if pattern == 1 { // unlimited
		db.UnlimitedHistory = append(db.UnlimitedHistory, *history)
		if len(db.UnlimitedHistory) > 10 {
			db.UnlimitedHistory = db.UnlimitedHistory[len(db.UnlimitedHistory)-10:]
		}
		r.SetUnlimitedHistory(db.UnlimitedHistory)
	} else { // limited
		db.LimitedHistory = append(db.LimitedHistory, *history)
		if len(db.LimitedHistory) > 10 {
			db.LimitedHistory = db.LimitedHistory[len(db.LimitedHistory)-10:]
		}
		r.SetLimitedHistory(db.LimitedHistory)
	}
}

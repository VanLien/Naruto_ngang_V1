package card_comment

import (
	"fmt"
	"sync/atomic"
	"tjgame/csv"
	"tjgame/document"
)

var config atomic.Value

func GetConfig() *Config {
	return config.Load().(*Config)
}

func LoadConfig() error {
	cfg := csv.GetConfig()

	v := &Config{}

	for idx := range cfg.Common_config {
		if cfg.Common_config[idx].Name == "cardCommentHotNum" {
			v.CardCommentHotNum = int(cfg.Common_config[idx].Value)
		}
	}

	config.Store(v)
	return nil
}

func maxInt(a, guard int) int {
	if a < guard {
		return guard
	} else {
		return a
	}
}

func getCardCommentRole(b *Builder, role ReqRole) *CardCommentRole {
	record := b.GetCardCommentRole(role.RoleID)
	if record == nil {
		record = b.CreateCardCommentRole(role)
	} else {
		record.updateRoleInfo(role)
	}
	return record
}

func documentIDSliceDel(s []document.ID, e document.ID) []document.ID {
	for idx := len(s) - 1; idx >= 0; idx-- {
		if s[idx] == e {
			s = append(s[:idx], s[idx+1:]...)
			break
		}
	}
	return s
}

func cardCommentSliceDel(comments []*CardComment, commentID document.ID) []*CardComment {
	for idx := len(comments) - 1; idx >= 0; idx-- {
		if comments[idx].GetID() == commentID {
			comments = append(comments[:idx], comments[idx+1:]...)
			break
		}
	}
	return comments
}

func makeMyCacheKey(roleID document.ID, markID int) string {
	return fmt.Sprintf("%x-%v", string(roleID), markID)
}

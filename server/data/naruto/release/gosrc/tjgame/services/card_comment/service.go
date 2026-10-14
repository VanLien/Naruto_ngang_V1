package card_comment

import (
	"tjgame/document"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
)

const Name = "card_comment"

type Service struct {
	*service.Service
	builder *Builder

	storage service.IService
	manager *Manager
}

func (s *Service) Init() bool {
	if ok := s.Service.Init(); !ok {
		return false
	}

	_ = LoadConfig()

	return true
}

func (s *Service) Start() bool {
	opt := s.Option.Base()
	for _, name := range opt.Dependent {
		ns, _, _ := service.SplitServiceName(name)
		if ns == "commentdb" {
			s.storage = s.Container().GetService(name)
			break
		}
	}
	s.builder = NewBuilder(s.storage)
	s.manager = newCardCommentManager(s.builder)
	s.builder.setManager(s.manager)

	return s.Service.Start()
}

func (s *Service) Stop() {
	s.Service.Stop()
	s.builder.Stop()
}

// 精灵评论主界面
func (s *Service) CardCommentList(req ReqList) (RespList, error) {
	return s.manager.getCardCommentList(req), nil
}

// 发表精灵评论
func (s *Service) CardCommentSend(role ReqRole, markID int, content string) (document.ID, error) {
	roleRecord := getCardCommentRole(s.builder, role)
	commentRecord := s.builder.CreateCardComment(roleRecord.RoleID(), markID, content)
	s.manager.sendComment(commentRecord)
	return commentRecord.GetID(), nil
}

// 精灵评论评价
func (s *Service) CardCommentEvaluate(role ReqRole, commentID document.ID, evaluateType string) (bool, error) {
	commentRecord := s.builder.GetCardComment(commentID)
	if commentRecord == nil {
		return false, ErrCardCommentNotFind
	}
	roleRecord := getCardCommentRole(s.builder, role)
	changeLike, changeDislike := roleRecord.cardCommentEvaluate(commentRecord.GetID(), evaluateType)
	commentRecord.updateLikeAndDislike(changeLike, changeDislike)
	s.manager.commentEvaluate(commentRecord.MarkID(), commentID)
	return true, nil
}

// 精灵评论删除
func (s *Service) CardCommentDel(role ReqRole, commentID document.ID) (bool, error) {
	commentRecord := s.builder.GetCardComment(commentID)
	if commentRecord == nil {
		return false, ErrCardCommentNotFind
	}
	roleRecord := getCardCommentRole(s.builder, role)
	if roleRecord.RoleID() != commentRecord.RoleID() {
		return false, ErrCardCommentNotSSelf
	}
	s.manager.delComment(commentRecord)
	commentRecord.SetDestroy()
	err := s.builder.DeleteCardComment(commentID)
	if err != nil {
		return false, err
	}
	return true, nil
}

func NewService(option service.IOption, container service.IContainer) service.IService {
	s := &Service{
		Service: service.NewService(option, container),
	}

	s.Register(s, "CardCommentList")
	s.Register(s, "CardCommentSend")
	s.Register(s, "CardCommentEvaluate")
	s.Register(s, "CardCommentDel")

	s.Register(s, "CardCommentGMList")
	s.Register(s, "CardCommentGMUpd")
	s.Register(s, "CardCommentGMDel")

	return s
}

func (s *Service) CardCommentGMList(markID int, offset, size int) (RespGMList, error) {
	return s.manager.getCardCommentGMList(markID, offset, size), nil
}

// GM 精灵评论修改
func (s *Service) CardCommentGMUpd(commentID document.ID, like, dislike int) ([2]int, error) {
	commentRecord := s.builder.GetCardComment(commentID)
	if commentRecord == nil {
		return [2]int{}, ErrCardCommentNotFind
	}

	db, unlock := commentRecord.LockAndGetDB()
	defer unlock()

	db.Like = maxInt(db.Like+like, 0)
	db.Dislike = maxInt(db.Dislike+dislike, 0)

	commentRecord.SetLike(db.Like)
	commentRecord.SetDislike(db.Dislike)

	log.Infof("CardCommentGMDel upd comment %v like %v dislike %v", commentID, like, dislike)
	return [2]int{db.Like, db.Dislike}, nil
}

// GM 精灵评论删除
func (s *Service) CardCommentGMDel(commentID document.ID) (bool, error) {
	commentRecord := s.builder.GetCardComment(commentID)
	if commentRecord == nil {
		return false, ErrCardCommentNotFind
	}
	s.manager.delComment(commentRecord)
	commentRecord.SetDestroy()
	err := s.builder.DeleteCardComment(commentID)
	if err != nil {
		return false, err
	}
	log.Infof("CardCommentGMDel del comment %v", commentID)
	return true, nil
}

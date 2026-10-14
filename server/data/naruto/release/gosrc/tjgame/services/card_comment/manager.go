package card_comment

import (
	"errors"
	"sort"
	"sync"
	"tjgame/document"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
)

const (
	CardCommentQueryLimit        = 1000  // 评论查询数量
	CardCommentRoleLRUCapacity   = 10000 // 角色 LRU 大小
	commentCacheGuardLRuCapacity = 1000  // // 部分不在 hotCache, totalCache, myCache 里的评论 LRU 大小

	RefreshDuration = 60 * 3 // hotCache 和 totalCache 刷新间隔
)

var (
	ErrCardCommentNotFind  = errors.New("cardCommentNotFind")    // 评论找不到
	ErrCardCommentNotSSelf = errors.New("card comment not self") // 不是自己的评论
)

type Manager struct {
	hotCache   map[int][]*CardComment       // 热门评论 {markID: []*CardComment}
	hotCheck   map[int]map[document.ID]bool // 检测是否是热门评论 {markID: {commentID: boo}}
	totalCache map[int][]*CardComment       // 需要展示的所有评论 {markID: []*CardComment}
	myCache    *util.LRUCache               // 玩家自己的评论 {RoleID-MarkID: []*CardComment}

	commentCache      map[document.ID]*CardComment // 评论总缓存 {commentID： *CardComment}
	roleCommentCache  map[document.ID]*CardComment // 玩家自己的评论 {commentID： *CardComment}
	commentCacheGuard *util.LRUCache               // 部分不在 hotCache, totalCache, myCache 里的评论 {commentID: *CardComment}
	roleCache         *util.LRUCache               // 玩家缓存 {roleID: *CardCommentRole}

	refreshTime map[int]float64
	refreshIng  map[int]bool

	builder *Builder
	lock    sync.RWMutex
}

func newCardCommentManager(builder *Builder) *Manager {
	mgr := &Manager{
		builder:           builder,
		hotCache:          make(map[int][]*CardComment),
		hotCheck:          make(map[int]map[document.ID]bool),
		totalCache:        make(map[int][]*CardComment),
		commentCache:      make(map[document.ID]*CardComment),
		roleCommentCache:  make(map[document.ID]*CardComment),
		commentCacheGuard: util.NewLRUCache(commentCacheGuardLRuCapacity, nil),
		roleCache:         util.NewLRUCache(CardCommentRoleLRUCapacity, nil),
		refreshTime:       make(map[int]float64),
		refreshIng:        make(map[int]bool),
	}

	mgr.myCache = util.NewLRUCache(CardCommentRoleLRUCapacity, mgr.onMyCacheEvict)

	return mgr
}

func (m *Manager) onMyCacheEvict(key, value interface{}) {
	comments, ok := value.([]*CardComment)
	if !ok {
		log.Warningf("CardCommentManager onMyCacheEvict error key %v value %v", key, value)
		return
	}

	// 此处不对 m.roleCommentCache 加锁，外部 m.myCache.Set() 前加锁
	for _, comment := range comments {
		delete(m.roleCommentCache, comment.GetID())
	}
}

func (m *Manager) refreshHot(markID int) {
	log.Infof("CardCommentManger refreshHot %v", markID)

	cardCommentHotNum := GetConfig().CardCommentHotNum
	data := m.builder.CardCommentQuery(markID, cardCommentHotNum*2+10, "", []string{"-like"})

	newHot, newHotCheck := m.sortHot(data)

	m.lock.Lock()
	for _, comment := range m.hotCache[markID] {
		delete(m.commentCache, comment.GetID())
	}
	m.hotCache[markID] = newHot
	m.hotCheck[markID] = newHotCheck
	for _, comment := range m.hotCache[markID] {
		m.commentCache[comment.GetID()] = comment
	}
	m.lock.Unlock()
}

func (m *Manager) sortHot(data []*CardComment) ([]*CardComment, map[document.ID]bool) {
	cardCommentHotNum := GetConfig().CardCommentHotNum

	ranks := &ranks{
		items: make([]rankItem, 0, cardCommentHotNum),
	}
	for idx, comment := range data {
		comment.RLock()
		like := comment.Like()
		dislike := comment.Dislike()
		commentTime := comment.Time()
		comment.RUnlock()

		ranks.items = append(ranks.items, rankItem{
			id: idx,
			items: map[string]int{
				"like":    like,
				"dislike": dislike,
				"time":    commentTime,
			},
		})
	}
	ranks.keys = [][]string{{"like", "desc"}, {"dislike", "asc"}, {"time", "asc"}}
	sort.Sort(ranks)
	if len(ranks.items) > cardCommentHotNum {
		ranks.items = ranks.items[:cardCommentHotNum]
	}

	newHot := make([]*CardComment, 0, cardCommentHotNum)
	newHotCheck := make(map[document.ID]bool)
	for _, item := range ranks.items {
		newHot = append(newHot, data[item.id])
		newHotCheck[data[item.id].GetID()] = true
	}

	return newHot, newHotCheck
}

func (m *Manager) refreshTotal(markID int) {
	log.Infof("CardCommentManger refreshTotal %v", markID)

	data := m.builder.CardCommentQuery(markID, CardCommentQueryLimit, "", []string{"-time"})

	m.lock.Lock()
	for _, comment := range m.totalCache[markID] {
		delete(m.commentCache, comment.GetID())
	}
	m.totalCache[markID] = data
	for _, comment := range m.totalCache[markID] {
		m.commentCache[comment.GetID()] = comment
	}
	m.lock.Unlock()
}

func (m *Manager) getMyAndNewCardComments(markID int, roleID document.ID, offset, size int) ([]*CardComment, []*CardComment) {
	myCacheKey := makeMyCacheKey(roleID, markID)
	cache, ok := m.myCache.Get(myCacheKey)
	myData := []*CardComment{}
	if ok {
		myData = cache.([]*CardComment)
	} else {
		myData = m.builder.CardCommentQuery(markID, CardCommentQueryLimit, roleID, []string{"-time"})
	}

	m.lock.Lock()
	defer m.lock.Unlock()

	hotCheck := m.hotCheck[markID]

	for _, comment := range myData {
		delete(m.roleCommentCache, comment.GetID())
	}
	myComments := []*CardComment{}
	for _, v := range myData {
		if hotCheck != nil && m.hotCheck[markID][v.GetID()] {
			continue
		}
		myComments = append(myComments, v)
		m.roleCommentCache[v.GetID()] = v
	}
	m.myCache.Set(myCacheKey, myComments)

	newComments := []*CardComment{}
	newIdx := 0
	newStart := offset + 1
	newEnd := offset + size

	for _, v := range m.totalCache[markID] {
		// 热门评论
		if hotCheck != nil && m.hotCheck[markID][v.GetID()] {
			continue
		}

		// 自己的评论
		if v.RoleID() == roleID {
			continue
		}

		newIdx++
		if newIdx >= newStart && newIdx <= newEnd {
			newComments = append(newComments, v)
		}

		if len(newComments) >= size {
			break
		}
	}

	return myComments, newComments
}

func (m *Manager) checkRefresh(markID int) {
	m.lock.Lock()
	lastTime := m.refreshTime[markID]
	needRefresh := util.NowTime()-lastTime >= RefreshDuration && !m.refreshIng[markID]
	if needRefresh {
		m.refreshIng[markID] = true
	}
	m.lock.Unlock()

	if needRefresh {
		m.refreshHot(markID)
		m.refreshTotal(markID)

		m.lock.Lock()
		m.refreshTime[markID] = util.NowTime()
		m.refreshIng[markID] = false
		m.lock.Unlock()
	}
}

func (m *Manager) getCardCommentList(req ReqList) RespList {
	m.checkRefresh(req.MarkID)

	m.lock.RLock()
	cardCommentHotNum := GetConfig().CardCommentHotNum
	hotComments := make([]*CardComment, len(m.hotCache[req.MarkID]))
	copy(hotComments, m.hotCache[req.MarkID])
	if len(hotComments) > cardCommentHotNum {
		hotComments = hotComments[:cardCommentHotNum]
	}
	m.lock.RUnlock()

	myComments, newComments := m.getMyAndNewCardComments(req.MarkID, req.Role.RoleID, req.Offset, req.Size)
	ret := RespList{
		Hot:     hotComments,
		My:      myComments,
		New:     newComments,
		Roles:   make(map[document.ID]ReqRole),
		Like:    make(map[document.ID]bool),
		Dislike: make(map[document.ID]bool),
	}

	total := make([]*CardComment, 0, len(ret.Hot)+len(ret.My)+len(ret.New))
	total = append(total, ret.Hot...)
	total = append(total, ret.My...)
	total = append(total, ret.New...)

	roleRecord := m.builder.GetCardCommentRole(req.Role.RoleID)
	if roleRecord != nil {
		roleRecord.updateRoleInfo(req.Role)
		roleRecord.RLock()
		defer roleRecord.RUnlock()
	}

	for _, v := range total {
		// 自己点赞和踩的评论
		if roleRecord != nil {
			commentID := v.GetID()
			if roleRecord.like[commentID] {
				ret.Like[commentID] = true
			}
			if roleRecord.disLike[commentID] {
				ret.Dislike[commentID] = true
			}
		}

		// 记录评论的角色信息
		if _, ok := ret.Roles[v.RoleID()]; ok {
			continue
		}

		r := m.builder.GetCardCommentRole(v.RoleID())
		if r == nil {
			log.Warningf("CardCommentList not find role %v", v.RoleID())
			continue
		}

		ret.Roles[r.RoleID()] = ReqRole{
			RoleID:  r.RoleID(),
			GameKey: r.GameKey(),
			Name:    r.Name(),
			Logo:    r.Logo(),
			Frame:   r.Frame(),
			Level:   r.Level(),
			Vip:     r.Vip(),
		}
	}

	return ret
}

func (m *Manager) sendComment(comment *CardComment) {
	m.lock.Lock()
	defer m.lock.Unlock()

	commentID := comment.GetID()
	roleID := comment.RoleID()
	markID := comment.MarkID()

	// 增加到自己评论的缓存中
	myCacheKey := makeMyCacheKey(roleID, markID)
	cache, ok := m.myCache.Get(myCacheKey)
	if ok {
		myComments := cache.([]*CardComment)
		myComments = append([]*CardComment{comment}, myComments...)
		m.myCache.Set(myCacheKey, myComments)
		m.roleCommentCache[comment.GetID()] = comment
	}

	// 增加到热门缓存中
	cardCommentHotNum := GetConfig().CardCommentHotNum
	if len(m.totalCache[markID]) < cardCommentHotNum && len(m.hotCache[markID]) < cardCommentHotNum {
		m.hotCache[markID] = append(m.hotCache[markID], comment)
		if _, ok := m.hotCheck[markID]; ok {
			m.hotCheck[markID][commentID] = true
		} else {
			m.hotCheck[markID] = map[document.ID]bool{commentID: true}
		}
	}

	// 增加到所有评论的缓存中
	m.totalCache[markID] = append([]*CardComment{comment}, m.totalCache[markID]...)
	if len(m.totalCache[markID]) > CardCommentQueryLimit {
		for _, comment := range m.totalCache[markID][CardCommentQueryLimit:] {
			delete(m.commentCache, comment.GetID())
		}
		m.totalCache[markID] = m.totalCache[markID][:CardCommentQueryLimit]
	}

	m.commentCache[comment.GetID()] = comment
}

func (m *Manager) delComment(comment *CardComment) {
	m.lock.Lock()
	defer m.lock.Unlock()

	commentID := comment.GetID()
	roleID := comment.RoleID()
	markID := comment.MarkID()

	// 从自己的评论缓存中删除
	myCacheKey := makeMyCacheKey(roleID, markID)
	cache, ok := m.myCache.Get(myCacheKey)
	if ok {
		myComments := cache.([]*CardComment)
		myComments = cardCommentSliceDel(myComments, commentID)
		m.myCache.Set(myCacheKey, myComments)
		delete(m.roleCommentCache, commentID)
	}

	// 从热门中删除
	m.hotCache[markID] = cardCommentSliceDel(m.hotCache[markID], commentID)
	if _, ok := m.hotCheck[markID]; ok {
		delete(m.hotCheck[markID], commentID)
	}

	// 从所有评论中删除
	m.totalCache[markID] = cardCommentSliceDel(m.totalCache[markID], commentID)

	delete(m.commentCache, commentID)
}

func (m *Manager) commentEvaluate(markID int, commentID document.ID) {
	m.lock.Lock()
	defer m.lock.Unlock()

	// 更新热门排序
	if _, ok := m.hotCheck[markID]; !ok {
		return
	}

	if _, ok := m.hotCheck[markID][commentID]; !ok {
		return
	}

	newHot, newHotCheck := m.sortHot(m.hotCache[markID])
	m.hotCache[markID] = newHot
	m.hotCheck[markID] = newHotCheck
}

func (m *Manager) getCardCommentByCache(commentID document.ID) (*CardComment, bool) {
	m.lock.RLock()
	defer m.lock.RUnlock()
	comment, ok := m.commentCache[commentID]
	if ok {
		return comment, ok
	}
	comment, ok = m.roleCommentCache[commentID]
	if ok {
		return comment, ok
	}
	cache, ok := m.commentCacheGuard.Get(commentID)
	if ok {
		return cache.(*CardComment), ok
	} else {
		return nil, false
	}
}

func (m *Manager) setCardCommentCache(comment *CardComment) {
	m.commentCacheGuard.Set(comment.GetID(), comment)
}

func (m *Manager) getRoleByCache(roleID document.ID) (*CardCommentRole, bool) {
	cache, ok := m.roleCache.Get(roleID)
	if ok {
		return cache.(*CardCommentRole), ok
	} else {
		return nil, false
	}
}

func (m *Manager) setRoleCache(role *CardCommentRole) {
	m.roleCache.Set(role.RoleID(), role)
}

func (m *Manager) getCardCommentGMList(markID, offset, size int) RespGMList {
	m.checkRefresh(markID)

	m.lock.RLock()
	cardCommentHotNum := GetConfig().CardCommentHotNum
	hotComments := make([]*CardComment, len(m.hotCache[markID]))
	copy(hotComments, m.hotCache[markID])
	if len(hotComments) > cardCommentHotNum {
		hotComments = hotComments[:cardCommentHotNum]
	}

	hotCheck := m.hotCheck[markID]
	newComments := make([]*CardComment, 0, size)
	start := offset + 1
	end := offset + size
	newIdx := 0
	for _, comment := range m.totalCache[markID] {
		if hotCheck != nil && hotCheck[comment.GetID()] {
			continue
		}
		newIdx++
		if newIdx >= start && newIdx <= end {
			newComments = append(newComments, comment)
		}
	}
	totalPage := newIdx / size
	if newIdx%size > 0 {
		totalPage++
	}
	m.lock.RUnlock()

	ret := RespGMList{
		Hot:       hotComments,
		New:       newComments,
		Roles:     make(map[document.ID]ReqRole),
		TotalPage: totalPage,
	}

	total := make([]*CardComment, 0, len(ret.Hot)+len(ret.New))
	total = append(total, ret.Hot...)
	total = append(total, ret.New...)

	for _, v := range total {
		// 记录评论的角色信息
		if _, ok := ret.Roles[v.RoleID()]; ok {
			continue
		}

		r := m.builder.GetCardCommentRole(v.RoleID())
		if r == nil {
			log.Warningf("CardCommentList not find role %v", v.RoleID())
			continue
		}

		ret.Roles[r.RoleID()] = ReqRole{
			RoleID:  r.RoleID(),
			GameKey: r.GameKey(),
			Name:    r.Name(),
			Logo:    r.Logo(),
			Frame:   r.Frame(),
			Level:   r.Level(),
			Vip:     r.Vip(),
		}
	}

	return ret
}

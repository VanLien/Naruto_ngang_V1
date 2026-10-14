package redpacket

import (
	"math/rand"
	"time"
	"tjgame/csv"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/server_framework/tj/util"
)

var (
	closedTime = util.Time{Hour: 5}
)

type RedPacket struct {
	*scheme.CrossRedPacketGlobalObject

	container service.IContainer
	manager   *Manager

	redPacketCount    document.Integer
	redPacketNoRemain []document.Integer
}

func (r *RedPacket) init(container service.IContainer, manager *Manager) {
	r.Lock()
	defer r.Unlock()

	r.container = container
	r.manager = manager
}

// 在活动开始前对旧数据进行清理（初始化）
func (r *RedPacket) onInit(id int, games []string) {

	util.WithGuard(r, func() {
		// 活动结束时间
		cfg := csv.GetConfig().Cross.Service[id]
		r.SetYYID(id)
		r.SetEndDate(cfg.EndDate)
		r.SetServers(games)
		r.SetStatus("start")

		r.SetRedPackets(make(map[document.Integer]*scheme.RedPacketInfo))
		r.redPacketCount = 0
		r.redPacketNoRemain = []document.Integer{}
	})

	duration := closedTime.CombineDateInt(r.EndDate()).Sub(util.Now())
	log.Infof("CrossRedPacket key %v group %v cross redpacket data reset delta %s", r.Key(), r.Group(), duration)
	time.AfterFunc(duration, r.onClosed)
}

func (r *RedPacket) isOver() bool {
	if r.Status() == "start" {
		return false
	}
	return true
}

// 活动中重启
func (r *RedPacket) resetToday() bool {
	if r.Status() == "closed" {
		return false
	}

	// 结束日期关闭活动
	if util.Todayinclock5date2int() >= r.EndDate() {
		r.onClosed()
		return false
	}

	// 从已有数据初始化对象
	util.WithGuard(r, func() {
		if r.RedPackets() == nil {
			r.SetRedPackets(make(map[document.Integer]*scheme.RedPacketInfo))
		}
		for idx, info := range r.RedPackets() {
			if r.redPacketCount < idx {
				r.redPacketCount = idx
			}
			if len(info.Members) >= info.TotalCount {
				r.redPacketNoRemain = append(r.redPacketNoRemain, idx)
			}
		}
	})

	duration := closedTime.CombineDateInt(r.EndDate()).Sub(util.Now())
	log.Infof("CrossRedPacket key %v group %v Start next reset delta %v", r.Key(), r.Group(), duration)
	time.AfterFunc(duration, r.onClosed)
	return true
}

// 活动结束
func (r *RedPacket) onClosed() {
	r.Lock()
	defer r.Unlock()

	if r.Status() == "closed" {
		log.Infof("CrossRedPacket key %v group %v has closed", r.Key(), r.Group())
		return
	}

	r.eventToGame("closed", struct{}{}, false)
	r.SetStatus("closed")
	r.manager.clearGameToPlay(r.Servers())
	log.Infof("CrossRedPacket key %v group %v servers %v closed", r.Key(), r.Group(), r.Servers())
}

func (r *RedPacket) eventToGame(event string, data struct{}, sync bool) {
	var model struct{}

	servers := r.Servers()
	keys := make([]string, 0, len(servers))
	for _, key := range servers {
		keys = append(keys, key)
		s := r.container.GetService(key)
		service.CallAsync(s, "HuoDongCrossRedPacketEvent", event, key, data, model)
	}
}

func (r *RedPacket) getRedPacketList() []*scheme.RedPacketInfo {
	redPacketInfoList := make([]*scheme.RedPacketInfo, 0)
	// 刷新红包列表
	util.WithGuard(r, func() {
		redPackets := r.RedPackets()
		count := len(redPackets) - 50
		if count > 0 && len(r.redPacketNoRemain) > 0 {
			var num int
			if count > len(r.redPacketNoRemain) {
				num = len(r.redPacketNoRemain)
			} else {
				num = count
			}
			idxs := r.redPacketNoRemain[:num]
			for _, idx := range idxs {
				delete(redPackets, idx)
			}
			r.redPacketNoRemain = r.redPacketNoRemain[num:]
			r.SetRedPackets(redPackets)
		}
		for _, v := range redPackets {
			redPacketInfoList = append(redPacketInfoList, v)
		}
	})
	return redPacketInfoList
}

func (r *RedPacket) sendRedPacket(redPacketInfo *scheme.RedPacketInfo) (int, []*scheme.RedPacketInfo) {
	idx := document.Integer(0)
	util.WithGuard(r, func() {
		// 红包id+1
		r.redPacketCount += 1
		idx = r.redPacketCount
		redPacketInfo.Idx = idx
		redPackets := r.RedPackets()
		redPackets[idx] = redPacketInfo
		r.SetRedPackets(redPackets)
	})

	redPacketInfoList := r.getRedPacketList()
	return int(idx), redPacketInfoList
}

func (r *RedPacket) robRedPacket(idx document.Integer, memberInfo scheme.MemberInfo) (*scheme.RedPacketInfo, int, []*scheme.RedPacketInfo, error) {
	var infoRet scheme.RedPacketInfo
	val := 0
	var err error
	util.WithGuard(r, func() {
		// 检查红包id是否存在
		redPackets := r.RedPackets()
		if _, ok := redPackets[idx]; !ok {
			err = ErrRedPacketNoRemain
			return
		}
		// 检查role是否已经抢过
		info := redPackets[idx]
		if _, ok := info.Members[memberInfo.Id]; ok {
			err = ErrRedPacketAlreadyRob
			return
		}
		// 检查次数是否已经抢完
		usedCount := len(info.Members)
		if usedCount >= info.TotalCount {
			err = ErrRedPacketNoRemain
			return
		}

		// 获取此次金额
		usedVal := 0
		for _, m := range info.Members {
			usedVal += m.Val
		}
		remainCount := info.TotalCount - len(info.Members)
		if remainCount == 1 {
			val = info.TotalVal - usedVal
		} else {
			right := (info.TotalVal - usedVal - remainCount) * 2 / remainCount
			if right < 1 {
				right = 1
			}
			val = rand.Intn(right-1) + 1
		}
		if val < 1 {
			val = 1
		}
		memberInfo.Val = val
		info.Members[memberInfo.Id] = memberInfo
		r.SetRedPackets(redPackets)
		if len(info.Members) >= info.TotalCount {
			r.redPacketNoRemain = append(r.redPacketNoRemain, idx)
		}
		// 这里拷贝一份
		infoRet = *info
		infoRet.Members = make(map[document.ID]scheme.MemberInfo)
		for key, value := range info.Members {
			infoRet.Members[key] = value
		}
	})

	if err != nil {
		return &infoRet, val, nil, err
	}

	redPacketInfoList := r.getRedPacketList()
	return &infoRet, val, redPacketInfoList, nil
}

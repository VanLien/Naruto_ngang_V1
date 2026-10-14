package redpacket

import "tjgame/document/scheme"

// 发红包
type RedPacketSendResponse struct {
	// 新增红包id
	Idx int `codec:"idx"`
	// 红包列表
	RedPacketList []*scheme.RedPacketInfo `codec:"red_packet_list"`
}

// 抢红包
type RedPacketRobResponse struct {
	// 此次被抢红包信息
	Info *scheme.RedPacketInfo `codec:"info"`
	// 此次抢到的数额
	Val int `codec:"val"`
	// 红包列表
	RedPacketList []*scheme.RedPacketInfo `codec:"red_packet_list"`
}

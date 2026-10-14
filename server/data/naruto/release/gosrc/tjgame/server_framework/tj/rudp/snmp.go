package rudp

import (
	"fmt"
	"strings"
	"sync/atomic"
)

// Snmp defines network statistics indicator
type Snmp struct {
	BytesSent       uint64 // bytes sent from upper level
	BytesReceived   uint64 // bytes received to upper level
	MaxConn         uint64 // max number of connections ever reached
	ActiveOpens     uint64 // accumulated active open connections
	PassiveOpens    uint64 // accumulated passive open connections
	CurrEstablished uint64 // current number of established connections
	InErrs          uint64 // UDP read errors reported from net.PacketConn
	RudpInErrors    uint64 // packet input errors reported from Rudp
	InSegments      uint64 // incoming Rudp segments
	OutSegments     uint64 // outgoing Rudp segments
	InPackages      uint64 // incoming packets count
	OutPackages     uint64 // outgoing packets count
	InBytes         uint64 // UDP bytes received
	OutBytes        uint64 // UDP bytes sent
	RetransSegments uint64 // accmulated retransmited segments
	LostSegments    uint64 // number of segs infered as lost
	RepeatSegments  uint64 // number of segs duplicated
}

// Reset values to zero
func (s *Snmp) Reset() {
	atomic.StoreUint64(&s.BytesSent, 0)
	atomic.StoreUint64(&s.BytesReceived, 0)
	atomic.StoreUint64(&s.MaxConn, 0)
	atomic.StoreUint64(&s.ActiveOpens, 0)
	atomic.StoreUint64(&s.PassiveOpens, 0)
	atomic.StoreUint64(&s.CurrEstablished, 0)
	atomic.StoreUint64(&s.InErrs, 0)
	atomic.StoreUint64(&s.RudpInErrors, 0)
	atomic.StoreUint64(&s.InPackages, 0)
	atomic.StoreUint64(&s.OutPackages, 0)
	atomic.StoreUint64(&s.InSegments, 0)
	atomic.StoreUint64(&s.OutSegments, 0)
	atomic.StoreUint64(&s.InBytes, 0)
	atomic.StoreUint64(&s.OutBytes, 0)
	atomic.StoreUint64(&s.RetransSegments, 0)
	atomic.StoreUint64(&s.LostSegments, 0)
	atomic.StoreUint64(&s.RepeatSegments, 0)
}

func (s *Snmp) String() string {
	titles := []string{
		"bytes_send",
		"bytes_received",
		//"max_conn",
		//"active_opens",
		//"passive_opens",
		//"curr_established",
		//"in_errs",
		//"rudp_in_errors",
		"in_segments",
		"out_segments",
		"in_packages",
		"out_packages",
		"in_bytes",
		"out_bytes",
		"retrans_segments",
		"lost_segments",
		"repeat_segments",
	}
	nums := []string{
		fmt.Sprint(s.BytesSent),
		fmt.Sprint(s.BytesReceived),
		//fmt.Sprint(s.MaxConn),
		//fmt.Sprint(s.ActiveOpens),
		//fmt.Sprint(s.PassiveOpens),
		//fmt.Sprint(s.CurrEstablished),
		//fmt.Sprint(s.InErrs),
		//fmt.Sprint(s.RudpInErrors),
		fmt.Sprint(s.InSegments),
		fmt.Sprint(s.OutSegments),
		fmt.Sprint(s.InPackages),
		fmt.Sprint(s.OutPackages),
		fmt.Sprint(s.InBytes),
		fmt.Sprint(s.OutBytes),
		fmt.Sprint(s.RetransSegments),
		fmt.Sprint(s.LostSegments),
		fmt.Sprint(s.RepeatSegments),
	}

	return fmt.Sprintf("%s\n%s", strings.Join(titles, "\t"), strings.Join(nums, "\t"))
}

var defaultSnmp *Snmp

func init() {
	defaultSnmp = &Snmp{}
}

func SnmpBytesSend(v uint64) {
	atomic.AddUint64(&defaultSnmp.BytesSent, v)
}

func SnmpBytesReceived(v uint64) {
	atomic.AddUint64(&defaultSnmp.BytesReceived, v)
}

func SnmpInSegments(v uint64) {
	atomic.AddUint64(&defaultSnmp.InSegments, v)
}

func SnmpOutSegments(v uint64) {
	atomic.AddUint64(&defaultSnmp.OutSegments, v)
}

func SnmpInPackages(v uint64) {
	atomic.AddUint64(&defaultSnmp.InPackages, v)
}

func SnmpOutPackages(v uint64) {
	atomic.AddUint64(&defaultSnmp.OutPackages, v)
}

func SnmpInBytes(v uint64) {
	atomic.AddUint64(&defaultSnmp.InBytes, v)
}

func SnmpOutBytes(v uint64) {
	atomic.AddUint64(&defaultSnmp.OutBytes, v)
}

func SnmpRetransSegements(v uint64) {
	atomic.AddUint64(&defaultSnmp.RetransSegments, v)
}

func SnmpLostSegments(v uint64) {
	atomic.AddUint64(&defaultSnmp.LostSegments, v)
}

func SnmpRepeatSegment(v uint64) {
	atomic.AddUint64(&defaultSnmp.RepeatSegments, v)
}

package util

import (
	"testing"
	"time"
)

func TestNow(t *testing.T) {
	now := Now()
	t.Log(now, Date2int(now))

	loc, _ := time.LoadLocation("EST") //UTC-5 EST 东部标准时区
	SetLocation(loc)

	now = Now()
	t.Log(now, Date2int(now))

	t.Log(now.Format("20060102150405"))
	t.Log(now.Format("20060102"))
	t.Log(now.Format("2006010215"))
	t.Log(now.Format("06010215"))

	t.Log(Weekinclock5date2int())
}

func Test_InClock5ElapseDays(t *testing.T) {
	tests := []struct {
		startTime time.Time
		endTime   time.Time
		ans       int
	}{
		{
			Date(2020, 12, 10, 6, 30, 0, 0),
			Date(2020, 12, 10, 16, 30, 0, 0),
			0,
		},
		{
			Date(2020, 12, 10, 6, 30, 0, 0),
			Date(2020, 12, 11, 1, 30, 0, 0),
			0,
		},
		{
			Date(2020, 12, 10, 6, 30, 0, 0),
			Date(2020, 12, 11, 6, 30, 0, 0),
			1,
		},
		{
			Date(2020, 12, 11, 1, 30, 0, 0),
			Date(2020, 12, 11, 1, 30, 0, 0),
			0,
		},
		{
			Date(2020, 12, 11, 1, 30, 0, 0),
			Date(2020, 12, 11, 6, 30, 0, 0),
			1,
		},
	}

	for _, test := range tests {
		if InClock5ElapseDays(test.startTime, test.endTime) != test.ans {
			t.Errorf("failure %+v", test)
		}
	}
}

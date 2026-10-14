package util

import "time"

var location *time.Location

var (
	UTC7Zone  = time.FixedZone("UTC8", 7*60*60) // UTC+7 越南时区
	UTC8Zone  = time.FixedZone("UTC8", 8*60*60)
	UTC9Zone  = time.FixedZone("UTC9", 9*60*60)   // UTC+9 韩国时间
	UTCN5Zone = time.FixedZone("UTCN5", -5*60*60) // UTC-5 EST 东部标准时区
)

func SetLocation(loc *time.Location) {
	location = loc
}

var dailyRefreshHour = 0

func SetDailyRefreshHour(hour int) {
	dailyRefreshHour = hour
}

func DailyRefreshHour() int {
	return dailyRefreshHour
}

func InitTimeZoneAndDailyRefreshHour(language string) {
	switch language {
	case "cn":
		// SetDailyRefreshHour(5)
		// SetLocation(UTC8Zone)
		SetDailyRefreshHour(0)
		SetLocation(UTC7Zone)

	case "kr":
		// SetDailyRefreshHour(0)
		// SetLocation(UTC9Zone)
		SetDailyRefreshHour(0)
		SetLocation(UTC7Zone)
	case "en":
		// SetDailyRefreshHour(0)
		// SetLocation(UTC8Zone)
		SetDailyRefreshHour(0)
		SetLocation(UTC7Zone)

	case "vn":
		// SetDailyRefreshHour(5)
		// SetLocation(UTC7Zone)

		SetDailyRefreshHour(0)
		SetLocation(UTC7Zone)
	}
}

const OneDay = 24 * time.Hour

func Now() time.Time {
	return time.Now().In(location)
}

func Date(year, month, day, hour, min, sec, nsec int) time.Time {
	return time.Date(year, time.Month(month), day, hour, min, sec, nsec, location)
}

func Unix(sec int64) time.Time {
	return time.Unix(sec, 0).In(location)
}

func NowTime() float64 {
	return float64(Now().Unix())
}

func Date2int(t time.Time) int {
	year, month, day := t.Date()
	return year*10000 + int(month*100) + day
}

func Int2Date(date int) time.Time {
	year, month, day := date/10000, (date/100)%100, date%100
	return Date(year, month, day, 0, 0, 0, 0)
}

func DateTimeCombine(date int, hour, min, sec int) time.Time {
	year, month, day := date/10000, (date/100)%100, date%100
	return Date(year, month, day, hour, min, sec, 0)
}

func inclock5(t time.Time) time.Time {
	if t.Hour() >= dailyRefreshHour {
		return t
	}
	return t.Add(-OneDay)
}

// 自然日
func Todaydate2int() int {
	return Date2int(Now())
}

// 自然月
func Todaymonth2int() int {
	year, month, _ := Now().Date()
	return year*100 + int(month)
}

// 凌晨5点之后算新的一天
func Todayinclock5date2int() int {
	t := Now()
	if t.Hour() >= dailyRefreshHour {
		return Date2int(t)
	}
	return Date2int(t.Add(-OneDay))
}

// 本周的周一，按凌晨5点算新的一天
func Weekinclock5date2int() int {
	t := Now()
	if t.Hour() < dailyRefreshHour {
		t = t.Add(-OneDay)
	}
	w := t.Weekday()
	if w != time.Monday {
		day := (int(w) - 1 + 7) % 7
		t = t.Add(-OneDay * time.Duration(day))
	}
	return Date2int(t)
}

// 本周的周一（按自然0点）
func WeekDate2int() int {
	t := Now()
	w := t.Weekday()
	if w != time.Monday {
		day := (int(w) - 1 + 7) % 7
		t = t.Add(-OneDay * time.Duration(day))
	}
	return Date2int(t)
}

func Nowtime2int() int {
	t := Now()
	return Time2int(t)
}

func Perioddate2int(hour int, t time.Time) int {
	if t.Hour() < hour {
		t = t.Add(-OneDay)
	}
	return Date2int(t)
}

func Period2Time(hour int, minute int, t time.Time) time.Time {
	if t.Hour() < hour || (t.Hour() == hour && t.Minute() < minute) {
		t = t.Add(-OneDay)
	}
	return t
}

func Time2int(t time.Time) int {
	year, month, day := t.Date()
	hour := t.Hour()
	return (year%100)*1000000 + int(month)*10000 + day*100 + hour
}

func InclockNdate2int(tnow time.Time, hour int) int {
	if tnow.Hour() >= hour {
		return Date2int(tnow)
	}
	return Date2int(tnow.Add(-OneDay))
}

// 找到时刻对应的时间区间起点的数字
func Time2Period(t time.Time, periods []int) int {
	hour := t.Hour()
	if hour < periods[0] {
		hour = periods[len(periods)-1]
		t = Time{Hour: hour}.Combine(t).Add(-OneDay)
	} else {
		for i, period := range periods {
			if period > hour {
				hour = periods[i-1]
				break
			}
		}
		t = Time{Hour: hour}.Combine(t)
	}
	return Time2int(t)
}

func NowTime2Peroid(periods []int) int {
	return Time2Period(Now(), periods)
}

func TimeParse(layout, value string) (time.Time, error) {
	return time.ParseInLocation(layout, value, location)
}

func Time2Date(t time.Time) time.Time {
	y, m, d := t.Date()
	return Date(y, int(m), d, 0, 0, 0, 0)
}

func InClock5ElapseDays(startTime, endTime time.Time) int {
	days := int(Time2Date(endTime).Sub(Time2Date(startTime)).Seconds() / 86400)
	if startTime.Hour() < dailyRefreshHour && endTime.Hour() >= dailyRefreshHour {
		return days + 1
	} else if endTime.Hour() < dailyRefreshHour && startTime.Hour() >= dailyRefreshHour {
		return days - 1
	}
	return days
}

func TodayInClock5ElapseDays(startTime time.Time) int {
	return InClock5ElapseDays(startTime, Now())
}

type Time struct {
	Hour   int
	Minute int
	Second int
}

func (t Time) Combine(t1 time.Time) time.Time {
	year, month, day := t1.Date()
	return Date(year, int(month), day, t.Hour, t.Minute, t.Second, 0)
}

func (t Time) CombineDateInt(date int) time.Time {
	year, month, day := date/10000, (date/100)%100, date%100
	return Date(year, month, day, t.Hour, t.Minute, t.Second, 0)
}

func init() {
	// location = UTC8Zone
	location = UTC7Zone
}

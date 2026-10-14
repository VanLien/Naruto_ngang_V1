package log

import (
	"io"
	"os"
	"runtime"
	"unsafe"

	"github.com/op/go-logging"
)

// Log levels.
// copy from go-logging
const (
	WARNING = logging.WARNING
	INFO    = logging.INFO
	DEBUG   = logging.DEBUG

	stackMaxSize = 4 * 1024
)

type Logger struct {
	*logging.Logger
}

type strFormat struct {
	logging.Formatter
}

func (s *strFormat) Format(calldepth int, r *logging.Record, w io.Writer) error {
	r.ID %= 1000 // %{id:03d}
	return s.Formatter.Format(calldepth, r, w)
}

var l *Logger
var lvl logging.Level

func newPrettyLogger(module string, level logging.Level) *Logger {
	var format logging.Formatter
	//if level == DEBUG {
	//	if len(module) > 0 {
	//		format =
	//			logging.MustStringFormatter(`%{color}[%{module} %{level:.1s} %{time:060102 15:04:05.000} %{longfile}]%{color:reset} %{message}`)
	//
	//	} else {
	//		format = logging.MustStringFormatter(`%{color}[%{program} %{level:.1s} %{time:060102 15:04:05.000} %{longfile}]%{color:reset} %{message}`)
	//	}
	//} else {
	//
	//}

	lvl = level
	if len(module) > 0 {
		format = logging.MustStringFormatter(`%{color}[%{module} %{level:.1s} %{time:060102 15:04:05.000}.%{id:03d} %{shortfile}]%{color:reset} %{message}`)

	} else {
		format = logging.MustStringFormatter(`%{color}[%{program} %{level:.1s} %{time:060102 15:04:05.000}.%{id:03d} %{shortfile}]%{color:reset} %{message}`)
	}

	backend1 := logging.NewLogBackend(os.Stdout, "", 0)
	backend1.Color = true

	backend1Formatter := logging.NewBackendFormatter(backend1, &strFormat{format})
	backend1Leveled := logging.AddModuleLevel(backend1Formatter)
	backend1Leveled.SetLevel(level, "")

	log := logging.MustGetLogger(module)
	log.SetBackend(backend1Leveled)
	log.ExtraCalldepth = 2 // skip aux functions frame
	return &Logger{log}
}

func GetLogger() *Logger {
	return l
}

// for NSQ Log
type NSQLogger struct {
	*Logger
}

func GetNSQLogger() *NSQLogger {
	return &NSQLogger{l}
}

// for NSQ Log, like golang log.Logger.Output
func (l *NSQLogger) Output(calldepth int, s string) error {
	//oldDepth := l.Logger.ExtraCalldepth
	//l.Logger.ExtraCalldepth = calldepth
	switch s[0] {
	case 'D':
		l.Logger.Debug(s)
	case 'I':
		l.Logger.Info(s)
	case 'W':
		l.Logger.Warning(s)
	case 'E':
		l.Logger.Error(s)
	default:
		l.Logger.Warning(s)
	}
	//l.Logger.ExtraCalldepth = oldDepth
	return nil
}

func GetNSQLogLevel() int {
	switch lvl {
	case DEBUG:
		return 0 // LogLevelDebug
	case INFO:
		return 1 // LogLevelInfo
	case WARNING:
		return 2 // LogLevelWarning
	default:
		return 3 // LogLevelError
	}
}

func Init(module string, level logging.Level) {
	l = newPrettyLogger(module, level)
}

func init() {
	l = newPrettyLogger("", DEBUG)
}

///////////////////////////
// aux functions
// no Fatal and Notice

// Panic is equivalent to l.Critical(fmt.Sprint()) followed by a call to panic().
func Panic(args ...interface{}) {
	l.Panic(args...)
}

// Panicf is equivalent to l.Critical followed by a call to panic().
func Panicf(format string, args ...interface{}) {
	l.Panicf(format, args...)
}

// Critical logs a message using CRITICAL as log level.
func Error(args ...interface{}) {
	stackBuf := make([]byte, stackMaxSize)
	stackBuf[0] = '\n'
	n := runtime.Stack(stackBuf[1:], false)
	b := stackBuf[:n+1]
	s := *(*string)(unsafe.Pointer(&b))
	args = append(args, s)
	l.Error(args...)
}

// Errorf logs a message using ERROR as log level.
func Errorf(format string, args ...interface{}) {
	stackBuf := make([]byte, stackMaxSize)
	n := runtime.Stack(stackBuf, false)
	b := stackBuf[:n]
	s := *(*string)(unsafe.Pointer(&b))
	args = append(args, s)
	l.Errorf(format+"\n%s", args...)
}

// Warning logs a message using WARNING as log level.
func Warning(args ...interface{}) {
	l.Warning(args...)
}

// Warningf logs a message using WARNING as log level.
func Warningf(format string, args ...interface{}) {
	l.Warningf(format, args...)
}

// Info logs a message using INFO as log level.
func Info(args ...interface{}) {
	l.Info(args...)
}

// Infof logs a message using INFO as log level.
func Infof(format string, args ...interface{}) {
	l.Infof(format, args...)
}

// Debug logs a message using DEBUG as log level.
func Debug(args ...interface{}) {
	if l.IsEnabledFor(DEBUG) {
		l.Debug(args...)
	}
}

// Debugf logs a message using DEBUG as log level.
func Debugf(format string, args ...interface{}) {
	if l.IsEnabledFor(DEBUG) {
		l.Debugf(format, args...)
	}
}

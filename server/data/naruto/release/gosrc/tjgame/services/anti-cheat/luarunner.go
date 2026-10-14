package anti_cheat

import (
	"bufio"
	"errors"
	"fmt"
	"io"
	"os/exec"
	"strconv"
	"strings"
	"time"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"

	"github.com/prometheus/client_golang/prometheus"
)

var magicFlag = []byte{'-', 'T', 'J', '-', '\n'}
var ErrWriteToLuaFailed = errors.New("write to lua failed")

type LuaRunner struct {
	idx int
	num int64

	runtimes time.Duration

	cmd    *exec.Cmd
	stdin  *bufio.Writer
	stdout *bufio.Reader
	stderr *bufio.Reader

	closer io.Closer

	// metric
	elapsed        prometheus.Counter
	count          prometheus.Counter
	durationBucket prometheus.Observer
}

func (r *LuaRunner) Start() error {
	err := r.cmd.Start()
	if err == nil {
		go func() {
			for {
				line, err := r.stdout.ReadString('\n')
				if err == nil {
					log.Infof("[Runner %d OUT]: %s", r.idx, strings.TrimSpace(line))
				} else if err == io.EOF {
					break
				} else {
					log.Warningf("Runner[%d] read from stdout error %v", r.idx, err)
				}
			}
		}()
	}
	return err
}

func (r *LuaRunner) Run(record *Record) {
	s1 := time.Now()
	v := []interface{}{types[record.Type], record.PlayRecord}
	data, err := util.MsgPack(v)
	if err != nil {
		log.Warningf("MsgPack %v", err)
		record.Result = "error"
		record.Done()
		return
	}

	err = r.send(data)
	if err != nil {
		record.Result = "error"
		return
	}

	result, err := r.recv()
	if err != nil {
		log.Warningf("Runner[%d] read/decoder from stderr error %v", r.idx, err)
		record.Result = "error"
	} else {
		record.Result = result.Result
		record.Point1 = result.Point1
		record.Point2 = result.Point2
		record.States = result.States
		record.Damages = result.Damages
		if record.Result == "error" {
			log.Warningf("Record %s:%v Result error, \n%s", record.servKey, record.playID, result.Traceback)
			report := &TracebackReport{
				Type:       record.Type,
				ServKey:    record.servKey,
				PlayID:     record.playID,
				PlayRecord: record.PlayRecord,
				Traceback:  result.Traceback,
			}
			go report.reportToCrash()
		}
		if record.Result == "error" && errorForceResult {
			record.forceResult()
		}
	}

	r.num++
	duration := time.Now().Sub(s1)
	r.runtimes += duration
	elapse := float64(duration) / 1e6
	avg := float64(int64(r.runtimes)/r.num) / 1e6
	log.Infof("%d Runner %s Cost %.2fms AVG %.2fms %d", r.idx, record, elapse, avg, r.num)
	record.Done()

	r.count.Inc()
	r.elapsed.Add(duration.Seconds())
	r.durationBucket.Observe(float64(duration.Milliseconds()))
}

func (r *LuaRunner) Stop() {
	if err := r.closer.Close(); err != nil {
		log.Errorf("Close Runner[%d] error %v", r.idx, err)
	}
	if err := r.cmd.Wait(); err != nil {
		log.Errorf("Stop Runner[%d] error %v", r.idx, err)
	}
}

func (r *LuaRunner) send(data []byte) error {
	// write flag
	n, err := r.stdin.Write(magicFlag)
	if err != nil || n != len(magicFlag) {
		log.Warningf("write magic flag error %v", err)
		return ErrWriteToLuaFailed
	}

	// write length
	head := fmt.Sprintf("%d\n", len(data))
	n, err = r.stdin.Write([]byte(head))
	if err != nil || n != len(head) {
		log.Warningf("write head error %v", err)
		return ErrWriteToLuaFailed
	}

	// write data
	for len(data) > 0 {
		size := 64
		if size > len(data) {
			size = len(data)
		}
		n, err := r.stdin.Write(data[:size])
		if err != nil {
			log.Warningf("!!! error %v", err)
			return ErrWriteToLuaFailed
		} else {
			data = data[n:]
		}
	}
	r.stdin.Flush()
	return nil
}

func (r *LuaRunner) recv() (result *Result, err error) {
	var num int
	var data []byte
	data, err = r.stderr.ReadBytes('\n')
	if err == nil {
		num, err = strconv.Atoi(string(data[:len(data)-1]))
	}
	if err != nil {
		return nil, err
	}
	data = make([]byte, num)
	_, err = io.ReadFull(r.stderr, data)
	if err == nil {
		result = &Result{}
		err = util.MsgUnpack(data, result)
		if err != nil {
			log.Warningf("msgpack unpack result %v error %v", result, err)
		}
	}
	return
}

func NewLuaRunner(idx int, labels prometheus.Labels) *LuaRunner {
	r := &LuaRunner{
		idx: idx,
	}

	cmd := exec.Command(luajit, "anti_main.lua")
	r.cmd = cmd
	r.cmd.Dir = scriptPath

	stdin, err := cmd.StdinPipe()
	if err != nil {
		panic(err)
	}
	r.stdin = bufio.NewWriter(stdin)
	r.closer = stdin

	stdout, err := cmd.StdoutPipe()
	if err != nil {
		panic(err)
	}
	r.stdout = bufio.NewReader(stdout)

	stderr, err := cmd.StderrPipe()
	if err != nil {
		panic(err)
	}
	r.stderr = bufio.NewReader(stderr)

	r.count = plays.With(labels)
	r.elapsed = elapsed.With(labels)
	r.durationBucket = durationBucket.With(labels)

	return r
}

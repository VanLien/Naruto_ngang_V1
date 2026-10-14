package anti_cheat

import (
	"bufio"
	"fmt"
	"io"
	"os/exec"
	"strings"
	"time"
	"tjgame/document"
	"tjgame/server_framework/tj/log"
	"tjgame/ugorji_go/codec"

	"github.com/prometheus/client_golang/prometheus"
)

type ProxyRunner struct {
	idx int
	num int64

	runtimes time.Duration

	cmd    *exec.Cmd
	stdin  *bufio.Writer
	stdout *bufio.Reader
	stderr *bufio.Reader

	decoder *codec.Decoder // result decoder

	closer io.Closer

	// metric
	elapsed        prometheus.Counter
	count          prometheus.Counter
	durationBucket prometheus.Observer
}

func (r *ProxyRunner) Start() error {
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

type Result struct {
	Result    string                     `codec:"result"`
	Point1    int                        `codec:"point1"`
	Point2    int                        `codec:"point2"`
	States    map[document.ID][2]float64 `codec:"states"`
	Damages   map[document.Integer]int   `codec:"damages"`
	Traceback string                     `codec:"traceback"`
}

func (r *ProxyRunner) Run(record *Record) {
	s1 := time.Now()
	identify := fmt.Sprintf("%s_%d", record.servKey, record.id)
	length := len(record.PlayRecord)
	in := fmt.Sprintf("%s %d %d %s\n", identify, record.Type, length, record.PlayRecord)
	if nn, err := r.stdin.WriteString(in); err != nil {
		log.Warningf("Write stdin %d %v", nn, err)
	}
	r.stdin.Flush()

	// read result from stderr
	var result Result
	err := r.decoder.Decode(&result)
	if err != nil {
		log.Warningf("Runner[%d] decoder from stderr error %v", r.idx, err)
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

	if record.Result != "" {
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
}

func (r *ProxyRunner) Stop() {
	if err := r.closer.Close(); err != nil {
		log.Errorf("Close Runner[%d] error %v", r.idx, err)
	}
	if err := r.cmd.Wait(); err != nil {
		log.Errorf("Stop Runner[%d] error %v", r.idx, err)
	}
}

var handle = &codec.MsgpackHandle{RawToString: true}

func NewProxyRunner(idx int, labels prometheus.Labels) *ProxyRunner {
	r := &ProxyRunner{
		idx: idx,
	}
	cmd := exec.Command(agentBinary)
	r.cmd = cmd

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

	r.decoder = codec.NewDecoder(stderr, handle)

	r.count = plays.With(labels)
	r.elapsed = elapsed.With(labels)
	r.durationBucket = durationBucket.With(labels)
	return r
}

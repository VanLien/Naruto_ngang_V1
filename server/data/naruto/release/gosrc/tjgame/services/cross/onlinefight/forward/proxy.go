package forward

import (
	"bufio"
	"context"
	"fmt"
	"io"
	"os"
	"os/exec"
	"runtime"
	"strconv"
	"strings"
	"sync"
	"sync/atomic"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/util"
	"tjgame/ugorji_go/codec"
)

var (
	scriptPath   = "game_scripts"
	agentBinary  = "./agent"
	luajit       = "luajit"
	currentPatch = 0
)

func init() {
	if runtime.GOOS == "windows" {
		luajit = "../luajit.exe"
	}
}

func SetScriptPath(path string) {
	if path != "" {
		scriptPath = path
	}
}

func SetAgentBinary(path string) {
	if path != "" {
		agentBinary = path
	}
}

type ProxyRunnerRequest struct {
	_struct struct{} `codec:",toarray"`

	ID     document.ID
	Length int
	Data   []byte
}

type ProxyRunnerResponse struct {
	//_struct struct{} `codec:",toarray"`

	ID        document.ID `codec:"id"`
	Next      int         `codec:"next"`
	Result    string      `codec:"result"`
	Wonderful bool        `codec:"wonderful"`
	Status    []byte      `codec:"status"`
	RandCnt   int         `codec:"rand_cnt"`
	Traceback string      `codec:"traceback"`
}

type ProxyRunner interface {
	StartBattle(record *scheme.CrossOnlineFightPlayRecord) (*ProxyRunnerResponse, error)
	Attack(id document.ID, current int, target int, skill int) (*ProxyRunnerResponse, error)
	CloseBattle(id document.ID) (*ProxyRunnerResponse, error)
}

type AntiProxyRunner struct {
	idx uint32
	mu  sync.Mutex

	cmd    *exec.Cmd
	stdin  *bufio.Writer
	stdout *bufio.Reader
	stderr *bufio.Reader

	decoder *codec.Decoder // output decoder

	closer io.Closer

	patch   int
	current int
	exited  bool // if true, no battle will auto stop runner

	ctx    context.Context
	cancel context.CancelFunc
}

func (r *AntiProxyRunner) Start() error {
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
					if err == os.ErrClosed || strings.HasSuffix(err.Error(), "file already closed") {
						break
					}
				}
			}
		}()
	}
	return err
}

func (r *AntiProxyRunner) Stop() {
	log.Infof("Stopping Runner[%d]", r.idx)
	if err := r.closer.Close(); err != nil {
		log.Errorf("Close Runner[%d] error %v", r.idx, err)
	}
	if err := r.cmd.Wait(); err != nil {
		log.Errorf("Stop Runner[%d] error %v", r.idx, err)
	}
}

func (r *AntiProxyRunner) recv() (*ProxyRunnerResponse, error) {
	var response ProxyRunnerResponse
	if err := r.decoder.Decode(&response); err != nil {
		return nil, err
	}
	return &response, nil
}

func (r *AntiProxyRunner) write(head string, data []byte) error {
	var err error
	var nn int
	nn, err = r.stdin.WriteString(head)
	if err == nil {
		nn, err = r.stdin.Write(data)
	}
	if err == nil {
		nn, err = r.stdin.WriteString("\n")
	}
	if err != nil {
		log.Warningf("Write stdin %d %v", nn, err)
	}
	r.stdin.Flush()
	log.Debugf("write to agent length %d+%d", len(head), len(data))
	return err
}

func (r *AntiProxyRunner) cancelWhenError(err error) {
	if err != nil {
		r.cancel()
	}
}

func (r *AntiProxyRunner) StartBattle(record *scheme.CrossOnlineFightPlayRecord) (*ProxyRunnerResponse, error) {
	data, err := util.MsgPack(record)
	if err != nil {
		return nil, err
	}
	r.mu.Lock()
	defer r.mu.Unlock()

	v := &ProxyRunnerRequest{
		ID:     record.ID,
		Length: len(data),
		Data:   data,
	}
	in := fmt.Sprintf("%s %s %d\n", "start", string(v.ID), v.Length)
	if err = r.write(in, v.Data); err != nil {
		r.cancelWhenError(err)
		return nil, err
	}
	response, err := r.recv()
	r.current += 1
	r.cancelWhenError(err)
	return response, err
}

func (r *AntiProxyRunner) Attack(id document.ID, current int, target int, skill int) (*ProxyRunnerResponse, error) {
	data, err := util.MsgPack([]int{current, target, skill})
	if err != nil {
		return nil, err
	}
	r.mu.Lock()
	defer r.mu.Unlock()

	v := &ProxyRunnerRequest{
		ID:     id,
		Length: len(data),
		Data:   data,
	}
	in := fmt.Sprintf("%s %s %d\n", "input", string(v.ID), v.Length)
	if err = r.write(in, v.Data); err != nil {
		r.cancelWhenError(err)
		return nil, err
	}

	response, err := r.recv()
	r.cancelWhenError(err)
	return response, err
}

func (r *AntiProxyRunner) CloseBattle(id document.ID) (*ProxyRunnerResponse, error) {
	r.mu.Lock()
	defer r.mu.Unlock()

	v := &ProxyRunnerRequest{
		ID:     id,
		Length: 0,
		Data:   []byte{},
	}
	in := fmt.Sprintf("%s %s %d\n", "close", string(v.ID), v.Length)
	if err := r.write(in, v.Data); err != nil {
		return nil, err
	}

	response, err := r.recv()
	r.current -= 1
	log.Debugf("Runner %d, patch %d, current %d, exited %v", r.idx, r.patch, r.current, r.exited)
	if r.exited && r.current == 0 {
		r.Stop()
	}
	return response, err
}

func (r *AntiProxyRunner) Done() <-chan struct{} {
	return r.ctx.Done()
}

func (r *AntiProxyRunner) NoBattleStop() {
	r.mu.Lock()
	defer r.mu.Unlock()
	r.exited = true
	if r.current == 0 {
		r.Stop()
	}
}

var handle = &codec.MsgpackHandle{RawToString: true}
var idx uint32

func NewAntiProxyRunner(patch int) *AntiProxyRunner {
	r := &AntiProxyRunner{
		idx:   atomic.AddUint32(&idx, 1),
		patch: patch,
	}
	cmd := exec.Command(agentBinary, "-m", "realtime", "-p", scriptPath)
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

	r.ctx, r.cancel = context.WithCancel(context.Background())

	return r
}

type AntiProxyLuaRunner struct {
	idx uint32
	mu  sync.Mutex

	cmd    *exec.Cmd
	stdin  *bufio.Writer
	stdout *bufio.Reader
	stderr *bufio.Reader

	closer io.Closer

	patch   int
	current int
	exited  bool // if true, no battle will auto stop runner
}

func (r *AntiProxyLuaRunner) Start() error {
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
					if err == os.ErrClosed || strings.HasSuffix(err.Error(), "file already closed") {
						break
					}
				}
			}
		}()
	}
	return err
}

func (r *AntiProxyLuaRunner) Stop() {
	log.Infof("Stopping Runner[%d]", r.idx)
	if err := r.closer.Close(); err != nil {
		log.Errorf("Close Runner[%d] error %v", r.idx, err)
	}
	if err := r.cmd.Wait(); err != nil {
		log.Errorf("Stop Runner[%d] error %v", r.idx, err)
	}
}

func (r *AntiProxyLuaRunner) StartBattle(record *scheme.CrossOnlineFightPlayRecord) (*ProxyRunnerResponse, error) {
	data, err := util.MsgPack(record)
	if err != nil {
		return nil, err
	}
	r.mu.Lock()
	defer r.mu.Unlock()
	return r.tolua(record.ID, "start", data)
}

func (r *AntiProxyLuaRunner) Attack(id document.ID, current int, target int, skill int) (*ProxyRunnerResponse, error) {
	data, err := util.MsgPack([]int{current, target, skill})
	if err != nil {
		return nil, err
	}
	r.mu.Lock()
	defer r.mu.Unlock()
	return r.tolua(id, "input", data)
}

func (r *AntiProxyLuaRunner) CloseBattle(id document.ID) (*ProxyRunnerResponse, error) {
	return r.tolua(id, "close", []byte{})
}

func (r *AntiProxyLuaRunner) tolua(id document.ID, action string, data []byte) (*ProxyRunnerResponse, error) {
	// write id
	n, err := r.stdin.WriteString(string(id))
	if err != nil || n != len(id) {
		log.Warningf("write id %v error %v", id, err)
		return nil, err
	}
	// write action and data length
	head := fmt.Sprintf("%s\n%d\n", action, len(data))
	n, err = r.stdin.WriteString(head)
	if err != nil || n != len(head) {
		log.Warningf("write action %s error %v", action, err)
		return nil, err
	}
	// write date
	n, err = r.stdin.Write(data)
	if err != nil || n != len(data) {
		log.Warningf("write data error %v, total %d, write %d", err, len(data), n)
		return nil, err
	}
	r.stdin.Flush()
	return r.fromlua()
}

func (r *AntiProxyLuaRunner) fromlua() (*ProxyRunnerResponse, error) {
	data, err := r.stderr.ReadBytes('\n')
	if err != nil {
		return nil, err
	}
	num, err := strconv.Atoi(string(data[:len(data)-1]))
	if err != nil {
		return nil, err
	}
	data = make([]byte, num)
	_, err = io.ReadFull(r.stderr, data)
	if err != nil {
		return nil, err
	}
	response := &ProxyRunnerResponse{}
	err = util.MsgUnpack(data, response)
	return response, err
}

func (r *AntiProxyLuaRunner) NoBattleStop() {
	r.mu.Lock()
	defer r.mu.Unlock()
	r.exited = true
	if r.current == 0 {
		r.Stop()
	}
}

func NewAntiProxyLuaRunner(patch int) *AntiProxyLuaRunner {
	r := &AntiProxyLuaRunner{
		idx:   atomic.AddUint32(&idx, 1),
		patch: patch,
	}

	cmd := exec.Command(luajit, "anti_main.lua", "--onlinefight")
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

	return r
}

type FakeProxyRunner struct {
	who   int
	count int
}

func (r *FakeProxyRunner) StartBattle(record *scheme.CrossOnlineFightPlayRecord) (*ProxyRunnerResponse, error) {
	r.who = 1
	return r.response(), nil
}

func (r *FakeProxyRunner) Attack(id document.ID, current int, target int, skill int) (*ProxyRunnerResponse, error) {
	r.count++
	r.who++
	r.who = (r.who-1)%12 + 1
	return r.response(), nil
}

func (r *FakeProxyRunner) CloseBattle(id document.ID) (*ProxyRunnerResponse, error) {
	return nil, nil
}

func (r *FakeProxyRunner) response() *ProxyRunnerResponse {
	if r.count >= 24 {
		return &ProxyRunnerResponse{
			Result: ResultWin,
		}
	}
	return &ProxyRunnerResponse{
		Next: r.who,
	}
}

type ResumeProxyRunner struct {
	battle *Battle
	who    chan int
}

func (r *ResumeProxyRunner) StartBattle(record *scheme.CrossOnlineFightPlayRecord) (*ProxyRunnerResponse, error) {
	return r.response(), nil
}

func (r *ResumeProxyRunner) Attack(id document.ID, current int, target int, skill int) (*ProxyRunnerResponse, error) {
	return r.response(), nil
}

func (r *ResumeProxyRunner) CloseBattle(id document.ID) (*ProxyRunnerResponse, error) {
	return nil, nil
}

func (r *ResumeProxyRunner) response() *ProxyRunnerResponse {
	r.battle.broadcast(0) // 先通知客户端，让客户端运算下去，以便发送next

	who := <-r.who
	return &ProxyRunnerResponse{
		Next: who,
	}
}

func (r *ResumeProxyRunner) Resume(who int) {
	r.who <- who
}

func NewResumeProxyRunner(battle *Battle) ProxyRunner {
	return &ResumeProxyRunner{
		battle: battle,
		who:    make(chan int),
	}
}

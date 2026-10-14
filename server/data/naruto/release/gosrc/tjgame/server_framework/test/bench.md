## 2019/02/25

```
goos: windows
goarch: amd64
pkg: server_framework/test
Benchmark_NativeCall-8       	100000000	        16.7 ns/op	       8 B/op	       1 allocs/op
Benchmark_NativeCallInGo-8   	  100000	       215 ns/op	       8 B/op	       1 allocs/op
Benchmark_Call-8             	 1000000	      1324 ns/op	     440 B/op	       9 allocs/op
Benchmark_CallInGo-8         	  100000	       765 ns/op	     440 B/op	       9 allocs/op
Benchmark_PingPong-8         	   50000	     24890 ns/op	    2794 B/op	      64 allocs/op
Benchmark_NSQPingPong-8      	    5000	    262600 ns/op	    8712 B/op	     163 allocs/op
PASS
ok  	server_framework/test	10.322s
```

## 2019/02/26

#### 1. pack、unpack直接返回[]byte

只留了unpackResp一处

allocs下降，但消耗没啥变动

```
Benchmark_NSQPingPong-8   	    5000	    271000 ns/op	    6440 B/op	     128 allocs/op
```

#### 2. pack、unpack只返回2字节[]byte

```
Benchmark_NSQPingPong-8   	    5000	    287100 ns/op	    6747 B/op	     131 allocs/op
```

#### 2019/02/27

受nsq -mem-queue-size配置影响，配置不匹配会导致写入磁盘，吞吐变低。

`Producer`内部设计问题，只采用单链接，单goroutine，无buff的chan，在大量请求下导致socket的recv或send buffer写满，无法进行正常发送请求，导致超时链接被关闭，msg无法发出。

暂时先不处理，benchmark的测试包数量大且并发高导致。后续还是要优化，包括异常处理。

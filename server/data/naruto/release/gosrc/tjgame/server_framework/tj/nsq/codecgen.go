//+build generate

package nsq

//go:generate codecgen -o message.generated.go -r rpcMessage message.go

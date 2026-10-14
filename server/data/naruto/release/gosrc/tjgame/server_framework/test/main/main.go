package main

import (
	"fmt"
	"regexp"
	"strings"
)

func main() {
	fmt.Println(regexp.MatchString("login.en*", "login.en.1"))
	fmt.Println(regexp.MatchString("login.en.*", "login.en.1"))
	fmt.Println(regexp.MatchString("login.en.[0-9]+", "login.en.1"))
	fmt.Println(regexp.MatchString("login.en.[0-9]+", "login.en.xxx"))
	fmt.Println(regexp.MatchString("login.en.[0-9]+", "login.en.a"))

	s := "login.en.1"
	arr := strings.Split(s, ".")
	for i, v := range arr {
		fmt.Println(i, v)
	}
}

package util

import (
	"fmt"
	"net/http"
	"strings"
)

func SendToDingDing(url, title, content string) bool {
	body := `{
	 "msgtype": "markdown",
	 "markdown": {
		 "title": "%s",
		 "text": "%s"
	 }
 }`
	content = fmt.Sprintf("## %s\\n", title) + strings.ReplaceAll(content, "\n", "\\n")
	body = fmt.Sprintf(body, title, content)
	req, err := http.NewRequest("POST", url, strings.NewReader(body))
	if err != nil {
		return false
	}
	req.Header.Set("Content-Type", "application/json;charset=utf-8")
	res, err := http.DefaultClient.Do(req)
	if err != nil {
		return false
	}
	defer res.Body.Close()

	if res.StatusCode == 200 {
		return true
	}
	return false
}

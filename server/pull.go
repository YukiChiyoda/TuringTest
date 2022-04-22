package main

import (
	"encoding/json"
	"io/ioutil"
	"net/http"
	"regexp"
)

type api struct {
	Result  int
	Content string
}

func Pull_Question() string {
	temp := "hello"
	Log_Info("拉取到问题：" + temp)
	return "temp"
}

func Pull_Answer(question string) string {
	res, err := http.Get("http://api.qingyunke.com/api.php?key=free&appid=0&msg=" + question)
	if err != nil {
		Log_Error("Bad Error for -2.1")
		return err.Error()
	}
	temp, err := ioutil.ReadAll(res.Body)
	if err != nil {
		Log_Error("Bad Error for -2.2")
		return err.Error()
	}
	var text api
	json.Unmarshal(temp, &text)
	sub, _ := regexp.Compile("{.*?}")
	text.Content = sub.ReplaceAllString(text.Content, "")
	Log_Info("拉取到AI作答：" + text.Content)
	return text.Content
}

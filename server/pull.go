package main

import (
	"bufio"
	"encoding/json"
	"io"
	"io/ioutil"
	"math/rand"
	"net/http"
	"os"
	"regexp"
	"strings"
)

type api struct {
	Result  int
	Content string
}

func Pull_Question() string {
	file, err := os.Open("./question.txt")
	if err != nil {
		Log_Error("Bad Error for -3.1")
		return err.Error()
	}
	defer file.Close()
	cache := bufio.NewReader(file)
	var text []string
	for {
		line, err := cache.ReadString('\n')
		if (err != nil || err == io.EOF) && line == "" {
			break
		}
		//Log_Debug(line)
		line = strings.TrimSpace(line)
		text = append(text, line)
	}
	result := text[rand.Intn(len(text))]
	Log_Info("拉取到随机问题：" + result)
	return result
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

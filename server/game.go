package main

import (
	"encoding/json"
	"io/ioutil"
	"math/rand"
	"strconv"
	"time"
)

type data struct {
	Id   int
	Text string
}

type jsoner struct {
	Status    string
	Timestamp string
	Question  string
	Length    int
	Target    int
	Answer    int
	Data      []data
}

var JSON jsoner

func game_init() {
	timestamp := time.Now().Unix()

	JSON.Status = "100"
	JSON.Timestamp = strconv.FormatInt(timestamp, 10)
	JSON.Question = Pull_Question()
	JSON.Length = 0
	JSON.Answer = -1
	JSON.Data = nil

	Log_Info("初始化完成")
}

func update_json() {
	timestamp := time.Now().Unix()
	JSON.Timestamp = strconv.FormatInt(timestamp, 10)

	// [2022-05-17] JSON答案位置随机化
	rand.Seed(time.Now().Unix())
	rand.Shuffle(len(JSON.Data), func(i, j int){JSON.Data[i], JSON.Data[j] = JSON.Data[j], JSON.Data[i]})

	jsonByte, err := json.Marshal(JSON)
	if err == nil {
		err = ioutil.WriteFile("./status.json", jsonByte, 0777)
		if err != nil {
			Log_Error(err.Error())
		}
		Log_Info("状态已被更新")
	}
}

func New_Game(length int) {
	JSON.Target = length
	game_init()
	update_json()
	go New_Answer(JSON.Question, true)
}

func New_Answer(text string, AI bool) {
	var temp data
	if AI {
		temp.Text = Pull_Answer(text)
		temp.Id = JSON.Length
		JSON.Answer = temp.Id
	} else {
		temp.Id = JSON.Length
		temp.Text = text
	}
	Log_Info("采集到新样本：" + temp.Text)
	JSON.Data = append(JSON.Data, temp)
	JSON.Length += 1
	if JSON.Length >= JSON.Target {
		Log_Info("样本采集数已达到目标")
		JSON.Status = "200"
	}
	update_json()
}

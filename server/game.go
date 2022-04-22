package main

import (
	"encoding/json"
	"io/ioutil"
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
	Answer    int
	Data      []data
}

var JSON jsoner
var LENG int

func game_init() {
	timestamp := time.Now().Unix()

	JSON.Status = "100"
	JSON.Timestamp = strconv.FormatInt(timestamp, 10)
	JSON.Question = "Are you a robot?"
	JSON.Length = 0
	JSON.Answer = -1
	JSON.Data = nil
	/*
		JSON.length = 4
		JSON.answer = -1
		for i := 0; i < JSON.length; i++ {
			JSON.data[i].Id = i
			JSON.data[i].Text = "I'm a robot."
		}
	*/

	LENG = 0
	Log_Debug("4")
}

func update_json() {
	timestamp := time.Now().Unix()
	JSON.Timestamp = strconv.FormatInt(timestamp, 10)

	jsonByte, err := json.Marshal(JSON)
	if err == nil {
		ioutil.WriteFile("./status.json", jsonByte, 0)
	}
	Log_Debug("3")
}

func New_Game(length int) {
	LENG = length
	game_init()
	update_json()
	Log_Debug("2")
}

func New_Answer(text string) {
	var temp data
	temp.Id = JSON.Length
	temp.Text = text
	JSON.Data = append(JSON.Data, temp)
	JSON.Length += 1
	if JSON.Length >= LENG {
		JSON.Status = "200"
	}
	update_json()
	Log_Debug("1")
}

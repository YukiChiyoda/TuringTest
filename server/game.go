package main

import (
	"encoding/json"
	"io/ioutil"
	"strconv"
	"time"
)

type data struct {
	id   int
	text string
}

type jsoner struct {
	status    string
	timestamp string
	question  string
	length    int
	answer    int
	data      []data
}

var JSON jsoner
var LENG int

func init() {
	timestamp := time.Now().Unix()

	JSON.status = "000"
	JSON.timestamp = strconv.FormatInt(timestamp, 10)
	JSON.question = "Are you a robot?"
	JSON.length = 0
	JSON.answer = -1
	JSON.data = nil
	/*
		JSON.length = 4
		JSON.answer = -1
		for i := 0; i < JSON.length; i++ {
			JSON.data[i].id = i
			JSON.data[i].text = "I'm a robot."
		}
	*/

	LENG = 0
}

func update_json() {
	timestamp := time.Now().Unix()
	JSON.timestamp = strconv.FormatInt(timestamp, 10)

	jsonByte, err := json.Marshal(JSON)
	if err == nil {
		ioutil.WriteFile("./status.json", jsonByte, 0)
	}
}

func New_Game(length int) {
	LENG = length
	JSON.status = "100"
	JSON.question = "Test Question"
	update_json()
}

func New_Answer(text string) {
	var temp data
	temp.id = JSON.length
	temp.text = text
	JSON.data = append(JSON.data, temp)
	JSON.length += 1
	if JSON.length >= LENG {
		JSON.status = "200"
	}
	update_json()
}

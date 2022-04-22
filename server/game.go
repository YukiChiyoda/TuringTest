package main

import (
	"encoding/json"
	"fmt"
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
	Target    int
	Answer    int
	Data      []data
}

var JSON jsoner

func game_init() {
	timestamp := time.Now().Unix()

	JSON.Status = "100"
	JSON.Timestamp = strconv.FormatInt(timestamp, 10)
	JSON.Question = "Are you a robot?"
	JSON.Length = 0
	JSON.Answer = -1
	JSON.Data = nil
}

func update_json() {
	timestamp := time.Now().Unix()
	JSON.Timestamp = strconv.FormatInt(timestamp, 10)

	jsonByte, err := json.Marshal(JSON)
	if err == nil {
		ioutil.WriteFile("./status.json", jsonByte, 0)
	}
}

func New_Game(length int) {
	JSON.Target = length
	game_init()
	update_json()
}

func New_Answer(text string) {
	var temp data
	temp.Id = JSON.Length
	temp.Text = text
	JSON.Data = append(JSON.Data, temp)
	JSON.Length += 1
	fmt.Println(JSON.Target)
	if JSON.Length >= JSON.Target {
		JSON.Status = "200"
	}
	update_json()
}

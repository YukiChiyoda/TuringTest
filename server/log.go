package main

import (
	"log"
	"time"
)

var timer string

func init() {
	timestamp := time.Now().Unix()
	timer = time.Unix(timestamp, 0).Format("2006-01-02 03:04:05")
}

func Log_Debug(message string) {
	//fmt.Printf("[DEBUG] %s\n", message)
	log.Printf("[DEBUG] %s\n", message)
}

func Log_Info(message string) {
	//fmt.Printf("[%v] %s\n", timer, message)
	log.Printf("[INFO] %s\n", message)
}

func Log_Error(message string) {
	//fmt.Printf("[ERROR] %s\n", message)
	log.Fatalf("[ERROR] %s\n", message)
}

package main

import (
	"fmt"
	"time"
)

var timer string

func init() {
	timestamp := time.Now().Unix()
	timer = time.Unix(timestamp, 0).Format("2006-01-02 03:04:05")
}

func Log_Debug(message string) {
	fmt.Printf("[DEBUG] %s\n", message)
}

func Log_Info(message string) {
	fmt.Printf("[%v] %s\n", timer, message)
}

func Log_Error(message string) {
	fmt.Printf("[%v] %s\n", timer, message)
}

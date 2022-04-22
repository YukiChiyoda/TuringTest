package main

import (
	"fmt"
)

func Command_Waiting() {
	for {
		var temp string
		fmt.Scan(&temp)

		switch temp {

		case "next":
			Log_Info("Next Game")

		case "stop":
			fmt.Println("Goodbye! :p")
			fmt.Println("==============================")
			Log_Info("Server Stop")

		default:
			fmt.Println("Command Error!")

		}
	}
}

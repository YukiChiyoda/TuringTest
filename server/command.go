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
			New_Game(4)
			Log_Info("New Game for 4 answers!")

		case "stop":
			fmt.Println("Goodbye! :p")
			fmt.Println("==============================")
			Log_Info("Server Stop")

		default:
			New_Answer(temp)
			Log_Debug("Get an test answer!")
			//fmt.Println("Command Error!")

		}
	}
}

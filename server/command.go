package main

import (
	"fmt"
	"strconv"
)

func Command_Waiting() {
	for {
		var temp string
		fmt.Scan(&temp)

		switch temp {

		case "next":
			var n int
			fmt.Scan(&n)
			New_Game(n)
			Log_Info("准备采集 " + strconv.Itoa(n) + " 样本")

		/*
			case "stop":
				fmt.Println("Goodbye! :p")
				fmt.Println("==============================")
				Log_Info("系统结束运行")
		*/

		default:
			New_Answer(temp, false)
			//fmt.Println("Command Error!")

		}
	}
}

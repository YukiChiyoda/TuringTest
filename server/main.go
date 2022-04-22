package main

import "fmt"

func main() {
	fmt.Println("Hello, Turing Test! :p")
	fmt.Println("Here is the lastest builder from Yuki!")
	fmt.Println("==============================")
	Log_Info("系统开始运行")

	go Server_Build()
	Log_Info("HTTP服务器正在部署")

	Command_Waiting()
	Log_Info("已准备采集控制台命令")
}

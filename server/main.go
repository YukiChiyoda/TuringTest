package main

import "fmt"

func main() {
	fmt.Println("Hello, Turing Test! :p")
	fmt.Println("Here is the lastest builder from Yuki!")
	fmt.Println("==============================")
	Log_Info("Server Start")

	go Server_Build()
	Log_Info("Server Built")

	Command_Waiting()
	Log_Info("Command Waiting")
}

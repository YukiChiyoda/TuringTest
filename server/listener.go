package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
)

func http_index(w http.ResponseWriter, r *http.Request) {
	Log_Info("Received request from " + r.RemoteAddr)
	fmt.Fprintf(w, "Server Running")
}

func http_status(w http.ResponseWriter, r *http.Request) {
	file, _ := ioutil.ReadFile("./status.json")
	fmt.Fprint(w, string(file))
}

func http_push(w http.ResponseWriter, r *http.Request) {

}

func http_answer(w http.ResponseWriter, r *http.Request) {

}

func Server_Build() {
	http.HandleFunc("/", http_index)
	http.HandleFunc("/status.go", http_status)
	http.HandleFunc("/push.go", http_push)
	http.HandleFunc("/answer.go", http_answer)
	if err := http.ListenAndServe(":233", nil); err != nil {
		Log_Error(err.Error())
	}
}

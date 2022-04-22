package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
)

func http_index(w http.ResponseWriter, r *http.Request) {
	Log_Info(r.RemoteAddr + "访问了站点")
	fmt.Fprintf(w, "Server Running")
}

func http_status(w http.ResponseWriter, r *http.Request) {
	file, _ := ioutil.ReadFile("./status.json")
	Log_Info(r.RemoteAddr + "查看了状态")
	fmt.Fprint(w, string(file))
}

func http_push(w http.ResponseWriter, r *http.Request) {
	if temp, err := r.URL.Query()["text"]; !err || len(temp[0]) < 1 {
		fmt.Fprint(w, "-1")
	} else {
		New_Answer(temp[0], false)
		Log_Info(r.RemoteAddr + "提交了答案：" + temp[0])
		fmt.Fprint(w, "0")
	}
}

func http_answer(w http.ResponseWriter, r *http.Request) {
	if temp := r.URL.Query().Get("flag"); len(temp) < 1 {
		fmt.Fprint(w, "-1")
	} else {
		Log_Info(r.RemoteAddr + "作答判定为：" + temp)
		fmt.Fprint(w, "0")
	}
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

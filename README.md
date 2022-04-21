## 客户端开发手册
---
* 以固定的周期向`http://job.hituring.cn/status.go`发送HTTP请求，您将获取到如下格式的JSON文本：
```
```
* 您需要解析其中的信息并将其更新到客户端的前端界面。
---
*该部分功能仅适用于**志愿者客户端***
* 向`http://job.hituring.cn/push.go`发送含POST字段的HTTP请求，其中POST参数包含以下内容：

|参数|描述|
|:---:|:---:|
|text|作答内容|

* 若该页面的返回值非`0`，请将该错误抛出至客户端的前端界面。
---
*该部分功能仅适用于**玩家客户端***
* 玩家在前端页面中作答后，即时判定其作答是否正确，并将其反馈到客户端的前端界面；
* 向`http://job.hituring.cn/answer.go`发送含POST字段的HTTP请求，其中POST参数包含以下内容：

|参数|描述|
|:---:|:---:|
|flag|判定结果(True或False)|

* 若该页面的返回值非`0`，请将该错误抛出至客户端的前端界面。
* **注：**由于我们以固定的周期实时更新前端界面内容，所以您无需设计额外的游戏结束机制。玩家作答完毕后，页面保持原状即可。
---
**Turing Test**
*Yuki*

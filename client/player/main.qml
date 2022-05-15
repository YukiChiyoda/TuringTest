import QtQuick 2.12
import QtQuick.Window 2.3
import QtQuick.Controls 2.9
import QtQuick.Controls.Material 2.9
import QtGraphicalEffects 1.0

Window {
    id: window
    visible: true
    width: 640
    height: 480
    flags: Qt.Window | Qt.FramelessWindowHint

    property int bw: 3
    property int ans: 0
    property int num: 0
    property string ts: ""

    function toggleMaximized() {
        if (window.visibility === Window.Maximized) {
            window.showNormal();
        } else {
            window.showMaximized();
        }
    }

    function request_question() {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                //print('HEADERS_RECEIVED')
            }
            else if(xhr.readyState === XMLHttpRequest.DONE) {
                //print('DONE')
                var json = JSON.parse(xhr.responseText.toString())

                questionText.text = "问题："+json["Question"]
                answer0Text.text = json["Data"][0]["Text"]
                answer1Text.text = json["Data"][1]["Text"]
                ans = json["Answer"]

                if(json["Length"]>=3) {
                    answer2Text.text = json["Data"][2]["Text"]
                    answer2.visible = true
                    answer2Shadow.visible = true
                }
                else {
                    answer2.visible = false
                    answer2Shadow.visible = false
                }

                if(json["Length"]>=4) {
                    answer3Text.text = json["Data"][3]["Text"]
                    answer3.visible = true
                    answer3Shadow.visible = true
                }
                else {
                    answer3.visible = false
                    answer3Shadow.visible = false
                }

                if(ts != json["Timestamp"]) {
                    ts = json["Timestamp"]
                    dialog.visible = false
                    dialogShadow.visible = false
                }
            }
        }
        xhr.open("GET", "http://101.34.210.66:233/status.go")
        xhr.send()
    }

    function check_Answer() {
        dialog.visible = true
        dialogShadow.visible = true
        if(num === ans) {
            dialogText.text = "回答正确！"
            dialogText.color = "#80CBC4"
        }
        else {
            dialogText.text = "回答错误！"
            dialogText.color = "#FFAB91"
        }
        print(ans)
        print(num)
    }

    Timer {
        id: requestQ
        interval: 300
        repeat: true
        running: true
        onTriggered: {
            request_question()
        }
    }

    MouseArea {
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        hoverEnabled: true
        cursorShape: {
            const p = Qt.point(mouseX, mouseY);
            const b = bw + 10;
            if (p.x < b && p.y < b) return Qt.SizeFDiagCursor;
            if (p.x >= width - b && p.y >= height - b) return Qt.SizeFDiagCursor;
            if (p.x >= width - b && p.y < b) return Qt.SizeBDiagCursor;
            if (p.x < b && p.y >= height - b) return Qt.SizeBDiagCursor;
            if (p.x < b || p.x >= width - b) return Qt.SizeHorCursor;
            if (p.y < b || p.y >= height - b) return Qt.SizeVerCursor;
        }
        acceptedButtons: Qt.NoButton
    }

    DragHandler {
        id: resizeHandler
        grabPermissions: TapHandler.TakeOverForbidden
        target: null
        onActiveChanged: if (active) {
                             const p = resizeHandler.centroid.position;
                             const b = bw + 10;
                             let e = 0;
                             if (p.x < b) { e |= Qt.LeftEdge }
                             if (p.x >= width - b) { e |= Qt.RightEdge }
                             if (p.y < b) { e |= Qt.TopEdge }
                             if (p.y >= height - b) { e |= Qt.BottomEdge }
                             window.startSystemResize(e);
                         }
    }

    Image {
        id: bg
        width: window.width
        height: window.height
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
        source: "file:prpr.jpg"
    }

    ToolBar {
        Material.background: Material.Cyan
        id: toolBar
        width: parent.width-2*bw
        height: 30
        x:bw;y:bw
        Item {
            anchors.fill: parent
            anchors.leftMargin: -6
            TapHandler {
                onTapped: if (tapCount === 2) toggleMaximized()
                gesturePolicy: TapHandler.DragThreshold
            }
            DragHandler {
                grabPermissions: TapHandler.CanTakeOverFromAnything
                onActiveChanged: if (active) { window.startSystemMove(); }
            }
        }

        Rectangle {
            id: title
            x: 5
            y: 20
            width: titleText.paintedWidth+10
            height: titleText.paintedHeight+10
            radius: 20
            color: "white"
            
            Text {
                x: 5
                y: 5
                id: titleText
                text: qsTr("TuringText-Player")
                font.pixelSize: 25
                font.bold: true
                font.family: "微软雅黑"
            }
        }

        DropShadow {
            anchors.fill: source
            horizontalOffset: 3
            verticalOffset: 3
            samples: 17
            color: "#80000000"
            source: title
        }

        RoundButton {
            id: roundButton
            x: toolBar.availableWidth-80
            y: 0
            text: "<font color=\"black\">-</font>"

            onClicked: {
                window.showMinimized()
            }
        }

        RoundButton {
            id: roundButton1
            x: toolBar.availableWidth-40
            y: 0
            text: "<font color=\"black\">x</font>"

            onClicked: {
                close()
            }
        }
    }

    Rectangle {
        id: question
        x: toolBar.availableWidth/2-questionText.text.length*questionText.font.pixelSize
        y: window.height/5.5
        width: questionText.paintedWidth+6
        height: questionText.paintedHeight+6
        color: "#A5D6A7"
        radius: 10

        Text {
            x: 3
            y: 3
            id: questionText
            text: qsTr("问题：")
            font.pixelSize: 20
            font.bold: true
            font.strikeout: false
            font.family: "微软雅黑"
        }
    }

    DropShadow {
        anchors.fill: source
        horizontalOffset: 3
        verticalOffset: 3
        samples: 17
        color: "#80000000"
        source: question
    }

    Rectangle {
        id: text
        x: toolBar.availableWidth/2-text1.text.length*text1.font.pixelSize/2-50
        y: question.y+text1.height+15
        width: text1.paintedWidth+4
        height: text1.paintedHeight+4
        color: "#A5D6A7"
        radius: 10

        Text {
            x: 2
            y: 2
            id: text1
            width: 60
            height: 25
            text: "你认为哪个是机器人的回答？"
            font.pixelSize: 20
            //font.bold: true
            font.family: "微软雅黑"
        }
    }

    DropShadow {
        anchors.fill: text
        horizontalOffset: 3
        verticalOffset: 3
        samples: 17
        color: "#80000000"
        source: text
    }

    Rectangle {
        id: answer0
        x: text.x
        y: text.y+alpha0.height+30
        width: alpha0.paintedWidth+answer0Text.paintedWidth+10
        height: alpha0.paintedHeight+6
        color: "#AFEEEE"
        radius: 10

        Text {
            id: alpha0
            x: 3
            y: 3
            text: qsTr("A.")
            font.pixelSize: 22
            //font.bold: true
            font.family: "微软雅黑"
        }

        Text {
            id: answer0Text
            x: alpha0.x+alpha0.paintedWidth
            y: alpha0.y
            text: qsTr("")
            font.pixelSize: 22
            //font.bold: true
            font.family: "微软雅黑"
        }

        RoundButton {
            id: answer0Button
            x: answer0Text.x+answer0Text.paintedWidth+10
            y: -5
            text: "<-"
            Material.background: Material.Cyan

            onClicked: {
                num = 0
                check_Answer()
            }
        }
    }

    DropShadow {
        id: answer0Shadow
        anchors.fill: source
        horizontalOffset: 3
        verticalOffset: 3
        samples: 17
        color: "#80000000"
        source: answer0
    }

    Rectangle {
        id: answer1
        x: text.x
        y: answer0.y+answer1.height+15
        width: alpha1.paintedWidth+answer1Text.paintedWidth+10
        height: alpha1.paintedHeight+6
        color: "#AFEEEE"
        radius: 10

        Text {
            id: alpha1
            x: 3
            y: 3
            text: qsTr("B.")
            font.pixelSize: 22
            //font.bold: true
            font.family: "微软雅黑"
        }

        Text {
            id: answer1Text
            x: alpha1.x+alpha1.paintedWidth
            y: alpha1.y
            text: qsTr("")
            font.pixelSize: 22
            //font.bold: true
            font.family: "微软雅黑"
        }

        RoundButton {
            id: answer1Button
            x: answer1Text.x+answer1Text.paintedWidth+10
            y: -5
            text: "<-"
            Material.background: Material.Cyan

            onClicked: {
                num = 1
                check_Answer()
            }
        }
    }

    DropShadow {
        id: answer1Shadow
        anchors.fill: source
        horizontalOffset: 3
        verticalOffset: 3
        samples: 17
        color: "#80000000"
        source: answer1
    }

    Rectangle {
        id: answer2
        x: text.x
        y: answer1.y+answer2.height+15
        width: alpha2.paintedWidth+answer2Text.paintedWidth+10
        height: alpha2.paintedHeight+6
        color: "#AFEEEE"
        radius: 10
        visible: false

        Text {
            id: alpha2
            x: 3
            y: 3
            text: qsTr("C.")
            font.pixelSize: 22
            //font.bold: true
            font.family: "微软雅黑"
        }

        Text {
            id: answer2Text
            x: alpha2.x+alpha2.paintedWidth
            y: alpha2.y
            text: qsTr("")
            font.pixelSize: 22
            //font.bold: true
            font.family: "微软雅黑"
        }

        RoundButton {
            id: answer2Button
            x: answer2Text.x+answer2Text.paintedWidth+10
            y: -5
            text: "<-"
            Material.background: Material.Cyan

            onClicked: {
                num = 2
                check_Answer()
            }
        }
    }

    DropShadow {
        id: answer2Shadow
        anchors.fill: source
        horizontalOffset: 3
        verticalOffset: 3
        samples: 17
        color: "#80000000"
        source: answer2
        visible: false
    }

    Rectangle {
        id: answer3
        x: text.x
        y: answer2.y+answer3.height+15
        width: alpha3.paintedWidth+answer3Text.paintedWidth+10
        height: alpha3.paintedHeight+6
        color: "#AFEEEE"
        radius: 10
        visible: false

        Text {
            id: alpha3
            x: 3
            y: 3
            text: qsTr("D.")
            font.pixelSize: 22
            //font.bold: true
            font.family: "微软雅黑"
        }

        Text {
            id: answer3Text
            x: alpha3.x+alpha3.paintedWidth
            y: alpha3.y
            text: qsTr("")
            font.pixelSize: 22
            //font.bold: true
            font.family: "微软雅黑"
        }

        RoundButton {
            id: answer3Button
            x: answer3Text.x+answer3Text.paintedWidth+10
            y: -5
            text: "<-"
            Material.background: Material.Cyan

            onClicked: {
                num = 3
                check_Answer()
            }
        }
    }

    DropShadow {
        id: answer3Shadow
        anchors.fill: source
        horizontalOffset: 3
        verticalOffset: 3
        samples: 17
        color: "#80000000"
        source: answer3
        visible: false
    }

    Rectangle {
        id: dialog
        x: answer3.x
        y: answer3.y+50
        width: dialogText.paintedWidth+10
        height: dialogText.paintedHeight+10
        color: "white"
        radius: 15
        visible: false

        Text {
            x: 5
            y: 5
            id: dialogText
            text: ""
            font.pixelSize: 50
            font.bold: true
            font.family: "微软雅黑"
        }
    }

    DropShadow {
        id: dialogShadow
        anchors.fill: source
        horizontalOffset: 3
        verticalOffset: 3
        samples: 17
        color: "#80000000"
        source: dialog
        visible: false
    }
}

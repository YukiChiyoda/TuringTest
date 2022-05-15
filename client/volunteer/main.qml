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
    property string ques: ""

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

                   if(ques !== json["Question"]) {
                       dialog.visible = false
                       dialogShadow.visible = false
                       ques = json["Question"]
                   }
               }
           }
           xhr.open("GET", "http://101.34.210.66:233/status.go")
           xhr.send()
       }

    function push() {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                print('HEADERS_RECEIVED')
            }
            else if(xhr.readyState === XMLHttpRequest.DONE) {
                print('DONE')
                if (xhr.responseText.toString() === "0") {
                    dialogText.text = "录入成功"
                    dialogText.color = "#80CBC4"
                    dialog.visible = true
                    dialogShadow.visible = true
                }
                else {
                    dialogText.text = "录入失败"
                    dialogText.color = "#FFAB91"
                    dialog.visible = true
                    dialogShadow.visible = true
                }

            }
        }
        xhr.open("GET", "http://101.34.210.66:233/push.go?text="+inputText.text)
        xhr.send()
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

            Text {
                x: 5
                y: 5
                id: titleText
                text: qsTr("TuringText-Volunteer")
                font.pixelSize: 25
                font.bold: true
                font.family: "微软雅黑"
            }
        }

        DropShadow {
                id: titleShadow
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
        x: input.x
        y: input.y-35
        width: questionText.paintedWidth+6
        height: questionText.paintedHeight+6
        color: "white"
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
        id: input
        width: window.width*0.5
        height: 40
        x: (window.width-input.width-inputButton.width)/2
        y:window.height/3
        color: "white"
        radius: 5

        TextInput {
            id: inputText
            x: 10
            y: 5
            width: input.width-5
            height: input.height
            anchors.margins: 2
            font.pointSize: 15
            font.family: "微软雅黑"
            focus: true
            maximumLength: 15
        }
    }

    DropShadow {
            id: inputShadow
            anchors.fill: source
            horizontalOffset: 3
            verticalOffset: 3
            samples: 17
            color: "#80000000"
            source: input
    }

    Button {
        id: inputButton
        x: input.x+input.width+10
        y: input.y
        width: 60
        height: input.height
        text: qsTr("录入")

        onClicked: {
            push()
        }
    }

    Rectangle {
        id: dialog
        x: (window.width-dialog.width)/2
        y: window.height*0.6
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
            font.pixelSize: 40
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

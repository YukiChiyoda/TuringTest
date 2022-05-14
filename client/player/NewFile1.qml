import QtQuick 2.12
import QtQuick.Window 2.3
import QtQuick.Controls 2.9
import QtQuick.Controls.Material 2.9

Window {
    id: window
    visible: true
    width: 640
    height: 480
    flags: Qt.Window | Qt.FramelessWindowHint
    Material.background: Material.Cyan

    property int bw: 3
    property bool flag: true
    property string ans: "A"

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
                print('HEADERS_RECEIVED')
            }
            else if(xhr.readyState === XMLHttpRequest.DONE) {
                print('DONE')
                flag = false;
                var json = JSON.parse(xhr.responseText.toString())

                questionText.text = "问题："+json["Question"]
                answer0Text.text = json["Data"][0]["Text"]
                answer1Text.text = json["Data"][1]["Text"]
            }
        }
        xhr.open("GET", "http://101.34.210.66:233/status.go")
        xhr.send()
    }

    function request_Answer() {
        flag = true;
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {

        }
    }

    Timer {
        id: requestQ
        interval: 300
        repeat: true
        onTriggered: {
            request_question()
        }
    }

    Timer {
        id: monitor
        interval: 300
        repeat: true
        running: true
        onTriggered: {
            if(flag) {
                requestQ.start()
            }
            else {
                requestQ.stop()
            }
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
        y: window.height/4
        width: questionText.paintedWidth+6
        height: questionText.paintedHeight+6
        color: "#00BCD4"
        radius: 10

        Text {
            x: 3
            y: 3
            id: questionText
            text: qsTr("问题：")
            font.pixelSize: 20
            font.bold: true
            font.strikeout: false
        }
    }

    Rectangle {
        id: text
        x: toolBar.availableWidth/2-text1.text.length*text1.font.pixelSize
        y: question.y+text1.height+10
        width: text1.paintedWidth
        height: text1.paintedHeight
        color: "#00BCD4"

        Text {
            id: text1
            width: 60
            height: 25
            text: "你认为哪个是人类的回答？"
            font.pixelSize: 15
        }
    }
}

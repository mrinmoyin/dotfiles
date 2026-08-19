import QtQuick
import QtQuick.Controls

Slider {
    id: root

    property string icon: ""
    property color bgColor: "#0fffffff"
    property color handleColor: "#ff9933"

    from: 0
    to: 100
    value: 0
    stepSize: 1
    snapMode: Slider.NoSnap
    orientation: Qt.Vertical

    implicitWidth: 200
    implicitHeight: 36

    background: Rectangle {
        id: bg
        anchors.fill: parent
        radius: 20
        color: root.bgColor
    }

    handle: Rectangle {
        id: hndl
        x: root.availableWidth - width
        y: root.visualPosition * (root.availableHeight - height)
        implicitWidth: bg.width
        implicitHeight: width
        radius: width / 2
        color: "transparent"

        Text {
            anchors.centerIn: parent
            visible: text !== ""
            text: root.icon
            color: "#ffffff"
            font.pixelSize: 24
        }
    }

    Rectangle {
        id: indicator
        z: -1
        width: bg.width
        anchors.top: hndl.top
        anchors.bottom: bg.bottom
        color: root.handleColor
        radius: 20
    }
}

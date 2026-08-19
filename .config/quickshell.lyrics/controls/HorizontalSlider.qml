import QtQuick
import QtQuick.Controls

Slider {
    id: root

    property string icon: ""
    property color bgColor: "#0fffffff"
    property color handleColor: "#E3701B"

    from: 0
    to: 100
    value: 0
    stepSize: 1
    snapMode: Slider.NoSnap

    implicitWidth: 200
    implicitHeight: 36

    background: Rectangle {
        id: bg
        implicitWidth: parent.width
        implicitHeight: parent.height
        radius: 20
        color: root.bgColor
    }

    handle: Rectangle {
        id: hndl
        x: root.visualPosition * (root.availableWidth - width)
        y: (root.availableHeight - height) / 2
        implicitWidth: bg.height
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
        z: -1
        height: bg.height
        anchors.left: bg.left
        anchors.right: hndl.right
        color: root.handleColor
        radius: 20
    }
}

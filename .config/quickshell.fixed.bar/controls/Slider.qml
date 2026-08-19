import QtQuick
import QtQuick.Controls
import "../config"

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

    implicitWidth: 200
    implicitHeight: 36

    background: Rectangle {
        id: bg
        // x: root.leftPadding
        // y: root.topPadding + root.availableHeight / 2 - height / 2
        // implicitWidth: 200
        // implicitHeight: 36
        // anchors.fill: parent
        implicitWidth: parent.width
        implicitHeight: parent.height
        radius: 20
        color: root.bgColor
    }

    handle: Rectangle {
        id: hndl
        // x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
        // y: root.topPadding + root.availableHeight / 2 - (height / 2)
        x: root.vertical ? (root.availableWidth - width) : root.visualPosition * (root.availableWidth - width)
        y: root.vertical ? root.visualPosition * (root.availableHeight - height) : (root.availableHeight - height) / 2
        implicitWidth: root.vertical ? bg.width : bg.height
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
        width: root.vertical ? bg.width : undefined
        height: root.horizontal ? bg.height : undefined
        anchors.left: root.horizontal ? bg.left : undefined
        anchors.right: root.horizontal ? hndl.right : undefined
        anchors.top: root.vertical ? hndl.top : undefined
        anchors.bottom: root.vertical ? bg.bottom : undefined
        // color: !root.enabled ? Qt.alpha(root.handleColor, 0.5) : root.handleColor
        color: root.handleColor
        radius: 20

        Behavior on width {
            NumberAnimation {
                duration: Config.appearence.animationDuration || 500
            }
        }
    }
}

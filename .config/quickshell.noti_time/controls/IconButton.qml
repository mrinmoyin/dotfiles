import QtQuick
import "../config"

Rectangle {
    id: root

    required property string icon
    property int size: 24
    property string desc: ""
    property color iconColor: "#ffffff"
    property color hoveredIconColor: "#E3701B"
    readonly property bool hovered: mouseArea.containsMouse

    signal clicked

    implicitWidth: size + 8
    implicitHeight: implicitWidth
    radius: size

    color: "transparent"
    // color: "#0fffffff"

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }

    Text {
        anchors.centerIn: parent
        visible: text !== ""
        text: root.icon
        font.pixelSize: root.size
        color: (root.enabled && root.hovered) ? root.hoveredIconColor : root.iconColor
        opacity: !root.enabled ? 0.5 : 1

        Behavior on color {
            ColorAnimation {
                duration: Config.appearence.animationDuration || 150
            }
        }
    }
}

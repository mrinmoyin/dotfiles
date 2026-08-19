import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property bool active: false
    property string icon: ""
    property string text: ""
    property string desc: ""
    property color textColor: "#ffffff"
    property color hoveredTextColor: "#E3701B"
    readonly property bool hovered: mouseArea.containsMouse

    signal clicked
    signal rightClicked

    implicitWidth: (content.implicitWidth ?? 0) + (8 * 2)
    implicitHeight: content.implicitHeight + 2
    radius: height / 2

    color: "transparent"

    // color: (active || hovered) ? "#00ff00" : "#0fffffff"
    // Behavior on color {
    //     ColorAnimation {
    //         duration: 200
    //     }
    // }

    RowLayout {
        id: content
        anchors.centerIn: parent
        spacing: 6

        Text {
            visible: root.icon !== ""
            text: root.icon
            font.pixelSize: 24
            color: (root.active || root.hovered) ? root.hoveredTextColor : root.textColor

            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
        }
        Text {
            visible: root.text !== ""
            text: root.text
            color: "#ffffff"
            font.pixelSize: 20

            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            if (mouse.button === Qt.RightButton)
                root.rightClicked();
            else
                root.clicked();
        }
    }
}

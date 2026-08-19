import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

RowLayout {
    id: root
    spacing: 4

    Repeater {
        model: SystemTray.items

        Rectangle {
            implicitWidth: 24
            implicitHeight: 24
            color: "transparent"
            // color: "#ff0000"

            Image {
                id: icon
                anchors.fill: parent
                source: modelData.icon
                visible: status === Image.Ready
            }

            Rectangle {
                visible: !icon.visible
                anchors.fill: parent
                color: "#0fffffff"

                Text {
                    text: ""
                    font.pixelSize: 24
                    anchors.centerIn: parent
                    color: "#ffffff"
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: modelData.activate()
                // onClicked: QsMenuOpener.menu = modelData.menu
            }
        }
    }
}

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
            id: card
            implicitWidth: 24
            implicitHeight: 24
            color: "transparent"
            // color: "#ff0000"

            required property SystemTrayItem modelData

            Image {
                id: icon
                anchors.fill: parent
                source: card.modelData.icon
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
            QsMenuAnchor {
                id: menu
                // anchor.window:
                menu: card.modelData.hasMenu ? card.modelData.menu : undefined
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                hoverEnabled: true
                onClicked: mouse => {
                    if (mouse.button == Qt.LeftButton) {
                        card.modelData.activate();
                    } else {
                        menu.open();
                        // card.modelData.display(root, 0, 0);
                    }
                }
                onEntered: {
                    console.log("SystemTrayItem", card.modelData.tooltipTitle, card.modelData.tooltipDescription);
                }
                // onClicked: QsMenuOpener.menu = card.modelData.menu
            }
        }
    }
}

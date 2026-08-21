import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../../services"
import "../../config"

PanelWindow {
    id: root
    // visible: ShellState.logout
    readonly property bool active: ShellState.logout

    anchors {
        top: true
        right: true
        bottom: true
        left: true
    }
    exclusionMode: ExclusionMode.Ignore

    // implicitWidth: Math.min(1280, screen.width - 40)
    // implicitHeight: Math.min(720, screen.height - 40)
    color: "#01000000"

    screen: Quickshell.screens[0]
    focusable: true

    property int selectedIndex: 0

    ListModel {
        id: logoutItems

        ListElement {
            icon: ""
            cmd: "hyprlock"
        }
        ListElement {
            icon: "󰿅"
            cmd: "killall -9 Hyprland"
        }
        ListElement {
            icon: ""
            cmd: "poweroff"
        }
        ListElement {
            icon: ""
            cmd: "reboot"
        }
    }

    FocusScope {
        anchors.fill: parent
        focus: true

        // transformOrigin: Item.TopRight
        // scale: visible ? 1.0 : 0.5
        // opacity: visible ? 1.0 : 0.0

        Keys.onUpPressed: if (root.selectedIndex > 2)
            root.selectedIndex = root.selectedIndex - 3
        Keys.onDownPressed: if (root.selectedIndex < 4 - 3)
            root.selectedIndex = root.selectedIndex + 3
        Keys.onLeftPressed: if (root.selectedIndex > 0)
            root.selectedIndex = root.selectedIndex - 1
        Keys.onRightPressed: if (root.selectedIndex < 3)
            root.selectedIndex = root.selectedIndex + 1
        Keys.onReturnPressed: logoutList.itemAt(root.selectedIndex).exec()
        Keys.onEscapePressed: ShellState.logout = false

        HoverHandler {
            id: hoverHandler
            onHoveredChanged: {
                if (hovered)
                    closeTimer.stop();
                else if (root.active)
                    closeTimer.restart();
            }
        }

        Timer {
            id: closeTimer
            interval: 500
            onTriggered: if (!hoverHandler.hovered)
                ShellState.logout = false
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: root.height / 4
            // anchors.margins: root.height * 0.45
            spacing: 20

            Repeater {
                id: logoutList
                model: logoutItems

                delegate: Rectangle {
                    id: itemDelegate

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    required property int index
                    required property var modelData
                    readonly property bool active: index === root.selectedIndex || mouseArea.containsMouse

                    radius: 56
                    color: active ? "#E3701B" : "#0fffffff"

                    function exec(): void {
                        if (itemDelegate.modelData.cmd !== "") {
                            ShellState.logout = false;
                            proc.running = true;
                        }
                    }

                    Process {
                        id: proc
                        command: ["/bin/sh", "-c", itemDelegate.modelData.cmd]
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: itemDelegate.exec()
                    }

                    Item {
                        visible: icon.text !== ""
                        anchors.centerIn: parent
                        scale: itemDelegate.active ? 1.20 : 1
                        implicitWidth: icon.width
                        implicitHeight: icon.height

                        Behavior on scale {
                            NumberAnimation {
                                duration: Config.appearence.animationDuration / 2 || 150
                                // duration: 150
                                easing.type: Easing.InOutCirc
                            }
                        }

                        Text {
                            id: icon
                            text: itemDelegate.modelData.icon
                            font.pixelSize: 156
                            color: "#ffffff"
                        }
                    }
                }
            }
        }
    }
}

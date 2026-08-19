import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import "../../components"
import "../../controls"
import "../../services"
import "../../config"

PanelWindow {
    id: root
    visible: ShellState.logout

    anchors {
        top: true
        right: true
        bottom: true
        left: true
    }
    exclusionMode: ExclusionMode.Ignore

    implicitWidth: Math.min(1280, screen.width - 40)
    implicitHeight: Math.min(720, screen.height - 40)
    color: "transparent"

    screen: Quickshell.screens[0]
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

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
        id: panelContent
        anchors.fill: parent

        transformOrigin: Item.TopRight
        scale: visible ? 1.0 : 0.5
        opacity: visible ? 1.0 : 0.0
        focus: true

        Keys.onEscapePressed: ShellState.logout = false
        Keys.onUpPressed: if (root.selectedIndex > 2)
            root.selectedIndex = root.selectedIndex - 3
        Keys.onDownPressed: if (root.selectedIndex < 4 - 3)
            root.selectedIndex = root.selectedIndex + 3
        Keys.onLeftPressed: if (root.selectedIndex > 0)
            root.selectedIndex = root.selectedIndex - 1
        Keys.onRightPressed: if (root.selectedIndex < 3)
            root.selectedIndex = root.selectedIndex + 1
        Keys.onReturnPressed: logoutList.itemAt(root.selectedIndex).exec()

        HoverHandler {
            id: hoverHandler
            onHoveredChanged: {
                if (hovered)
                    closeTimer.stop();
                else if (root.visible)
                    closeTimer.restart();
            }
        }

        Timer {
            id: closeTimer
            interval: 500
            onTriggered: if (!hoverHandler.hovered)
                ShellState.logout = false
        }

        Rectangle {
            id: panel
            anchors.fill: parent
            radius: 20
            color: "#0fffffff"
            clip: true

            RowLayout {
                anchors.fill: parent
                anchors.margins: root.implicitHeight * 0.45
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

                        Text {
                            visible: text !== ""
                            anchors.centerIn: parent
                            text: itemDelegate.modelData.icon
                            font.pixelSize: 156
                            color: "#ffffff"
                            scale: itemDelegate.active ? 1.20 : 1

                            Behavior on scale {
                                NumberAnimation {
                                    duration: Config.appearence.animationDuration || 150
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

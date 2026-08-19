import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "../../components"
import "../../services"

PanelWindow {
    id: root
    visible: ShellState.help

    // anchors.top: true
    // anchors.right: true
    // anchors.bottom: true
    exclusionMode: ExclusionMode.Normal
    // exclusionMode: ExclusionMode.Ignore

    implicitWidth: Math.min(640, screen.width - 40)
    implicitHeight: Math.min(520, screen.height - 40)
    color: "transparent"

    screen: Quickshell.screens[0]
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    FocusScope {
        id: panelContent
        anchors.fill: parent

        transformOrigin: Item.TopRight
        scale: visible ? 1.0 : 0.5
        opacity: visible ? 1.0 : 0.0

        focus: true
        Keys.onEscapePressed: root.visible = false

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
                root.visible = false
        }

        // Behavior on scale {
        //     NumberAnimation {
        //         duration: 550
        //         easing.bezierCurve: [0.85, 0, 0.15, 1]
        //     }
        // }
        // Behavior on opacity {
        //     NumberAnimation {
        //         duration: 550
        //         easing.bezierCurve: [0.85, 0, 0.15, 1]
        //     }
        // }

        Rectangle {
            id: panel
            anchors.fill: parent
            // implicitWidth: 100
            // implicitHeight: 50
            anchors.margins: 16
            radius: 16
            color: "#0fffffff"
            clip: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16

                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    spacing: 16

                    ColumnLayout {
                        spacing: 0

                        Text {
                            text: "Keybinds"
                            font.family: "Inter"
                            font.pixelSize: 42
                            font.weight: Font.Black
                            color: "#ffffff"
                            lineHeight: 0.9
                        }
                        Text {
                            text: "Specified in hyprland config"
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            color: "#f1f1f1"
                            lineHeight: 1.5
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    RowLayout {
                        spacing: 8

                        BarButton {
                            icon: "󰒓"
                        }
                    }
                }

                Flickable {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    // contentHeight: content.height

                    maximumFlickVelocity: 3000
                    flickDeceleration: 1500
                    boundsBehavior: Flickable.DragAndOvershootBounds
                    boundsMovement: Flickable.FollowBoundsBehavior

                    rebound: Transition {
                        NumberAnimation {
                            properties: "x,y"
                            duration: 150
                            easing.bezierCurve: [0.85, 0, 0.15, 1]
                        }
                    }

                    // ListView {
                    //     clip: true
                    //     spacing: 8
                    //     model: NotificationService.trackedNotifications ?? []
                    //     delegate: NotificationCard {}
                    // }
                }
            }
        }
    }
}

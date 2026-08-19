import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "../../components"
import "../../services"

PanelWindow {
    id: root
    visible: ShellState.mpd

    // anchors.top: true
    // anchors.right: true
    // anchors.bottom: true
    exclusionMode: ExclusionMode.Normal
    // exclusionMode: ExclusionMode.Ignore

    implicitWidth: Math.min(1280, screen.width - 40)
    implicitHeight: Math.min(720, screen.height - 40)
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
        Keys.onEscapePressed: ShellState.mpd = false

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
                ShellState.mpd = false
        }

        Rectangle {
            id: panel
            anchors.fill: parent
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

                    Text {
                        text: "󰎈"
                        font.family: "Inter"
                        font.pixelSize: 42
                        font.weight: Font.Black
                        color: "#ffffff"
                        lineHeight: 0.9
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

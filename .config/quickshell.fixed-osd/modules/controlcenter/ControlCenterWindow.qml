import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import QtQuick.Effects
import QtQuick.Shapes
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Mpris
import Quickshell.Services.UPower
import "../../components"
import "../../services"
import "../notification"
import "../../controls"
import "../../config"

PanelWindow {
    id: root

    readonly property bool active: ShellState.controlcenter
    onActiveChanged: {
        if (active)
            playersList.currentIndex = MprisService.playerIndex;
    }

    HyprlandFocusGrab {
        active: root.active
        windows: [root]
    }

    anchors {
        right: true
    }

    margins {
        right: active ? 0 : -width
    }

    color: "transparent"
    implicitWidth: 360
    implicitHeight: Math.min(860, screen.height - 40)

    screen: Quickshell.screens[0]
    exclusionMode: ExclusionMode.Normal
    // WlrLayershell.keyboardFocus: active ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    FocusScope {
        anchors.fill: parent
        focus: true

        Keys.onEscapePressed: ShellState.controlcenter = false

        HoverHandler {
            onHoveredChanged: {
                if (hovered) {
                    closeTimer.stop();
                } else {
                    if (root.active)
                        closeTimer.restart();
                }
            }
        }
        // MouseArea {
        //     anchors.fill: background
        //     hoverEnabled: true
        //     onEntered: {
        //         closeTimer.stop();
        //     }
        //     onExited: {
        //         if (root.active && !containsPress)
        //             closeTimer.restart();
        //     }
        // }

        Timer {
            id: closeTimer
            interval: 500
            onTriggered: ShellState.controlcenter = false
        }

        MultiEffect {
            source: background
            anchors.fill: background
            maskEnabled: true
            maskSource: mask

            // layer.smooth: true

            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
        }

        Rectangle {
            id: background
            anchors.fill: parent
            visible: false
            // smooth: true
            color: "#01000000"
        }

        Shape {
            id: mask
            anchors.fill: background
            antialiasing: true

            visible: false
            layer.enabled: true

            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                strokeColor: "transparent"

                startX: mask.width
                startY: 0

                PathArc {
                    radiusX: 20
                    radiusY: 20
                    x: mask.width - 20
                    y: 20
                }
                PathLine {
                    x: 20
                    y: 20
                }
                PathArc {
                    direction: PathArc.Counterclockwise
                    radiusX: 20
                    radiusY: 20
                    x: 0
                    y: 40
                }
                PathLine {
                    x: 0
                    y: mask.height - 40
                }
                PathArc {
                    direction: PathArc.Counterclockwise
                    radiusX: 20
                    radiusY: 20
                    x: 20
                    y: mask.height - 20
                }
                PathLine {
                    x: mask.width - 20
                    y: mask.height - 20
                }
                PathArc {
                    radiusX: 20
                    radiusY: 20
                    x: mask.width
                    y: mask.height
                }
                PathLine {
                    x: mask.width
                    y: 0
                }
            }
        }

        ColumnLayout {
            anchors {
                fill: background

                topMargin: 36
                leftMargin: 16
                rightMargin: 16
                bottomMargin: 36
            }
            spacing: 16

            RowLayout {
                spacing: 0

                ColumnLayout {
                    spacing: 0

                    Text {
                        text: ClockService.time
                        font.family: "Inter"
                        font.pixelSize: 42
                        font.weight: Font.Black
                        color: "#ffffff"
                        lineHeight: 0.9
                    }
                    Text {
                        text: ClockService.date
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
                    BarButton {
                        icon: "󰐥"
                    }
                }
            }

            Flickable {
                // implicitWidth: background.width
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentWidth: width
                contentHeight: content.height
                flickableDirection: Flickable.VerticalFlick
                clip: true

                // boundsBehavior: Flickable.StopAtBounds
                // maximumFlickVelocity: 3000
                // flickDeceleration: 1500
                // boundsBehavior: Flickable.DragAndOvershootBounds
                // boundsMovement: Flickable.FollowBoundsBehavior

                // rebound: Transition {
                //     NumberAnimation {
                //         properties: "x,y"
                //         duration: 150
                //         easing.bezierCurve: [0.85, 0, 0.15, 1]
                //     }
                // }

                ColumnLayout {
                    id: content
                    anchors.fill: parent
                    spacing: 8

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        rowSpacing: 8
                        columnSpacing: 8

                        QuickActionButton {
                            icon: ""
                            label: "Wifi"
                        }

                        QuickActionButton {
                            icon: "󰂯"
                            label: "Bluetooth"
                        }

                        QuickActionButton {
                            icon: ""
                            label: "Power"
                            desc: UPower.profile === PowerProfile.PowerSaver ? "PowerSaver" : UPower.profile === PowerProfile.Balanced ? "Balanced" : "Performance"
                            onClicked: {
                                if (UPower.hasPerformanceProfile) {
                                    switch (UPower.profile) {
                                    case PowerProfile.Balanced:
                                        UPower.profile = PowerProfile.Performance;
                                        break;
                                    case PowerProfile.Performance:
                                        UPower.profile = PowerProfile.PowerSaver;
                                        break;
                                    default:
                                        UPower.profile = PowerProfile.Balanced;
                                        break;
                                    }
                                } else {
                                    switch (UPower.profile) {
                                    case PowerProfile.Balanced:
                                        UPower.profile = PowerProfile.PowerSaver;
                                        break;
                                    default:
                                        UPower.profile = PowerProfile.Balanced;
                                        break;
                                    }
                                }
                            }
                        }

                        QuickActionButton {
                            icon: "󰂛"
                            label: "DND"
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        // Brightness slider
                        HorizontalSlider {
                            visible: BrightnessService.hasBacklight
                            Layout.fillWidth: true
                            icon: "󰃠"

                            value: BrightnessService.getBrightness()
                            onMoved: BrightnessService.setBrightness(value)
                        }

                        // Sink volume slider
                        HorizontalSlider {
                            Layout.fillWidth: true
                            icon: "󰕾"

                            from: 0
                            to: 1
                            stepSize: 0.01
                            value: AudioService.sink.audio.volume
                            onMoved: AudioService.sink.audio.volume = value

                            Behavior on value {
                                NumberAnimation {
                                    duration: Config.appearence.animationDuration || 500
                                }
                            }
                        }
                        // Source volume slider
                        HorizontalSlider {
                            Layout.fillWidth: true
                            icon: ""

                            from: 0
                            to: 1
                            stepSize: 0.01
                            value: AudioService.source.audio.volume
                            onMoved: AudioService.source.audio.volume = value

                            Behavior on value {
                                NumberAnimation {
                                    duration: Config.appearence.animationDuration || 500
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 100
                        visible: MprisService.player !== null
                        // visible: Mpris.players.values.length > 0

                        QQC.SwipeView {
                            id: playersList
                            anchors.fill: parent
                            spacing: 8
                            // currentIndex: MprisService.playerIndex

                            Repeater {
                                model: Mpris.players

                                MediaPlayerCard {
                                    width: playersList.width
                                }
                            }
                        }
                    }
                    // Flickable {
                    //     id: playersList
                    //     visible: Mpris.players.values.length > 0
                    //     Layout.fillWidth: true
                    //     implicitHeight: 100
                    //     contentWidth: playersContent.width
                    //     contentHeight: playersContent.height
                    //     flickableDirection: Flickable.HorizontalFlick
                    //     clip: true
                    //     // boundsBehavior: Flickable.StopAtBounds
                    //
                    //     Row {
                    //         id: playersContent
                    //         spacing: 8
                    //
                    //         Repeater {
                    //             model: Mpris.players
                    //
                    //             MediaPlayerCard {
                    //                 width: playersList.width
                    //             }
                    //         }
                    //     }
                    // }

                    ColumnLayout {
                        id: notificationsContainer
                        Layout.fillWidth: true
                        spacing: 8

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 0

                            Text {
                                Layout.fillWidth: true
                                text: "Notifications"
                                font.pixelSize: 12
                                font.weight: Font.DemiBold
                                color: "#ffffff"
                            }

                            BarButton {
                                icon: "󰎟"
                                onClicked: NotificationService.dismissAll()
                            }
                        }

                        Repeater {
                            model: NotificationService.trackedNotificationsModel
                            // model: NotificationService.trackedNotifications

                            NotificationCard {
                                onDismiss: {
                                    NotificationService.trackedNotificationsModel.remove(index);
                                    NotificationService.dismiss(modelData.id);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

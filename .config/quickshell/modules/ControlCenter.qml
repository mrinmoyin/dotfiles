import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Shapes
import Quickshell.Services.Mpris
import Quickshell.Services.UPower
import "../components"
import "../services"
import "./notification"
import "../controls"
import "../config"
import "./controlcenter"

Item {
    id: root

    width: 0
    height: 860

    readonly property bool active: ShellState.controlcenter

    onActiveChanged: {
        if (active)
            inAnimation.start();
        else
            outAnimation.start();
    }

    PropertyAnimation {
        id: inAnimation
        target: root
        property: "width"
        alwaysRunToEnd: true
        to: 360
        duration: Config.appearence.animationDuration || 150
        easing.type: Easing.OutQuad
    }
    PropertyAnimation {
        id: outAnimation
        target: root
        property: "width"
        alwaysRunToEnd: true
        to: 0
        duration: Config.appearence.animationDuration || 150
        easing.type: Easing.InQuad
        onFinished: root.close()
    }

    function close(): void {
        ShellState.controlcenter = false;
        scrollable.contentItem.contentY = 0;
        playersList.currentIndex = MprisService.playerIndex;
    }

    HoverHandler {
        onHoveredChanged: {
            if (hovered)
                closeTimer.stop();
            else
                closeTimer.restart();
        }
    }

    Timer {
        id: closeTimer
        interval: 500
        onTriggered: outAnimation.start()
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
        id: content
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

                IconButton {
                    icon: "󰒓"
                    onClicked: ShellState.wallpaper = !ShellState.wallpaper
                }
                IconButton {
                    icon: "󰐥"
                    onClicked: ShellState.logout = !ShellState.logout
                }
            }
        }
        // Component.onCompleted {
        // }

        ScrollView {
            id: scrollable
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.interactive: false
            ScrollBar.vertical.interactive: true

            ColumnLayout {
                implicitWidth: content.width
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

                    SwipeView {
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

        // Flickable {
        //     id: flickableContent
        //     // implicitWidth: background.width
        //     Layout.fillWidth: true
        //     Layout.fillHeight: true
        //     contentWidth: width
        //     contentHeight: content.height
        //     clip: true
        //
        //     flickableDirection: Flickable.VerticalFlick
        //     boundsBehavior: Flickable.DragAndOvershootBounds
        //     boundsMovement: Flickable.OvershootBounds
        //     // boundsMovement: Flickable.FollowBoundsBehavior
        //     // boundsBehavior: Flickable.StopAtBounds
        //     // maximumFlickVelocity: 3000
        //     // flickDeceleration: 1500
        //
        //     // rebound: Transition {
        //     //     NumberAnimation {
        //     //         properties: "x,y"
        //     //         duration: 150
        //     //         easing.bezierCurve: [0.85, 0, 0.15, 1]
        //     //     }
        //     // }
        //
        //     ColumnLayout {
        //         id: content
        //         anchors.fill: parent
        //         spacing: 8
        //
        //         GridLayout {
        //             Layout.fillWidth: true
        //             columns: 2
        //             rowSpacing: 8
        //             columnSpacing: 8
        //
        //             QuickActionButton {
        //                 icon: ""
        //                 label: "Wifi"
        //             }
        //
        //             QuickActionButton {
        //                 icon: "󰂯"
        //                 label: "Bluetooth"
        //             }
        //
        //             QuickActionButton {
        //                 icon: ""
        //                 label: "Power"
        //                 desc: UPower.profile === PowerProfile.PowerSaver ? "PowerSaver" : UPower.profile === PowerProfile.Balanced ? "Balanced" : "Performance"
        //                 onClicked: {
        //                     if (UPower.hasPerformanceProfile) {
        //                         switch (UPower.profile) {
        //                         case PowerProfile.Balanced:
        //                             UPower.profile = PowerProfile.Performance;
        //                             break;
        //                         case PowerProfile.Performance:
        //                             UPower.profile = PowerProfile.PowerSaver;
        //                             break;
        //                         default:
        //                             UPower.profile = PowerProfile.Balanced;
        //                             break;
        //                         }
        //                     } else {
        //                         switch (UPower.profile) {
        //                         case PowerProfile.Balanced:
        //                             UPower.profile = PowerProfile.PowerSaver;
        //                             break;
        //                         default:
        //                             UPower.profile = PowerProfile.Balanced;
        //                             break;
        //                         }
        //                     }
        //                 }
        //             }
        //
        //             QuickActionButton {
        //                 icon: "󰂛"
        //                 label: "DND"
        //             }
        //         }
        //
        //         ColumnLayout {
        //             Layout.fillWidth: true
        //             spacing: 8
        //
        //             // Brightness slider
        //             HorizontalSlider {
        //                 visible: BrightnessService.hasBacklight
        //                 Layout.fillWidth: true
        //                 icon: "󰃠"
        //
        //                 value: BrightnessService.getBrightness()
        //                 onMoved: BrightnessService.setBrightness(value)
        //             }
        //
        //             // Sink volume slider
        //             HorizontalSlider {
        //                 Layout.fillWidth: true
        //                 icon: "󰕾"
        //
        //                 from: 0
        //                 to: 1
        //                 stepSize: 0.01
        //                 value: AudioService.sink.audio.volume
        //                 onMoved: AudioService.sink.audio.volume = value
        //
        //                 Behavior on value {
        //                     NumberAnimation {
        //                         duration: Config.appearence.animationDuration || 500
        //                     }
        //                 }
        //             }
        //             // Source volume slider
        //             HorizontalSlider {
        //                 Layout.fillWidth: true
        //                 icon: ""
        //
        //                 from: 0
        //                 to: 1
        //                 stepSize: 0.01
        //                 value: AudioService.source.audio.volume
        //                 onMoved: AudioService.source.audio.volume = value
        //
        //                 Behavior on value {
        //                     NumberAnimation {
        //                         duration: Config.appearence.animationDuration || 500
        //                     }
        //                 }
        //             }
        //         }
        //
        //         Item {
        //             Layout.fillWidth: true
        //             implicitHeight: 100
        //             visible: MprisService.player !== null
        //             // visible: Mpris.players.values.length > 0
        //
        //             SwipeView {
        //                 id: playersList
        //                 anchors.fill: parent
        //                 spacing: 8
        //                 // currentIndex: MprisService.playerIndex
        //
        //                 Repeater {
        //                     model: Mpris.players
        //
        //                     MediaPlayerCard {
        //                         width: playersList.width
        //                     }
        //                 }
        //             }
        //         }
        //         // Flickable {
        //         //     id: playersList
        //         //     visible: Mpris.players.values.length > 0
        //         //     Layout.fillWidth: true
        //         //     implicitHeight: 100
        //         //     contentWidth: playersContent.width
        //         //     contentHeight: playersContent.height
        //         //     flickableDirection: Flickable.HorizontalFlick
        //         //     clip: true
        //         //     // boundsBehavior: Flickable.StopAtBounds
        //         //
        //         //     Row {
        //         //         id: playersContent
        //         //         spacing: 8
        //         //
        //         //         Repeater {
        //         //             model: Mpris.players
        //         //
        //         //             MediaPlayerCard {
        //         //                 width: playersList.width
        //         //             }
        //         //         }
        //         //     }
        //         // }
        //
        //         ColumnLayout {
        //             id: notificationsContainer
        //             Layout.fillWidth: true
        //             spacing: 8
        //
        //             RowLayout {
        //                 Layout.fillWidth: true
        //                 spacing: 0
        //
        //                 Text {
        //                     Layout.fillWidth: true
        //                     text: "Notifications"
        //                     font.pixelSize: 12
        //                     font.weight: Font.DemiBold
        //                     color: "#ffffff"
        //                 }
        //
        //                 BarButton {
        //                     icon: "󰎟"
        //                     onClicked: NotificationService.dismissAll()
        //                 }
        //             }
        //
        //             Repeater {
        //                 model: NotificationService.trackedNotificationsModel
        //                 // model: NotificationService.trackedNotifications
        //
        //                 NotificationCard {
        //                     onDismiss: {
        //                         NotificationService.trackedNotificationsModel.remove(index);
        //                         NotificationService.dismiss(modelData.id);
        //                     }
        //                 }
        //             }
        //         }
        //     }
        // }
    }
}

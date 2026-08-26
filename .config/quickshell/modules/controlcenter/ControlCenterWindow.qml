import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Shapes
import Quickshell
import Quickshell.Hyprland
import Quickshell.Networking
import Quickshell.Services.UPower
import "../../components"
import "../../services"
import "../notification"
import "../../controls"
import "../../config"

PanelWindow {
    id: root
    visible: active

    readonly property bool active: ShellState.controlcenter

    onActiveChanged: if (active)
        inAnimation.start()

    HyprlandFocusGrab {
        active: root.active
        windows: [root]
    }

    anchors {
        right: true
    }

    color: "transparent"
    implicitWidth: 360
    implicitHeight: 860

    screen: Quickshell.screens[0]
    exclusionMode: ExclusionMode.Normal

    function close(): void {
        outAnimation.start();
    }

    FocusScope {
        id: scope
        focus: true
        // onActiveFocusChanged: if (!activeFocus) {
        //     root.close();
        // }

        anchors {
            top: parent.top
            right: parent.right
            bottom: parent.bottom
        }
        width: 0

        PropertyAnimation {
            id: inAnimation
            target: scope
            property: "width"
            alwaysRunToEnd: true
            to: root.width
            duration: Config.appearence.animationDuration || 500
            easing.type: Easing.InOutCirc
        }
        PropertyAnimation {
            id: outAnimation
            target: scope
            property: "width"
            alwaysRunToEnd: true
            to: 0
            duration: Config.appearence.animationDuration || 500
            easing.type: Easing.InOutCirc
            onFinished: {
                ShellState.controlcenter = false;
                scrollable.contentItem.contentY = 0;
            }
        }

        Keys.onEscapePressed: root.close()

        HoverHandler {
            onHoveredChanged: {
                if (hovered) {
                    closeTimer.stop();
                } else if (root.active) {
                    closeTimer.restart();
                }
            }
        }

        Timer {
            id: closeTimer
            interval: Config.appearence.timeout
            onTriggered: root.close()
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
                        onClicked: {
                            root.close();
                            ShellState.wallpaper = !ShellState.wallpaper;
                        }
                    }
                    IconButton {
                        icon: "󰐥"
                        onClicked: {
                            root.close();
                            ShellState.logout = !ShellState.logout;
                        }
                    }
                }
            }

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
                            enabled: Networking.wifiHardwareEnabled
                            active: Networking.wifiEnabled
                            onClicked: Networking.wifiEnabled = !Networking.wifiEnabled
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
                        visible: MprisService.players.length > 0

                        Loader {
                            id: playersListLoader
                            active: parent.visible && root.active
                            anchors.fill: parent
                            sourceComponent: Component {
                                SwipeView {
                                    id: playersList
                                    anchors.fill: parent
                                    spacing: 8
                                    currentIndex: MprisService.playerIndex

                                    Repeater {
                                        model: MprisService.players

                                        MediaPlayerCard {
                                            width: playersList.width
                                        }
                                    }
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

                        Loader {
                            active: root.active
                            Layout.fillWidth: true
                            sourceComponent: Component {
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
    }
}

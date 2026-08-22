import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Shapes
import Quickshell
import Quickshell.Services.Pipewire
import "../../services"
import "../../controls"
import "../../config"

PanelWindow {
    id: root
    visible: ShellState.osd

    onVisibleChanged: if (visible)
        inAnimation.start()

    anchors {
        right: true
    }

    color: "transparent"
    implicitWidth: content.width + content.anchors.leftMargin + content.anchors.rightMargin
    implicitHeight: 560
    // implicitHeight: Math.min(460, screen.height - (content.anchors.topMargin + content.anchors.bottomMargin)) + content.anchors.topMargin + content.anchors.bottomMargin

    screen: Quickshell.screens[0]
    exclusionMode: ExclusionMode.Normal

    Item {
        id: scope
        clip: true

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
                ShellState.osd = false;
            }
        }

        HoverHandler {
            id: hoverHandler
            enabled: root.visible
            // onHoveredChanged: {
            //     if (hovered)
            //         closeTimer.stop();
            //     else
            //         closeTimer.restart();
            // }
        }

        Timer {
            id: closeTimer
            running: root.visible && !hoverHandler.hovered
            interval: 2000
            // onTriggered: if (!hoverHandler.hovered)
            //     outAnimation.start()
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

        RowLayout {
            id: content

            spacing: 16

            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right

                topMargin: 36
                leftMargin: 16
                rightMargin: 16
                bottomMargin: 36
            }

            RowLayout {
                id: applicationsContent
                implicitHeight: parent.height
                // implicitWidth: active ? applicationsList.width : 0
                visible: active
                spacing: 8

                property bool active: false

                Binding {
                    target: applicationsContent
                    property: "active"
                    value: !ShellState.osd && false
                }

                Repeater {
                    model: AudioService.applications
                    Layout.fillHeight: true

                    ColumnLayout {
                        id: card
                        implicitWidth: 40
                        implicitHeight: parent.height
                        spacing: 8

                        required property PwNode modelData

                        Rectangle {
                            color: "#0fffffff"
                            implicitWidth: parent.width
                            implicitHeight: width
                            radius: 20

                            Text {
                                anchors.centerIn: parent
                                text: card.modelData.name.slice(0, 1).toUpperCase()
                                font.family: "Inter"
                                font.pixelSize: 20
                                font.weight: Font.DemiBold
                                color: "#ffffff"
                            }
                        }

                        VerticalSlider {
                            implicitWidth: parent.width
                            Layout.fillHeight: true
                            icon: "󰕾"

                            from: 0
                            to: 1
                            stepSize: 0.01
                            value: card.modelData.audio.volume
                            onMoved: card.modelData.audio.volume = value
                        }
                    }
                }
            }

            ColumnLayout { // TODO Controls for individual audio channels
                Layout.preferredWidth: 40
                Layout.fillHeight: true
                spacing: 8

                Rectangle {
                    color: "#0fffffff"
                    implicitWidth: parent.width
                    implicitHeight: width
                    radius: 20

                    Text {
                        anchors.centerIn: parent
                        text: "󰣇"
                        color: "#ffffff"
                        font.pixelSize: 24
                    }
                }

                VerticalSlider {
                    implicitWidth: parent.width
                    Layout.fillHeight: true
                    icon: "󰕾"

                    from: 0
                    to: 1
                    stepSize: 0.01
                    value: AudioService.sink.audio.volume
                    onMoved: AudioService.sink.audio.volume = value
                    onValueChanged: closeTimer.restart()

                    Behavior on value {
                        NumberAnimation {
                            duration: Config.appearence.animationDuration || 500
                        }
                    }
                }
                IconButton {
                    icon: "󰮫"
                    enabled: AudioService.applications.length > 0
                    Layout.fillWidth: true
                    onClicked: applicationsContent.active = !applicationsContent.active
                }
            }
        }
    }
}

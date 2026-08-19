import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import QtQuick.Controls as QQC
import Quickshell
import Quickshell.Hyprland
import "../../services"
import "../../config"

PanelWindow {
    id: root

    readonly property bool active: ShellState.mediaplayer

    onActiveChanged: {
        if (active)
            playersList.currentIndex = MprisService.playerIndex;
    }

    HyprlandFocusGrab {
        active: root.active
        windows: [root]
    }

    anchors {
        top: true
    }

    margins {
        top: active ? 0 : (-height + -34)
    }

    color: "transparent"
    implicitWidth: 640
    implicitHeight: 320

    screen: Quickshell.screens[0]
    exclusionMode: ExclusionMode.Normal

    function close(): void {
        ShellState.mediaplayer = false;
    }

    FocusScope {
        anchors.fill: parent
        focus: true

        Keys.onEscapePressed: root.close()

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
                root.close()
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
            smooth: true

            visible: false
            layer.enabled: true

            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                strokeColor: "transparent"

                startX: 0
                startY: 0

                PathArc {
                    radiusX: 20
                    radiusY: 20
                    x: 20
                    y: 20
                }
                PathLine {
                    x: 20
                    y: mask.height - 20
                }
                PathArc {
                    direction: PathArc.Counterclockwise
                    radiusX: 20
                    radiusY: 20
                    x: 40
                    y: mask.height
                }
                PathLine {
                    x: mask.width - 40
                    y: mask.height
                }
                PathArc {
                    direction: PathArc.Counterclockwise
                    radiusX: 20
                    radiusY: 20
                    x: mask.width - 20
                    y: mask.height - 20
                }
                PathLine {
                    x: mask.width - 20
                    y: 20
                }
                PathArc {
                    radiusX: 20
                    radiusY: 20
                    x: mask.width
                    y: 0
                }
                PathLine {
                    x: 0
                    y: 0
                }
            }
        }

        Item {
            anchors {
                fill: background

                topMargin: 16
                leftMargin: 36
                rightMargin: 36
                bottomMargin: 16
            }
            clip: true

            QQC.SwipeView {
                id: playersList
                visible: MprisService.players.length > 0
                anchors.fill: parent
                spacing: 8
                currentIndex: MprisService.playerIndex

                Repeater {
                    model: MprisService.players

                    MediaPlayerCard {}
                }
            }
        }
    }
}

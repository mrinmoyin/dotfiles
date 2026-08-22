import QtQuick
import Quickshell
import QtQuick.Effects
import QtQuick.Shapes
import "../../services"
import "../mediaplayer"

PanelWindow {
    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }
    exclusionMode: ExclusionMode.Ignore
    aboveWindows: ShellState.mediaplayer
    focusable: true

    color: "transparent"

    screen: Quickshell.screens[0]

    Item {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        height: 54

        MultiEffect {
            id: panel
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

                startX: 0
                startY: 0

                PathLine {
                    x: 0
                    y: mask.height
                }
                PathArc {
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
                PathLine {
                    x: 0
                    y: 0
                }
            }
        }

        BarContent {
            anchors.top: background.top
            anchors.left: background.left
            anchors.right: background.right
        }
    }

    MediaPlayerWindow {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 34
    }
}

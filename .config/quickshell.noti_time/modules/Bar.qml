import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import Quickshell
import "./bar"

Item {
    id: root

    // BarWindow {
    //     color: "#01000000"
    // }

    property ShellScreen screen: Quickshell.screens[0]

    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }
        exclusionMode: ExclusionMode.Ignore

        implicitWidth: screen.width
        implicitHeight: 54
        color: "transparent"

        screen: root.screen

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

                // PathLine {
                //     x: mask.width - 20 - 320
                //     y: mask.height - 20
                // }
                // PathArc {
                //     radiusX: 20
                //     radiusY: 20
                //     x: mask.width - 320
                //     y: mask.height
                // }
                // PathLine {
                //     x: mask.width - 320
                //     y: mask.height - 20 + 100
                // }
                // PathArc {
                //     direction: PathArc.Counterclockwise
                //     radiusX: 20
                //     radiusY: 20
                //     x: mask.width - 320 - 20
                //     y: mask.height - 20 + 100
                // }
                // PathLine {
                //     x: mask.width - 20
                //     y: mask.height + 100 - 20
                // }
                // PathArc {
                //     radiusX: 20
                //     radiusY: 20
                //     x: mask.width
                //     y: mask.height + 100
                // }

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

    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }
        // exclusionMode: ExclusionMode.Normal

        implicitWidth: screen.width
        implicitHeight: 34
        color: "transparent"

        screen: root.screen
    }
}

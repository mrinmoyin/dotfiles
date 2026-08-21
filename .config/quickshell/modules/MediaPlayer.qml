import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import QtQuick.Controls
import "../services"
import "../config"
import "./mediaplayer"

Item {
    id: root

    width: 640
    height: 0

    readonly property bool active: ShellState.mediaplayer

    onActiveChanged: {
        if (active)
            inAnimation.start();
        else
            outAnimation.start();
    }

    PropertyAnimation {
        id: inAnimation
        target: root
        property: "height"
        alwaysRunToEnd: true
        to: 320
        duration: Config.appearence.animationDuration || 500
        easing.type: Easing.InOutCirc
        // easing.bezierCurve: [0.85, 0, 0.15, 1]
    }
    PropertyAnimation {
        id: outAnimation
        target: root
        property: "height"
        alwaysRunToEnd: true
        to: 0
        duration: Config.appearence.animationDuration || 500
        easing.type: Easing.InOutCirc
        // easing.bezierCurve: [0.85, 0, 0.15, 1]
        onFinished: root.close()
    }

    function close(): void {
        ShellState.mediaplayer = false;
        playersList.currentIndex = MprisService.playerIndex;
    }

    HoverHandler {
        id: hoverHandler
        onHoveredChanged: {
            if (hovered)
                closeTimer.stop();
            else
                closeTimer.restart();
        }
    }

    Timer {
        id: closeTimer
        interval: Config.appearence.timeout
        onTriggered: if (!hoverHandler.hovered)
            outAnimation.start()
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

        SwipeView {
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

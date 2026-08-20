//@ pragma UseQApplication

import QtQuick
import Quickshell
import QtQuick.Effects
import QtQuick.Shapes
import "./modules/notification"
import "./modules/controlcenter"
import "./modules/launcher"
import "./modules/clipboard"
import "./modules/help"
import "./modules/osd"
import "./modules/mediaplayer"
import "./modules/wallpaperselector"
import "./modules/logout"
import "./modules/mpd"
import "./modules"
import "./modules/bar"
import "./services"

ShellRoot {
    Shortcuts {}
    Gestures {}

    Bar {}

    LauncherWindow {}
    ControlCenterWindow {}
    NotificationWindow {}
    OsdWindow {}
    HelpWindow {}
    ClipboardWindow {}
    // MediaPlayerWindow {}
    WallpaperSelectorWindow {}
    LogoutWindow {}
    MpdWindow {}

    PanelWindow {
        id: root
        visible: ShellState.testmode
        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }
        exclusionMode: ExclusionMode.Ignore
        aboveWindows: false
        // aboveWindows: scope.activeFocus
        focusable: true
        implicitHeight: 600

        color: "transparent"
        // color: "#0fffffff"

        screen: Quickshell.screens[0]

        function close(): void {
            aboveWindows = false;
        }

        FocusScope {
            id: scope
            anchors.fill: parent
            focus: true
            onActiveFocusChanged: {
                // console.log("focusChanged()", activeFocus);
                if (activeFocus)
                    root.aboveWindows = true;
                else
                    root.aboveWindows = false;
            }

            Keys.onEscapePressed: root.close()

            // Timer {
            //     id: closeTimer
            //     interval: 500
            //     onTriggered: if (!hoverHandler.hovered)
            //         root.close()
            // }
            // HoverHandler {
            //     id: hoverHandler
            //     cursorShape: Qt.PointingHandCursor
            //     onHoveredChanged: {
            //         console.log("hoverChanged()", hovered);
            //         if (hovered)
            //             closeTimer.stop();
            //         else if (root.aboveWindows)
            //             closeTimer.restart();
            //     }
            // }

            BarContent {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
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

                property real barHeight: 54
                property real mediaPlayerWidth: 640
                property real mediaPlayerHeight: 320

                preferredRendererType: Shape.CurveRenderer

                ShapePath {
                    strokeColor: "transparent"

                    startX: 0
                    startY: 0

                    PathLine {
                        x: 0
                        y: mask.barHeight
                    }
                    PathArc {
                        radiusX: 20
                        radiusY: 20
                        x: 20
                        y: mask.barHeight - 20
                    }

                    PathLine {
                        x: mask.width - 20
                        y: mask.barHeight - 20
                    }

                    PathArc {
                        radiusX: 20
                        radiusY: 20
                        x: mask.width
                        y: mask.barHeight
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

            MediaPlayer {
                // visible: ShellState.mediaplayer
                anchors.top: parent.top
                anchors.topMargin: 34
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}

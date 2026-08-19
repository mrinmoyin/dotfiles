import QtQuick
import Quickshell
import "../services"

Item {
    id: root

    property ShellScreen screen: Quickshell.screens[0]
    property color gestureColor: "transparent"

    // Top - Media Player
    PanelWindow {
        anchors {
            top: true
        }
        exclusionMode: ExclusionMode.Ignore

        implicitWidth: 460
        implicitHeight: 5
        color: root.gestureColor

        screen: root.screen

        HoverHandler {
            onHoveredChanged: hovered && (ShellState.mediaplayer = true)
        }
    }

    // Right - Control Center
    PanelWindow {
        anchors {
            right: true
        }
        exclusionMode: ExclusionMode.Ignore

        implicitWidth: 5
        implicitHeight: 460
        color: root.gestureColor

        screen: root.screen

        HoverHandler {
            onHoveredChanged: hovered && (ShellState.controlcenter = true)
        }
    }

    // Bottom - Launcher
    PanelWindow {
        anchors {
            bottom: true
        }
        exclusionMode: ExclusionMode.Ignore

        implicitWidth: 460
        implicitHeight: 5
        color: root.gestureColor

        screen: root.screen

        HoverHandler {
            onHoveredChanged: hovered && (ShellState.launcher = true)
        }
    }
}

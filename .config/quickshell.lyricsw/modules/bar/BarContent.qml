import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../components"
import "../../services"

Item {
    id: root
    // anchors.fill: parent
    implicitHeight: 34

    readonly property int gapIn: 8
    readonly property int gapOut: 4

    // Left
    RowLayout {
        anchors {
            left: parent.left
            leftMargin: root.gapOut
            verticalCenter: parent.verticalCenter
        }
        spacing: root.gapIn

        // AppMenuButton {}
        BarButton {
            icon: "󰣇"
            onClicked: ShellState.launcher = !ShellState.launcher
        }
        SystemTray {}
    }

    // Center
    RowLayout {
        anchors {
            centerIn: parent
            verticalCenter: parent.verticalCenter
            leftMargin: root.gapOut
            rightMargin: root.gapOut
        }
        spacing: root.gapIn

        Mpris {}
    }

    // Right
    RowLayout {
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: root.gapOut
        }
        spacing: root.gapIn

        Network {}
        SystemUsage {}
        Clock {}
        BarButton {
            icon: ""
            onClicked: ShellState.controlcenter = !ShellState.controlcenter
        }
    }
}

import QtQuick
import Quickshell
import "./modules/notification"
import "./modules/help"
import "./modules/osd"
import "./modules/wallpaperselector"
import "./modules/logout"
import "./modules/mpd"
import "./modules/launcher"
import "./modules/clipboard"
import "./modules/controlcenter"
import "./modules"
import "./services"

ShellRoot {
    id: root

    Shortcuts {}
    Gestures {}

    // Dummy Bar
    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 34
        color: "transparent"

        screen: Quickshell.screens[0]
        aboveWindows: false
    }

    ControlCenterWindow {}
    LauncherWindow {}
    ClipboardWindow {}

    Loader {
        active: ShellState.osn
        sourceComponent: Component {
            NotificationWindow {}
        }
    }

    Loader {
        active: ShellState.osd
        sourceComponent: Component {
            OsdWindow {}
        }
    }

    Loader {
        active: ShellState.help
        sourceComponent: Component {
            HelpWindow {}
        }
    }
    Loader {
        active: ShellState.wallpaper
        sourceComponent: Component {
            WallpaperSelectorWindow {}
        }
    }
    Loader {
        active: ShellState.logout
        sourceComponent: Component {
            LogoutWindow {}
        }
    }
    Loader {
        active: ShellState.mpd
        sourceComponent: Component {
            MpdWindow {}
        }
    }

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

        function close(): void {
            aboveWindows = false;
        }

        Bar {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
        }

        MediaPlayer {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 34
        }
    }
}

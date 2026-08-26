import QtQuick

import Quickshell
import "./modules/notification"
import "./modules/help"
import "./modules/osd"
import "./modules/wallpaperselector"
import "./modules/logout"
import "./modules/mpd"
import "./modules/bar"
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

    BarWindow {}
    ControlCenterWindow {}
    LauncherWindow {}
    ClipboardWindow {}

    OsdWindow {}
    NotificationWindow {}

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
}

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
    Shortcuts {}
    Gestures {}

    // Dummy Bar
    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }

        height: 34
        color: "transparent"

        screen: root.screen
        aboveWindows: false
    }

    // Loader {
    //     active: ShellState.controlcenter
    // }
    ControlCenterWindow {}

    // Loader {
    //     active: ShellState.osn
    // }
    NotificationWindow {}

    // Loader {
    //     active: ShellState.osd
    // }
    OsdWindow {}

    // Loader {
    //     active: ShellState.launcher
    // }
    LauncherWindow {}

    // Loader {
    //     active: ShellState.clipboard
    // }
    ClipboardWindow {}

    // Loader {
    //     active: ShellState.help
    // }
    HelpWindow {}
    // Loader {
    //     active: ShellState.wallpaper
    // }
    WallpaperSelectorWindow {}
    // Loader {
    //     active: ShellState.logout
    // }
    LogoutWindow {}
    // Loader {
    //     active: ShellState.mpd
    // }
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
        // aboveWindows: false
        // aboveWindows: ShellState.activeFocus
        aboveWindows: ShellState.mediaplayer
        focusable: true
        // implicitHeight: 600

        color: "transparent"
        // color: "#0fffffff"

        screen: Quickshell.screens[0]

        function close(): void {
            aboveWindows = false;
        }

        Bar {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
        }

        // Loader {
        //     active: ShellState.controlcenter
        //     anchors.fill: parent
        //
        //     ControlCenter {
        //         anchors.right: parent.right
        //         anchors.verticalCenter: parent.verticalCenter
        //     }
        // }

        Loader {
            active: ShellState.mediaplayer
            anchors.fill: parent

            MediaPlayer {
                anchors.top: parent.top
                anchors.topMargin: 34
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // Loader {
        //     active: ShellState.osd
        //     anchors.fill: parent
        //
        //     OSD {
        //         anchors.right: parent.right
        //         anchors.verticalCenter: parent.verticalCenter
        //     }
        // }

        // Loader {
        //     active: ShellState.osn
        //     anchors.fill: parent
        //
        //     Notification {
        //         anchors.top: parent.top
        //         anchors.right: parent.right
        //         anchors.topMargin: 34
        //     }
        // }

        // Loader {
        //     active: ShellState.launcher
        //     anchors.fill: parent
        //
        //     Launcher {
        //         anchors.bottom: parent.bottom
        //         anchors.horizontalCenter: parent.horizontalCenter
        //     }
        // }

        // Loader {
        //     active: ShellState.clipboard
        //     anchors.fill: parent
        //
        //     Clipboard {
        //         anchors.bottom: parent.bottom
        //         anchors.horizontalCenter: parent.horizontalCenter
        //     }
        // }
    }
}

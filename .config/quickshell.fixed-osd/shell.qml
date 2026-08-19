import QtQuick
import Quickshell
import "./modules/notification"
import "./modules/controlcenter"
import "./modules/launcher"
import "./modules/clipboard"
import "./modules/help"
import "./modules/osd"
import "./modules/mediaplayer"
import "./modules/wallpaperselector"
import "./modules/logout"
import "./modules"

ShellRoot {
    id: root

    Shortcuts {}
    Gestures {}

    Bar {}

    LauncherWindow {}
    ControlCenterWindow {}
    NotificationWindow {}
    OsdWindow {}
    HelpWindow {}
    ClipboardWindow {}
    MediaPlayerWindow {}
    WallpaperSelectorWindow {}
    LogoutWindow {}
}

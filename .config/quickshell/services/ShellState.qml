pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property ShellScreen screen: Quickshell.screens[0]

    property bool osd: false
    property bool launcher: false
    property bool controlcenter: false
    property bool mediaplayer: false
    property bool clipboard: false
    property bool help: false
    property bool wallpaper: false
    property bool logout: false
    property bool mpd: false
    property bool testmode: false
}

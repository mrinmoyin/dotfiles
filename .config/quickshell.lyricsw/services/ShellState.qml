pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property bool osd: false
    property bool launcher: false
    property bool controlcenter: false
    property bool mediaplayer: false
    property bool clipboard: false
    property bool help: false
    property bool wallpaper: false
    property bool logout: false
    property bool mpd: false

    function toggleOsd(): void {
        if (!controlcenter)
            osd = !osd;
    }
    function toggleLauncher(): void {
        if (clipboard)
            clipboard = !clipboard;
        launcher = !launcher;
    }
    function toggleControlCenter(): void {
        if (osd)
            osd = !osd;
        controlcenter = !controlcenter;
    }
    function toggleMediaPlayer(): void {
        mediaplayer = !mediaplayer;
    }
    function toggleClipboard(): void {
        if (launcher)
            launcher = !launcher;
        clipboard = !clipboard;
    }
    function toggleHelp(): void {
        help = !help;
    }
    function toggleWallpaper(): void {
        wallpaper = !wallpaper;
    }
}

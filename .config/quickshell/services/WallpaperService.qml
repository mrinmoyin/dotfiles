pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property list<string> wallpapers: []
    property string wallpapersDir: "~/Documents"

    FileView {
        path: "~/.cache/qs/colors.json"
    }

    Process {
        id: fetchWallpapersProc
        running: true
        // command: ["/bin/sh", "-c", `find ${root.wallpapersDir} -type f -print0 | xargs -0 file --mime-type | grep -F 'image/' | cut -d ':' -f 1`]
        command: ["/bin/sh", "-c", `find ${root.wallpapersDir} -maxdepth 1 -type f -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp"`]

        stdout: StdioCollector {
            onStreamFinished: {
                root.wallpapers = text.trim().split("\n");
                console.log("wallpapers", JSON.stringify(root.wallpapers));
            }
        }
    }
}

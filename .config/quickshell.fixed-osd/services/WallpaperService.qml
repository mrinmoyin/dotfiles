pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property list<string> wallpapers: []

    Process {
        id: fetchWallpapersProc
        running: true
        command: ["/bin/sh", "-c", `find ~/Documents -type f -print0 | xargs -0 file --mime-type | grep -F 'image/' | cut -d ':' -f 1`]

        stdout: StdioCollector {
            onStreamFinished: {
                root.wallpapers = text.trim().split("\n");
                // console.log("wallpapers", JSON.stringify(root.wallpapers));
            }
        }
    }
}

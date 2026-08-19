pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property list<string> entries: []
    // property ListModel entries: ListModel {}
    function refresh(): void {
        readProc.running = true;
    }

    Process {
        id: readProc
        running: false
        command: ["/bin/sh", "-c", "cliphist list"]

        property list<string> buff: []
        // property ListModel buff: ListModel {}

        stdout: SplitParser {
            onRead: line => {
                readProc.buff.push(line);
            // readProc.buff.append(line);
            }
        }

        onExited: (code, status) => {
            if (code === 0) {
                root.entries = readProc.buff;
                readProc.buff = [];
            } else {
                console.log("Cliphist exited with code", code);
            }
        }
    }
}

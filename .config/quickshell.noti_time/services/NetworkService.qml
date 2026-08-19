pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Networking

Singleton {
    id: root

    property string interfaceName: "enp0s20u1"

    readonly property real downBytesSec: rxBytes
    readonly property real upBytesSec: txBytes
    readonly property list<NetworkDevice> devices: Networking.devices.values
    onDevicesChanged: console.log("networks", JSON.stringify(devices))

    property int rxBytes: 0
    property int txBytes: 0

    property var _state: ({
            initialized: false,
            prevRxBytes: 0,
            prevTxBytes: 0
        })

    FileView {
        id: rxFile
        path: "/sys/class/net/" + root.interfaceName + "/statistics/rx_bytes"
    }

    FileView {
        id: txFile
        path: "/sys/class/net/" + root.interfaceName + "/statistics/tx_bytes"
    }

    Timer {
        running: true
        interval: 1000
        repeat: true
        triggeredOnStart: false

        onTriggered: {
            let state = root._state;

            rxFile.reload();
            txFile.reload();
            // const rxBytes = parseInt(rxFile.text().trim() || "0", 10) || 0;
            // const txBytes = parseInt(txFile.text().trim() || "0", 10) || 0;
            let rxBytes = parseInt(rxFile.text().trim());
            let txBytes = parseInt(txFile.text().trim());
            // console.log("rxBytes", rxBytes, "txBytes", txBytes);

            if (!state.initialized) {
                state.prevRxBytes = rxBytes;
                state.prevTxBytes = txBytes;
                state.initialized = true;
                root._state = state;
                return;
            }

            root.rxBytes = rxBytes - state.prevRxBytes;
            root.txBytes = txBytes - state.prevTxBytes;

            state.prevRxBytes = rxBytes;
            state.prevTxBytes = txBytes;
            root._state = state;

            // if (root.downBytesSec < 1024) {
            //     console.log("DownByte", root.downBytesSec);
            // } else if (root.downBytesSec < 1024000) {
            //     console.log("DownKB", (root.downBytesSec / 1024.0).toFixed(1));
            // } else if (root.downBytesSec < 1024000000) {
            //     console.log("DownMB", (root.downBytesSec / 1024000.0).toFixed(1));
            // } else if (root.downBytesSec < 1024000000000) {
            //     console.log("DownGB", (root.downBytesSec / 1024000000.0).toFixed(1));
            // }
        }
    }
}

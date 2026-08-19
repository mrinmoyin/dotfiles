pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string _backlightDevice: ""
    readonly property bool hasBacklight: _backlightDevice !== ""

    function getBrightness(): int { // brightness in percent
        // console.log("getBrightness()", 50);
        return 50;
    }
    function setBrightness(value: int): void { // brightness in percent
        console.log("setBrightness()", setBrightnessProc.command, value);
        if (_backlightDevice === "")
            return;

        setBrightnessProc.value = value;
        setBrightnessProc.running = true;
    }

    Process {
        id: setBrightnessProc
        property int value: 0
        command: ["/bin/sh", "-c", `brightnessctl set ${value}%`]
    }

    Component.onCompleted: {}
}

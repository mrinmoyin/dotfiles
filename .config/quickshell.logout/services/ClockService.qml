pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root
    readonly property string time: {
        Qt.formatDateTime(clock.date, "hh:mm");
        // Qt.formatDateTime(clock.date, "ddd MMM d hh:mm:ss AP t yyyy");
    }
    readonly property string date: {
        Qt.formatDateTime(clock.date, "dddd, MMMM d");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}

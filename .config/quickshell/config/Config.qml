pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property var launcher: ({
            favourites: ["Alacritty", "Zen Browser", "thunar",]
        })

    readonly property var onScreenNotification: ({
            maxLength: 3,
            timeout: 5000
        })

    readonly property var appearence: ({
            animationDuration: 500
        })
}

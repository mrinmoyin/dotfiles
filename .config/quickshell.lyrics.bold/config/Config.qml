pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property var launcher: ({
            maxResults: 5,
            favourites: ["Alacritty", "Zen Browser", "thunar",]
        })

    readonly property var onScreenNotification: ({
            maxVisible: 3
        })

    readonly property var appearence: ({
            animationDuration: 150
        })
}

pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import "../types"

Singleton {
    id: root

    Component {
        id: wrapper
        Player {}
    }

    readonly property list<Player> players: {
        let result = [];

        for (let i = 0; i < Mpris.players.rowCount(); i++) {
            result.push(wrapper.createObject(root, {
                source: Mpris.players.values[i]
            }));
        }
        return result;
    }

    readonly property list<Player> activePlayers: players.filter(plyr => plyr.source.isPlaying === true)
    readonly property Player player: players.find(plyr => plyr.source.isPlaying === true) || players[lastPlayerIndex] || players[0]

    readonly property int playerIndex: players.indexOf(player)
    property int lastPlayerIndex: 0

    onActivePlayersChanged: if (activePlayers[0])
        lastPlayerIndex = players.indexOf(activePlayers[0])
}

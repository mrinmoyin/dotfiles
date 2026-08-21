pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property list<MprisPlayer> players: Mpris.players.values
    readonly property list<MprisPlayer> activePlayers: players.filter(plyr => plyr.isPlaying === true)
    readonly property MprisPlayer player: players.find(plyr => plyr.isPlaying === true) || players[lastPlayerIndex] || players[0]

    readonly property int playerIndex: players.indexOf(player)
    property int lastPlayerIndex: 0

    onActivePlayersChanged: if (activePlayers[0])
        lastPlayerIndex = players.indexOf(activePlayers[0])

    // TODO seperate lyrics control for every player
    property bool lyricsEnabled: false
    property bool lyricsAvailable: false
    property bool loadingLyrics: lyricsProc.running
    property ListModel lyrics: ListModel {}
    property int currentLyricsIndex: 0

    Timer {
        running: root.player.isPlaying
        repeat: true
        interval: 1000
        // onTriggered: root.player.positionChanged()
        onTriggered: {
            for (const plyr of root.activePlayers) {
                plyr.positionChanged();
                if (plyr.position < 1 && root.lyricsEnabled && root.lyricsAvailable) {
                    console.log("synch lyrics");
                    root.syncLyrics();
                }
            }
        }
    }

    onPlayerIndexChanged: {
        lastPlayerIndex = playerIndex;
    }

    onLyricsChanged: {
        syncLyrics();
    }

    onLyricsEnabledChanged: {
        if (lyricsEnabled) {
            if (lyrics.count === 0)
                fetchLyrics();
            else
                syncLyrics();
        }
    }

    onCurrentLyricsIndexChanged: {
        if (lyrics.count > currentLyricsIndex + 1) {
            lyricsTimer.interval = lyrics.get(currentLyricsIndex + 1).time - player.position;
            lyricsTimer.reset();
        }
    }

    function formatTime(sec: real): string {
        var sec_num = parseInt(sec, 10);
        var hours = Math.floor(sec_num / 3600);
        var minutes = Math.floor(sec_num / 60) % 60;
        var seconds = sec_num % 60;

        return [hours, minutes, seconds].map(v => v < 10 ? "0" + v : v).filter((v, i) => v !== "00" || i > 0).join(":");
    }

    function fetchLyrics(): void {
        lyricsProc.running = true;
    }

    function syncLyrics(): void {
        for (var i = 0; i < lyrics.count; i++) {
            if (lyrics.get(i).time > player.position) {
                if (i > 0) {
                    currentLyricsIndex = i - 1;
                } else {
                    currentLyricsIndexChanged();
                }
                break;
            } else if (player.position > lyrics.get(lyrics.count - 1).time) {
                currentLyricsIndex = lyrics.count - 1;
                break;
            }
        }
    }

    Connections {
        target: root.player

        function onPostTrackChanged() {
            if (root.lyricsEnabled) {
                root.lyrics.clear();
                root.fetchLyrics();
            }
        }
    }

    FrameAnimation {
        id: lyricsTimer
        running: root.lyricsEnabled && root.player.isPlaying && root.lyrics.count > 0 && root.currentLyricsIndex !== root.lyrics.count - 1
        property real interval: 100
        onTriggered: {
            if (elapsedTime >= interval) {
                root.currentLyricsIndex = root.currentLyricsIndex + 1;
            }
        }
    }

    Process {
        id: lyricsProc
        // command: ["/bin/sh", "-c", `curl "https://lrclib.net/api/get?artist_name=${encodeURI(root.player.trackArtist) + "&track_name=" + encodeURI(root.player.trackTitle) + "&album_name=" + encodeURI(root.player.trackAlbum) + "&duration=" + root.player.length}"`]
        // command: ["/bin/sh", "-c", `curl "https://lrclib.net/api/get?artist_name=${encodeURI(root.player.trackArtist) + "&track_name=" + encodeURI(root.player.trackTitle) + "&duration=" + root.player.length}"`]
        command: ["/bin/sh", "-c", `curl "https://lrclib.net/api/get?artist_name=${encodeURI(root.player.trackArtist.split(",")[0]) + "&track_name=" + encodeURI(root.player.trackTitle) + "&duration=" + root.player.length}"`]

        stdout: StdioCollector {
            onStreamFinished: {
                // console.log(text);
                const data = JSON.parse(text);
                if (!data.syncedLyrics) {
                    console.warn("unalbe to fetch lyrics", lyricsProc.command);
                    root.lyricsAvailable = false;
                    return;
                }
                root.lyricsAvailable = true;
                const lines = data.syncedLyrics.split("\n");

                root.lyrics.append({
                    time: 0.00,
                    text: ""
                });
                for (var i = 0; i < lines.length; i++) {
                    const parts = lines[i].split(/ (.*)/);
                    const times = parts[0].match(/\[(.*?)\]/)[1].split(":");
                    root.lyrics.append({
                        time: parseInt(times[0] * 60) + parseFloat(times[1]),
                        text: parts[1]
                    });
                    // console.log("time:", parseInt(times[0] * 60) + parseFloat(times[1]), "text:", parts[1]);
                }
                root.lyricsChanged();
            }
        }
    }
}

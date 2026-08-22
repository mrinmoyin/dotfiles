import QtQuick
import Quickshell.Io
import Quickshell.Services.Mpris

QtObject {
    id: root

    required property MprisPlayer source
    property bool lyricsEnabled: false
    property bool lyricsAvailable: false
    property ListModel lyrics: ListModel {}
    property int currentLyricsIndex: 0
    property bool loadingLyrics: lyricsProc.running
    property string positionString: "00:00"
    property string lengthString: formatTime(source.length)

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
            lyricsTimer.interval = lyrics.get(currentLyricsIndex + 1).time - source.position;
            lyricsTimer.reset();
        }
    }

    function fetchLyrics(): void {
        lyricsProc.running = true;
    }

    function syncLyrics(): void {
        for (var i = 0; i < lyrics.count; i++) {
            if (lyrics.get(i).time > source.position) {
                if (i > 0) {
                    currentLyricsIndex = i - 1;
                } else {
                    currentLyricsIndexChanged();
                }
                break;
            } else if (source.position > lyrics.get(lyrics.count - 1).time) {
                currentLyricsIndex = lyrics.count - 1;
                break;
            }
        }
    }

    function formatTime(sec: real): string {
        var sec_num = parseInt(sec, 10);
        var hours = Math.floor(sec_num / 3600);
        var minutes = Math.floor(sec_num / 60) % 60;
        var seconds = sec_num % 60;

        return [hours, minutes, seconds].map(v => v < 10 ? "0" + v : v).filter((v, i) => v !== "00" || i > 0).join(":");
    }

    property Connections trackChangeConn: Connections {
        target: player.source

        function onPostTrackChanged() {
            if (root.lyricsEnabled) {
                root.lyrics.clear();
                root.fetchLyrics();
            }
        }
    }

    property FrameAnimation lyricsTimer: FrameAnimation {
        running: root.lyricsEnabled && root.source.isPlaying && root.lyrics.count > 0 && root.currentLyricsIndex !== root.lyrics.count - 1
        property real interval: 100
        onTriggered: {
            if (elapsedTime >= interval) {
                root.currentLyricsIndex = root.currentLyricsIndex + 1;
            }
        }
    }

    property Process lyricsProc: Process {
        command: ["/bin/sh", "-c", `curl "https://lrclib.net/api/get?artist_name=${encodeURI(root.source.trackArtist.split(",")[0]) + "&track_name=" + encodeURI(root.source.trackTitle) + "&duration=" + root.source.length}"`]

        stdout: StdioCollector {
            onStreamFinished: {
                const data = JSON.parse(text);
                if (!data.syncedLyrics) {
                    console.warn("unalbe to fetch lyrics", root.lyricsProc.command);
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

    property Timer refreshTimer: Timer {
        running: root.source.isPlaying
        repeat: true
        interval: 1000
        // onTriggered: root.player.positionChanged()
        onTriggered: {
            root.positionString = root.formatTime(root.source.position);
            root.source.positionChanged();
            if (root.source.position < 1 && root.lyricsEnabled && root.lyricsAvailable) {
                console.log("synch lyrics");
                root.syncLyrics();
            }
        }
    }
}

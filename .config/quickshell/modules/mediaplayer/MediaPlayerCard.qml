import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Services.Mpris
import "../../controls"
import "../../services"
import "../../types"

RowLayout {
    id: root
    spacing: 16

    required property Player modelData
    required property int index

    Item {
        Layout.fillHeight: true
        implicitWidth: height

        MouseArea {
            id: mouseArea
            visible: root.modelData.source.canRaise
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root.modelData.source.raise();
                ShellState.mediaplayer = false;
            }
        }

        Image {
            id: artSource
            visible: false
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            source: root.modelData.source.trackArtUrl
        }

        Rectangle {
            id: artMask
            anchors.fill: parent
            radius: 20
            visible: false
            layer.enabled: true
        }

        MultiEffect {
            id: art
            visible: artSource.status === Image.Ready
            anchors.fill: parent
            source: artSource
            maskSource: artMask
            maskEnabled: true
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
        }

        Rectangle {
            anchors.fill: parent
            visible: !art.visible
            radius: 20
            color: "#0fffffff"

            Text {
                anchors.centerIn: parent
                text: "󰝚"
                color: "#ffffff"
                font.pixelSize: 40
            }
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        // Layout.fillHeight: true

        Text {
            Layout.alignment: Qt.AlignTop | Qt.AlignRight
            text: root.modelData.source.identity || "Unknown"
            // text: root.modelData.desktopEntry || "Unknown"
            // text: root.modelData.dbusName || "Unknown"
            color: "#ffffff"
            font.pixelSize: 10
            font.weight: Font.Medium
        }

        Text {
            text: root.modelData.source.trackTitle || "Unknown"
            color: "#ffffff"
            font.pixelSize: 12
            font.weight: Font.DemiBold
            elide: Text.ElideRight
            Layout.fillWidth: true
        }

        Text {
            text: root.modelData.source.trackArtist || "Unknown"
            color: "#ffffff"
            font.pixelSize: 10
            font.weight: Font.Medium
            elide: Text.ElideRight
            Layout.fillWidth: true
        }

        Item {
            id: lyricsContainer
            Layout.fillHeight: true
            Layout.fillWidth: true

            IconButton {
                anchors.top: parent.top
                anchors.right: parent.right
                icon: root.modelData.lyricsEnabled ? "󰨖" : "󰨗"
                onClicked: root.modelData.lyricsEnabled = !root.modelData.lyricsEnabled
            }

            Item {
                anchors.fill: parent
                visible: root.modelData.lyricsEnabled

                Text {
                    id: lyricsStatusText
                    anchors.centerIn: parent
                    visible: !root.modelData.lyricsAvailable
                    text: root.modelData.loadingLyrics ? "Loading lyrics..." : "Lyrics unavailable"
                    color: "#ffffff"
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                    lineHeight: 0
                }

                Loader {
                    active: parent.visible && !lyricsStatusText.visible
                    anchors.fill: parent

                    sourceComponent: Component {
                        ListView {
                            id: lyricsList
                            model: root.modelData.lyrics
                            anchors.fill: parent
                            clip: true
                            highlightRangeMode: ListView.StrictlyEnforceRange
                            preferredHighlightBegin: height / 2 - currentItem.height / 2
                            preferredHighlightEnd: height / 2 + currentItem.height / 2
                            interactive: false
                            currentIndex: root.modelData.currentLyricsIndex
                            spacing: 4

                            delegate: Item {
                                id: lyricsItem
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: lyricsText.height

                                required property var modelData
                                required property int index
                                readonly property int currentIndex: lyricsList.currentIndex
                                Text {
                                    id: lyricsText
                                    anchors.left: parent.left
                                    anchors.right: parent.right

                                    horizontalAlignment: Text.AlignHCenter
                                    text: lyricsItem.modelData.text
                                    color: "#ffffff"
                                    // lineHeight: 0
                                    wrapMode: Text.WordWrap
                                    font.pixelSize: 16
                                    font.weight: Font.DemiBold
                                }

                                states: [
                                    State {
                                        name: "primary"
                                        when: lyricsItem.index === lyricsItem.currentIndex

                                        PropertyChanges {
                                            target: lyricsItem
                                            scale: 1
                                            opacity: 1
                                        }
                                    },
                                    State {
                                        name: "secondary"
                                        when: lyricsItem.index === lyricsItem.currentIndex + 1 || lyricsItem.index === lyricsItem.currentIndex - 1

                                        PropertyChanges {
                                            target: lyricsItem
                                            scale: 0.75
                                            opacity: 0.75
                                        }
                                    },
                                    State {
                                        name: "tertiary"
                                        when: lyricsItem.index === lyricsItem.currentIndex + 2 || lyricsItem.index === lyricsItem.currentIndex - 2

                                        PropertyChanges {
                                            target: lyricsItem
                                            scale: 0.5
                                            opacity: 0.5
                                        }
                                    },
                                    State {
                                        name: "others"
                                        when: lyricsItem.index === lyricsItem.currentIndex + 3 || lyricsItem.index === lyricsItem.currentIndex - 3

                                        PropertyChanges {
                                            target: lyricsItem
                                            scale: 0.25
                                            opacity: 0.25
                                        }
                                    },
                                    State {
                                        name: "etc"
                                        when: lyricsItem.index >= lyricsItem.currentIndex + 4 || lyricsItem.index <= lyricsItem.currentIndex - 4

                                        PropertyChanges {
                                            target: lyricsItem
                                            scale: 0
                                            opacity: 0
                                        }
                                    }
                                ]
                            }
                        }
                    }
                }
            }
        }

        HorizontalSlider {
            id: progress
            visible: root.modelData.source.positionSupported
            implicitHeight: 12
            Layout.fillWidth: true
            Layout.topMargin: 4
            enabled: root.modelData.source.canSeek

            from: 0
            to: root.modelData.source.length
            stepSize: 1

            value: root.modelData.source.position
            onMoved: {
                root.modelData.source.seek(value);
                // root.modelData.source.position = value;
            }

            Behavior on value {
                NumberAnimation {
                    duration: 1000
                }
            }
        }
        RowLayout {
            Text {
                Layout.fillWidth: true
                text: root.modelData.positionString
                color: "#ffffff"
                font.pixelSize: 10
                font.weight: Font.Medium
            }
            Text {
                Layout.alignment: Qt.AlignRight
                text: root.modelData.lengthString
                color: "#ffffff"
                font.pixelSize: 10
                font.weight: Font.Medium
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

            IconButton {
                icon: root.modelData.source.shuffle ? "󰒝" : "󰒞"
                enabled: root.modelData.source.shuffleSupported
                onClicked: root.modelData.source.shuffle = !root.modelData.source.shuffle
            }
            IconButton {
                icon: "󰒮"
                enabled: root.modelData.source.canGoPrevious
                onClicked: root.modelData.source.previous()
            }
            IconButton {
                icon: root.modelData.source.playbackState === MprisPlaybackState.Playing ? "" : ""
                enabled: root.modelData.source.canTogglePlaying
                onClicked: root.modelData.source.togglePlaying()
                size: 32
            }
            IconButton {
                icon: "󰒭"
                enabled: root.modelData.source.canGoNext
                onClicked: root.modelData.source.next()
            }
            IconButton {
                icon: root.modelData.source.loopState === MprisLoopState.Track ? "󰑘" : root.modelData.source.loopState === MprisLoopState.Playlist ? "󰑖" : "󰑗"
                enabled: root.modelData.source.loopSupported
                onClicked: {
                    if (root.modelData.source.loopState === MprisLoopState.None)
                        root.modelData.source.loopState = MprisLoopState.Track;
                    else if (root.modelData.source.loopState === MprisLoopState.Track)
                        root.modelData.source.loopState = MprisLoopState.Playlist;
                    else
                        root.modelData.source.loopState = MprisLoopState.None;
                }
            }
        }
    }
}

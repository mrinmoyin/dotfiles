import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Services.Mpris
import "../../controls"
import "../../services"
import "../../types"

Rectangle {
    id: root

    required property Player modelData
    required property int index

    implicitWidth: parent.width
    implicitHeight: 100
    radius: 20
    color: "#0fffffff"

    RowLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

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
                    ShellState.controlcenter = false;
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
            Layout.fillHeight: true
            // Layout.topMargin: 8
            spacing: 5

            ColumnLayout {
                spacing: 0

                Text {
                    text: root.modelData.source.trackTitle || "Unknown"
                    color: "#ffffff"
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
                RowLayout {
                    Text {
                        text: root.modelData.source.trackArtist || "Unknown"
                        color: "#ffffff"
                        font.pixelSize: 10
                        font.weight: Font.Medium
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    Text {
                        text: root.modelData.source.identity || "Unknown"
                        // text: root.modelData.source.desktopEntry || "Unknown"
                        // text: root.modelData.source.dbusName || "Unknown"
                        color: "#ffffff"
                        font.pixelSize: 10
                        font.weight: Font.Medium
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
                onMoved: if (root.modelData.source.canSeek) {
                    root.modelData.source.position = value;
                }

                Behavior on value {
                    NumberAnimation {
                        duration: 1000
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

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
}

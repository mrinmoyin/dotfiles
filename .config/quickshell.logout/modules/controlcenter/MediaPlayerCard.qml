import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Services.Mpris
import "../../controls"
import "../../services"

Rectangle {
    id: root

    required property MprisPlayer modelData
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
                visible: root.modelData.canRaise
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.modelData.raise();
                    ShellState.controlcenter = false;
                }
            }

            Image {
                id: artSource
                visible: false
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                source: root.modelData.trackArtUrl
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
                    text: root.modelData.trackTitle || "Unknown"
                    color: "#ffffff"
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
                RowLayout {
                    Text {
                        text: root.modelData.trackArtist || "Unknown"
                        color: "#ffffff"
                        font.pixelSize: 10
                        font.weight: Font.Medium
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    Text {
                        text: root.modelData.identity || "Unknown"
                        // text: root.modelData.desktopEntry || "Unknown"
                        // text: root.modelData.dbusName || "Unknown"
                        color: "#ffffff"
                        font.pixelSize: 10
                        font.weight: Font.Medium
                    }
                }
            }

            HorizontalSlider {
                id: progress
                visible: root.modelData.positionSupported
                implicitHeight: 12
                Layout.fillWidth: true
                Layout.topMargin: 4
                enabled: root.modelData.canSeek

                from: 0
                to: root.modelData.length
                stepSize: 1

                value: root.modelData.position
                onMoved: if (root.modelData.canSeek) {
                    root.modelData.position = value;
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
                    icon: root.modelData.shuffle ? "󰒝" : "󰒞"
                    enabled: root.modelData.shuffleSupported
                    onClicked: root.modelData.shuffle = !root.modelData.shuffle
                }
                IconButton {
                    icon: "󰒮"
                    enabled: root.modelData.canGoPrevious
                    onClicked: root.modelData.previous()
                }
                IconButton {
                    icon: root.modelData.playbackState === MprisPlaybackState.Playing ? "" : ""
                    enabled: root.modelData.canTogglePlaying
                    onClicked: root.modelData.togglePlaying()
                }
                IconButton {
                    icon: "󰒭"
                    enabled: root.modelData.canGoNext
                    onClicked: root.modelData.next()
                }
                IconButton {
                    icon: root.modelData.loopState === MprisLoopState.Track ? "󰑘" : root.modelData.loopState === MprisLoopState.Playlist ? "󰑖" : "󰑗"
                    enabled: root.modelData.loopSupported
                    onClicked: {
                        if (root.modelData.loopState === MprisLoopState.None)
                            root.modelData.loopState = MprisLoopState.Track;
                        else if (root.modelData.loopState === MprisLoopState.Track)
                            root.modelData.loopState = MprisLoopState.Playlist;
                        else
                            root.modelData.loopState = MprisLoopState.None;
                    }
                }
            }
        }
    }
}

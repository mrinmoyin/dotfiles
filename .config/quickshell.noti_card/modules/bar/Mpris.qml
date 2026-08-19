import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import "../../controls"
import "../../services"

Item {
    id: root
    implicitWidth: Math.min(Quickshell.screens[0].width / 3, 540)
    implicitHeight: 20

    property MprisPlayer player: MprisService.player

    Component {
        id: sliderComp

        HorizontalSlider {
            id: slider
            enabled: root.player.canSeek

            from: 0
            to: root.player.length
            value: root.player.position
            stepSize: 1
            onMoved: if (root.player.canSeek) {
                root.player.position = value;
            }

            Behavior on value {
                NumberAnimation {
                    duration: 1000
                }
            }

            Item {
                implicitWidth: Math.min(parent.width - 16, visibleText.implicitWidth)
                implicitHeight: parent.height
                anchors.horizontalCenter: parent.horizontalCenter

                readonly property string title: "  " + root.player.trackTitle || "Unknown"
                readonly property string lyric: MprisService.lyricsAvailable && MprisService.lyrics.get(MprisService.currentLyricsIndex).text || ""
                readonly property string currentText: MprisService.lyricsEnabled && lyric !== "" ? lyric : title

                Text {
                    id: visibleText
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    text: parent.currentText
                    color: "#ffffff"
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                    lineHeight: 0

                    // Behavior on text {
                    //     NumberAnimation {
                    //         duration: 250
                    //     }
                    // }
                }
            }
        }
    }

    Loader {
        anchors.fill: parent
        active: root.player !== null
        asynchronous: true
        sourceComponent: sliderComp
    }
}

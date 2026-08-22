import QtQuick
import Quickshell
import "../../controls"
import "../../services"
import "../../config"
import "../../types"

Item {
    id: root
    implicitWidth: Math.min(Quickshell.screens[0].width / 3, 540)
    implicitHeight: 24

    property Player player: MprisService.player

    HorizontalSlider {
        id: slider
        anchors.fill: parent
        enabled: root.player.source.canSeek
        clip: true

        from: 0
        to: root.player.source.length
        value: root.player.source.position
        stepSize: 1
        onMoved: if (root.player.source.canSeek) {
            root.player.source.position = value;
        }

        Behavior on value {
            NumberAnimation {
                duration: 1000
            }
        }

        Item {
            id: textContainer
            implicitWidth: Math.min(parent.width - 16, visibleText.implicitWidth)
            implicitHeight: visibleText.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            opacity: 1

            readonly property string title: "  " + root.player.source.trackTitle || "Unknown"
            readonly property string lyric: root.player.lyricsAvailable && root.player.lyrics.get(root.player.currentLyricsIndex).text || ""
            readonly property string currentText: root.player.lyricsEnabled && lyric !== "" ? lyric : title

            onCurrentTextChanged: {
                outAnimation.start();
            }

            PropertyAnimation {
                id: outAnimation
                target: visibleText
                alwaysRunToEnd: true
                property: "opacity"
                to: 0
                duration: Config.appearence.animationDuration / 2 || 250
                easing.type: Easing.InOutCirc
                onFinished: {
                    visibleText.text = textContainer.currentText;
                    inAnimation.start();
                }
            }
            PropertyAnimation {
                id: inAnimation
                target: visibleText
                alwaysRunToEnd: true
                property: "opacity"
                to: 1
                duration: Config.appearence.animationDuration / 2 || 250
                easing.type: Easing.InOutCirc
            }

            Text {
                id: visibleText
                width: parent.width
                text: parent.title
                color: "#ffffff"
                font.pixelSize: 14
                font.weight: Font.DemiBold
                elide: Text.ElideRight
                lineHeight: 0
            }
        }
    }
}

import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import "../../controls"
import "../../services"
import "../../config"

Item {
    id: root
    implicitWidth: Math.min(Quickshell.screens[0].width / 3, 540)
    implicitHeight: 24

    property MprisPlayer player: MprisService.player

    Component {
        id: sliderComp

        HorizontalSlider {
            id: slider
            enabled: root.player.canSeek
            clip: true

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
                id: textContainer
                implicitWidth: Math.min(parent.width - 16, visibleText.implicitWidth)
                implicitHeight: visibleText.height
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                opacity: 1

                readonly property string title: "  " + root.player.trackTitle || "Unknown"
                readonly property string lyric: MprisService.lyricsAvailable && MprisService.lyrics.get(MprisService.currentLyricsIndex).text || ""
                readonly property string currentText: MprisService.lyricsEnabled && lyric !== "" ? lyric : title
                onCurrentTextChanged: {
                    outAnimation.start();
                }

                PropertyAnimation {
                    id: outAnimation
                    target: visibleText
                    alwaysRunToEnd: true
                    property: "opacity"
                    to: 0
                    duration: Config.appearence.animationDuration || 150
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
                    duration: Config.appearence.animationDuration || 150
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

            // Item {
            //     visible: !lyrics.visible
            //     implicitWidth: Math.min(parent.width - 16, visibleText.implicitWidth)
            //     implicitHeight: parent.height
            //     anchors.horizontalCenter: parent.horizontalCenter
            //     opacity: visible ? 1 : 0
            //
            //     Behavior on opacity {
            //         NumberAnimation {
            //             duration: 150
            //         }
            //     }
            //
            //     Text {
            //         id: visibleText
            //         width: parent.width
            //         anchors.verticalCenter: parent.verticalCenter
            //         text: "  " + root.player.trackTitle || "Unknown"
            //         color: "#ffffff"
            //         font.pixelSize: 12
            //         font.weight: Font.DemiBold
            //         elide: Text.ElideRight
            //         lineHeight: 0
            //     }
            // }
            //
            // ListView {
            //     id: lyrics
            //     model: MprisService.lyrics
            //     anchors.fill: parent
            //     interactive: false
            //     currentIndex: MprisService.currentLyricsIndex
            //     spacing: 4
            //     visible: MprisService.lyricsEnabled && MprisService.lyricsAvailable && currentItem.modelData.text !== ""
            //     opacity: visible ? 1 : 0
            //
            //     Behavior on opacity {
            //         NumberAnimation {
            //             duration: 150
            //         }
            //     }
            //
            //     delegate: Item {
            //         id: lyricsItem
            //         anchors.left: parent.left
            //         anchors.right: parent.right
            //         height: lyricsText.height
            //
            //         required property var modelData
            //         required property int index
            //
            //         Text {
            //             id: lyricsText
            //             anchors.left: parent.left
            //             anchors.right: parent.right
            //
            //             horizontalAlignment: Text.AlignHCenter
            //             text: lyricsItem.modelData.text
            //             color: "#ffffff"
            //             lineHeight: 0
            //             font.pixelSize: 14
            //             font.weight: Font.DemiBold
            //             elide: Text.ElideRight
            //         }
            //     }
            // }
        }
    }

    Loader {
        anchors.fill: parent
        active: root.player !== null
        asynchronous: true
        sourceComponent: sliderComp
    }
}

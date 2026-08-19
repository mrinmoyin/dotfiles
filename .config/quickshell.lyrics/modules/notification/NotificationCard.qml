import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Services.Notifications
import "../../config"

// TODO collapsable card height
Rectangle {
    id: root

    required property var modelData
    required property int index

    signal dismiss

    implicitWidth: parent.width
    implicitHeight: 100
    radius: 20
    color: modelData.urgency === NotificationUrgency.Critical ? "#0fff0000" : "#0fffffff"

    // Behavior on x {
    //     NumberAnimation {
    //         duration: Config.appearence.animationDuration || 500
    //     }
    // }

    DragHandler {
        id: dragHandle
        target: root
        yAxis.enabled: false
        cursorShape: active ? Qt.ClosedHandCursor : Qt.PointingHandCursor
        onGrabChanged: (transition, point) => {
            if (transition == PointerDevice.UngrabExclusive) {
                if (root.x > root.width / 2)
                    root.dismiss();
                else
                    root.x = 0;
            }
        }
    }
    // MouseArea {
    //     id: mouseArea
    //     anchors.fill: parent
    //     onClicked: dismiss()
    // }

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        RowLayout {
            implicitHeight: 20
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            spacing: 0

            // Rectangle {
            //     radius: 20
            //     color: "#0fffffff"
            //     implicitWidth: 32
            //     implicitHeight: 32
            //     Layout.rightMargin: 8
            //
            //     Image {
            //         id: appIcon
            //         anchors.fill: parent
            //         fillMode: Image.PreserveAspectFit
            //
            //         property int sourceIndex: 0
            //         property var iconSources: [`/usr/share/pixmaps/${root.modelData.appIcon}`, `/usr/share/icons/hicolor/scalable/apps/${root.modelData.appIcon}.svg`, `/usr/share/icons/hicolor/32x32/apps/${root.modelData.appIcon}`]
            //
            //         source: iconSources[sourceIndex]
            //         asynchronous: true
            //         onStatusChanged: {
            //             if (status === Image.Error) {
            //                 if (root.modelData.appIcon !== "" && sourceIndex < iconSources.length - 1)
            //                     sourceIndex = sourceIndex + 1;
            //                 else
            //                     visible = false;
            //             }
            //         }
            //     }
            //
            //     Text {
            //         visible: !appIcon.visible
            //         text: "󰂚"
            //         anchors.centerIn: parent
            //         color: "#ffffff"
            //         font.pixelSize: 20
            //     }
            // }

            Item {
                implicitWidth: 32
                implicitHeight: 32
                Layout.rightMargin: 8

                Image {
                    id: artSource
                    visible: false
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit

                    property int sourceIndex: 0
                    property var iconSources: [`/usr/share/pixmaps/${root.modelData.appIcon}`, `/usr/share/icons/hicolor/scalable/apps/${root.modelData.appIcon}.svg`, `/usr/share/icons/hicolor/32x32/apps/${root.modelData.appIcon}`]

                    source: iconSources[sourceIndex]
                    asynchronous: true
                    onStatusChanged: {
                        if (status === Image.Error) {
                            if (root.modelData.appIcon !== "" && sourceIndex < iconSources.length - 1)
                                sourceIndex = sourceIndex + 1;
                            else
                                visible = false;
                        }
                    }
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
                        text: "󰂚"
                        color: "#ffffff"
                        font.pixelSize: 20
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                // Layout.alignment: Qt.AlignVCenter
                spacing: 0

                Text {
                    text: root.modelData.appName || "Unknown"

                    color: "#ffffff"
                    font.pixelSize: 12
                }

                Text {
                    id: time
                    text: formatTime(root.modelData.time)

                    color: "#ffffff"
                    font.pixelSize: 10

                    Timer {
                        // running: true
                        running: root.visible
                        interval: 60000
                        repeat: true
                        // triggeredOnStart: true
                        triggeredOnStart: false

                        onTriggered: time.text = formatTime(root.modelData.time)
                    }
                }
            }

            // BarButton {
            //     icon: ""
            //     onClicked: dismiss()
            // }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: root.modelData.summary

                    Layout.fillWidth: true
                    color: "#E3701B"
                    font.family: "Inter"
                    font.pixelSize: 16
                    font.bold: true
                    elide: Text.ElideRight
                }

                Text {
                    visible: text !== ""
                    text: root.modelData.body

                    Layout.fillWidth: true
                    color: "#ffffff"
                    // font.family: Config.fontFamily
                    // font.pixelSize: Config.fontSize - 1
                    font.pixelSize: 14
                    // wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                }

                Image {
                    visible: source.toString() !== ""
                    source: root.modelData.image || ""

                    Layout.fillWidth: true
                    // Layout.preferredWidth: 36
                    // Layout.preferredHeight: 36
                    // Layout.alignment: Qt.AlignTop
                    fillMode: Image.PreserveAspectFit
                }
            }
        }
    }

    function formatTime(date): string {
        const currentDate = new Date();
        // const deltaM = currentDate.getMinutes() - date.getMinutes()
        const deltaT = Math.floor((currentDate.getTime() - date.getTime()) / 60000);
        // console.log("deltaT", deltaT);
        if (deltaT < 1) {
            return "Just now";
        } else if (deltaT < 60) {
            return deltaT + " Min ago";
        } else if (deltaT < (60 * 24)) {
            return (currentDate.getHours() - date.getHours()) + " Hours " + (currentDate.getMinutes() - date.getMinutes()) + " Min ago";
        } else if (deltaT < (60 * 24 * 24)) {
            return (currentDate.getDay() - date.getDay()) + " Days ago";
        }
        return date.toDateString();

        // const deltaT = (time - Date.now()) / 60000;
        // if (deltaT < 1) {
        //     return "Just now";
        // } else if (deltaT < 60) {
        //     return deltaT + "Mins ago";
        // } else if (deltaT < (60 * 24)) {
        //     return deltaT / 60 + "Hours" + "Mins ago";
        // }
    }
}

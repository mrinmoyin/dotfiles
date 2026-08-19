import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Services.Notifications
import "../../controls"
import "../../config"

// TODO collapsable card height
Rectangle {
    id: root

    required property var modelData
    required property int index

    property bool expanded: false

    signal dismiss

    implicitWidth: parent.width
    // Layout.fillWidth: true
    // implicitHeight: 100
    implicitHeight: content.height
    radius: 20
    color: modelData.urgency === NotificationUrgency.Critical ? "#0fff0000" : "#0fffffff"

    // Behavior on implicitHeight {
    //     NumberAnimation {
    //         // duration: Config.appearence.animationDuration || 500
    //         duration: 500
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

    ColumnLayout {
        id: content
        // anchors.fill: parent
        // implicitWidth: parent.width
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        spacing: 8
        // Rectangle {
        //     anchors.fill: parent
        //     color: "#0fffffff"
        // }

        RowLayout {
            implicitHeight: 20
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            spacing: 0
            Layout.topMargin: 8

            Item {
                implicitWidth: 32
                implicitHeight: 32
                Layout.rightMargin: 8

                Image {
                    id: imageSource
                    visible: false
                    anchors.fill: image
                    fillMode: Image.PreserveAspectFit

                    source: root.modelData.image || ""
                    asynchronous: true
                    onStatusChanged: {
                        if (status === Image.Error) {
                            visible = false;
                        }
                    }
                }

                Rectangle {
                    id: imageMask
                    anchors.fill: parent
                    radius: 20
                    visible: false
                    layer.enabled: true
                }

                MultiEffect {
                    id: image
                    visible: imageSource.status === Image.Ready
                    anchors.fill: imageMask
                    source: imageSource
                    maskSource: imageMask
                    maskEnabled: true
                    maskThresholdMin: 0.5
                    maskSpreadAtMin: 1.0
                }

                Image {
                    id: appIconSource
                    visible: false
                    anchors.fill: appIcon
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
                    id: appIconMask
                    anchors.fill: parent
                    radius: 20
                    visible: false
                    layer.enabled: true

                    // width: 16
                    // height: 16
                    // anchors.top: parent.top
                    // anchors.right: parent.right
                }

                MultiEffect {
                    id: appIcon
                    visible: !image.visible && appIconSource.status === Image.Ready
                    anchors.fill: appIconMask
                    source: appIconSource
                    maskSource: appIconMask
                    maskEnabled: true
                    maskThresholdMin: 0.5
                    maskSpreadAtMin: 1.0
                }

                Rectangle {
                    anchors.fill: parent
                    visible: !image.visible && !appIcon.visible
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

            Item {
                Layout.fillWidth: true
            }

            IconButton {
                id: expandBtn
                visible: false
                icon: root.expanded ? "󰞙" : "󰞖"
                // enabled:
                size: 16
                onClicked: root.expanded = !root.expanded
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            Layout.bottomMargin: 8

            Text {
                id: summary
                text: root.modelData.summary

                Layout.fillWidth: true
                // color: "#E3701B"
                color: "#ffffff"
                font.family: "Inter"
                font.pixelSize: 16
                font.bold: true
                elide: Text.ElideRight
                wrapMode: root.expanded ? Text.Wrap : Text.NoWrap
            }

            Text {
                id: body
                visible: text !== ""
                text: root.modelData.body

                Layout.fillWidth: true
                color: "#ffffff"
                // font.family: Config.fontFamily
                // font.pixelSize: Config.fontSize - 1
                font.pixelSize: 14
                elide: Text.ElideRight
                wrapMode: root.expanded ? Text.Wrap : Text.NoWrap
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
    Component.onCompleted: {
        if (summary.truncated || body.truncated)
            expandBtn.visible = true;
    }
}

import QtQuick

TextField {
    id: root

    leftPadding: 16
    rightPadding: 16
    topPadding: 8
    bottomPadding: 8

    onPressed: {}
    background: Rectangle {
        id: bg
        anchors.fill: parent
        color: "#0fffffff"
        radius: 20
    }

    Text {
        id: placeholder

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: root.leftPadding

        text: root.placeholderText
        color: "#ffffff"
        font.family: "Inter"

        opacity: root.text ? 0 : 1
    }

    TapHandler {
        id: tapHandler
    }
}

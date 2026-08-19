import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    Layout.fillWidth: true
    implicitHeight: 60
    color: "#0fffffff"
    radius: 20

    required property string icon
    required property string label
    property string desc: ""

    signal clicked

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: clicked()
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: height
            color: "#0fffffff"
            radius: 20

            Text {
                anchors.centerIn: parent
                text: root.icon
                font.pixelSize: 20
                color: "#ffffff"
            }
        }
        ColumnLayout {
            Text {
                Layout.fillWidth: true
                text: root.label
                color: "#ffffff"
                font.pixelSize: 14
                font.weight: Font.DemiBold
                elide: Text.ElideRight
            }
            Text {
                visible: text != ""
                Layout.fillWidth: true
                color: "#ffffff"
                text: root.desc
                font.pixelSize: 10
                font.weight: Font.DemiBold
                elide: Text.ElideRight
            }
        }
    }
}

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Networking
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import "../../services"
import "../../components"
import "../../controls"

RowLayout {
    id: root

    ColumnLayout {
        Layout.fillHeight: true
        spacing: 2

        HorizontalSlider {
            implicitHeight: 12
            implicitWidth: 100
            enabled: false

            to: 1
            stepSize: 0.01
            value: NetworkService.upBytesSec / 1048576

            Text {
                anchors.centerIn: parent
                text: " " + formatBytes(NetworkService.upBytesSec)
                color: "#ffffff"
                font.pixelSize: 8
                font.weight: Font.DemiBold
                elide: Text.ElideRight
                lineHeight: 0
            }
        }

        HorizontalSlider {
            implicitHeight: 12
            implicitWidth: 100
            enabled: false

            to: 1
            stepSize: 0.01
            value: NetworkService.downBytesSec / 1048576

            Item {
                implicitWidth: Math.min(parent.width - 8, downText.implicitWidth)
                implicitHeight: downText.height
                anchors.centerIn: parent

                Text {
                    id: downText
                    width: parent.width
                    text: "  " + formatBytes(NetworkService.downBytesSec) + " "
                    color: "#ffffff"
                    font.pixelSize: 8
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                    lineHeight: 0
                }
            }
        }
    }

    // Text {
    //     text: " " + formatBytes(NetworkService.downBytesSec)
    //     font.family: "Inter"
    //     font.pixelSize: 16
    //     font.weight: Font.Black
    //     color: "#ffffff"
    //     lineHeight: 0.9
    // }
    // Text {
    //     text: " " + formatBytes(NetworkService.upBytesSec)
    //     font.family: "Inter"
    //     font.pixelSize: 16
    //     font.weight: Font.Black
    //     color: "#ffffff"
    //     lineHeight: 0.9
    // }

    function formatBytes(bytes: int): string {
        // const gb = bytes / (1024 ** 3);
        // const mb = bytes / (1024 ** 2);
        // const kb = bytes / (1024);
        if (bytes < 1024) {
            return (bytes / 1.0).toFixed(1) + "B/s";
        } else if (bytes < 1024000) {
            return (bytes / 1024.0).toFixed(1) + "K/s";
        } else if (bytes < 1024000000) {
            return (bytes / 1024000.0).toFixed(1) + "M/s";
        } else {
            return (bytes / 1024000000.0).toFixed(1) + "G/s";
        }
    }
}

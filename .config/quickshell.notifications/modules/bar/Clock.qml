import QtQuick
import "../../services"

Text {
    text: ClockService.time
    font.family: "Inter"
    font.pixelSize: 24
    font.weight: Font.Black
    color: "#ffffff"
    lineHeight: 0
}

import QtQuick
// import qs.config as Config
import "../config"

Item {
    id: root

    property int size: 150
    property int lineWidth: 5
    property real value: 0
    property string icon: ""

    implicitWidth: size
    implicitHeight: size

    onValueChanged: {
        canvas.degree = value * 360;
    }

    Text {
        visible: text !== ""
        text: root.icon
        anchors.centerIn: parent
        color: "#ffffff"
        font.pixelSize: root.size / 2
    }

    Canvas {
        id: canvas

        anchors.fill: parent
        antialiasing: true

        property real degree: 0
        property real radius: root.size / 2 - root.lineWidth
        property real startAngle: (Math.PI / 180) * 270
        property real fullAngle: (Math.PI / 180) * (270 + 360)
        property real progressAngle: (Math.PI / 180) * (270 + degree)
        property real center: root.size / 2

        onDegreeChanged: {
            requestPaint();
        }

        onPaint: {
            var ctx = getContext("2d");

            ctx.reset();

            ctx.lineCap = 'round';
            ctx.lineWidth = root.lineWidth;

            ctx.beginPath();
            ctx.arc(center, center, radius, startAngle, fullAngle);
            ctx.strokeStyle = "#0fffffff";
            ctx.stroke();

            ctx.beginPath();
            ctx.arc(center, center, radius, startAngle, progressAngle);
            ctx.strokeStyle = "#E3701B";
            ctx.stroke();
        }

        Behavior on degree {
            NumberAnimation {
                duration: Config.appearence.animationDuration || 500
            }
        }
    }
}

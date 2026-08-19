import QtQuick
import QtQuick.Templates

TextField {
    id: root

    color: "#ffffff"
    placeholderText: "#08ffffff"
    selectionColor: "#0000ff"
    selectedTextColor: "#000000"

    font.family: "Inter"
    renderType: echoMode === TextField.Password ? TextField.QtRendering : TextField.NativeRendering
    cursorVisible: !readOnly
    verticalAlignment: TextInput.AlignVCenter

    cursorDelegate: Item {}

    Rectangle {
        id: cursor

        x: root.cursorRectangle.x
        y: root.cursorRectangle.y
        implicitWidth: 1.5
        implicitHeight: root.cursorRectangle.height

        color: "#ffffff"
        radius: 4

        property bool disableBlink

        Connections {
            function onCursorPositionChanged(): void {
                if (root.activeFocus && root.cursorVisible) {
                    cursor.opacity = 1;
                    cursor.disableBlink = true;
                    blink.restart();
                }
            }

            target: root
        }

        Timer {
            id: blink

            interval: 500
            onTriggered: cursor.disableBlink = false
        }

        Timer {
            running: root.activeFocus && root.cursorVisible && !cursor.disableBlink
            repeat: true
            triggeredOnStart: true
            interval: 500
            onTriggered: parent.opacity = parent.opacity === 1 ? 0 : 1
        }

        Binding {
            when: !root.activeFocus || !root.cursorVisible
            cursor.opacity: 0
        }
    }
}

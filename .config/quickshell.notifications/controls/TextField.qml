import QtQuick
import QtQuick.Templates

TextField {
    id: root

    color: "#ffffff"
    placeholderTextColor: "#08ffffff"
    selectionColor: "#0000ff"
    selectedTextColor: "#000000"

    font.family: "Inter"
    renderType: echoMode === TextField.Password ? TextField.QtRendering : TextField.NativeRendering
    cursorVisible: !readOnly
    verticalAlignment: TextInput.AlignVCenter

    cursorDelegate: Rectangle {
        id: cursor

        // x: root.cursorRectangle.x
        // y: root.cursorRectangle.y
        implicitWidth: 2
        // implicitHeight: root.cursorRectangle.height

        color: "#ffffff"
        radius: 8

        property bool blink
    }

    onCursorPositionChanged: {
        if (root.activeFocus && root.cursorVisible) {
            root.cursorDelegate.opacity = 1;
            root.cursorDelegate.blink = false;
            blinkTimer.restart();
        }
    }

    // Timer {
    //     id: blink
    //     interval: 500
    //     onTriggered: cursor.blink = false
    // }

    Timer {
        id: blinkTimer
        running: root.activeFocus && root.cursorVisible && root.cursorDelegate.blink
        repeat: true
        triggeredOnStart: true
        interval: 500
        onTriggered: root.cursorDelegate.opacity = root.cursorDelegate.opacity === 1 ? 0 : 1
    }

    // Binding {
    //     when: !root.activeFocus || !root.cursorVisible
    //     cursor.opacity: 0
    // }
}

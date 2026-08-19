import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Shapes
import Quickshell
import Quickshell.Hyprland
import "../../controls"
import "../../services"

PanelWindow {
    id: root

    readonly property bool active: ShellState.clipboard
    onActiveChanged: {
        if (active)
            ClipboardService.refresh();
    }

    HyprlandFocusGrab {
        active: root.active
        windows: [root]
    }

    anchors {
        bottom: true
    }

    margins {
        bottom: active ? 0 : -height
    }

    color: "transparent"
    implicitWidth: Math.min(540, screen.width - 40)
    implicitHeight: Math.min(640, screen.height - 40)

    screen: Quickshell.screens[0]
    exclusionMode: ExclusionMode.Normal

    property string query: ""

    readonly property list<string> visibleEntries: {
        const q = query.trim();

        if (q.length > 0) {
            return ClipboardService.entries.filter(entry => entry.split("\t")[1].toLowerCase().includes(q));
        }

        return ClipboardService.entries;
    }

    function copy(): void {
        Quickshell.execDetached(["/bin/sh", "-c", `wl-copy ${list.currentItem.modelData.split("\t")[1]}`]);
        close();
    }

    function close(): void {
        ShellState.clipboard = false;
        root.query = "";
        list.currentIndex = 0;
    }

    FocusScope {
        anchors.fill: parent
        focus: true

        Keys.onEscapePressed: root.close()
        Keys.onDownPressed: list.incrementCurrentIndex()
        Keys.onUpPressed: list.decrementCurrentIndex()
        Keys.onReturnPressed: {
            root.copy();
            root.close();
        }

        HoverHandler {
            id: hoverHandler
            onHoveredChanged: {
                if (hovered)
                    closeTimer.stop();
                else if (root.visible)
                    closeTimer.restart();
            }
        }

        Timer {
            id: closeTimer
            interval: 500
            onTriggered: if (!hoverHandler.hovered)
                root.close()
        }

        MultiEffect {
            source: background
            anchors.fill: background
            maskEnabled: true
            maskSource: mask

            // layer.smooth: true

            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
        }

        Rectangle {
            id: background
            anchors.fill: parent
            visible: false
            // smooth: true
            color: "#01000000"
        }

        Shape {
            id: mask
            anchors.fill: background
            antialiasing: true

            visible: false
            layer.enabled: true

            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                strokeColor: "transparent"

                startX: 0
                startY: mask.height

                PathArc {
                    direction: PathArc.Counterclockwise
                    radiusX: 20
                    radiusY: 20
                    x: 20
                    y: mask.height - 20
                }
                PathLine {
                    x: 20
                    y: 20
                }
                PathArc {
                    radiusX: 20
                    radiusY: 20
                    x: 40
                    y: 0
                }
                PathLine {
                    x: mask.width - 40
                    y: 0
                }
                PathArc {
                    direction: PathArc.Clockwise
                    radiusX: 20
                    radiusY: 20
                    x: mask.width - 20
                    y: 20
                }
                PathLine {
                    x: mask.width - 20
                    y: mask.height - 20
                }
                PathArc {
                    direction: PathArc.Counterclockwise
                    radiusX: 20
                    radiusY: 20
                    x: mask.width
                    y: mask.height
                }
                PathLine {
                    x: 0
                    y: mask.height
                }
            }
        }

        ColumnLayout {
            anchors {
                fill: background

                topMargin: 16
                leftMargin: 36
                rightMargin: 36
                bottomMargin: 8
            }
            spacing: 16

            Rectangle {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                implicitHeight: 40
                color: "#0fffffff"
                radius: 20

                RowLayout {
                    anchors.fill: parent
                    Layout.leftMargin: 16
                    Layout.rightMargin: 16
                    spacing: 16

                    Text {
                        text: "📋"
                        font.pixelSize: 20
                        font.weight: Font.Black
                        color: "#ffffff"
                        Layout.leftMargin: 16
                    }
                    TextFieldBase {
                        focus: true
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        font.pixelSize: 20
                        placeholderText: "Search"
                        text: root.query
                        onTextChanged: root.query = text
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: root.query.trim().length ? "Best matches" : "Recent"
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                    color: "#ffffff"
                }
            }

            ListView {
                id: list
                model: root.visibleEntries
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                delegate: Rectangle {
                    id: card

                    required property string modelData
                    required property int index

                    width: list.width
                    height: 60
                    radius: 20
                    color: list.currentIndex === index ? "#0fffffff" : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0

                        Item {
                            Layout.fillHeight: true
                            implicitWidth: height
                            Layout.margins: 8

                            Rectangle {
                                radius: 20
                                color: "#0fffffff"
                                anchors.fill: parent

                                Text {
                                    anchors.centerIn: parent
                                    text: "󰦨"
                                    font.family: "Inter"
                                    font.pixelSize: 20
                                    font.weight: Font.DemiBold
                                    color: "#ffffff"
                                }
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                Layout.fillWidth: true
                                text: card.modelData.split("\t")[1]
                                font.family: "Inter"
                                font.pixelSize: 16
                                font.weight: Font.Medium
                                color: "#ffffff"
                                elide: Text.ElideRight
                            }
                        }
                    }

                    TapHandler {
                        cursorShape: Qt.PointingHandCursor
                        onTapped: {
                            root.copy();
                        }
                    }
                    // MouseArea {
                    //     anchors.fill: parent
                    //     hoverEnabled: true
                    //     cursorShape: Qt.PointingHandCursor
                    //     onEntered: root.selectedIndex = card.index
                    //     onClicked: {
                    //         root.copy();
                    //         root.close();
                    //     }
                    // }
                }
            }
            // Flickable {
            //     id: list
            //     Layout.fillWidth: true
            //     Layout.fillHeight: true
            //     clip: true
            //     contentWidth: width
            //     contentHeight: content.implicitHeight
            //
            //     boundsBehavior: Flickable.StopAtBounds
            //
            //     Column {
            //         id: content
            //         spacing: 8
            //         bottomPadding: 16
            //
            //         Repeater {
            //             model: root.visibleEntries
            //
            //             Rectangle {
            //                 id: card
            //
            //                 required property string modelData
            //                 required property int index
            //
            //                 width: list.width
            //                 height: 60
            //                 radius: 20
            //                 color: root.selectedIndex === index ? "#0fffffff" : "transparent"
            //
            //                 RowLayout {
            //                     anchors.fill: parent
            //                     spacing: 0
            //
            //                     Item {
            //                         Layout.fillHeight: true
            //                         implicitWidth: height
            //                         Layout.margins: 8
            //
            //                         Rectangle {
            //                             radius: 20
            //                             color: "#0fffffff"
            //                             anchors.fill: parent
            //
            //                             Text {
            //                                 anchors.centerIn: parent
            //                                 text: "󰦨"
            //                                 font.family: "Inter"
            //                                 font.pixelSize: 20
            //                                 font.weight: Font.DemiBold
            //                                 color: "#ffffff"
            //                             }
            //                         }
            //                     }
            //
            //                     ColumnLayout {
            //                         Layout.fillWidth: true
            //                         spacing: 2
            //
            //                         Text {
            //                             Layout.fillWidth: true
            //                             text: card.modelData.split("\t")[1]
            //                             font.family: "Inter"
            //                             font.pixelSize: 16
            //                             font.weight: Font.Medium
            //                             color: "#ffffff"
            //                             elide: Text.ElideRight
            //                         }
            //                     }
            //                 }
            //
            //                 MouseArea {
            //                     anchors.fill: parent
            //                     hoverEnabled: true
            //                     cursorShape: Qt.PointingHandCursor
            //                     onEntered: root.selectedIndex = card.index
            //                     onClicked: {
            //                         root.copy();
            //                         root.close();
            //                     }
            //                 }
            //             }
            //         }
            //     }
            // }

            Text {
                Layout.fillWidth: true
                visible: root.visibleEntries === 0
                text: "No result found"
                horizontalAlignment: Text.AlignHCenter
                font.family: "Inter"
                font.pixelSize: 12
                color: "#ffffff"
            }
        }
    }
}

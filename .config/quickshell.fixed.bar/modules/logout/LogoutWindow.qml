import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "../../components"
import "../../services"

PanelWindow {
    id: root
    visible: ShellState.logout

    property int selectedIndex: 0

    anchors {
        top: true
        right: true
        bottom: true
        left: true
    }
    // anchors.top: true
    // anchors.right: true
    // anchors.bottom: true
    // exclusionMode: ExclusionMode.Normal
    // exclusionMode: ExclusionMode.Ignore

    implicitWidth: Math.min(1280, screen.width - 40)
    implicitHeight: Math.min(720, screen.height - 40)
    color: "transparent"

    screen: Quickshell.screens[0]
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    FocusScope {
        id: panelContent
        anchors.fill: parent

        transformOrigin: Item.TopRight
        scale: visible ? 1.0 : 0.5
        opacity: visible ? 1.0 : 0.0
        focus: true

        Keys.onEscapePressed: ShellState.logout = false
        Keys.onUpPressed: if (root.selectedIndex > 2)
            root.selectedIndex = root.selectedIndex - 3
        Keys.onDownPressed: if (root.selectedIndex < 4 - 3)
            root.selectedIndex = root.selectedIndex + 3
        Keys.onLeftPressed: if (root.selectedIndex > 0)
            root.selectedIndex = root.selectedIndex - 1
        Keys.onRightPressed: if (root.selectedIndex < 3)
            root.selectedIndex = root.selectedIndex + 1

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
                ShellState.logout = false
        }

        Rectangle {
            id: panel
            anchors.fill: parent
            // anchors.margins: 16
            radius: 20
            color: "#0fffffff"
            clip: true

            Flickable {
                id: wallpaperList
                anchors.fill: parent
                anchors.margins: 20

                GridLayout {
                    columns: 3
                    rowSpacing: 20
                    columnSpacing: 20

                    Repeater {
                        // model: WallpaperService.wallpapers
                        model: ListModel {
                            ListElement {
                                uri: "/home/mrinmoy/Documents/can-anyone-please-give-me-similar-wallpaper-for-laptop-and-v0-motbre9rx6ag1.webp"
                            }
                            ListElement {
                                uri: "/home/mrinmoy/Documents/can-anyone-please-give-me-similar-wallpaper-for-laptop-and-v0-motbre9rx6ag1.webp"
                            }
                            ListElement {
                                uri: "/home/mrinmoy/Documents/can-anyone-please-give-me-similar-wallpaper-for-laptop-and-v0-motbre9rx6ag1.webp"
                            }
                            ListElement {
                                uri: "/home/mrinmoy/Documents/can-anyone-please-give-me-similar-wallpaper-for-laptop-and-v0-motbre9rx6ag1.webp"
                            }
                        }

                        delegate: Item {
                            id: card
                            required property string uri
                            required property int index
                            // Layout.fillWidth: true
                            implicitWidth: 400
                            implicitHeight: 225
                            // Rectangle {
                            //     anchors.fill: parent
                            //     color: "#0fffffff"
                            // }
                            scale: index === root.selectedIndex ? 1.05 : 1
                            Behavior on scale {
                                NumberAnimation {
                                    duration: 180
                                }
                            }
                            Image {
                                anchors.fill: parent
                                source: uri
                                fillMode: Image.PreserveAspectCrop
                            }
                        }
                    }
                }
            }
            // GridView {
            //     id: wallpaperList
            //     anchors.fill: parent
            //     // anchors.margins: 16
            //     anchors.topMargin: 16
            //     anchors.bottomMargin: 16
            //     anchors.leftMargin: 16
            //     anchors.rightMargin: 16
            //     // model: WallpaperService.wallpapers
            //     model: ListModel {
            //         ListElement {
            //             uri: "/home/mrinmoy/Documents/can-anyone-please-give-me-similar-wallpaper-for-laptop-and-v0-motbre9rx6ag1.webp"
            //         }
            //         ListElement {
            //             uri: "/home/mrinmoy/Documents/can-anyone-please-give-me-similar-wallpaper-for-laptop-and-v0-motbre9rx6ag1.webp"
            //         }
            //         ListElement {
            //             uri: "/home/mrinmoy/Documents/can-anyone-please-give-me-similar-wallpaper-for-laptop-and-v0-motbre9rx6ag1.webp"
            //         }
            //         ListElement {
            //             uri: "/home/mrinmoy/Documents/can-anyone-please-give-me-similar-wallpaper-for-laptop-and-v0-motbre9rx6ag1.webp"
            //         }
            //     }
            //     cellWidth: 416
            //     cellHeight: 234
            //
            //     // highlight: Rectangle {
            //     //     color: "#8fff0000"
            //     //     // border.width: 2
            //     //     // border.color: "#ff0000"
            //     //     // scale: 1.05
            //     // }
            //
            //     delegate: Item {
            //         width: wallpaperList.cellWidth - 16
            //         height: wallpaperList.cellHeight - 16
            //         // scale: index === wallpaperList.currentIndex ? 1.1 : 0
            //         Rectangle {
            //             anchors.fill: parent
            //             color: "#0fffffff"
            //         }
            //         // Image {
            //         //     anchors.fill: parent
            //         //     source: uri
            //         //     fillMode: Image.PreserveAspectCrop
            //         // }
            //     }
            // }
        }
    }
}

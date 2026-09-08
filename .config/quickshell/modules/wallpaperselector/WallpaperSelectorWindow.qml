import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "../../components"
import "../../services"

PanelWindow {
    id: root
    visible: ShellState.wallpaper

    property list<string> wallpapers: WallpaperService.wallpapers
    property int selectedIndex: 0
    // onWallpapersChanged: console.log("wallpapers", JSON.stringify(wallpapers))

    // anchors.top: true
    // anchors.right: true
    // anchors.bottom: true
    exclusionMode: ExclusionMode.Normal
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

        Keys.onEscapePressed: ShellState.wallpaper = false
        Keys.onUpPressed: if (root.selectedIndex > 2)
            root.selectedIndex = root.selectedIndex - 3
        Keys.onDownPressed: if (root.selectedIndex < 4 - 3)
            root.selectedIndex = root.selectedIndex + 3
        Keys.onLeftPressed: if (root.selectedIndex > 0)
            root.selectedIndex = root.selectedIndex - 1
        Keys.onRightPressed: if (root.selectedIndex < 3)
            root.selectedIndex = root.selectedIndex + 1

        Rectangle {
            id: panel
            anchors.fill: parent
            // anchors.margins: 16
            radius: 20
            color: "#0fffffff"
            clip: true

            ScrollView {
                id: wallpaperList
                anchors.fill: parent
                anchors.margins: 20

                GridLayout {
                    anchors.fill: parent
                    columns: 3
                    rowSpacing: 20
                    columnSpacing: 20
                    uniformCellWidths: true
                    uniformCellHeights: true

                    Repeater {
                        // model: WallpaperService.wallpapers
                        model: ListModel {
                            ListElement {
                                modelData: "/home/mrinmoy/Documents/can-anyone-please-give-me-similar-wallpaper-for-laptop-and-v0-motbre9rx6ag1.webp"
                            }
                            ListElement {
                                modelData: "/home/mrinmoy/Documents/can-anyone-please-give-me-similar-wallpaper-for-laptop-and-v0-motbre9rx6ag1.webp"
                            }
                            ListElement {
                                modelData: "/home/mrinmoy/Documents/HB6Qleya4AA-r9k.jpg"
                            }
                            ListElement {
                                modelData: "/home/mrinmoy/Documents/can-anyone-please-give-me-similar-wallpaper-for-laptop-and-v0-motbre9rx6ag1.webp"
                            }
                            ListElement {
                                modelData: "/home/mrinmoy/Documents/can-anyone-please-give-me-similar-wallpaper-for-laptop-and-v0-motbre9rx6ag1.webp"
                            }
                            ListElement {
                                modelData: "/home/mrinmoy/Documents/can-anyone-please-give-me-similar-wallpaper-for-laptop-and-v0-motbre9rx6ag1.webp"
                            }
                            ListElement {
                                modelData: "/home/mrinmoy/Documents/can-anyone-please-give-me-similar-wallpaper-for-laptop-and-v0-motbre9rx6ag1.webp"
                            }
                            ListElement {
                                modelData: "/home/mrinmoy/Documents/can-anyone-please-give-me-similar-wallpaper-for-laptop-and-v0-motbre9rx6ag1.webp"
                            }
                            ListElement {
                                modelData: "/home/mrinmoy/Documents/can-anyone-please-give-me-similar-wallpaper-for-laptop-and-v0-motbre9rx6ag1.webp"
                            }
                            ListElement {
                                modelData: "/home/mrinmoy/Documents/can-anyone-please-give-me-similar-wallpaper-for-laptop-and-v0-motbre9rx6ag1.webp"
                            }
                            ListElement {
                                modelData: "/home/mrinmoy/Documents/can-anyone-please-give-me-similar-wallpaper-for-laptop-and-v0-motbre9rx6ag1.webp"
                            }
                            ListElement {
                                modelData: "/home/mrinmoy/Documents/can-anyone-please-give-me-similar-wallpaper-for-laptop-and-v0-motbre9rx6ag1.webp"
                            }
                        }

                        delegate: Item {
                            id: card
                            required property string modelData
                            required property int index
                            // Layout.fillWidth: true
                            implicitWidth: 400
                            implicitHeight: 225
                            scale: index === root.selectedIndex ? 1.05 : 1
                            Layout.rowSpan: image.sourceSize.width < image.sourceSize.height ? 2 : 1
                            Behavior on scale {
                                NumberAnimation {
                                    duration: 180
                                }
                            }
                            Image {
                                id: image
                                anchors.fill: parent
                                source: modelData
                                fillMode: Image.PreserveAspectCrop
                                cache: false
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

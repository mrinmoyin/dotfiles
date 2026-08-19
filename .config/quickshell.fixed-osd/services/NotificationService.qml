pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property bool centerOpen: false

    readonly property ListModel onScreenNotificationsModel: ListModel {}
    readonly property ListModel trackedNotificationsModel: ListModel {}
    // readonly property list<Notification> onScreenNotifications: onScreenNotificationsModel
    // readonly property list<Notification> trackedNotifications: server.trackedNotifications.values

    // function dismiss(index: int): void {
    //     const id = onScreenNotificationsModel.get(index).id;
    //     onScreenNotificationsModel.remove(index);
    //     console.log("dismiss notification", index, id);
    //     server.trackedNotifications.values.find(n => n.id === id)?.dismiss();
    // }
    function dismiss(id: int): void {
        // const id = onScreenNotificationsModel.get(index).id;
        // onScreenNotificationsModel.remove(index);
        console.log("dismiss notification id: ", id);
        onScreenNotificationsModel;
        server.trackedNotifications.values.find(n => n.id === id)?.dismiss();
    }
    function dismissAll(): void {
        console.log("dismiss all");
        trackedNotificationsModel.clear();
        onScreenNotificationsModel.clear();
        server.trackedNotifications.values.map(n => n.dismiss()); // BUG Only dismisses first one
        console.log("after dismiss all: ", JSON.stringify(server.trackedNotifications.values));

        // console.log(server.trackedNotifications.values[0].summary);
        // console.log(server.trackedNotifications.values[0].dismiss());
        // for (let i = 0; i < server.trackedNotifications.values.length; i++) {
        //     console.log("notification:", server.trackedNotifications.values[i].summary);
        //     server.trackedNotifications.values[i].dismiss();
        // }
        // for (const n of server.trackedNotifications.values) {
        //     console.log("notification:", n.summary);
        //     n.dismiss();
        // }
    }

    NotificationServer {
        id: server
        actionsSupported: true
        bodySupported: true
        imageSupported: true
        inlineReplySupported: true
        bodyImagesSupported: true

        onNotification: n => {
            console.log("Notification", JSON.stringify(n));
            // TODO inline reply support, launch app onclick and expire
            n.tracked = true;
            // n.time = Date.now();
            n.time = new Date();
            // n.time = Qt.formatDateTime(new Date(), "HH:mm");
            root.trackedNotificationsModel.insert(0, n);
            if (!ShellState.controlcenter) {
                root.onScreenNotificationsModel.insert(0, n);
                // root.onScreenNotificationsModel.insert(0, {
                //     id: n.id,
                //     summary: n.summary,
                //     body: n.body,
                //     appName: n.appName,
                //     appIcon: n.appIcon,
                //     urgency: n.urgency,
                //     time: n.time
                // });
            }
        }
    }

    // GlobalShortcut {
    //     name: "controls_center"
    //     description: "Controls Center"
    //
    //     onPressed: {
    //         root.centerOpen = !root.centerOpen;
    //         if (root.centerOpen)
    //             root.onScreenNotificationsModel.clear();
    //     }
    // }
}

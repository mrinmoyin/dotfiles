import Quickshell
import Quickshell.Hyprland
import "../services"

Scope {
    id: root

    GlobalShortcut {
        name: "launcher"
        description: "Toggle application launcher"

        onPressed: {
            if (ShellState.clipboard)
                ShellState.clipboard = false;
            ShellState.launcher = !ShellState.launcher;
        }
    }

    GlobalShortcut {
        name: "controlcenter"
        description: "Toggle control center"

        onPressed: {
            if (ShellState.osd)
                ShellState.osd = false;
            if (NotificationService.onScreenNotificationsModel.count)
                NotificationService.onScreenNotificationsModel.clear();
            ShellState.controlcenter = !ShellState.controlcenter;
        }
    }

    GlobalShortcut {
        name: "clipboard"
        description: "Toggle clipboard"

        onPressed: {
            if (ShellState.launcher)
                ShellState.launcher = false;
            ShellState.clipboard = !ShellState.clipboard;
        }
    }

    GlobalShortcut {
        name: "osd"
        description: "Toggle osd"

        onPressed: {
            if (!ShellState.controlcenter)
                ShellState.osd = !ShellState.osd;
        }
    }

    // GlobalShortcut {
    //     name: "help"
    //     description: "Toggle keybinds help"
    //
    //     onPressed: {
    //         ShellState.help = !ShellState.help;
    //     }
    // }

    GlobalShortcut {
        name: "help"
        description: "Toggle wallpaper selector"

        onPressed: {
            // ShellState.help = !ShellState.help;
            // ShellState.wallpaper = !ShellState.wallpaper;
            // ShellState.logout = !ShellState.logout;
            ShellState.mpd = !ShellState.mpd;
        }
    }

    GlobalShortcut {
        name: "logout"
        description: "Toggle logout menu"

        onPressed: {
            ShellState.logout = !ShellState.logout;
        }
    }

    GlobalShortcut {
        name: "showcase"
        description: "Toggle launcher, osd, controlcenter"

        onPressed: {
            console.log("showcase triggered");
            ShellState.launcher = ShellState.osd = ShellState.controlcenter = !(ShellState.launcher || ShellState.osd || ShellState.controlcenter);
        }
    }

    GlobalShortcut {
        name: "testmode"
        description: "Toggle test mode"

        onPressed: {
            ShellState.testmode = !ShellState.testmode;
        }
    }
}

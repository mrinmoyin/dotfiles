pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    property real sinkVolume: sink.audio.volume
    onSinkVolumeChanged: if (!ShellState.osd && !ShellState.controlcenter)
        ShellState.osd = true

    // Binding {
    //     target: ShellState
    //     property: "osd"
    //     value: sink.audio.volume && !ShellState.controlcenter ? true : false
    // }

    readonly property list<PwNode> applications: Pipewire.nodes.values.filter(node => node.isStream === true && node.isSink === true)

    PwObjectTracker {
        objects: [root.sink, root.source, ...root.applications]
    }
}

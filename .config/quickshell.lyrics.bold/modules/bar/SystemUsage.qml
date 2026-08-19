import QtQuick
import QtQuick.Layouts
import "../../services"
import "../../controls"

RowLayout {
    CircularProgressBar {
        size: 28
        lineWidth: 3
        icon: ""
        value: SystemUsageService.cpuUsage
    }
    CircularProgressBar {
        size: 28
        lineWidth: 3
        icon: ""
        value: SystemUsageService.memUsage
    }
    CircularProgressBar {
        size: 28
        lineWidth: 3
        icon: "󰋊"
        value: SystemUsageService.diskUsage
    }
    CircularProgressBar {
        size: 28
        lineWidth: 3
        icon: "󰔄"
        value: SystemUsageService.cpuTemp / 100
    }
}

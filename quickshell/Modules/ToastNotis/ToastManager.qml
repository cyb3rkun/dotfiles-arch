import Quickshell
import QtQuick
import qs.Singletons

Scope {
	PanelWindow {
		anchors {
			top: true
			right: true
			// margins: 20
		}
		color: Qt.rgba(0,0,0,0)
		mask: Visibility.None

		Column {
			spacing: 10
			Repeater {
				model: Notifications.activeNotifications
				delegate: Rectangle {
					width: 300
					height: 80
					color: "#2e3440"
					radius: 8
				}

				Text {
					text: modelData.summery
					color: "white"
					anchors.centerIn: parent
				}

				Timer {
					interval: 5000
					running: true
					onTriggered: modelData.dismiss()
				}
			}
		}
	}
}

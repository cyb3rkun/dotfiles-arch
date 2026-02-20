import Quickshell
import QtQuick
import qs.Singletons

Item {
	width: 40
	height: parent.height

	Text {
		text: "🔔 " + Notifications.activeNotifications.length
		visible: Notifications.activeNotifications.length > 0
		anchors.centerIn: parent
		color: "white"
	}
	MouseArea {
		anchors.fill: parent
		onClicked: Notifications.dismissAll()
	}
}

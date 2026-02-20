pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.Notifications

QtObject {
	readonly property var service: Notifications
	readonly property var activeNotifications:Notifications.notifications

	function dismissAll() {
		for (let i = 0; i < activeNotifications.length; i ++) {
			activeNotifications[i].dismiss()
		}
	}
}

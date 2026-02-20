import Quickshell.Hyprland
import Quickshell
import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import "Widgets"
import qs.Shapes
import qs.Singletons

Variants {
	model: Quickshell.screens

	PanelWindow {
		id: bar
		screen: modelData

		required property var modelData
		readonly property string monitorName: modelData.name

		color: Colors.transparent
		implicitHeight: 24
		anchors {
			top: true
			// bottom: true
			left: true
			right: true
		}

		// Left Section
		RowLayout {
			anchors.left: parent.left
			anchors.verticalCenter: parent.verticalCenter // Add this for vertical alignment
			anchors.leftMargin: 10 // Optional: Add some padding
			anchors.topMargin: 2

			WorkspaceModule {
				monitorName: bar.monitorName
				emptyBgCol: Qt.rgba(0, 1, 1, 0.8)
				activeBgCol: Colors.cyan
				inactiveBgCol: Qt.rgba(0, 1, 1, 0.4)
				activeTextCol: Colors.black
				inactiveTextCol: Colors.black
				emptyTextCol: Colors.white

				spacingP: 0
				borderWidth: 5
				borderRadius: 9
				spaceWidth: 38
				spaceHeight: (32 + 3) / 2

				readonly property var wsMap: ({
					"HDMI-A-2": [1, 2, 3, 4],
					"DP-2": [5, 6, 7, 8]
					// add more monitors
				})

				wsIds: wsMap[bar.monitorName] || []
			}
		}

		// Center Section
		RowLayout {
			anchors.centerIn: parent
			ClockModule {
				heightP: bar.implicitHeight - 2
				bgCol: Qt.rgba(0, 0, 0, 0.2)
				textCol: Colors.cyan
				borderCol: Colors.cyan
				borderWidth: 1.0
			}
		}

		//Right Section
		RowLayout {
			anchors.right: parent.right
			// anchors.verticalCenter: parent.verticalCenter // Add this for vertical alignment
			anchors.rightMargin: 0 // Optional: Add some padding
			spacing: 5

			SystemTray {
				color: Qt.rgba(0, 0, 0, 0.2)
			}
			PowermenuModule {}
		}
	}
}

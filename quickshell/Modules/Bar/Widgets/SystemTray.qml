import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.Shapes
import qs.Singletons

Item {
	id: root
	anchors.verticalCenter: parent.verticalCenter
	implicitWidth: container.implicitWidth
	implicitHeight: container.implicitHeight
	property int spacing: 2
	property color color: Colors.cyan

	property color borderCol: Colors.cyan
	property real borderWidth: 1.5

	ChamferRect {
		id: container
		// width: 70
		// height: 24
		cutTopLeft: 0
		cutTopRight: 0
		cutBottomLeft: 4
		cutBottomRight: 4
		implicitWidth: items.implicitWidth + 10
		implicitHeight: items.implicitHeight

		// Colors
		borderColor: root.borderCol
		color: root.color

		borderWidth: root.borderWidth

		RowLayout {
			id: items
			spacing: 0
			anchors.centerIn: parent
			anchors.horizontalCenterOffset: 1

			Repeater {
				model: SystemTray.items

				delegate: MouseArea {
					id: itemDelegate

					required property SystemTrayItem modelData

					implicitWidth: 22
					implicitHeight: 22
					hoverEnabled: true

					acceptedButtons: Qt.LeftButton | Qt.RightButton

					IconImage {
						anchors.fill: parent
						source: itemDelegate.modelData.icon
					}

					// TODO: improve state logic to reduce icky-ness
					onClicked: mouse => {
						if (mouse.button === Qt.LeftButton) {
							itemDelegate.modelData.activate();
							console.log("LeftButton SysTray");
							trayWindow.visible = false;
						} else if (mouse.button === Qt.RightButton) {
							console.log("RightButton SysTray");
							trayMenuAnchor.menu = modelData.menu;

							trayMenuAnchor.anchor.window = bar;
							// trayWindow.visible = trayWindow.visible = !trayWindow.visible;

							let coords = itemDelegate.mapToItem(null, 0, 0); // null maps to the window
							trayMenuAnchor.anchor.rect = Qt.rect(coords.x, coords.y, itemDelegate.width, itemDelegate.height);
							//
							trayMenuAnchor.open();
							// itemDelegate.modelData.display(trayWindow, mouse.x, mouse.y);
						}
					}
				}
			}
		}
	}
	QsMenuAnchor {
		id: trayMenuAnchor
	}
}

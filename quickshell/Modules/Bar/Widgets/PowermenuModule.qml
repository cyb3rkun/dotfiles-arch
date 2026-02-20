import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Shapes
import qs.Shapes
import qs.Singletons

Item {
	id: root

	property color btnFgHovCol: Colors.black
	property color btnFgCol: Colors.cyan
	property color hovBgCol: Colors.cyan
	property color btnBgCol: Qt.rgba(0, 1, 1, 0.12)
	property color btnBrdCol: Colors.cyan
	property color btnHovBrdCol: Colors.Cyan

	property color pwrBtnFgCol: Colors.cyan
	property color pwrBtnBgCol: Qt.rgba(0, 1, 1, 0.2)
	property color pwrBtnBrdrCol: Colors.cyan
	property color pwrBtnHovBrdrCol: Colors.cyan
	property color pwrBtnFgHovCol: Colors.black
	property color pwrBgHovCol: Qt.rgba(0,1,1, 0.5)

	property alias font: font
	QtObject {
		id: font
		property string family: "JetBrainsMono Nerd Font"
		property int size: 14
		property bool bold: false
		property real letterSpacing: 1.0
	}

	implicitWidth: menuButton.implicitWidth
	implicitHeight: menuButton.implicitHeight

	ChamferRect {
		id: menuButton
		anchors.centerIn: parent

		implicitWidth: btText.contentWidth + 10
		width: implicitWidth
		height: implicitWidth

		cutBottomLeft: 4
		cutBottomRight: 0
		cutTopLeft: 0
		cutTopRight: 0

		borderColor: root.btnBrdCol
		color: root.btnBgCol

		Text {
			id: btText
			anchors.centerIn: parent
			text: "⏻"
			color: root.btnFgCol
			font {
				family: root.font.family
				pixelSize: root.font.size
				bold: root.font.bold
			}
		}
		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			onEntered: {
				parent.color = root.hovBgCol;
				btText.color = root.btnFgHovCol;
			}
			onExited: {
				parent.color = root.btnBgCol;
				btText.color = root.btnFgCol;
			}
			onClicked: {
				if (!popup.active) {
					popup.active = true;
				} else {
					popup.active = false;
				}
			}
		}
	}

	PanelWindow {
		id: popup

		property bool active: false

		visible: active || slideAnimation.running

		// width: 300
		color: Colors.transparent

		anchors {
			top: true
			bottom: true
			right: true
			left: true
		}
		MouseArea {
			anchors.fill: parent

			onClicked: popup.active = false
		}

		// Rectangle {
		Column {
			id: menuRect
			// color: Colors.transparent

			height: column.implicitHeight + 24
			width: column.implicitWidth + 24

			anchors {
				bottom: parent.top
				right: parent.right

				bottomMargin: popup.active ? -height : height
			}

			Behavior on anchors.bottomMargin {
				NumberAnimation {
					id: slideAnimation
					duration: 250
					easing.type: Easing.OutCubic
				}
			}

			ChamferRect {
				id: menuRectb

				width: 320
				height: 40

				cutTopRight: 18
				cutTopLeft: 0
				cutBottomRight: 0
				cutBottomLeft: 18

				color: root.btnBgCol
				borderColor: root.pwrBtnBrdrCol

				anchors.fill: parent
				Column {
					id: column

					spacing: 12
					anchors {
						top: parent.top
						topMargin: 0
						horizontalCenter: parent.horizontalCenter
						centerIn: parent
					}

					Button {
						text: "Shutdown"
						iconSource: "../../Assets/power-symbol-svgrepo-com.svg"
						// icon: "⏻"
						iconOnly: true
						onClicked: {
							console.log("ShutDown");
							shellCommand.command = ["poweroff"];
							shellCommand.running = true;
						}
						IconImage {
							width: 80
							height: 80
							source: "image://icon/system-shutdown"
						}
					}
					Button {
						text: "Reboot"
						iconSource: "../../Assets/restart-svgrepo-com.svg"
						// icon: ""
						iconOnly: true
						onClicked: {
							console.log("Reboot");
							shellCommand.command = ["reboot"];
							shellCommand.running = true;
						}
						IconImage {
							width: 80
							height: 80
							source: "image://icon/system-reboot"
						}
					}
					Button {
						text: "Sleep"
						iconSource: "../../Assets/zzz-fill-svgrepo-com.svg"
						// icon: "󰤄"
						iconOnly: true
						onClicked: {
							console.log("Sleep");
							shellCommand.command = ["systemctl", "suspend"];
							shellCommand.running = true;
						}
						IconImage {
							width: 80
							height: 80
							source: "image://icon/system-suspend-uninhibited"
						}
					}
					Button {
						iconSource: "../../Assets/logout-svgrepo-com.svg"
						text: "Logout"
						// icon: "󰍃"
						iconOnly: true
						onClicked: {
							console.log("Logout");
							shellCommand.command = ["uwsm", "stop"];
							shellCommand.running = true;
						}
						IconImage {
							width: 80
							height: 80
							source: "image://icon/system-log-out-rtl"
						}
					}
				}
			}
			// ChamferRect {
			// 	widthP: 218
			// 	heightP: 20
			//
			// 	cutTopRight: 0
			// 	cutTopLeft: 0
			// 	cutBottomRight:10
			// 	cutBottomLeft:4
			//
			// 	color: Colors.cyan
			//
			// 	anchors.top: parent.bottom
			// 	anchors.left: parent.left
			// 	anchors.leftMargin: 26
			//
			// 	Text {
			// 		anchors.centerIn: parent
			// 		color: root.buttonFgHovCol
			// 		text: "Power Menu"
			// 		font {
			// 			family: root.font.family
			// 			pixelSize: root.font.size
			// 			bold: true
			// 		}
			// 	}
			// }
		}
	}

	Process {
		id: shellCommand
	}
	component Button: ChamferRect {
		id: bin

		signal clicked

		property string text: ""
		property string icon: ""
		property string iconSource

		property bool iconOnly: false

		width: iconOnly ? 80 : 110
		height: iconOnly ? 80 : 40

		cutTopRight: 12
		cutTopLeft: 0
		cutBottomRight: 0
		cutBottomLeft: 12

		color: root.pwrBtnBgCol
		borderColor: root.pwrBtnBrdrCol
		Text {
			id: text
			anchors {
				left: parent.left
				// leftMargin: 18
				verticalCenter: parent.verticalCenter
				centerIn: parent
			}
			text: iconOnly ? bin.icon : bin.icon + bin.text
			color: root.pwrBtnFgCol

			font {
				family: root.font.family
				pixelSize: iconOnly ? 42 : root.font.size
				bold: root.font.bold
			}
		}
		MouseArea {
			anchors.fill: parent
			hoverEnabled: true

			onEntered: {
				parent.color = root.pwrBgHovCol;
				text.textCol = root.pwrBtnFgHovCol;
			}

			onExited: {
				parent.color = root.pwrBtnBgCol;
				text.color = root.pwrBtnFgCol;
			}
			onClicked: bin.clicked()
		}
	}
}

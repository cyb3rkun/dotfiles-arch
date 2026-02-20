// ClockWidget.qml
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.Singletons
import qs.Shapes

Item {
	id: root
	property color bgCol: Colors.background
	property color textCol: Colors.white
	property color borderCol: Colors.cyan

	property int heightP: 24
	property int horizontalPadding: 20
	property real borderWidth: 1.0

	property int cutTopLeft: 0
	property int cutTopRight: 6
	property int cutBottomLeft: 6
	property int cutBottomRight: 0

	property alias font: font
	QtObject {
		id: font
		property string family: "JetBrainsMono Nerd Font"
		property int size: 14
		property bool bold: true
		property real letterSpacing: 1.0
	}
	implicitWidth: time.contentWidth + horizontalPadding
	// implicitHeight: heightP

	ChamferRect {
		anchors.centerIn: parent
		width: root.implicitWidth
		height: root.heightP

		borderWidth: root.borderWidth
		color: root.bgCol
		borderColor: root.borderCol

		cutTopLeft: root.cutTopLeft
		cutTopRight: root.cutTopRight
		cutBottomLeft: root.cutBottomLeft
		cutBottomRight: root.cutBottomRight

		Text {
			id: time
			anchors.centerIn: parent
			text: Time.time
			color: root.textCol
			font {
				family: root.font.family
				pixelSize: root.font.size
				bold: root.font.bold
			}
		}
	}
}

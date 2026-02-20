import QtQuick
import "../QtSingletons"

Item {
	id: root

	width: implicitWidth
	height: implicitHeight

	property color color: Colors.background
	property color borderColor: Colors.cyan

	property real borderWidth: 1.0

	// Individual cut sizes in pixels
	property real cutTopLeft: 10
	property real cutTopRight: 10
	property real cutBottomRight: 10
	property real cutBottomLeft: 10

	// Individual angles (45 is standard)
	property real angleTopLeft: 45
	property real angleTopRight: 45
	property real angleBottomRight: 45
	property real angleBottomLeft: 45

	// Inside ChamferRect.qml
	ShaderEffect {
		// Use Math.max to prevent 0-sized shaders which can crash/be invisible
		width: Math.max(root.width, 1)
		height: Math.max(root.height, 1)
		anchors.centerIn: parent

		property color fillColor: root.color
		property color strokeColor: root.borderColor
		property real bWidth: root.borderWidth

		// Explicitly cast to the types the shader expects
		property var size: Qt.vector2d(width, height)
		property var cuts: Qt.vector4d(root.cutTopLeft, root.cutTopRight, root.cutBottomRight, root.cutBottomLeft)
		property var angles: Qt.vector4d(root.angleTopLeft, root.angleTopRight, root.angleBottomRight, root.angleBottomLeft)

		fragmentShader: "Shaders/chamfer.frag.qsb"
	}
}

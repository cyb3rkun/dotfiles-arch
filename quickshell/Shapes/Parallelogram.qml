import QtQuick

Item {
	id: root

	property color color: "cyan"
	property real skew: 20 // Pixel offset for the slant
	property real borderWidth: 1.0
	property color borderColor: "white"

	property alias layoutWidth: root.implicitWidth
	property alias layoutHeight: root.implicitHeight

	property real contentPadding: Math.abs(skew)
	ShaderEffect {
		anchors.fill: parent

		property color fillColor: root.color
		property color strokeColor: root.borderColor

		// Pass the raw pixel value instead of a ratio
		property real bWidth: root.borderWidth

		property real skewFactor: root.skew / root.width
		property vector2d size: Qt.vector2d(width, height)

		fragmentShader: "Shaders/parallelogram.frag.qsb"
	}
}

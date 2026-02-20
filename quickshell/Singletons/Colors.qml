// Themes/Colors.qml

// This pragma tells the QML engine that this object is a singleton.
pragma Singleton

import QtQuick

// QtObject is a basic, non-visual QML type, perfect for holding properties.

QtObject {
	// Define all your theme colors here as properties.
	// The 'readonly' keyword is good practice to prevent them from being changed accidentally.

	// Core Palette
	readonly property color background: "#1a1b26" // Main background
	readonly property color foreground: "#a9b1d6" // Default text
	readonly property color comment: "#565f89" // Comments and subtle text
	readonly property color black: "#06080a" // True black, for borders etc.
	readonly property color white: "#d2d2d2" // True black, for borders etc.

	// Accent Colors
	readonly property color blue: "#7aa2f7" // Functions, keywords
	readonly property color cyan: "#7dcfff" // Includes, types
	readonly property color green: "#9ece6a" // Strings
	readonly property color orange: "#ff9e64" // Numbers, constants

	readonly property color red: "#f7768e" // Errors, special keywords
	readonly property color magenta: "#bb9af7" // Variables, parameters
	readonly property color yellow: "#e0af68" // Warnings, attributes
	readonly property color transparent: "#00000000"

	// You can also define other theme variables
	readonly property int baseSpacing: 8
	readonly property font baseFont: Qt.font({
		family: "JetBrains Mono",
		pixelSize: 14
	})
}

// WorkspaceModule.qml
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../../QtSingletons" // Make sure this path is correct
import qs.Shapes

RowLayout {
	id: root
	// --- Configurable colors ---
	property color activeTextCol: Colors.orange
	property color emptyTextCol: Colors.blue
	property color inactiveTextCol: Colors.comment

	property color activeBgCol: Colors.orange
	property color emptyBgCol: Colors.blue
	property color inactiveBgCol: Colors.comment

	property color activeBorderCol: Colors.orange
	property color emtpyBorderCol: Colors.blue
	property color inactiveBorderCol: Colors.comment

	// -- layout properties --
	property int borderWidth: 2
	property int borderRadius: 1
	property int spaceWidth: 28
	property int spaceHeight: 28
	property int spacingP: 5

	property string monitorName: ""

	spacing: spacingP
	anchors.margins: 0

	property var wsIds: []

	anchors.verticalCenter: parent.verticalCenter

	Repeater {
		// model: root.monitorWorkspaces
		model: root.wsIds
		Parallelogram {
			id: spaceBgRect

			Layout.alignment: Qt.AlignVCenter
			readonly property int modelId: root.wsIds[index]

			property var ws: Hyprland.workspaces.values.find(w => w.id === wsIds[index])
			property bool isActive: Hyprland.focusedWorkspace?.id === wsIds[index]


			// border.color: isActive ? root.activeBorderCol : (ws ? root.emtpyBorderCol : root.inactiveBorderCol)
			implicitWidth: root.spaceWidth
			implicitHeight: root.spaceHeight

			Layout.preferredHeight: isActive ? root.spaceHeight : (ws ? root.spaceHeight/2:root.spaceHeight/2)
			Layout.preferredWidth: isActive ? root.spaceWidth + 6 : (ws ? root.spaceWidth : root.spaceWidth)
			Layout.leftMargin: isActive ? -4 : 0
			Layout.rightMargin: isActive ? -4 : 0

			width: Layout.preferredWidth
			height: Layout.preferredHeight
			
			color: isActive ? root.activeBgCol : (ws ? root.emptyBgCol : root.inactiveBgCol)
			borderColor: isActive ? root.activeBgCol : (ws ? root.inactiveBgCol : root.emptyBgCol)

			skew: isActive ? 15 : (ws ? 8 : 8)
			borderWidth: 0

			MouseArea {
				anchors.fill: parent
				onClicked: Hyprland.dispatch("workspace " + modelId)
			}
		}
	}
}

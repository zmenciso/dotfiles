import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore

import "lib"

// Based on the DefaultCompactRepresentation
// https://github.com/KDE/plasma-desktop/blob/master/desktoppackage/contents/applet/DefaultCompactRepresentation.qml
Item {
	id: panelItem

	readonly property bool inPanel: (plasmoid.location == PlasmaCore.Types.TopEdge
		|| plasmoid.location == PlasmaCore.Types.RightEdge
		|| plasmoid.location == PlasmaCore.Types.BottomEdge
		|| plasmoid.location == PlasmaCore.Types.LeftEdge)

	Layout.minimumWidth: {
		switch (plasmoid.formFactor) {
		case PlasmaCore.Types.Vertical:
			return 0
		case PlasmaCore.Types.Horizontal:
			return height
		default:
			return units.gridUnit * 3
		}
	}

	Layout.minimumHeight: {
		switch (plasmoid.formFactor) {
		case PlasmaCore.Types.Vertical:
			return width
		case PlasmaCore.Types.Horizontal:
			return 0
		default:
			return units.gridUnit * 3
		}
	}

	Layout.maximumWidth: inPanel ? units.iconSizeHints.panel : -1
	Layout.maximumHeight: inPanel ? units.iconSizeHints.panel : -1

	readonly property string iconSource: icon.usingPackageSvg ? icon.filename : icon.source
	AppletIcon {
		id: icon
		anchors.fill: parent

		source: plasmoid.configuration.icon
		active: mouseArea.containsMouse
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		hoverEnabled: true

		property bool wasExpanded: false
		onPressed: wasExpanded = plasmoid.expanded
		onClicked: plasmoid.expanded = !wasExpanded
	}
}

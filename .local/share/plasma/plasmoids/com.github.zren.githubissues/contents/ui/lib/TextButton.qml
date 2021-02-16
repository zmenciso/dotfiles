import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore

TextLabel {
	id: textButton
	Layout.alignment: Qt.AlignTop
	
	property color textColor: mouseArea.containsMouse ? PlasmaCore.ColorScope.highlightColor : PlasmaCore.ColorScope.textColor
	color: textColor
	wrapMode: Text.Wrap
	font.family: 'Helvetica'
	font.pointSize: -1
	font.pixelSize: 16 * units.devicePixelRatio
	
	signal clicked(var mouse)

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		Layout.alignment: Qt.AlignTop
		hoverEnabled: true
		cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
		
		onClicked: textButton.clicked(mouse)
	}
}


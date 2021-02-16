// Version 2

import QtQuick 2.0

Rectangle {
	id: tagRect
	implicitWidth: horzPadding + tagText.implicitWidth + horzPadding
	implicitHeight: vertPadding + tagText.implicitHeight + vertPadding
	property int horzPadding: 4 * units.devicePixelRatio
	property int vertPadding: 1 * units.devicePixelRatio
	
	color: "#006b75"
	radius: 2 * units.devicePixelRatio

	property alias text: tagText.text
	property alias font: tagText.font
	property alias lineHeight: tagText.lineHeight
	property alias lineHeightMode: tagText.lineHeightMode
	

	property alias backgroundColor: tagRect.color
	property alias textColor: tagText.color

	TextLabel {
		id: tagText
		anchors.centerIn: parent
		text: ""
		font.pointSize: -1
		font.pixelSize: 12 * units.devicePixelRatio
		lineHeight: 15 * units.devicePixelRatio
		lineHeightMode: Text.FixedHeight
		color: "#ffffff"
	}
}

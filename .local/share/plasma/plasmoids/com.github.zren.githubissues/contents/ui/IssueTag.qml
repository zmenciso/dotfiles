// Version 1
import QtQuick 2.0
import "lib"

TextTag {
	visible: text

	function alpha(c, a) {
		return Qt.rgba(c.r, c.g, c.b, a)
	}
	function lerpColor(a, b, ratio) {
		return Qt.tint(a, alpha(b, ratio))
	}
	backgroundColor: lerpColor(theme.backgroundColor, theme.textColor, 0.2)
	textColor: lerpColor(theme.backgroundColor, theme.textColor, 0.85)
	font.weight: Font.Bold
	font.pixelSize: 12 * units.devicePixelRatio
	lineHeight: 15 * units.devicePixelRatio
	property int rightMargin: 4 * units.devicePixelRatio
}

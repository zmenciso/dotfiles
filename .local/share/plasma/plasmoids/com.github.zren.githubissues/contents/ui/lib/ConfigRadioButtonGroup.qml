// Version 2

import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

/*
** Example:
**
ConfigRadioButtonGroup {
	configKey: "appDescription"
	model: [
		{ value: "a", text: i18n("A") },
		{ value: "b", text: i18n("B") },
		{ value: "c", text: i18n("C") },
	]
}
*/
ColumnLayout {
	id: configRadioButtonGroup
	ExclusiveGroup { id: radioButtonGroup }

	property string configKey: ''
	readonly property string configValue: configKey ? plasmoid.configuration[configKey] : ""

	property alias model: buttonRepeater.model

	Repeater {
		id: buttonRepeater
		RadioButton {
			text: modelData.text
			checked: modelData.value == configValue
			exclusiveGroup: radioButtonGroup
			onClicked: {
				plasmoid.configuration[configKey] = modelData.value
			}
		}
	}
}

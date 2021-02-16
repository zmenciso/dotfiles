// Version 4

import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import "lib"
import "lib/TimeUtils.js" as TimeUtils

Item {
	id: issueListView

	property bool isSetup: false
	property bool showHeading: true
	property string headingText: ""

	property alias delegate: listView.delegate

	property alias scrollView: scrollView
	property alias listView: listView
	property alias heading: heading
	property alias relativeDateTimer: relativeDateTimer

	Layout.minimumWidth: 300 * units.devicePixelRatio
	Layout.minimumHeight: 200 * units.devicePixelRatio
	Layout.preferredHeight: 600 * units.devicePixelRatio

	RelativeDateTimer { id: relativeDateTimer }

	ColumnLayout {
		anchors.fill: parent
		visible: issueListView.isSetup

		PlasmaComponents.Label {
			id: heading
			Layout.fillWidth: true
			visible: issueListView.showHeading
			text: issueListView.headingText
			font.weight: Font.Bold
			font.pointSize: -1
			font.pixelSize: 18 * units.devicePixelRatio
			elide: Text.ElideRight
			wrapMode: Text.NoWrap
			fontSizeMode: Text.Fit

			PlasmaCore.ToolTipArea {
				anchors.fill: parent
				enabled: parent.truncated
				subText: parent.text
			}
		}

		ScrollView {
			id: scrollView
			Layout.fillWidth: true
			Layout.fillHeight: true

			ListView {
				id: listView
				width: scrollView.width

				model: issuesModel
			}
		}

	}

	PlasmaComponents.Button {
		anchors.centerIn: parent
		visible: !issueListView.isSetup
		text: plasmoid.action("configure").text
		onClicked: plasmoid.action("configure").trigger()
	}
}

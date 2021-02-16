// Version 5

import QtQuick 2.9
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import "lib"
import "lib/TimeUtils.js" as TimeUtils

ColumnLayout {
	id: issueListItem

	spacing: 0
	width: listView.width

	readonly property var issue: modelData

	property string issueSummary: ''
	property string issueId: '123'
	property string issueIdStr: '#' + issueId
	property bool issueOpen: true
	property string issueHtmlLink: 'https://www.google.com'
	property bool showNumComments: numComments > 0
	property int numComments: 0
	property string issueCreatorName: "Submitter"
	
	// ['opened', 'closed', 'openPullRequest', 'closedPullRequest', 'merged']
	property string issueState: 'opened'

	property alias dateTime: timestampText.dateTime
	property alias tagBefore: issueTagBefore.text
	property alias tagBeforeTextColor: issueTagBefore.textColor
	property alias tagBeforeBackgroundColor: issueTagBefore.backgroundColor
	property alias category: categoryText.text

	Rectangle {
		visible: (heading.visible && index == 0) || index > 0
		Layout.fillWidth: true
		color: theme.textColor
		Layout.preferredHeight: 1 * units.devicePixelRatio
		opacity: 0.3
	}
	
	RowLayout {
		Layout.fillWidth: true

		property int sidePadding: 16 * units.devicePixelRatio
		Layout.rightMargin: sidePadding
		Layout.leftMargin: sidePadding

		property int padding: 8 * units.devicePixelRatio
		Layout.topMargin: padding
		Layout.bottomMargin: padding

		TextLabel {
			id: issueTitleIcon
			
			text: {
				var s = issueListItem.issueState
				if (s == 'opened') {
					return octicons.issueOpened
				} else if (s == 'closed') {
					return octicons.issueClosed
				} else if (s == 'openPullRequest' || s == 'closedPullRequest') {
					return octicons.gitPullRequest
				} else if (s == 'merged') {
					return octicons.gitMerge
				} else { // ?!
					return ''
				}
			}
			color: {
				var s = issueListItem.issueState
				if (s == 'opened' || s == 'openPullRequest') {
					return '#28a745'
				} else if (s == 'closed' || s == 'closedPullRequest') {
					return '#cb2431'
				} else if (s == 'merged') {
					return '#6f42c1'
				} else { // ?!
					return ''
				}
			}
			font.family: "fontello"
			font.pointSize: -1
			font.pixelSize: 16 * units.devicePixelRatio
			// font.weight: Font.Bold
			Layout.alignment: Qt.AlignTop
			Layout.minimumWidth: 16 * units.devicePixelRatio
			Layout.minimumHeight: 16 * units.devicePixelRatio
		}

		ColumnLayout {
			spacing: 4 * units.devicePixelRatio

			TextButton {
				id: issueTitleLabel

				Layout.fillWidth: true
				text: issueListItem.issueSummary
				font.weight: Font.Bold

				onClicked: Qt.openUrlExternally(issueListItem.issueHtmlLink)

				onLineLaidOut: {
					if (line.number == 0 && issueTagBefore.visible) {
						var indent = issueTagBefore.width + issueTagBefore.rightMargin
						line.x += indent
						line.width -= indent
					}
				}

				IssueTag {
					id: issueTagBefore
					onVisibleChanged: issueTitleLabel.forceLayout()
				}
			}

			TextLabel {
				id: categoryText
				Layout.fillWidth: true
				wrapMode: Text.Wrap
				font.family: 'Helvetica'
				font.pointSize: -1
				font.pixelSize: 12 * units.devicePixelRatio
				opacity: 0.6
				font.weight: Font.Bold

				text: ""
				visible: text
			}

			TextLabel {
				id: timestampText
				Layout.fillWidth: true
				wrapMode: Text.Wrap
				font.family: 'Helvetica'
				font.pointSize: -1
				font.pixelSize: 12 * units.devicePixelRatio
				opacity: 0.6

				text: ""
				property var dateTime: new Date()
				property string dateTimeText: ""
				Component.onCompleted: timestampText.updateText()
				
				Connections {
					target: relativeDateTimer
					onTriggered: timestampText.updateText()
				}

				function updateRelativeDate() {
					dateTimeText = TimeUtils.getRelativeDate(dateTime)
				}

				function updateText() {
					updateRelativeDate()

					var s = issueListItem.issueState
					if (s == 'opened' || s == 'openPullRequest') {
						// '#19 opened 7 days ago by RustyRaptor'
						text = i18n("%1 opened %2 by %3", issueListItem.issueIdStr, dateTimeText, issueListItem.issueCreatorName)
					} else if (s == 'closed' || s == 'closedPullRequest') {
						// '#14 by JPRuehmann was closed on 5 Jul'
						text = i18n("%1 by %3 was closed %2", issueListItem.issueIdStr, dateTimeText, issueListItem.issueCreatorName)
					} else if (s == 'merged') {
						text = i18n("%1 by %3 was merged %2", issueListItem.issueIdStr, dateTimeText, issueListItem.issueCreatorName)
					} else { // ?!
						text = ''
					}
				}
			}
		}

		MouseArea {
			id: commentButton
			Layout.alignment: Qt.AlignTop
			implicitWidth: commentButtonRow.implicitWidth
			implicitHeight: commentButtonRow.implicitHeight

			visible: issueListItem.showNumComments
			
			hoverEnabled: true
			cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
			property color textColor: containsMouse ? PlasmaCore.ColorScope.highlightColor : PlasmaCore.ColorScope.textColor

			onClicked: Qt.openUrlExternally(issueListItem.issueHtmlLink)

			RowLayout {
				id: commentButtonRow
				spacing: 0

				TextLabel {
					text: octicons.comment
					
					color: commentButton.textColor
					font.family: "fontello"
					// font.weight: Font.Bold
					font.pointSize: -1
					font.pixelSize: 16 * units.devicePixelRatio
					Layout.preferredHeight: 16 * units.devicePixelRatio
				}

				TextLabel {
					text: " " + issueListItem.numComments
					
					color: commentButton.textColor
					font.family: "Helvetica"
					// font.weight: Font.Bold
					font.pointSize: -1
					font.pixelSize: 12 * units.devicePixelRatio
					Layout.preferredHeight: 12 * units.devicePixelRatio
					Layout.alignment: Qt.AlignTop
				}
			}
		}
	}
}

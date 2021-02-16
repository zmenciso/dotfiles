// Version 1

import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.0

ColumnLayout {
	id: page
	Layout.fillWidth: true
	
	property alias dbName: localDb.name
	property alias dbVersion: localDb.version
	property alias dbDescription: localDb.description
	property alias dbEstimatedSize: localDb.estimatedSize
	LocalDb {
		id: localDb
		name: plasmoid.pluginName
	}
	Component.onCompleted: {
		localDb.initDb(function(err){
			localDb.getAllAsList(function(err, data, rows){
				tableView.model = data
			})
		})
	}


	// https://github.com/qt/qtquickcontrols/blob/5.11/src/controls/TableView.qml
	// https://github.com/qt/qtquickcontrols/blob/5.11/src/controls/Private/BasicTableView.qml
	// https://github.com/qt/qtquickcontrols/blob/5.11/src/controls/Private/TableViewItemDelegateLoader.qml
	TableView {
		id: tableView

		Layout.fillWidth: true
		Layout.fillHeight: true

		model: []

		property int viewportWidth: tableView.width - (40 * units.devicePixelRatio)

		TableViewColumn {
			role: "key"
			title: i18n("Key")
			width: tableView.viewportWidth * 1/3
		}
		TableViewColumn {
			role: "value"
			title: i18n("Value")
			width: tableView.viewportWidth * 2/3
			delegate: TextField {
				text: {
					if (styleData.value) {
						return JSON.stringify(styleData.value)
					} else {
						return ''
					}
				}
			}
		}
	}
}

import QtQuick 2.0

import org.kde.plasma.configuration 2.0

ConfigModel {
	ConfigCategory {
		name: i18n("General")
		icon: "configure"
		source: "config/ConfigGeneral.qml"
	}
	ConfigCategory {
		name: i18n("Debug: LocalDB")
		icon: "application-x-sqlite3"
		source: "lib/ConfigLocalDBView.qml"
		visible: false
	}
}

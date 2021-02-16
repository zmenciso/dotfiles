// Version 1

import QtQuick 2.0
import QtQuick.LocalStorage 2.0

// http://doc.qt.io/qt-5/qtquick-localstorage-qmlmodule.html
QtObject {
	id: localDb
	property string name
	property string version: "1"
	property string description: ""
	property int estimatedSize: 1 * 1024 * 1024 // 1 MiB
	property var db: null

	property var loggerObj: Logger {
		id: logger
		name: 'localdb'
		// showDebug: true
	}
	property alias showDebug: logger.showDebug

	function initDb(callback) {
		logger.debug('initDb.start')
		db = LocalStorage.openDatabaseSync(name, version, description, estimatedSize)

		db.transaction(function(tx) {
			// Create the database if it doesn't already exist
			var sql = 'CREATE TABLE IF NOT EXISTS KeyValue('
			sql += 'name TEXT NOT NULL PRIMARY KEY,'
			sql += 'dataStr TEXT,'
			sql += 'created_at timestamp NOT NULL DEFAULT current_timestamp,'
			sql += 'updated_at timestamp NOT NULL DEFAULT current_timestamp)'
			tx.executeSql(sql)

			logger.debug('initDb.ready')
			callback(null)
		})
	}

	function get(key, callback) {
		db.transaction(function(tx) {
			var rs = tx.executeSql('SELECT * FROM KeyValue WHERE name = ?', key)
			var row = null
			if (rs.rows.length >= 1) {
				var row = rs.rows.item(0)
			}
			logger.debug('db.get', key, row && row.updated_at, row && row.dataStr)
			callback(null, row)
		})
	}

	function getJSON(key, callback) {
		get(key, function(err, row){
			if (err) {
				callback(err, null, row)
			} else {
				if (row) {
					var data = row.dataStr
					if (row.dataStr) {
						data = JSON.parse(data)
					}
					callback(null, data, row)
				} else {
					callback(null, null, null)
				}
			}
		})
	}

	function set(key, value, callback) {
		db.transaction(function(tx) {
			tx.executeSql('INSERT OR REPLACE INTO KeyValue(name, dataStr, updated_at) VALUES (?, ?, current_timestamp)', [key, value])
			logger.debug('db.set', key, value)
			callback(null)
		})
	}

	function setJSON(key, value, callback) {
		var dataStr = JSON.stringify(value)
		set(key, dataStr, callback)
	}



	function getAll(callback) {
		db.transaction(function(tx) {
			var rs = tx.executeSql('SELECT * FROM KeyValue')
			logger.debug('db.getAll', rs.rows.length)
			callback(null, rs.rows)
		})
	}
	function getAllAsMap(callback) {
		getAll(function(err, rows){
			logger.debug('db.getAllAsMap', rows.length)
			if (err) {
				callback(err, null, rows)
			} else {
				var data = {}
				for (var i = 0; i < rows.length; i++) {
					var row = rows[i]
					if (row.dataStr) {
						data[row.name] = JSON.parse(row.dataStr)
					} else {
						data[row.name] = null
					}
				}
			}
		})
	}
	function getAllAsList(callback) {
		getAll(function(err, rows){
			logger.debug('db.getAllAsList', rows.length)
			if (err) {
				callback(err, null, rows)
			} else {
				var arr = []
				for (var i = 0; i < rows.length; i++) {
					var row = rows[i]
					var value = row.dataStr ? JSON.parse(row.dataStr) : null
					var item = {
						key: row.name,
						value: value,
					}
					arr.push(item)
				}
				callback(null, arr, rows)
			}
		})
	}

	function deleteAll(callback) {
		logger.debug('db.deleteAll.start')
		db.transaction(function(tx) {
			var rs = tx.executeSql('DELETE FROM KeyValue')
			logger.debug('db.deleteAll.done')
			callback(null)
		})
	}
}

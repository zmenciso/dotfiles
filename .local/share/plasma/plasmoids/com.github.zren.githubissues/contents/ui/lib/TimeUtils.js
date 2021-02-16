function isSameDate(a, b) {
	return a.getFullYear() == b.getFullYear() && a.getMonth() == b.getMonth() && a.getDate() == b.getDate()
}
function getRelativeDate(dateStr) {
	return relativeDateToNow(new Date(dateStr))
}
function relativeDateToNow(a) {
	var aTime = a.getTime()
	var now = new Date()
	var nowTime = now.getTime()
	var deltaTime = nowTime - aTime

	var oneSecond = 1000
	var oneMinute = oneSecond * 60
	var oneHour = oneMinute * 60
	var oneDay = oneHour * 24
	var oneMonth = oneDay * 30
	var oneYear = oneDay * 365

	// console.log('relativeDateToNow', a, 'deltaTime', deltaTime)
	if (deltaTime < oneMinute) {
		return i18n("just now")
	} else if (deltaTime < oneHour) {
		var minutes = Math.floor(deltaTime / oneMinute)
		return i18np("%1 minute ago", "%1 minutes ago", minutes)
	} else if (deltaTime < oneDay) {
		var hours = Math.floor(deltaTime / oneHour)
		return i18np("%1 hour ago", "%1 hours ago", hours)
	} else if (deltaTime < oneMonth) {
		var days = Math.floor(deltaTime / oneDay)
		return i18np("%1 day ago", "%1 days ago", days)
	} else if (deltaTime < oneYear) {
		var months = Math.floor(deltaTime / oneMonth)
		return i18np("%1 month ago", "%1 months ago", months)
	} else {
		var years = Math.floor(deltaTime / oneYear)
		return i18np("%1 year ago", "%1 years ago", years)
	}
}

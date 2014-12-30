# Flash Interface
#
# Yep, this stuff needs to be out in the open, polluting the global namespace. Gross. Sorry.

window.hasAPI = ()->
	return true

window.awardPoints = (percent, exact, name)->
	window.dispatchEvent new CustomEvent "cdAwardPoints", detail:
		id: name
		percent: 100
		exact: 0
	return true

# Backend: LocalStorage
# This service provides the standard Backend API, backed by the browser's LocalStorage.
# It's a very simple backend intended for testing.
#
# Compatability:
# LocalStorage - IE8
# JSON - IE8


Take "load", ()->
	KEY = "Backend-LocalStorage"
	
	Make "Backend",
		
		getPersistedData: ()->
			json = window.localStorage[KEY]
			return JSON.parse(json) if json?
		

		setPersistedData: (data)->
			if data?
				json = JSON.stringify(data)
				window.localStorage[KEY] = json
				return true
			else
				return false
		
		
		complete: ()->
			return true

# Params
# Pull all the query params out of the URL and turn them into a hash.

Make "Params", do ()->
	
	params = {}
	paramStrings = window.location.search.substr(1).split("&")
	
	for paramString in paramStrings
		paramParts = paramString.split("=")
		params[paramParts[0]] = paramParts[1] or true
	
	return Object.freeze(params)

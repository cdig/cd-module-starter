# Backend: SCORM 2004
# This service wraps the SCORM 2004 API and exposes a standard interface to the rest of the system.
# It will automatically set itself up, and fire an event when it is ready. It will also tear itself
# down when `unload` fires. Other backend services may be swapped in place of this one. Just make
# sure they place the same properties on `window.Backend`.
#
# Compatability:
# Only works with SCORM 2004
# Throws an error if it can't find the SCORM API Object

do ()->
	scormAPI = null
	connected = false
	
	
	Take "load", ()->
		setupScormAPI()
		setupConnection()
		setupStatuses()
		setupNavigation()
		
		Take "unload", ()->
			commit() # Ensures that we our navigation status (etc) is saved
			disconnect()
				
		Make "Backend",
			getPersistedData: ()->
				json = getValue("cmi.suspend_data") || "{}"
				return JSON.parse(json)
			
			setPersistedData: (data)->
				json = JSON.stringify(data)
				success = setValue("cmi.suspend_data", json)
				return success and commit()
			
			complete: ()->
				# Assumption: we should only set a score on completion, and not when the user is incomplete
				s = setValue("cmi.score.scaled", 1)
				m = setValue("cmi.score.min", 0)
				M = setValue("cmi.score.max", 1)
				r = setValue("cmi.score.raw", 1)
				
				c = setValue("cmi.completion_status", "completed")
				p = setValue("cmi.success_status", "passed")
				
				return s and m and M and r and c and p and commit()
			
	
# SETUP
	
	setupScormAPI = ()->
		return if (scormAPI = findScormAPIObject(window))?
		return if (scormAPI = findScormAPIObject(window.top?.opener))?
		return if (scormAPI = findScormAPIObject(window.top?.opener?.document))? # Special handling for Plateau
		throw new Error("SCORM 2004 API not found.")
	
	
	setupConnection = ()->
		connected = scormGet("Initialize", "", true)
		console.log("Connecting failed.") unless connected
		
		
	setupStatuses = ()->
		setValue("cmi.exit", "suspend")
		status = getValue("cmi.completion_status")
		if status isnt "completed"
			setValue("cmi.completion_status", "incomplete")
		
	
	setupNavigation = ()->
		setValue("adl.nav.request", "suspendAll")
	
	
# HIGH LEVEL WRAPPED SCORM NICENESS
	
	getValue = (parameter)->
		return scormGet("GetValue", parameter)
	
	
	setValue = (parameter, value)->
		return scormSet("SetValue", parameter, value)
	
	
	commit = ()->
		return scormGet("Commit", "")
	
	
	disconnect = ()->
		console.log "DISCONNECT DISABLED"
		# if connected
		# 	if scormGet("Terminate", "")
		# 		connected = false
		# return !connected
		return true
		
	
# LOW LEVEL RAW SCORM UGLINESS
	
	findScormAPIObject = (context)->
		if context?
			findAttempts = 10
			while findAttempts-- > 0
				switch
					when context.API_1484_11? 			then return context.API_1484_11
					when not context.parent? 				then return null
					when context.parent is context	then return null
					else context = context.parent
		
	
	scormGet = (name, parameter, force = false)->
		failureMsg = "API.#{name}(#{parameter}) failed:"
		
		if connected or force
			result = String(scormAPI[name](parameter))
			if getSucceeded(result)
				return result
			else
				failure(failureMsg)
				return null
		
		else
			console.log("#{failureMsg} Not Connected")
	
	
	scormSet = (name, parameter, value, force = false)->
		failureMsg = "API.#{name}(#{parameter}, #{value}) failed:"
		
		if connected or force
			result = String(scormAPI[name](parameter, value))
			if setSucceeded(result)
				return true
			else
				failure(failureMsg)
				return false

		else
			console.log("#{failureMsg} Not Connected")
		
		
	getSucceeded = (value)->
		hasValue = value isnt ""
		noError = parseInt(scormAPI.GetLastError(), 10) is 0
		return hasValue or noError
	
	
	setSucceeded = (value)->
		switch typeof value
			when "object", "string" then (/(true|1)/i).test(value)
			when "number" then Boolean(value)
			when "boolean" then value
			else false
	
	
	failure = (message)->
		errorCode = parseInt(scormAPI.GetLastError(), 10)
		errorString = scormAPI.GetErrorString(String(errorCode))
		diagnostics = scormAPI.GetDiagnostic(String(errorCode))
		console.log(message)
		console.log("  Code: #{errorCode}")
		console.log("  Message: #{errorString}")
		console.log("  Diagnostics: #{diagnostics}")

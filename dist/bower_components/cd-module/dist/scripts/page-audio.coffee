# Page Audio
# Loads and plays audio corresponding to the current page whenever the page changes.
# Exposes an API for enabling/disabling/toggling audio, and being notified of changer.
# Audio is disabled by default.
# None of this works in IE, or iOS / Android

Take ["PageScrollWatcher"], (PageScrollWatcher)->
	audioEnabled = false
	updateListeners = []
	currentPageName = null
	requestPending = false
	context = null
	source = null
	
	request = new XMLHttpRequest()
	request.addEventListener "load", ()->
		requestPending = false
		context.decodeAudioData request.response, setBuffer, decodeFailure
	
	
	Make "PageAudio", PageAudio =
		
		onUpdate: (listener)->
			updateListeners.push(listener)
			listener(audioEnabled)
		
		toggle: ()->
			if audioEnabled then PageAudio.disable() else PageAudio.enable()
		
		enable: ()->
			unless audioEnabled
				audioEnabled = true
				context ?= new (window.AudioContext || window.webkitAudioContext)()
				loadAudioForCurrentPage()
				update()
		
		disable: ()->
			if audioEnabled
				audioEnabled = false
				request.abort() if requestPending
				stopAudio()
				update()
	
	
	PageScrollWatcher.onPageChange (page)->
		currentPageName = page.id
		loadAudioForCurrentPage()
	
	
	loadAudioForCurrentPage = ()->
		if currentPageName? and audioEnabled
			request.abort() if requestPending
			request.open("GET", "audio/#{currentPageName}.mp3", true)
			request.responseType = "arraybuffer" # Must set this AFTER opening the request, or FF breaks
			requestPending = true
			request.send()
	
	
	setBuffer = (buffer)->
		stopAudio()
		source = context.createBufferSource()
		source.connect context.destination
		source.buffer = buffer
		source.start 0
	
	
	decodeFailure = (e)->
		console.log("Error decoding audio data", e)
	
	
	stopAudio = ()->
		try source.stop 0 if source?
	
	
	update = ()->
		for listener in updateListeners
			listener(audioEnabled)

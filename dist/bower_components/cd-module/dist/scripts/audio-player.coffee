# None of this works in IE, or iOS / Android

do ()->
	audioEnabled = false
	currentPageName = null
	requestPending = false
	context = new (@AudioContext || @webkitAudioContext)()
	source = null
	
	# @addEventListener "click", ()->
	# 	@dispatchEvent new CustomEvent(if audioEnabled then "disableAudio" else "enableAudio")
			
	request = new XMLHttpRequest()
	request.responseType = "arraybuffer"
	request.addEventListener "load", ()->
		requestPending = false
		context.decodeAudioData request.response, setBuffer, decodeFailure
	
	@addEventListener "disableAudio", (e)->
		if audioEnabled
			audioEnabled = false
			request.abort() if requestPending
			source.stop 0 if source?
	
	@addEventListener "enableAudio", (e)->
		unless audioEnabled
			audioEnabled = true
			loadAudioForCurrentPage()
	
	@addEventListener "pageChange", (e)->
		currentPageName = e.detail.page.id
		loadAudioForCurrentPage()
	
	loadAudioForCurrentPage = ()->
		if currentPageName? and audioEnabled
			request.abort() if requestPending
			request.open "GET", "audio/#{currentPageName}.mp3", true
			requestPending = true
			request.send()
	
	setBuffer = (buffer)->
		stopAudio()
		source = context.createBufferSource()
		source.connect context.destination
		source.buffer = buffer
		source.start 0
	
	decodeFailure = (e)->
		"Error with decoding audio data" + e.err
	
	stopAudio = ()->
		try source.stop 0 if source?

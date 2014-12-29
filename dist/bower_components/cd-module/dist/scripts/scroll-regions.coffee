# This might be broken. Ivan just hastily converted it to Take/Make. Someone needs to review and test it.


Take "load", ()->
	scrollAreas = []


# SETUP
	
	scrollStarts = document.querySelectorAll('[scrollStart]')
	scrollEnds = document.querySelectorAll('[scrollEnd]')
	
	for scrollStart in scrollStarts
		scrollGroup = scrollStart.getAttribute('scrollStart')
		for scrollEnd in scrollEnds
			scrollEndGroup = scrollEnd.getAttribute('scrollEnd')
			if scrollGroup is scrollEndGroup
				scrollAreas.push
					start: scrollStart
					stop: scrollEnd


# EVENT HANDLERS

	handleScrollAreas = ()->
		scrollTop = document.body.scrollTop
		for scrollArea in scrollAreas
			scrollAreaTop = scrollArea.start.offsetTop
			scrollAreaBottom = scrollArea.stop.offsetTop
			if scrollTop > scrollAreaTop and scrollTop <= scrollAreaBottom
				value = (scrollTop - scrollAreaTop) / (scrollAreaBottom - scrollAreaTop)
				scrollArea.start.dispatchEvent new CustomEvent "scrollPercentage", detail:
					value: value
	
	
	handleScrollBody = ()->
		scrollAreaTop = document.body.offsetTop
		scrollAreaBottom = document.body.offsetTop + document.body.scrollHeight - document.body.offsetHeight
		scrollTop = document.body.scrollTop
		value = (scrollTop - scrollAreaTop) / (scrollAreaBottom - scrollAreaTop)
		event = new CustomEvent "scrollPercentage", detail:
			value: value
		document.body.dispatchEvent(event)
		
		
# EVENT LISTENERS
	
	window.addEventListener "scroll", handleScrollAreas
	window.addEventListener "scroll", handleScrollBody

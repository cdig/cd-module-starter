loadScrollRegions = ()->	
	scrollStarts =  document.querySelectorAll('[scrollStart]')
	scrollEnds = document.querySelectorAll('[scrollEnd]')

	scrollAreas = []
	for scrollStart in scrollStarts
		scrollVal = scrollStart.getAttribute('scrollStart')
		for scrollEnd in scrollEnds
			scrollValEnd = scrollEnd.getAttribute('scrollEnd')
			if scrollVal is scrollValEnd
				scrollAreas.push {start: scrollStart, stop: scrollEnd}
	console.log scrollAreas
	handleScrollAreas = ()->
		scrollTop = document.body.scrollTop
		for scrollArea in scrollAreas
			scrollAreaTop = scrollArea.start.offsetTop
			scrollAreaBottom = scrollArea.stop.offsetTop
			if scrollTop > scrollAreaTop and scrollTop <= scrollAreaBottom
				value = (scrollTop - scrollAreaTop) / (scrollAreaBottom - scrollAreaTop)
				event = new CustomEvent("scrollPercentage", {"detail":{"value":value}})
				scrollArea.start.dispatchEvent(event)
	
	handleScrollBody = ()->
		scrollAreaTop = document.body.offsetTop
		scrollAreaBottom = document.body.offsetTop + document.body.scrollHeight - document.body.offsetHeight
		scrollTop = document.body.scrollTop
		value = (scrollTop - scrollAreaTop) / (scrollAreaBottom - scrollAreaTop)
		event = new CustomEvent("scrollPercentage", {"detail":{"value":value}})
		document.body.dispatchEvent(event)
	window.addEventListener "scroll", handleScrollAreas
	window.addEventListener "scroll", handleScrollBody
window.addEventListener "load", loadScrollRegions
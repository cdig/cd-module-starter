# @codekit-prepend 'coffee/utilities.coffee'
loadSideBar = ()->
	pages =  document.querySelectorAll('[page]')
	navButtons = []
	elemDiv = document.createElement('div');
	elemDiv.className = "sidebar"
	
	for page in pages
		testFunc = (pag)=>
			pageNum = pag.getAttribute('page')
			newDiv = document.createElement('div');
			newDiv.className = "navButton"
			navButtons.push newDiv
			elemDiv.appendChild(newDiv)
			newDiv.onclick = ()=>
				element = document.querySelector('[page="' + pageNum + '"]')
				y = element.offsetTop
				console.log y
				scrollTo(document.body, document.body.scrollTop, y - document.body.scrollTop, 2000)
		testFunc(page)
	

	sidebarScroll = ()->
		for i in [0..pages.length-1]
			page = pages[i]
			navButton = navButtons[i]
			pageNum = page.getAttribute('page')
			element = document.querySelector('[page="' + pageNum + '"]')
			elTop = element.offsetTop
			elBottom = element.offsetTop + element.offsetHeight
			scrollOffset = window.pageYOffset + document.body.clientHeight / 2
			if scrollOffset > elTop and scrollOffset < elBottom
				navButton.style.background =  "red"
			else
				navButton.style.background = "blue"
		console.log "scrollin' " + window.pageYOffset

	scrollToAnimate =	(element, to, duration)=>
		if duration <= 0 
			console.log "we done2"
			return
		difference = to - element.scrollTop;
		perTick = difference / duration * 10;
		#easeFunc(timeDiff, @scale, 1.0 - @scale,  duration)
		setTimeout ()=>
			element.scrollTop = element.scrollTop + perTick;
			if element.scrollTop is to 
				console.log "we done"
				return
			scrollToAnimate(element, to, duration - 10)
		, 10
		
	scrollTo = (element, startHeight, heightDiff, duration)->
		startTime = null
		cTime = 0
		scrollFunc = (time)=>
			console.log "sup"
			if startTime is null
				startTime = time			
			cTime = time - startTime
			if cTime > duration
				cTime = duration
			height = easeInOutCubic cTime, startHeight, heightDiff, duration
			element.scrollTop = height
			if cTime < duration
				requestAnimationFrame scrollFunc
			#else
				#cancelAnimationFrame requestID
		requestID = requestAnimationFrame scrollFunc
			
	#elemDiv.style.cssText = 'position:absolute;width:100%;height:100%;opacity:0.3;z-index:100;background:#000;';
	document.body.appendChild(elemDiv)
	window.addEventListener "scroll", sidebarScroll, false
	sidebarScroll()

window.addEventListener "load", loadSideBar
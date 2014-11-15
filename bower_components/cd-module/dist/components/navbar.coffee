# Compatability Note:
# This code uses Element.classList, which is IE 10+
# This code uses CustomEvent, which is non-IE — polyfil: https://developer.mozilla.org/en/docs/Web/API/CustomEvent

do ()->
	
	PAGE_SELECTOR = "page"
	SCROLL_ANIMATION_SPEED = 500
	
	pages = null
	navbarButtons = []
	lastCurrentPageIndex = null
	
	
	@addEventListener "load", ()->
		setupPages()
		setupNavbar()
		setupScrolling()
	
	
	setupPages = ()->
		pages = document.querySelectorAll PAGE_SELECTOR
		
		
	setupNavbar = ()->
		navbar = document.createElement "div"
		navbar.classList.add "navbar"
		
		for page, pageIndex in pages
			navbarButton = makeNavbarButton page, pageIndex
			navbarButtons.push navbarButton
			navbar.appendChild navbarButton
			
		document.body.appendChild navbar

	
	makeNavbarButton = (page, pageIndex)->
		navbarButton = document.createElement "div"
		navbarButton.classList.add "pageButton"
		
		# Hack: Let's try using the page ID as a title
		navbarButton.textContent = page.id.replace /-/g, " "
		
		navbarButton.addEventListener "click", ()->
			scrollPosition = document.body.scrollTop
			pageTop = page.offsetTop
			
			# Hack: As a convention, the first child of a page has a fair bit of margin.
			# We'll take that margin into account when animating to a page.
			# childStyle = @getComputedStyle page.querySelector ":first-child"
			# marginString = childStyle.getPropertyValue "margin-top"
			# margin = parseInt marginString.split("px")[0]
			# contentTop = pageTop + margin/2 # Adjust the factor as needed
			
			scrollTo scrollPosition, pageTop - scrollPosition
		
		return navbarButton
	
	
	setupScrolling = ()->
		@addEventListener "scroll", updateScroll
		updateScroll()
	
	
	updateScroll = ()->
		
		# Loop through all the pages
		for page, pageIndex in pages
			
			# Check if this page is the current page
			if pageIsCurrent page
				
				# Check if this is a new current page
				if pageIndex isnt lastCurrentPageIndex
					newCurrentPage page, pageIndex
					
					# We're done here
					break
	
	
	pageIsCurrent = (page)->
		pageTop = page.offsetTop
		pageBottom = page.offsetTop + page.offsetHeight
		scrollOffset = @pageYOffset + document.body.clientHeight / 2
		return scrollOffset > pageTop and scrollOffset < pageBottom
	
	
	newCurrentPage = (page, pageIndex)->
		deactivateNavbarButton lastCurrentPageIndex if lastCurrentPageIndex?
		lastCurrentPageIndex = pageIndex
		dispatchPageChangeEvent page, pageIndex
		activateNavbarButton pageIndex

	
	activateNavbarButton = (index)->
		navbarButtons[index].classList.add "current"
	
	
	deactivateNavbarButton = (index)->
		navbarButtons[index].classList.remove "current"
	
	
	dispatchPageChangeEvent = (page, pageIndex)->
		@dispatchEvent new CustomEvent "pageChange",
			detail:
				page: page
				pageIndex: pageIndex
	
	
	easeInOutCubic = (t, b, c, d)->
		t /= d/2
		if (t < 1)
			return c/2*t*t*t + b
		else
			t -= 2
			return c/2*(t*t*t + 2) + b
	
	
	scrollTo = (startHeight, heightDiff)->
		return if heightDiff is 0
		
		startTime = null
		currentTime = 0
		duration = Math.sqrt Math.abs heightDiff * SCROLL_ANIMATION_SPEED
		
		animate = (systemTime)->
			startTime ?= systemTime
			currentTime = systemTime - startTime
			currentTime = duration if currentTime > duration
			height = easeInOutCubic currentTime, startHeight, heightDiff, duration
			document.body.scrollTop = height
			requestAnimationFrame animate if currentTime < duration
			
		requestAnimationFrame animate

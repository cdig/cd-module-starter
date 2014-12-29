# Scroll To
# Animate the scroll to the desired position


Take "Easing", (Easing)->
	SCROLL_ANIMATION_SPEED = 500
	
	Make "ScrollTo", (startHeight, heightDiff)->
		return if heightDiff is 0
		
		startTime = null
		currentTime = 0
		duration = Math.sqrt Math.abs heightDiff * SCROLL_ANIMATION_SPEED
		
		animate = (systemTime)->
			startTime ?= systemTime
			currentTime = systemTime - startTime
			currentTime = duration if currentTime > duration
			height = Easing.inOutCubic(currentTime, startHeight, heightDiff, duration)
			document.body.scrollTop = height
			requestAnimationFrame animate if currentTime < duration
			
		requestAnimationFrame animate

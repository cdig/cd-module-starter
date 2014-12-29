# Overlay
# This is unused, but saved for future use.

Take "load", ()->
	document.body.appendChild(overlay)
	overlay = document.createElement("editor-overlay")
	
	Make "Overlay",
		show: (target)->
			rect = target.getBoundingClientRect()
			overlay.style.top = (rect.top + document.body.scrollTop) + "px"
			overlay.style.left = rect.left + "px"
			overlay.style.width = target.offsetWidth + "px"
			overlay.style.height = target.offsetHeight + "px"
			overlay.style.display = "block"
		
		hide: ()->
			overlay.style.display = "none"
		

# Compat:
# IE10 — Transitions

Take "load", ()->
	
	main = document.createElement("cd-modal")
	popup = document.createElement("modal-popup")
	title = document.createElement("h1")
	content = document.createElement("p")
	buttons = document.createElement("modal-buttons")
	okayButton = document.createElement("okay-button")
	
	buttons.appendChild(okayButton)
	popup.appendChild(title)
	popup.appendChild(content)
	popup.appendChild(buttons)
	main.appendChild(popup)
	document.body.appendChild(main)
	
	
	do hide = ()->
		main.className = "hide"
		
	fadeOut = ()->
		main.className = "hiding"
		setTimeout(hide, 500) # There's no transitionend in IE9, so we do this crap
	
	
	okayButton.textContent = "Okay"
	okayButton.addEventListener("click", fadeOut)
	
	
	Make "ModalPopup",
	
		open: (givenTitle, givenContent, showButtons = true)->
			title.textContent = givenTitle
			
			if typeof givenContent is "string"
				content.textContent = givenContent
			else
				while content.hasChildNodes()
					content.removeChild(content.lastChild)
				content.appendChild(givenContent)
			
			main.className = "show"
			
			if showButtons
				buttons.style.visibility = null
			else
				buttons.style.visibility = "hidden"
		
		
		close: ()->
			fadeOut()

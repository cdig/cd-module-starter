Take "load", ()->
	
	main = document.querySelector(".browser-support")
	popup = document.querySelector(".support-popup")
	
	buttons = document.createElement("div")
	okayButton = document.createElement("div")
	
	buttons.className = "support-buttons"
	okayButton.textContent = "Okay"
	
	buttons.appendChild(okayButton)
	popup.appendChild(buttons)
	
	hide = ()->
		main.className = "browser-support hide"
	
	okayButton.addEventListener("click", hide)

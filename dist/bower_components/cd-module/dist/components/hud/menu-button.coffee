# Menu Button

Take ["cdHUD", "SaveWithPopup", "Params"], (cdHUD, SaveWithPopup, Params)->
	
	goToLauncher = ()->
		location.href = Params["launcher-url"]
	
	button = document.createElement("menu-button")
	button.textContent = "Menu"
	button.addEventListener "click", ()->
		SaveWithPopup (success)->
			if success
				setTimeout(goToLauncher, 500)
	
	cdHUD.addElement(button)

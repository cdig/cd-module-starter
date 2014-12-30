# HUD Container component
# The main container element for the HUD.
# Exposes an API for adding HUD elements.

Take "load", ()->
	
	hud = document.createElement("cd-hud")
	document.body.appendChild(hud)
	
	Make "cdHUD",
		addElement: (element)->
			hud.appendChild(element)

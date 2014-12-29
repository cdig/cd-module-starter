Take "load", ()->
	
	makeNestedLabel = (callOut)->
		label = document.createElement("call-out-label")
		label.innerHTML = callOut.innerHTML
		callOut.innerHTML = ""
		callOut.appendChild(label)
	
	show = (e)->
		e.currentTarget.setAttribute("open", true)
		e.currentTarget.setAttribute("seen", true)
	
	hide = (e)->
		e.currentTarget.removeAttribute("open")
	
	for callOut in document.querySelectorAll("call-out")
		callOut.addEventListener("mouseover", show)
		callOut.addEventListener("mouseout", hide)
		
		# We need the label to be nested for the CSS.
		# It's easiest to do this nesting with JS, rather than in the HTML.
		makeNestedLabel(callOut)

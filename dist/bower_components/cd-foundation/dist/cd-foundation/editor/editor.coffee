Take "load", ()->
	
# INITIALIZATION
	
	editableElements = document.querySelectorAll("[editable]")
	return unless editableElements.length
	
	setTimeout ()->
		setEvents("init")
	
	
# STATE
	target = null
	manipulatedElements = {}
	
	
# ELEMENTS
	outputField = document.createElement("textarea")
	outputContainer = document.createElement("editor-container")
	outputContainer.className = "selectable"
	outputContainer.appendChild(outputField)
	document.body.appendChild(outputContainer)
	
	hudButton = document.createElement("editor-button")
	hudButton.textContent = "Editor Output"
	hudButton.addEventListener "click", ()->
		outputContainer.classList.toggle("show")
	Take "cdHUD", (cdHUD)->
		cdHUD.addElement(hudButton)
	
	
# VECTORS
	
	vec =
		create: (x = 0, y = 0)->
			return { x:x, y:y }
		
		fromEventClient: (e)->
			return vec.create(e.clientX, e.clientY)
		
		add: (a, b)->
			return vec.create(a.x + b.x, a.y + b.y)
			
		subtract: (a, b)->
			return vec.create(a.x - b.x, a.y - b.y)
		
		scalarMultiply: (v, s)->
			return vec.create(v.x*s, v.y*s)
		
		scalarDivide: (v, s)->
			return vec.create(v.x/s, v.y/s)
	
	
# (ALMOST) PURE FUNCTIONS
	
	getContainingEditable = (elm)->
		if not elm?
			return null
		else if elm.matches("[editable]")
			return elm
		else if elm.parentElement?
			return getContainingEditable(elm.parentElement)
		else
			return null
	
	vecFromElementPos = (elm)->
		style = window.getComputedStyle(elm)
		left = parseInt(style.left)/100 * elm.offsetParent.offsetWidth
		left = 0 if isNaN(left)
		marginTop = parseInt(style.marginTop)
		return vec.create(left, marginTop)
	
	extractLastClass = (elm)->
		return "." + elm.className.split(" ").pop()
	
	computeCSSRules = ()->
		selectors = Object.keys(manipulatedElements).sort() # Alphabetical by class name
		rules = for selector in selectors
			elm = manipulatedElements[selector]
			left = styleValToNumWithPrecision(elm.style.left, 2)
			marginTop = styleValToNumWithPrecision(elm.style.marginTop, 2)
			toFormattedCSSRule(selector, left, marginTop)
		return rules.join("\n")
		
	styleValToNumWithPrecision = (n, p)->
		return parseFloat(n).toFixed(p).replace(/\0+$/, "").replace(/\.$/, "")
	
	toFormattedCSSRule = (selector, left, marginTop)->
		s = "#{selector} {\n"
		s += "\tleft: #{left}%;\n"
		s += "\tmargin-top: #{marginTop}%;\n"
		s += "}\n"
		return s

	
# MUTATION
	lastMousePos = null
	
	beginDrag = (mousePos)->
		disableCursor(true)
		lastMousePos = mousePos
		target.editorPos ?= vecFromElementPos(target)
		manipulatedElements[extractLastClass(target)] ?= target
	
	updateDrag = (mousePos)->
		deltaPos = vec.subtract(mousePos, lastMousePos)
		target.editorPos = vec.add(target.editorPos, deltaPos) # Mutation
		normalizedPos = vec.scalarDivide(target.editorPos, target.offsetParent.offsetWidth)
		percentPos = vec.scalarMultiply(normalizedPos, 100)
		applyPosToElement(percentPos, target)
		lastMousePos = mousePos
	
	endDrag = ()->
		disableCursor(false)
		updateField(computeCSSRules())
	
	applyPosToElement = (pos, elm)->
		elm.style.left = pos.x + "%"
		elm.style.marginTop = pos.y + "%"
	
	updateField = (value)->
		outputField.value = value
	
	disableCursor = (disable = true)->
		fn = if disable then "add" else "remove"
		document.body.classList[fn]("editor-dragging")
	
	
# EVENT HANDLING

	downHandler = (e)->
		target = getContainingEditable(e.target)
		return unless target?
		beginDrag(vec.fromEventClient(e))
		setEvents("down")
		e.preventDefault()

	dragHandler = (e)->
		updateDrag(vec.fromEventClient(e))
		e.preventDefault()
	
	dropHandler = (e)->
		endDrag()
		setEvents("drop")
		e.preventDefault()
	
	
# EVENT SWITCHING — An FSM would be wonderful right about now
	
	setEvents = (situation)->
		switch situation
			when "init"
				window.addEventListener("mousedown", downHandler)
			when "down"
				window.removeEventListener("mousedown", downHandler)
				window.addEventListener("mousemove", dragHandler)
				window.addEventListener("mouseup", dropHandler)
			when "drop"
				window.removeEventListener("mousemove", dragHandler)
				window.removeEventListener("mouseup", dropHandler)
				window.addEventListener("mousedown", downHandler)

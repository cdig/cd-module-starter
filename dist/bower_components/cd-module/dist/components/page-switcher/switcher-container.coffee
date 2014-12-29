# Page Switcher
# A hovering UI element that allows quick access to a specific page


Take ["PageManager", "SwitcherButton"], (PageManager, SwitcherButton)->
	
	switcherOpen = false
	
	switcher = document.createElement("page-switcher")
	switcher.className = "closed"
	
	switcherButtons = for page, pageIndex in PageManager.getPages()
		switcher.appendChild(SwitcherButton(page, pageIndex))
	
	Take "PageLocking", (PageLocking)->
		PageLocking.onUpdate ()->
			for page, pageIndex in PageManager.getPages()
				if page.classList.contains("locked")
					switcherButtons[pageIndex].classList.add("locked")
				else
					switcherButtons[pageIndex].classList.remove("locked")
	
	document.body.appendChild(switcher)
	
	
	Make "PageSwitcher", PageSwitcher =
		open: ()->
			enableOpen(true) unless switcherOpen
			
		close: ()->
			enableOpen(false) if switcherOpen
		
		toggle: ()->
			if switcherOpen then PageSwitcher.close() else PageSwitcher.open()
		
		setPosition: (x, y)->
			y += 10
			switcher.style.left = "#{x}px"
			switcher.style["padding-bottom"] = "#{y}px"
	
	
	enableOpen = (enable = true)->
		switcherOpen = enable
		switcher.className = if enable then "open" else "closed"
		
		if enable
			setTimeout ()->
				window.addEventListener "click", clickOutside = ()->
					window.removeEventListener "click", clickOutside
					enableOpen(false)

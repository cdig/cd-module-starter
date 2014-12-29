
Take ["cdHUD", "PageScrollWatcher", "PageTitle"], (cdHUD, PageScrollWatcher, PageTitle)->
	
	indicator = document.createElement("current-page-indicator")
	cdHUD.addElement(indicator)
	
	
	PageScrollWatcher.onPageChange (page)->
		indicator.textContent = PageTitle(page)
	
	
	Take "PageSwitcher", (PageSwitcher)->
		indicator.addEventListener "click", ()->
			PageSwitcher.toggle()
		
		updatePosition = ()->
			x = indicator.offsetLeft
			y = parseInt(window.getComputedStyle(indicator).height.split("px")[0]) # Hooo my god Hacks
			PageSwitcher.setPosition(x, y)
		
		window.addEventListener("resize", updatePosition)
		
		setTimeout ()->
			updatePosition()

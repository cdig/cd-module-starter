# Compatability:
#	pageYOffset is an IE-compatable version of scrollY

do ()->
	EVENTS =
		scroll: "scroll"
	
	pageChangeListeners = []
	
	
	Take "Pages", (pages)->
		setupScrollWatching(pages)
		
		Make "PageScrollWatcher",
			onPageChange: (listener)->
				pageChangeListeners.push(listener)
		
		
	setupScrollWatching = (pages)->
		prevPageIndex = null
		prevPage = null
		
		scrollHandlerFn = ()->
			for page, pageIndex in pages
				if pageIsCurrent(page)
					if pageIndex isnt prevPageIndex
						pageChange(page, pageIndex, prevPage, prevPageIndex)
						prevPageIndex = pageIndex
						prevPage = page
					return
		
		window.addEventListener(EVENTS.scroll, scrollHandlerFn)
		setTimeout(scrollHandlerFn)
	
	
	pageIsCurrent = (page)->
		pageTop = page.offsetTop
		pageBottom = page.offsetTop + page.offsetHeight
		scrollPosition = window.pageYOffset + document.body.clientHeight / 2
		return pageTop < scrollPosition and scrollPosition < pageBottom
	
	
	pageChange = (page, pageIndex, previousPage, previousPageIndex)->
		for callback in pageChangeListeners
			callback(page, pageIndex, previousPage, previousPageIndex)

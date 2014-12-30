# Page Manager
# A nice set of helpers for getting specific pages.
# Yeah, they're a touch redundant. Consider this an abstraction.

Take ["Pages", "MatchesSelector"], (pages, MatchesSelector)->
	
	Make "PageManager", PageManager =
		
		getPages: ()->
			return pages
		
		getPagesContainingSelector: (selector)->
			return pages.filter (page, index)->
				return page.querySelector(selector)?
		
		getPageContainingElement: (element)->
			if MatchesSelector(element, "cd-page")
				return element
			else if element.parentElement?
				return PageManager.getPageContainingElement(element.parentElement)
			else
				return null

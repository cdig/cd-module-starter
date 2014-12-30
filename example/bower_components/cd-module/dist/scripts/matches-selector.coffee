# Matches Selector
# A polyfill in 1 act.

Make "MatchesSelector", (page, selector)->
		return page.matches(selector) if page.matches?
		return page.msMatchesSelector(selector) if page.msMatchesSelector?
		throw new Error("No supported Element.matches() implementation.")

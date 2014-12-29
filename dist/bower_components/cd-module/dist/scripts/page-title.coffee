# Page Title
# Given a page, what title should we use for it?
# We isolate this logic here, so it's not scattered all over the system.
# Currently, we're generating a title based on the page's ID. This is a hack.

Make "PageTitle", (page)->
	return page.id.replace(/-/g, " ")

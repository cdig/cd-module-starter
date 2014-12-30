# Pages
# All the pages in the module

Take "load", ()->
	
	pagesNodeList = document.querySelectorAll("cd-page")
	pages = Array.prototype.slice.call(pagesNodeList)
	Object.freeze(pages)
	
	Make "Pages", pages

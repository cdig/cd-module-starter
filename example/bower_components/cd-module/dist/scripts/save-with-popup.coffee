# Save With Popup
# An asynchronous saving service with a nice UI.
# Call us, and we'll show a popup and attempt to save.
# Don't call us if you need synchronous saves!

Take ["KVStore", "ModalPopup"], (KVStore, ModalPopup)->
	
	saving = false
	callbacks = []
	
	
	runSave = ()->
		success = KVStore.save()
		
		if success
			ModalPopup.close()
		else
			ModalPopup.open("Saving Failed", "Check your internet connection and try again.")
		
		for callback in callbacks
			setTimeout ()-> # Don't call immediately, since they might want to retry saving or something
				callback(success)
		
		callbacks = []
		saving = false
		
	
	Make "SaveWithPopup", (callback)->
		callbacks.push(callback)
		
		if not saving
			saving = true
			ModalPopup.open("Saving", "Please do not close this page.", false)
			setTimeout(runSave, 500)

# Save Before Unload
# Make sure we attempt to save before closing the window.
# If the save fails, warn the user.
#
# We need to directly call the KVStore, not the Saving service, because we must be synchronous.

Take ["KVStore", "beforeunload"], (KVStore, event)->
	if KVStore.save()
		event.returnValue ?= "Saving changes failed. If you leave now, changes will be lost."

# KV Store
# Provides a simple get/set k/v interface, with a save() method to persist the underlying DB.


Take "Backend", (Backend)->
	hasUnsavedChanges = false
	db = Backend.getPersistedData() or {}
	
	Make "KVStore",
		set: (k, v)->
			hasUnsavedChanges = true
			return db[k] = v
		
		get: (k)->
			return db[k]
		
		save: ()->
			if hasUnsavedChanges
				if Backend.setPersistedData(db)
					hasUnsavedChanges = false
					return true
				else
					return false
			else
				return true

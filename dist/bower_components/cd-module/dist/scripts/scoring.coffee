# window.localStorage.clear()

Take ["PageManager", "KVStore", "Params"], (PageManager, KVStore, Params)->
	hasPoints = document.querySelector("cd-activity")?
	moduleTotalPoints = 0
	pointsToAward = 0
	projectNode = null
	chapterNode = null
	moduleNode = null
	updateCallbacks = []
	
	
	setTimeout ()->
		loadScoringTree()
		if hasPoints
			crawlActivityPoints()
			updateModuleScore()
			saveScoringTree()
			runCallbacks()
		makeAPI()
	

# PUBLIC
	
	makeAPI = ()->
		Make "Scoring",
			addPoints: (id, percent = 0, exact = 0)->
				throw new Error("You must add a points attribute to your activity: #{id}") unless hasPoints
				
				activityNode = moduleNode.activities[id]
				scoreBefore = activityNode.score
				
				scoreToAward = percent + (exact / activityNode.points)
				
				activityNode.score ?= 0
				activityNode.score += scoreToAward
				activityNode.score = Math.min(activityNode.score, 1)
				activityNode.score = Math.round(activityNode.score * 1000)/1000 # Helps avoid rounding errors
				
				pointsToAward = (activityNode.score - scoreBefore) * activityNode.points
				
				updateModuleScore()
				saveScoringTree()
				runCallbacks()
			
			getActivityScore: (id)->
				return moduleNode.activities[id].score
			
			getModulePoints: ()->
				return moduleTotalPoints
			
			getModuleScore: ()->
				return moduleNode.score
			
			onUpdate: (callback)->
				updateCallbacks.push(callback)
		
		

# SETUP
	
	loadScoringTree = ()->
		projectNode = KVStore.get(Params.project) or createNodeWith("chapters")
		chapterNode = projectNode.chapters[Params.chapter] ?= createNodeWith("modules")
		moduleNode = chapterNode.modules[Params.module] ?= createNodeWith("activities")
		
	
	createNodeWith = (groupName)->
		node = {}
		node.score = 0
		node[groupName] = {}
		return node


	crawlActivityPoints = ()->
		moduleTotalPoints = 0
		for activity in document.querySelectorAll("cd-activity")
			name = activity.id
			points = parseInt(activity.getAttribute("points"))
			moduleNode.activities[name] ?= {}
			moduleNode.activities[name].score ?= 0
			moduleNode.activities[name].points = points # Always overwrite
			moduleTotalPoints += points


# INTERNAL
	
	updateModuleScore = ()->
		earnedPoints = 0
		for name, activityNode of moduleNode.activities
			earnedPoints += activityNode.score * activityNode.points
		moduleNode.score = earnedPoints / moduleTotalPoints
	
	
	saveScoringTree = ()->
		KVStore.set(Params.project, projectNode)
		KVStore.save() # DEBUG
	
	runCallbacks = ()->
		call(moduleNode.score, pointsToAward) for call in updateCallbacks


# Map scoring events into the Scoring system

Take "Scoring", (Scoring)->
	window.addEventListener "cdAwardPoints", (e)->
		id = e.detail.id
		percent = e.detail.percent
		exact = e.detail.exact
		throw new Error("Activity events must provide an id.") unless id?
		throw new Error("Activity events must provide either a percent or exact: #{id}") unless percent? or exact?
		Scoring.addPoints(id, percent, exact)

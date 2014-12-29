do ()->
	SCALE = 1.5
	MAX_TRAVEL_TIME = 1.5 * SCALE # How long does it take to get to the score indicator
	MIN_TRAVEL_TIME = 1.0 * SCALE
	MAX_SCATTER_SPEED = 240 / SCALE # How quickly do the points spread out from their initial position
	MIN_SCATTER_SPEED = 180 / SCALE
	
	
	addVectors = (v0, v1)->
		return v =
			x: v0.x + v1.x
			y: v0.y + v1.y
	
	scalarMultiply = (vec, scalar)->
		return v =
			x: vec.x * scalar
			y: vec.y * scalar
	
	map = (input, inputMin, inputMax, outputMin, outputMax, clip = true)->
		input = Math.max(Math.min(input, inputMax), inputMin) if clip
		input -= inputMin
		input /= inputMax - inputMin
		input *= outputMax - outputMin
		input += outputMin
		return input
		
	getRandomInRange = (max, min)->
		return Math.random() * (max - min) + min
	
	
	Make "Particle", class Particle
		element: null
		x: 0
		y: 0
		pos: 0
		scale: 0
		travelSpeed: 0.0
		scatterSpeed: 0.0
		scatterAngle: 0.0
		scatterForce: null
		scatterTrajectory: null
		target: null
		
		
		constructor: (@element)->
			@setInactive()
		
		setActive: (sX, sY)=>
			@pos = 0
			@x = sX
			@y = sY
			@scatterTrajectory = { x: sX, y: sY }
			
			@travelSpeed = 1 / getRandomInRange(MAX_TRAVEL_TIME, MIN_TRAVEL_TIME)
			@scatterSpeed = getRandomInRange(MAX_SCATTER_SPEED, MIN_SCATTER_SPEED)
			@scatterAngle = getRandomInRange(2 * Math.PI, 0)
			@scatterForce =
				x: Math.cos(@scatterAngle) * @scatterSpeed
				y: Math.sin(@scatterAngle) * @scatterSpeed
		
		
		setInactive: ()=>
			@x = -999
			@y = -999
			@scale = 0
			@draw()
		
			
		update: (dT, targetX, targetY)=>
			@pos += @travelSpeed * dT
			@pos = Math.min(@pos, 1)
			@scatterTrajectory = addVectors(@scatterTrajectory, scalarMultiply(@scatterForce, dT))
			@x = map(@pos*@pos, 0, 1, @scatterTrajectory.x, targetX)
			@y = map(@pos*@pos*@pos, 0, 1, @scatterTrajectory.y, targetY)
			@scale = Math.abs Math.sin @pos * Math.PI * 4
			return @pos >= 1
		
			
		draw: ()=>
			x = @x
			y = @y
			transString = "translate3d(#{@x}px, #{@y}px, 0px) scale(#{@scale})"
			@element.style.webkitTransform = transString
			@element.style.transform = transString

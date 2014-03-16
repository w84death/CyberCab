-- 
--	Krzysztof Jankowski
--	P 1 X  G A M E S
--	
--	p1x.in
--	@w84death
--	
--	CYBERPUNK JAM [01.03.2014]
--
module(..., package.seeall)

-- GLOBAL VIRABLES
-----------------------------------------------------------------------------------------




function newClient()
	local this = {}	
	this.client =	nil
	this.platform =	nil
	this.wating =	false
	this.waveing =	false
	this.waveDistance =	150
	this.player = 		nil
	this.destination = "A"
	this.isReady = 	false
	this.flip = 	false

	function this:init(params)
		local clientTypes = {'white','black'}
		this.platform = params.platform
		this.destination = params.destination		
		this.player = params.player

		local sheetData = { 
		width=14, height=28, 
		numFrames=12, 
		sheetContentWidth=56, 
		sheetContentHeight=84 }
 		
		local mySheet = graphics.newImageSheet( "media/gfx/clients/"..clientTypes[math.random(#clientTypes)]..".png", sheetData )
		 
		local cabAnimations = {
		    { name = "idle", frames={9,9,10},time=2000 },
		    { name = "wave", frames={11,12}, time=800 },
		    { name = "move", frames={ 1,2,3,4,5,6,7,8 }, time=400 }
		}
		 
		this.client = display.newSprite( mySheet, cabAnimations )

		local startPos = {}
		startPos.x = this.platform.platform.x - 10
		startPos.y = this.platform.platform.y-9
		if(this.platform.flip)then			
			startPos.x = this.platform.platform.x + 130
		end

		this.client.x, this.client.y = startPos.x,startPos.y
		this.client:setSequence( "move" )			
		this.client:play()

		this.client.name = 'client'
		this.client.destination = this.destination
		this.client.platform = this.platform
	
		this.platform.hasClient = true

		local function clientReady()
			this.client:setSequence( "idle" )			
			this.client:play()
			this.isReady = true
		end

		local moveTo = 25
		if(this.platform.flip)then			
			moveTo = -25
		else
			this.client.xScale = -1
			this.flip = true
		end
		transition.moveTo( this.client, {x=this.client.x+moveTo, time=900, onComplete=clientReady} )

		local function wave( event )
		 	this:animations()
		end
		this.client:addEventListener( "sprite", wave )
	end

	function this:animations()
		if(this.isReady)then
			local distance = math.sqrt((this.player.cab.x-this.client.x)^2+(this.player.cab.y-this.client.y)^2)
			if(distance < this.waveDistance and this.waveing == false)then
				this.client:setSequence( "wave" )
				this.client:play()
				this.waveing = true
			end
			if(distance >= this.waveDistance and this.waveing == true)then
				this.client:setSequence( "idle" )			
				this.client:play()
				this.waveing = false
			end
		end
	end

	function this:goToCab( params )
		this.player:activateDoors()
		this.player.hasClient = this
		this.client:setSequence( "move" )			
		this.client:play()
		function enterCab()
			this.client.platform = nil
			this.client.x, this.client.y = -666,-666						
			this.player:activateDoors()
			this.player.engine.on = true
		end		
		transition.moveTo( this.client, {x=this.player.cab.x, y=this.client.y, time=params.time, onComplete=enterCab} )
	end

	function this:exitCab( flip )
		this.isReady = false
		this.player.hasClient = false
		this.platform.hasClient = false
		this.client.x, this.client.y = this.player.cab.x,this.player.cab.y
		this.client:setSequence( "move" )			
		this.client:play()
		function goAway()
			this.client:removeSelf()
			this.client = nil
			this = nil			
		end		
		print(flip)
		local moveTo = -180
		if(flip)then			
			moveTo = 180				
			if(this.flip == false)then
				this.client.xScale = -1	
			end
		else
			if(this.flip)then
				this.client.xScale = 1	
			end			
		end
		transition.moveTo( this.client, {x=this.client.x+moveTo, time=4000, onComplete=goAway} )
		
	end

	return this
end

function newNPC()
	local this = {}	
	this.ai = {}
	this.ai.right = 0
	this.ai.left = 0
	this.ai.idle = 0
	this.flip = 	false

	function this:init(params)

		local sheetData = { 
		width=14, height=28, 
		numFrames=12, 
		sheetContentWidth=56, 
		sheetContentHeight=84 }
 		
		local mySheet = graphics.newImageSheet( "media/gfx/clients/"..clientTypes[math.random(#clientTypes)]..".png", sheetData )
		 
		local cabAnimations = {
		    { name = "idle", frames={9,9,10},time=2000 },
		    { name = "wave", frames={11,12}, time=800 },
		    { name = "move", frames={ 1,2,3,4,5,6,7,8 }, time=400 }
		}
		 
		this.client = display.newSprite( mySheet, cabAnimations )

		local startPos = {}
		startPos.x = this.platform.platform.x - 10
		startPos.y = this.platform.platform.y-9
		if(this.platform.flip)then			
			startPos.x = this.platform.platform.x + 130
		end

		this.client.x, this.client.y = startPos.x,startPos.y
		this.client:setSequence( "move" )			
		this.client:play()

		this.client.name = 'client'
		this.client.destination = this.destination
		this.client.platform = this.platform
	
		this.platform.hasClient = true

		local function clientReady()
			this.client:setSequence( "idle" )			
			this.client:play()
			this.isReady = true
		end

		local moveTo = 25
		if(this.platform.flip)then			
			moveTo = -25
		else
			this.client.xScale = -1
			this.flip = true
		end
		transition.moveTo( this.client, {x=this.client.x+moveTo, time=900, onComplete=clientReady} )

		local function wave( event )
		 	this:animations()
		end
		this.client:addEventListener( "sprite", wave )
	end

	function this:animations()
		if(this.isReady)then
			local distance = math.sqrt((this.player.cab.x-this.client.x)^2+(this.player.cab.y-this.client.y)^2)
			if(distance < this.waveDistance and this.waveing == false)then
				this.client:setSequence( "wave" )
				this.client:play()
				this.waveing = true
			end
			if(distance >= this.waveDistance and this.waveing == true)then
				this.client:setSequence( "idle" )			
				this.client:play()
				this.waveing = false
			end
		end
	end

	return this
end

